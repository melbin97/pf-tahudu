# Tahudu - Implementation notes

This document supplements the assignment **README** with how the project is structured, what was implemented, and where to find it in the codebase.

---

## Table of Contents

- [Architecture](#architecture)
- [Task mapping](#task-mapping)
- [Folder layout](#folder-layout)
- [Search screen state](#search-screen-state)
- [Networking & errors](#networking--errors)
- [Testing](#testing)
- [Out of scope & assumptions](#out-of-scope--assumptions)
- [Optional follow-ups](#optional-follow-ups)

---

## Architecture

* **Pattern:** MVVM on the Search screen — SwiftUI views (`SearchView`, `ListingCardView`, …) backed by `SearchViewModel` (`ObservableObject`, `@MainActor`).
* **Composition root:** `AppDependencies` wires production dependencies (`live()`) and preview-style helpers (`preview()`). `TahuduApp` uses `AppDependencies.live()` and passes services into `TahuduTabView` → `SearchView`.
* **Protocols:** Networking and storage are abstracted behind `ListingService`, `APIService`, and `StorageService` so the view model can be tested with mocks (`TahuduTests/Mocks/`).
* **URLs:** The listings JSON endpoint lives in `Configuration/AppEnvironment.swift` as `APIEndpoints.listingURL`; `ListingManager` passes it into `URLSessionAPIClient`.

---

## Task mapping

How the README tasks map to this implementation:

* **Task 1 — Search UI:** Toolbar (filter/sort print to console per spec), search field, scrolling list, card layout (tags, price, carousel assets, relative “Published …”, optional “Last contacted …”, contact buttons). See `Screens/Search/`, `Components/`, `Models/ListingResponse.swift`, `Extensions/`.
* **Task 2 — Fetch listings:** `URLSession` via `URLSessionAPIClient`, `JSONDecoder` with ISO-8601 dates, decoding into `Listing` / `ListingResponse`. See `Services/URLSessionAPIClient.swift`, `Services/ListingManager.swift`.
* **Task 3 — Favourites & filter:** Heart toggles favourites; IDs persisted with `UserDefaults` through `UserDefaultsStorage` / `StorageService`; star control filters to favourites only with clear on/off styling; empty states when there is no data or no favourites. See `SearchViewModel.swift`, `ListingCardView.swift`, `Screens/Search/Models/`.
* **Bonus — Settings:** `UITableViewController` refactored to data-driven sections/items (`SettingsItem`, `items(for:)`); `SettingsView` remains `UIViewControllerRepresentable` embedding the nav controller. See `Screens/Settings/`.

---

## Folder layout

App target — high-level map:

* **`Configuration/`** — App-wide constants (e.g. `APIEndpoints`).
* **`Dependencies/`** — `AppDependencies` and preview-oriented mocks used by SwiftUI previews.
* **`Services/`** — `URLSessionAPIClient`, `ListingManager`, `UserDefaultsStorage`, protocol definitions.
* **`Models/`** — Shared types such as `Listing` / `ListingResponse`.
* **`Screens/Search/`** — Search UI, view model, `EmptyState`, `ListingFilter`, components.
* **`Screens/Settings/`** — Settings UIKit + SwiftUI bridge.
* **`Components/`** — Reusable controls (e.g. `ClearableTextField`, `ContactButton`).
* **`Extensions/`** — Shared helpers (`Date`, `String`, `Image`, …).
* **`Preview Content/`** — Preview-only listing data (`Listing.mockList()`), etc.

---

## Search screen state

* `SearchViewModel` exposes `listings`, loading/error flags, `listingFilter`, and `favoriteIds`.
* `listViewState` is derived: loading → API error → non-empty list → empty states (no data vs no favourites when filters apply).
* `displayListings` applies the favourites-only filter client-side.

---

## Networking & errors

* HTTP status and non-JSON responses are handled in `URLSessionAPIClient`; decoding errors surface as a typed `NetworkError` with user-facing messages where appropriate.
* The view model uses a generic error UI for failures (`hasError` / empty state); detailed error kinds are not shown separately in the UI (acceptable scope for the exercise).

---

## Testing

* Unit tests live under `TahuduTests/Search/` with mocks for `APIService` and `StorageService`.
* Tests cover successful fetch, failure, favourites persistence, filter behaviour, and empty states.

