From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/11] libipt_CLUSTERIP: use guided option parser
Date: Wed, 11 May 2011 15:52:50 +0200
Message-ID: <1305121977-4361-6-git-send-email-jengelh@medozas.de>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58955 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab1EKPxR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 11:53:17 -0400
In-Reply-To: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_CLUSTERIP.c |  157 ++++++++++++++---------------------------
 1 files changed, 52 insertions(+), 105 deletions(-)

diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index f7f46d1..301e0e1 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -19,6 +19,22 @@
 #include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 
+enum {
+	O_NEW = 0,
+	O_HASHMODE,
+	O_CLUSTERMAC,
+	O_TOTAL_NODES,
+	O_LOCAL_NODE,
+	O_HASH_INIT,
+	F_NEW         = 1 << O_NEW,
+	F_HASHMODE    = 1 << O_HASHMODE,
+	F_CLUSTERMAC  = 1 << O_CLUSTERMAC,
+	F_TOTAL_NODES = 1 << O_TOTAL_NODES,
+	F_LOCAL_NODE  = 1 << O_LOCAL_NODE,
+	F_FULL        = F_NEW | F_HASHMODE | F_CLUSTERMAC |
+	                F_TOTAL_NODES | F_LOCAL_NODE,
+};
+
 static void CLUSTERIP_help(void)
 {
 	printf(
@@ -34,130 +50,61 @@ static void CLUSTERIP_help(void)
 "  --hash-init <num>		 Set init value of the Jenkins hash\n");
 }
 
-#define	PARAM_NEW	0x0001
-#define PARAM_HMODE	0x0002
-#define PARAM_MAC	0x0004
-#define PARAM_TOTALNODE	0x0008
-#define PARAM_LOCALNODE	0x0010
-#define PARAM_HASHINIT	0x0020
-
-static const struct option CLUSTERIP_opts[] = {
-	{.name = "new",         .has_arg = false, .val = '1'},
-	{.name = "hashmode",    .has_arg = true,  .val = '2'},
-	{.name = "clustermac",  .has_arg = true,  .val = '3'},
-	{.name = "total-nodes", .has_arg = true,  .val = '4'},
-	{.name = "local-node",  .has_arg = true,  .val = '5'},
-	{.name = "hash-init",   .has_arg = true,  .val = '6'},
-	XT_GETOPT_TABLEEND,
+#define s struct ipt_clusterip_tgt_info
+static const struct xt_option_entry CLUSTERIP_opts[] = {
+	{.name = "new", .id = O_NEW, .type = XTTYPE_NONE},
+	{.name = "hashmode", .id = O_HASHMODE, .type = XTTYPE_STRING,
+	 .also = O_NEW},
+	{.name = "clustermac", .id = O_CLUSTERMAC, .type = XTTYPE_ETHERMAC,
+	 .also = O_NEW, .flags = XTOPT_PUT, XTOPT_POINTER(s, clustermac)},
+	{.name = "total-nodes", .id = O_TOTAL_NODES, .type = XTTYPE_UINT16,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, num_total_nodes),
+	 .also = O_NEW, .max = CLUSTERIP_MAX_NODES},
+	{.name = "local-node", .id = O_LOCAL_NODE, .type = XTTYPE_UINT16,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, local_nodes[0]),
+	 .also = O_NEW, .max = CLUSTERIP_MAX_NODES},
+	{.name = "hash-init", .id = O_HASH_INIT, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, hash_initval),
+	 .also = O_NEW, .max = UINT_MAX},
+	XTOPT_TABLEEND,
 };
+#undef s
 
