class Codemap < Formula
  desc "Deterministic code index for AI agents — token-cheap symbol-level navigation"
  homepage "https://github.com/nicolas-soares-gomes/codemap"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.1.1/codemap-aarch64-apple-darwin.tar.xz"
      sha256 "8425e896bb946d8a0b94eb3415653e348129ca5df08b9a3a281b127e86ac78c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.1.1/codemap-x86_64-apple-darwin.tar.xz"
      sha256 "4b90797b1e833c4522cc870d92cce4696ebcfdd997e80545adc02cd11e05a51c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.1.1/codemap-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0528f63ba69ee1e52ae47b28ba9be28825b06dc479330938c7c730f6463a8aa4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.1.1/codemap-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f72b3fb8b35d0929a361b2b11e163b2025c24d3f5f7dfb5d8f849ad30bde852c"
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
