
# Project 11. Bookworm

This is an app to track which books you’ve read and what you thought of them.

## Topics

- Core Data
- `@Binding` property wrapper
- `@FetchRequest` property wrapper

## Images

<p align="center"><img src="img/run-example.gif" height="600px"></p>

## Notes 

- `@Binding` lets us connect an `@State` property of one view to some underlying model data. It lets us create a mutable value in a view, that actually points to some other value from elsewhere.


- `AnyView` is a type-erased wrapper. It conforms to the `View` protocol and contains inside a view of a specific type. However, it doesn't expose what it contains, so SwiftUI only sees that it returns `AnyView`. This is where the name **type erasure** comes from: `AnyView` effectively hides – or erases – the type of the views it contains.

- Retrieving information from Core Data is done using a fetch request – we describe what we want, how it should sorted, and whether any filters should be used, and Core Data sends back all the matching data.

- When we place an object into the environment for a view, it becomes accessible to that view and any views that can call it an ancestor.