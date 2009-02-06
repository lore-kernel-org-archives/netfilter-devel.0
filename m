From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] iptables: cluster match support
Date: Fri, 06 Feb 2009 08:44:23 +0100
Message-ID: <20090206074423.6474.84130.stgit@Decadence>
References: <20090206074401.6474.98561.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39416 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751245AbZBFHom (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:44:42 -0500
In-Reply-To: <20090206074401.6474.98561.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for the cluster match to iptables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 extensions/libxt_cluster.c           |  200 ++++++++++++++++++++++++++++++++++
 include/linux/netfilter/xt_cluster.h |   21 ++++
 2 files changed, 221 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_cluster.c
 create mode 100644 include/linux/netfilter/xt_cluster.h

diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
new file mode 100644
index 0000000..1f82ac3
--- /dev/null
+++ b/extensions/libxt_cluster.c
@@ -0,0 +1,200 @@
+/*
+ * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <stddef.h>
+
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_cluster.h>
+
+/* maximum 16 nodes */
+#define CLUSTER_MAX_NODES	16
+
+/* hack to keep for check */
+static int total_nodes;
+static int local_node;
+
+static void
+cluster_help(void)
+{
+	printf(
+"cluster match options:\n"
+"  --cluster-total-nodes <num>		Set number of total nodes in cluster\n"
+"  --cluster-local-node <num>		Set the local node number\n"
+"  --cluster-hash-seed <num>		Set seed value of the Jenkins hash\n"
+"  --cluster-proc-name <string>		Proc interface name\n");
+}
+
+enum {
+	CLUSTER_OPT_DEVICE,
+	CLUSTER_OPT_TOTAL_NODES,
+	CLUSTER_OPT_LOCAL_NODE,
+	CLUSTER_OPT_HASH_SEED,
+	CLUSTER_OPT_PROC_NAME,
+};
+
+static const struct option cluster_opts[] = {
+	{ "cluster-total-nodes", 	1, NULL, CLUSTER_OPT_TOTAL_NODES },
+	{ "cluster-local-node", 	1, NULL, CLUSTER_OPT_LOCAL_NODE },
+	{ "cluster-hash-seed",		1, NULL, CLUSTER_OPT_HASH_SEED },
+	{ "cluster-proc-name",		1, NULL, CLUSTER_OPT_PROC_NAME },
+	{ .name = NULL }
+};
+
+static int 
+cluster_parse(int c, char **argv, int invert, unsigned int *flags,
+	      const void *entry, struct xt_entry_match **match)
+{
+	struct xt_cluster_match_info *info = (void *)(*match)->data;
+	unsigned int num;
+
+	switch (c) {
+	case CLUSTER_OPT_TOTAL_NODES:
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "Can only specify "
+				   "`--cluster-total-nodes' once");
+
+		if (string_to_number(optarg, 1, CLUSTER_MAX_NODES, &num) < 0)
+			exit_error(PARAMETER_PROBLEM, 
+				    "Unable to parse `%s' in "
+				    "`--cluster-total-nodes'", optarg);
+
+		total_nodes = num;
+		info->total_nodes = (u_int16_t)num;
+		*flags |= 1 << c;
+		break;
+	case CLUSTER_OPT_LOCAL_NODE:
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "Can only specify "
+				   "`--cluster-local-node' once");
+
+		check_inverse(optarg, &invert, &optind, 0);
+
+		if (string_to_number(optarg, 1, CLUSTER_MAX_NODES, &num) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				   "Unable to parse `%s' in "
+				   "`--cluster-local-node'", optarg);
+
+		if (invert)
+			info->flags |= (1 << XT_CLUSTER_F_INV);
+
+		info->node_id = (u_int16_t)num;
+		*flags |= 1 << c;
+		break;
+	case CLUSTER_OPT_HASH_SEED:
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "Can only specify "
+				   "`--cluster-hash-seed' once");
+
+		if (string_to_number(optarg, 0, UINT_MAX, &num) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				   "Unable to parse `%s'", optarg);
+
+		info->hash_seed = num;
+		*flags |= 1 << c;
+		break;
+	case CLUSTER_OPT_PROC_NAME:
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "Can only specify "
+				   "`--cluster-proc-name' once");
+
+		if (strlen(optarg) > sizeof(info->proc_name))
+			exit_error(PARAMETER_PROBLEM,
+				   "--cluster-proc-name string too long");
+
+		strncpy(info->proc_name, optarg, sizeof(info->proc_name));
+		info->proc_name[sizeof(info->proc_name)-1] = '\0';
+		*flags |= 1 << c;
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void
+cluster_check(unsigned int flags)
+{
+	if ((flags & ((1 << CLUSTER_OPT_TOTAL_NODES) |
+		      (1 << CLUSTER_OPT_LOCAL_NODE)  |
+		      (1 << CLUSTER_OPT_PROC_NAME)))
+		== ((1 << CLUSTER_OPT_TOTAL_NODES) |
+		    (1 << CLUSTER_OPT_LOCAL_NODE) |
+		    (1 << CLUSTER_OPT_PROC_NAME))) {
+		if (local_node > total_nodes)
+			exit_error(PARAMETER_PROBLEM,
+				   "cluster match: `--cluster-local-node' "
+				   "must be <= `--cluster-total-nodes'");
+		return;
+	}
+
+	exit_error(PARAMETER_PROBLEM,
+		   "cluster match: Invalid parameter combination");
+}
+
+static void
+cluster_print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_cluster_match_info *info = (void *)match->data;
+
+	printf("cluster ");
+	if (info->flags & XT_CLUSTER_F_INV)
+		printf("!node_id=%u ", info->node_id);
+	else
+		printf("node_id=%u ", info->node_id);
+
+	printf("total_nodes=%u hash_seed=%u proc=%s ", 
+		info->total_nodes,
+		info->hash_seed,
+		info->proc_name);
+}
+
+static void
+cluster_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_cluster_match_info *info = (void *)match->data;
+
+	if (info->flags & XT_CLUSTER_F_INV)
+		printf("! --cluster-this-node %u ", info->node_id);
+	else
+		printf("--cluster-this-node %u ", info->node_id);
+
+	printf("--cluster-total-nodes %u "
+	       "--cluster-hash-seed %u "
+	       "--cluster-proc-entry %s ",
+		info->total_nodes,
+		info->hash_seed,
+		info->proc_name);
+}
+
+static struct xtables_match cluster_mt_reg = {
+	.family		= AF_UNSPEC,
+	.name		= "cluster",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_cluster_match_info)),
+	.userspacesize  = XT_ALIGN(offsetof(struct xt_cluster_match_info,data)),
+ 	.help		= cluster_help,
+	.parse		= cluster_parse,
+	.final_check	= cluster_check,
+	.print		= cluster_print,
+	.save		= cluster_save,
+	.extra_opts	= cluster_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&cluster_mt_reg);
+}
diff --git a/include/linux/netfilter/xt_cluster.h b/include/linux/netfilter/xt_cluster.h
new file mode 100644
index 0000000..a06401d
--- /dev/null
+++ b/include/linux/netfilter/xt_cluster.h
@@ -0,0 +1,21 @@
+#ifndef _XT_CLUSTER_MATCH_H
+#define _XT_CLUSTER_MATCH_H
+
+struct proc_dir_entry;
+
+enum xt_cluster_flags {
+	XT_CLUSTER_F_INV = 0,
+};
+
+struct xt_cluster_match_info {
+	u_int16_t		total_nodes;
+	u_int16_t		node_id;
+	u_int32_t		hash_seed;
+	char			proc_name[16];
+	u_int32_t		flags;
+
+	/* Used internally by the kernel */
+	void			*data __attribute__((aligned(8)));
+};
+
+#endif /* _XT_CLUSTER_MATCH_H */

