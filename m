From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: IPT [PATCH 3/3] libxt_TOS target module
Date: Tue, 27 Nov 2007 00:46:57 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711270046430.22369@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711270044250.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49159 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbXKZXq6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:46:58 -0500
In-Reply-To: <Pine.LNX.4.64.0711270044250.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Upgrades libipt_TOS to libxt_TOS and use the new xt_TOS v1 target.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/Makefile               |    4=20
 extensions/libipt_TOS.c           |  159 -----------------------------
 extensions/libipt_TOS.man         |   11 --
 extensions/libxt_TOS.c            |  207 +++++++++++++++++++++++++++++=
+++++++++
 extensions/libxt_TOS.man          |   12 ++
 include/linux/netfilter/xt_DSCP.h |    5=20
 6 files changed, 226 insertions(+), 172 deletions(-)

Index: iptables-modules/extensions/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/Makefile
+++ iptables-modules/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this ipta=
bles
 # package (HW)
 #
-PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange policy realm rec=
ent ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIREC=
T REJECT SAME SNAT TOS TTL ULOG
+PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange policy realm rec=
ent ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIREC=
T REJECT SAME SNAT TTL ULOG
 PF6_EXT_SLIB:=3Dah dst eui64 frag hbh hl icmp6 ipv6header mh policy rt=
 HL LOG REJECT
-PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp has=
hlimit helper length limit mac mark multiport owner physdev pkttype quo=
ta sctp state statistic standard string tcp tcpmss time tos u32 udp CLA=
SSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp has=
hlimit helper length limit mac mark multiport owner physdev pkttype quo=
ta sctp state statistic standard string tcp tcpmss time tos u32 udp CLA=
SSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TOS TRACE
=20
 PF_EXT_SELINUX_SLIB:=3D
 PF6_EXT_SELINUX_SLIB:=3D
