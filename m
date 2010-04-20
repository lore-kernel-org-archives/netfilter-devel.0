From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 3/3] bridge-netfilter: fix refragmenting IP traffic encapsulated
 in PPPoE traffic
Date: Tue, 20 Apr 2010 15:33:49 +0200
Message-ID: <4BCDAD3D.80604@pandora.be>
References: <4BC5BFB4.4080101@pandora.be> <4BC6EA8D.2030602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:43822 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab0DTNdw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:33:52 -0400
In-Reply-To: <4BC6EA8D.2030602@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Bart De Schuymer wrote:
>> bridge-netfilter: fix refragmenting IP traffic encapsulated in PPPoE
>> traffic
> 
> I think it would be nice to encapsulate this in a small inline
> function, perhaps nf_bridge_adjust_mtu(skb, mtu) or something
> like that.
> 
> Please also fix the overly long lines.

Done, see below.

bridge-netfilter: fix refragmenting IP traffic encapsulated in PPPoE traffic
 
The MTU for IP traffic encapsulated inside PPPoE traffic is smaller
than the MTU of the Ethernet device (1500). Connection tracking
gathers all IP packets and sometimes will refragment them in
ip_fragment(). We then need to subtract the length of the
encapsulating header from the mtu used in ip_fragment(). The check in
br_nf_dev_queue_xmit() which determines if ip_fragment() has to be
called is also updated for the PPPoE-encapsulated packets.
nf_bridge_copy_header() is also updated to make sure the PPPoE data
length field has the correct value.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>

--- nf-next-2.6/include/linux/netfilter_bridge.h.ori3	2010-04-20 14:59:36.000000000 +0200
+++ nf-next-2.6/include/linux/netfilter_bridge.h	2010-04-20 15:19:58.000000000 +0200
@@ -68,6 +68,13 @@ static inline unsigned int nf_bridge_enc
 	}
 }
 
+static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
+{
+	if (unlikely(skb->nf_bridge->mask & BRNF_PPPoE))
+		return PPPOE_SES_HLEN;
+	return 0;
+}
+
 extern int br_handle_frame_finish(struct sk_buff *skb);
 /* Only used in br_device.c */
 static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
--- nf-next-2.6/net/ipv4/ip_output.c.ori	2010-04-14 14:01:28.000000000 +0200
+++ nf-next-2.6/net/ipv4/ip_output.c	2010-04-20 15:05:27.000000000 +0200
@@ -468,6 +468,10 @@ int ip_fragment(struct sk_buff *skb, int
 
 	hlen = iph->ihl * 4;
 	mtu = dst_mtu(&rt->u.dst) - hlen;	/* Size of data space */
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (skb->nf_bridge)
+		mtu -= nf_bridge_mtu_reduction(skb);
+#endif
 	IPCB(skb)->flags |= IPSKB_FRAG_COMPLETE;
 
 	/* When frag_list is given, use it. First, check its validity:
--- nf-next-2.6/net/bridge/br_netfilter.c.ori3	2010-04-14 14:06:05.000000000 +0200
+++ nf-next-2.6/net/bridge/br_netfilter.c	2010-04-20 15:03:10.000000000 +0200
@@ -744,7 +744,7 @@ static unsigned int br_nf_forward_arp(un
 static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
 	if (skb->nfct != NULL && skb->protocol == htons(ETH_P_IP) &&
-	    skb->len > skb->dev->mtu &&
+	    skb->len + nf_bridge_mtu_reduction(skb) > skb->dev->mtu &&
 	    !skb_is_gso(skb))
 		return ip_fragment(skb, br_dev_queue_push_xmit);
 	else


-- 
Bart De Schuymer
www.artinalgorithms.be
