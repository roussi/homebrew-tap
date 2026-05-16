class Guardep < Formula
  desc "Package-manager firewall: blocks risky npm/pnpm/yarn/mvn installs before postinstall runs"
  homepage "https://github.com/roussi/guardep"
  license "MIT"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/roussi/guardep/releases/download/v0.1.0/guardep-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "6f3ba2423abaf3d60af1ec922c9b08fb5ded86d38f79f4ca4b5d3d6187f2a28c"
    end
    # Intel macOS not shipped in this release; users on Rosetta 2
    # transparently run the aarch64 binary. Native support returns
    # once GitHub-hosted Intel runners stabilise.
  end

  on_linux do
    on_arm do
      url "https://github.com/roussi/guardep/releases/download/v0.1.0/guardep-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "456710d4482bf0a59b6a4b70b17ecb262e121d0166cae7504db4ccfde6169d82"
    end
    on_intel do
      url "https://github.com/roussi/guardep/releases/download/v0.1.0/guardep-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d9b676f67e1ad616a3fe93fe0edcc7f8144470034018b50d47f24f543f35d95d"
    end
  end

  def install
    # Homebrew strips the top-level `guardep-<ver>-<target>/` dir
    # because it starts with the formula name. Binary lands at the
    # buildpath root.
    bin.install "guardep"
  end

  def caveats
    <<~EOC
      To enforce the package-manager firewall locally:

        guardep install-shims

      This wires npm/pnpm/yarn/mvn through guardep via PATH shims placed in
      ~/.guardep/bin. Reverse with `guardep uninstall-shims`.
    EOC
  end

  test do
    assert_match "guardep 0.1.0", shell_output("#{bin}/guardep --version")
    (testpath/"empty").mkpath
    system bin/"guardep", "audit", "--path", testpath/"empty", "--fail-on", "never"
  end
end
