From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: bridge: fix double POST_ROUTING invocation
Date: Fri, 11 Jan 2008 18:56:56 +0100
Message-ID: <4787ADE8.2010902@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070903020502010209050808"
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58082 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761281AbYAKSBh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:01:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070903020502010209050808
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------070903020502010209050808
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 1a9bf90bb26d520263d06a4e54daae7b37e3d1e5
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 11 18:52:30 2008 +0100

    [NETFILTER]: bridge: fix double POST_ROUTING invocation
    
    The bridge code incorrectly causes two POST_ROUTING hook invocations
    for DNATed packets that end up on the same bridge device. This
    happens because packets with a changed destination address are passed
    to dst_output() to make them go through the neighbour output function
    again to build a new destination MAC address, before they will continue
    through the IP hooks simulated by bridge netfilter.
    
    The resulting hook order is:
     PREROUTING	(bridge netfilter)
     POSTROUTING	(dst_output -> ip_output)
     FORWARD	(bridge netfilter)
     POSTROUTING	(bridge netfilter)
    
    The deferred hooks used to abort the first POST_ROUTING invocation,
    but since the only thing bridge netfilter actually really wants is
    a new MAC address, we can avoid going through the IP stack completely
    by simply calling the neighbour output function directly.
    
    Tested, reported and lots of data provided by: Damien Thebault <damien.thebault@gmail.com>
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index c1757c7..5d8b939 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -247,8 +247,9 @@ static void __br_dnat_complain(void)
  * Let us first consider the case that ip_route_input() succeeds:
  *
  * If skb->dst->dev equals the logical bridge device the packet
- * came in on, we can consider this bridging. We then call
- * skb->dst->output() which will make the packet enter br_nf_local_out()
+ * came in on, we can consider this bridging. The packet is passed
+ * through the neighbour output function to build a new destination
+ * MAC address, which will make the packet enter br_nf_local_out()
  * not much later. In that function it is assured that the iptables
  * FORWARD chain is traversed for the packet.
  *
@@ -285,12 +286,17 @@ static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 	skb->nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
 
 	skb->dev = bridge_parent(skb->dev);
-	if (!skb->dev)
-		kfree_skb(skb);
-	else {
+	if (skb->dev) {
+		struct dst_entry *dst = skb->dst;
+
 		nf_bridge_pull_encap_header(skb);
-		skb->dst->output(skb);
+
+		if (dst->hh)
+			return neigh_hh_output(dst->hh, skb);
+		else if (dst->neighbour)
+			return dst->neighbour->output(skb);
 	}
+	kfree_skb(skb);
 	return 0;
 }
 

--------------070903020502010209050808--
