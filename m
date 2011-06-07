From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] Looks like the MTA ate this
Date: Tue, 7 Jun 2011 22:47:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106072246090.2450@frira.zrqbmnf.qr>
References: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56393 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab1FGUrT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:47:19 -0400
In-Reply-To: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

manual paste thus:

parent 5c8f5b60aa8e24da0bd25824f0f85bf7a4a39ea7 (v1.4.11-12-g5c8f5b6)
commit 033e25a3ad215ee3f5a07f0a3315f74c4abfaced
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jun 7 14:02:37 2011 +0200

src: move all iptables pieces into a separate directory

(Unclutter top-level dir)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore                                         |   14 ---
 Makefile.am                                        |   67 +-----------
 configure.ac                                       |    3 +-
 iptables/.gitignore                                |   14 +++
 iptables/Makefile.am                               |   67 ++++++++++++
 ip6tables-multi.h => iptables/ip6tables-multi.h    |    0
 .../ip6tables-restore.8                            |    0
 .../ip6tables-restore.c                            |    0
 ip6tables-save.8 => iptables/ip6tables-save.8      |    0
 ip6tables-save.c => iptables/ip6tables-save.c      |    0
 .../ip6tables-standalone.c                         |    0
 ip6tables.8.in => iptables/ip6tables.8.in          |    0
 ip6tables.c => iptables/ip6tables.c                |    0
 iptables-apply => iptables/iptables-apply          |    0
 iptables-apply.8 => iptables/iptables-apply.8      |    0
 iptables-multi.h => iptables/iptables-multi.h      |    0
 iptables-restore.8 => iptables/iptables-restore.8  |    0
 iptables-restore.c => iptables/iptables-restore.c  |    0
 iptables-save.8 => iptables/iptables-save.8        |    0
 iptables-save.c => iptables/iptables-save.c        |    0
 .../iptables-standalone.c                          |    0
 iptables-xml.1 => iptables/iptables-xml.1          |    0
 iptables-xml.c => iptables/iptables-xml.c          |    0
 iptables.8.in => iptables/iptables.8.in            |    0
 iptables.c => iptables/iptables.c                  |    0
 iptables.xslt => iptables/iptables.xslt            |    0
 xshared.c => iptables/xshared.c                    |    0
 xshared.h => iptables/xshared.h                    |    0
 xtables-multi.c => iptables/xtables-multi.c        |    0
 xtables-multi.h => iptables/xtables-multi.h        |    0
 xtables.c => iptables/xtables.c                    |    0
 xtables.pc.in => iptables/xtables.pc.in            |    0
 xtoptions.c => iptables/xtoptions.c                |    0
 33 files changed, 84 insertions(+), 81 deletions(-)
 create mode 100644 iptables/.gitignore
 create mode 100644 iptables/Makefile.am
 rename ip6tables-multi.h => iptables/ip6tables-multi.h (100%)
 rename ip6tables-restore.8 => iptables/ip6tables-restore.8 (100%)
 rename ip6tables-restore.c => iptables/ip6tables-restore.c (100%)
 rename ip6tables-save.8 => iptables/ip6tables-save.8 (100%)
 rename ip6tables-save.c => iptables/ip6tables-save.c (100%)
 rename ip6tables-standalone.c => iptables/ip6tables-standalone.c (100%)
 rename ip6tables.8.in => iptables/ip6tables.8.in (100%)
 rename ip6tables.c => iptables/ip6tables.c (100%)
 rename iptables-apply => iptables/iptables-apply (100%)
 rename iptables-apply.8 => iptables/iptables-apply.8 (100%)
 rename iptables-multi.h => iptables/iptables-multi.h (100%)
 rename iptables-restore.8 => iptables/iptables-restore.8 (100%)
 rename iptables-restore.c => iptables/iptables-restore.c (100%)
 rename iptables-save.8 => iptables/iptables-save.8 (100%)
 rename iptables-save.c => iptables/iptables-save.c (100%)
 rename iptables-standalone.c => iptables/iptables-standalone.c (100%)
 rename iptables-xml.1 => iptables/iptables-xml.1 (100%)
 rename iptables-xml.c => iptables/iptables-xml.c (100%)
 rename iptables.8.in => iptables/iptables.8.in (100%)
 rename iptables.c => iptables/iptables.c (100%)
 rename iptables.xslt => iptables/iptables.xslt (100%)
 rename xshared.c => iptables/xshared.c (100%)
 rename xshared.h => iptables/xshared.h (100%)
 rename xtables-multi.c => iptables/xtables-multi.c (100%)
 rename xtables-multi.h => iptables/xtables-multi.h (100%)
 rename xtables.c => iptables/xtables.c (100%)
 rename xtables.pc.in => iptables/xtables.pc.in (100%)
 rename xtoptions.c => iptables/xtoptions.c (100%)

