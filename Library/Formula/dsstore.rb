require 'formula'

class Dsstore < Formula
  homepage 'https://github.com/tommetge/dsstore'
  url 'https://github.com/tommetge/dsstore/archive/1.0.0.zip'
  sha1 '3fe6fc5800b468f56393ed454e385eb10e8270bc'

  head 'https://github.com/tommetge/dsstore.git', :branch => 'master'

  depends_on :xcode # For a working xcodebuild

  def install
    system "xcodebuild", "-project", "dsstore.xcodeproj",
                         "-target", "dsstore",
                         "-configuration", "release",
                         "clean", "install",
                         "SYMROOT=build",
                         "DSTROOT=build",
                         "INSTALL_PATH=/bin"
    bin.install "build/bin/dsstore"
  end

  test do
    system "#{bin}/dsstore"
  end
end
