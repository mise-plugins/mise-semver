# mise-semver

A [mise](https://mise.jdx.dev) plugin for [semver](https://github.com/fsaintjacques/semver-tool) - a semantic versioning command-line tool.

## Installation

```bash
mise plugin install semver https://github.com/mise-plugins/mise-semver
```

## Usage

```bash
# List all available versions
mise ls-remote semver

# Install a specific version
mise install semver@3.4.0

# Install latest version
mise install semver@latest

# Set as global default
mise use -g semver@3.4.0

# Set as project default
mise use semver@3.4.0
```

## About semver

semver is a bash utility to manipulate and validate semantic versions. It provides commands to:

- Compare versions
- Bump major/minor/patch versions
- Validate version strings
- Extract version components

For more information, see the [semver repository](https://github.com/fsaintjacques/semver-tool).

## License

This plugin is licensed under the MIT License. See [LICENSE](LICENSE) for details.

The semver tool itself is licensed under Apache 2.0.