diff --git a/.gitignore b/.gitignore
index fc68536..3e7def5 100644
--- a/.gitignore
+++ b/.gitignore
@@ -36,17 +36,3 @@ Makefile.in
 /ltmain.sh
 /missing
 /stamp-h1
-/xtables.pc
-
-/ip6tables
-/ip6tables.8
-/ip6tables-save
-/ip6tables-restore
-/ip6tables-static
-/iptables
-/iptables.8
-/iptables-save
-/iptables-restore
-/iptables-static
-/iptables-xml
-/xtables-multi
diff --git a/Makefile.am b/Makefile.am
index 02b5c09..34b3501 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,9 +3,7 @@
 ACLOCAL_AMFLAGS  = -I m4
 AUTOMAKE_OPTIONS = foreign subdir-objects
 
-AM_CFLAGS        = ${regular_CFLAGS}
-AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS}
-SUBDIRS          = extensions libiptc
+SUBDIRS          = extensions libiptc iptables
 if ENABLE_DEVEL
 SUBDIRS         += include
 endif
@@ -16,61 +14,6 @@ if HAVE_LIBNFNETLINK
 SUBDIRS         += utils
 endif
 
-lib_LTLIBRARIES       = libxtables.la
-libxtables_la_SOURCES = xtables.c xtoptions.c
-libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
-if ENABLE_SHARED
-libxtables_la_CFLAGS  = ${AM_CFLAGS}
-libxtables_la_LIBADD  = -ldl
-else
-libxtables_la_CFLAGS  = ${AM_CFLAGS} -DNO_SHARED_LIBS=1
-libxtables_la_LIBADD  =
-endif
-
-xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
-xtables_multi_CFLAGS   = ${AM_CFLAGS} -DIPTABLES_MULTI
-xtables_multi_LDFLAGS  = -rdynamic
-xtables_multi_LDADD    = extensions/libext.a
-if ENABLE_STATIC
-xtables_multi_CFLAGS  += -DALL_INCLUSIVE
-endif
-if ENABLE_IPV4
-xtables_multi_SOURCES += iptables-save.c iptables-restore.c \
-                         iptables-standalone.c iptables.c
-xtables_multi_CFLAGS  += -DENABLE_IPV4
-xtables_multi_LDADD   += libiptc/libip4tc.la extensions/libext4.a
-endif
-if ENABLE_IPV6
-xtables_multi_SOURCES += ip6tables-save.c ip6tables-restore.c \
-                          ip6tables-standalone.c ip6tables.c
-xtables_multi_CFLAGS  += -DENABLE_IPV6
-xtables_multi_LDADD   += libiptc/libip6tc.la extensions/libext6.a
-endif
-xtables_multi_SOURCES += xshared.c
-xtables_multi_LDADD   += libxtables.la -lm
-
-sbin_PROGRAMS    = xtables-multi
-man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
-                   iptables-xml.1 ip6tables.8 ip6tables-restore.8 \
-                   ip6tables-save.8
-CLEANFILES       = iptables.8 ip6tables.8
-
-vx_bin_links   = iptables-xml
-if ENABLE_IPV4
-v4_sbin_links  = iptables iptables-restore iptables-save
-endif
-if ENABLE_IPV6
-v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
-endif
-
-iptables.8: ${srcdir}/iptables.8.in extensions/matches4.man extensions/targets4.man
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches4.man' -e '/@TARGET@/ r extensions/targets4.man' $< >$@;
-
-ip6tables.8: ${srcdir}/ip6tables.8.in extensions/matches6.man extensions/targets6.man
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches6.man' -e '/@TARGET@/ r extensions/targets6.man' $< >$@;
-
-pkgconfig_DATA = xtables.pc
-
 .PHONY: tarball
 tarball:
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
@@ -81,11 +24,3 @@ tarball:
 
 config.status: extensions/GNUmakefile.in \
 	include/xtables.h.in include/iptables/internal.h.in
