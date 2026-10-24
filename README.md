# kameas-ai/homebrew-tap

Homebrew tap for [Kenaz](https://kenaz.kameas.ai/) by Kameas AI, Inc.

```sh
brew install kameas-ai/tap/kenaz
kenaz init
```

Upgrade with `brew upgrade --cask kenaz`, remove with `brew uninstall --cask kenaz`.

`kenaz` is a cask: it installs the Developer ID signed and notarized macOS
build from `https://downloads.kameas.ai/kenaz-plugin/` (the same bytes as every
other channel, checked against the release's signed `checksums.txt`) and
links `kenaz` into `$(brew --prefix)/bin`. macOS 12 or later, Apple silicon
or Intel. On Linux, use `curl -fsSL https://downloads.kameas.ai/kenaz-plugin/install.sh | sh`
or the apt/dnf repositories.

Official builds are licensed under the Kameas Client Software License.
Claude and Claude Code are trademarks of Anthropic, PBC. OpenAI and Codex are
trademarks of OpenAI. Kenaz and Kameas are trademarks of Kameas AI, Inc. Kenaz
for Claude Code and Codex is an independent product of Kameas AI, Inc. and is
not affiliated with, endorsed or sponsored by Anthropic or OpenAI.

## How the cask is updated

Nobody edits `Casks/kenaz.rb` by hand. The private release pipeline
(`kameas-ai/kenaz-plugin-release`, `publish.yml`, channel `homebrew`)
renders the cask from a verified, signed release candidate and opens a pull
request `kenaz <version>` from branch `kenaz-<version>`. The tap's CI
(`.github/workflows/ci.yml`) runs `brew style`, `brew audit --cask --strict
--online`, a sha256 check of both architectures and a real install. The
pipeline never moves the tap backwards and never changes a released
version's cask.

## Repository settings (one-time, by an org owner)

1. Public repository `kameas-ai/homebrew-tap`, default branch `main`.
2. Copy `packaging/homebrew/tap-ci.yml` from kenaz-plugin-release to
   `.github/workflows/ci.yml`, and this file to `README.md`. Create an empty
   `Casks/` directory only through the first release PR.
3. A **ruleset** on `main` (not classic branch protection: the release
   pipeline checks the ruleset through `rules/branches/main` before it
   enables auto-merge): require a pull request (0 approvals, or auto-merge
   waits for one), require the status check **brew style, audit and
   install**, block force pushes. Squash merges only.
4. Settings, General: **Allow auto-merge** (needed only for
   `BREW_AUTO_MERGE=true`, below).
5. Install the release GitHub App (the one behind `RELEASE_APP_ID`) on this
   repository with **Contents: write** and **Pull requests: write**.
6. In kenaz-plugin-release, set the repository variable
   `ENABLE_BREW_PUBLISH=true`. Optionally `BREW_AUTO_MERGE=true`.

## Merging release PRs

- `BREW_AUTO_MERGE` unset (default): the release PR waits for a maintainer to
  review and merge it. Users get the new version only after that merge.
- `BREW_AUTO_MERGE=true` (recommended once step 3 and 4 are done): the
  pipeline confirms the ruleset requires "brew style, audit and install",
  then runs `gh pr merge --auto --squash`, so GitHub merges the PR as soon as
  that check passes, and never when it fails. Without the ruleset it does
  not enable auto-merge, and says so in the publish log. The cask's content
  already comes from a release that passed the publish gate and the `prod`
  environment approval, so a second manual approval adds little.
