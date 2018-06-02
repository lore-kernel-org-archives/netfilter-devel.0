From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/20] netfilter: nft_compat: use call_rcu for nfnl_compat_get
Date: Sat,  2 Jun 2018 02:22:46 +0200
Message-ID: <20180602002259.4024-8-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Just use .call_rcu instead.  We can drop the rcu read lock
after obtaining a reference and re-acquire on return.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 1d99a1efdafc..8d1ff654e5af 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -611,10 +611,10 @@ nfnl_compat_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	return -1;
 }
 
-static int nfnl_compat_get(struct net *net, struct sock *nfnl,
-			   struct sk_buff *skb, const struct nlmsghdr *nlh,
-			   const struct nlattr * const tb[],
-			   struct netlink_ext_ack *extack)
+static int nfnl_compat_get_rcu(struct net *net, struct sock *nfnl,
+			       struct sk_buff *skb, const struct nlmsghdr *nlh,
+			       const struct nlattr * const tb[],
+			       struct netlink_ext_ack *extack)
 {
 	int ret = 0, target;
 	struct nfgenmsg *nfmsg;
@@ -653,16 +653,21 @@ static int nfnl_compat_get(struct net *net, struct sock *nfnl,
 		return -EINVAL;
 	}
 
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+
+	rcu_read_unlock();
 	try_then_request_module(xt_find_revision(nfmsg->nfgen_family, name,
 						 rev, target, &ret),
 						 fmt, name);
-
 	if (ret < 0)
-		return ret;
+		goto out_put;
 
 	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (skb2 == NULL)
-		return -ENOMEM;
+	if (skb2 == NULL) {
+		ret = -ENOMEM;
+		goto out_put;
+	}
 
 	/* include the best revision for this extension in the message */
 	if (nfnl_compat_fill_info(skb2, NETLINK_CB(skb).portid,
@@ -672,14 +677,16 @@ static int nfnl_compat_get(struct net *net, struct sock *nfnl,
 				  nfmsg->nfgen_family,
 				  name, ret, target) <= 0) {
 		kfree_skb(skb2);
-		return -ENOSPC;
+		goto out_put;
 	}
 
 	ret = netlink_unicast(nfnl, skb2, NETLINK_CB(skb).portid,
 				MSG_DONTWAIT);
 	if (ret > 0)
 		ret = 0;
-
+out_put:
+	rcu_read_lock();
+	module_put(THIS_MODULE);
 	return ret == -EAGAIN ? -ENOBUFS : ret;
 }
 
@@ -691,7 +698,7 @@ static const struct nla_policy nfnl_compat_policy_get[NFTA_COMPAT_MAX+1] = {
 };
 
 static const struct nfnl_callback nfnl_nft_compat_cb[NFNL_MSG_COMPAT_MAX] = {
-	[NFNL_MSG_COMPAT_GET]		= { .call = nfnl_compat_get,
+	[NFNL_MSG_COMPAT_GET]		= { .call_rcu = nfnl_compat_get_rcu,
 					    .attr_count = NFTA_COMPAT_MAX,
 					    .policy = nfnl_compat_policy_get },
 };
-- 
2.11.0
