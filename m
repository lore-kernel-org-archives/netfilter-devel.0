From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in clamp-to-pmtu
Date: Wed, 23 Jan 2008 21:57:36 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801232155020.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, jaco@uls.co.za
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35787 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYAWU5i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 15:57:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On top of standard net branch, no previous patch required.

===
commit 46bfc78a6b91251fd55140b27f382259fc3333a2
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 23 16:35:00 2008 +0100

    [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in clamp-to-pmtu
    
    The TCPMSS target in Xtables should consider the MTU of the reverse
    route on forwarded packets as part of the path MTU.
    
    Point in case: IN=ppp0, OUT=eth0. MSS set to 1460 in spite of MTU of
    ppp0 being 1392.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 60e3767..d2b3a27 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -13,7 +13,10 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
+#include <net/dst.h>
+#include <net/flow.h>
 #include <net/ipv6.h>
+#include <net/route.h>
 #include <net/tcp.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
@@ -41,6 +44,7 @@ optlen(const u_int8_t *opt, unsigned int offset)
 static int
 tcpmss_mangle_packet(struct sk_buff *skb,
 		     const struct xt_tcpmss_info *info,
+		     unsigned int in_mtu,
 		     unsigned int tcphoff,
 		     unsigned int minlen)
 {
@@ -76,7 +80,13 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 				       dst_mtu(skb->dst));
 			return -1;
 		}
-		newmss = dst_mtu(skb->dst) - minlen;
+		if (in_mtu <= minlen) {
+			if (net_ratelimit())
+				printk(KERN_ERR "xt_TCPMSS: unknown or "
+				       "invalid path-MTU (%u)\n", in_mtu);
+			return -1;
+		}
+		newmss = min(dst_mtu(skb->dst), in_mtu) - minlen;
 	} else
 		newmss = info->mss;
 
@@ -137,6 +147,30 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	return TCPOLEN_MSS;
 }
 
+static u_int32_t tcpmss_reverse_mtu4(const struct iphdr *iph)
+{
+	struct flowi fl = {.nl_u = {.ip4_u = {
+		.daddr = iph->saddr,
+		.tos   = RT_TOS(iph->tos),
+		.scope = RT_SCOPE_UNIVERSE,
+	}}};
+	const struct nf_afinfo *ai;
+	struct rtable *rt = NULL;
+	u_int32_t mtu     = ~0U;
+
+	rcu_read_lock();
+	ai = nf_get_afinfo(AF_INET);
+	if (ai != NULL)
+		ai->route((struct dst_entry **)&rt, &fl);
+	rcu_read_unlock();
+
+	if (rt != NULL) {
+		mtu = dst_mtu(&rt->u.dst);
+		dst_release(&rt->u.dst);
+	}
+	return mtu;
+}
+
 static unsigned int
 tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
            const struct net_device *out, unsigned int hooknum,
@@ -146,8 +180,8 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, targinfo, iph->ihl * 4,
-				   sizeof(*iph) + sizeof(struct tcphdr));
+	ret = tcpmss_mangle_packet(skb, targinfo, tcpmss_reverse_mtu4(iph),
+	      iph->ihl * 4, sizeof(*iph) + sizeof(struct tcphdr));
 	if (ret < 0)
 		return NF_DROP;
 	if (ret > 0) {
@@ -160,6 +194,31 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+static u_int32_t tcpmss_reverse_mtu6(const struct ipv6hdr *iph)
+{
+	struct flowi fl = {.nl_u = {.ip6_u = {
+		.daddr     = iph->saddr,
+		.flowlabel = ((iph->flow_lbl[0] << 16) |
+		             (iph->flow_lbl[1] << 8) | iph->flow_lbl[2]) &
+		             0x00FFFFFF,
+	}}};
+	const struct nf_afinfo *ai;
+	struct rtable *rt = NULL;
+	u_int32_t mtu     = ~0U;
+
+	rcu_read_lock();
+	ai = nf_get_afinfo(AF_INET6);
+	if (ai != NULL)
+		ai->route((struct dst_entry **)&rt, &fl);
+	rcu_read_unlock();
+
+	if (rt != NULL) {
+		mtu = dst_mtu(&rt->u.dst);
+		dst_release(&rt->u.dst);
+	}
+	return mtu;
+}
+
 static unsigned int
 tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
            const struct net_device *out, unsigned int hooknum,
@@ -174,8 +233,8 @@ tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr);
 	if (tcphoff < 0)
 		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, targinfo, tcphoff,
-				   sizeof(*ipv6h) + sizeof(struct tcphdr));
+	ret = tcpmss_mangle_packet(skb, targinfo, tcpmss_reverse_mtu6(ipv6h),
+	      tcphoff, sizeof(*ipv6h) + sizeof(struct tcphdr));
 	if (ret < 0)
 		return NF_DROP;
 	if (ret > 0) {

