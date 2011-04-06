From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/10] libxt_cluster: use guided option parser
Date: Wed,  6 Apr 2011 13:31:17 +0200
Message-ID: <1302089478-15022-11-git-send-email-jengelh@medozas.de>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46511 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab1DFLbc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:32 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_cluster.c |  187 +++++++++++--------------------------------
 1 files changed, 48 insertions(+), 139 deletions(-)

diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
index e1607d0..3adff12 100644
--- a/extensions/libxt_cluster.c
+++ b/extensions/libxt_cluster.c
@@ -5,21 +5,10 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <stddef.h>
-
 #include <xtables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_cluster.h>
 
-/* hack to keep for check */
-static unsigned int total_nodes;
-static unsigned int node_mask;
-
 static void
 cluster_help(void)
 {
@@ -32,160 +21,80 @@ cluster_help(void)
 }
 
 enum {
-	CLUSTER_OPT_TOTAL_NODES,
-	CLUSTER_OPT_LOCAL_NODE,
-	CLUSTER_OPT_NODE_MASK,
-	CLUSTER_OPT_HASH_SEED,
+	O_CL_TOTAL_NODES = 0,
+	O_CL_LOCAL_NODE,
+	O_CL_LOCAL_NODEMASK,
+	O_CL_HASH_SEED,
+	F_CL_TOTAL_NODES    = 1 << O_CL_TOTAL_NODES,
+	F_CL_LOCAL_NODE     = 1 << O_CL_LOCAL_NODE,
+	F_CL_LOCAL_NODEMASK = 1 << O_CL_LOCAL_NODEMASK,
+	F_CL_HASH_SEED      = 1 << O_CL_HASH_SEED,
 };
 
-static const struct option cluster_opts[] = {
-	{.name = "cluster-total-nodes",    .has_arg = true, .val = CLUSTER_OPT_TOTAL_NODES},
-	{.name = "cluster-local-node",     .has_arg = true, .val = CLUSTER_OPT_LOCAL_NODE},
-	{.name = "cluster-local-nodemask", .has_arg = true, .val = CLUSTER_OPT_NODE_MASK},
-	{.name = "cluster-hash-seed",      .has_arg = true, .val = CLUSTER_OPT_HASH_SEED},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_cluster_match_info
+static const struct xt_option_entry cluster_opts[] = {
+	{.name = "cluster-total-nodes", .id = O_CL_TOTAL_NODES,
+	 .type = XTTYPE_UINT32, .min = 1, .max = XT_CLUSTER_NODES_MAX,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, total_nodes)},
+	{.name = "cluster-local-node", .id = O_CL_LOCAL_NODE,
+	 .excl = F_CL_LOCAL_NODEMASK, .flags = XTOPT_INVERT,
+	 .type = XTTYPE_UINT32, .min = 1, .max = XT_CLUSTER_NODES_MAX},
+	{.name = "cluster-local-nodemask", .id = O_CL_LOCAL_NODEMASK,
+	 .excl = F_CL_LOCAL_NODE, .type = XTTYPE_UINT32,
+	 .min = 1, .max = XT_CLUSTER_NODES_MAX,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, node_mask)},
+	{.name = "cluster-hash-seed", .id = O_CL_HASH_SEED,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_MAND | XTOPT_PUT,
+	 XTOPT_POINTER(s, hash_seed)},
+	XTOPT_TABLEEND,
 };
 
-static int 
-cluster_parse(int c, char **argv, int invert, unsigned int *flags,
-	      const void *entry, struct xt_entry_match **match)
+static void cluster_parse(struct xt_option_call *cb)
 {
-	struct xt_cluster_match_info *info = (void *)(*match)->data;
-	unsigned int num;
+	struct xt_cluster_match_info *info = cb->data;
 
-	switch (c) {
-	case CLUSTER_OPT_TOTAL_NODES:
-		if (*flags & (1 << c)) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Can only specify "
-				      "`--cluster-total-nodes' once");
-		}
-		if (!xtables_strtoui(optarg, NULL, &num, 1,
-				     XT_CLUSTER_NODES_MAX)) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Unable to parse `%s' in "
-				      "`--cluster-total-nodes'", optarg);
-		}
-		total_nodes = num;
-		info->total_nodes = total_nodes = num;
-		*flags |= 1 << c;
-		break;
-	case CLUSTER_OPT_LOCAL_NODE:
-		if (*flags & (1 << c)) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Can only specify "
-				      "`--cluster-local-node' once");
-		}
-		if (*flags & (1 << CLUSTER_OPT_NODE_MASK)) {
-			xtables_error(PARAMETER_PROBLEM, "You cannot use "
-				      "`--cluster-local-nodemask' and "
-				      "`--cluster-local-node'");
-		}
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		if (!xtables_strtoui(optarg, NULL, &num, 1,
-				     XT_CLUSTER_NODES_MAX)) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Unable to parse `%s' in "
-				      "`--cluster-local-node'", optarg);
-		}
-		if (invert)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_CL_LOCAL_NODE:
+		if (cb->invert)
 			info->flags |= XT_CLUSTER_F_INV;
-
-		info->node_mask = node_mask = (1 << (num - 1));
-		*flags |= 1 << c;
+		info->node_mask = 1 << (cb->val.u32 - 1);
 		break;
