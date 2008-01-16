From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [07/19] libxt_CONNMARK r1
Date: Wed, 16 Jan 2008 14:50:18 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161450030.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48695 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbYAPNuU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:50:20 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for xt_CONNMARK target revision 1.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_CONNMARK.c           |  266 ++++++++++++++++++++++++++++++++--
 extensions/libxt_CONNMARK.man         |   51 ++++--
 include/linux/netfilter/xt_CONNMARK.h |    5 
 3 files changed, 300 insertions(+), 22 deletions(-)

Index: iptables-modules/extensions/libxt_CONNMARK.c
===================================================================
--- iptables-modules.orig/extensions/libxt_CONNMARK.c
+++ iptables-modules/extensions/libxt_CONNMARK.c
@@ -28,12 +28,10 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CONNMARK.h>
 
-#if 0
-struct markinfo {
-	struct xt_entry_target t;
-	struct ipt_connmark_target_info mark;
+enum {
+	F_MARK    = 1 << 0,
+	F_SR_MARK = 1 << 1,
 };
-#endif
 
 /* Function which prints out usage message. */
 static void CONNMARK_help(void)
@@ -55,6 +53,52 @@ static const struct option CONNMARK_opts
 	{ }
 };
 
+static const struct option connmark_tg_opts[] = {
+	{.name = "set-xmark",     .has_arg = true,  .val = '='},
+	{.name = "set-mark",      .has_arg = true,  .val = '-'},
+	{.name = "and-mark",      .has_arg = true,  .val = '&'},
+	{.name = "or-mark",       .has_arg = true,  .val = '|'},
+	{.name = "xor-mark",      .has_arg = true,  .val = '^'},
+	{.name = "save-mark",     .has_arg = false, .val = 'S'},
+	{.name = "restore-mark",  .has_arg = false, .val = 'R'},
+	{.name = "ctmask",        .has_arg = true,  .val = 'c'},
+	{.name = "nfmask",        .has_arg = true,  .val = 'n'},
+	{.name = "mask",          .has_arg = true,  .val = 'm'},
+	{},
+};
+
+static void connmark_tg_help(void)
+{
+	printf(
+"CONNMARK target options:\n"
+"  XOR-based operations:\n"
+"  --set-xmark value[/ctmask]    Zero mask bits and XOR ctmark with value\n"
+"  --save-mark [--ctmask mask] [--nfmask mask]\n"
+"                                Copy ctmark to nfmark using masks\n"
+"  --restore-mark [--ctmask mask] [--nfmask mask]\n"
+"                                Copy nfmark to ctmark using masks\n"
+"  --and-mark bits\n"
+"  --or-mark bits\n"
+"  --xor-mark bits\n"
+"  OR-based operations (deprecated):\n"
+"  --set-mark value[/mask]       Set conntrack mark value\n"
+"  --save-mark [--mask mask]     Save the packet nfmark in the connection\n"
+"  --restore-mark [--mask mask]  Restore saved nfmark value\n"
+);
+}
+
+static void connmark_tg_init(struct xt_entry_target *target)
+{
+	struct xt_connmark_tginfo1 *info = (void *)target->data;
+
+	/*
+	 * Need these defaults for --save-mark/--restore-mark if no
+	 * --ctmark or --nfmask is given.
+	 */
+	info->ctmask = ~0U;
+	info->nfmask = ~0U;
+}
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -110,7 +154,110 @@ CONNMARK_parse(int c, char **argv, int i
 	return 1;
 }
 
