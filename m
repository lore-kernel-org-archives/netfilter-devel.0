From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Pkttype match mismatches in OUTPUT chain
Date: Sun, 10 Aug 2008 15:53:53 -0700
Message-ID: <20080810225353.GA31138@linuxace.com>
References: <20080810221835.GA28761@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:45183
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751472AbYHJWxy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Aug 2008 18:53:54 -0400
Content-Disposition: inline
In-Reply-To: <20080810221835.GA28761@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Minor change to fix compile warning.

On Sun, Aug 10, 2008 at 03:18:35PM -0700, Phil Oester wrote:
> Back in 7/2006, we fixed an issue with the pkttype match mismatching
> on locally generated packets.[1]  At the time, I didn't test the fix
> in the OUTPUT chain, but only in the INPUT chain, where packets showed
> up as PACKET_LOOPBACK.  Unfortunately, when packets are output, they
> aren't tagged as PACKET_LOOPBACK so the fix was incomplete.
> 
> Below is another attempt at fixing the problem in all cases, and fixes
> the original netfilter bugzilla #484 as well as a new bug submission (which
> I can't get the number of since bugzilla is presently down).  
> 
> The fix is somewhat complicated because when broadcast packets hit the
> OUTPUT chain they have no destination MAC attached, so the "simple"
> test for 'all FF' doesn't work for us, and instead we have to consult the
> routing table.
> 
> One other note: since IPv6 doesn't have the concept of "broadcast", perhaps
> the userspace extension shouldn't allow broadcast rules to be added for
> that family?
> 
> Phil
> 
> Signed-off-by: Phil Oester <kernel@linuxace.com>
> 
> [1] http://marc.info/?l=netfilter-devel&m=115318495708540&w=2



--GvXjxJ+pjyke8COw
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

--GvXjxJ+pjyke8COw--
