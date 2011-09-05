From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] libxt_statistic: link with -lm
Date: Mon,  5 Sep 2011 20:22:49 +0200
Message-ID: <1315246974-11538-2-git-send-email-jengelh@medozas.de>
References: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33341 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab1IESW6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:22:58 -0400
In-Reply-To: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
1.7.3.4

