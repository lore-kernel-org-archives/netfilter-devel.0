From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/18] netfilter: add struct nf_nat_hook and use it
Date: Wed, 23 May 2018 20:42:52 +0200
Message-ID: <20180523184254.22599-17-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Move decode_session() and parse_nat_setup_hook() indirections to struct
nf_nat_hook structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h            | 21 ++++++++++++++++-----
 include/net/netfilter/nf_nat_core.h  |  7 -------
 net/netfilter/core.c                 |  8 +++-----
 net/netfilter/nf_conntrack_core.c    |  5 -----
 net/netfilter/nf_conntrack_netlink.c | 10 +++++-----
 net/netfilter/nf_nat_core.c          | 23 ++++++++++++-----------
 6 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 75ded6f6eebe..e8d09dc028f6 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -320,18 +320,29 @@ int nf_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry);
 
 #include <net/flow.h>
-extern void (*nf_nat_decode_session_hook)(struct sk_buff *, struct flowi *);
+
+struct nf_conn;
+enum nf_nat_manip_type;
+struct nlattr;
+
+struct nf_nat_hook {
+	int (*parse_nat_setup)(struct nf_conn *ct, enum nf_nat_manip_type manip,
+			       const struct nlattr *attr);
+	void (*decode_session)(struct sk_buff *skb, struct flowi *fl);
+};
+
+extern struct nf_nat_hook __rcu *nf_nat_hook;
 
 static inline void
 nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 {
 #ifdef CONFIG_NF_NAT_NEEDED
-	void (*decodefn)(struct sk_buff *, struct flowi *);
+	struct nf_nat_hook *nat_hook;
 
 	rcu_read_lock();
-	decodefn = rcu_dereference(nf_nat_decode_session_hook);
-	if (decodefn)
-		decodefn(skb, fl);
+	nat_hook = rcu_dereference(nf_nat_hook);
+	if (nat_hook->decode_session)
+		nat_hook->decode_session(skb, fl);
 	rcu_read_unlock();
 #endif
 }
diff --git a/include/net/netfilter/nf_nat_core.h b/include/net/netfilter/nf_nat_core.h
index c78e9be14b3d..dc7cd0440229 100644
--- a/include/net/netfilter/nf_nat_core.h
+++ b/include/net/netfilter/nf_nat_core.h
@@ -26,11 +26,4 @@ static inline int nf_nat_initialized(struct nf_conn *ct,
 		return ct->status & IPS_DST_NAT_DONE;
 }
 
-struct nlattr;
-
-extern int
-(*nfnetlink_parse_nat_setup_hook)(struct nf_conn *ct,
-				  enum nf_nat_manip_type manip,
-				  const struct nlattr *attr);
-
 #endif /* _NF_NAT_CORE_H */
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 1bd844ea1d7c..e0ae4aae96f5 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -574,6 +574,9 @@ void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *)
 		__rcu __read_mostly;
 EXPORT_SYMBOL(ip_ct_attach);
 
+struct nf_nat_hook __rcu *nf_nat_hook __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_hook);
+
 void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
 {
 	void (*attach)(struct sk_buff *, const struct sk_buff *);
@@ -608,11 +611,6 @@ const struct nf_conntrack_zone nf_ct_zone_dflt = {
 EXPORT_SYMBOL_GPL(nf_ct_zone_dflt);
 #endif /* CONFIG_NF_CONNTRACK */
 
-#ifdef CONFIG_NF_NAT_NEEDED
-void (*nf_nat_decode_session_hook)(struct sk_buff *, struct flowi *);
-EXPORT_SYMBOL(nf_nat_decode_session_hook);
-#endif
-
 static void __net_init __netfilter_net_init(struct nf_hook_entries **e, int max)
 {
 	int h;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8b2a8644d955..8d109d750073 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -58,11 +58,6 @@
 
 #include "nf_internals.h"
 
-int (*nfnetlink_parse_nat_setup_hook)(struct nf_conn *ct,
-				      enum nf_nat_manip_type manip,
-				      const struct nlattr *attr) __read_mostly;
-EXPORT_SYMBOL_GPL(nfnetlink_parse_nat_setup_hook);
-
 __cacheline_aligned_in_smp spinlock_t nf_conntrack_locks[CONNTRACK_LOCKS];
 EXPORT_SYMBOL_GPL(nf_conntrack_locks);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d807b8770be3..39327a42879f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1431,11 +1431,11 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 			  enum nf_nat_manip_type manip,
 			  const struct nlattr *attr)
 {
-	typeof(nfnetlink_parse_nat_setup_hook) parse_nat_setup;
+	struct nf_nat_hook *nat_hook;
 	int err;
 
-	parse_nat_setup = rcu_dereference(nfnetlink_parse_nat_setup_hook);
-	if (!parse_nat_setup) {
+	nat_hook = rcu_dereference(nf_nat_hook);
+	if (!nat_hook) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
 		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
@@ -1446,13 +1446,13 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 		}
 		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
 		rcu_read_lock();
-		if (nfnetlink_parse_nat_setup_hook)
+		if (nat_hook->parse_nat_setup)
 			return -EAGAIN;
 #endif
 		return -EOPNOTSUPP;
 	}
 
-	err = parse_nat_setup(ct, manip, attr);
+	err = nat_hook->parse_nat_setup(ct, manip, attr);
 	if (err == -EAGAIN) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 489599b549cf..f4d264676cfe 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1026,6 +1026,13 @@ static struct pernet_operations nat_net_ops = {
 	.size = sizeof(struct nat_net),
 };
 
+struct nf_nat_hook nat_hook = {
+	.parse_nat_setup	= nfnetlink_parse_nat_setup,
+#ifdef CONFIG_XFRM
+	.decode_session		= __nf_nat_decode_session,
+#endif
+};
+
 static int __init nf_nat_init(void)
 {
 	int ret, i;
@@ -1057,13 +1064,9 @@ static int __init nf_nat_init(void)
 
 	nf_ct_helper_expectfn_register(&follow_master_nat);
 
-	BUG_ON(nfnetlink_parse_nat_setup_hook != NULL);
-	RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook,
-			   nfnetlink_parse_nat_setup);
-#ifdef CONFIG_XFRM
-	BUG_ON(nf_nat_decode_session_hook != NULL);
-	RCU_INIT_POINTER(nf_nat_decode_session_hook, __nf_nat_decode_session);
-#endif
+	WARN_ON(nf_nat_hook != NULL);
+	RCU_INIT_POINTER(nf_nat_hook, &nat_hook);
+
 	return 0;
 }
 
@@ -1076,10 +1079,8 @@ static void __exit nf_nat_cleanup(void)
 
 	nf_ct_extend_unregister(&nat_extend);
 	nf_ct_helper_expectfn_unregister(&follow_master_nat);
-	RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook, NULL);
-#ifdef CONFIG_XFRM
-	RCU_INIT_POINTER(nf_nat_decode_session_hook, NULL);
-#endif
+	RCU_INIT_POINTER(nf_nat_hook, NULL);
+
 	synchronize_rcu();
 
 	for (i = 0; i < NFPROTO_NUMPROTO; i++)
-- 
2.11.0
