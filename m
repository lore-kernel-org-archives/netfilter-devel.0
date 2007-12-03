From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [rfc] using xor in mark targets
Date: Mon, 3 Dec 2007 18:35:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712031832430.11746@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr>
 <474F4AD4.5030502@trash.net> <Pine.LNX.4.64.0711300120310.3089@fbirervta.pbzchgretzou.qr>
 <47541C45.3090804@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47134 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbXLCRfK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:35:10 -0500
In-Reply-To: <47541C45.3090804@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 3 2007 16:09, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> I was asking what name I should give to the option that enables
>> "new-style" handling (origmark & ~mask ^ val):
>> 
>>  --set-extended-mark val/mask
>> 
>> because it is not sooo extended after all, just a different notation of what
>> libxt_MARK takes right now.
>
> Why not simply "--and-mark", "--or-mark", "--xor-mark", ...?
>
Alright, I just saw that MARK will remain compatible to my plans.
But it concerns CONNMARK. See this patch, which introduces --set-xmark.

Assumes a xt_CONNMARK.ko v2 that does:
--set:
	ctmark = (ctmark & info->ctmark_mask) ^ info->ctmark_value;
--save:
	ctmark = (nfmark & info->nfmark_mask) ^ (ctmark & info->ctmark_mask);
--restore:
	nfmark = (nfmark & info->nfmark_mask) ^ (ctmark & info->ctmark_mask);


As you can see, it would introduce a new option "--set-xmark", and
that name does not sound as appalling as --set-mark, so I was looking
for a better one ;-)


---
 extensions/libxt_CONNMARK.c |  266 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 266 insertions(+)

Index: iptables-modules/extensions/libxt_CONNMARK.c
===================================================================
--- iptables-modules.orig/extensions/libxt_CONNMARK.c
+++ iptables-modules/extensions/libxt_CONNMARK.c
@@ -28,6 +28,13 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CONNMARK.h>
 
+enum {
+	F_HALF_SAVE    = 1 << 0,
+	F_HALF_RESTORE = 1 << 1,
+	F_HALF         = F_HALF_SAVE | F_HALF_RESTORE,
+	F_COMPLETE     = 1 << 2,
+};
+
 #if 0
 struct markinfo {
 	struct xt_entry_target t;
@@ -35,6 +42,13 @@ struct markinfo {
 };
 #endif
 
+struct xt_connmark_target_info_v2 {
+	u_int32_t ctmark_value;
+	u_int32_t ctmark_mask;
+	u_int32_t nfmark_mask;
+	u_int8_t mode;
+};
+
 /* Function which prints out usage message. */
 static void CONNMARK_help(void)
 {
@@ -47,6 +61,19 @@ static void CONNMARK_help(void)
 IPTABLES_VERSION);
 }
 
+static void connmark_tg_help(void)
+{
+	printf(
+		"CONNMARK target v%s options:\n"
+		"  --set-xmark value[/mask]         Set conntrack mark value\n"
+		"  --save-mark                      Copy nfmark to ctmark\n"
+		"  --restore-mark                   Copy ctmark to nfmark\n"
+		"  --save-xmark ctmask[/nfmask]     XOR ctmark with nfmark using masks\n"
+		"  --restore-xmark ctmask[/nfmask]  XOR nfmark with ctmark using masks\n"
+		"\n",
+		IPTABLES_VERSION);
+}
+
 static const struct option CONNMARK_opts[] = {
 	{ "set-mark", 1, NULL, '1' },
 	{ "save-mark", 0, NULL, '2' },
@@ -55,6 +82,18 @@ static const struct option CONNMARK_opts
 	{ }
 };
 
+static const struct option connmark_tg_opts[] = {
+	{.name = "set-xmark",     .has_arg = true,  .val = 'A'},
+	{.name = "save-xmark",    .has_arg = true,  .val = 'S'},
+	{.name = "restore-xmark", .has_arg = true,  .val = 'R'},
+	{.name = "save-mark",     .has_arg = false, .val = 's'},
+	{.name = "restore-mark",  .has_arg = false, .val = 'r'},
+	/* Deprecated options, hence not documented: */
+	{.name = "set-mark",      .has_arg = true,  .val = 'a'},
+	{.name = "mask",          .has_arg = false, .val = 'm'},
+	{},
+};
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -112,6 +151,149 @@ CONNMARK_parse(int c, char **argv, int i
 	return 1;
 }
 
