From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/8] build: also use libtool for install stage
Date: Thu, 24 Jan 2013 20:37:51 +0100
Message-ID: <1359056278-27618-2-git-send-email-jengelh@inai.de>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40467 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab3AXTiJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:38:09 -0500
In-Reply-To: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The just-built library has DT_RPATH entries to be runnable from
whereever it is. If we just install that, the distro build systems
will throw warnings like

	(Open Build Service) ERROR: RPATH
	"/home/abuild/rpmbuild/BUILD/iptables-1.4.17a/libxtables/.libs"
	on /home/abuild/rpmbuild/BUILDROOT/iptables-1.4.17a-0.x86_64/usr/lib64/xtables/libxt_unclean.so
	is not allowed

These RPATH entries are indeed undesired for libraries is in a system
location, which is why libtool produces another copy of the library on
installation. The makefile however missed using libtool during
installation (introduced with commit v1.4.17-1-g68e77a2).
This patch now resolves this.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/GNUmakefile.in |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index adad4d6..e520c86 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -49,6 +49,9 @@ pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
 pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
 pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
 pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
+pfx_lalibs    := $(patsubst %,libxt_%.la,${pfx_build_mod})
+pf4_lalibs    := $(patsubst %,libipt_%.la,${pf4_build_mod})
+pf6_lalibs    := $(patsubst %,libip6t_%.la,${pf6_build_mod})
 pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_symlinks})
 pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
 pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
@@ -63,7 +66,8 @@ targets_install :=
 @ENABLE_STATIC_TRUE@ libext4_objs := ${pf4_objs}
 @ENABLE_STATIC_TRUE@ libext6_objs := ${pf6_objs}
 @ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
-@ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_STATIC_FALSE@ targets_la_install += ${pfx_lalibs} ${pf4_lalibs} ${pf6_lalibs}
+@ENABLE_STATIC_FALSE@ targets_so_install += ${pfx_solibs}
 
 .SECONDARY:
 
@@ -71,9 +75,11 @@ targets_install :=
 
 all: ${targets}
 
-install: ${targets_install}
+install: ${targets_la_install} ${targets_so_install}
 	@mkdir -p "${DESTDIR}${xtlibdir}";
-	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
+	${AM_VERBOSE_NULL} ../libtool ${AM_LIBTOOL_SILENT} --mode=install install -pm0755 ${targets_la_install} "${DESTDIR}${xtlibdir}/"
+	rm -f "${DESTDIR}${xtlibdir}"/*.la;
+	install -pm0755 ${targets_so_install} "${DESTDIR}${xtlibdir}/"
 
 clean:
 	rm -f *.la *.o *.lo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
@@ -94,7 +100,7 @@ lib%.so: lib%.la
 	${AM_VERBOSE_NULL} ln -fs .libs/$@ $@
 
 lib%.la: lib%.lo
-	${AM_VERBOSE_CCLD} ../libtool ${AM_LIBTOOL_SILENT} --tag=CC --mode=link ${CCLD} ${AM_LDFLAGS} -module ${LDFLAGS} -o $@ $< ../libxtables/libxtables.la ${$*_LIBADD} -rpath ${xtlibdir}
+	${AM_VERBOSE_CCLD} ../libtool ${AM_LIBTOOL_SILENT} --tag=CC --mode=link ${CCLD} ${AM_LDFLAGS} -avoid-version -module ${LDFLAGS} -o $@ $< ../libxtables/libxtables.la ${$*_LIBADD} -rpath ${xtlibdir}
 
 lib%.lo: ${srcdir}/lib%.c
 	${AM_VERBOSE_CC} ../libtool ${AM_LIBTOOL_SILENT} --tag=CC --mode=compile ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init ${CFLAGS} -o $@ -c $<
-- 
1.7.10.4

