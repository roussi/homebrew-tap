class Guardep < Formula
  desc "Package-manager firewall: blocks risky npm/pnpm/yarn/mvn installs before postinstall runs"
  homepage "https://github.com/roussi/guardep"
  license "MIT"
  version "0.2.0"

  on_macos do
    on_arm do
      url "https://github.com/roussi/guardep/releases/download/v0.2.0/guardep-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "20b048f79ab313dbb85dd2dbe02406ff4d08dc9bc8351cfb9a0ceaa2aba00eca"
    end
    on_intel do
      url "https://github.com/roussi/guardep/releases/download/v0.2.0/guardep-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "cb7aa7200a965158d28f6172b4715c8da465cd737c97c370c004c2d90ae0f04d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/roussi/guardep/releases/download/v0.2.0/guardep-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "df70a3d49a801e24a79499f00e6e0aa94735b3b8548f853179aea264fc7445d2"
    end
    on_intel do
      url "https://github.com/roussi/guardep/releases/download/v0.2.0/guardep-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a2d40430bf09020022f49db1e78bcda235b81375e08cbb77d7f9a6926de17781"
    end
  end

  def install
    # Tarball top-level dir is .
    # Homebrew strips it because the prefix matches the
    # formula name, so the binary lands at the buildpath
    # root.
    bin.install "guardep"
  end

  def caveats
    <<~EOC
      To enforce the package-manager firewall locally:

        guardep shims install

      This wires npm/pnpm/yarn/mvn/cargo through guardep via PATH shims placed in
      ~/.guardep/bin. Reverse with `guardep shims uninstall`.
    EOC
  end

  test do
    assert_match "guardep 0.2.0", shell_output("#{bin}/guardep --version")
    (testpath/"empty").mkpath
    system bin/"guardep", "audit", "--path", testpath/"empty", "--fail-on", "never"
  end
end
