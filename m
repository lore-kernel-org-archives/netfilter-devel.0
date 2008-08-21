From: adobriyan@gmail.com
Subject: [PATCH 04/38] netns nf: ip6t_REJECT in netns for real
Date: Fri, 22 Aug 2008 01:58:01 +0400
Message-ID: <20080821215801.GD31136@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	containers@lists.linux-foundation.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:8261 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYHUV4j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:56:39 -0400
Received: by yw-out-2324.google.com with SMTP id 9so9896ywe.1
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2008 14:56:38 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv6/netfilter/ip6t_REJECT.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -35,7 +35,7 @@ MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv6");
 MODULE_LICENSE("GPL");
 
 /* Send RST reply */
-static void send_reset(struct sk_buff *oldskb)
+static void send_reset(struct net *net, struct sk_buff *oldskb)
 {
 	struct sk_buff *nskb;
 	struct tcphdr otcph, *tcph;
@@ -94,7 +94,7 @@ static void send_reset(struct sk_buff *oldskb)
 	fl.fl_ip_sport = otcph.dest;
 	fl.fl_ip_dport = otcph.source;
 	security_skb_classify_flow(oldskb, &fl);
-	dst = ip6_route_output(&init_net, NULL, &fl);
+	dst = ip6_route_output(net, NULL, &fl);
 	if (dst == NULL)
 		return;
 	if (dst->error || xfrm_lookup(&dst, &fl, NULL, 0))
@@ -163,10 +163,11 @@ static void send_reset(struct sk_buff *oldskb)
 }
 
 static inline void
-send_unreach(struct sk_buff *skb_in, unsigned char code, unsigned int hooknum)
+send_unreach(struct net *net, struct sk_buff *skb_in, unsigned char code,
+	     unsigned int hooknum)
 {
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
-		skb_in->dev = init_net.loopback_dev;
+		skb_in->dev = net->loopback_dev;
 
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0, NULL);
 }
@@ -177,6 +178,7 @@ reject_tg6(struct sk_buff *skb, const struct net_device *in,
            const struct xt_target *target, const void *targinfo)
 {
 	const struct ip6t_reject_info *reject = targinfo;
+	struct net *net = dev_net(in ? in : out);
 
 	pr_debug("%s: medium point\n", __func__);
 	/* WARNING: This code causes reentry within ip6tables.
@@ -184,25 +186,25 @@ reject_tg6(struct sk_buff *skb, const struct net_device *in,
 	   must return an absolute verdict. --RR */
 	switch (reject->with) {
 	case IP6T_ICMP6_NO_ROUTE:
-		send_unreach(skb, ICMPV6_NOROUTE, hooknum);
+		send_unreach(net, skb, ICMPV6_NOROUTE, hooknum);
 		break;
 	case IP6T_ICMP6_ADM_PROHIBITED:
-		send_unreach(skb, ICMPV6_ADM_PROHIBITED, hooknum);
+		send_unreach(net, skb, ICMPV6_ADM_PROHIBITED, hooknum);
 		break;
 	case IP6T_ICMP6_NOT_NEIGHBOUR:
-		send_unreach(skb, ICMPV6_NOT_NEIGHBOUR, hooknum);
+		send_unreach(net, skb, ICMPV6_NOT_NEIGHBOUR, hooknum);
 		break;
 	case IP6T_ICMP6_ADDR_UNREACH:
-		send_unreach(skb, ICMPV6_ADDR_UNREACH, hooknum);
+		send_unreach(net, skb, ICMPV6_ADDR_UNREACH, hooknum);
 		break;
 	case IP6T_ICMP6_PORT_UNREACH:
-		send_unreach(skb, ICMPV6_PORT_UNREACH, hooknum);
+		send_unreach(net, skb, ICMPV6_PORT_UNREACH, hooknum);
 		break;
 	case IP6T_ICMP6_ECHOREPLY:
 		/* Do nothing */
 		break;
 	case IP6T_TCP_RESET:
-		send_reset(skb);
+		send_reset(net, skb);
 		break;
 	default:
 		if (net_ratelimit())
-- 
1.5.6.3


