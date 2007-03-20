From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/2]: conntrack: don't use nfct in skb if conntrack is
 disabled
Date: Tue, 20 Mar 2007 15:07:16 +0900 (JST)
Message-ID: <200703200607.l2K67HXZ025064@toshiba.co.jp>
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


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/linux/netfilter.h |   11 +++++++----
 include/linux/skbuff.h    |   24 +++++++-----------------
 net/core/skbuff.c         |    4 +---
 net/netfilter/core.c      |    2 ++
 4 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 70d3b4f..4777f1b 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -281,9 +281,6 @@ extern void nf_reinject(struct sk_buff *
 			struct nf_info *info,
 			unsigned int verdict);
 
-extern void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
-extern void nf_ct_attach(struct sk_buff *, struct sk_buff *);
-
 /* FIXME: Before cache is ever used, this must be implemented for real. */
 extern void nf_invalidate_cache(int pf);
 
@@ -388,11 +385,17 @@ static inline int nf_hook(int pf, unsign
 {
 	return 1;
 }
-static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 struct flowi;
 static inline void
 nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, int family) {}
 #endif /*CONFIG_NETFILTER*/
 
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+extern void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
+extern void nf_ct_attach(struct sk_buff *, struct sk_buff *);
+#else
+static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
+#endif
+
 #endif /*__KERNEL__*/
 #endif /*__LINUX_NETFILTER_H*/
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4803e4d..865f6d7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -88,11 +88,12 @@
 
 struct net_device;
 
-#ifdef CONFIG_NETFILTER
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 struct nf_conntrack {
 	atomic_t use;
 	void (*destroy)(struct nf_conntrack *);
 };
+#endif
 
 #ifdef CONFIG_BRIDGE_NETFILTER
 struct nf_bridge_info {
@@ -107,8 +108,6 @@ struct nf_bridge_info {
 };
 #endif
 
-#endif
-
 struct sk_buff_head {
 	/* These two members must be first. */
 	struct sk_buff	*next;
@@ -278,15 +277,13 @@ struct sk_buff {
 	__be16			protocol;
 
 	void			(*destructor)(struct sk_buff *skb);
-#ifdef CONFIG_NETFILTER
-	struct nf_conntrack	*nfct;
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	struct nf_conntrack	*nfct;
 	struct sk_buff		*nfct_reasm;
 #endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	struct nf_bridge_info	*nf_bridge;
 #endif
-#endif /* CONFIG_NETFILTER */
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
 #ifdef CONFIG_NET_CLS_ACT
@@ -1557,7 +1554,7 @@ static inline unsigned int skb_checksum_
 		__skb_checksum_complete(skb);
 }
 
-#ifdef CONFIG_NETFILTER
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
 	if (nfct && atomic_dec_and_test(&nfct->use))
@@ -1568,7 +1565,6 @@ static inline void nf_conntrack_get(stru
 	if (nfct)
 		atomic_inc(&nfct->use);
 }
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 static inline void nf_conntrack_get_reasm(struct sk_buff *skb)
 {
 	if (skb)
@@ -1594,9 +1590,9 @@ static inline void nf_bridge_get(struct
 #endif /* CONFIG_BRIDGE_NETFILTER */
 static inline void nf_reset(struct sk_buff *skb)
 {
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_conntrack_put(skb->nfct);
 	skb->nfct = NULL;
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_conntrack_put_reasm(skb->nfct_reasm);
 	skb->nfct_reasm = NULL;
 #endif
@@ -1609,10 +1605,10 @@ static inline void nf_reset(struct sk_bu
 /* Note: This doesn't put any conntrack and bridge info in dst. */
 static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src)
 {
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	dst->nfct = src->nfct;
 	nf_conntrack_get(src->nfct);
 	dst->nfctinfo = src->nfctinfo;
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	dst->nfct_reasm = src->nfct_reasm;
 	nf_conntrack_get_reasm(src->nfct_reasm);
 #endif
@@ -1624,8 +1620,8 @@ static inline void __nf_copy(struct sk_b
 
 static inline void nf_copy(struct sk_buff *dst, const struct sk_buff *src)
 {
-	nf_conntrack_put(dst->nfct);
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	nf_conntrack_put(dst->nfct);
 	nf_conntrack_put_reasm(dst->nfct_reasm);
 #endif
 #ifdef CONFIG_BRIDGE_NETFILTER
@@ -1634,12 +1630,6 @@ static inline void nf_copy(struct sk_buf
 	__nf_copy(dst, src);
 }
 
-#else /* CONFIG_NETFILTER */
-static inline void nf_reset(struct sk_buff *skb) {}
-static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src) {}
-static inline void nf_copy(struct sk_buff *dst, const struct sk_buff *src) {}
-#endif /* CONFIG_NETFILTER */
-
 #ifdef CONFIG_NETWORK_SECMARK
 static inline void skb_copy_secmark(struct sk_buff *to, const struct sk_buff *from)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 88625f9..d78803c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -383,15 +383,13 @@ void __kfree_skb(struct sk_buff *skb)
 		WARN_ON(in_irq());
 		skb->destructor(skb);
 	}
-#ifdef CONFIG_NETFILTER
-	nf_conntrack_put(skb->nfct);
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	nf_conntrack_put(skb->nfct);
 	nf_conntrack_put_reasm(skb->nfct_reasm);
 #endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	nf_bridge_put(skb->nf_bridge);
 #endif
-#endif
 /* XXX: IS this still necessary? - JHS */
 #ifdef CONFIG_NET_SCHED
 	skb->tc_index = 0;
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index c3ebdbd..90e4211 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -244,6 +244,7 @@ void nf_proto_csum_replace4(__sum16 *sum
 }
 EXPORT_SYMBOL(nf_proto_csum_replace4);
 
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 /* This does not belong here, but locally generated errors need it if connection
    tracking in use: without this, connection may not be in hash table, and hence
    manufactured ICMP or RST packets will not be associated with it. */
@@ -263,6 +264,7 @@ void nf_ct_attach(struct sk_buff *new, s
 	}
 }
 EXPORT_SYMBOL(nf_ct_attach);
+#endif
 
 #ifdef CONFIG_PROC_FS
 struct proc_dir_entry *proc_net_netfilter;
-- 
1.4.4
