From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH 1/3] bridge-netfilter: simplify IP DNAT
Date: Wed, 14 Apr 2010 15:14:17 +0200
Message-ID: <4BC5BFA9.1060500@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:36407 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0DNNOT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:14:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

bridge-netfilter: simplify IP DNAT

Remove br_netfilter.c::br_nf_local_out(). The function
br_nf_local_out() was needed because the PF_BRIDGE::LOCAL_OUT hook
could be called when IP DNAT happens on to-be-bridged traffic. The
new scheme eliminates this mess.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>

--- nf-next-2.6/include/linux/netfilter_bridge.h.ori	2010-04-14 11:10:24.000000000 +0200
+++ nf-next-2.6/include/linux/netfilter_bridge.h	2010-04-14 12:30:11.000000000 +0200
@@ -41,9 +41,8 @@ enum nf_br_hook_priorities {
 
 #define BRNF_PKT_TYPE			0x01
 #define BRNF_BRIDGED_DNAT		0x02
-#define BRNF_DONT_TAKE_PARENT		0x04
-#define BRNF_BRIDGED			0x08
-#define BRNF_NF_BRIDGE_PREROUTING	0x10
+#define BRNF_BRIDGED			0x04
+#define BRNF_NF_BRIDGE_PREROUTING	0x08
 
 
 /* Only used in br_forward.c */
@@ -68,6 +67,18 @@ static inline unsigned int nf_bridge_enc
 	}
 }
 
+extern int br_handle_frame_finish(struct sk_buff *skb);
+/* Only used in br_device.c */
+static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
+{
+	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+
+	skb_pull(skb, ETH_HLEN);
+	nf_bridge->mask ^= BRNF_BRIDGED_DNAT;
+	skb->dev = nf_bridge->physindev;
+	return br_handle_frame_finish(skb);
+}
+
 /* This is called by the IP fragmenting code and it ensures there is
  * enough room for the encapsulating header (if there is one). */
 static inline unsigned int nf_bridge_pad(const struct sk_buff *skb)
--- nf-next-2.6/net/bridge/br_device.c.ori	2010-04-14 09:38:29.000000000 +0200
+++ nf-next-2.6/net/bridge/br_device.c	2010-04-14 11:43:56.000000000 +0200
@@ -15,7 +15,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
-
+#include <linux/netfilter_bridge.h>
 #include <asm/uaccess.h>
 #include "br_private.h"
 
