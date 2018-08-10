From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/8] netfilter: cttimeout: decouple timeout policy from nfnetlink_cttimeout object
Date: Fri, 10 Aug 2018 13:16:17 +0200
Message-ID: <20180810111622.3981-4-pablo@netfilter.org>
References: <20180810111622.3981-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810111622.3981-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The timeout policy is currently embedded into the nfnetlink_cttimeout
object, move the policy into an independent object. This allows us to
reuse part of the existing conntrack timeout extension from nf_tables
without adding dependencies with the nfnetlink_cttimeout object layout.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_timeout.h | 22 ++++++++++-------
 net/netfilter/nf_conntrack_timeout.c         |  6 ++---
 net/netfilter/nfnetlink_cttimeout.c          | 37 ++++++++++++++++------------
 net/netfilter/xt_CT.c                        |  4 +--
 4 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 7a21bc0f00eb..d5f62cc6c2ae 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -11,24 +11,28 @@
 
 #define CTNL_TIMEOUT_NAME_MAX	32
 
+struct nf_ct_timeout {
+	__u16			l3num;
+	const struct nf_conntrack_l4proto *l4proto;
+	char			data[0];
+};
+
 struct ctnl_timeout {
 	struct list_head	head;
 	struct rcu_head		rcu_head;
 	refcount_t		refcnt;
 	char			name[CTNL_TIMEOUT_NAME_MAX];
-	__u16			l3num;
-	const struct nf_conntrack_l4proto *l4proto;
-	char			data[0];
+	struct nf_ct_timeout	timeout;
 };
 
 struct nf_conn_timeout {
-	struct ctnl_timeout __rcu *timeout;
+	struct nf_ct_timeout __rcu *timeout;
 };
 
 static inline unsigned int *
 nf_ct_timeout_data(struct nf_conn_timeout *t)
 {
-	struct ctnl_timeout *timeout;
+	struct nf_ct_timeout *timeout;
 
 	timeout = rcu_dereference(t->timeout);
 	if (timeout == NULL)
@@ -49,7 +53,7 @@ struct nf_conn_timeout *nf_ct_timeout_find(const struct nf_conn *ct)
 
 static inline
 struct nf_conn_timeout *nf_ct_timeout_ext_add(struct nf_conn *ct,
-					      struct ctnl_timeout *timeout,
+					      struct nf_ct_timeout *timeout,
 					      gfp_t gfp)
 {
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
@@ -83,7 +87,7 @@ static inline unsigned int *nf_ct_timeout_lookup(const struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 int nf_conntrack_timeout_init(void);
 void nf_conntrack_timeout_fini(void);
-void nf_ct_untimeout(struct net *net, struct ctnl_timeout *timeout);
+void nf_ct_untimeout(struct net *net, struct nf_ct_timeout *timeout);
 #else
 static inline int nf_conntrack_timeout_init(void)
 {
@@ -97,8 +101,8 @@ static inline void nf_conntrack_timeout_fini(void)
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-extern struct ctnl_timeout *(*nf_ct_timeout_find_get_hook)(struct net *net, const char *name);
-extern void (*nf_ct_timeout_put_hook)(struct ctnl_timeout *timeout);
+extern struct nf_ct_timeout *(*nf_ct_timeout_find_get_hook)(struct net *net, const char *name);
+extern void (*nf_ct_timeout_put_hook)(struct nf_ct_timeout *timeout);
 #endif
 
 #endif /* _NF_CONNTRACK_TIMEOUT_H */
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 401c2cce4a61..91fbd183da2d 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -24,11 +24,11 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 
-struct ctnl_timeout *
+struct nf_ct_timeout *
 (*nf_ct_timeout_find_get_hook)(struct net *net, const char *name) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_timeout_find_get_hook);
 
-void (*nf_ct_timeout_put_hook)(struct ctnl_timeout *timeout) __read_mostly;
+void (*nf_ct_timeout_put_hook)(struct nf_ct_timeout *timeout) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_timeout_put_hook);
 
 static int untimeout(struct nf_conn *ct, void *timeout)
@@ -42,7 +42,7 @@ static int untimeout(struct nf_conn *ct, void *timeout)
 	return 0;
 }
 
-void nf_ct_untimeout(struct net *net, struct ctnl_timeout *timeout)
+void nf_ct_untimeout(struct net *net, struct nf_ct_timeout *timeout)
 {
 	nf_ct_iterate_cleanup_net(net, untimeout, timeout, 0, 0);
 }
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index df53aef2d642..d46a236cdf31 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -113,13 +113,13 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 			/* You cannot replace one timeout policy by another of
 			 * different kind, sorry.
 			 */
-			if (matching->l3num != l3num ||
-			    matching->l4proto->l4proto != l4num)
+			if (matching->timeout.l3num != l3num ||
+			    matching->timeout.l4proto->l4proto != l4num)
 				return -EINVAL;
 
-			return ctnl_timeout_parse_policy(&matching->data,
-							 matching->l4proto, net,
-							 cda[CTA_TIMEOUT_DATA]);
+			return ctnl_timeout_parse_policy(&matching->timeout.data,
+							 matching->timeout.l4proto,
+							 net, cda[CTA_TIMEOUT_DATA]);
 		}
 
 		return -EBUSY;
