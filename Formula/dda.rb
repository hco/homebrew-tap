class Dda < Formula
  desc "Scan a directory tree for dependency directories (node_modules, target, .venv, …) and report how much space they use."
  homepage "https://github.com/hco/dependency-dir-analyzer"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.1.1/dependency-dir-analyzer-aarch64-apple-darwin.tar.xz"
      sha256 "b6cdbfb1ec2f4c4a1dccb141f5bacf5d21a45cb588e7401390032043cda5d5a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.1.1/dependency-dir-analyzer-x86_64-apple-darwin.tar.xz"
      sha256 "87e996496f665f0db509dcacafd881ff8e59f243d6632389a448764237b197d4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.1.1/dependency-dir-analyzer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f83ed283b0af3402b3cba5f9106d7327db506ea920ec754ac649f650a9e673b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hco/dependency-dir-analyzer/releases/download/v0.1.1/dependency-dir-analyzer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "660617b563f6f01aa346412f982027df022b9e3e29be086ece068bfe986d544a"
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
