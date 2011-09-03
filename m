From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables: libxt_statistic.so undefined symbol: lround
Date: Sat, 3 Sep 2011 14:07:29 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109031406430.26365@frira.zrqbmnf.qr>
References: <CAEik5nPmurYA8tysJ7+LRH-uM5Nx=Odr-YYwsrxUKGFivQu1BQ@mail.gmail.com> <CAEik5nN4W3W-51Zj=Yd-33uATD1TLZg0K4+N7RfWhKr7=78fRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Dan McGee <dan@archlinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33225 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab1ICMHd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Sep 2011 08:07:33 -0400
In-Reply-To: <CAEik5nN4W3W-51Zj=Yd-33uATD1TLZg0K4+N7RfWhKr7=78fRw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-09-02 15:51, Dan McGee wrote:

>Ping? Do I need to report this somewhere else? Not fixed in the just
>released 1.4.12.1.

After pondering how to go about this, I have now a patch for this, 
which should appear sooner (or later..) in the tree.

parent 2ca6273c73b42e8c74afd5f8b1fe10c5c93ce363 (v1.4.12-43-g2ca6273)
commit d4e72dc1c684c2f8361d87e6bde2902cd2ee8efb
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Sep 3 13:34:40 2011 +0200

libxt_statistic: link with -lm

$ ldd -r libxt_statistic.so
undefined symbol: lround        (./libxt_statistic.so)

References: https://bugs.archlinux.org/task/25358
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/GNUmakefile.in |    5 ++++-
 iptables/Makefile.am      |    9 +++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 2b48d84..dbf210c 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -90,11 +90,14 @@ init%.o: init%.c
 #	Shared libraries
 #
 lib%.so: lib%.oo
-	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $<;
+	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< ${$*_LIBADD};
 
 lib%.oo: ${srcdir}/lib%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
 
+# Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
+xt_statistic_LIBADD = -lm
+
 
 #
 #	Static bits
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index addb159..f6db32d 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -6,12 +6,17 @@ AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}
 lib_LTLIBRARIES       = libxtables.la
 libxtables_la_SOURCES = xtables.c xtoptions.c
 libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
+libxtables_la_LIBADD  =
+if ENABLE_STATIC
+# With --enable-static, shipped extensions are linked into the main executable,
+# so we need all the LIBADDs here too
+libxtables_la_LIBADD += -lm
+endif
 if ENABLE_SHARED
 libxtables_la_CFLAGS  = ${AM_CFLAGS}
-libxtables_la_LIBADD  = -ldl
+libxtables_la_LIBADD += -ldl
 else
 libxtables_la_CFLAGS  = ${AM_CFLAGS} -DNO_SHARED_LIBS=1
-libxtables_la_LIBADD  =
 endif
 
 xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
-- 
# Created with git-export-patch
