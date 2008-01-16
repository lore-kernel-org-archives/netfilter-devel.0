From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [05/19] libxt_tos
Date: Wed, 16 Jan 2008 14:49:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161449370.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48687 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbYAPNtx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:49:53 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move libipt_tos revision 0 to libxt_tos revision 0 and add support
for xt_tos match revision 1.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libipt_tos.c           |  163 -----------------------------=
---
 extensions/libipt_tos.man         |    9 -
 extensions/libxt_tos.c            |  190 +++++++++++++++++++++++++++++=
+++++++++
 extensions/libxt_tos.man          |   12 ++
 extensions/tos_values.c           |   90 ++++++++++++++++++
 include/linux/netfilter/xt_dscp.h |    6 +
 6 files changed, 298 insertions(+), 172 deletions(-)

Index: iptables-modules/extensions/libipt_tos.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/libipt_tos.c
+++ /dev/null
@@ -1,163 +0,0 @@
-/* Shared library add-on to iptables to add TOS matching support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_tos.h>
-
-/* TOS names and values. */
-static const
-struct TOS_value
-{
-	unsigned char TOS;
-	const char *name;
-} TOS_values[] =3D {
-	{ IPTOS_LOWDELAY,    "Minimize-Delay" },
-	{ IPTOS_THROUGHPUT,  "Maximize-Throughput" },
-	{ IPTOS_RELIABILITY, "Maximize-Reliability" },
-	{ IPTOS_MINCOST,     "Minimize-Cost" },
-	{ IPTOS_NORMALSVC,   "Normal-Service" },
-};
-
-/* Function which prints out usage message. */
-static void tos_help(void)
-{
-	unsigned int i;
-
-	printf(
-"TOS match v%s options:\n"
-"[!] --tos value                 Match Type of Service field from one =
of the\n"
-"                                following numeric or descriptive valu=
es:\n",
-IPTABLES_VERSION);
-
-	for (i =3D 0; i < sizeof(TOS_values)/sizeof(struct TOS_value);i++)
-		printf("                                     %s %u (0x%02x)\n",
-		       TOS_values[i].name,
-                       TOS_values[i].TOS,
-                       TOS_values[i].TOS);
-	fputc('\n', stdout);
-}
-
-static const struct option tos_opts[] =3D {
-	{ "tos", 1, NULL, '1' },
-	{ }
-};
-
-static void
-parse_tos(const char *s, struct ipt_tos_info *info)
-{
-	unsigned int i;
-	unsigned int tos;
-
-	if (string_to_number(s, 0, 255, &tos) !=3D -1) {
-		if (tos =3D=3D IPTOS_LOWDELAY
-		    || tos =3D=3D IPTOS_THROUGHPUT
-		    || tos =3D=3D IPTOS_RELIABILITY
-		    || tos =3D=3D IPTOS_MINCOST
-		    || tos =3D=3D IPTOS_NORMALSVC) {
-		    	info->tos =3D (u_int8_t )tos;
-		    	return;
-		}
-	} else {
-		for (i =3D 0; i<sizeof(TOS_values)/sizeof(struct TOS_value); i++)
-			if (strcasecmp(s,TOS_values[i].name) =3D=3D 0) {
-				info->tos =3D TOS_values[i].TOS;
-				return;
-			}
-	}
-	exit_error(PARAMETER_PROBLEM, "Bad TOS value `%s'", s);
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int tos_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
-                     const void *entry, struct xt_entry_match **match)
-{
-	struct ipt_tos_info *tosinfo =3D (struct ipt_tos_info *)(*match)->dat=
a;
-
-	switch (c) {
-	case '1':
-		/* Ensure that `--tos' haven't been used yet. */
-		if (*flags =3D=3D 1)
-			exit_error(PARAMETER_PROBLEM,
-					"tos match: only use --tos once!");
-
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_tos(argv[optind-1], tosinfo);
-		if (invert)
-			tosinfo->invert =3D 1;
-		*flags =3D 1;
-		break;
-
-	default:
-		return 0;
-	}
-	return 1;
-}
-
-static void
-print_tos(u_int8_t tos, int numeric)
-{
-	unsigned int i;
-
-	if (!numeric) {
-		for (i =3D 0; i<sizeof(TOS_values)/sizeof(struct TOS_value); i++)
-			if (TOS_values[i].TOS =3D=3D tos) {
-				printf("%s ", TOS_values[i].name);
-				return;
-			}
-	}
-	printf("0x%02x ", tos);
-}
-
-/* Final check; must have specified --tos. */
-static void tos_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "TOS match: You must specify `--tos'");
-}
-
-/* Prints out the matchinfo. */
-static void tos_print(const void *ip, const struct xt_entry_match *mat=
ch,
-                      int numeric)
-{
-	const struct ipt_tos_info *info =3D (const struct ipt_tos_info *)matc=
h->data;
-   =20
-	printf("TOS match ");
-	if (info->invert)
-		printf("!");
-	print_tos(info->tos, numeric);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void tos_save(const void *ip, const struct xt_entry_match *matc=
h)
-{
-	const struct ipt_tos_info *info =3D (const struct ipt_tos_info *)matc=
h->data;
-   =20
-	if (info->invert)
-		printf("! ");
-	printf("--tos ");
-	print_tos(info->tos, 0);
-}
-
-static struct iptables_match tos_match =3D {
-	.name		=3D "tos",
-	.version	=3D IPTABLES_VERSION,
-	.size		=3D IPT_ALIGN(sizeof(struct ipt_tos_info)),
-	.userspacesize	=3D IPT_ALIGN(sizeof(struct ipt_tos_info)),
-	.help		=3D tos_help,
-	.parse		=3D tos_parse,
-	.final_check	=3D tos_check,
-	.print		=3D tos_print,
-	.save		=3D tos_save,
-	.extra_opts	=3D tos_opts,
-};
-
-void _init(void)
-{
-	register_match(&tos_match);
-}
Index: iptables-modules/extensions/libipt_tos.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/libipt_tos.man
+++ /dev/null
@@ -1,9 +0,0 @@
-This module matches the 8 bits of Type of Service field in the IP
-header (ie. including the precedence bits).
-.TP
-.BI "--tos " "tos"
-The argument is either a standard name, (use
-.br
- iptables -m tos -h
-.br
-to see the list), or a numeric value to match.
Index: iptables-modules/extensions/libxt_tos.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_tos.c
@@ -0,0 +1,190 @@
+/*
+ * Shared library add-on to iptables to add tos match support
+ *
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
+ * Contact: Jan Engelhardt <jengelh@computergmbh.de>
+ */
+#include <getopt.h>
+#include <netdb.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_dscp.h>
+#include <linux/netfilter_ipv4/ipt_tos.h>
+#include "tos_values.c"
+
+enum {
+	FLAG_TOS =3D 1 << 0,
+};
+
+static const struct option tos_mt_opts[] =3D {
+	{.name =3D "tos", .has_arg =3D true, .val =3D 't'},
+	{},
+};
+
+static void tos_mt_help(void)
+{
+	const struct tos_symbol_info *symbol;
+
+	printf(
+"tos match options:\n"
+"[!] --tos value[/mask]    Match Type of Service/Priority field value\=
n"
+"[!] --tos symbol          Match TOS field (IPv4 only) by symbol\n"
+"                          Accepted symbolic names for value are:\n");
+
+	for (symbol =3D tos_symbol_names; symbol->name !=3D NULL; ++symbol)
+		printf("                          (0x%02x) %2u %s\n",
+		       symbol->value, symbol->value, symbol->name);
+
+	printf("\n");
+}
+
+static int tos_mt_parse_v0(int c, char **argv, int invert, unsigned in=
t *flags,
+                           const void *entry, struct xt_entry_match **=
match)
+{
+	struct ipt_tos_info *info =3D (void *)(*match)->data;
+	struct tos_value_mask tvm;
+
+	switch (c) {
+	case 't':
+		param_act(P_ONLY_ONCE, "tos", "--tos", *flags & FLAG_TOS);
+		if (!tos_parse_symbolic(optarg, &tvm, 0xFF))
+			param_act(P_BAD_VALUE, "tos", "--tos", optarg);
+		if (tvm.mask !=3D 0xFF)
+			exit_error(PARAMETER_PROBLEM, "tos: Your kernel is "
+			           "too old to support anything besides /0xFF "
+				   "as a mask.");
+		info->tos =3D tvm.value;
+		if (invert)
+			info->invert =3D true;
+		*flags |=3D FLAG_TOS;
+		return true;
+	}
+	return false;
+}
+
+static int tos_mt_parse(int c, char **argv, int invert, unsigned int *=
flags,
+                        const void *entry, struct xt_entry_match **mat=
ch)
+{
+	struct xt_tos_match_info *info =3D (void *)(*match)->data;
+	struct tos_value_mask tvm =3D {.mask =3D 0xFF};
+
+	switch (c) {
+	case 't':
+		param_act(P_ONLY_ONCE, "tos", "--tos", *flags & FLAG_TOS);
+		if (!tos_parse_symbolic(optarg, &tvm, 0x3F))
+			param_act(P_BAD_VALUE, "tos", "--tos", optarg);
+		info->tos_value =3D tvm.value;
+		info->tos_mask  =3D tvm.mask;
+		if (invert)
+			info->invert =3D true;
+		*flags |=3D FLAG_TOS;
+		return true;
+	}
+	return false;
+}
+
+static void tos_mt_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		exit_error(PARAMETER_PROBLEM,
+		           "tos: --tos parameter required");
+}
+
+static void tos_mt_print_v0(const void *ip, const struct xt_entry_matc=
h *match,
+                            int numeric)
+{
+	const struct ipt_tos_info *info =3D (const void *)match->data;
+
+	printf("tos match ");
+	if (info->invert)
+		printf("!");
+	if (numeric || !tos_try_print_symbolic("", info->tos, 0x3F))
+		printf("0x%02x ", info->tos);
+}
+
+static void tos_mt_print(const void *ip, const struct xt_entry_match *=
match,
+                         int numeric)
+{
+	const struct xt_tos_match_info *info =3D (const void *)match->data;
+
+	printf("tos match ");
+	if (info->invert)
+		printf("!");
+	if (numeric ||
+	    !tos_try_print_symbolic("", info->tos_value, info->tos_mask))
+		printf("0x%02x/0x%02x ", info->tos_value, info->tos_mask);
+}
+
+static void tos_mt_save_v0(const void *ip, const struct xt_entry_match=
 *match)
