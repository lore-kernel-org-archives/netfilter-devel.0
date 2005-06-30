From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH: NF_CONNTRACK 1/6] resolve conflicts when merging.
Date: Thu, 30 Jun 2005 10:30:33 +0900 (JST)
Message-ID: <200506300130.j5U1UYsT003301@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Jun_30_10:30:33_2005_266)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Thu_Jun_30_10:30:33_2005_266)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch is for resolving conflicts when merging nf_conntrack to the latest
kernel, and is diffs of skbuff.[ch] between mainline kernel.
Maybe you can easily resolve them in manual, so this patch is just for your
reference.

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Jun_30_10:30:33_2005_266)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-conflicts.patch"

Index: include/linux/skbuff.h
===================================================================
--- 9fba45e2b1a769b0f984fa7b780020256ed3b9ba/include/linux/skbuff.h  (mode:100644)
+++ uncommitted/include/linux/skbuff.h  (mode:100644)
@@ -264,6 +264,9 @@
 	__u32			nfcache;
 	__u32			nfctinfo;
 	struct nf_conntrack	*nfct;
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	struct sk_buff		*nfct_reasm;
+#endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	struct nf_bridge_info	*nf_bridge;
 #endif
@@ -1234,10 +1237,26 @@
 	if (nfct)
 		atomic_inc(&nfct->use);
 }
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+static inline void nf_conntrack_get_reasm(struct sk_buff *skb)
+{
+	if (skb)
+		atomic_inc(&skb->users);
+}
+static inline void nf_conntrack_put_reasm(struct sk_buff *skb)
+{
+	if (skb)
+		kfree_skb(skb);
+}
+#endif
 static inline void nf_reset(struct sk_buff *skb)
 {
 	nf_conntrack_put(skb->nfct);
 	skb->nfct = NULL;
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	nf_conntrack_put_reasm(skb->nfct_reasm);
+	skb->nfct_reasm = NULL;
+#endif
 }
 
 #ifdef CONFIG_BRIDGE_NETFILTER
Index: net/core/skbuff.c
===================================================================
--- 9fba45e2b1a769b0f984fa7b780020256ed3b9ba/net/core/skbuff.c  (mode:100644)
+++ uncommitted/net/core/skbuff.c  (mode:100644)
@@ -292,6 +292,9 @@
 	}
 #ifdef CONFIG_NETFILTER
 	nf_conntrack_put(skb->nfct);
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	nf_conntrack_put_reasm(skb->nfct_reasm);
+#endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	nf_bridge_put(skb->nf_bridge);
 #endif
@@ -365,6 +368,10 @@
 	C(nfct);
 	nf_conntrack_get(skb->nfct);
 	C(nfctinfo);
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	C(nfct_reasm);
+	nf_conntrack_get_reasm(skb->nfct_reasm);
+#endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	C(nf_bridge);
 	nf_bridge_get(skb->nf_bridge);
@@ -429,6 +436,10 @@
 	new->nfct	= old->nfct;
 	nf_conntrack_get(old->nfct);
 	new->nfctinfo	= old->nfctinfo;
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	new->nfct_reasm	= old->nfct_reasm;
+	nf_conntrack_get_reasm(old->nfct_reasm);
+#endif
 #ifdef CONFIG_BRIDGE_NETFILTER
 	new->nf_bridge	= old->nf_bridge;
 	nf_bridge_get(old->nf_bridge);

----Next_Part(Thu_Jun_30_10:30:33_2005_266)----
