From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 23/24] [NETFILTER]: Collapse tcpmss_reverse_mtu{4,6} into one function
Date: Wed,  2 Apr 2008 13:12:05 +0200
Message-ID: <c4afa44fe53b549b086d5fd98e519861907e8946.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43155 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbYDBLMM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:12 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/netfilter/xt_TCPMSS.c |   46 ++++++++++++-------------------------
 1 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 217e2b6..1be63e6 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -147,17 +147,21 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	return TCPOLEN_MSS;
 }
 
-static u_int32_t tcpmss_reverse_mtu4(const struct iphdr *iph)
+static u_int32_t tcpmss_reverse_mtu(const struct sk_buff *skb,
+                                    unsigned int family)
 {
-	struct flowi fl = {
-		.fl4_dst = iph->saddr,
-	};
+	struct flowi fl = {};
 	const struct nf_afinfo *ai;
 	struct rtable *rt = NULL;
 	u_int32_t mtu     = ~0U;
 
+	if (family == AF_INET)
+		fl.fl4_dst = ip_hdr(skb)->saddr;
+	else
+		fl.fl6_dst = ipv6_hdr(skb)->saddr;
+
 	rcu_read_lock();
-	ai = nf_get_afinfo(AF_INET);
+	ai = nf_get_afinfo(family);
 	if (ai != NULL)
 		ai->route((struct dst_entry **)&rt, &fl);
 	rcu_read_unlock();
@@ -178,9 +182,10 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, targinfo, tcpmss_reverse_mtu4(iph),
-				   iph->ihl * 4,
-				   sizeof(*iph) + sizeof(struct tcphdr));
+	ret = tcpmss_mangle_packet(skb, targinfo,
+	                           tcpmss_reverse_mtu(skb, AF_INET),
+	                           iph->ihl * 4,
+	                           sizeof(*iph) + sizeof(struct tcphdr));
 	if (ret < 0)
 		return NF_DROP;
 	if (ret > 0) {
@@ -193,28 +198,6 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-static u_int32_t tcpmss_reverse_mtu6(const struct ipv6hdr *iph)
-{
-	struct flowi fl = {
-		.fl6_dst = iph->saddr,
-	};
-	const struct nf_afinfo *ai;
-	struct rtable *rt = NULL;
-	u_int32_t mtu     = ~0U;
-
-	rcu_read_lock();
-	ai = nf_get_afinfo(AF_INET6);
-	if (ai != NULL)
-		ai->route((struct dst_entry **)&rt, &fl);
-	rcu_read_unlock();
-
-	if (rt != NULL) {
-		mtu = dst_mtu(&rt->u.dst);
-		dst_release(&rt->u.dst);
-	}
-	return mtu;
-}
-
 static unsigned int
 tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
            const struct net_device *out, unsigned int hooknum,
@@ -229,7 +212,8 @@ tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr);
 	if (tcphoff < 0)
 		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, targinfo, tcpmss_reverse_mtu6(ipv6h),
+	ret = tcpmss_mangle_packet(skb, targinfo,
+	                           tcpmss_reverse_mtu(skb, AF_INET6),
 				   tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
 	if (ret < 0)
-- 
1.5.4.4

