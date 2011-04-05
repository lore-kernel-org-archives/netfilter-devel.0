From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH] RFC - introduce xtables-multi
Date: Tue,  5 Apr 2011 02:49:19 -0700
Message-ID: <1301996959-7342-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47678 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1DEJtp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Apr 2011 05:49:45 -0400
Received: by iwn34 with SMTP id 34so201903iwn.19
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Apr 2011 02:49:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

I'm posting this mostly to inspire discussion.

I'd like to merge iptables-multi and ip6tables-multi
into a single multi-purpose binary xtables-multi.

I can think of a few ways to do this... any preferences?

a) we delete iptables-multi and ip6tables-multi and only build xtables-=
multi
which depending on whether we're including v4 and/or v6 has different c=
apabilities
unfortunately we lose support for 'iptables-multi save', since with 'xt=
ables-multi save'
it would not be clear whether ipv4 or ipv6 was meant

b) we add xtables-multi, only build it when both v4 and v6 are enabled,=
 but don't install it
(or at least don't install any symlinks to it)
we leave the existing iptables-multi and ip6tables-multi as is

c) we add xtables-multi, only build it when both v4 and v6 are enabled,=
 and when both
v4 and v6 are enabled we don't build both iptables-multi and ip6tables-=
multi
(also means we lose 'iptables-multi save' support), the symlinks now po=
int to xtables-multi

d) maybe other ways I can't think of

(a) results in the smallest amount of code
(b) is the most backwards compatible
(c) has less if-def'ery then (a)

[side note: this patch depends on the "move 'int line'" patch I posted =
earlier today]

Comments?
---
 .gitignore      |    1 +
 Makefile.am     |   20 ++++++++++++++++++++
 xtables-multi.c |   22 ++++++++++++++++++++++
 3 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 xtables-multi.c

diff --git a/.gitignore b/.gitignore
index e5d3099..02f9d4e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -51,3 +51,4 @@ Makefile.in
 /iptables-restore
 /iptables-static
 /iptables-xml
+/xtables-multi
diff --git a/Makefile.am b/Makefile.am
index 866ac7e..f4e4587 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -57,6 +57,21 @@ endif
 ip6tables_multi_LDFLAGS   =3D -rdynamic
 ip6tables_multi_LDADD     =3D libiptc/libip6tc.la extensions/libext6.a=
 libxtables.la -lm
=20
+xtables_multi_SOURCES     =3D xtables-multi.c \
+                            iptables-save.c iptables-restore.c iptable=
s-xml.c \
+                            iptables-standalone.c iptables.c \
+                            ip6tables-save.c ip6tables-restore.c \
+                            ip6tables-standalone.c ip6tables.c \
+                            xshared.c
+xtables_multi_CFLAGS      =3D ${AM_CFLAGS} -DIPTABLES_MULTI
+if ENABLE_STATIC
+xtables_multi_CFLAGS     +=3D -DALL_INCLUSIVE
+endif
+xtables_multi_LDFLAGS     =3D -rdynamic
+xtables_multi_LDADD       =3D libiptc/libip4tc.la extensions/libext4.a=
 \
+                            libiptc/libip6tc.la extensions/libext6.a \
+                            libxtables.la -lm
+
 sbin_PROGRAMS    =3D
 man_MANS         =3D iptables.8 iptables-restore.8 iptables-save.8 \
                    iptables-xml.8 ip6tables.8 ip6tables-restore.8 \
@@ -72,6 +87,11 @@ if ENABLE_IPV6
 sbin_PROGRAMS +=3D ip6tables-multi
 v6_sbin_links  =3D ip6tables ip6tables-restore ip6tables-save
 endif
+if ENABLE_IPV4
+if ENABLE_IPV6
+sbin_PROGRAMS +=3D xtables-multi
+endif
+endif
=20
 iptables.8: ${srcdir}/iptables.8.in extensions/matches4.man extensions=
/targets4.man
 	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAG=
E_VERSION}/g' -e '/@MATCH@/ r extensions/matches4.man' -e '/@TARGET@/ r=
 extensions/targets4.man' $< >$@;
diff --git a/xtables-multi.c b/xtables-multi.c
new file mode 100644
index 0000000..61060d3
--- /dev/null
+++ b/xtables-multi.c
@@ -0,0 +1,22 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "xshared.h"
+#include "iptables-multi.h"
+#include "ip6tables-multi.h"
+
+static const struct subcommand multi_subcommands[] =3D {
+	{"iptables",          iptables_main},
+	{"iptables-save",     iptables_save_main},
+	{"iptables-restore",  iptables_restore_main},
+	{"iptables-xml",      iptables_xml_main},
+	{"ip6tables",         ip6tables_main},
+	{"ip6tables-save",    ip6tables_save_main},
+	{"ip6tables-restore", ip6tables_restore_main},
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
