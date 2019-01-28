From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/33] netfilter: conntrack: remove module owner field
Date: Tue, 29 Jan 2019 00:57:31 +0100
Message-ID: <20190128235750.18412-15-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No need to get/put module owner reference, none of these can be removed
anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 4 ----
 net/netfilter/nf_conntrack_proto.c           | 8 --------
 net/netfilter/nf_conntrack_proto_gre.c       | 1 -
 net/netfilter/nfnetlink_cttimeout.c          | 6 ------
 net/netfilter/nft_ct.c                       | 2 --
 5 files changed, 21 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 6cec8337e684..fd8954429e87 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -74,9 +74,6 @@ struct nf_conntrack_l4proto {
 
 	/* Return the per-net protocol part. */
 	struct nf_proto_net *(*get_net_proto)(struct net *net);
-
-	/* Module (if any) which this is connected to. */
-	struct module *me;
 };
 
 bool icmp_pkt_to_tuple(const struct sk_buff *skb,
@@ -148,7 +145,6 @@ extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 const struct nf_conntrack_l4proto *__nf_ct_l4proto_find(u8 l4proto);
 
 const struct nf_conntrack_l4proto *nf_ct_l4proto_find_get(u8 l4proto);
-void nf_ct_l4proto_put(const struct nf_conntrack_l4proto *p);
 
 /* Protocol pernet registration. */
 int nf_ct_l4proto_pernet_register_one(struct net *net,
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 47b9294a86f7..3455f993cc68 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -139,20 +139,12 @@ const struct nf_conntrack_l4proto *nf_ct_l4proto_find_get(u8 l4num)
 
 	rcu_read_lock();
 	p = __nf_ct_l4proto_find(l4num);
-	if (!try_module_get(p->me))
-		p = &nf_conntrack_l4proto_generic;
 	rcu_read_unlock();
 
 	return p;
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_find_get);
 
-void nf_ct_l4proto_put(const struct nf_conntrack_l4proto *p)
-{
-	module_put(p->me);
-}
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_put);
-
 static int kill_l4proto(struct nf_conn *i, void *data)
 {
 	const struct nf_conntrack_l4proto *l4proto;
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 04bc982b274d..0c26cfd5d29f 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -373,7 +373,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre = {
 #endif
 	.packet		 = gre_packet,
 	.destroy	 = gre_destroy,
-	.me 		 = THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr = nf_ct_port_tuple_to_nlattr,
 	.nlattr_tuple_size = nf_ct_port_nlattr_tuple_size,
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 0e3e1a018206..37b4f84ac153 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -152,7 +152,6 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 err:
 	kfree(timeout);
 err_proto_put:
-	nf_ct_l4proto_put(l4proto);
 	return ret;
 }
 
@@ -302,7 +301,6 @@ static int ctnl_timeout_try_del(struct net *net, struct ctnl_timeout *timeout)
 	if (refcount_dec_if_one(&timeout->refcnt)) {
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&timeout->head);
-		nf_ct_l4proto_put(timeout->timeout.l4proto);
 		nf_ct_untimeout(net, &timeout->timeout);
 		kfree_rcu(timeout, rcu_head);
 	} else {
@@ -372,10 +370,8 @@ static int cttimeout_default_set(struct net *net, struct sock *ctnl,
 	if (ret < 0)
 		goto err;
 
-	nf_ct_l4proto_put(l4proto);
 	return 0;
 err:
-	nf_ct_l4proto_put(l4proto);
 	return ret;
 }
 
@@ -511,7 +507,6 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 	/* this avoids a loop in nfnetlink. */
 	return ret == -EAGAIN ? -ENOBUFS : ret;
 err:
-	nf_ct_l4proto_put(l4proto);
 	return err;
 }
 
@@ -592,7 +587,6 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 
 	list_for_each_entry_safe(cur, tmp, &net->nfct_timeout_list, head) {
 		list_del_rcu(&cur->head);
-		nf_ct_l4proto_put(cur->timeout.l4proto);
 
 		if (refcount_dec_and_test(&cur->refcnt))
 			kfree_rcu(cur, rcu_head);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 586627c361df..3249cc059048 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -902,7 +902,6 @@ static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
 err_free_timeout:
 	kfree(timeout);
 err_proto_put:
-	nf_ct_l4proto_put(l4proto);
 	return ret;
 }
 
@@ -913,7 +912,6 @@ static void nft_ct_timeout_obj_destroy(const struct nft_ctx *ctx,
 	struct nf_ct_timeout *timeout = priv->timeout;
 
 	nf_ct_untimeout(ctx->net, timeout);
-	nf_ct_l4proto_put(timeout->l4proto);
 	nf_ct_netns_put(ctx->net, ctx->family);
 	kfree(priv->timeout);
 }
-- 
2.11.0
