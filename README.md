# TMFunctions.swift

This repository contains a utility class called `TMFunctions` and a custom view class called `TMCircularProgressView` that provide various functions and UI components for iOS development.

## Table of Contents

- [Introduction](#introduction)
- [Classes](#classes)
- [Functions](#functions)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

`TMFunctions` is a utility class written in Swift that offers convenient functions for tasks such as string manipulation, image conversion, toast message display, image preview, color conversion, shadow effect, and date formatting. These functions can be used in iOS projects to simplify common development tasks.

`TMCircularProgressView` is a custom view class that provides a circular progress indicator. It can be used to visualize the progress of a task or an operation in an iOS app.

## Classes

### TMFunctions
The `TMFunctions` class provides various utility functions.

### TMCircularProgressView
The `TMCircularProgressView` class provides a circular progress indicator.

## Functions

### stringNotEmpty
Checks if a given string is not empty.

### convertImageToBase64
Converts an image to its Base64 representation with the specified quality.

### showToast
Displays a toast message on the specified view with customizable options.

### presentImage
Presents a preview image view controller to display a tapped image.

### uicolor
Creates a UIColor instance from a hexadecimal string.

### applyShadow
Applies a shadow effect to the view.

### dateString
Converts a Date object to a string representation using the specified format.

## Usage
To use TMFunctions and TMCircularProgressView in your iOS project, follow these steps:

1. Add the TMFunctions.swift and TMCircularProgressView.swift files to your project.
2. Import the module where you want to use the classes: import TMFunctions.
3. Call the desired functions or create instances of TMCircularProgressView as needed.
4. Customize the function parameters or properties of TMCircularProgressView to suit your requirements.

## Contributing
Contributions to TMFunctions and TMCircularProgressView are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License
This project is licensed under the [MIT License](LICENSE).
