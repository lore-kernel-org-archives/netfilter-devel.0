From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: nftables: fix nf_trace always-on with XT_TRACE=n
Date: Sat, 15 Feb 2014 23:48:45 +0100
Message-ID: <1392504525-21134-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52029 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbaBOWwf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Feb 2014 17:52:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using nftables with CONFIG_NETFILTER_XT_TARGET_TRACE=n, we get
lots of "TRACE: filter:output:policy:1 IN=..." warnings as several
places will leave skb->nf_trace uninitialised.

Unlike iptables tracing functionality is not conditional in nftables,
so always copy/zero nf_trace setting when nftables is enabled.

Move this into __nf_copy() helper.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/skbuff.h | 5 ++++-
 net/core/skbuff.c      | 3 ---
 net/ipv4/ip_output.c   | 3 ---
 net/ipv6/ip6_output.c  | 3 ---
 4 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1f689e6..99fc8b3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2724,7 +2724,7 @@ static inline void nf_reset(struct sk_buff *skb)
 
 static inline void nf_reset_trace(struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
 	skb->nf_trace = 0;
 #endif
 }
@@ -2741,6 +2741,9 @@ static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src)
 	dst->nf_bridge  = src->nf_bridge;
 	nf_bridge_get(src->nf_bridge);
 #endif
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+	dst->nf_trace = src->nf_trace;
+#endif
 }
 
 static inline void nf_copy(struct sk_buff *dst, const struct sk_buff *src)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8f519db..875df74 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -705,9 +705,6 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	new->mark		= old->mark;
 	new->skb_iif		= old->skb_iif;
 	__nf_copy(new, old);
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
-	new->nf_trace		= old->nf_trace;
-#endif
 #ifdef CONFIG_NET_SCHED
 	new->tc_index		= old->tc_index;
 #ifdef CONFIG_NET_CLS_ACT
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8971780..73c6b63 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -422,9 +422,6 @@ static void ip_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 	to->tc_index = from->tc_index;
 #endif
 	nf_copy(to, from);
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
-	to->nf_trace = from->nf_trace;
-#endif
 #if defined(CONFIG_IP_VS) || defined(CONFIG_IP_VS_MODULE)
 	to->ipvs_property = from->ipvs_property;
 #endif
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ef02b26..4cfbe0f 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -517,9 +517,6 @@ static void ip6_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 	to->tc_index = from->tc_index;
 #endif
 	nf_copy(to, from);
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
-	to->nf_trace = from->nf_trace;
-#endif
 	skb_copy_secmark(to, from);
 }
 
-- 
1.8.1.5