+{
+	const struct ipt_tos_info *info =3D (const void *)match->data;
+
+	if (info->invert)
+		printf("! ");
+	printf("--tos 0x%02x ", info->tos);
+}
+
+static void tos_mt_save(const void *ip, const struct xt_entry_match *m=
atch)
+{
+	const struct xt_tos_match_info *info =3D (const void *)match->data;
+
+	if (info->invert)
+		printf("! ");
+	printf("--tos 0x%02x/0x%02x ", info->tos_value, info->tos_mask);
+}
+
+static struct xtables_match tos_mt_reg_v0 =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "tos",
+	.family        =3D AF_INET,
+	.revision      =3D 0,
+	.size          =3D XT_ALIGN(sizeof(struct ipt_tos_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct ipt_tos_info)),
+	.help          =3D tos_mt_help,
+	.parse         =3D tos_mt_parse_v0,
+	.final_check   =3D tos_mt_check,
+	.print         =3D tos_mt_print_v0,
+	.save          =3D tos_mt_save_v0,
+	.extra_opts    =3D tos_mt_opts,
+};
+
+static struct xtables_match tos_mt_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "tos",
+	.family        =3D AF_INET,
+	.revision      =3D 1,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tos_match_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tos_match_info)),
+	.help          =3D tos_mt_help,
+	.parse         =3D tos_mt_parse,
+	.final_check   =3D tos_mt_check,
+	.print         =3D tos_mt_print,
+	.save          =3D tos_mt_save,
+	.extra_opts    =3D tos_mt_opts,
+};
+
+static struct xtables_match tos_mt6_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "tos",
+	.family        =3D AF_INET6,
+	.revision      =3D 1,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tos_match_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tos_match_info)),
+	.help          =3D tos_mt_help,
+	.parse         =3D tos_mt_parse,
+	.final_check   =3D tos_mt_check,
+	.print         =3D tos_mt_print,
+	.save          =3D tos_mt_save,
+	.extra_opts    =3D tos_mt_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&tos_mt_reg_v0);
+	xtables_register_match(&tos_mt_reg);
+	xtables_register_match(&tos_mt6_reg);
+}
Index: iptables-modules/extensions/libxt_tos.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_tos.man
@@ -0,0 +1,12 @@
+This module matches the 8-bit Type of Service field in the IPv4 header=
 (i.e.
+including the "Precedence" bits) or the (also 8-bit) Priority field in=
 the IPv6