+static int
+connmark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_target **target)
+{
+	struct xt_connmark_target_info_v2 *info = (void *)(*target)->data;
+	unsigned int value, mask = ~0U;
+	char *end;
+
+	switch (c) {
+	case 'A': /* --set-xmark */
+		if (*flags & (F_COMPLETE | F_HALF))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: --set-xmark is in "
+			           "conflict with other CONNMARK parameters.");
+		if (!bound_strtou(optarg, &end, &value, 0, ~0U))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Illegal value");
+		if (*end == '/')
+			if (!bound_strtou(optarg, &end, &mask, 0, ~0U))
+				exit_error(PARAMETER_PROBLEM,
+				           "CONNMARK target: Illegal mask");
+		if (*end != '\0')
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Illegal specification");
+		info->mode         = XT_CONNMARK_SET;
+		info->ctmark_value = value;
+		info->ctmark_mask  = mask;
+		*flags            |= F_COMPLETE;
+		break;
+
+	case 'S': /* --save-xmark */
+		if (*flags & (F_COMPLETE | F_HALF))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: --save-xmark is in "
+			           "conflict with other CONNMARK parameters.");
+		if (!bound_strtou(optarg, &end, &value, 0, ~0U))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Illegal ctmask");
+		if (*end == '/')
+			if (!bound_strtou(optarg, &end, &mask, 0, ~0U))
+				exit_error(PARAMETER_PROBLEM,
+				           "CONNMARK target: Illegal nfmask");
+		if (*end != '\0')
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Illegal specification");
+		info->mode        = XT_CONNMARK_SAVE;
+		info->ctmark_mask = value;
+		info->nfmark_mask = mask;
+		*flags           |= F_COMPLETE;
+		break;
+
+	case 'R': /* --restore-xmark */
+		if (*flags & (F_COMPLETE | F_HALF))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: --restore-xmark is in "
+			           "conflict with other CONNMARK parameters.");
+		if (!bound_strtou(optarg, &end, &value, 0, ~0U))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Illegal ctmask");
+		if (*end == '/')
+			if (!bound_strtou(optarg, &end, &mask, 0, ~0U))
+				exit_error(PARAMETER_PROBLEM,
+				           "CONNMARK target: Illegal nfmask");
+		if (*end != '\0')
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Illegal specification");
+		info->mode        = XT_CONNMARK_RESTORE;
+		info->ctmark_mask = value;
+		info->nfmark_mask = mask;
+		*flags           |= F_COMPLETE;
+		break;
+
+	case 'a': /* --set-mark */
+		if (*flags & (F_COMPLETE | F_HALF))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: --set-mark is in "
+			           "conflict with other CONNMARK parameters.");
+		if (!bound_strtou(optarg, &end, &value, 0, ~0U))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Illegal value");
+		if (*end == '/')
+			if (!bound_strtou(optarg, &end, &mask, 0, ~0U))
+				exit_error(PARAMETER_PROBLEM,
+				           "CONNMARK target: Illegal mask");
+		if (*end != '\0')
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Illegal specification");
+		info->mode         = XT_CONNMARK_SET;
+		info->ctmark_value = value;
+		info->ctmark_mask  = ~mask;
+		*flags            |= F_COMPLETE;
+		break;
+
+	case 's': /* --save-mark */
+		if (*flags & (F_COMPLETE | F_HALF))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: --save-mark is in "
+			           "conflict with other CONNMARK parameters.");
+		info->mode        = XT_CONNMARK_SAVE;
+		info->ctmark_mask = ~0U;
+		info->nfmark_mask = 0;
+		*flags           |= F_HALF_SAVE;
+		break;
+
+	case 'r': /* --restore-mark */
+		if (*flags & (F_COMPLETE | F_HALF))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: --restore-mark is in "
+			           "conflict with other CONNMARK parameters.");
+		info->mode        = XT_CONNMARK_RESTORE;
+		info->ctmark_mask = 0;
+		info->nfmark_mask = ~0U;
+		*flags           |= F_HALF_RESTORE;
+		break;
+
+	case 'm':
+		if (!(*flags & F_HALF))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Need --save-mark or "
+			           "--restore-mark for --mask");
+		if (!bound_strtou(optarg, &end, &mask, 0, ~0U))
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Illegal value");
+		if (*end != '\0')
+			exit_error(PARAMETER_PROBLEM,
+			           "CONNMARK target: Illegal specifcation");
+		if (*flags & F_HALF_SAVE) {
+			info->ctmark_mask = ~mask;
+			info->nfmark_mask = mask;
+		} else if (*flags & F_HALF_RESTORE) {
+			info->ctmark_mask = mask;
+			info->nfmark_mask = ~mask;
+		}
+		*flags |= F_COMPLETE;
+		break;
+
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 static void CONNMARK_check(unsigned int flags)
 {
 	if (!flags)
@@ -119,6 +301,13 @@ static void CONNMARK_check(unsigned int 
 		           "CONNMARK target: No operation specified");
 }
 
