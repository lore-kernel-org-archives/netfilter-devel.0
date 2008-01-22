From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/2] [NETFILTER]: xt_TCPMSS: Consider incoming device's
 MTU in clamp-to-pmtu
Date: Tue, 22 Jan 2008 22:10:02 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801222204290.9183@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801201318040.14598@fbirervta.pbzchgretzou.qr>
 <47935127.30902@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: Jaco Kroon <jaco@uls.co.za>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52568 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYAVVKE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:10:04 -0500
In-Reply-To: <47935127.30902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Jan 20 2008 14:48, Patrick McHardy wrote:
>> -				   sizeof(*ipv6h) + sizeof(struct tcphdr));
>> +	ret = tcpmss_mangle_packet(skb, targinfo, (in == NULL) ? ~0U : in->mtu,
>> +	      tcphoff, sizeof(*ipv6h) + sizeof(struct tcphdr));
>
>
> This is slightly better than what we currently have, but it should
> actually use the MTU from the dst_entry for the reverse direction.
> I've tried adding this not too long ago and ran into some problems,
> but I can't remember the exact details.
>

Jaco, please test this one (goes on top of the previous MTU patch).

===Patch begins===
commit f75cb772940a1c18e36166a962b54ec60b89b2fa
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Jan 22 21:52:43 2008 +0100

    [NETFILTER]: xt_TCPMSS: Consider reverse route MTU in clamp-to-pmtu
    
    Just using in_dev->mtu is not right; what we need is the reverse
    route MTU.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 2c446b6..e0586e3 100644
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
@@ -144,6 +147,21 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	return TCPOLEN_MSS;
 }
 
+static u_int16_t tcpmss_reverse_mtu4(const struct iphdr *iph)
+{
+	struct rtable *rt = NULL;
+	struct flowi fl = {.nl_u = {.ip4_u = {
+		.daddr = iph->saddr,
+		.tos   = RT_TOS(iph->tos),
+		.scope = RT_SCOPE_UNIVERSE,
+	}}};
+
+	ip_route_output_key(&rt, &fl);
+	if (rt == NULL)
+		return ~(u_int16_t)0;
+	return dst_mtu(&rt->u.dst);
+}
+
 static unsigned int
 tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
            const struct net_device *out, unsigned int hooknum,
@@ -153,7 +171,7 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, targinfo, (in == NULL) ? ~0U : in->mtu,
+	ret = tcpmss_mangle_packet(skb, targinfo, tcpmss_reverse_mtu4(iph),
 	      iph->ihl * 4, sizeof(*iph) + sizeof(struct tcphdr));
 	if (ret < 0)
 		return NF_DROP;
@@ -167,6 +185,22 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+static u_int16_t tcpmss_reverse_mtu6(const struct ipv6hdr *iph)
+{
+	struct rtable *rt = NULL;
+	struct flowi fl = {.nl_u = {.ip6_u = {
+		.daddr     = iph->saddr,
+		.flowlabel = ((iph->flow_lbl[0] << 16) |
+		             (iph->flow_lbl[1] << 8) | iph->flow_lbl[2]) &
+		             0x00FFFFFF,
+	}}};
+
+	ip_route_output_key(&rt, &fl);
+	if (rt == NULL)
+		return ~(u_int16_t)0;
+	return dst_mtu(&rt->u.dst);
+}
+
 static unsigned int
 tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
            const struct net_device *out, unsigned int hooknum,
@@ -181,7 +215,7 @@ tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr);
 	if (tcphoff < 0)
 		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, targinfo, (in == NULL) ? ~0U : in->mtu,
+	ret = tcpmss_mangle_packet(skb, targinfo, tcpmss_reverse_mtu6(ipv6h),
 	      tcphoff, sizeof(*ipv6h) + sizeof(struct tcphdr));
 	if (ret < 0)
 		return NF_DROP;
