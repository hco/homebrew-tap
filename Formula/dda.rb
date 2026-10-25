class Dda < Formula
  desc "Scan a directory tree for dependency directories (node_modules, target, .venv, …) and report how much space they use."
  homepage "https://github.com/hco/dependency-dir-analyzer"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.2.0/dependency-dir-analyzer-aarch64-apple-darwin.tar.xz"
      sha256 "4909658d926908d57052a6d97231237d2b4ccee819e541248dd3d34f21688a37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.2.0/dependency-dir-analyzer-x86_64-apple-darwin.tar.xz"
      sha256 "382a748817f7c14490eace07d62027ed9661a0d0f9a438b96a29c6e280e4e296"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.2.0/dependency-dir-analyzer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ee6c0a5969a932065037b8dacec132d7044428e1f21ec9dcbd07215e6566bafb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.2.0/dependency-dir-analyzer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dc5ead70e43d58760cbb042682fcf7ff18db5fa3a99692ead61a5447f29f66d5"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dda"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dda"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dda"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dda"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
