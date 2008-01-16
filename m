From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [18/19] libxt_TCPOPTSTRIP
Date: Wed, 16 Jan 2008 14:54:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161454010.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, svens@bitebene.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38609 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYAPNym (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:54:42 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Import libxt_TCPOPTSTRIP into iptables.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sven Schnelle <svens@bitebene.org>

---
 extensions/libxt_TCPOPTSTRIP.c           |  212 ++++++++++++++++++++++=
+++++++++
 extensions/libxt_TCPOPTSTRIP.man         |    7 +
 include/linux/netfilter/xt_TCPOPTSTRIP.h |   13 +
 4 files changed, 233 insertions(+)

Index: iptables-modules/extensions/libxt_TCPOPTSTRIP.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_TCPOPTSTRIP.c
@@ -0,0 +1,212 @@
+/*
+ * Shared library add-on to iptables to add TCPOPTSTRIP target support=
=2E
+ * Copyright (c) 2007 Sven Schnelle <svens@bitebene.org>
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
+ * Jan Engelhardt <jengelh@computergmbh.de>
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
+	FLAG_STRIP =3D 1 << 0,
+};
+
+struct tcp_optionmap {
+	const char *name, *desc;
+	const int option;
+};
+
+static const struct option tcpoptstrip_tg_opts[] =3D {
+	{.name =3D "strip-options", .has_arg =3D true, .val =3D 's'},
+	{},
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
+static void tcpoptstrip_tg_help(void)
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
+static void tcpoptstrip_tg_init(struct xt_entry_target *t)
+{
+	struct xt_tcpoptstrip_target_info *info =3D (void *)t->data;
+
+	/* strictly necessary? play safe for now. */
+	memset(info->strip_bmap, 0, sizeof(info->strip_bmap));
+}
+
+static void parse_list(struct xt_tcpoptstrip_target_info *info, char *=
arg)
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
+static int tcpoptstrip_tg_parse(int c, char **argv, int invert,
+                                unsigned int *flags, const void *entry=
,
+                                struct xt_entry_target **target)
+{
+	struct xt_tcpoptstrip_target_info *info =3D (void *)(*target)->data;
+
+	switch (c) {
+	case 's':
+		if (*flags & FLAG_STRIP)
+			exit_error(PARAMETER_PROBLEM,
+			           "You can specify --strip-options only once");
+		parse_list(info, optarg);
+		*flags |=3D FLAG_STRIP;
+		return true;
+	}
+
+	return false;
+}
+
+static void tcpoptstrip_tg_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		exit_error(PARAMETER_PROBLEM,
+		           "TCPOPTSTRIP: --strip-options parameter required");
+}
+
+static void
+tcpoptstrip_print_list(const struct xt_tcpoptstrip_target_info *info,
+                       bool numeric)
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
+static void
+tcpoptstrip_tg_print(const void *ip, const struct xt_entry_target *tar=
get,
+                     int numeric)
+{
+	const struct xt_tcpoptstrip_target_info *info =3D
+		(const void *)target->data;
+
+	printf("TCPOPTSTRIP options ");
+	tcpoptstrip_print_list(info, numeric);
+}
+
+static void
+tcpoptstrip_tg_save(const void *ip, const struct xt_entry_target *targ=
et)
+{
+	const struct xt_tcpoptstrip_target_info *info =3D
+		(const void *)target->data;
+
+	printf("--strip-options ");
+	tcpoptstrip_print_list(info, true);
+}
+
+static struct xtables_target tcpoptstrip_tg_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "TCPOPTSTRIP",
+	.family        =3D AF_INET,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)=
),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)=
),
+	.help          =3D tcpoptstrip_tg_help,
+	.init          =3D tcpoptstrip_tg_init,
+	.parse         =3D tcpoptstrip_tg_parse,
+	.final_check   =3D tcpoptstrip_tg_check,
+	.print         =3D tcpoptstrip_tg_print,
+	.save          =3D tcpoptstrip_tg_save,
+	.extra_opts    =3D tcpoptstrip_tg_opts,
+};
+
+static struct xtables_target tcpoptstrip_tg6_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "TCPOPTSTRIP",
+	.family        =3D AF_INET6,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)=
),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)=
),
+	.help          =3D tcpoptstrip_tg_help,
+	.init          =3D tcpoptstrip_tg_init,
+	.parse         =3D tcpoptstrip_tg_parse,
+	.final_check   =3D tcpoptstrip_tg_check,
+	.print         =3D tcpoptstrip_tg_print,
+	.save          =3D tcpoptstrip_tg_save,
+	.extra_opts    =3D tcpoptstrip_tg_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&tcpoptstrip_tg_reg);
+	xtables_register_target(&tcpoptstrip_tg6_reg);
+}
Index: iptables-modules/extensions/libxt_TCPOPTSTRIP.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_TCPOPTSTRIP.man
@@ -0,0 +1,7 @@
+This target will strip TCP options off a TCP packet. (It will actually=
 replace
+them by NO-OPs.) As such, you will need to add the \fB-p tcp\fR parame=
ters.
+.TP
+\fB--strip-options\fR \fIoption\fR[\fB,\fR\fI...\fR]
+Strip the given option(s). The options may be specified by TCP option =
number or
+by symbolic name. The list of recognized options can be obtained by ca=
lling
+iptables with \fB-j TCPOPTSTRIP -h\fR.
Index: iptables-modules/include/linux/netfilter/xt_TCPOPTSTRIP.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+#define tcpoptstrip_set_bit(bmap, idx) \
+	(bmap[(idx) >> 5] |=3D 1U << (idx & 31))
+#define tcpoptstrip_test_bit(bmap, idx) \
+	(((1U << (idx & 31)) & bmap[(idx) >> 5]) !=3D 0)
+
+struct xt_tcpoptstrip_target_info {
+	u_int32_t strip_bmap[8];
+};
+
+#endif /* _XT_TCPOPTSTRIP_H */
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
