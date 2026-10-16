# immichframe-age

[ImmichFrame](https://github.com/immichFrame/ImmichFrame) with one addition: each person's age at the time the photo was taken is shown after their name, e.g. `John (7)`. People without a birthday in Immich show just their name.

This is a stop-gap until upstream PR [#681](https://github.com/immichFrame/ImmichFrame/pull/681) is merged. Unlike the PR, the feature here is always on, with no config option.

## How it works

`Dockerfile` clones upstream at the version in `VERSION`, applies `show-people-age.patch` (a single frontend file), rebuilds the frontend and copies it over `/app/wwwroot` in the official image of the same version. The .NET API is untouched.

Images are published to `ghcr.io/alangrainger/immichframe-age`, tagged with the upstream version (e.g. `v1.0.39.0`) and `latest`. Use it as a drop-in replacement for `ghcr.io/immichframe/immichframe` in your compose file; all configuration is identical.

## Updating to a new upstream release

Change the version in `VERSION` and push. The workflow builds and publishes the new image. If the build fails at `git apply`, upstream has changed `asset-info.svelte` and the patch needs refreshing.
