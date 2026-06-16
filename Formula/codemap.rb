class Codemap < Formula
  desc "Deterministic code index for AI agents — token-cheap symbol-level navigation"
  homepage "https://github.com/nicolas-soares-gomes/codemap"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.1.0/codemap-aarch64-apple-darwin.tar.xz"
      sha256 "ff10b331dd0a1e39f19cbc78bfa24cc61ec046ba78a1c72de5182a7ee7e4de83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.1.0/codemap-x86_64-apple-darwin.tar.xz"
      sha256 "d6dcaab4d8bc1c5079de3e3438b91c056e9b98e6546da1bd1fdce639d737bb52"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.1.0/codemap-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1a1e309fa5e96629d4f75ac88fc0c95d9677bb5d612b88fae97a38b73162604f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.1.0/codemap-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4934af4fe0f931d1b5cdf2f96b7e744102907b8be1ba57a4ab62faae59c85236"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "codemap" if OS.mac? && Hardware::CPU.arm?
    bin.install "codemap" if OS.mac? && Hardware::CPU.intel?
    bin.install "codemap" if OS.linux? && Hardware::CPU.arm?
    bin.install "codemap" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
