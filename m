From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/22]: conntrack: add __nf_copy() to copy members in skb
Date: Wed, 14 Mar 2007 09:50:42 +0100 (MET)
Message-ID: <20070314085026.15282.72961.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: add __nf_copy() to copy members in skb

This unifies the codes to copy netfilter related datas. Note that
__nf_copy() assumes destination skb doesn't have any netfilter
related members.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c3f281b640e4bec1e09a5ec338d3e605c23a3e9e
tree 9084a7a022b9222cc4d7230f9b885a8693f08296
parent a36f33350b8220397ac33ee98c26e808289a302b
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 14 Mar 2007 09:32:00 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:32:00 +0100

 include/linux/skbuff.h |   17 +++++++++++++++++
 net/core/skbuff.c      |   28 ++--------------------------
 2 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6148cb3..3d4d49d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1481,8 +1481,25 @@ #ifdef CONFIG_BRIDGE_NETFILTER
 #endif
 }
 
+/* Note: This doesn't put any conntrack and bridge info in dst. */
+static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src)
+{
+	dst->nfct = src->nfct;
+	nf_conntrack_get(src->nfct);
+	dst->nfctinfo = src->nfctinfo;
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	dst->nfct_reasm = src->nfct_reasm;
+	nf_conntrack_get_reasm(src->nfct_reasm);
+#endif
+#ifdef CONFIG_BRIDGE_NETFILTER
+	dst->nf_bridge  = src->nf_bridge;
+	nf_bridge_get(src->nf_bridge);
+#endif
+}
+
 #else /* CONFIG_NETFILTER */
 static inline void nf_reset(struct sk_buff *skb) {}
+static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src) {}
 #endif /* CONFIG_NETFILTER */
 
 #ifdef CONFIG_NETWORK_SECMARK
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 05949c9..100af5b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -476,19 +476,7 @@ #endif
 	C(protocol);
 	n->destructor = NULL;
 	C(mark);
-#ifdef CONFIG_NETFILTER
-	C(nfct);
-	nf_conntrack_get(skb->nfct);
-	C(nfctinfo);
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
-	C(nfct_reasm);
-	nf_conntrack_get_reasm(skb->nfct_reasm);
-#endif
-#ifdef CONFIG_BRIDGE_NETFILTER
-	C(nf_bridge);
-	nf_bridge_get(skb->nf_bridge);
-#endif
-#endif /*CONFIG_NETFILTER*/
+	__nf_copy(n, skb);
 #ifdef CONFIG_NET_SCHED
 	C(tc_index);
 #ifdef CONFIG_NET_CLS_ACT
@@ -537,22 +525,10 @@ #endif
 	new->tstamp	= old->tstamp;
 	new->destructor = NULL;
 	new->mark	= old->mark;
-#ifdef CONFIG_NETFILTER
-	new->nfct	= old->nfct;
-	nf_conntrack_get(old->nfct);
-	new->nfctinfo	= old->nfctinfo;
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
-	new->nfct_reasm = old->nfct_reasm;
-	nf_conntrack_get_reasm(old->nfct_reasm);
-#endif
+	__nf_copy(new, old);
 #if defined(CONFIG_IP_VS) || defined(CONFIG_IP_VS_MODULE)
 	new->ipvs_property = old->ipvs_property;
 #endif
-#ifdef CONFIG_BRIDGE_NETFILTER
-	new->nf_bridge	= old->nf_bridge;
-	nf_bridge_get(old->nf_bridge);
-#endif
-#endif
 #ifdef CONFIG_NET_SCHED
 #ifdef CONFIG_NET_CLS_ACT
 	new->tc_verd = old->tc_verd;
