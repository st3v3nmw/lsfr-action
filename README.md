# lsfr GitHub Action

_Build complex systems from scratch_

A GitHub Action for testing [lsfr](https://lsfr.io) challenges in your CI/CD pipeline.

## Quick Start

Add this workflow to your repository at `.github/workflows/lsfr.yml`:

```yaml
name: lsfr Tests

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: st3v3nmw/lsfr-action@main
```

The action runs `lsfr test` on every push to main and on pull requests.

## Usage

### Basic

```yaml
- uses: st3v3nmw/lsfr-action@main
```

### Custom Working Directory

If your `lsfr.yaml` isn't at the repository root:

```yaml
- uses: st3v3nmw/lsfr-action@main
  with:
    working-directory: './my-challenge'
```