@@ -28,6 +28,13 @@ netdev_tx_t br_dev_xmit(struct sk_buff *
 	struct net_bridge_mdb_entry *mdst;
 	struct br_cpu_netstats *brstats = this_cpu_ptr(br->stats);
 
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (skb->nf_bridge && (skb->nf_bridge->mask & BRNF_BRIDGED_DNAT)) {
+		br_nf_pre_routing_finish_bridge_slow(skb);
+		return NETDEV_TX_OK;
+	}
+#endif
+
 	brstats->tx_packets++;
 	brstats->tx_bytes += skb->len;
 
--- nf-next-2.6/net/bridge/br_netfilter.c.ori	2010-04-14 11:39:50.000000000 +0200
+++ nf-next-2.6/net/bridge/br_netfilter.c	2010-04-14 12:28:21.000000000 +0200
@@ -246,8 +246,7 @@ static int br_nf_pre_routing_finish_ipv6
 }
 
 /* This requires some explaining. If DNAT has taken place,
- * we will need to fix up the destination Ethernet address,
- * and this is a tricky process.
+ * we will need to fix up the destination Ethernet address.
  *
  * There are two cases to consider:
  * 1. The packet was DNAT'ed to a device in the same bridge
@@ -261,52 +260,38 @@ static int br_nf_pre_routing_finish_ipv6
  * call ip_route_input() and to look at skb->dst->dev, which is
  * changed to the destination device if ip_route_input() succeeds.
  *
- * Let us first consider the case that ip_route_input() succeeds:
- *
- * If skb->dst->dev equals the logical bridge device the packet
- * came in on, we can consider this bridging. The packet is passed
- * through the neighbour output function to build a new destination
- * MAC address, which will make the packet enter br_nf_local_out()
- * not much later. In that function it is assured that the iptables
- * FORWARD chain is traversed for the packet.
+ * Let's first consider the case that ip_route_input() succeeds:
  *
+ * If the output device equals the logical bridge device the packet
+ * came in on, we can consider this bridging. The corresponding MAC
+ * address will be obtained in br_nf_pre_routing_finish_bridge.
  * Otherwise, the packet is considered to be routed and we just
  * change the destination MAC address so that the packet will
  * later be passed up to the IP stack to be routed. For a redirected
  * packet, ip_route_input() will give back the localhost as output device,
  * which differs from the bridge device.
  *
- * Let us now consider the case that ip_route_input() fails:
+ * Let's now consider the case that ip_route_input() fails:
  *
  * This can be because the destination address is martian, in which case
  * the packet will be dropped.
- * After a "echo '0' > /proc/sys/net/ipv4/ip_forward" ip_route_input()
- * will fail, while __ip_route_output_key() will return success. The source
- * address for __ip_route_output_key() is set to zero, so __ip_route_output_key
+ * If IP forwarding is disabled, ip_route_input() will fail, while
+ * ip_route_output_key() can return success. The source
+ * address for ip_route_output_key() is set to zero, so ip_route_output_key()
  * thinks we're handling a locally generated packet and won't care
- * if IP forwarding is allowed. We send a warning message to the users's
- * log telling her to put IP forwarding on.
- *
- * ip_route_input() will also fail if there is no route available.
- * In that case we just drop the packet.
- *
- * --Lennert, 20020411
- * --Bart, 20020416 (updated)
- * --Bart, 20021007 (updated)
- * --Bart, 20062711 (updated) */
+ * if IP forwarding is enabled. If the output device equals the logical bridge
+ * device, we proceed as if ip_route_input() succeeded. If it differs from the
+ * logical bridge port or if ip_route_output_key() fails we drop the packet.
+ */
+
 static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 {
-	if (skb->pkt_type == PACKET_OTHERHOST) {
-		skb->pkt_type = PACKET_HOST;
-		skb->nf_bridge->mask |= BRNF_PKT_TYPE;
-	}
-	skb->nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
-
 	skb->dev = bridge_parent(skb->dev);
 	if (skb->dev) {
 		struct dst_entry *dst = skb_dst(skb);
 
 		nf_bridge_pull_encap_header(skb);
+		skb->nf_bridge->mask |= BRNF_BRIDGED_DNAT;
 
 		if (dst->hh)
 			return neigh_hh_output(dst->hh, skb);
@@ -368,9 +353,6 @@ free_skb:
 		} else {
 			if (skb_dst(skb)->dev == dev) {
 bridged_dnat:
-				/* Tell br_nf_local_out this is a
-				 * bridged frame */
-				nf_bridge->mask |= BRNF_BRIDGED_DNAT;
 				skb->dev = nf_bridge->physindev;
 				nf_bridge_push_encap_header(skb);
 				NF_HOOK_THRESH(NFPROTO_BRIDGE,
@@ -721,54 +703,6 @@ static unsigned int br_nf_forward_arp(un
 	return NF_STOLEN;
 }
 
-/* PF_BRIDGE/LOCAL_OUT ***********************************************
- *
- * This function sees both locally originated IP packets and forwarded
- * IP packets (in both cases the destination device is a bridge
- * device). It also sees bridged-and-DNAT'ed packets.
- *
- * If (nf_bridge->mask & BRNF_BRIDGED_DNAT) then the packet is bridged
- * and we fake the PF_BRIDGE/FORWARD hook. The function br_nf_forward()
- * will then fake the PF_INET/FORWARD hook. br_nf_local_out() has priority
- * NF_BR_PRI_FIRST, so no relevant PF_BRIDGE/INPUT functions have been nor
- * will be executed.
- */
-static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff *skb,
-				    const struct net_device *in,
-				    const struct net_device *out,
-				    int (*okfn)(struct sk_buff *))
-{
-	struct net_device *realindev;
-	struct nf_bridge_info *nf_bridge;
-
-	if (!skb->nf_bridge)
-		return NF_ACCEPT;
-
-	/* Need exclusive nf_bridge_info since we might have multiple
-	 * different physoutdevs. */
-	if (!nf_bridge_unshare(skb))
-		return NF_DROP;
-
-	nf_bridge = skb->nf_bridge;
-	if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT))
-		return NF_ACCEPT;
-
-	/* Bridged, take PF_BRIDGE/FORWARD.
-	 * (see big note in front of br_nf_pre_routing_finish) */
-	nf_bridge->physoutdev = skb->dev;
-	realindev = nf_bridge->physindev;
-
-	if (nf_bridge->mask & BRNF_PKT_TYPE) {
-		skb->pkt_type = PACKET_OTHERHOST;
-		nf_bridge->mask ^= BRNF_PKT_TYPE;
-	}
-	nf_bridge_push_encap_header(skb);
-
-	NF_HOOK(NFPROTO_BRIDGE, NF_BR_FORWARD, skb, realindev, skb->dev,
-		br_forward_finish);
-	return NF_STOLEN;
-}
-
 #if defined(CONFIG_NF_CONNTRACK_IPV4) || defined(CONFIG_NF_CONNTRACK_IPV4_MODULE)
 static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
@@ -797,10 +731,7 @@ static unsigned int br_nf_post_routing(u
 	struct net_device *realoutdev = bridge_parent(skb->dev);
 	u_int8_t pf;
 
-	if (!nf_bridge)
-		return NF_ACCEPT;
-
-	if (!(nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT)))
+	if (!nf_bridge || !(nf_bridge->mask & BRNF_BRIDGED))
 		return NF_ACCEPT;
 
 	if (!realoutdev)
@@ -847,10 +778,8 @@ static unsigned int ip_sabotage_in(unsig
 	return NF_ACCEPT;
 }
 
-/* For br_nf_local_out we need (prio = NF_BR_PRI_FIRST), to insure that innocent
- * PF_BRIDGE/NF_BR_LOCAL_OUT functions don't get bridged traffic as input.
- * For br_nf_post_routing, we need (prio = NF_BR_PRI_LAST), because
- * ip_refrag() can return NF_STOLEN. */
+/* For br_nf_post_routing, we need (prio = NF_BR_PRI_LAST), because
+ * br_dev_queue_push_xmit is called afterwards */
 static struct nf_hook_ops br_nf_ops[] __read_mostly = {
 	{
 		.hook = br_nf_pre_routing,
@@ -881,13 +810,6 @@ static struct nf_hook_ops br_nf_ops[] __
 		.priority = NF_BR_PRI_BRNF,
 	},
 	{
-		.hook = br_nf_local_out,
-		.owner = THIS_MODULE,
-		.pf = PF_BRIDGE,
-		.hooknum = NF_BR_LOCAL_OUT,
-		.priority = NF_BR_PRI_FIRST,
-	},
-	{
 		.hook = br_nf_post_routing,
 		.owner = THIS_MODULE,
 		.pf = PF_BRIDGE,



-- 
Bart De Schuymer
www.artinalgorithms.be
