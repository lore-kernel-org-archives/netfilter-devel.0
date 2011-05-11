From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/11] libipt_MASQUERADE: use guided option parser
Date: Wed, 11 May 2011 15:52:54 +0200
Message-ID: <1305121977-4361-10-git-send-email-jengelh@medozas.de>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53157 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868Ab1EKQIQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 12:08:16 -0400
In-Reply-To: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_MASQUERADE.c |   48 +++++++++++++++++----------------------
 1 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 00baf25..7ba42df 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -1,5 +1,3 @@
-/* Shared library add-on to iptables to add masquerade support. */
-#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -10,6 +8,11 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/netfilter/nf_nat.h>
 
+enum {
+	O_TO_PORTS = 0,
+	O_RANDOM,
+};
+
 static void MASQUERADE_help(void)
 {
 	printf(
@@ -20,10 +23,10 @@ static void MASQUERADE_help(void)
 "				Randomize source port.\n");
 }
 
-static const struct option MASQUERADE_opts[] = {
-	{.name = "to-ports", .has_arg = true,  .val = '1'},
-	{.name = "random",   .has_arg = false, .val = '2'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry MASQUERADE_opts[] = {
+	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING},
+	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
 static void MASQUERADE_init(struct xt_entry_target *t)
@@ -32,7 +35,6 @@ static void MASQUERADE_init(struct xt_entry_target *t)
 
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
-
 }
 
 /* Parses ports */
@@ -69,13 +71,11 @@ parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 	xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
 }
 
-static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
-                            const void *e, struct xt_entry_target **target)
+static void MASQUERADE_parse(struct xt_option_call *cb)
 {
-	const struct ipt_entry *entry = e;
+	const struct ipt_entry *entry = cb->xt_entry;
 	int portok;
-	struct nf_nat_multi_range *mr
-		= (struct nf_nat_multi_range *)(*target)->data;
+	struct nf_nat_multi_range *mr = cb->data;
 
 	if (entry->ip.proto == IPPROTO_TCP
 	    || entry->ip.proto == IPPROTO_UDP
@@ -86,24 +86,18 @@ static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
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
-		return 1;
-
-	case '2':
+		parse_ports(cb->arg, mr);
+		break;
+	case O_RANDOM:
 		mr->range[0].flags |=  IP_NAT_RANGE_PROTO_RANDOM;
-		return 1;
+		break;
 	}
-	return 0;
 }
 
 static void
@@ -148,10 +142,10 @@ static struct xtables_target masquerade_tg_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= MASQUERADE_help,
 	.init		= MASQUERADE_init,
-	.parse		= MASQUERADE_parse,
+	.x6_parse	= MASQUERADE_parse,
 	.print		= MASQUERADE_print,
 	.save		= MASQUERADE_save,
-	.extra_opts	= MASQUERADE_opts,
+	.x6_options	= MASQUERADE_opts,
 };
 
 void _init(void)
-- 
1.7.1