+static void connmark_tg_check(unsigned int flags)
+{
+	if (!(flags & F_COMPLETE))
+		exit_error(PARAMETER_PROBLEM,
+		           "CONNMARK target: No operation specified");
+}
+
 static void
 print_mark(unsigned long mark)
 {
@@ -161,6 +350,29 @@ static void CONNMARK_print(const void *i
 	}
 }
 
+static void
+connmark_tg_print(const void *ip, const struct xt_entry_target *target,
+                  int numeric)
+{
+	const struct xt_connmark_target_info_v2 *info =
+		(const void *)target->data;
+
+	switch (info->mode) {
+		case XT_CONNMARK_SET:
+			printf("MARK set 0x%x/0x%x ",
+			       info->ctmark_value, info->ctmark_mask);
+			break;
+		case XT_CONNMARK_SAVE:
+			printf("CONNMARK save CT:0x%x NF:0x%x ",
+			       info->ctmark_mask, info->nfmark_mask);
+			break;
+		case XT_CONNMARK_RESTORE:
+			printf("CONNMARK restore CT:0x%x NF:0x%x ",
+			       info->ctmark_mask, info->nfmark_mask);
+			break;
+	}
+}
+
 /* Saves the target into in parsable form to stdout. */
 static void CONNMARK_save(const void *ip, const struct xt_entry_target *target)
 {
@@ -188,6 +400,28 @@ static void CONNMARK_save(const void *ip
 	}
 }
 
+static void
+connmark_tg_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_connmark_target_info_v2 *info =
+		(const void *)target->data;
+
+	switch (info->mode) {
+		case XT_CONNMARK_SET:
+			printf("--set-xmark 0x%x/0x%x ",
+			       info->ctmark_value, info->ctmark_mask);
+			break;
+		case XT_CONNMARK_SAVE:
+			printf("--save-xmark 0x%x/0x%x ",
+			       info->ctmark_mask, info->nfmark_mask);
+			break;
+		case XT_CONNMARK_RESTORE:
+			printf("--restore-mark 0x%x/0x%x ",
+			       info->ctmark_mask, info->nfmark_mask);
+			break;
+	}
+}
+
 static struct xtables_target connmark_target = {
 	.family		= AF_INET,
 	.name		= "CONNMARK",
@@ -216,8 +450,40 @@ static struct xtables_target connmark_ta
 	.extra_opts	= CONNMARK_opts,
 };
 
+static struct xtables_target connmark_tg_reg = {
+	.version       = IPTABLES_VERSION,
+	.name          = "CONNMARK",
+	.revision      = 2,
+	.family        = AF_INET,
+	.size          = XT_ALIGN(sizeof(struct xt_connmark_target_info_v2)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_connmark_target_info_v2)),
+	.help          = connmark_tg_help,
+	.parse         = connmark_tg_parse,
+	.final_check   = connmark_tg_check,
+	.print         = connmark_tg_print,
+	.save          = connmark_tg_save,
+	.extra_opts    = connmark_tg_opts,
+};
+
+static struct xtables_target connmark_tg6_reg = {
+	.version       = IPTABLES_VERSION,
+	.name          = "CONNMARK",
+	.revision      = 2,
+	.family        = AF_INET6,
+	.size          = XT_ALIGN(sizeof(struct xt_connmark_target_info_v2)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_connmark_target_info_v2)),
+	.help          = connmark_tg_help,
+	.parse         = connmark_tg_parse,
+	.final_check   = connmark_tg_check,
+	.print         = connmark_tg_print,
+	.save          = connmark_tg_save,
+	.extra_opts    = connmark_tg_opts,
+};
+
 void _init(void)
 {
 	xtables_register_target(&connmark_target);
 	xtables_register_target(&connmark_target6);
+	xtables_register_target(&connmark_tg_reg);
+	xtables_register_target(&connmark_tg6_reg);
 }
