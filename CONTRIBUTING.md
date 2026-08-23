# Contributing to Ridy Driver App

Thank you for your interest in contributing to the Ridy Driver App! We welcome contributions from the community and are grateful for your support.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Features](#suggesting-features)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## Getting Started

### Prerequisites

- Flutter SDK 3.47.1 or higher
- Dart SDK 3.13.0 or higher
- Git
- A GitHub account
- Android Studio or Xcode (for mobile development)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:

```bash
git clone https://github.com/mo7amed4522/Driver-App.git
cd Driver-App
```

3. Add the upstream repository:

```bash
git remote add upstream https://github.com/mo7amed4522/Driver-App.git
```

4. Install dependencies:

```bash
flutter pub get
```

## Development Workflow

### Creating a Branch

Always create a new branch for your work:

```bash
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/` - New features
- `bugfix/` - Bug fixes
- `hotfix/` - Critical fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Adding or updating tests

### Keeping Your Fork Updated

Regularly sync your fork with the upstream repository:

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

## Coding Standards

### Dart/Flutter Guidelines

We follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and [Flutter Best Practices](https://flutter.dev/docs/development/best-practices).

#### Key Points:

1. **Use `dart format`** before committing:
   ```bash
   dart format .
   ```

2. **Follow naming conventions**:
   - Classes: `PascalCase`
   - Variables/Functions: `camelCase`
   - Constants: `lowerCamelCase`
   - Files: `snake_case.dart`

3. **Documentation**:
   - Add doc comments for public APIs
   - Use `///` for documentation comments
   - Include examples where helpful

4. **Code Organization**:
   - Keep files under 300 lines when possible
   - Separate concerns (UI, business logic, data)
   - Use proper folder structure

### Code Quality

- Run `flutter analyze` to check for issues:
  ```bash
  flutter analyze
  ```

- Ensure no warnings or errors before submitting

- Keep code DRY (Don't Repeat Yourself)

- Write self-documenting code with clear variable names

## Commit Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `ci`: CI/CD changes

### Examples

```bash
feat(auth): add biometric authentication

Implemented fingerprint and face recognition for faster login.
Supports both Android and iOS platforms.

Closes #123
```

```bash
fix(map): resolve marker not showing on iOS

The marker was not appearing due to incorrect coordinate conversion.
Fixed by adjusting the latitude/longitude calculation.

Fixes #456
```

## Pull Request Process

### Before Submitting

1. **Update your branch** with the latest main:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run all checks**:
   ```bash
   # Format code
   dart format .
   
   # Analyze code
   flutter analyze
   
   # Run tests
   flutter test
   
   # Build the app
   flutter build apk --debug
   ```

3. **Update documentation** if needed

4. **Add tests** for new features

### Submitting the Pull Request

1. Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. Go to the original repository on GitHub

3. Click "New Pull Request"

4. Select your fork and branch

5. Fill out the pull request template:
   - Clear title describing the change
   - Detailed description of what and why
   - Link to related issues
   - Screenshots/GIFs for UI changes
   - Checklist completion

6. Request review from maintainers

### PR Title Format

Follow the same format as commit messages:

```
feat(auth): add biometric authentication
fix(map): resolve marker display issue on iOS
docs: update README with new installation steps
```

### Review Process

- Maintainers will review your PR
- Address any feedback or requested changes
- Once approved, a maintainer will merge your PR
- Your contribution will be included in the next release

## Testing Guidelines

### Writing Tests

- Write unit tests for business logic
- Write widget tests for UI components
- Aim for at least 70% code coverage

### Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureName', () {
    test('should do something', () {
      // Arrange
      final input = 'test';
      
      // Act
      final result = someFunction(input);
      
      // Assert
      expect(result, equals('expected'));
    });
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

## Reporting Bugs

### Before Reporting

1. Check if the bug has already been reported in [Issues](https://github.com/mo7amed4522/Driver-App/issues)
2. Try to reproduce the bug in the latest version
3. Collect relevant information (logs, screenshots, device info)

### Bug Report Template

When reporting a bug, please include:

- **Description**: Clear description of the bug
- **Steps to Reproduce**: Detailed steps to reproduce the issue
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Screenshots**: If applicable
- **Environment**:
  - Flutter version: `flutter --version`
  - Device/OS: (e.g., Pixel 7 / Android 13)
  - App version: (e.g., 2.3.2)
- **Logs**: Relevant error logs or stack traces

## Suggesting Features

We welcome feature suggestions! Please:

1. Check if the feature has already been suggested
2. Open a new issue with the "feature request" label
3. Provide:
   - Clear description of the feature
   - Use case and benefits
   - Possible implementation approach
   - Mockups/wireframes if applicable

## Questions?

- Open a [Discussion](https://github.com/mo7amed4522/Driver-App/discussions)
- Contact the maintainers
- Join our community chat (if available)

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to Ridy Driver App! 🚗✨