-
-# Using if..fi avoids an ugly "error (ignored)" message :)
-install-exec-hook:
-	-if test -z "${DESTDIR}"; then /sbin/ldconfig; fi;
-	${INSTALL} -dm0755 "${DESTDIR}${bindir}";
-	for i in ${vx_bin_links}; do ${LN_S} -f "${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
-	for i in ${v4_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
-	for i in ${v6_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
diff --git a/configure.ac b/configure.ac
index f3de3d3..4fba167 100644
--- a/configure.ac
+++ b/configure.ac
@@ -111,6 +111,7 @@ libxtables_vmajor=$(($libxtables_vcurrent - $libxtables_vage));
 AC_SUBST([libxtables_vmajor])
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
+	iptables/Makefile iptables/xtables.pc
 	libipq/Makefile libiptc/Makefile libiptc/libiptc.pc utils/Makefile
-	include/xtables.h include/iptables/internal.h xtables.pc])
+	include/xtables.h include/iptables/internal.h])
 AC_OUTPUT
diff --git a/iptables/.gitignore b/iptables/.gitignore
new file mode 100644
index 0000000..5a08937
--- /dev/null
+++ b/iptables/.gitignore
@@ -0,0 +1,14 @@
+/ip6tables
+/ip6tables.8
+/ip6tables-save
+/ip6tables-restore
+/ip6tables-static
+/iptables
+/iptables.8
+/iptables-save
+/iptables-restore
+/iptables-static
+/iptables-xml
+/xtables-multi
+
+/xtables.pc
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
new file mode 100644
index 0000000..13cca9c
--- /dev/null
+++ b/iptables/Makefile.am
@@ -0,0 +1,67 @@
+# -*- Makefile -*-
+
+AM_CFLAGS        = ${regular_CFLAGS}
+AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS}
+
+lib_LTLIBRARIES       = libxtables.la
+libxtables_la_SOURCES = xtables.c xtoptions.c
+libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
+if ENABLE_SHARED
+libxtables_la_CFLAGS  = ${AM_CFLAGS}
+libxtables_la_LIBADD  = -ldl
+else
+libxtables_la_CFLAGS  = ${AM_CFLAGS} -DNO_SHARED_LIBS=1
+libxtables_la_LIBADD  =
+endif
+
+xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
+xtables_multi_CFLAGS   = ${AM_CFLAGS} -DIPTABLES_MULTI
+xtables_multi_LDFLAGS  = -rdynamic
+xtables_multi_LDADD    = ../extensions/libext.a
+if ENABLE_STATIC
+xtables_multi_CFLAGS  += -DALL_INCLUSIVE
+endif
+if ENABLE_IPV4
+xtables_multi_SOURCES += iptables-save.c iptables-restore.c \
+                         iptables-standalone.c iptables.c
+xtables_multi_CFLAGS  += -DENABLE_IPV4
+xtables_multi_LDADD   += ../libiptc/libip4tc.la ../extensions/libext4.a
+endif
+if ENABLE_IPV6
+xtables_multi_SOURCES += ip6tables-save.c ip6tables-restore.c \
+                          ip6tables-standalone.c ip6tables.c
+xtables_multi_CFLAGS  += -DENABLE_IPV6
+xtables_multi_LDADD   += ../libiptc/libip6tc.la ../extensions/libext6.a
+endif
+xtables_multi_SOURCES += xshared.c
+xtables_multi_LDADD   += libxtables.la -lm
+
+sbin_PROGRAMS    = xtables-multi
+man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
+                   iptables-xml.1 ip6tables.8 ip6tables-restore.8 \
+                   ip6tables-save.8
+CLEANFILES       = iptables.8 ip6tables.8
+
+vx_bin_links   = iptables-xml
+if ENABLE_IPV4
+v4_sbin_links  = iptables iptables-restore iptables-save
+endif
+if ENABLE_IPV6
+v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
+endif
+
+iptables.8: ${srcdir}/iptables.8.in ../extensions/matches4.man ../extensions/targets4.man
+	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches4.man' -e '/@TARGET@/ r extensions/targets4.man' $< >$@;
+
+ip6tables.8: ${srcdir}/ip6tables.8.in ../extensions/matches6.man ../extensions/targets6.man
+	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches6.man' -e '/@TARGET@/ r extensions/targets6.man' $< >$@;
+
+pkgconfig_DATA = xtables.pc
+
+# Using if..fi avoids an ugly "error (ignored)" message :)
+install-exec-hook:
+	-if test -z "${DESTDIR}"; then /sbin/ldconfig; fi;
+	${INSTALL} -dm0755 "${DESTDIR}${bindir}";
+	for i in ${vx_bin_links}; do ${LN_S} -f "${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
+	for i in ${v4_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
+	for i in ${v6_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
diff --git a/ip6tables-multi.h b/iptables/ip6tables-multi.h
similarity index 100%
rename from ip6tables-multi.h
rename to iptables/ip6tables-multi.h
diff --git a/ip6tables-restore.8 b/iptables/ip6tables-restore.8
similarity index 100%
rename from ip6tables-restore.8
rename to iptables/ip6tables-restore.8
diff --git a/ip6tables-restore.c b/iptables/ip6tables-restore.c
similarity index 100%
rename from ip6tables-restore.c
rename to iptables/ip6tables-restore.c
diff --git a/ip6tables-save.8 b/iptables/ip6tables-save.8
similarity index 100%
rename from ip6tables-save.8
rename to iptables/ip6tables-save.8
diff --git a/ip6tables-save.c b/iptables/ip6tables-save.c
similarity index 100%
rename from ip6tables-save.c
rename to iptables/ip6tables-save.c
diff --git a/ip6tables-standalone.c b/iptables/ip6tables-standalone.c
similarity index 100%
rename from ip6tables-standalone.c
rename to iptables/ip6tables-standalone.c
diff --git a/ip6tables.8.in b/iptables/ip6tables.8.in
similarity index 100%
rename from ip6tables.8.in
rename to iptables/ip6tables.8.in
diff --git a/ip6tables.c b/iptables/ip6tables.c
similarity index 100%
rename from ip6tables.c
rename to iptables/ip6tables.c
diff --git a/iptables-apply b/iptables/iptables-apply
similarity index 100%
rename from iptables-apply
rename to iptables/iptables-apply
diff --git a/iptables-apply.8 b/iptables/iptables-apply.8
similarity index 100%
rename from iptables-apply.8
rename to iptables/iptables-apply.8
diff --git a/iptables-multi.h b/iptables/iptables-multi.h
similarity index 100%
rename from iptables-multi.h
rename to iptables/iptables-multi.h
diff --git a/iptables-restore.8 b/iptables/iptables-restore.8
similarity index 100%
rename from iptables-restore.8
rename to iptables/iptables-restore.8
diff --git a/iptables-restore.c b/iptables/iptables-restore.c
similarity index 100%
rename from iptables-restore.c
rename to iptables/iptables-restore.c
diff --git a/iptables-save.8 b/iptables/iptables-save.8
similarity index 100%
rename from iptables-save.8
rename to iptables/iptables-save.8
diff --git a/iptables-save.c b/iptables/iptables-save.c
similarity index 100%
rename from iptables-save.c
rename to iptables/iptables-save.c
diff --git a/iptables-standalone.c b/iptables/iptables-standalone.c
similarity index 100%
rename from iptables-standalone.c
rename to iptables/iptables-standalone.c
diff --git a/iptables-xml.1 b/iptables/iptables-xml.1
similarity index 100%
rename from iptables-xml.1
rename to iptables/iptables-xml.1
diff --git a/iptables-xml.c b/iptables/iptables-xml.c
similarity index 100%
rename from iptables-xml.c
rename to iptables/iptables-xml.c
diff --git a/iptables.8.in b/iptables/iptables.8.in
similarity index 100%
rename from iptables.8.in
rename to iptables/iptables.8.in
diff --git a/iptables.c b/iptables/iptables.c
similarity index 100%
rename from iptables.c
rename to iptables/iptables.c
diff --git a/iptables.xslt b/iptables/iptables.xslt
similarity index 100%
rename from iptables.xslt
rename to iptables/iptables.xslt
diff --git a/xshared.c b/iptables/xshared.c
similarity index 100%
rename from xshared.c
rename to iptables/xshared.c
diff --git a/xshared.h b/iptables/xshared.h
similarity index 100%
rename from xshared.h
rename to iptables/xshared.h
diff --git a/xtables-multi.c b/iptables/xtables-multi.c
similarity index 100%
rename from xtables-multi.c
rename to iptables/xtables-multi.c
diff --git a/xtables-multi.h b/iptables/xtables-multi.h
similarity index 100%
rename from xtables-multi.h
rename to iptables/xtables-multi.h
diff --git a/xtables.c b/iptables/xtables.c
similarity index 100%
rename from xtables.c
rename to iptables/xtables.c
diff --git a/xtables.pc.in b/iptables/xtables.pc.in
similarity index 100%
rename from xtables.pc.in
rename to iptables/xtables.pc.in
diff --git a/xtoptions.c b/iptables/xtoptions.c
similarity index 100%
rename from xtoptions.c
rename to iptables/xtoptions.c
-- 
# Created with git-export-patch