-static void CONNMARK_check(unsigned int flags)
+static int connmark_tg_parse(int c, char **argv, int invert,
+                             unsigned int *flags, const void *entry,
+                             struct xt_entry_target **target)
+{
+	struct xt_connmark_tginfo1 *info = (void *)(*target)->data;
+	unsigned int value, mask = ~0U;
+	char *end;
+
+	switch (c) {
+	case '=': /* --set-xmark */
+	case '-': /* --set-mark */
+		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		if (!strtonum(optarg, &end, &value, 0, ~0U))
+			param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
+		if (*end == '/')
+			if (!strtonum(end + 1, &end, &mask, 0, ~0U))
+				param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
+		if (*end != '\0')
+			param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
+		info->mode   = XT_CONNMARK_SET;
+		info->ctmark = value;
+		info->ctmask = mask;
+		if (c == '-')
+			info->ctmask = value | mask;
+		*flags |= F_MARK;
+		return true;
+
+	case '&': /* --and-mark */
+		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		if (!strtonum(optarg, NULL, &mask, 0, ~0U))
+			param_act(P_BAD_VALUE, "CONNMARK", "--and-mark", optarg);
+		info->mode   = XT_CONNMARK_SET;
+		info->ctmark = 0;
+		info->ctmask = ~mask;
+		*flags      |= F_MARK;
+		return true;
+
+	case '|': /* --or-mark */
+		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+			param_act(P_BAD_VALUE, "CONNMARK", "--or-mark", optarg);
+		info->mode   = XT_CONNMARK_SET;
+		info->ctmark = value;
+		info->ctmask = value;
+		*flags      |= F_MARK;
+		return true;
+
+	case '^': /* --xor-mark */
+		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+			param_act(P_BAD_VALUE, "CONNMARK", "--xor-mark", optarg);
+		info->mode   = XT_CONNMARK_SET;
+		info->ctmark = value;
+		info->ctmask = 0;
+		*flags      |= F_MARK;
+		return true;
+
+	case 'S': /* --save-mark */
+		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		info->mode = XT_CONNMARK_SAVE;
+		*flags |= F_MARK | F_SR_MARK;
+		return true;
+
+	case 'R': /* --restore-mark */
+		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		info->mode = XT_CONNMARK_RESTORE;
+		*flags |= F_MARK | F_SR_MARK;
+		return true;
+
+	case 'n': /* --nfmask */
+		if (!(*flags & F_SR_MARK))
+			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
+			           "or --restore-mark is required for "
+			           "--nfmask");
+		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+			param_act(P_BAD_VALUE, "CONNMARK", "--nfmask", optarg);
+		info->nfmask = value;
+		return true;
+
+	case 'c': /* --ctmask */
+		if (!(*flags & F_SR_MARK))
+			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
+			           "or --restore-mark is required for "
+			           "--ctmask");
+		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+			param_act(P_BAD_VALUE, "CONNMARK", "--ctmask", optarg);
+		info->ctmask = value;
+		return true;
+
+	case 'm': /* --mask */
+		if (!(*flags & F_SR_MARK))
+			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
+			           "or --restore-mark is required for "
+			           "--mask");
+		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+			param_act(P_BAD_VALUE, "CONNMARK", "--mask", optarg);
+		info->nfmask = info->ctmask = value;
+		return true;
+	}
+
+	return false;
+}
+
+static void connmark_tg_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -159,6 +306,50 @@ static void CONNMARK_print(const void *i
 	}
 }
 
