From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/4] xtables: add xtables-compat-multi for the nftables compatibility layer
Date: Tue,  4 Feb 2014 16:32:26 +0100
Message-ID: <1391527946-19077-5-git-send-email-pablo@netfilter.org>
References: <1391527946-19077-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38451 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbaBDPcv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:32:51 -0500
In-Reply-To: <1391527946-19077-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch should allow distributors to switch to the iptables over
nftables compatibility layer in a transparent way by updating
symbolic links from:

lrwxrwxrwx  1 root    root         13 feb  4 15:35 iptables -> xtables-multi

to:

lrwxrwxrwx  1 root    root         13 feb  4 15:35 iptables -> xtables-compat-multi

Same thing with iptables-save, iptables-restore, ip6tables, ip6tables-save,
ip6tables-restore and arptables.

Note that, after this patch, the following new symlinks are installed:

* iptables-compat
* iptables-compat-save
* iptables-compat-restore
* ip6tables-compat
* ip6tables-compat-save
* ip6tables-compat-restore
* arptables-compat

which point to the new binary xtables-compat-multi.

The idea is to keep both native and compatibility tools installed in the
system, which should also make it easier for testing purposes.

The iptables over nftables compatibility layer is enabled by default
and it requires the libmnl and libnftnl libraries. If you don't want to
compile the compatibility layer, you can still disable it through
--disable-nftables.

This patch also includes changes to adapt the existing code to this
approach.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/Makefile.am              |   41 ++++++++++++++++++++++---------------
 iptables/xtables-arp-standalone.c |    2 +-
 iptables/xtables-arp.c            |    2 +-
 iptables/xtables-compat-multi.c   |   39 +++++++++++++++++++++++++++++++++++
 iptables/xtables-multi.h          |   13 ++++++++----
 iptables/xtables-restore.c        |   22 +++++++++++++++-----
 iptables/xtables-save.c           |   18 ++++++++++++----
 iptables/xtables-standalone.c     |   24 +++++++++++++++-------
 8 files changed, 123 insertions(+), 38 deletions(-)
 create mode 100644 iptables/xtables-compat-multi.c

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 2c6a163..41bca7c 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -25,24 +25,32 @@ endif
 xtables_multi_SOURCES += xshared.c
 xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
 
+# nftables compatibility layer
 if ENABLE_NFTABLES
-if HAVE_LIBMNL
-if HAVE_LIBNFTNL
-xtables_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
-xtables_multi_SOURCES += xtables-save.c xtables-restore.c \
-			 xtables-standalone.c xtables.c nft.c \
-			 nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
-			 xtables-config.c xtables-events.c \
-			 xtables-arp-standalone.c xtables-arp.c
-xtables_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS}
-xtables_multi_CFLAGS  += -DENABLE_NFTABLES
-# yacc and lex generate dirty code
-xtables_multi-xtables-config-parser.o xtables_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
-endif
+xtables_compat_multi_SOURCES  = xtables-compat-multi.c iptables-xml.c
+xtables_compat_multi_CFLAGS   = ${AM_CFLAGS}
+xtables_compat_multi_LDADD    = ../extensions/libext.a
+if ENABLE_STATIC
+xtables_compat_multi_CFLAGS  += -DALL_INCLUSIVE
 endif
+xtables_compat_multi_CFLAGS  += -DENABLE_NFTABLES -DENABLE_IPV4 -DENABLE_IPV6
+xtables_compat_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
+xtables_compat_multi_SOURCES += xtables-save.c xtables-restore.c \
+				xtables-standalone.c xtables.c nft.c \
+				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
+				xtables-config.c xtables-events.c \
+				xtables-arp-standalone.c xtables-arp.c
+xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS}
+# yacc and lex generate dirty code
+xtables_compat_multi-xtables-config-parser.o xtables_compat_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
+xtables_compat_multi_SOURCES += xshared.c
+xtables_compat_multi_LDADD   += ../libxtables/libxtables.la -lm
 endif
 
 sbin_PROGRAMS    = xtables-multi
+if ENABLE_NFTABLES
+sbin_PROGRAMS	+= xtables-compat-multi
+endif
 man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    iptables-xml.1 ip6tables.8 ip6tables-restore.8 \
                    ip6tables-save.8 iptables-extensions.8
@@ -57,8 +65,9 @@ if ENABLE_IPV6
 v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
 endif
 if ENABLE_NFTABLES
