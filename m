From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/18] netfilter: add struct nf_ct_hook and use it
Date: Wed, 23 May 2018 20:42:51 +0200
Message-ID: <20180523184254.22599-16-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Move the nf_ct_destroy indirection to the struct nf_ct_hook.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h         |  7 ++++++-
 net/netfilter/core.c              | 14 +++++++-------
 net/netfilter/nf_conntrack_core.c |  9 ++++++---
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 72f5871b9a0a..75ded6f6eebe 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -373,13 +373,18 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 
 extern void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *) __rcu;
 void nf_ct_attach(struct sk_buff *, const struct sk_buff *);
-extern void (*nf_ct_destroy)(struct nf_conntrack *) __rcu;
 #else
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif
 
 struct nf_conn;
 enum ip_conntrack_info;
+
+struct nf_ct_hook {
+	void (*destroy)(struct nf_conntrack *);
+};
+extern struct nf_ct_hook __rcu *nf_ct_hook;
+
 struct nlattr;
 
 struct nfnl_ct_hook {
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 907d6ef8f3c1..1bd844ea1d7c 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -563,6 +563,9 @@ EXPORT_SYMBOL(skb_make_writable);
 struct nfnl_ct_hook __rcu *nfnl_ct_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nfnl_ct_hook);
 
+struct nf_ct_hook __rcu *nf_ct_hook __read_mostly;
+EXPORT_SYMBOL_GPL(nf_ct_hook);
+
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 /* This does not belong here, but locally generated errors need it if connection
    tracking in use: without this, connection may not be in hash table, and hence
@@ -585,17 +588,14 @@ void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
 }
 EXPORT_SYMBOL(nf_ct_attach);
 
-void (*nf_ct_destroy)(struct nf_conntrack *) __rcu __read_mostly;
-EXPORT_SYMBOL(nf_ct_destroy);
-
 void nf_conntrack_destroy(struct nf_conntrack *nfct)
 {
-	void (*destroy)(struct nf_conntrack *);
+	struct nf_ct_hook *ct_hook;
 
 	rcu_read_lock();
-	destroy = rcu_dereference(nf_ct_destroy);
-	BUG_ON(destroy == NULL);
-	destroy(nfct);
+	ct_hook = rcu_dereference(nf_ct_hook);
+	BUG_ON(ct_hook == NULL);
+	ct_hook->destroy(nfct);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(nf_conntrack_destroy);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 605441727008..8b2a8644d955 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1813,8 +1813,7 @@ void nf_conntrack_cleanup_start(void)
 
 void nf_conntrack_cleanup_end(void)
 {
-	RCU_INIT_POINTER(nf_ct_destroy, NULL);
-
+	RCU_INIT_POINTER(nf_ct_hook, NULL);
 	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
 	nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_htable_size);
 
@@ -2131,11 +2130,15 @@ int nf_conntrack_init_start(void)
 	return ret;
 }
 
+static struct nf_ct_hook nf_conntrack_hook = {
+	.destroy	= destroy_conntrack,
+};
+
 void nf_conntrack_init_end(void)
 {
 	/* For use by REJECT target */
 	RCU_INIT_POINTER(ip_ct_attach, nf_conntrack_attach);
-	RCU_INIT_POINTER(nf_ct_destroy, destroy_conntrack);
+	RCU_INIT_POINTER(nf_ct_hook, &nf_conntrack_hook);
 }
 
 /*
-- 
2.11.0
