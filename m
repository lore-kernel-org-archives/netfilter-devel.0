From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] build: build only iptables-multi
Date: Sat, 25 Jul 2009 22:22:43 +0200
Message-ID: <1248553363-26903-6-git-send-email-jengelh@medozas.de>
References: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55094 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZGYUWu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:22:50 -0400
In-Reply-To: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I see no pressing reason to install all single programs when the
multi binary can do the job. Within the build directory, developers
can run the components by means of, for example,

	./ip6tables-multi {main|restore|save} ...

And when make install-ed, symlinks are available.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |   50 +++++++++++++-------------------------------------
 1 files changed, 13 insertions(+), 37 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index fc779e9..6bf40af 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -34,12 +34,6 @@ libxtables_la_CFLAGS  = ${AM_CFLAGS} -DNO_SHARED_LIBS=1
 libxtables_la_LIBADD  =
 endif
 
-# iptables, dynamic
-iptables_SOURCES          = iptables-standalone.c iptables.c xshared.c
-iptables_LDFLAGS          = -rdynamic
-iptables_LDADD            = libiptc/libip4tc.la extensions/libext4.a libxtables.la -lm
-
-iptables_xml_LDADD        = libxtables.la
 iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
                             iptables-restore.c iptables-xml.c \
                             iptables-standalone.c iptables.c xshared.c
@@ -47,23 +41,8 @@ iptables_multi_CFLAGS     = ${AM_CFLAGS} -DIPTABLES_MULTI
 if ENABLE_STATIC
 iptables_multi_CFLAGS    += -DALL_INCLUSIVE
 endif
-iptables_multi_LDFLAGS    = ${iptables_LDFLAGS}
-iptables_multi_LDADD      = ${iptables_LDADD}
-
-iptables_restore_SOURCES  = iptables-restore.c iptables.c xshared.c
-iptables_restore_LDFLAGS  = ${iptables_LDFLAGS}
-iptables_restore_LDADD    = ${iptables_LDADD}
-
-iptables_save_SOURCES     = iptables-save.c iptables.c xshared.c
-iptables_save_LDFLAGS     = ${iptables_LDFLAGS}
-iptables_save_LDADD       = ${iptables_LDADD}
-
-iptables_xml_SOURCES      = iptables-xml.c
-
-# ip6tables, dynamic
-ip6tables_SOURCES         = ip6tables-standalone.c ip6tables.c xshared.c
-ip6tables_LDFLAGS         = -rdynamic
-ip6tables_LDADD           = libiptc/libip6tc.la extensions/libext6.a libxtables.la -lm
+iptables_multi_LDFLAGS    = -rdynamic
+iptables_multi_LDADD      = libiptc/libip4tc.la extensions/libext4.a libxtables.la -lm
 
 ip6tables_multi_SOURCES   = ip6tables-multi.c ip6tables-save.c \
                             ip6tables-restore.c ip6tables-standalone.c \
@@ -72,30 +51,23 @@ ip6tables_multi_CFLAGS    = ${AM_CFLAGS} -DIPTABLES_MULTI
 if ENABLE_STATIC
 ip6tables_multi_CFLAGS   += -DALL_INCLUSIVE
 endif
-ip6tables_multi_LDFLAGS   = ${ip6tables_LDFLAGS}
-ip6tables_multi_LDADD     = ${ip6tables_LDADD}
-
-ip6tables_restore_SOURCES = ip6tables-restore.c ip6tables.c xshared.c
-ip6tables_restore_LDFLAGS = ${ip6tables_LDFLAGS}
-ip6tables_restore_LDADD   = ${ip6tables_LDADD}
-
-ip6tables_save_SOURCES    = ip6tables-save.c ip6tables.c xshared.c
-ip6tables_save_LDFLAGS    = ${ip6tables_LDFLAGS}
-ip6tables_save_LDADD      = ${ip6tables_LDADD}
+ip6tables_multi_LDFLAGS   = -rdynamic
+ip6tables_multi_LDADD     = libiptc/libip6tc.la extensions/libext6.a libxtables.la -lm
 
-bin_PROGRAMS     = iptables-xml
 sbin_PROGRAMS    =
-noinst_PROGRAMS  =
 man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    iptables-xml.8 ip6tables.8 ip6tables-restore.8 \
                    ip6tables-save.8
 CLEANFILES       = iptables.8 ip6tables.8
 
 if ENABLE_IPV4
-sbin_PROGRAMS += iptables iptables-multi iptables-restore iptables-save
+sbin_PROGRAMS += iptables-multi
+v4_bin_links   = iptables-xml
+v4_sbin_links  = iptables iptables-restore iptables-save
 endif
 if ENABLE_IPV6
-sbin_PROGRAMS += ip6tables ip6tables-multi ip6tables-restore ip6tables-save
+sbin_PROGRAMS += ip6tables-multi
+v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
 endif
 
 iptables.8: ${srcdir}/iptables.8.in extensions/matches4.man extensions/targets4.man
@@ -120,3 +92,7 @@ config.status: extensions/GNUmakefile.in \
 # Using if..fi avoids an ugly "error (ignored)" message :)
 install-exec-hook:
 	-if test -z "${DESTDIR}"; then /sbin/ldconfig; fi;
+	${INSTALL} -dm0755 "${DESTDIR}${bindir}";
+	for i in ${v4_bin_links}; do ${LN_S} -f "${sbindir}/iptables-multi" "${DESTDIR}${bindir}/$$i"; done;
+	for i in ${v4_sbin_links}; do ${LN_S} -f iptables-multi "${DESTDIR}${sbindir}/$$i"; done;
+	for i in ${v6_sbin_links}; do ${LN_S} -f ip6tables-multi "${DESTDIR}${sbindir}/$$i"; done;
-- 
1.6.3.3

