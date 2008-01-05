From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 9/21] libxt_connmark match, revision 1
Date: Sat, 5 Jan 2008 15:45:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801051544480.14194@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37241 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbYAEOpF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:45:05 -0500
In-Reply-To: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for xt_connmark match revision 1.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_connmark.c           |  146 +++++++++++++++++++++++++++-------
 extensions/libxt_connmark.man         |    9 --
 include/linux/netfilter/xt_connmark.h |    5 +
 3 files changed, 124 insertions(+), 36 deletions(-)

Index: iptables-modules/extensions/libxt_connmark.c
===================================================================
--- iptables-modules.orig/extensions/libxt_connmark.c
+++ iptables-modules/extensions/libxt_connmark.c
@@ -28,21 +28,52 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_connmark.h>
 
-/* Function which prints out usage message. */
-static void connmark_help(void)
+enum {
+	F_MARK = 1 << 0,
+};
+
+static void connmark_mt_help(void)
 {
 	printf(
-"CONNMARK match v%s options:\n"
-"[!] --mark value[/mask]         Match nfmark value with optional mask\n"
-"\n",
-IPTABLES_VERSION);
+"connmark match options:\n"
+"[!] --mark value[/mask]    Match ctmark value with optional mask\n"
+"\n");
 }
 
-static const struct option connmark_opts[] = {
-	{ "mark", 1, NULL, '1' },
-	{ }
+static const struct option connmark_mt_opts[] = {
+	{.name = "mark", .has_arg = true, .val = '1'},
+	{},
 };
 
+static int
+connmark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_match **match)
+{
+	struct xt_connmark_mtinfo1 *info = (void *)(*match)->data;
+	unsigned int mark, mask = ~0U;
+	char *end;
+
+	switch (c) {
+	case '1': /* --mark */
+		param_act(P_ONLY_ONCE, "connmark", "--mark", *flags & F_MARK);
+		if (!strtonum(optarg, &end, &mark, 0, ~0U))
+			param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
+		if (*end == '/')
+			if (!strtonum(end + 1, &end, &mask, 0, ~0U))
+				param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
+		if (*end != '\0')
+			param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
+
+		if (invert)
+			info->invert = true;
+		info->mark = mark;
+		info->mask = mask;
+		*flags    |= F_MARK;
+		return true;
+	}
+	return false;
+}
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -75,21 +106,19 @@ connmark_parse(int c, char **argv, int i
 	return 1;
 }
 
-static void
-print_mark(unsigned long mark, unsigned long mask, int numeric)
+static void print_mark(unsigned int mark, unsigned int mask)
 {
-	if(mask != 0xffffffffUL)
-		printf("0x%lx/0x%lx ", mark, mask);
+	if (mask != 0xffffffffU)
+		printf("0x%x/0x%x ", mark, mask);
 	else
-		printf("0x%lx ", mark);
+		printf("0x%x ", mark);
 }
 
-/* Final check; must have specified --mark. */
-static void connmark_check(unsigned int flags)
+static void connmark_mt_check(unsigned int flags)
 {
-	if (!flags)
+	if (flags == 0)
 		exit_error(PARAMETER_PROBLEM,
-			   "MARK match: You must specify `--mark'");
+		           "connmark: The --mark option is required");
 }
 
 /* Prints out the matchinfo. */
@@ -101,7 +130,18 @@ connmark_print(const void *ip, const str
 	printf("CONNMARK match ");
 	if (info->invert)
 		printf("!");
-	print_mark(info->mark, info->mask, numeric);
+	print_mark(info->mark, info->mask);
+}
+
+static void
+connmark_mt_print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_connmark_mtinfo1 *info = (const void *)match->data;
+
+	printf("connmark match ");
+	if (info->invert)
+		printf("!");
+	print_mark(info->mark, info->mask);
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
@@ -113,39 +153,85 @@ static void connmark_save(const void *ip
 		printf("! ");
 
 	printf("--mark ");
-	print_mark(info->mark, info->mask, 0);
+	print_mark(info->mark, info->mask);
+}
+
+static void
+connmark_mt_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_connmark_mtinfo1 *info = (const void *)match->data;
+
+	if (info->invert)
+		printf("! ");
+
+	printf("--mark ");
+	print_mark(info->mark, info->mask);
 }
 
