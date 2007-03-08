From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 02/04]: conntrack: add nf_copy() to safely copy members in
 skb
Date: Fri, 09 Mar 2007 01:23:17 +0900 (JST)
Message-ID: <200703081623.l28GNIMd015118@toshiba.co.jp>
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


This unifies the codes to copy netfilter related datas. Before copying,
nf_copy() puts original members in destination skb.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/linux/skbuff.h |   13 +++++++++++++
 net/ipv4/ip_output.c   |   13 +------------
 net/ipv6/ip6_output.c  |   18 +-----------------
 3 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0e179bb..6aa68f0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1470,9 +1470,22 @@ static inline void __nf_copy(struct sk_b
 #endif
 }
 
+static inline void nf_copy(struct sk_buff *dst, const struct sk_buff *src)
+{
+	nf_conntrack_put(dst->nfct);
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	nf_conntrack_put_reasm(dst->nfct_reasm);
+#endif
+#ifdef CONFIG_BRIDGE_NETFILTER
+	nf_bridge_put(dst->nf_bridge);
+#endif
+	__nf_copy(dst, src);
+}
+
 #else /* CONFIG_NETFILTER */
 static inline void nf_reset(struct sk_buff *skb) {}
 static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src) {}
+static inline void nf_copy(struct sk_buff *dst, const struct sk_buff *src) {}
 #endif /* CONFIG_NETFILTER */
 
 #ifdef CONFIG_NETWORK_SECMARK
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d096332..d6844a1 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -386,21 +386,10 @@ static void ip_copy_metadata(struct sk_b
 #ifdef CONFIG_NET_SCHED
 	to->tc_index = from->tc_index;
 #endif
-#ifdef CONFIG_NETFILTER
-	/* Connection association is same as pre-frag packet */
-	nf_conntrack_put(to->nfct);
-	to->nfct = from->nfct;
-	nf_conntrack_get(to->nfct);
-	to->nfctinfo = from->nfctinfo;
+	nf_copy(to, from);
 #if defined(CONFIG_IP_VS) || defined(CONFIG_IP_VS_MODULE)
 	to->ipvs_property = from->ipvs_property;
 #endif
-#ifdef CONFIG_BRIDGE_NETFILTER
-	nf_bridge_put(to->nf_bridge);
-	to->nf_bridge = from->nf_bridge;
-	nf_bridge_get(to->nf_bridge);
-#endif
-#endif
 	skb_copy_secmark(to, from);
 }
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 3055169..855ec87 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -499,23 +499,7 @@ static void ip6_copy_metadata(struct sk_
 #ifdef CONFIG_NET_SCHED
 	to->tc_index = from->tc_index;
 #endif
-#ifdef CONFIG_NETFILTER
-	/* Connection association is same as pre-frag packet */
-	nf_conntrack_put(to->nfct);
-	to->nfct = from->nfct;
-	nf_conntrack_get(to->nfct);
-	to->nfctinfo = from->nfctinfo;
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
-	nf_conntrack_put_reasm(to->nfct_reasm);
-	to->nfct_reasm = from->nfct_reasm;
-	nf_conntrack_get_reasm(to->nfct_reasm);
-#endif
-#ifdef CONFIG_BRIDGE_NETFILTER
-	nf_bridge_put(to->nf_bridge);
-	to->nf_bridge = from->nf_bridge;
-	nf_bridge_get(to->nf_bridge);
-#endif
-#endif
+	nf_copy(to, from);
 	skb_copy_secmark(to, from);
 }
 
-- 
1.4.4
