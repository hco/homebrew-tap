class Dda < Formula
  desc "Scan a directory tree for dependency directories (node_modules, target, .venv, …) and report how much space they use."
  homepage "https://github.com/hco/dependency-dir-analyzer"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.1.0/dependency-dir-analyzer-aarch64-apple-darwin.tar.xz"
      sha256 "3d3eebc9389e07eb07f356d6c41ff97a5f2c9ef84f44909c92eb21a80156a278"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.1.0/dependency-dir-analyzer-x86_64-apple-darwin.tar.xz"
      sha256 "71fe1a046663382050b6ba94429b798542d50b6ae55526a4de70fb57196c4d48"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.1.0/dependency-dir-analyzer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "da367be1b49916b26d9dd88189c450e8e92e0a92bb293a96ce59908e5c666c84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.1.0/dependency-dir-analyzer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ecec6b137e041ff759229b71871113826b8cdff511317344b052556ef05e32e0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "dda" if OS.mac? && Hardware::CPU.arm?
    bin.install "dda" if OS.mac? && Hardware::CPU.intel?
    bin.install "dda" if OS.linux? && Hardware::CPU.arm?
    bin.install "dda" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
