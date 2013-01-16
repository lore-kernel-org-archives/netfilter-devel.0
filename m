From: Cristian Iorga <cristian.iorga@intel.com>
Subject: [PATCH] iptables: extensions: fix iptables extensions build error    in cross-compilation environments
Date: Wed, 16 Jan 2013 21:07:35 +0200
Message-ID: <1358363255-30629-1-git-send-email-cristian.iorga@intel.com>
Cc: Cristian Iorga <cristian.iorga@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49807 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab3APTH1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2013 14:07:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libtool is properly declared and used for cross-platform
build environments

Signed-off-by: Cristian Iorga <cristian.iorga@intel.com>
---
 extensions/GNUmakefile.in |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index adad4d6..befb1fb 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -13,6 +13,7 @@ xtlibdir     = @xtlibdir@
 
 CC                 = @CC@
 CCLD               = ${CC}
+LIBTOOL            = @LIBTOOL@
 CFLAGS             = @CFLAGS@
 CPPFLAGS           = @CPPFLAGS@
 LDFLAGS            = @LDFLAGS@
@@ -94,10 +95,10 @@ lib%.so: lib%.la
 	${AM_VERBOSE_NULL} ln -fs .libs/$@ $@
 
 lib%.la: lib%.lo
-	${AM_VERBOSE_CCLD} ../libtool ${AM_LIBTOOL_SILENT} --tag=CC --mode=link ${CCLD} ${AM_LDFLAGS} -module ${LDFLAGS} -o $@ $< ../libxtables/libxtables.la ${$*_LIBADD} -rpath ${xtlibdir}
+	${AM_VERBOSE_CCLD} ${LIBTOOL} ${AM_LIBTOOL_SILENT} --tag=CC --mode=link ${CCLD} ${AM_LDFLAGS} -module ${LDFLAGS} -o $@ $< ../libxtables/libxtables.la ${$*_LIBADD} -rpath ${xtlibdir}
 
 lib%.lo: ${srcdir}/lib%.c
-	${AM_VERBOSE_CC} ../libtool ${AM_LIBTOOL_SILENT} --tag=CC --mode=compile ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init ${CFLAGS} -o $@ -c $<
+	${AM_VERBOSE_CC} ${LIBTOOL} ${AM_LIBTOOL_SILENT} --tag=CC --mode=compile ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init ${CFLAGS} -o $@ -c $<
 
 libxt_NOTRACK.so: libxt_CT.so
 	${AM_VERBOSE_GEN} ln -fs $< $@
-- 
1.7.10.4

