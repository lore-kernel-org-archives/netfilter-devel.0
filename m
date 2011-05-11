From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/11] libipt_REDIRECT: use guided option parser
Date: Wed, 11 May 2011 15:52:55 +0200
Message-ID: <1305121977-4361-11-git-send-email-jengelh@medozas.de>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53156 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab1EKQIQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 12:08:16 -0400
In-Reply-To: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_REDIRECT.c |   62 +++++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 37 deletions(-)

diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 471ff29..426a746 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -1,17 +1,17 @@
-/* Shared library add-on to iptables to add redirect support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/netfilter/nf_nat.h>
 
-#define IPT_REDIRECT_OPT_DEST	0x01
-#define IPT_REDIRECT_OPT_RANDOM	0x02
+enum {
+	O_TO_PORTS = 0,
+	O_RANDOM,
+	F_TO_PORTS = 1 << O_TO_PORTS,
+	F_RANDOM   = 1 << O_RANDOM,
+};
 
 static void REDIRECT_help(void)
 {
@@ -22,10 +22,11 @@ static void REDIRECT_help(void)
 " [--random]\n");
 }
 
-static const struct option REDIRECT_opts[] = {
-	{.name = "to-ports", .has_arg = true,  .val = '1'},
-	{.name = "random",   .has_arg = false, .val = '2'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry REDIRECT_opts[] = {
+	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
 static void REDIRECT_init(struct xt_entry_target *t)
@@ -34,7 +35,6 @@ static void REDIRECT_init(struct xt_entry_target *t)
 
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
-
 }
 
 /* Parses ports */
@@ -73,12 +73,10 @@ parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 	xtables_param_act(XTF_BAD_VALUE, "REDIRECT", "--to-ports", arg);
 }
 
-static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
-                          const void *e, struct xt_entry_target **target)
+static void REDIRECT_parse(struct xt_option_call *cb)
 {
-	const struct ipt_entry *entry = e;
-	struct nf_nat_multi_range *mr
-		= (struct nf_nat_multi_range *)(*target)->data;
+	const struct ipt_entry *entry = cb->xt_entry;
+	struct nf_nat_multi_range *mr = (void *)(*cb->target)->data;
 	int portok;
 
 	if (entry->ip.proto == IPPROTO_TCP
@@ -90,31 +88,21 @@ static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
 	else
 		portok = 0;
 
-	switch (c) {
-	case '1':
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_TO_PORTS:
 		if (!portok)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
-
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --to-ports");
-
-		parse_ports(optarg, mr);
-		if (*flags & IPT_REDIRECT_OPT_RANDOM)
+		parse_ports(cb->arg, mr);
+		if (cb->xflags & F_RANDOM)
 			mr->range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
-		*flags |= IPT_REDIRECT_OPT_DEST;
-		return 1;
-
-	case '2':
-		if (*flags & IPT_REDIRECT_OPT_DEST) {
+		break;
+	case O_RANDOM:
+		if (cb->xflags & F_TO_PORTS)
 			mr->range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
-			*flags |= IPT_REDIRECT_OPT_RANDOM;
-		} else
-			*flags |= IPT_REDIRECT_OPT_RANDOM;
-		return 1;
+		break;
 	}
-	return 0;
 }
 
 static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
@@ -156,10 +144,10 @@ static struct xtables_target redirect_tg_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= REDIRECT_help,
 	.init		= REDIRECT_init,
- 	.parse		= REDIRECT_parse,
+ 	.x6_parse	= REDIRECT_parse,
 	.print		= REDIRECT_print,
 	.save		= REDIRECT_save,
-	.extra_opts	= REDIRECT_opts,
+	.x6_options	= REDIRECT_opts,
 };
 
 void _init(void)
-- 
1.7.1

