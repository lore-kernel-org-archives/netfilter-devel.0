From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH] combine ip6?tables-multi into xtables-multi
Date: Tue,  5 Apr 2011 16:45:59 -0700
Message-ID: <1302047159-9976-1-git-send-email-zenczykowski@gmail.com>
References: <alpine.LNX.2.01.1104051151330.8800@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46064 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1DEXqU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:46:20 -0400
Received: by gwaa18 with SMTP id a18so186428gwa.19
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Apr 2011 16:46:19 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1104051151330.8800@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej Zenczykowski <maze@google.com>
---
 .gitignore        |    3 +--
 Makefile.am       |   46 +++++++++++++++++++++++----------------------=
-
 ip6tables-multi.c |   20 --------------------
 iptables-multi.c  |   22 ----------------------
 xtables-multi.c   |   39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 63 insertions(+), 67 deletions(-)
 delete mode 100644 ip6tables-multi.c
 delete mode 100644 iptables-multi.c
 create mode 100644 xtables-multi.c

diff --git a/.gitignore b/.gitignore
index e5d3099..377339d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -40,14 +40,13 @@ Makefile.in
=20
 /ip6tables
 /ip6tables.8
-/ip6tables-multi
 /ip6tables-save
 /ip6tables-restore
 /ip6tables-static
 /iptables
 /iptables.8
-/iptables-multi
 /iptables-save
 /iptables-restore
 /iptables-static
 /iptables-xml
+/xtables-multi
diff --git a/Makefile.am b/Makefile.am
index 866ac7e..7348a8a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -17,7 +17,7 @@ endif
 lib_LTLIBRARIES =3D
=20
 # libiptc
-lib_LTLIBRARIES           +=3D libiptc/libip4tc.la libiptc/libip6tc.la=
 libiptc/libiptc.la
+lib_LTLIBRARIES            +=3D libiptc/libip4tc.la libiptc/libip6tc.l=
a libiptc/libiptc.la
 libiptc_libiptc_la_SOURCES  =3D
 libiptc_libiptc_la_LIBADD   =3D libiptc/libip4tc.la libiptc/libip6tc.l=
a
 libiptc_libiptc_la_LDFLAGS  =3D -version-info 0:0:0 ${libiptc_LDFLAGS2=
}
@@ -37,39 +37,39 @@ libxtables_la_CFLAGS  =3D ${AM_CFLAGS} -DNO_SHARED_=
LIBS=3D1
 libxtables_la_LIBADD  =3D
 endif
=20
-iptables_multi_SOURCES    =3D iptables-multi.c iptables-save.c \
-                            iptables-restore.c iptables-xml.c \
-                            iptables-standalone.c iptables.c xshared.c
-iptables_multi_CFLAGS     =3D ${AM_CFLAGS} -DIPTABLES_MULTI
+xtables_multi_SOURCES  =3D xtables-multi.c
+xtables_multi_CFLAGS   =3D ${AM_CFLAGS} -DIPTABLES_MULTI
+xtables_multi_LDFLAGS  =3D -rdynamic
+xtables_multi_LDADD    =3D
 if ENABLE_STATIC
-iptables_multi_CFLAGS    +=3D -DALL_INCLUSIVE
+xtables_multi_CFLAGS  +=3D -DALL_INCLUSIVE
 endif
-iptables_multi_LDFLAGS    =3D -rdynamic
-iptables_multi_LDADD      =3D libiptc/libip4tc.la extensions/libext4.a=
 libxtables.la -lm
-
-ip6tables_multi_SOURCES   =3D ip6tables-multi.c ip6tables-save.c \
-                            ip6tables-restore.c ip6tables-standalone.c=
 \
-                            ip6tables.c xshared.c
-ip6tables_multi_CFLAGS    =3D ${AM_CFLAGS} -DIPTABLES_MULTI
-if ENABLE_STATIC
-ip6tables_multi_CFLAGS   +=3D -DALL_INCLUSIVE
+if ENABLE_IPV4
+xtables_multi_SOURCES +=3D iptables-save.c iptables-restore.c iptables=
-xml.c \
+                         iptables-standalone.c iptables.c
+xtables_multi_CFLAGS  +=3D -DENABLE_IPV4
+xtables_multi_LDADD   +=3D libiptc/libip4tc.la extensions/libext4.a
+endif
+if ENABLE_IPV6
+xtables_multi_SOURCES +=3D ip6tables-save.c ip6tables-restore.c \
+                          ip6tables-standalone.c ip6tables.c
+xtables_multi_CFLAGS  +=3D -DENABLE_IPV6
+xtables_multi_LDADD   +=3D libiptc/libip6tc.la extensions/libext6.a
 endif
-ip6tables_multi_LDFLAGS   =3D -rdynamic
-ip6tables_multi_LDADD     =3D libiptc/libip6tc.la extensions/libext6.a=
 libxtables.la -lm
