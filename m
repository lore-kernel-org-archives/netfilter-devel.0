From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 01/02]: bridge: fix double POST_ROUTING invocation
Date: Tue, 29 Jan 2008 19:08:25 +0100
Message-ID: <479F6B99.60005@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070402000706000703080500"
Cc: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60988 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbYA2SI3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:08:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070402000706000703080500
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

These two patches for stable-2.6.23 fix two problems with the
bridge netfilter code, a double POST_ROUTING hook invocation
with routing between two bridge devices, which breaks NAT,
and some net_device refcount leaks when queueing bridged
packets to userspace.

Please apply, thanks.


--------------070402000706000703080500
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit 42265d7441145c4310926c1dcce339e5bd82b601
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Jan 29 19:02:30 2008 +0100

    [NETFILTER]: bridge: fix double POST_ROUTING invocation
    
    Upstream commit 2948d2ebbb98747b912ac6d0c864b4d02be8a6f5
    
    The bridge code incorrectly causes two POST_ROUTING hook invocations
    for DNATed packets that end up on the same bridge device. This
    happens because packets with a changed destination address are passed
    to dst_output() to make them go through the neighbour output function
    again to build a new destination MAC address, before they will continue
    through the IP hooks simulated by bridge netfilter.
    
    The resulting hook order is:
     PREROUTING (bridge netfilter)
     POSTROUTING        (dst_output -> ip_output)
     FORWARD    (bridge netfilter)
     POSTROUTING        (bridge netfilter)
    
    The deferred hooks used to abort the first POST_ROUTING invocation,
    but since the only thing bridge netfilter actually really wants is
    a new MAC address, we can avoid going through the IP stack completely
    by simply calling the neighbour output function directly.
    
    Tested, reported and lots of data provided by: Damien Thebault <damien.thebault@gmail.com>
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index fc13130..ce48d8c 100644
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
 

--------------070402000706000703080500--