-	case CLUSTER_OPT_NODE_MASK:
-		if (*flags & (1 << c)) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Can only specify "
-				      "`--cluster-local-node' once");
-		}
-		if (*flags & (1 << CLUSTER_OPT_LOCAL_NODE)) {
-			xtables_error(PARAMETER_PROBLEM, "You cannot use "
-				      "`--cluster-local-nodemask' and "
-				      "`--cluster-local-node'");
-		}
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		if (!xtables_strtoui(optarg, NULL, &num, 1,
-				     XT_CLUSTER_NODES_MAX)) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Unable to parse `%s' in "
-				      "`--cluster-local-node'", optarg);
-		}
-		if (invert)
+	case O_CL_LOCAL_NODEMASK:
+		if (cb->invert)
 			info->flags |= XT_CLUSTER_F_INV;
-
-		info->node_mask = node_mask = num;
-		*flags |= 1 << c;
-		break;
-
-	case CLUSTER_OPT_HASH_SEED:
-		if (*flags & (1 << c)) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Can only specify "
-				      "`--cluster-hash-seed' once");
-		}
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX)) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "Unable to parse `%s'", optarg);
-		}
-		info->hash_seed = num;
-		*flags |= 1 << c;
 		break;
 	}
-
-	return 1;
 }
 
-static void
-cluster_check(unsigned int flags)
+static void cluster_check(struct xt_fcheck_call *cb)
 {
-	if ((flags & ((1 << CLUSTER_OPT_TOTAL_NODES) |
-		      (1 << CLUSTER_OPT_LOCAL_NODE) |
-		      (1 << CLUSTER_OPT_HASH_SEED)))
-		== ((1 << CLUSTER_OPT_TOTAL_NODES) |
-		    (1 << CLUSTER_OPT_LOCAL_NODE) |
-		    (1 << CLUSTER_OPT_HASH_SEED))) {
-		if (node_mask >= (1ULL << total_nodes)) {
+	const struct xt_cluster_match_info *info = cb->data;
+	unsigned int test;
+
+	test = F_CL_TOTAL_NODES | F_CL_LOCAL_NODE | F_CL_HASH_SEED;
+	if ((cb->xflags & test) == test) {
+		if (info->node_mask >= (1ULL << info->total_nodes))
 			xtables_error(PARAMETER_PROBLEM,
 				      "cluster match: "
 				      "`--cluster-local-node' "
 				      "must be <= `--cluster-total-nodes'");
-		}
 		return;
 	}
-	if ((flags & ((1 << CLUSTER_OPT_TOTAL_NODES) |
-		      (1 << CLUSTER_OPT_NODE_MASK) |
-		      (1 << CLUSTER_OPT_HASH_SEED)))
-		== ((1 << CLUSTER_OPT_TOTAL_NODES) |
-		    (1 << CLUSTER_OPT_NODE_MASK) |
-		    (1 << CLUSTER_OPT_HASH_SEED))) {
-		if (node_mask >= (1ULL << total_nodes)) {
+
+	test = F_CL_TOTAL_NODES | F_CL_LOCAL_NODEMASK | F_CL_HASH_SEED;
+	if ((cb->xflags & test) == test) {
+		if (info->node_mask >= (1ULL << info->total_nodes))
 			xtables_error(PARAMETER_PROBLEM,
 				      "cluster match: "
 				      "`--cluster-local-nodemask' too big "
 				      "for `--cluster-total-nodes'");
-		}
 		return;
 	}
-	if (!(flags & (1 << CLUSTER_OPT_TOTAL_NODES))) {
-		xtables_error(PARAMETER_PROBLEM,
-			      "cluster match: `--cluster-total-nodes' "
-			      "is missing");
-	}
-	if (!(flags & (1 << CLUSTER_OPT_HASH_SEED))) {
-		xtables_error(PARAMETER_PROBLEM,
-			      "cluster match: `--cluster-hash-seed' "
-			      "is missing");
-	}
-	if (!(flags & ((1 << (CLUSTER_OPT_LOCAL_NODE) |
-		       (1 << (CLUSTER_OPT_NODE_MASK)))))) {
+	if (!(cb->xflags & (F_CL_LOCAL_NODE | F_CL_LOCAL_NODEMASK)))
 		xtables_error(PARAMETER_PROBLEM,
 			      "cluster match: `--cluster-local-node' or"
 			      "`--cluster-local-nodemask' is missing");
-	}
 }
 
 static void
@@ -224,11 +133,11 @@ static struct xtables_match cluster_mt_reg = {
 	.size		= XT_ALIGN(sizeof(struct xt_cluster_match_info)),
 	.userspacesize  = XT_ALIGN(sizeof(struct xt_cluster_match_info)),
  	.help		= cluster_help,
-	.parse		= cluster_parse,
-	.final_check	= cluster_check,
 	.print		= cluster_print,
 	.save		= cluster_save,
-	.extra_opts	= cluster_opts,
+	.x6_parse	= cluster_parse,
+	.x6_fcheck	= cluster_check,
+	.x6_options	= cluster_opts,
 };
 
 void _init(void)
-- 
1.7.1