-x_sbin_links  = xtables xtables-restore xtables-save xtables-config \
-		xtables-events xtables-arp
+x_sbin_links  = iptables-compat iptables-compat-restore iptables-compat-save \
+		ip6tables-compat ip6tables-compat-restore ip6tables-compat-save \
+		arptables-compat xtables-config xtables-events
 endif
 
 iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../extensions/targets.man
@@ -75,4 +84,4 @@ install-exec-hook:
 	for i in ${vx_bin_links}; do ${LN_S} -f "${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
 	for i in ${v4_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
 	for i in ${v6_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
-	for i in ${x_sbin_links}; do ${LN_S} -f xtables-multi "${DESTDIR}${sbindir}/$$i"; done;
+	for i in ${x_sbin_links}; do ${LN_S} -f xtables-compat-multi "${DESTDIR}${sbindir}/$$i"; done;
diff --git a/iptables/xtables-arp-standalone.c b/iptables/xtables-arp-standalone.c
index 8d4679f..23b6bcb 100644
--- a/iptables/xtables-arp-standalone.c
+++ b/iptables/xtables-arp-standalone.c
@@ -62,7 +62,7 @@ int xtables_arp_main(int argc, char *argv[])
 		.family = NFPROTO_ARP,
 	};
 
-	xtables_globals.program_name = "xtables-arp";
+	xtables_globals.program_name = "arptables";
 	/* This code below could be replaced by xtables_init_all, which
 	 * doesn't support NFPROTO_ARP yet.
 	 */
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 298801b..0c79a38 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -202,7 +202,7 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 };
 
 const char *program_version = XTABLES_VERSION;
-const char *program_name = "xtables-arp";
+const char *program_name = "arptables";
 
 /* A few hardcoded protocols for 'all' and in case the user has no
    /etc/protocols */
diff --git a/iptables/xtables-compat-multi.c b/iptables/xtables-compat-multi.c
new file mode 100644
index 0000000..4781052
--- /dev/null
+++ b/iptables/xtables-compat-multi.c
@@ -0,0 +1,39 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "xshared.h"
+
+#include "xtables-multi.h"
+
+static const struct subcommand multi_subcommands[] = {
+	{"iptables-xml",		iptables_xml_main},
+	{"xml",				iptables_xml_main},
+	{"iptables",			xtables_ip4_main},
+	{"iptables-compat",		xtables_ip4_main},
+	{"main4",			xtables_ip4_main},
+	{"save4",			xtables_ip4_save_main},
+	{"restore4",			xtables_ip4_restore_main},
+	{"iptables-save",		xtables_ip4_save_main},
+	{"iptables-restore",		xtables_ip4_restore_main},
+	{"iptables-compat-save",	xtables_ip4_save_main},
+	{"iptables-compat-restore",	xtables_ip4_restore_main},
+	{"ip6tables",			xtables_ip6_main},
+	{"ip6tables-compat",		xtables_ip6_main},
+	{"main6",			xtables_ip6_main},
+	{"save6",			xtables_ip6_save_main},
+	{"restore6",			xtables_ip6_restore_main},
+	{"ip6tables-save",		xtables_ip6_save_main},
+	{"ip6tables-restore",		xtables_ip6_restore_main},
+	{"ip6tables-compat-save",	xtables_ip6_save_main},
+	{"ip6tables-compat-restore",	xtables_ip6_restore_main},
+	{"arptables",			xtables_arp_main},
+	{"arptables-compat",		xtables_arp_main},
+	{"xtables-config",		xtables_config_main},
+	{"xtables-events",		xtables_events_main},
+	{NULL},
+};
+
+int main(int argc, char **argv)
+{
+	return subcmd_main(argc, argv, multi_subcommands);
+}
diff --git a/iptables/xtables-multi.h b/iptables/xtables-multi.h
index 759e24f..e706894 100644
--- a/iptables/xtables-multi.h
+++ b/iptables/xtables-multi.h
@@ -2,11 +2,16 @@
 #define _XTABLES_MULTI_H 1
 
 extern int iptables_xml_main(int, char **);
