From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 30/38] netfilter: nf_tables: take module reference when starting a batch
Date: Fri, 20 Jul 2018 15:08:58 +0200
Message-ID: <20180720130906.27687-31-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h | 1 +
 net/netfilter/nf_tables_api.c       | 1 +
 net/netfilter/nfnetlink.c           | 9 +++++++++
 3 files changed, 11 insertions(+)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 3ecc3050be0e..4a520d3304a2 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -29,6 +29,7 @@ struct nfnetlink_subsystem {
 	__u8 subsys_id;			/* nfnetlink subsystem ID */
 	__u8 cb_count;			/* number of callbacks */
 	const struct nfnl_callback *cb;	/* callback for individual types */
+	struct module *owner;
 	int (*commit)(struct net *net, struct sk_buff *skb);
 	int (*abort)(struct net *net, struct sk_buff *skb);
 	void (*cleanup)(struct net *net);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 594b395442d6..c16c481fc52a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6603,6 +6603,7 @@ static const struct nfnetlink_subsystem nf_tables_subsys = {
 	.abort		= nf_tables_abort,
 	.cleanup	= nf_tables_cleanup,
 	.valid_genid	= nf_tables_valid_genid,
+	.owner		= THIS_MODULE,
 };
 
 int nft_chain_validate_dependency(const struct nft_chain *chain,
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 94f9bcaa0799..dd1d7bc23b03 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -337,7 +337,14 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return kfree_skb(skb);
 	}
 
+	if (!try_module_get(ss->owner)) {
+		nfnl_unlock(subsys_id);
+		netlink_ack(oskb, nlh, -EOPNOTSUPP, NULL);
+		return kfree_skb(skb);
+	}
+
 	if (!ss->valid_genid(net, genid)) {
+		module_put(ss->owner);
 		nfnl_unlock(subsys_id);
 		netlink_ack(oskb, nlh, -ERESTART, NULL);
 		return kfree_skb(skb);
@@ -472,6 +479,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		nfnl_err_reset(&err_list);
 		nfnl_unlock(subsys_id);
 		kfree_skb(skb);
+		module_put(ss->owner);
 		goto replay;
 	} else if (status == NFNL_BATCH_DONE) {
 		err = ss->commit(net, oskb);
@@ -491,6 +499,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	nfnl_err_deliver(&err_list, oskb);
 	nfnl_unlock(subsys_id);
 	kfree_skb(skb);
+	module_put(ss->owner);
 }
 
 static const struct nla_policy nfnl_batch_policy[NFNL_BATCH_MAX + 1] = {
-- 
2.11.0
