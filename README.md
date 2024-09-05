# DragToDismiss

`DragToDismiss` 是一个用于 iOS 应用的视图控制器拖动关闭手势库。用户可以通过拖动当前显示的视图来关闭它，并且带有平滑的转场动画效果。该项目包含自定义的手势处理与动画管理，支持简单易用的集成方式。

## 功能特性

- 支持通过拖动手势关闭视图控制器。
- 自定义的转场动画，用户体验更加平滑。
- 易于与现有的视图控制器集成。

## 项目结构

- **`DragToDismissController.swift`**:
  - 负责管理拖动关闭功能的视图控制器，整合了`DragToDismissGesture`和`DragToDismissTransition`。
  
- **`DragToDismissGesture.swift`**:
  - 实现拖动手势的识别和处理逻辑，根据手势的触摸位置和滑动距离来决定是否关闭视图。
  
- **`DragToDismissTransition.swift`**:
  - 负责视图控制器展示和关闭时的动画效果，包括手势交互时的过渡动画。
  
## 安装

### Swift Package Manager

你可以通过 Swift Package Manager 将 `DragToDismiss` 集成到你的项目中。 在 `Package.swift` 文件中添加如下依赖：

```swift
dependencies: [
    .package(url: "https://github.com/linhay/DragToDismiss", branch: "main")
]
```

## 示例代码

这是一个简单的示例，展示如何在视图控制器中设置 `DragToDismiss`：

```swift
let vc = PresentedViewController()
let dragToDismiss = DragToDismissController()
dragToDismiss.sourceView = button
dragToDismiss.add(content: vc)
present(dragToDismiss, animated: true, completion: nil)
```

## 许可协议

本项目基于 MIT 许可协议进行开源。详情请参阅 `LICENSE` 文件。

## 如何贡献

欢迎提交 issue 或 pull request 来为该项目做出贡献。期待你的参与！