Index: iptables-modules/extensions/libipt_TOS.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/libipt_TOS.c
+++ /dev/null
@@ -1,159 +0,0 @@
-/* Shared library add-on to iptables to add TOS target support. */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_TOS.h>
-
-struct tosinfo {
-	struct xt_entry_target t;
-	struct ipt_tos_target_info tos;
-};
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
-static void TOS_help(void)
-{
-	unsigned int i;
-
-	printf(
-"TOS target v%s options:\n"
-"  --set-tos value                   Set Type of Service field to one =
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
-static const struct option TOS_opts[] =3D {
-	{ "set-tos", 1, NULL, '1' },
-	{ }
-};
-
-static void
-parse_tos(const char *s, struct ipt_tos_target_info *info)
-{
-	unsigned int i, tos;
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
-static int TOS_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
-                     const void *entry, struct xt_entry_target **targe=
t)
-{
-	struct ipt_tos_target_info *tosinfo
-		=3D (struct ipt_tos_target_info *)(*target)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "TOS target: Cant specify --set-tos twice");
-		parse_tos(optarg, tosinfo);
-		*flags =3D 1;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-static void TOS_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-		           "TOS target: Parameter --set-tos is required");
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
-/* Prints out the targinfo. */
-static void TOS_print(const void *ip, const struct xt_entry_target *ta=
rget,
-                      int numeric)
-{
-	const struct ipt_tos_target_info *tosinfo =3D
-		(const struct ipt_tos_target_info *)target->data;
-	printf("TOS set ");
-	print_tos(tosinfo->tos, numeric);
-}
-
-/* Saves the union ipt_targinfo in parsable form to stdout. */
-static void TOS_save(const void *ip, const struct xt_entry_target *tar=
get)
-{
-	const struct ipt_tos_target_info *tosinfo =3D
-		(const struct ipt_tos_target_info *)target->data;
-
-	printf("--set-tos 0x%02x ", tosinfo->tos);
-}
-
-static struct iptables_target tos_target =3D {
-	.name		=3D "TOS",
-	.version	=3D IPTABLES_VERSION,
-	.size		=3D IPT_ALIGN(sizeof(struct ipt_tos_target_info)),
-	.userspacesize	=3D IPT_ALIGN(sizeof(struct ipt_tos_target_info)),
-	.help		=3D TOS_help,
-	.parse		=3D TOS_parse,
-	.final_check	=3D TOS_check,
-	.print		=3D TOS_print,
-	.save		=3D TOS_save,
-	.extra_opts	=3D TOS_opts,
-};
-
-void _init(void)
-{
-	register_target(&tos_target);
-}
Index: iptables-modules/extensions/libipt_TOS.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/extensions/libipt_TOS.man
+++ /dev/null
@@ -1,11 +0,0 @@
-This is used to set the 8-bit Type of Service field in the IP header.
-It is only valid in the
-.B mangle
-table.
-.TP
-.BI "--set-tos " "tos"
-You can use a numeric TOS values, or use
-.nf
- iptables -j TOS -h
-.fi
-to see the list of valid TOS names.
Index: iptables-modules/extensions/libxt_TOS.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_TOS.c
@@ -0,0 +1,207 @@
+/*
+ * Shared library add-on to iptables to add TOS target support
+ *
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
+ * Contact: Jan Engelhardt <jengelh@computergmbh.de>
+ */
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_DSCP.h>
+#include <linux/netfilter_ipv4/ipt_TOS.h>
+#include "tos_values.c"
+
+enum {
+	FLAG_TOS =3D 1 << 0,
+};
+
+static const struct option tos_tg_opts[] =3D {
+	{.name =3D "set-tos", .has_arg =3D true, .val =3D 't'},
+	{},
+};
+
+static void tos_tg_help(void)
+{
+	const struct tos_symbol_info *symbol;
+
+	printf(
+"TOS target v%s options:\n"
+"  --set-tos value[/mask]    Set Type of Service/Priority field to val=
ue\n"
+"  --set-tos symbol          Set TOS field (IPv4 only) by symbol\n"
+"                            Accepted symbolic names for value are:\n"=
,
+IPTABLES_VERSION);
+
+	for (symbol =3D tos_symbol_names; symbol->name !=3D NULL; ++symbol)
+		printf("                          (0x%02x) %2u %s\n",
+		       symbol->value, symbol->value, symbol->name);
+
+	printf("\n");
+}
+
+static int tos_tg_parse_v0(int c, char **argv, int invert, unsigned in=
t *flags,
+                           const void *entry, struct xt_entry_target *=
*target)
+{
+	struct ipt_tos_target_info *info =3D (void *)(*target)->data;
+	struct tos_value_mask tvm;
+
+	switch (c) {
+	case 't':
+		if (*flags & FLAG_TOS)
+			exit_error(PARAMETER_PROBLEM, "TOS target: You cannot "
+			           "specify --set-tos more than once");
+		if (!tos_parse_symbolic(optarg, &tvm, 8))
+			exit_error(PARAMETER_PROBLEM, "TOS target: Invalid "
+			           "value for --set-tos parameter");
+		if (tvm.mask !=3D 0xFF)
+			exit_error(PARAMETER_PROBLEM, "tos match: Your kernel "
+			           "is too old to support anything besides "
+				   "/0xFF as a mask.");
+		info->tos =3D tvm.value;
+		*flags |=3D FLAG_TOS;
+		return true;
+	}
+
+	return false;
+}
+
+static int tos_tg4_parse(int c, char **argv, int invert, unsigned int =
*flags,
+                         const void *entry, struct xt_entry_target **t=
arget)
+{
+	struct xt_tos_target_info *info =3D (void *)(*target)->data;
+	struct tos_value_mask tvm;
+
+	switch (c) {
+	case 't':
+		if (*flags & FLAG_TOS)
+			exit_error(PARAMETER_PROBLEM, "TOS target: You cannot "
+			           "specify --set-tos more than once");
+		if (!tos_parse_symbolic(optarg, &tvm, 8))
+			exit_error(PARAMETER_PROBLEM, "TOS target: Invalid "
+			           "value for --set-tos parameter");
+		info->tos_value =3D tvm.value;
+		info->tos_mask  =3D tvm.mask;
+		*flags |=3D FLAG_TOS;
+		return true;
+	}
+
+	return false;
+}
+
+static int tos_tg6_parse(int c, char **argv, int invert, unsigned int =
*flags,
+                         const void *entry, struct xt_entry_target **t=
arget)
+{
+	struct xt_tos_target_info *info =3D (void *)(*target)->data;
+	struct tos_value_mask tvm;
+
+	switch (c) {
+	case 't':
+		if (*flags & FLAG_TOS)
+			exit_error(PARAMETER_PROBLEM, "TOS target: You cannot "
+			           "specify --set-tos more than once");
+		if (!tos_parse_numeric(optarg, &tvm, 4))
+			exit_error(PARAMETER_PROBLEM, "TOS target: Invalid "
+			           "value for --tos parameter");
+		info->tos_value =3D tvm.value;
+		info->tos_mask  =3D tvm.mask;
+		*flags |=3D FLAG_TOS;
+		return true;
+	}
+
+	return false;
+}
+
+static void tos_tg_check(unsigned int flags)
+{
+	if (flags =3D=3D 0)
+		exit_error(PARAMETER_PROBLEM,
+		           "TOS target: --set-tos parameter required");
+}
+
+static void tos_tg_print_v0(const void *ip,
+                            const struct xt_entry_target *target, int =
numeric)
+{
+	const struct ipt_tos_target_info *info =3D (const void *)target->data=
;
+
+	printf("TOS set ");
+	if (numeric || !tos_try_print_symbolic(info->tos, 0xFF))
+		printf("0x%02x ", info->tos);
+}
+
+static void tos_tg_print(const void *ip, const struct xt_entry_target =
*target,
+                         int numeric)
+{
+	const struct xt_tos_target_info *info =3D (const void *)target->data;
+
+	printf("TOS set ");
+	if (numeric || !tos_try_print_symbolic(info->tos_value, info->tos_mas=
k))
+		printf("0x%02x/0x%02x ", info->tos_value, info->tos_mask);
+}
+
+static void tos_tg_save_v0(const void *ip, const struct xt_entry_targe=
t *target)
+{
+	const struct ipt_tos_target_info *info =3D (const void *)target->data=
;
+
+	printf("--set-tos 0x%02x ", info->tos);
+}
+
+static void tos_tg_save(const void *ip, const struct xt_entry_target *=
target)
+{
+	const struct xt_tos_target_info *info =3D (const void *)target->data;
+
+	printf("--set-tos 0x%02x/0x%02x ", info->tos_value, info->tos_mask);
+}
+
+static struct xtables_target tos_tg_reg_v0 =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "TOS",
+	.revision      =3D 0,
+	.family        =3D AF_INET,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tos_target_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tos_target_info)),
+	.help          =3D tos_tg_help,
+	.parse         =3D tos_tg_parse_v0,
+	.final_check   =3D tos_tg_check,
+	.print         =3D tos_tg_print_v0,
+	.save          =3D tos_tg_save_v0,
+	.extra_opts    =3D tos_tg_opts,
+};
+
+static struct xtables_target tos_tg_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "TOS",
+	.revision      =3D 1,
+	.family        =3D AF_INET,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tos_target_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tos_target_info)),
+	.help          =3D tos_tg_help,
+	.parse         =3D tos_tg4_parse,
+	.final_check   =3D tos_tg_check,
+	.print         =3D tos_tg_print,
+	.save          =3D tos_tg_save,
+	.extra_opts    =3D tos_tg_opts,
+};
+
+static struct xtables_target tos_tg6_reg =3D {
+	.version       =3D IPTABLES_VERSION,
+	.name          =3D "TOS",
+	.family        =3D AF_INET6,
+	.revision      =3D 1,
+	.size          =3D XT_ALIGN(sizeof(struct xt_tos_target_info)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_tos_target_info)),
+	.help          =3D tos_tg_help,
+	.parse         =3D tos_tg6_parse,
+	.final_check   =3D tos_tg_check,
+	.print         =3D tos_tg_print,
+	.save          =3D tos_tg_save,
+	.extra_opts    =3D tos_tg_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&tos_tg_reg_v0);
+	xtables_register_target(&tos_tg_reg);
+	xtables_register_target(&tos_tg6_reg);
+}
Index: iptables-modules/extensions/libxt_TOS.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables-modules/extensions/libxt_TOS.man
@@ -0,0 +1,12 @@
+This module sets the 8-bit Type of Service field in the IPv4 header (i=
ncluding
+the 'precedence' bits) or the 4-bit Priority field in the IPv6 header.=
 It is
+only valid in the \fBmangle\fR table.
+.TP
+\fB--set-tos\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+Zeroes out the TOS bits given by \fImask\fR and XORs \fIvalue\fR into =
the
+TOS/Priority field.
+.TP
+\fB--set-tos\fR \fIsymbol\fR
+You can specify a symbolic name when using the TOS target for IPv4. It=
 implies
+a mask of 0xFF. The list of recognized TOS names can be obtained by ca=
lling
+iptables with \fB-j TOS -h\fR.
Index: iptables-modules/include/linux/netfilter/xt_DSCP.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/include/linux/netfilter/xt_DSCP.h
+++ iptables-modules/include/linux/netfilter/xt_DSCP.h
@@ -17,4 +17,9 @@ struct xt_DSCP_info {
 	u_int8_t dscp;
 };
=20
+struct xt_tos_target_info {
+	u_int8_t tos_value;
+	u_int8_t tos_mask;
+};
+
 #endif /* _XT_DSCP_TARGET_H */
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