-static struct xtables_match connmark_match = {
+static struct xtables_match connmark_mt_reg_v0 = {
 	.family		= AF_INET,
 	.name		= "connmark",
+	.revision	= 0,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_info)),
-	.help		= connmark_help,
+	.help		= connmark_mt_help,
 	.parse		= connmark_parse,
-	.final_check	= connmark_check,
+	.final_check	= connmark_mt_check,
 	.print		= connmark_print,
 	.save		= connmark_save,
-	.extra_opts	= connmark_opts,
+	.extra_opts	= connmark_mt_opts,
 };
 
-static struct xtables_match connmark_match6 = {
+static struct xtables_match connmark_mt6_reg_v0 = {
 	.family		= AF_INET6,
 	.name		= "connmark",
+	.revision	= 0,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_info)),
-	.help		= connmark_help,
+	.help		= connmark_mt_help,
 	.parse		= connmark_parse,
-	.final_check	= connmark_check,
+	.final_check	= connmark_mt_check,
 	.print		= connmark_print,
 	.save		= connmark_save,
-	.extra_opts	= connmark_opts,
+	.extra_opts	= connmark_mt_opts,
+};
+
+static struct xtables_match connmark_mt_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "connmark",
+	.revision       = 1,
+	.family         = AF_INET,
+	.size           = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
+	.userspacesize  = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
+	.help           = connmark_mt_help,
+	.parse          = connmark_mt_parse,
+	.final_check    = connmark_mt_check,
+	.print          = connmark_mt_print,
+	.save           = connmark_mt_save,
+	.extra_opts     = connmark_mt_opts,
+};
+
+static struct xtables_match connmark_mt6_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "connmark",
+	.revision       = 1,
+	.family         = AF_INET6,
+	.size           = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
+	.userspacesize  = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
+	.help           = connmark_mt_help,
+	.parse          = connmark_mt_parse,
+	.final_check    = connmark_mt_check,
+	.print          = connmark_mt_print,
+	.save           = connmark_mt_save,
+	.extra_opts     = connmark_mt_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&connmark_match);
-	xtables_register_match(&connmark_match6);
+	xtables_register_match(&connmark_mt_reg_v0);
+	xtables_register_match(&connmark_mt6_reg_v0);
+	xtables_register_match(&connmark_mt_reg);
+	xtables_register_match(&connmark_mt6_reg);
 }
Index: iptables-modules/extensions/libxt_connmark.man
===================================================================
--- iptables-modules.orig/extensions/libxt_connmark.man
+++ iptables-modules/extensions/libxt_connmark.man
@@ -1,9 +1,6 @@
 This module matches the netfilter mark field associated with a connection
-(which can be set using the
-.B CONNMARK
-target below).
+(which can be set using the \fBCONNMARK\fR target below).
 .TP
-.BI "--mark " "value[/mask]"
+\fB--mark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
 Matches packets in connections with the given mark value (if a mask is
-specified, this is logically ANDed with the mark before the
-comparison).
+specified, this is logically ANDed with the mark before the comparison).
Index: iptables-modules/include/linux/netfilter/xt_connmark.h
===================================================================
--- iptables-modules.orig/include/linux/netfilter/xt_connmark.h
+++ iptables-modules/include/linux/netfilter/xt_connmark.h
@@ -15,4 +15,9 @@ struct xt_connmark_info {
 	u_int8_t invert;
 };
 
+struct xt_connmark_mtinfo1 {
+	u_int32_t mark, mask;
+	u_int8_t invert;
+};
+
 #endif /*_XT_CONNMARK_H*/
