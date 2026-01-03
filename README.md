# lsfr GitHub Action

_Build distributed systems from scratch._

A GitHub Action for testing [lsfr](https://lsfr.io) challenges in your CI/CD pipeline.

## Quick Start

Add this workflow to your repository at `.github/workflows/lsfr.yaml`:

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
      - uses: actions/checkout@v6
      - uses: st3v3nmw/lsfr-action@main
```

The action runs `lsfr test` on every push to main and on pull requests.

## Usage

For the full usage documentation, please see [this guide](https://lsfr.io/guides/ci-cd/#github-actions).
