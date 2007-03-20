From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/2]: conntrack: kill destroy() in struct nf_conntrack for
 diet
Date: Tue, 20 Mar 2007 15:07:24 +0900 (JST)
Message-ID: <200703200607.l2K67Pbq025155@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


The destructor per conntrack is unnecessary, then this replaces it with
system wide destructor.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/linux/netfilter.h         |    1 +
 include/linux/skbuff.h            |    7 +------
 net/netfilter/core.c              |   19 ++++++++++++++++++-
 net/netfilter/nf_conntrack_core.c |    4 +++-
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 4777f1b..10b5c62 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -393,6 +393,7 @@ nf_nat_decode_session(struct sk_buff *sk
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 extern void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
 extern void nf_ct_attach(struct sk_buff *, struct sk_buff *);
+extern void (*nf_ct_destroy)(struct nf_conntrack *);
 #else
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 865f6d7..ac3090a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -91,7 +91,6 @@ struct net_device;
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 struct nf_conntrack {
 	atomic_t use;
-	void (*destroy)(struct nf_conntrack *);
 };
 #endif
 
@@ -1555,11 +1554,7 @@ static inline unsigned int skb_checksum_
 }
 
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
-static inline void nf_conntrack_put(struct nf_conntrack *nfct)
-{
-	if (nfct && atomic_dec_and_test(&nfct->use))
-		nfct->destroy(nfct);
-}
+extern void nf_conntrack_put(struct nf_conntrack *nfct);
 static inline void nf_conntrack_get(struct nf_conntrack *nfct)
 {
 	if (nfct)
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 90e4211..82f4640 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -264,7 +264,24 @@ void nf_ct_attach(struct sk_buff *new, s
 	}
 }
 EXPORT_SYMBOL(nf_ct_attach);
-#endif
+
+void (*nf_ct_destroy)(struct nf_conntrack *);
+EXPORT_SYMBOL(nf_ct_destroy);
+
+void nf_conntrack_put(struct nf_conntrack *nfct)
+{
+	void (*destroy)(struct nf_conntrack *);
+
+	if (nfct && atomic_dec_and_test(&nfct->use)) {
+		rcu_read_lock();
+		destroy = rcu_dereference(nf_ct_destroy);
+		BUG_ON(destroy == NULL);
+		destroy(nfct);
+		rcu_read_unlock();
+	}
+}
+EXPORT_SYMBOL(nf_conntrack_put);
+#endif /* CONFIG_NF_CONNTRACK */
 
 #ifdef CONFIG_PROC_FS
 struct proc_dir_entry *proc_net_netfilter;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2b0cc7a..b280d5d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -634,7 +634,6 @@ __nf_conntrack_alloc(const struct nf_con
 	memset(conntrack, 0, nf_ct_cache[features].size);
 	conntrack->features = features;
 	atomic_set(&conntrack->ct_general.use, 1);
-	conntrack->ct_general.destroy = destroy_conntrack;
 	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *repl;
 	/* Don't set timer yet: wait for confirmation */
@@ -1141,6 +1140,8 @@ void nf_conntrack_cleanup(void)
 	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
 		schedule();
 
+	rcu_assign_pointer(nf_ct_destroy, NULL);
+
 	for (i = 0; i < NF_CT_F_NUM; i++) {
 		if (nf_ct_cache[i].use == 0)
 			continue;
@@ -1278,6 +1279,7 @@ int __init nf_conntrack_init(void)
 
 	/* For use by REJECT target */
 	rcu_assign_pointer(ip_ct_attach, __nf_conntrack_attach);
+	rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
 
 	/* Set up fake conntrack:
 	    - to never be deleted, not in any hashes */
-- 
1.4.4
