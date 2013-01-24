From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/8] build: do not dereference symlinks on installation
Date: Thu, 24 Jan 2013 20:37:52 +0100
Message-ID: <1359056278-27618-3-git-send-email-jengelh@inai.de>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40469 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab3AXTiK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:38:10 -0500
In-Reply-To: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By using install(1), libxt_NOTRACK.so was inadvertently installed as
an actual file to /usr/lib/xtables rather than as a symlink. Switch to
using cp(1).

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/GNUmakefile.in |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index e520c86..15ede9f 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -52,9 +52,10 @@ pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
 pfx_lalibs    := $(patsubst %,libxt_%.la,${pfx_build_mod})
 pf4_lalibs    := $(patsubst %,libipt_%.la,${pf4_build_mod})
 pf6_lalibs    := $(patsubst %,libip6t_%.la,${pf6_build_mod})
-pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_symlinks})
+pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod})
 pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
 pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
+pfx_solinks   := $(patsubst %,libxt_%.so,${pfx_symlinks})
 
 
 #
@@ -65,9 +66,9 @@ targets_install :=
 @ENABLE_STATIC_TRUE@ libext_objs := ${pfx_objs}
 @ENABLE_STATIC_TRUE@ libext4_objs := ${pf4_objs}
 @ENABLE_STATIC_TRUE@ libext6_objs := ${pf6_objs}
-@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs} ${pfx_solinks}
 @ENABLE_STATIC_FALSE@ targets_la_install += ${pfx_lalibs} ${pf4_lalibs} ${pf6_lalibs}
-@ENABLE_STATIC_FALSE@ targets_so_install += ${pfx_solibs}
+@ENABLE_STATIC_FALSE@ targets_so_install += ${pfx_solinks}
 
 .SECONDARY:
 
@@ -79,7 +80,9 @@ install: ${targets_la_install} ${targets_so_install}
 	@mkdir -p "${DESTDIR}${xtlibdir}";
 	${AM_VERBOSE_NULL} ../libtool ${AM_LIBTOOL_SILENT} --mode=install install -pm0755 ${targets_la_install} "${DESTDIR}${xtlibdir}/"
 	rm -f "${DESTDIR}${xtlibdir}"/*.la;
-	install -pm0755 ${targets_so_install} "${DESTDIR}${xtlibdir}/"
+	# targets_so_install contains symlinks, and these should be preserved,
+	# so using install(1) is out of the question for them.
+	cp -a ${targets_so_install} "${DESTDIR}${xtlibdir}/"
 
 clean:
 	rm -f *.la *.o *.lo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
-- 
1.7.10.4

