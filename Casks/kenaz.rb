# Cask for kameas-ai/homebrew-tap (spec 012 FR-7). Rendered by
# scripts/render-cask.sh in the optional homebrew job of
# .github/workflows/publish.yml, which substitutes 0.7.0,
# 1a17164e8336c5141a886d1b54cf1cdaca136d13eb1aa11285ce9ab761d7e09b and e31ca1fcccac085d50f83652faea9c9e04cf8f767e3c95c0885c3750f6d28839 from the candidate's verified
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

  version "0.7.0"
  sha256 arm:   "1a17164e8336c5141a886d1b54cf1cdaca136d13eb1aa11285ce9ab761d7e09b",
         intel: "e31ca1fcccac085d50f83652faea9c9e04cf8f767e3c95c0885c3750f6d28839"

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
  # desc and caveats are Kameas's approved listing text: use them exactly.
  # The first caveats line is for pre-releases (published with
  # skip_conformance). In the first release published without
  # skip_conformance, replace it with "Kenaz for Claude Code and Codex is in
  # early access." until GA.
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
