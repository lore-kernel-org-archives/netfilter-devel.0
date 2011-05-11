From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/11] libipt_DNAT: use guided option parser
Date: Wed, 11 May 2011 15:52:52 +0200
Message-ID: <1305121977-4361-8-git-send-email-jengelh@medozas.de>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58265 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab1EKP6Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 11:58:16 -0400
In-Reply-To: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_DNAT.c |   88 ++++++++++++++++++++-------------------------
 1 files changed, 39 insertions(+), 49 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 49c74e1..e7fd7c9 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -1,18 +1,20 @@
-/* Shared library add-on to iptables to add destination-NAT support. */
-#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <iptables.h> /* get_kernel_version */
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/netfilter/nf_nat.h>
 
-#define IPT_DNAT_OPT_DEST 0x1
-#define IPT_DNAT_OPT_RANDOM 0x2
+enum {
+	O_TO_DEST = 0,
+	O_RANDOM,
+	O_PERSISTENT,
+	F_TO_DEST = 1 << O_TO_DEST,
+	F_RANDOM  = 1 << O_RANDOM,
+};
 
 /* Dest NAT data consists of a multi-range, indicating where to map
    to. */
@@ -31,11 +33,12 @@ static void DNAT_help(void)
 "[--random] [--persistent]\n");
 }
 
-static const struct option DNAT_opts[] = {
-	{.name = "to-destination", .has_arg = true,  .val = '1'},
-	{.name = "random",         .has_arg = false, .val = '2'},
-	{.name = "persistent",     .has_arg = false, .val = '3'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry DNAT_opts[] = {
+	{.name = "to-destination", .id = O_TO_DEST, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_MULTI},
+	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
+	{.name = "persistent", .id = O_PERSISTENT, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
 static struct ipt_natinfo *
@@ -59,12 +62,15 @@ append_range(struct ipt_natinfo *info, const struct nf_nat_range *range)
 
 /* Ranges expected in network order. */
 static struct xt_entry_target *
-parse_to(char *arg, int portok, struct ipt_natinfo *info)
+parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 {
 	struct nf_nat_range range;
-	char *colon, *dash, *error;
+	char *arg, *colon, *dash, *error;
 	const struct in_addr *ip;
 
+	arg = strdup(orig_arg);
+	if (arg == NULL)
+		xtables_error(RESOURCE_PROBLEM, "strdup");
 	memset(&range, 0, sizeof(range));
 	colon = strchr(arg, ':');
 
@@ -107,8 +113,10 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 			range.max.tcp.port = htons(maxport);
 		}
 		/* Starts with a colon? No IP info...*/
-		if (colon == arg)
+		if (colon == arg) {
+			free(arg);
 			return &(append_range(info, &range)->t);
+		}
 		*colon = '\0';
 	}
 
@@ -134,14 +142,14 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 	} else
 		range.max_ip = range.min_ip;
 
+	free(arg);
 	return &(append_range(info, &range)->t);
 }
 
-static int DNAT_parse(int c, char **argv, int invert, unsigned int *flags,
-                      const void *e, struct xt_entry_target **target)
+static void DNAT_parse(struct xt_option_call *cb)
 {
-	const struct ipt_entry *entry = e;
-	struct ipt_natinfo *info = (void *)*target;
+	const struct ipt_entry *entry = cb->xt_entry;
+	struct ipt_natinfo *info = (void *)(*cb->target);
 	int portok;
 
 	if (entry->ip.proto == IPPROTO_TCP
@@ -153,46 +161,29 @@ static int DNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 	else
 		portok = 0;
 
-	switch (c) {
-	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --to-destination");
-
-		if (*flags & IPT_DNAT_OPT_DEST) {
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_TO_DEST:
+		if (cb->xflags & F_TO_DEST) {
 			if (!kernel_version)
 				get_kernel_version();
 			if (kernel_version > LINUX_VERSION(2, 6, 10))
 				xtables_error(PARAMETER_PROBLEM,
 					   "Multiple --to-destination not supported");
 		}
-		*target = parse_to(optarg, portok, info);
+		*cb->target = parse_to(cb->arg, portok, info);
 		/* WTF do we need this for?? */
-		if (*flags & IPT_DNAT_OPT_RANDOM)
+		if (cb->xflags & F_RANDOM)
 			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
-		*flags |= IPT_DNAT_OPT_DEST;
-		return 1;
-
-	case '2':
-		if (*flags & IPT_DNAT_OPT_DEST) {
+		break;
+	case O_RANDOM:
+		if (cb->xflags & F_TO_DEST)
 			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
-			*flags |= IPT_DNAT_OPT_RANDOM;
-		} else
-			*flags |= IPT_DNAT_OPT_RANDOM;
-		return 1;
-
-	case '3':
+		break;
+	case O_PERSISTENT:
 		info->mr.range[0].flags |= IP_NAT_RANGE_PERSISTENT;
-		return 1;
+		break;
 	}
-	return 0;
-}
-
-static void DNAT_check(unsigned int flags)
-{
-	if (!(flags & IPT_DNAT_OPT_DEST))
-		xtables_error(PARAMETER_PROBLEM,
-			   "You must specify --to-destination");
 }
 
 static void print_range(const struct nf_nat_range *r)
@@ -253,11 +244,10 @@ static struct xtables_target dnat_tg_reg = {
 	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= DNAT_help,
-	.parse		= DNAT_parse,
-	.final_check	= DNAT_check,
+	.x6_parse	= DNAT_parse,
 	.print		= DNAT_print,
 	.save		= DNAT_save,
-	.extra_opts	= DNAT_opts,
+	.x6_options	= DNAT_opts,
 };
 
 void _init(void)
-- 
1.7.1

