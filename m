From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 7/11] libxt_MARK target revision 2
Date: Sat, 22 Dec 2007 03:46:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220345490.8607@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712220342260.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56613 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXLVCqG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:46:06 -0500
In-Reply-To: <Pine.LNX.4.64.0712220342260.8607@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


libxt_MARK revision 2 support.
Also consolidate libip6t_MARK.man and libipt_MARK.man.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libip6t_MARK.man       |    6 -
 extensions/libipt_MARK.man        |   13 ---
 extensions/libxt_MARK.c           |  158 ++++++++++++++++++++++++++++++++++++++
 extensions/libxt_MARK.man         |   25 ++++++
 include/linux/netfilter/xt_MARK.h |    4 
 5 files changed, 187 insertions(+), 19 deletions(-)

Index: iptables-modules/extensions/libip6t_MARK.man
===================================================================
--- iptables-modules.orig/extensions/libip6t_MARK.man
+++ /dev/null
@@ -1,6 +0,0 @@
-This is used to set the netfilter mark value associated with the
-packet.  It is only valid in the
-.B mangle
-table.
-.TP
-.BI "--set-mark " "mark"
Index: iptables-modules/extensions/libipt_MARK.man
===================================================================
--- iptables-modules.orig/extensions/libipt_MARK.man
+++ /dev/null
@@ -1,13 +0,0 @@
-This is used to set the netfilter mark value associated with the
-packet.  It is only valid in the
-.B mangle
-table.  It can for example be used in conjunction with iproute2.
-.TP
-.BI "--set-mark " "value"
-Set nfmark value
-.TP
-.BI "--and-mark " "value"
-Binary AND the nfmark with value
-.TP
-.BI "--or-mark " "value"
-Binary OR  the nfmark with value
Index: iptables-modules/extensions/libxt_MARK.c
===================================================================
--- iptables-modules.orig/extensions/libxt_MARK.c
+++ iptables-modules/extensions/libxt_MARK.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add MARK target support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -8,6 +9,10 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_MARK.h>
 
+enum {
+	F_MARK = 1 << 0,
+};
+
 /* Function which prints out usage message. */
 static void MARK_help(void)
 {
@@ -27,6 +32,27 @@ static const struct option MARK_opts[] =
 	{ }
 };
 
+static const struct option mark_tg_opts[] = {
+	{.name = "set-xmark", .has_arg = true, .val = 'X'},
+	{.name = "set-mark",  .has_arg = true, .val = '='},
+	{.name = "and-mark",  .has_arg = true, .val = '&'},
+	{.name = "or-mark",   .has_arg = true, .val = '|'},
+	{.name = "xor-mark",  .has_arg = true, .val = '^'},
+	{},
+};
+
+static void mark_tg_help(void)
+{
+	printf(
+"MARK target options:\n"
+"  --set-xmark value[/mask]  Clear bits in mask and XOR value into nfmark\n"
+"  --set-mark value[/mask]   Clear bits in mask and OR value into nfmark\n"
+"  --and-mark bits           Binary AND the nfmark with bits\n"
+"  --or-mark bits            Binary OR the nfmark with bits\n"
+"  --xor-mask bits           Binary XOR the nfmark with bits\n"
+"\n");
+}
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -101,6 +127,84 @@ MARK_parse_v1(int c, char **argv, int in
 	return 1;
 }
 
