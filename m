From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: libxt_TCPOPTSTRIP(iptables) 20071014
Date: Sun, 14 Oct 2007 16:23:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710141622170.22801@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40586 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbXJNOXc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Oct 2007 10:23:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


This version folds in tcp option descriptions.

=3D=3D=3D Patch begins here =3D=3D=3D

Add libxt_TCPOPTSTRIP.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/Makefile                      |    2=20
 extensions/libxt_TCPOPTSTRIP.c           |  205 ++++++++++++++++++++++=
+++++++++
 include/linux/netfilter/xt_TCPOPTSTRIP.h |   13 +
 3 files changed, 219 insertions(+), 1 deletion(-)

Index: iptables/extensions/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange owner policy rea=
lm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETM=
AP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=3Dah dst eui64 frag hbh hl icmp6 ipv6header mh owner pol=
icy rt HL LOG REJECT
-PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp has=
hlimit helper length limit mac mark multiport physdev pkttype quota sct=
p state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONN=
MARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp has=
hlimit helper length limit mac mark multiport physdev pkttype quota sct=
p state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONN=
MARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TCPOPTSTRIP TRACE
=20
 PF_EXT_SELINUX_SLIB:=3D
 PF6_EXT_SELINUX_SLIB:=3D
Index: iptables/extensions/libxt_TCPOPTSTRIP.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libxt_TCPOPTSTRIP.c
@@ -0,0 +1,205 @@
+/*
+ * Shared library add-on to iptables to add TCPOPTSTRIP target support=
=2E
+ * Copyright (c) 2007 Sven Schnelle <svens@bitebene.org>
+ * Copyright =C2=A9 Jan Engelhardt <jengelh@computergmbh.de>
+ */
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TCPOPTSTRIP.h>
+#ifndef TCPOPT_MD5SIG
+#	define TCPOPT_MD5SIG 19
+#endif
+
+enum {
+	F_STRIP =3D 1 << 0,
+};
+
+struct tcp_optionmap {
+	const char *name, *desc;
+	const int option;
+};
+
+static const struct option tcpoptstrip_opts[] =3D {
+	{"strip-options", true, NULL, '0'},
+	{NULL},
+};
+
+static const struct tcp_optionmap tcp_optionmap[] =3D {
+	{"wscale",         "Window scale",         TCPOPT_WINDOW},
+	{"mss",            "Maximum Segment Size", TCPOPT_MAXSEG},
+	{"sack-permitted", "SACK permitted",       TCPOPT_SACK_PERMITTED},
+	{"sack",           "Selective ACK",        TCPOPT_SACK},
+	{"timestamp",      "Timestamp",            TCPOPT_TIMESTAMP},
+	{"md5",            "MD5 signature",        TCPOPT_MD5SIG},
+	{NULL},
+};
+
+static void tcpoptstrip_help(void)
+{
+	const struct tcp_optionmap *w;
+
+	printf(
+"TCPOPTSTRIP target options:\n"
+"  --strip-options value     strip specified TCP options denoted by va=
lue\n"
+"                            (separated by comma) from TCP header\n"
+"  Instead of the numeric value, you can also use the following names:=
\n"
+	);
+
+	for (w =3D tcp_optionmap; w->name !=3D NULL; ++w)
+		printf("    %-14s    strip \"%s\" option\n", w->name, w->desc);
+}
+
+static void tcpoptstrip_init(struct xt_entry_target *t)
+{
+	struct xt_tcpoptstrip_info *info =3D (void *)t->data;
+
+	/* strictly necessary? play safe for now. */
+	memset(info->strip_bmap, 0, sizeof(info->strip_bmap));
+}
+
+static void parse_list(struct xt_tcpoptstrip_info *info, char *arg)
+{
+	unsigned int option;
+	char *p;
+	int i;
+
+	while (true) {
+		p =3D strchr(arg, ',');
+		if (p !=3D NULL)
+			*p =3D '\0';
+
+		option =3D 0;
+		for (i =3D 0; tcp_optionmap[i].name !=3D NULL; ++i)
+			if (strcmp(tcp_optionmap[i].name, arg) =3D=3D 0) {
+				option =3D tcp_optionmap[i].option;
+				break;
+			}
+
+		if (option =3D=3D 0 && string_to_number(arg, 0, 255, &option) =3D=3D=
 -1)
+			exit_error(PARAMETER_PROBLEM,
+			           "Bad TCP option value \"%s\"", arg);
+
+		if (option < 2)
+			exit_error(PARAMETER_PROBLEM,
+			           "Option value may not be 0 or 1");
+
+		if (tcpoptstrip_test_bit(info->strip_bmap, option))
+			exit_error(PARAMETER_PROBLEM,
+			           "Option \"%s\" already specified", arg);
+
+		tcpoptstrip_set_bit(info->strip_bmap, option);
+		if (p =3D=3D NULL)
+			break;
+		arg =3D p + 1;
+	}
+}
+
+static int tcpoptstrip_parse(int c, char **argv, int invert,
+                             unsigned int *flags, const void *entry,
+                             struct xt_entry_target **target)
+{
+	struct xt_tcpoptstrip_info *info =3D (void *)(*target)->data;
+
+	switch (c) {
+	case '0':
+		if (*flags & F_STRIP)
+			exit_error(PARAMETER_PROBLEM,
+			           "You can specify --strip-options only once");
+		parse_list(info, optarg);
+		*flags |=3D F_STRIP;
+		return 1;
+	}
+
+	return 0;
+}
+
+static void tcpoptstrip_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		exit_error(PARAMETER_PROBLEM,
+		           "TCPOPTSTRIP: At least one of the strip options must be s=
pecified");
+}
+
+static void tcpoptstrip_print_list(const struct xt_tcpoptstrip_info *i=
nfo,
+                                   bool numeric)
+{
+	unsigned int i, j;
+	const char *name;
+	bool first =3D true;
+
+	for (i =3D 0; i < 256; ++i) {
+		if (!tcpoptstrip_test_bit(info->strip_bmap, i))
+			continue;
+		if (!first)
+			printf(",");
+
+		first =3D false;
+		name  =3D NULL;
+		if (!numeric)
+			for (j =3D 0; tcp_optionmap[j].name !=3D NULL; ++j)
+				if (tcp_optionmap[j].option =3D=3D i)
+					name =3D tcp_optionmap[j].name;
+
+		if (name !=3D NULL)
+			printf("%s", name);
+		else
+			printf("%u", i);
+	}
+}
+
+static void tcpoptstrip_print(const void *ip,
+                              const struct xt_entry_target *target, in=
t numeric)
+{
+	const struct xt_tcpoptstrip_info *info =3D (const void *)target->data=
;
+	printf("TCPOPTSTRIP options ");
+	tcpoptstrip_print_list(info, numeric);
+}
+
+static void tcpoptstrip_save(const void *ip,
+                             const struct xt_entry_target *target)
+{
+	const struct xt_tcpoptstrip_info *info =3D (const void *)target->data=
;
+	printf("--strip-options ");
+	tcpoptstrip_print_list(info, true);
+}
+
+static struct xtables_target tcpoptstrip_target =3D {
+	.name          =3D "TCPOPTSTRIP",
+	.family        =3D AF_INET,
+	.version       =3D IPTABLES_VERSION,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.help          =3D tcpoptstrip_help,
+	.init          =3D tcpoptstrip_init,
+	.parse         =3D tcpoptstrip_parse,
+	.final_check   =3D tcpoptstrip_check,
+	.print         =3D tcpoptstrip_print,
+	.save          =3D tcpoptstrip_save,
+	.extra_opts    =3D tcpoptstrip_opts,
+};
+
+static struct xtables_target tcpoptstrip_target6 =3D {
+	.name          =3D "TCPOPTSTRIP",
+	.family        =3D AF_INET6,
+	.version       =3D IPTABLES_VERSION,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.help          =3D tcpoptstrip_help,
+	.init          =3D tcpoptstrip_init,
+	.parse         =3D tcpoptstrip_parse,
+	.final_check   =3D tcpoptstrip_check,
+	.print         =3D tcpoptstrip_print,
+	.save          =3D tcpoptstrip_save,
+	.extra_opts    =3D tcpoptstrip_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&tcpoptstrip_target);
+	xtables_register_target(&tcpoptstrip_target6);
+}
Index: iptables/include/linux/netfilter/xt_TCPOPTSTRIP.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+#define tcpoptstrip_set_bit(bmap, idx) \
+	(bmap[(idx) >> 5] |=3D 1UL << (idx & 31))
+#define tcpoptstrip_test_bit(bmap, idx) \
+	(((1UL << (idx & 31)) & bmap[(idx) >> 5]) !=3D 0)
+
+struct xt_tcpoptstrip_info {
+	u_int32_t strip_bmap[8];
+};
+
+#endif /* _XT_TCPOPTSTRIP_H */

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
