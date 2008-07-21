From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 06/08: xt_TCPMSS: collapse tcpmss_reverse_mtu{4,6} into one function
Date: Mon, 21 Jul 2008 18:17:31 +0200 (MEST)
Message-ID: <20080721161730.28572.62125.sendpatchset@localhost.localdomain>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41634 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYGUQRc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:17:32 -0400
In-Reply-To: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: xt_TCPMSS: collapse tcpmss_reverse_mtu{4,6} into one function

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 373729398480d3132bb04f8cea368bf4746eee79
tree 6d1b31d1c11d8a2153bb96b8982885db49e11f10
parent a2f9df434bac7b6dd1a14fa6867e6165d7ed587a
author Jan Engelhardt <jengelh@medozas.de> Mon, 21 Jul 2008 18:05:57 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 21 Jul 2008 18:05:57 +0200

 net/netfilter/xt_TCPMSS.c |   42 +++++++++++++-----------------------------
 1 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 217e2b6..beb5094 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -147,17 +147,21 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	return TCPOLEN_MSS;
 }
 
-static u_int32_t tcpmss_reverse_mtu4(const struct iphdr *iph)
+static u_int32_t tcpmss_reverse_mtu(const struct sk_buff *skb,
+				    unsigned int family)
 {
-	struct flowi fl = {
-		.fl4_dst = iph->saddr,
-	};
+	struct flowi fl = {};
 	const struct nf_afinfo *ai;
 	struct rtable *rt = NULL;
 	u_int32_t mtu     = ~0U;
 
+	if (family == PF_INET)
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
@@ -178,7 +182,8 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, targinfo, tcpmss_reverse_mtu4(iph),
+	ret = tcpmss_mangle_packet(skb, targinfo,
+				   tcpmss_reverse_mtu(skb, PF_INET),
 				   iph->ihl * 4,
 				   sizeof(*iph) + sizeof(struct tcphdr));
 	if (ret < 0)
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
+				   tcpmss_reverse_mtu(skb, PF_INET6),
 				   tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
 	if (ret < 0)
