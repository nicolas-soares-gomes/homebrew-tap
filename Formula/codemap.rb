class Codemap < Formula
  desc "Deterministic code index for AI agents — token-cheap symbol-level navigation"
  homepage "https://github.com/nicolas-soares-gomes/codemap"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.2.1/codemap-aarch64-apple-darwin.tar.xz"
      sha256 "3251533cabc1a5084b6057c50125c7235aca49acb755c67d2e760f878b38293a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.2.1/codemap-x86_64-apple-darwin.tar.xz"
      sha256 "a87e0d5f830e8fe6caa8438e6246b1e78c651c630ae7a77f04e2b1c87859f32a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.2.1/codemap-aarch64-unknown-linux-musl.tar.xz"
      sha256 "3eb132f5172e87f47d73c3174cbb1fb09df63a169027ee5bed213bc939658929"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nicolas-soares-gomes/codemap/releases/download/v0.2.1/codemap-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ab6cb6a8016d9d06bea2653898f5ebc002668bb7a60f44765c0b4c5e935bd531"
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