+static void
+connmark_tg_print(const void *ip, const struct xt_entry_target *target,
+                  int numeric)
+{
+	const struct xt_connmark_tginfo1 *info = (const void *)target->data;
+
+	switch (info->mode) {
+	case XT_CONNMARK_SET:
+		if (info->ctmark == 0)
+			printf("CONNMARK and 0x%x ",
+			       (unsigned int)(u_int32_t)~info->ctmask);
+		else if (info->ctmark == info->ctmask)
+			printf("CONNMARK or 0x%x ", info->ctmark);
+		else if (info->ctmask == 0)
+			printf("CONNMARK xor 0x%x ", info->ctmark);
+		else
+			printf("CONNMARK xset 0x%x/0x%x ",
+			       info->ctmark, info->ctmask);
+		break;
+	case XT_CONNMARK_SAVE:
+		if (info->nfmask == ~0U && info->ctmask == ~0U)
+			printf("CONNMARK save ");
+		else if (info->nfmask == info->ctmask)
+			printf("CONNMARK save mask 0x%x ", info->nfmask);
+		else
+			printf("CONNMARK save nfmask 0x%x ctmask ~0x%x ",
+			       info->nfmask, info->ctmask);
+		break;
+	case XT_CONNMARK_RESTORE:
+		if (info->ctmask == ~0U && info->nfmask == ~0U)
+			printf("CONNMARK restore ");
+		else if (info->ctmask == info->nfmask)
+			printf("CONNMARK restore mask 0x%x ", info->ctmask);
+		else
+			printf("CONNMARK restore ctmask 0x%x nfmask ~0x%x ",
+			       info->ctmask, info->nfmask);
+		break;
+
+	default:
+		printf("ERROR: UNKNOWN CONNMARK MODE");
+		break;
+	}
+}
+
 /* Saves the target into in parsable form to stdout. */
 static void CONNMARK_save(const void *ip, const struct xt_entry_target *target)
 {
@@ -194,16 +385,40 @@ static void CONNMARK_init(struct xt_entr
 	markinfo->mask = 0xffffffffUL;
 }
 
+static void
+connmark_tg_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_connmark_tginfo1 *info = (const void *)target->data;
+
+	switch (info->mode) {
+	case XT_CONNMARK_SET:
+		printf("--set-xmark 0x%x/0x%x ", info->ctmark, info->ctmask);
+		break;
+	case XT_CONNMARK_SAVE:
+		printf("--save-mark --nfmask 0x%x --ctmask 0x%x ",
+		       info->nfmask, info->ctmask);
+		break;
+	case XT_CONNMARK_RESTORE:
+		printf("--restore-mark --nfmask 0x%x --ctmask 0x%x ",
+		       info->nfmask, info->ctmask);
+		break;
+	default:
+		printf("ERROR: UNKNOWN CONNMARK MODE");
+		break;
+	}
+}
+
 static struct xtables_target connmark_target = {
 	.family		= AF_INET,
 	.name		= "CONNMARK",
+	.revision	= 0,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.help		= CONNMARK_help,
 	.init           = CONNMARK_init,
 	.parse		= CONNMARK_parse,
-	.final_check	= CONNMARK_check,
+	.final_check	= connmark_tg_check,
 	.print		= CONNMARK_print,
 	.save		= CONNMARK_save,
 	.extra_opts	= CONNMARK_opts,
@@ -212,20 +427,55 @@ static struct xtables_target connmark_ta
 static struct xtables_target connmark_target6 = {
 	.family		= AF_INET6,
 	.name		= "CONNMARK",
+	.revision	= 0,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.help		= CONNMARK_help,
 	.init           = CONNMARK_init,
 	.parse		= CONNMARK_parse,
-	.final_check	= CONNMARK_check,
+	.final_check	= connmark_tg_check,
 	.print		= CONNMARK_print,
 	.save		= CONNMARK_save,
 	.extra_opts	= CONNMARK_opts,
 };
 
+static struct xtables_target connmark_tg_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "CONNMARK",
+	.revision       = 1,
+	.family         = AF_INET,
+	.size           = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
+	.userspacesize  = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
+	.help           = connmark_tg_help,
+	.init           = connmark_tg_init,
+	.parse          = connmark_tg_parse,
+	.final_check    = connmark_tg_check,
+	.print          = connmark_tg_print,
+	.save           = connmark_tg_save,
+	.extra_opts     = connmark_tg_opts,
+};
+
+static struct xtables_target connmark_tg6_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "CONNMARK",
+	.revision       = 1,
+	.family         = AF_INET6,
+	.size           = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
+	.userspacesize  = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
+	.help           = connmark_tg_help,
+	.init           = connmark_tg_init,
+	.parse          = connmark_tg_parse,
+	.final_check    = connmark_tg_check,
+	.print          = connmark_tg_print,
+	.save           = connmark_tg_save,
+	.extra_opts     = connmark_tg_opts,
+};
+
 void _init(void)
 {
 	xtables_register_target(&connmark_target);
 	xtables_register_target(&connmark_target6);
+	xtables_register_target(&connmark_tg_reg);
+	xtables_register_target(&connmark_tg6_reg);
 }