+xtables_multi_SOURCES +=3D xshared.c
+xtables_multi_LDADD   +=3D libxtables.la -lm
=20
-sbin_PROGRAMS    =3D
+sbin_PROGRAMS    =3D xtables-multi
 man_MANS         =3D iptables.8 iptables-restore.8 iptables-save.8 \
                    iptables-xml.8 ip6tables.8 ip6tables-restore.8 \
                    ip6tables-save.8
 CLEANFILES       =3D iptables.8 ip6tables.8
=20
 if ENABLE_IPV4
-sbin_PROGRAMS +=3D iptables-multi
 v4_bin_links   =3D iptables-xml
 v4_sbin_links  =3D iptables iptables-restore iptables-save
 endif
 if ENABLE_IPV6
-sbin_PROGRAMS +=3D ip6tables-multi
 v6_sbin_links  =3D ip6tables ip6tables-restore ip6tables-save
 endif
=20
@@ -96,9 +96,9 @@ config.status: extensions/GNUmakefile.in \
 install-exec-hook:
 	-if test -z "${DESTDIR}"; then /sbin/ldconfig; fi;
 	${INSTALL} -dm0755 "${DESTDIR}${bindir}";
-	for i in ${v4_bin_links}; do ${LN_S} -f "${sbindir}/iptables-multi" "=
${DESTDIR}${bindir}/$$i"; done;
-	for i in ${v4_sbin_links}; do ${LN_S} -f iptables-multi "${DESTDIR}${=
sbindir}/$$i"; done;
-	for i in ${v6_sbin_links}; do ${LN_S} -f ip6tables-multi "${DESTDIR}$=
{sbindir}/$$i"; done;
+	for i in ${v4_bin_links}; do ${LN_S} -f "${sbindir}/xtables-multi" "$=
{DESTDIR}${bindir}/$$i"; done;
+	for i in ${v4_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${s=
bindir}/$$i"; done;
+	for i in ${v6_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${s=
bindir}/$$i"; done;
=20
 gitclean: distclean
 	rm -f Makefile.in aclocal.m4 compile config.guess config.h.in config.=
h.in~ config.sub configure depcomp include/Makefile.in install-sh libip=
q/Makefile.in ltmain.sh missing utils/Makefile.in;
diff --git a/ip6tables-multi.c b/ip6tables-multi.c
deleted file mode 100644
index 40ce37b..0000000
--- a/ip6tables-multi.c
+++ /dev/null
@@ -1,20 +0,0 @@
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include "xshared.h"
-#include "ip6tables-multi.h"
-
-static const struct subcommand multi6_subcommands[] =3D {
-	{"ip6tables",         ip6tables_main},
-	{"main",              ip6tables_main},
-	{"ip6tables-save",    ip6tables_save_main},
-	{"save",              ip6tables_save_main},
-	{"ip6tables-restore", ip6tables_restore_main},
-	{"restore",           ip6tables_restore_main},
-	{NULL},
-};
-
-int main(int argc, char **argv)
-{
-	return subcmd_main(argc, argv, multi6_subcommands);
-}
diff --git a/iptables-multi.c b/iptables-multi.c
deleted file mode 100644
index 14579e0..0000000
--- a/iptables-multi.c
+++ /dev/null
@@ -1,22 +0,0 @@
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include "xshared.h"
-#include "iptables-multi.h"
-
-static const struct subcommand multi4_subcommands[] =3D {
-	{"iptables",         iptables_main},
-	{"main",             iptables_main},
-	{"iptables-save",    iptables_save_main},
-	{"save",             iptables_save_main},
-	{"iptables-restore", iptables_restore_main},
-	{"restore",          iptables_restore_main},
-	{"iptables-xml",     iptables_xml_main},
-	{"xml",              iptables_xml_main},
-	{NULL},
-};
-
-int main(int argc, char **argv)
-{
-	return subcmd_main(argc, argv, multi4_subcommands);
-}
diff --git a/xtables-multi.c b/xtables-multi.c
new file mode 100644
index 0000000..c712b2a
--- /dev/null
+++ b/xtables-multi.c
@@ -0,0 +1,39 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "xshared.h"
+
+#ifdef ENABLE_IPV4
+#include "iptables-multi.h"
+#endif
+
+#ifdef ENABLE_IPV6
+#include "ip6tables-multi.h"
+#endif
+
+static const struct subcommand multi_subcommands[] =3D {
+#ifdef ENABLE_IPV4
+	{"iptables",          iptables_main},
+	{"main4",             iptables_main},
+	{"iptables-save",     iptables_save_main},
+	{"save4",             iptables_save_main},
+	{"iptables-restore",  iptables_restore_main},
+	{"restore4",          iptables_restore_main},
+	{"iptables-xml",      iptables_xml_main},
+	{"xml4",              iptables_xml_main},
+#endif
+#ifdef ENABLE_IPV6
+	{"ip6tables",         ip6tables_main},
+	{"main6",             ip6tables_main},
+	{"ip6tables-save",    ip6tables_save_main},
+	{"save6",             ip6tables_save_main},
+	{"ip6tables-restore", ip6tables_restore_main},
+	{"restore6",          ip6tables_restore_main},
+#endif
+	{NULL},
+};
+
+int main(int argc, char **argv)
+{
+	return subcmd_main(argc, argv, multi_subcommands);
+}
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
