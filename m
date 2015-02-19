From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/7] extensions: remove SAME target
Date: Thu, 19 Feb 2015 14:11:18 +0100
Message-ID: <1424351483-27617-3-git-send-email-fw@strlen.de>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58478 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbbBSNLq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:11:46 -0500
In-Reply-To: <1424351483-27617-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

removed from the kernel December 2007.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libipt_SAME.c                | 186 --------------------------------
 extensions/libipt_SAME.man              |  17 ---
 include/linux/netfilter_ipv4/ipt_SAME.h |  20 ----
 3 files changed, 223 deletions(-)
 delete mode 100644 extensions/libipt_SAME.c
 delete mode 100644 extensions/libipt_SAME.man
 delete mode 100644 include/linux/netfilter_ipv4/ipt_SAME.h

diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
deleted file mode 100644
index 5d5bf63..0000000
--- a/extensions/libipt_SAME.c
+++ /dev/null
@@ -1,186 +0,0 @@
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <xtables.h>
-#include <linux/netfilter/nf_nat.h>
-#include <linux/netfilter_ipv4/ipt_SAME.h>
-
-enum {
-	O_TO_ADDR = 0,
-	O_NODST,
-	O_RANDOM,
-	F_TO_ADDR = 1 << O_TO_ADDR,
-	F_RANDOM  = 1 << O_RANDOM,
-};
-
-static void SAME_help(void)
-{
-	printf(
-"SAME target options:\n"
-" --to <ipaddr>-<ipaddr>\n"
-"				Addresses to map source to.\n"
-"				 May be specified more than\n"
-"				  once for multiple ranges.\n"
-" --nodst\n"
-"				Don't use destination-ip in\n"
-"				           source selection\n"
-" --random\n"
-"				Randomize source port\n");
-}
-
-static const struct xt_option_entry SAME_opts[] = {
-	{.name = "to", .id = O_TO_ADDR, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND},
-	{.name = "nodst", .id = O_NODST, .type = XTTYPE_NONE},
-	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
-	XTOPT_TABLEEND,
-};
-
-/* Parses range of IPs */
-static void parse_to(const char *orig_arg, struct nf_nat_ipv4_range *range)
-{
-	char *dash, *arg;
-	const struct in_addr *ip;
-
-	arg = strdup(orig_arg);
-	if (arg == NULL)
-		xtables_error(RESOURCE_PROBLEM, "strdup");
-	range->flags |= NF_NAT_RANGE_MAP_IPS;
-	dash = strchr(arg, '-');
-
-	if (dash)
-		*dash = '\0';
-
-	ip = xtables_numeric_to_ipaddr(arg);
-	if (!ip)
-		xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
-			   arg);
-	range->min_ip = ip->s_addr;
-
-	if (dash) {
-		ip = xtables_numeric_to_ipaddr(dash+1);
-		if (!ip)
-			xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
-				   dash+1);
-	}
-	range->max_ip = ip->s_addr;
-	if (dash)
-		if (range->min_ip > range->max_ip)
-			xtables_error(PARAMETER_PROBLEM, "Bad IP range \"%s-%s\"\n",
-				   arg, dash+1);
-	free(arg);
-}
-
-static void SAME_parse(struct xt_option_call *cb)
-{
-	struct ipt_same_info *mr = cb->data;
-	unsigned int count;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_TO_ADDR:
-		if (mr->rangesize == IPT_SAME_MAX_RANGE)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Too many ranges specified, maximum "
-				   "is %i ranges.\n",
-				   IPT_SAME_MAX_RANGE);
-		parse_to(cb->arg, &mr->range[mr->rangesize]);
-		mr->rangesize++;
-		break;
-	case O_NODST:
-		mr->info |= IPT_SAME_NODST;
-		break;
-	case O_RANDOM:
-		for (count=0; count < mr->rangesize; count++)
-			mr->range[count].flags |= NF_NAT_RANGE_PROTO_RANDOM;
-		break;
-	}
-}
-
-static void SAME_fcheck(struct xt_fcheck_call *cb)
-{
-	static const unsigned int f = F_TO_ADDR | F_RANDOM;
-	struct ipt_same_info *mr = cb->data;
-	unsigned int count;
-
-	if ((cb->xflags & f) == f)
-		for (count = 0; count < mr->rangesize; ++count)
-			mr->range[count].flags |= NF_NAT_RANGE_PROTO_RANDOM;
-}
-
-static void SAME_print(const void *ip, const struct xt_entry_target *target,
-                       int numeric)
-{
-	unsigned int count;
-	const struct ipt_same_info *mr = (const void *)target->data;
-	int random_selection = 0;
-	
-	printf(" same:");
-
-	for (count = 0; count < mr->rangesize; count++) {
-		const struct nf_nat_ipv4_range *r = &mr->range[count];
-		struct in_addr a;
-
-		a.s_addr = r->min_ip;
-
-		printf("%s", xtables_ipaddr_to_numeric(&a));
-		a.s_addr = r->max_ip;
-		
-		if (r->min_ip != r->max_ip)
-			printf("-%s", xtables_ipaddr_to_numeric(&a));
-		if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
-			random_selection = 1;
-	}
-	
-	if (mr->info & IPT_SAME_NODST)
-		printf(" nodst");
-
-	if (random_selection)
-		printf(" random");
-}
-
-static void SAME_save(const void *ip, const struct xt_entry_target *target)
-{
-	unsigned int count;
-	const struct ipt_same_info *mr = (const void *)target->data;
-	int random_selection = 0;
-
-	for (count = 0; count < mr->rangesize; count++) {
-		const struct nf_nat_ipv4_range *r = &mr->range[count];
-		struct in_addr a;
-
-		a.s_addr = r->min_ip;
-		printf(" --to %s", xtables_ipaddr_to_numeric(&a));
-		a.s_addr = r->max_ip;
-
-		if (r->min_ip != r->max_ip)
-			printf("-%s", xtables_ipaddr_to_numeric(&a));
-		if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
-			random_selection = 1;
-	}
-	
-	if (mr->info & IPT_SAME_NODST)
-		printf(" --nodst");
-
-	if (random_selection)
-		printf(" --random");
-}
-
-static struct xtables_target same_tg_reg = {
-	.name		= "SAME",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct ipt_same_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct ipt_same_info)),
-	.help		= SAME_help,
-	.x6_parse	= SAME_parse,
-	.x6_fcheck	= SAME_fcheck,
-	.print		= SAME_print,
-	.save		= SAME_save,
-	.x6_options	= SAME_opts,
-};
-
-void _init(void)
-{
-	xtables_register_target(&same_tg_reg);
-}
diff --git a/extensions/libipt_SAME.man b/extensions/libipt_SAME.man
deleted file mode 100644
index a99dc73..0000000
--- a/extensions/libipt_SAME.man
+++ /dev/null
@@ -1,17 +0,0 @@
-Similar to SNAT/DNAT depending on chain: it takes a range of addresses
-(`\-\-to 1.2.3.4\-1.2.3.7') and gives a client the same
-source-/destination-address for each connection.
-.PP
-N.B.: The DNAT target's \fB\-\-persistent\fP option replaced the SAME target.
-.TP
-\fB\-\-to\fP \fIipaddr\fP[\fB\-\fP\fIipaddr\fP]
-Addresses to map source to. May be specified more than once for
-multiple ranges.
-.TP
-\fB\-\-nodst\fP
-Don't use the destination-ip in the calculations when selecting the
-new source-ip
-.TP
-\fB\-\-random\fP
-Port mapping will be forcibly randomized to avoid attacks based on 
-port prediction (kernel >= 2.6.21).
diff --git a/include/linux/netfilter_ipv4/ipt_SAME.h b/include/linux/netfilter_ipv4/ipt_SAME.h
deleted file mode 100644
index a855167..0000000
--- a/include/linux/netfilter_ipv4/ipt_SAME.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef _IPT_SAME_H
-#define _IPT_SAME_H
-
-#include <linux/types.h>
-
-#define IPT_SAME_MAX_RANGE	10
-
-#define IPT_SAME_NODST		0x01
-
-struct ipt_same_info {
-	unsigned char info;
-	__u32 rangesize;
-	__u32 ipnum;
-	__u32 *iparray;
-
-	/* hangs off end. */
-	struct nf_nat_ipv4_range range[IPT_SAME_MAX_RANGE];
-};
-
-#endif /*_IPT_SAME_H*/
-- 
2.0.5