@@ -140,14 +140,14 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 		goto err_proto_put;
 	}
 
-	ret = ctnl_timeout_parse_policy(&timeout->data, l4proto, net,
+	ret = ctnl_timeout_parse_policy(&timeout->timeout.data, l4proto, net,
 					cda[CTA_TIMEOUT_DATA]);
 	if (ret < 0)
 		goto err;
 
 	strcpy(timeout->name, nla_data(cda[CTA_TIMEOUT_NAME]));
-	timeout->l3num = l3num;
-	timeout->l4proto = l4proto;
+	timeout->timeout.l3num = l3num;
+	timeout->timeout.l4proto = l4proto;
 	refcount_set(&timeout->refcnt, 1);
 	list_add_tail_rcu(&timeout->head, &net->nfct_timeout_list);
 
@@ -166,7 +166,7 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	unsigned int flags = portid ? NLM_F_MULTI : 0;
-	const struct nf_conntrack_l4proto *l4proto = timeout->l4proto;
+	const struct nf_conntrack_l4proto *l4proto = timeout->timeout.l4proto;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK_TIMEOUT, event);
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*nfmsg), flags);
@@ -179,8 +179,9 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	nfmsg->res_id = 0;
 
 	if (nla_put_string(skb, CTA_TIMEOUT_NAME, timeout->name) ||
-	    nla_put_be16(skb, CTA_TIMEOUT_L3PROTO, htons(timeout->l3num)) ||
-	    nla_put_u8(skb, CTA_TIMEOUT_L4PROTO, timeout->l4proto->l4proto) ||
+	    nla_put_be16(skb, CTA_TIMEOUT_L3PROTO,
+			 htons(timeout->timeout.l3num)) ||
+	    nla_put_u8(skb, CTA_TIMEOUT_L4PROTO, l4proto->l4proto) ||
 	    nla_put_be32(skb, CTA_TIMEOUT_USE,
 			 htonl(refcount_read(&timeout->refcnt))))
 		goto nla_put_failure;
@@ -194,7 +195,8 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		if (!nest_parms)
 			goto nla_put_failure;
 
-		ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, &timeout->data);
+		ret = l4proto->ctnl_timeout.obj_to_nlattr(skb,
+							&timeout->timeout.data);
 		if (ret < 0)
 			goto nla_put_failure;
 
@@ -308,8 +310,8 @@ static int ctnl_timeout_try_del(struct net *net, struct ctnl_timeout *timeout)
 	if (refcount_dec_if_one(&timeout->refcnt)) {
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&timeout->head);
-		nf_ct_l4proto_put(timeout->l4proto);
-		nf_ct_untimeout(net, timeout);
+		nf_ct_l4proto_put(timeout->timeout.l4proto);
+		nf_ct_untimeout(net, &timeout->timeout);
 		kfree_rcu(timeout, rcu_head);
 	} else {
 		ret = -EBUSY;
@@ -510,8 +512,11 @@ ctnl_timeout_find_get(struct net *net, const char *name)
 	return matching;
 }
 
-static void ctnl_timeout_put(struct ctnl_timeout *timeout)
+static void ctnl_timeout_put(struct nf_ct_timeout *t)
 {
+	struct ctnl_timeout *timeout =
+		container_of(t, struct ctnl_timeout, timeout);
+
 	if (refcount_dec_and_test(&timeout->refcnt))
 		kfree_rcu(timeout, rcu_head);
 
@@ -561,7 +566,7 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 
 	list_for_each_entry_safe(cur, tmp, &net->nfct_timeout_list, head) {
 		list_del_rcu(&cur->head);
-		nf_ct_l4proto_put(cur->l4proto);
+		nf_ct_l4proto_put(cur->timeout.l4proto);
 
 		if (refcount_dec_and_test(&cur->refcnt))
 			kfree_rcu(cur, rcu_head);
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 7ba454e9e3fa..89457efd2e00 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -104,7 +104,7 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
 }
 
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-static void __xt_ct_tg_timeout_put(struct ctnl_timeout *timeout)
+static void __xt_ct_tg_timeout_put(struct nf_ct_timeout *timeout)
 {
 	typeof(nf_ct_timeout_put_hook) timeout_put;
 
@@ -121,7 +121,7 @@ xt_ct_set_timeout(struct nf_conn *ct, const struct xt_tgchk_param *par,
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	typeof(nf_ct_timeout_find_get_hook) timeout_find_get;
 	const struct nf_conntrack_l4proto *l4proto;
-	struct ctnl_timeout *timeout;
+	struct nf_ct_timeout *timeout;
 	struct nf_conn_timeout *timeout_ext;
 	const char *errmsg = NULL;
 	int ret = 0;
-- 
2.11.0