-extern int xtables_main(int, char **);
-extern int xtables_save_main(int, char **);
-extern int xtables_restore_main(int, char **);
+#ifdef ENABLE_NFTABLES
+extern int xtables_ip4_main(int, char **);
+extern int xtables_ip4_save_main(int, char **);
+extern int xtables_ip4_restore_main(int, char **);
+extern int xtables_ip6_main(int, char **);
+extern int xtables_ip6_save_main(int, char **);
+extern int xtables_ip6_restore_main(int, char **);
+extern int xtables_arp_main(int, char **);
 extern int xtables_config_main(int, char **);
 extern int xtables_events_main(int, char **);
-extern int xtables_arp_main(int, char **);
+#endif
 
 #endif /* _XTABLES_MULTI_H */
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 230894c..c4af2c5 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -165,11 +165,11 @@ static const struct xtc_ops xtc_ops = {
 	.strerror	= nft_strerror,
 };
 
-int
-xtables_restore_main(int argc, char *argv[])
+static int
+xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 {
 	struct nft_handle h = {
-		.family = AF_INET,	/* default to IPv4 */
+		.family = family,
 	};
 	char buffer[10240];
 	int c;
@@ -183,8 +183,8 @@ xtables_restore_main(int argc, char *argv[])
 
 	line = 0;
 
-	xtables_globals.program_name = "xtables-restore";
-	c = xtables_init_all(&xtables_globals, NFPROTO_IPV4);
+	xtables_globals.program_name = progname;
+	c = xtables_init_all(&xtables_globals, family);
 	if (c < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
 				xtables_globals.program_name,
@@ -472,3 +472,15 @@ xtables_restore_main(int argc, char *argv[])
 	fclose(in);
 	return 0;
 }
+
+int xtables_ip4_restore_main(int argc, char *argv[])
+{
+	return xtables_restore_main(NFPROTO_IPV4, "iptables-restore",
+				    argc, argv);
+}
+
+int xtables_ip6_restore_main(int argc, char *argv[])
+{
+	return xtables_restore_main(NFPROTO_IPV6, "ip6tables-restore",
+				    argc, argv);
+}
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 77eab14..93065cf 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -74,17 +74,17 @@ do_output(struct nft_handle *h, const char *tablename, bool counters)
  * :Chain name POLICY packets bytes
  * rule
  */
-int
-xtables_save_main(int argc, char *argv[])
+static int
+xtables_save_main(int family, const char *progname, int argc, char *argv[])
 {
 	const char *tablename = NULL;
 	bool dump = false;
 	struct nft_handle h = {
-		.family	= AF_INET,	/* default to AF_INET */
+		.family	= family,
 	};
 	int c;
 
-	xtables_globals.program_name = "xtables-save";
+	xtables_globals.program_name = progname;
 	/* XXX xtables_init_all does several things we don't want */
 	c = xtables_init_all(&xtables_globals, NFPROTO_IPV4);
 	if (c < 0) {
@@ -143,3 +143,13 @@ xtables_save_main(int argc, char *argv[])
 
 	return !do_output(&h, tablename, show_counters);
 }
+
+int xtables_ip4_save_main(int argc, char *argv[])
+{
+	return xtables_save_main(NFPROTO_IPV4, "iptables-save", argc, argv);
+}
+
+int xtables_ip6_save_main(int argc, char *argv[])
+{
+	return xtables_save_main(NFPROTO_IPV6, "ip6tables-save", argc, argv);
+}
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index c9f8e15..eb13980 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -39,17 +39,17 @@
 #include "xtables-multi.h"
 #include "nft.h"
 
-int
-xtables_main(int argc, char *argv[])
+static int
+xtables_main(int family, const char *progname, int argc, char *argv[])
 {
 	int ret;
 	char *table = "filter";
-	struct nft_handle h;
+	struct nft_handle h = {
+		.family = family,
+	};
 
-	memset(&h, 0, sizeof(h));
-
-	xtables_globals.program_name = "xtables";
-	ret = xtables_init_all(&xtables_globals, NFPROTO_IPV4);
+	xtables_globals.program_name = progname;
+	ret = xtables_init_all(&xtables_globals, family);
 	if (ret < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
 				xtables_globals.program_name,
@@ -92,3 +92,13 @@ xtables_main(int argc, char *argv[])
 
 	exit(!ret);
 }
+
+int xtables_ip4_main(int argc, char *argv[])
+{
+	return xtables_main(NFPROTO_IPV4, "iptables", argc, argv);
+}
+
+int xtables_ip6_main(int argc, char *argv[])
+{
+	return xtables_main(NFPROTO_IPV6, "ip6tables", argc, argv);
+}
-- 
1.7.10.4

