From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/8] netfilter: cttimeout: move ctnl_untimeout to nf_conntrack
Date: Fri, 10 Aug 2018 13:16:16 +0200
Message-ID: <20180810111622.3981-3-pablo@netfilter.org>
References: <20180810111622.3981-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810111622.3981-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Harsha Sharma <harshasharmaiitr@gmail.com>

As, ctnl_untimeout is required by nft_ct, so move ctnl_timeout from
nfnetlink_cttimeout to nf_conntrack_timeout and rename as nf_ct_timeout.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_timeout.h |  1 +
 net/netfilter/nf_conntrack_timeout.c         | 17 +++++++++++++++++
 net/netfilter/nfnetlink_cttimeout.c          | 20 ++------------------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 80ceb3d0291d..7a21bc0f00eb 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -83,6 +83,7 @@ static inline unsigned int *nf_ct_timeout_lookup(const struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 int nf_conntrack_timeout_init(void);
 void nf_conntrack_timeout_fini(void);
+void nf_ct_untimeout(struct net *net, struct ctnl_timeout *timeout);
 #else
 static inline int nf_conntrack_timeout_init(void)
 {
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 46aee65f339b..401c2cce4a61 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -31,6 +31,23 @@ EXPORT_SYMBOL_GPL(nf_ct_timeout_find_get_hook);
 void (*nf_ct_timeout_put_hook)(struct ctnl_timeout *timeout) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_timeout_put_hook);
 
+static int untimeout(struct nf_conn *ct, void *timeout)
+{
+	struct nf_conn_timeout *timeout_ext = nf_ct_timeout_find(ct);
+
+	if (timeout_ext && (!timeout || timeout_ext->timeout == timeout))
+		RCU_INIT_POINTER(timeout_ext->timeout, NULL);
+
+	/* We are not intended to delete this conntrack. */
+	return 0;
+}
+
+void nf_ct_untimeout(struct net *net, struct ctnl_timeout *timeout)
+{
+	nf_ct_iterate_cleanup_net(net, untimeout, timeout, 0, 0);
+}
+EXPORT_SYMBOL_GPL(nf_ct_untimeout);
+
 static const struct nf_ct_ext_type timeout_extend = {
 	.len	= sizeof(struct nf_conn_timeout),
 	.align	= __alignof__(struct nf_conn_timeout),
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 4199e5300575..df53aef2d642 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -297,22 +297,6 @@ static int cttimeout_get_timeout(struct net *net, struct sock *ctnl,
 	return ret;
 }
 
-static int untimeout(struct nf_conn *ct, void *timeout)
-{
-	struct nf_conn_timeout *timeout_ext = nf_ct_timeout_find(ct);
-
-	if (timeout_ext && (!timeout || timeout_ext->timeout == timeout))
-		RCU_INIT_POINTER(timeout_ext->timeout, NULL);
-
-	/* We are not intended to delete this conntrack. */
-	return 0;
-}
-
-static void ctnl_untimeout(struct net *net, struct ctnl_timeout *timeout)
-{
-	nf_ct_iterate_cleanup_net(net, untimeout, timeout, 0, 0);
-}
-
 /* try to delete object, fail if it is still in use. */
 static int ctnl_timeout_try_del(struct net *net, struct ctnl_timeout *timeout)
 {
@@ -325,7 +309,7 @@ static int ctnl_timeout_try_del(struct net *net, struct ctnl_timeout *timeout)
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&timeout->head);
 		nf_ct_l4proto_put(timeout->l4proto);
-		ctnl_untimeout(net, timeout);
+		nf_ct_untimeout(net, timeout);
 		kfree_rcu(timeout, rcu_head);
 	} else {
 		ret = -EBUSY;
@@ -573,7 +557,7 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 	struct ctnl_timeout *cur, *tmp;
 
 	nf_ct_unconfirmed_destroy(net);
-	ctnl_untimeout(net, NULL);
+	nf_ct_untimeout(net, NULL);
 
 	list_for_each_entry_safe(cur, tmp, &net->nfct_timeout_list, head) {
 		list_del_rcu(&cur->head);
-- 
2.11.0