Index: iptables-modules/extensions/libxt_CONNMARK.man
===================================================================
--- iptables-modules.orig/extensions/libxt_CONNMARK.man
+++ iptables-modules/extensions/libxt_CONNMARK.man
@@ -1,15 +1,38 @@
-This module sets the netfilter mark value associated with a connection
+This module sets the netfilter mark value associated with a connection.
 .TP
-.B --set-mark mark[/mask]
-Set connection mark. If a mask is specified then only those bits set in the
-mask is modified.
-.TP
-.B --save-mark [--mask mask]
-Copy the netfilter packet mark value to the connection mark. If a mask
-is specified then only those bits are copied.
-.TP
-.B --restore-mark [--mask mask]
-Copy the connection mark value to the packet. If a mask is specified
-then only those bits are copied. This is only valid in the
-.B mangle
-table.
+\fB--set-xmark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+Zero out the bits given by \fImask\fR and XOR \fIvalue\fR into the ctmark.
+.TP
+\fB--save-mark\fR [\fB--nfmask\fR \fInfmask\fR] [\fB--ctmask\fR \fIctmask\fR]
+Copy the packet mark (nfmark) to the connection mark (ctmark) using the given
+masks. The new nfmark value is determined as follows:
+.IP
+ctmark = (ctmark & ~ctmask) ^ (nfmark & nfmask)
+.TP
+i.e. \fIctmask\fR defines what bits to clear and \fInfmask\fR what bits of the
+nfmark to XOR into the ctmark.
+.TP
+\fB--restore-mark\fR [\fB--nfmask\fR \fInfmask\fR] [\fB--ctmask\fR \fIctmask\fR]
+Copy the connection mark (ctmark) to the packet mark (nfmark) using the given
+masks. The new ctmark value is determined as follows:
+.IP
+nfmark = (nfmark & ~\fInfmask\fR) ^ (ctmark & \fIctmask\fR);
+.TP
+i.e. \fInfmask\fR defines what bits to clear and \fIctmask\fR what bits of the
+ctmark to XOR into the nfmark.
+.TP
+\fB--restore-mark\fR is only valid in the \fBmangle\fR table.
+.PP
+The following mnemonics are available for \fB--set-xmark\fR:
+.TP
+\fB--and-mark\fR \fIbits\fR
+Binary AND the ctmark with \fIbits\fR. (Mnemonic for \fB--set-xmark
+0/\fR\fIinvbits\fR, where \fIinvbits\fR is the binary negation of \fIbits\fR.)
+.TP
+\fB--or-mark\fR \fIbits\fR
+Binary OR the ctmark with \fIbits\fR. (Mnemonic for \fB--set-xmark\fR
+\fIbits\fR\fB/\fR\fIbits\fR.)
+.TP
+\fB--xor-mark\fR \fIbits\fR
+Binary XOR the ctmark with \fIbits\fR. (Mnemonic for \fB--set-xmark\fR
+\fIbits\fR\fB/0\fR.)
Index: iptables-modules/include/linux/netfilter/xt_CONNMARK.h
===================================================================
--- iptables-modules.orig/include/linux/netfilter/xt_CONNMARK.h
+++ iptables-modules/include/linux/netfilter/xt_CONNMARK.h
@@ -22,4 +22,9 @@ struct xt_connmark_target_info {
 	u_int8_t mode;
 };
 
+struct xt_connmark_tginfo1 {
+	u_int32_t ctmark, ctmask, nfmask;
+	u_int8_t mode;
+};
+
 #endif /*_XT_CONNMARK_H_target*/
