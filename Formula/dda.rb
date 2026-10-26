class Dda < Formula
  desc "Scan a directory tree for dependency directories (node_modules, target, .venv, …) and report how much space they use."
  homepage "https://github.com/hco/dependency-dir-analyzer"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.3.0/dependency-dir-analyzer-aarch64-apple-darwin.tar.xz"
      sha256 "af847771ad3b3c7d78fb1925db89e220c2b561f87b4e8b6214d501905b9ee8ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.3.0/dependency-dir-analyzer-x86_64-apple-darwin.tar.xz"
      sha256 "8c3d4ae8356f2cbdf1549011e0048155be7dd4d07cf6e41dd2eaf01adbf6b25c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.3.0/dependency-dir-analyzer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "03bf04e11c963488c38e54eafb6ef8a7d30f57732591c00cf36cc1da2fa15dce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.3.0/dependency-dir-analyzer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c7240c06437189787e5c53211b37773e459b6a1fe40dbf6e537192b4240772a3"
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
