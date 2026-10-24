# Cask for kameas-ai/homebrew-tap (spec 012 FR-7). Rendered by
# scripts/render-cask.sh in the optional homebrew job of
# .github/workflows/publish.yml, which substitutes 0.5.0,
# 51c1480681c5b47c43a728d6b07400512efb9a687862623ad2e16447ab41cf50 and 23585373eb44d64319cc603adf04535d0d77c4df57ab5b324771b7184ee75bfb from the candidate's verified
# checksums.txt and opens a PR on the tap. Archives are served from the
# download CDN. The executable is Developer ID signed + notarized (FR-4) and
# identical to every other channel's.
#
#   brew install kameas-ai/tap/kenaz
#
# A cask, not a formula: the binary is a prebuilt, notarized Mach-O, and a
# formula install may rewrite and ad-hoc re-sign Mach-O files. The `binary`
# stanza links bin/kenaz from the unpacked bundle into $(brew --prefix)/bin,
# which is on PATH.
cask "kenaz" do
  arch arm: "arm64", intel: "amd64"

  version "0.5.0"
  sha256 arm:   "51c1480681c5b47c43a728d6b07400512efb9a687862623ad2e16447ab41cf50",
         intel: "23585373eb44d64319cc603adf04535d0d77c4df57ab5b324771b7184ee75bfb"

  url "https://downloads.kameas.ai/kenaz-plugin/v#{version}/kenaz_#{version}_darwin_#{arch}.tar.gz"
  name "Kenaz"
  desc "Connects Claude Code and Codex to Kameas Fleet (Kenaz, a Kameas AI product)"
  homepage "https://kenaz.kameas.ai/"

  # The stable pointer of the download CDN names the current release.
  livecheck do
    url "https://downloads.kameas.ai/kenaz-plugin/manifest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: :monterey

  # The archive is the self-contained bundle: kenaz_<version>_darwin_<arch>/
  # holds bin/kenaz, the local plugin, licences and bundle.json.
  binary "kenaz_#{version}_darwin_#{arch}/bin/kenaz"

  # Licence files ship in the archive (licenses/LICENSE, LICENSE-APACHE,
  # NOTICE, THIRD_PARTY_NOTICES) and inside the binary: `kenaz licenses`.
  caveats <<~EOS
    Kenaz for Claude Code and Codex is in early access, and this is a pre-release.
    Official builds are licensed under the Kameas Client Software License:
    https://kenaz.kameas.ai/client-license (run `kenaz licenses` for open-source notices).
    Claude and Claude Code are trademarks of Anthropic, PBC. OpenAI and Codex are trademarks of OpenAI.
    Kenaz and Kameas are trademarks of Kameas AI, Inc. Kenaz for Claude Code and Codex is an independent
    product of Kameas AI, Inc. and is not affiliated with, endorsed or sponsored by Anthropic or OpenAI.

    Run: kenaz init
  EOS
end
