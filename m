From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/6] extensions: link on libxtables and check symbols
Date: Fri, 30 Dec 2011 02:35:00 +0100
Message-ID: <1325208902-2014-6-git-send-email-jengelh@medozas.de>
References: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40849 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1L3BfM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:35:12 -0500
In-Reply-To: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Have each extension link against libxtables.so; with this, all home
symbols are known at link time and we can use ld's --no-undefined to
run the check, dropping the homebrew solution.

By having libxtables.so required by extensions, package managers'
automatic dependency discovery will become effective so that manual
dependencies for distros with split extension packages (e.g. OpenWRT)
will not be necessary anymore.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac              |   10 ++++++++++
 extensions/GNUmakefile.in |   14 +++-----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/configure.ac b/configure.ac
index 5679098..0f85b83 100644
--- a/configure.ac
+++ b/configure.ac
@@ -58,6 +58,15 @@ AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
 	[libiptc_LDFLAGS2="-Wl,--no-as-needed"])
 AC_SUBST([libiptc_LDFLAGS2])
 
+AC_MSG_CHECKING([whether $LD knows -Wl,--no-undefined])
+saved_LDFLAGS="$LDFLAGS";
+LDFLAGS="-Wl,--no-undefined";
+AC_LINK_IFELSE([AC_LANG_SOURCE([int main(void) {}])],
+	[noundef_LDFLAGS="$LDFLAGS"; AC_MSG_RESULT([yes])],
+	[AC_MSG_RESULT([no])]
+)
+LDFLAGS="$saved_LDFLAGS";
+
 blacklist_modules="";
 
 AC_CHECK_HEADERS([linux/dccp.h linux/ip_vs.h linux/magic.h linux/proc_fs.h])
@@ -99,6 +108,7 @@ pkgdatadir='${datadir}/xtables';
 
 AC_SUBST([regular_CFLAGS])
 AC_SUBST([regular_CPPFLAGS])
+AC_SUBST([noundef_LDFLAGS])
 AC_SUBST([kinclude_CPPFLAGS])
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 84c85de..218dc3a 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -23,6 +23,7 @@ kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
 AM_CFLAGS       = ${regular_CFLAGS}
 AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS}
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
+AM_LDFLAGS      = @noundef_LDFLAGS@
 
 ifeq (${V},)
 AM_LIBTOOL_SILENT = --silent
@@ -68,16 +69,7 @@ targets_install :=
 
 .PHONY: all install clean distclean FORCE
 
-all: ${targets} check
-
-check: ${targets}
-	@echo "  CHECK    unknown symbols in .so files"; \
-	. ../libxtables/libxtables.la; \
-	for i in lib*.so; do \
-		[ "$$i" = "lib*.so" ] && continue; \
-		LD_PRELOAD="$$dlname" LD_LIBRARY_PATH=../libxtables/.libs \
-			ldd -r $$i 2>&1 >/dev/null; \
-	done;
+all: ${targets}
 
 install: ${targets_install}
 	@mkdir -p "${DESTDIR}${xtlibdir}";
@@ -99,7 +91,7 @@ init%.o: init%.c
 #	Shared libraries
 #
 lib%.so: lib%.oo
-	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< ${$*_LIBADD};
+	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD};
 
 lib%.oo: ${srcdir}/lib%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
-- 
1.7.3.4

