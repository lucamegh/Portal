# Portal 🌀

`ContainerViewController` is a container view controller designed to display other view controllers.

```swift
import Portal

let loadingViewController = LoadingViewController(message: "Searching...")
let containerViewController = ContainerViewController(content: loadingViewController)
Cookbook.shared.search("spaghetti") { result in
    switch result {
        case .success([]):
            containerViewController.content = EmptyViewController()
        case .success(let recipes):
            containerViewController.content = RecipesViewController(recipes: recipes)
        case .failure(let error):
            containerViewController.content = ErrorViewController(error: error)
    }
}
```

## Installation

Portal is distributed using [Swift Package Manager](https://swift.org/package-manager). To install it into a project, simply add it as a dependency within your Package.swift manifest:
```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/lucamegh/Portal", from: "1.0.0")
    ],
    ...
)
```

## Usage

### Changing content

Set the `content` property to a view controller to display it:
```swift
containerViewController.content = PostViewController(post: post)
```

If you want to animate the view controller transition, simply call the `setViewController(_:animated:)` method. By default, container view controllers will transiton using a 'cross dissolve' animation.
```swift
let articleViewController = ...
containerViewController.setContent(articleViewController, animated: true)
```

### Custom transitions
To create a custom transiton, use the `ContainerViewControllerTransition.custom(animator:)` method. This method accepts an object conforming to the `UIViewControllerAnimatedTransitioning` protocol.

```swift
class SlideAnimator: NSObject, UIViewControllerAnimatedTransitioning { ... }

let slideAnimator = SlideAnimator(direction: .leftToRight)

containerViewController.transition = .custom(animator: slideAnimator)
```

If you're going to reuse a custom transiton across your project, you might find it useful to create a static factory method like this:

```swift
extension ContainerViewControllerTransition {

    static func slide(direction: SlideAnimator.Direction) -> Self {
        let slideAnimator = SlideAnimator(direction: direction)
        return custom(animator: slideAnimator)
    }
}

containerViewController.transition = .slide(direction: .leftToRight)
```

## Credits

This library was inspired by Dave DeLong's [A Better MVC](https://davedelong.com/blog/tags/a-better-mvc/) blog post series.
