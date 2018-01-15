From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [Iptables Patch V3] extensions: libxt_cluster: Add translation to nft
Date: Mon, 15 Jan 2018 11:29:28 +0530
Message-ID: <1515995968-10120-1-git-send-email-mayhs11saini@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        Shyam Saini <mayhs11saini@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36375 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932672AbeAOF7m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 00:59:42 -0500
Received: by mail-pg0-f65.google.com with SMTP id j2so7501126pgv.3
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2018 21:59:42 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for cluster to nft

$ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster
--cluster-total-nodes 7 --cluster-local-node 5 --cluster-hash-seed
0xdeadbeef -j MARK --set-mark 0xffff

nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr
mod 7 seed 0xdeadbeef eq 5 meta pkttype set host counter meta mark set
0xffff

$ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster
--cluster-total-nodes 7 --cluster-local-nodemask 5 --cluster-hash-seed
0xdeadbeef -j MARK --set-mark 0xffff

nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr
mod 7 seed 0xdeadbeef eq { 0, 2 } meta pkttype set host counter meta
mark set 0xffff

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 extensions/libxt_cluster.c | 52 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
index 3adff12..800e3ae 100644
--- a/extensions/libxt_cluster.c
+++ b/extensions/libxt_cluster.c
@@ -71,7 +71,6 @@ static void cluster_check(struct xt_fcheck_call *cb)
 {
 	const struct xt_cluster_match_info *info = cb->data;
 	unsigned int test;
-
 	test = F_CL_TOTAL_NODES | F_CL_LOCAL_NODE | F_CL_HASH_SEED;
 	if ((cb->xflags & test) == test) {
 		if (info->node_mask >= (1ULL << info->total_nodes))
@@ -126,6 +125,56 @@ cluster_save(const void *ip, const struct xt_entry_match *match)
 		info->total_nodes, info->hash_seed);
 }
 
+static int cluster_xlate(struct xt_xlate *xl,
+		const struct xt_xlate_mt_params *params)
+{
+	int node, shift_value = 1, comma_needed = 0;
+	uint32_t temp_node_mask, node_id = 0, needs_set = 0;
+	const struct xt_cluster_match_info *info = params->match->data;
+	const char jhash_st[28] = "jhash ct original saddr mod";
+	const char pkttype_st[22] = "meta pkttype set host";
+
+	if (!(info->node_mask & (info->node_mask - 1))) {
+		if (info->node_mask <= 2)
+			xt_xlate_add(xl, "%s %u seed 0x%08x eq %u %s", jhash_st,
+					info->total_nodes, info->hash_seed,
+					info->node_mask, pkttype_st);
+		else {
+			temp_node_mask = info->node_mask;
+			while (1) {
+				temp_node_mask = temp_node_mask >> shift_value;
+				node_id++;
+				if (temp_node_mask == 0)
+					break;
+			}
+			xt_xlate_add(xl, "%s %u seed 0x%08x eq %u %s", jhash_st,
+					info->total_nodes, info->hash_seed,
+					node_id, pkttype_st);
+		}
+	} else {
+		xt_xlate_add(xl, "%s %u seed 0x%08x eq ", jhash_st,
+				info->total_nodes, info->hash_seed);
+		for (node = 0; node < 32; node++) {
+			if (info->node_mask & (1 << node)) {
+				if (needs_set == 0) {
+					xt_xlate_add(xl, "{ ");
+					needs_set = 1;
+				}
+
+				if (comma_needed)
+					xt_xlate_add(xl, ", ");
+				xt_xlate_add(xl, "%u", node);
+				comma_needed++;
+			}
+		}
+		if (needs_set)
+			xt_xlate_add(xl, " }");
+		xt_xlate_add(xl, " %s", pkttype_st);
+	}
+
+	return 1;
+}
+
 static struct xtables_match cluster_mt_reg = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "cluster",
@@ -138,6 +187,7 @@ static struct xtables_match cluster_mt_reg = {
 	.x6_parse	= cluster_parse,
 	.x6_fcheck	= cluster_check,
 	.x6_options	= cluster_opts,
+	.xlate		= cluster_xlate,
 };
 
 void _init(void)
-- 
1.9.1

