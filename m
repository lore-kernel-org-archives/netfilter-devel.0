From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Pkttype match mismatches in OUTPUT chain
Date: Wed, 3 Sep 2008 09:06:08 -0700
Message-ID: <20080903160608.GB8460@linuxace.com>
References: <20080810221835.GA28761@linuxace.com> <20080810225353.GA31138@linuxace.com> <48A2E268.6010808@trash.net> <20080814120240.GA30222@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:46378
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751189AbYICQGI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:06:08 -0400
Content-Disposition: inline
In-Reply-To: <20080814120240.GA30222@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 14, 2008 at 05:02:40AM -0700, Phil Oester wrote:
> On Wed, Aug 13, 2008 at 03:32:24PM +0200, Patrick McHardy wrote:
> > This is getting more and more kludgy, wouldn't it make more sense
> > to move the pkt_type initialisation from the device layer to the
> > protocol layer?
> 
> It would, but that's a large-ish change, and unknown if DaveM would
> support it just to make an iptables match less kludgy.  
> 
> Unfortunately, it doesn't appear this match was tested very thoroughly
> prior to being added to the tree...
> 
> Phil

Any further thoughts on this Patrick?  Longer-term, your plan would help,
but perhaps in the interim we should get this queued up for 2.6.27 so
we have a working match for OUTPUT packets?

Original patch included below.

Phil


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-pkttype-output

diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 7936f7e..7036d43 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -29,18 +29,21 @@ pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
            bool *hotdrop)
 {
 	const struct xt_pkttype_info *info = matchinfo;
-	u_int8_t type;
+	u_int8_t type = 0; 
 
-	if (skb->pkt_type != PACKET_LOOPBACK)
-		type = skb->pkt_type;
-	else if (match->family == AF_INET &&
-	    ipv4_is_multicast(ip_hdr(skb)->daddr))
-		type = PACKET_MULTICAST;
-	else if (match->family == AF_INET6 &&
+	if (match->family == AF_INET) {
+		struct net *net = dev_net(skb->dst->dev);
+		const struct iphdr *iph = ip_hdr(skb);
+		if (ipv4_is_multicast(iph->daddr))
+			type = PACKET_MULTICAST;
+		else if (inet_addr_type(net, iph->daddr) == RTN_BROADCAST)
+			type = PACKET_BROADCAST;
+	} else if (match->family == AF_INET6 &&
 	    ipv6_hdr(skb)->daddr.s6_addr[0] == 0xFF)
 		type = PACKET_MULTICAST;
-	else
-		type = PACKET_BROADCAST;
+
+	if (!type)
+		type = skb->pkt_type;
 
 	return (type == info->pkttype) ^ info->invert;
 }

--DocE+STaALJfprDB--
