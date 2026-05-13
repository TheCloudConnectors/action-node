# action-node

A Dockerized GitHub Action that wraps the `yarn` CLI with a private npm
registry, AWS CLI, and [Aikido Safe Chain](https://github.com/AikidoSec/safe-chain)
supply-chain protection preinstalled.

## Usage

```yaml
- uses: TheCloudConnectors/action-node@v1.24
  with:
    cmd: install
  env:
    NPM_REGISTRY: registry.npmjs.org
    NPMRC: //registry.npmjs.org/:_authToken=${{ secrets.NPM_TOKEN }}
```

`cmd: install` runs `yarn install --frozen-lockfile`. Any other value is passed
through verbatim to `yarn` (e.g. `cmd: build`, `cmd: test`).

### Inputs

| Name  | Required | Description    |
| ----- | -------- | -------------- |
| `cmd` | yes      | Yarn command.  |

### Environment variables

| Name           | Default                | Description                                                                  |
| -------------- | ---------------------- | ---------------------------------------------------------------------------- |
| `NPM_REGISTRY` | `registry.npmjs.org`   | Registry written to `~/.npmrc` as the default for `yarn`/`npm`.              |
| `NPMRC`        | _(empty)_              | Extra lines appended to `~/.npmrc`, typically auth tokens.                   |
| `NPM_CONFIG`   | `$HOME/.npmrc`         | Path of the npmrc file to write. You usually don't need to change this.      |

## Node.js version

The Node major version is set by `ARG NODE_VERSION` at the top of the
[`Dockerfile`](./Dockerfile). Each release tag bakes in one Node version.
To move to a newer Node major:

1. Bump `ARG NODE_VERSION=` in the Dockerfile on `main`.
2. Build and verify:
   ```sh
   docker build -t action-node:test .
   docker run --rm --entrypoint node action-node:test -v
   ```
3. Cut a new release tag (e.g. `v1.25`).
4. Update consumers to pin the new tag.

## What's in the image

- Node.js (set by `ARG NODE_VERSION`)
- `yarn` (latest, force-installed via `npm i -g`)
- `awscli` 1.18.69
- `git`, `python3`, `build-base`, `libxml2`, `libxml2-utils`
- Aikido Safe Chain 1.4.9, configured with a 30-day minimum package age and
  an exclusion for the `@thecloudconnectors` scope
