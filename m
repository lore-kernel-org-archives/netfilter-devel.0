From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/11] libipt_SAME: use guided option parser
Date: Wed, 11 May 2011 15:52:56 +0200
Message-ID: <1305121977-4361-12-git-send-email-jengelh@medozas.de>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60358 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab1EKPsQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:16 -0400
In-Reply-To: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_SAME.c |   82 +++++++++++++++++-----------------------------
 1 files changed, 30 insertions(+), 52 deletions(-)

diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index b18351e..2ff6c82 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -1,15 +1,17 @@
-/* Shared library add-on to iptables to add simple non load-balancing SNAT support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <net/netfilter/nf_nat.h>
-/* For 64bit kernel / 32bit userspace */
 #include <linux/netfilter_ipv4/ipt_SAME.h>
 
+enum {
+	O_TO_ADDR = 0,
+	O_NODST,
+	O_RANDOM,
+	F_RANDOM = 1 << O_RANDOM,
+};
+
 static void SAME_help(void)
 {
 	printf(
@@ -25,20 +27,23 @@ static void SAME_help(void)
 "				Randomize source port\n");
 }
 
-static const struct option SAME_opts[] = {
-	{.name = "to",     .has_arg = true,  .val = '1'},
-	{.name = "nodst",  .has_arg = false, .val = '2'},
-	{.name = "random", .has_arg = false, .val = '3'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry SAME_opts[] = {
+	{.name = "to", .id = O_TO_ADDR, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	{.name = "nodst", .id = O_NODST, .type = XTTYPE_NONE},
+	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
 /* Parses range of IPs */
-static void
-parse_to(char *arg, struct nf_nat_range *range)
+static void parse_to(const char *orig_arg, struct nf_nat_range *range)
 {
-	char *dash;
+	char *dash, *arg;
 	const struct in_addr *ip;
 
+	arg = strdup(orig_arg);
+	if (arg == NULL)
+		xtables_error(RESOURCE_PROBLEM, "strdup");
 	range->flags |= IP_NAT_RANGE_MAP_IPS;
 	dash = strchr(arg, '-');
 
@@ -62,63 +67,37 @@ parse_to(char *arg, struct nf_nat_range *range)
 		if (range->min_ip > range->max_ip)
 			xtables_error(PARAMETER_PROBLEM, "Bad IP range \"%s-%s\"\n",
 				   arg, dash+1);
+	free(arg);
 }
 
-#define IPT_SAME_OPT_TO			0x01
-#define IPT_SAME_OPT_NODST		0x02
-#define IPT_SAME_OPT_RANDOM		0x04
-
-static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
-                      const void *entry, struct xt_entry_target **target)
+static void SAME_parse(struct xt_option_call *cb)
 {
-	struct ipt_same_info *mr
-		= (struct ipt_same_info *)(*target)->data;
+	struct ipt_same_info *mr = cb->data;
 	unsigned int count;
 
-	switch (c) {
-	case '1':
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_TO_ADDR:
 		if (mr->rangesize == IPT_SAME_MAX_RANGE)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Too many ranges specified, maximum "
 				   "is %i ranges.\n",
 				   IPT_SAME_MAX_RANGE);
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --to");
-
-		parse_to(optarg, &mr->range[mr->rangesize]);
+		parse_to(cb->arg, &mr->range[mr->rangesize]);
 		/* WTF do we need this for? */
-		if (*flags & IPT_SAME_OPT_RANDOM)
+		if (cb->xflags & F_RANDOM)
 			mr->range[mr->rangesize].flags 
 				|= IP_NAT_RANGE_PROTO_RANDOM;
 		mr->rangesize++;
-		*flags |= IPT_SAME_OPT_TO;
 		break;
-		
-	case '2':
-		if (*flags & IPT_SAME_OPT_NODST)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --nodst twice");
-		
+	case O_NODST:
 		mr->info |= IPT_SAME_NODST;
-		*flags |= IPT_SAME_OPT_NODST;
 		break;
-
-	case '3':	
-		*flags |= IPT_SAME_OPT_RANDOM;
+	case O_RANDOM:
 		for (count=0; count < mr->rangesize; count++)
 			mr->range[count].flags |= IP_NAT_RANGE_PROTO_RANDOM;
 		break;
 	}
-	
-	return 1;
-}
-
-static void SAME_check(unsigned int flags)
-{
-	if (!(flags & IPT_SAME_OPT_TO))
-		xtables_error(PARAMETER_PROBLEM,
-			   "SAME needs --to");
 }
 
 static void SAME_print(const void *ip, const struct xt_entry_target *target,
@@ -186,11 +165,10 @@ static struct xtables_target same_tg_reg = {
 	.size		= XT_ALIGN(sizeof(struct ipt_same_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_same_info)),
 	.help		= SAME_help,
-	.parse		= SAME_parse,
-	.final_check	= SAME_check,
+	.x6_parse	= SAME_parse,
 	.print		= SAME_print,
 	.save		= SAME_save,
-	.extra_opts	= SAME_opts,
+	.x6_options	= SAME_opts,
 };
 
 void _init(void)
-- 
1.7.1