+static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
+                         const void *entry, struct xt_entry_target **target)
+{
+	struct xt_mark_target_info_v2 *info = (void *)(*target)->data;
+	unsigned int value, mask = ~0U;
+	char *end;
+
+	switch (c) {
+	case 'X': /* --set-xmark */
+	case '=': /* --set-mark */
+		if (*flags & F_MARK)
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Only one MARK operation allowed\n");
+		if (!bound_strtou(optarg, &end, &value, 0, ~0U))
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Illegal value");
+		if (*end == '/')
+			if (!bound_strtou(end + 1, &end, &mask, 0, ~0U))
+				exit_error(PARAMETER_PROBLEM,
+				           "MARK target: Illegal mask");
+		if (*end != '\0')
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Illegal specifcation");
+		info->mark = value;
+		info->mask = mask;
+
+		if (c == '=')
+			info->mask = value | mask;
+		break;
+
+	case '&': /* --and-mark */
+		if (*flags & F_MARK)
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Only one MARK operation allowed\n");
+		if (!bound_strtou(optarg, &end, &mask, 0, ~0U) || *end != '\0')
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Illegal value");
+		info->mark = 0;
+		info->mask = ~mask;
+		break;
+
+	case '|': /* --or-mark */
+		if (*flags & F_MARK)
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Only one MARK operation allowed\n");
+		if (!bound_strtou(optarg, &end, &value, 0, ~0U) || *end != '\0')
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Illegal value");
+		info->mark = value;
+		info->mask = value;
+		break;
+
+	case '^': /* --xor-mark */
+		if (*flags & F_MARK)
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Only one MARK operation allowed\n");
+		if (!bound_strtou(optarg, &end, &value, 0, ~0U) || *end != '\0')
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Illegal value");
+		info->mark = value;
+		info->mask = 0;
+		break;
+
+	default:
+		return false;
+	}
+
+	*flags |= F_MARK;
+	return true;
+}
+
+static void mark_tg_check(unsigned int flags)
+{
+	if (!(flags & F_MARK))
+		exit_error(PARAMETER_PROBLEM,
+		           "MARK target: a MARK operation is required");
+}
+
 static void
 print_mark(unsigned long mark)
 {
@@ -148,6 +252,21 @@ static void MARK_print_v1(const void *ip
 	print_mark(markinfo->mark);
 }
 
+static void mark_tg_print(const void *ip, const struct xt_entry_target *target,
+                          int numeric)
+{
+	const struct xt_mark_target_info_v2 *info = (const void *)target->data;
+
+	if (info->mark == 0)
+		printf("MARK and 0x%x ", (unsigned int)(u_int32_t)~info->mask);
+	else if (info->mark == info->mask)
+		printf("MARK or 0x%x ", info->mark);
+	else if (info->mask == 0)
+		printf("MARK xor 0x%x ", info->mark);
+	else
+		printf("MARK xset 0x%x/0x%x ", info->mark, info->mask);
+}
+
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void MARK_save_v1(const void *ip, const struct xt_entry_target *target)
 {
@@ -168,6 +287,13 @@ static void MARK_save_v1(const void *ip,
 	print_mark(markinfo->mark);
 }
 
+static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_mark_target_info_v2 *info = (const void *)target->data;
+
+	printf("--set-xmark 0x%x/0x%x ", info->mark, info->mask);
+}
+
 static struct xtables_target mark_target_v0 = {
 	.family		= AF_INET,
 	.name		= "MARK",
@@ -213,9 +339,41 @@ static struct xtables_target mark_target
 	.extra_opts	= MARK_opts,
 };
 
+static struct xtables_target mark_tg_reg_v2 = {
+	.version       = IPTABLES_VERSION,
+	.name          = "MARK",
+	.revision      = 2,
+	.family        = AF_INET,
+	.size          = XT_ALIGN(sizeof(struct xt_mark_target_info_v2)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_mark_target_info_v2)),
+	.help          = mark_tg_help,
+	.parse         = mark_tg_parse,
+	.final_check   = mark_tg_check,
+	.print         = mark_tg_print,
+	.save          = mark_tg_save,
+	.extra_opts    = mark_tg_opts,
+};
+
+static struct xtables_target mark_tg6_reg_v2 = {
+	.version       = IPTABLES_VERSION,
+	.name          = "MARK",
+	.revision      = 2,
+	.family        = AF_INET6,
+	.size          = XT_ALIGN(sizeof(struct xt_mark_target_info_v2)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_mark_target_info_v2)),
+	.help          = mark_tg_help,
+	.parse         = mark_tg_parse,
+	.final_check   = mark_tg_check,
+	.print         = mark_tg_print,
+	.save          = mark_tg_save,
+	.extra_opts    = mark_tg_opts,
+};
+
 void _init(void)
 {
 	xtables_register_target(&mark_target_v0);
 	xtables_register_target(&mark_target_v1);
 	xtables_register_target(&mark_target6_v0);
+	xtables_register_target(&mark_tg_reg_v2);
+	xtables_register_target(&mark_tg6_reg_v2);
 }
Index: iptables-modules/extensions/libxt_MARK.man
===================================================================
--- /dev/null
+++ iptables-modules/extensions/libxt_MARK.man
@@ -0,0 +1,25 @@
+This target is used to set the Netfilter mark value associated with the packet.
+The target can only be used in the \fBmangle\fR table. It can, for example, be
+used in conjunction with routing based on fwmark (needs iproute2).
+.TP
+\fB--set-xmark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+Zeroes out the bits given by \fImask\fR and XORs \fIvalue\fR into the packet
+mark ("nfmark"). If \fImask\fR is omitted, 0xFFFFFFFF is assumed.
+.TP
+\fB--set-mark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+Zeroes out the bits given by \fImask\fR and ORs \fIvalue\fR into the packet
+mark. If \fImask\fR is omitted, 0xFFFFFFFF is assumed.
+.PP
+The following mnemonics are available:
+.TP
+\fB--and-mark\fR \fIbits\fR
+Binary AND the nfmark with \fIbits\fR. (Mnemonic for \fB--set-xmark
+0/\fR\fIinvbits\fR, where \fIinvbits\fR is the binary negation of \fIbits\fR.)
+.TP
+\fB--or-mark\fR \fIbits\fR
+Binary OR the nfmark with \fIbits\fR. (Mnemonic for \fB--set-xmark\fR
+\fIbits\fR\fB/\fR\fIbits\fR.)
+.TP
+\fB--xor-mark\fR \fIbits\fR
+Binary XOR the nfmark with \fIbits\fR. (Mnemonic for \fB--set-xmark\fR
+\fIbits\fR\fB/0\fR.)
Index: iptables-modules/include/linux/netfilter/xt_MARK.h
===================================================================
--- iptables-modules.orig/include/linux/netfilter/xt_MARK.h
+++ iptables-modules/include/linux/netfilter/xt_MARK.h
@@ -18,4 +18,8 @@ struct xt_mark_target_info_v1 {
 	u_int8_t mode;
 };
 
+struct xt_mark_target_info_v2 {
+	u_int32_t mark, mask;
+};
+
 #endif /*_XT_MARK_H_target */
