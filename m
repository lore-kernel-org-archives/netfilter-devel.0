From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/12] netfilter: xt_cluster: add dependency on conntrack module
Date: Tue, 11 Sep 2018 02:20:34 +0200
Message-ID: <20180911002044.9100-3-pablo@netfilter.org>
References: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911002044.9100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Martin Willi <martin@strongswan.org>

The cluster match requires conntrack for matching packets. If the
netns does not have conntrack hooks registered, the match does not
work at all.

Implicitly load the conntrack hook for the family, exactly as many
other extensions do. This ensures that the match works even if the
hooks have not been registered by other means.

Signed-off-by: Martin Willi <martin@strongswan.org>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_cluster.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index dfbdbb2fc0ed..51d0c257e7a5 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -125,6 +125,7 @@ xt_cluster_mt(const struct sk_buff *skb, struct xt_action_param *par)
 static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	struct xt_cluster_match_info *info = par->matchinfo;
+	int ret;
 
 	if (info->total_nodes > XT_CLUSTER_NODES_MAX) {
 		pr_info_ratelimited("you have exceeded the maximum number of cluster nodes (%u > %u)\n",
@@ -135,7 +136,17 @@ static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
 		pr_info_ratelimited("node mask cannot exceed total number of nodes\n");
 		return -EDOM;
 	}
-	return 0;
+
+	ret = nf_ct_netns_get(par->net, par->family);
+	if (ret < 0)
+		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
+				    par->family);
+	return ret;
+}
+
+static void xt_cluster_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	nf_ct_netns_put(par->net, par->family);
 }
 
 static struct xt_match xt_cluster_match __read_mostly = {
@@ -144,6 +155,7 @@ static struct xt_match xt_cluster_match __read_mostly = {
 	.match		= xt_cluster_mt,
 	.checkentry	= xt_cluster_mt_checkentry,
 	.matchsize	= sizeof(struct xt_cluster_match_info),
+	.destroy	= xt_cluster_mt_destroy,
 	.me		= THIS_MODULE,
 };
 
-- 
2.11.0