+header.
+.TP
+\fB--tos\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+Matches packets with the given TOS mark value. If a mask is specified,=
 it is
+logically ANDed with the TOS mark before the comparison.
+.TP
+\fB--tos\fR \fIsymbol\fR
+You can specify a symbolic name when using the tos match for IPv4. The=
 list of
+recognized TOS names can be obtained by calling iptables with \fB-m to=
s -h\fR.
+Note that this implies a mask of 0x3F, i.e. all but the ECN bits.
Index: iptables-modules/extensions/tos_values.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/tos_values.c
@@ -0,0 +1,90 @@
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+
+struct tos_value_mask {
+	uint8_t value, mask;
+};
+
+static const struct tos_symbol_info {
+	unsigned char value;
+	const char *name;
+} tos_symbol_names[] =3D {
+	{IPTOS_LOWDELAY,    "Minimize-Delay"},
+	{IPTOS_THROUGHPUT,  "Maximize-Throughput"},
+	{IPTOS_RELIABILITY, "Maximize-Reliability"},
+	{IPTOS_MINCOST,     "Minimize-Cost"},
+	{IPTOS_NORMALSVC,   "Normal-Service"},
+	{},
+};
+
+/*
+ * tos_parse_numeric - parse sth. like "15/255"
+ *
+ * @s:		input string
+ * @info:	accompanying structure
+ * @bits:	number of bits that are allowed
+ *		(8 for IPv4 TOS field, 4 for IPv6 Priority Field)
+ */
+static bool tos_parse_numeric(const char *str, struct tos_value_mask *=
tvm,
+                              unsigned int bits)
+{
+	const unsigned int max =3D (1 << bits) - 1;
+	unsigned int value;
+	char *end;
+
+	strtonum(str, &end, &value, 0, max);
+	tvm->value =3D value;
+	tvm->mask  =3D max;
+
+	if (*end =3D=3D '/') {
+		const char *p =3D end + 1;
+
+		if (!strtonum(p, &end, &value, 0, max))
+			exit_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"",
+			           str);
+		tvm->mask =3D value;
+	}
+
+	if (*end !=3D '\0')
+		exit_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"", str);
+	return true;
+}
+
+static bool tos_parse_symbolic(const char *str, struct tos_value_mask =
*tvm,
+    unsigned int def_mask)
+{
+	const unsigned int max =3D 255;
+	const struct tos_symbol_info *symbol;
+
+	if (strtonum(str, NULL, NULL, 0, max))
+		return tos_parse_numeric(str, tvm, max);
+
+	/* Do not consider ECN bits */
+	tvm->mask =3D def_mask;
+	for (symbol =3D tos_symbol_names; symbol->name !=3D NULL; ++symbol)
+		if (strcasecmp(str, symbol->name) =3D=3D 0) {
+			tvm->value =3D symbol->value;
+			return true;
+		}
+
+	exit_error(PARAMETER_PROBLEM, "Symbolic name \"%s\" is unknown", str)=
;
+	return false;
+}
+
+static bool tos_try_print_symbolic(const char *prefix,
+    u_int8_t value, u_int8_t mask)
+{
+	const struct tos_symbol_info *symbol;
+
+	if (mask !=3D 0x3F)
+		return false;
+
+	for (symbol =3D tos_symbol_names; symbol->name !=3D NULL; ++symbol)
+		if (value =3D=3D symbol->value) {
+			printf("%s%s ", prefix, symbol->name);
+			return true;
+		}
+
+	return false;
+}
Index: iptables-modules/include/linux/netfilter/xt_dscp.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/include/linux/netfilter/xt_dscp.h
+++ iptables-modules/include/linux/netfilter/xt_dscp.h
@@ -20,4 +20,10 @@ struct xt_dscp_info {
 	u_int8_t invert;
 };
=20
+struct xt_tos_match_info {
+	u_int8_t tos_mask;
+	u_int8_t tos_value;
+	u_int8_t invert;
+};
+
 #endif /* _XT_DSCP_H */
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
