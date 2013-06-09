require 'formula'

class Qemu < Formula
  homepage 'http://www.qemu.org/'
  url 'http://wiki.qemu-project.org/download/qemu-1.5.0.tar.bz2'
  sha1 '52d1bd7f8627bb435b95b88ea005b71b9b1a0098'

  head 'git://git.qemu-project.org/qemu.git'

  depends_on 'pkg-config' => :build
  depends_on :libtool
  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'
  depends_on 'pixman'
  depends_on 'sdl' => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --enable-cocoa
      --disable-bsd-user
      --disable-guest-agent
    ]
    args << (build.with?('sdl') ? '--enable-sdl' : '--disable-sdl')
    ENV['LIBTOOL'] = 'glibtool'
    system "./configure", *args
    system "make install"
  end

  def patches
    # fixes lsi_soft_reset assertion
    DATA
  end
end

__END__
diff --git a/hw/scsi/lsi53c895a.c b/hw/scsi/lsi53c895a.c
index 22b8e98..6e22cc4 100644
--- a/hw/scsi/lsi53c895a.c
+++ b/hw/scsi/lsi53c895a.c
@@ -348,6 +348,7 @@ static void lsi_soft_reset(LSIState *s)
     s->sbc = 0;
     s->csbc = 0;
     s->sbr = 0;
+    qbus_reset_all(&s->bus.qbus);
     assert(QTAILQ_EMPTY(&s->queue));
     assert(!s->current);
 }