-static void
-parse_mac(const char *mac, char *macbuf)
+static void CLUSTERIP_parse(struct xt_option_call *cb)
 {
-	unsigned int i = 0;
-
-	if (strlen(mac) != ETH_ALEN*3-1)
-		xtables_error(PARAMETER_PROBLEM, "Bad mac address \"%s\"", mac);
-
-	for (i = 0; i < ETH_ALEN; i++) {
-		long number;
-		char *end;
+	struct ipt_clusterip_tgt_info *cipinfo = cb->data;
 
-		number = strtol(mac + i*3, &end, 16);
-
-		if (end == mac + i*3 + 2
-		    && number >= 0
-		    && number <= 255)
-			macbuf[i] = number;
-		else
-			xtables_error(PARAMETER_PROBLEM,
-				   "Bad mac address `%s'", mac);
-	}
-}
-
-static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
-                           const void *entry, struct xt_entry_target **target)
-{
-	struct ipt_clusterip_tgt_info *cipinfo
-		= (struct ipt_clusterip_tgt_info *)(*target)->data;
-
-	switch (c) {
-		unsigned int num;
-	case '1':
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_NEW:
 		cipinfo->flags |= CLUSTERIP_FLAG_NEW;
-		if (*flags & PARAM_NEW)
-			xtables_error(PARAMETER_PROBLEM, "Can only specify \"--new\" once\n");
-		*flags |= PARAM_NEW;
 		break;
-	case '2':
-		if (!(*flags & PARAM_NEW))
-			xtables_error(PARAMETER_PROBLEM, "Can only specify hashmode combined with \"--new\"\n");
-		if (*flags & PARAM_HMODE)
-			xtables_error(PARAMETER_PROBLEM, "Can only specify hashmode once\n");
-		if (!strcmp(optarg, "sourceip"))
+	case O_HASHMODE:
+		if (strcmp(cb->arg, "sourceip") == 0)
 			cipinfo->hash_mode = CLUSTERIP_HASHMODE_SIP;
-		else if (!strcmp(optarg, "sourceip-sourceport"))
+		else if (strcmp(cb->arg, "sourceip-sourceport") == 0)
 			cipinfo->hash_mode = CLUSTERIP_HASHMODE_SIP_SPT;
-		else if (!strcmp(optarg, "sourceip-sourceport-destport"))
+		else if (strcmp(cb->arg, "sourceip-sourceport-destport") == 0)
 			cipinfo->hash_mode = CLUSTERIP_HASHMODE_SIP_SPT_DPT;
 		else
 			xtables_error(PARAMETER_PROBLEM, "Unknown hashmode \"%s\"\n",
-				   optarg);
-		*flags |= PARAM_HMODE;
+				   cb->arg);
 		break;
-	case '3':
-		if (!(*flags & PARAM_NEW))
-			xtables_error(PARAMETER_PROBLEM, "Can only specify MAC combined with \"--new\"\n");
-		if (*flags & PARAM_MAC)
-			xtables_error(PARAMETER_PROBLEM, "Can only specify MAC once\n");
-		parse_mac(optarg, (char *)cipinfo->clustermac);
+	case O_CLUSTERMAC:
 		if (!(cipinfo->clustermac[0] & 0x01))
 			xtables_error(PARAMETER_PROBLEM, "MAC has to be a multicast ethernet address\n");
-		*flags |= PARAM_MAC;
-		break;
-	case '4':
-		if (!(*flags & PARAM_NEW))
-			xtables_error(PARAMETER_PROBLEM, "Can only specify node number combined with \"--new\"\n");
-		if (*flags & PARAM_TOTALNODE)
-			xtables_error(PARAMETER_PROBLEM, "Can only specify total node number once\n");
-		if (!xtables_strtoui(optarg, NULL, &num, 1, CLUSTERIP_MAX_NODES))
-			xtables_error(PARAMETER_PROBLEM, "Unable to parse \"%s\"\n", optarg);
-		cipinfo->num_total_nodes = num;
-		*flags |= PARAM_TOTALNODE;
 		break;
-	case '5':
-		if (!(*flags & PARAM_NEW))
-			xtables_error(PARAMETER_PROBLEM, "Can only specify node number combined with \"--new\"\n");
-		if (*flags & PARAM_LOCALNODE)
-			xtables_error(PARAMETER_PROBLEM, "Can only specify local node number once\n");
-		if (!xtables_strtoui(optarg, NULL, &num, 1, CLUSTERIP_MAX_NODES))
-			xtables_error(PARAMETER_PROBLEM, "Unable to parse \"%s\"\n", optarg);
+	case O_LOCAL_NODE:
 		cipinfo->num_local_nodes = 1;
-		cipinfo->local_nodes[0] = num;
-		*flags |= PARAM_LOCALNODE;
-		break;
-	case '6':
-		if (!(*flags & PARAM_NEW))
-			xtables_error(PARAMETER_PROBLEM, "Can only specify hash init value combined with \"--new\"\n");
-		if (*flags & PARAM_HASHINIT)
-			xtables_error(PARAMETER_PROBLEM, "Can specify hash init value only once\n");
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT_MAX))
-			xtables_error(PARAMETER_PROBLEM, "Unable to parse \"%s\"\n", optarg);
-		cipinfo->hash_initval = num;
-		*flags |= PARAM_HASHINIT;
 		break;
 	}
-
-	return 1;
 }
 
-static void CLUSTERIP_check(unsigned int flags)
+static void CLUSTERIP_check(struct xt_fcheck_call *cb)
 {
-	if (flags == 0)
+	if (cb->xflags == 0)
 		return;
-
-	if ((flags & (PARAM_NEW|PARAM_HMODE|PARAM_MAC|PARAM_TOTALNODE|PARAM_LOCALNODE))
-		== (PARAM_NEW|PARAM_HMODE|PARAM_MAC|PARAM_TOTALNODE|PARAM_LOCALNODE))
+	if ((cb->xflags & F_FULL) == F_FULL)
 		return;
 
 	xtables_error(PARAMETER_PROBLEM, "CLUSTERIP target: Invalid parameter combination\n");
@@ -235,11 +182,11 @@ static struct xtables_target clusterip_tg_reg = {
 	.size		= XT_ALIGN(sizeof(struct ipt_clusterip_tgt_info)),
 	.userspacesize	= offsetof(struct ipt_clusterip_tgt_info, config),
  	.help		= CLUSTERIP_help,
-	.parse		= CLUSTERIP_parse,
-	.final_check	= CLUSTERIP_check,
+	.x6_parse	= CLUSTERIP_parse,
+	.x6_fcheck	= CLUSTERIP_check,
 	.print		= CLUSTERIP_print,
 	.save		= CLUSTERIP_save,
-	.extra_opts	= CLUSTERIP_opts,
+	.x6_options	= CLUSTERIP_opts,
 };
 
 void _init(void)
-- 
1.7.1

