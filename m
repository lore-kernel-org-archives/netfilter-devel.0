From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] xtables-multi: fix absence of xml translator in IPv6-only builds
Date: Tue,  7 Jun 2011 22:35:59 +0200
Message-ID: <1307478964-2034-2-git-send-email-jengelh@medozas.de>
References: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39434 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591Ab1FGUgJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:36:09 -0400
In-Reply-To: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>

Commit v1.4.11-4-gde791ff did not actually build the iptables-xml code
into the xtables-multi binary.

Signed-off-by: Maciej Zenczykowski <maze@google.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am      |    4 ++--
 iptables-multi.h |    1 -
 iptables-xml.c   |    4 ++--
 xtables-multi.c  |    6 ++++--
 xtables-multi.h  |    6 ++++++
 5 files changed, 14 insertions(+), 7 deletions(-)
 create mode 100644 xtables-multi.h

diff --git a/Makefile.am b/Makefile.am
index 60ea83b..48f01d8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -38,7 +38,7 @@ libxtables_la_CFLAGS  =3D ${AM_CFLAGS} -DNO_SHARED_LI=
BS=3D1
 libxtables_la_LIBADD  =3D
 endif
=20
-xtables_multi_SOURCES  =3D xtables-multi.c
+xtables_multi_SOURCES  =3D xtables-multi.c iptables-xml.c
 xtables_multi_CFLAGS   =3D ${AM_CFLAGS} -DIPTABLES_MULTI
 xtables_multi_LDFLAGS  =3D -rdynamic
 xtables_multi_LDADD    =3D extensions/libext.a
@@ -46,7 +46,7 @@ if ENABLE_STATIC
 xtables_multi_CFLAGS  +=3D -DALL_INCLUSIVE
 endif
 if ENABLE_IPV4
-xtables_multi_SOURCES +=3D iptables-save.c iptables-restore.c iptables=
-xml.c \
+xtables_multi_SOURCES +=3D iptables-save.c iptables-restore.c \
                          iptables-standalone.c iptables.c
 xtables_multi_CFLAGS  +=3D -DENABLE_IPV4
 xtables_multi_LDADD   +=3D libiptc/libip4tc.la extensions/libext4.a
diff --git a/iptables-multi.h b/iptables-multi.h
index a9912b0..a2bb878 100644
--- a/iptables-multi.h
+++ b/iptables-multi.h
@@ -4,6 +4,5 @@
 extern int iptables_main(int, char **);
 extern int iptables_save_main(int, char **);
 extern int iptables_restore_main(int, char **);
-extern int iptables_xml_main(int, char **);
=20
 #endif /* _IPTABLES_MULTI_H */
diff --git a/iptables-xml.c b/iptables-xml.c
index aa98f75..5aa638c 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -1,6 +1,6 @@
 /* Code to convert iptables-save format to xml format,
  * (C) 2006 Ufo Mechanic <azez@ufomechanic.net>
- * based on iptables-restor (C) 2000-2002 by Harald Welte <laforge@gnu=
monks.org>
+ * based on iptables-restore (C) 2000-2002 by Harald Welte <laforge@gn=
umonks.org>
  * based on previous code from Rusty Russell <rusty@linuxcare.com.au>
  *
  * This code is distributed under the terms of GNU GPL v2
@@ -14,7 +14,7 @@
 #include <stdarg.h>
 #include "iptables.h"
 #include "libiptc/libiptc.h"
-#include "iptables-multi.h"
+#include "xtables-multi.h"
 #include <xtables.h>
=20
 #ifdef DEBUG
diff --git a/xtables-multi.c b/xtables-multi.c
index f8d56ce..8014d5f 100644
--- a/xtables-multi.c
+++ b/xtables-multi.c
@@ -3,6 +3,8 @@
 #include <string.h>
 #include "xshared.h"
=20
+#include "xtables-multi.h"
+
 #ifdef ENABLE_IPV4
 #include "iptables-multi.h"
 #endif
@@ -19,9 +21,9 @@ static const struct subcommand multi_subcommands[] =3D=
 {
 	{"save4",               iptables_save_main},
 	{"iptables-restore",    iptables_restore_main},
 	{"restore4",            iptables_restore_main},
-	{"iptables-xml",        iptables_xml_main},
-	{"xml4",                iptables_xml_main},
 #endif
+	{"iptables-xml",        iptables_xml_main},
+	{"xml",                 iptables_xml_main},
 #ifdef ENABLE_IPV6
 	{"ip6tables",           ip6tables_main},
 	{"main6",               ip6tables_main},
diff --git a/xtables-multi.h b/xtables-multi.h
new file mode 100644
index 0000000..615724b
--- /dev/null
+++ b/xtables-multi.h
@@ -0,0 +1,6 @@
+#ifndef _XTABLES_MULTI_H
+#define _XTABLES_MULTI_H 1
+
+extern int iptables_xml_main(int, char **);
+
+#endif /* _XTABLES_MULTI_H */
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
