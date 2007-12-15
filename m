From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 5/7] xt_MARK target rev 2
Date: Sat, 15 Dec 2007 15:47:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712151459470.22877@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712070341310.1262@fbirervta.pbzchgretzou.qr>
 <475E6618.5080007@trash.net> <Pine.LNX.4.64.0712151450540.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50934 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbXLOOra (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Dec 2007 09:47:30 -0500
In-Reply-To: <Pine.LNX.4.64.0712151450540.22877@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 15 2007 14:59, Jan Engelhardt wrote:
>On Dec 11 2007 11:27, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Introduce the xt_MARK target revision 2. It uses fixed types, with the
>>> goal of obsoleting revision 0 and 1 some day (uses nonfixed types).
>>> xt_MARK rev 2 also uses more expressive XOR logic.
>>
>> Can I see a userspace patch for this please? :)
>>


libxt_MARK revision 2 support.
Also consolidates libip6t_MARK.man and libipt_MARK.man.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libip6t_MARK.man       |    6 -
 extensions/libipt_MARK.man        |   13 ---
 extensions/libxt_MARK.c           |  139 ++++++++++++++++++++++++++++++++++++++
 extensions/libxt_MARK.man         |   20 +++++
 include/linux/netfilter/xt_MARK.h |    4 +
 5 files changed, 163 insertions(+), 19 deletions(-)

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
@@ -27,6 +32,26 @@ static const struct option MARK_opts[] =
 	{ }
 };
 
+static const struct option mark_tg_opts[] = {
+	{.name = "set-xmark", .has_arg = true, .val = 'X'},
+	{.name = "set-mark",  .has_arg = true, .val = '='},
+	{.name = "and-mark",  .has_arg = true, .val = '&'},
+	{.name = "or-mark",   .has_arg = true, .val = '|'},
+	{},
+};
+
+static void mark_tg_help(void)
+{
+	printf(
+	"MARK target v%s options:\n"
+	"  --set-xmark value[/mask]  Clear bits in mask and XOR value into nfmark\n"
+	"  --set-mark value[/mask]   Clear bits in mask and OR value into nfmark\n"
+	"  --and-mark mask           Binary AND the nfmark with bits in mask\n"
+	"  --or-mark mask            Binary OR the nfmark with bits in mask\n"
+	"\n",
+	IPTABLES_VERSION);
+}
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -101,6 +126,73 @@ MARK_parse_v1(int c, char **argv, int in
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
+			           "MARK target: Only one MARK option allowed\n");
+		if (!bound_strtou(optarg, &end, &value, 0, ~0U))
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Illegal value");
+		if (*end == '/')
+			if (!bound_strtou(optarg, &end, &mask, 0, ~0U))
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
+			           "MARK target: Only one MARK option allowed\n");
+		if (!bound_strtou(optarg, &end, &mask, 0, ~0U))
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Illegal value");
+		info->mark = 0;
+		info->mask = ~mask;
+		break;
+
+	case '|': /* --or-mark */
+		if (*flags & F_MARK)
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Only one MARK option allowed\n");
+		if (!bound_strtou(optarg, &end, &value, 0, ~0U))
+			exit_error(PARAMETER_PROBLEM,
+			           "MARK target: Illegal value");
+		info->mark = value;
+		info->mask = value;
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
+		           "MARK target: Parameter --set-mark is required");
+}
+
 static void
 print_mark(unsigned long mark)
 {
@@ -148,6 +240,14 @@ static void MARK_print_v1(const void *ip
 	print_mark(markinfo->mark);
 }
 
+static void mark_tg_print(const void *ip, const struct xt_entry_target *target,
+                          int numeric)
+{
+	const struct xt_mark_target_info_v2 *info = (const void *)target->data;
+
+	printf("MARK xor 0x%x/0x%x ", info->mark, info->mask);
+}
+
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void MARK_save_v1(const void *ip, const struct xt_entry_target *target)
 {
@@ -168,6 +268,13 @@ static void MARK_save_v1(const void *ip,
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
@@ -213,9 +320,41 @@ static struct xtables_target mark_target
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
@@ -0,0 +1,20 @@
+This is used to set the netfilter mark value associated with the packet. It is
+only valid in the \fBmangle\fR table. It can for example be used in conjunction
+with iproute2.
+.TP
+\fB--set-xmark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+Zeroes out the bits given by \fImask\fR and XORs \fIvalue\fR into the packet
+mark ("nfmark"). If \fImask\fR is omitted, all bits in the nfmark are zeroed,
+i.e. \fImask\fR is implicitly assumed to be 0xFFFFFFFF.
+.PP
+The following options are for backwards-compatibility and convenience, and will
+be transformed into xmark internally.
+.TP
+\fB--and-mark\fR \fImask\fR
+Binary AND the nfmark with \fImask\fR. This is equivalent to zeroing
+\fIinvmask\fR (i.e. \fB~\fR\fImask\fR) and hence equivalent to \fB--set-xmark
+0x0/\fR\fIinvmask\fR.
+.TP
+\fB--or-mark\fR \fImask\fR
+Binary OR the nfmark with \fImask\fR. This is equivalent to \fB--set-xmark\fR
+\fImask\fR/\fImask\fR.
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
