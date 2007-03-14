From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/22]: conntrack: add nf_copy() to safely copy members
	in skb
Date: Wed, 14 Mar 2007 09:50:43 +0100 (MET)
Message-ID: <20070314085028.15282.48179.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: add nf_copy() to safely copy members in skb

This unifies the codes to copy netfilter related datas. Before copying,
nf_copy() puts original members in destination skb.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 625c028a6c0ccfd684f4334699f9ec7672fd179c
tree 2a28f1dbd73d0dab5458df7203534f9ad7bf942e
parent c3f281b640e4bec1e09a5ec338d3e605c23a3e9e
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 14 Mar 2007 09:32:30 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:32:30 +0100

 include/linux/skbuff.h |   13 +++++++++++++
 net/ipv4/ip_output.c   |   13 +------------
 net/ipv6/ip6_output.c  |   18 +-----------------
 3 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3d4d49d..2451264 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1497,9 +1497,22 @@ #ifdef CONFIG_BRIDGE_NETFILTER
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
index 1abc488..f05ea0e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -384,21 +384,10 @@ static void ip_copy_metadata(struct sk_b
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
index 1900c62..26b834e 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -504,23 +504,7 @@ static void ip6_copy_metadata(struct sk_
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
 
