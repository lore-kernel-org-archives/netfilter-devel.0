From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/17] libipt_NETMAP: use guided option parser
Date: Mon,  9 May 2011 21:55:07 +0200
Message-ID: <1304970912-11520-14-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49368 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab1EITzb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:31 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_NETMAP.c |  106 +++++++-------------------------------------
 1 files changed, 16 insertions(+), 90 deletions(-)

diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 0e85dec..5c4471a 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -1,7 +1,6 @@
 /* Shared library add-on to iptables to add static NAT support.
    Author: Svenning Soerensen <svenning@post5.tele.dk>
 */
-#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -12,9 +11,14 @@
 
 #define MODULENAME "NETMAP"
 
-static const struct option NETMAP_opts[] = {
-	{.name = "to", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+enum {
+	O_TO = 0,
+};
+
+static const struct xt_option_entry NETMAP_opts[] = {
+	{.name = "to", .id = O_TO, .type = XTTYPE_HOSTMASK,
+	 .flags = XTOPT_MAND},
+	XTOPT_TABLEEND,
 };
 
 static void NETMAP_help(void)
@@ -25,18 +29,6 @@ static void NETMAP_help(void)
 	       NETMAP_opts[0].name);
 }
 
-static uint32_t
-bits2netmask(int bits)
-{
-	uint32_t netmask, bm;
-
-	if (bits >= 32 || bits < 0)
-		return(~0);
-	for (netmask = 0, bm = 0x80000000; bits; bits--, bm >>= 1)
-		netmask |= bm;
-	return htonl(netmask);
-}
-
 static int
 netmask2bits(uint32_t netmask)
 {
@@ -57,82 +49,17 @@ static void NETMAP_init(struct xt_entry_target *t)
 
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
-
 }
 
-/* Parses network address */
-static void
-parse_to(char *arg, struct nf_nat_range *range)
+static void NETMAP_parse(struct xt_option_call *cb)
 {
-	char *slash;
-	const struct in_addr *ip;
-	uint32_t netmask;
-	unsigned int bits;
+	struct nf_nat_multi_range *mr = cb->data;
+	struct nf_nat_range *range = &mr->range[0];
 
+	xtables_option_parse(cb);
 	range->flags |= IP_NAT_RANGE_MAP_IPS;
-	slash = strchr(arg, '/');
-	if (slash)
-		*slash = '\0';
-
-	ip = xtables_numeric_to_ipaddr(arg);
-	if (!ip)
-		xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
-			   arg);
-	range->min_ip = ip->s_addr;
-	if (slash) {
-		if (strchr(slash+1, '.')) {
-			ip = xtables_numeric_to_ipmask(slash+1);
-			if (!ip)
-				xtables_error(PARAMETER_PROBLEM, "Bad netmask \"%s\"\n",
-					   slash+1);
-			netmask = ip->s_addr;
-		}
-		else {
-			if (!xtables_strtoui(slash+1, NULL, &bits, 0, 32))
-				xtables_error(PARAMETER_PROBLEM, "Bad netmask \"%s\"\n",
-					   slash+1);
-			netmask = bits2netmask(bits);
-		}
-		/* Don't allow /0 (/1 is probably insane, too) */
-		if (netmask == 0)
-			xtables_error(PARAMETER_PROBLEM, "Netmask needed\n");
-	}
-	else
-		netmask = ~0;
-
-	if (range->min_ip & ~netmask) {
-		if (slash)
-			*slash = '/';
-		xtables_error(PARAMETER_PROBLEM, "Bad network address \"%s\"\n",
-			   arg);
-	}
-	range->max_ip = range->min_ip | ~netmask;
-}
-
-static int NETMAP_parse(int c, char **argv, int invert, unsigned int *flags,
-                        const void *entry, struct xt_entry_target **target)
-{
-	struct nf_nat_multi_range *mr
-		= (struct nf_nat_multi_range *)(*target)->data;
-
-	switch (c) {
-	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --%s", NETMAP_opts[0].name);
-
-		parse_to(optarg, &mr->range[0]);
-		*flags = 1;
-		return 1;
-	}
-	return 0;
-}
-
-static void NETMAP_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   MODULENAME" needs --%s", NETMAP_opts[0].name);
+	range->min_ip = cb->val.haddr.ip & cb->val.hmask.ip;
+	range->max_ip = range->min_ip | ~cb->val.hmask.ip;
 }
 
 static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
@@ -167,11 +94,10 @@ static struct xtables_target netmap_tg_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= NETMAP_help,
 	.init		= NETMAP_init,
-	.parse		= NETMAP_parse,
-	.final_check	= NETMAP_check,
+	.x6_parse	= NETMAP_parse,
 	.print		= NETMAP_print,
 	.save		= NETMAP_save,
-	.extra_opts	= NETMAP_opts,
+	.x6_options	= NETMAP_opts,
 };
 
 void _init(void)
-- 
1.7.1

