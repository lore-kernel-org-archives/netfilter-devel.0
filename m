From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH:RFC 4/5] bridge-netfilter: fix refragmenting IP traffic encapsulated
 in PPPoE traffic
Date: Tue, 30 Mar 2010 16:16:17 +0200
Message-ID: <4BB207B1.4050502@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:53197 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab0C3OQS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:16:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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

--- linux-2.6.33/net/bridge/br_netfilter.c	2010-03-30 14:25:02.000000000 +0200
+++ linux-2.6.33-uml/net/bridge/br_netfilter.c	2010-03-30 14:29:01.000000000 +0200
@@ -221,6 +221,8 @@ int nf_bridge_copy_header(struct sk_buff
 	skb_copy_to_linear_data_offset(skb, -header_size,
 				       skb->nf_bridge->data, header_size);
 	__skb_push(skb, nf_bridge_encap_header_len(skb));
+	if (unlikely(skb->protocol == htons(ETH_P_PPP_SES)))
+		((struct pppoe_hdr *)skb->data)->length = htons(skb->len-sizeof(struct pppoe_hdr));
 	return 0;
 }
 
@@ -743,7 +745,7 @@ static unsigned int br_nf_forward_arp(un
 static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
 	if (skb->nfct != NULL && skb->protocol == htons(ETH_P_IP) &&
-	    skb->len > skb->dev->mtu &&
+	    skb->len + ((skb->nf_bridge->mask & BRNF_PPPoE) ? PPPOE_SES_HLEN:0) > skb->dev->mtu &&
 	    !skb_is_gso(skb))
 		return ip_fragment(skb, br_dev_queue_push_xmit);
 	else
--- linux-2.6.33/net/ipv4/ip_output.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33-uml/net/ipv4/ip_output.c	2010-03-30 14:31:15.000000000 +0200
@@ -468,6 +468,10 @@ int ip_fragment(struct sk_buff *skb, int
 
 	hlen = iph->ihl * 4;
 	mtu = dst_mtu(&rt->u.dst) - hlen;	/* Size of data space */
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (unlikely(skb->nf_bridge && (skb->nf_bridge->mask & BRNF_PPPoE)))
+		mtu -= PPPOE_SES_HLEN;
+#endif
 	IPCB(skb)->flags |= IPSKB_FRAG_COMPLETE;
 
 	/* When frag_list is given, use it. First, check its validity:

-- 
Bart De Schuymer
www.artinalgorithms.be
