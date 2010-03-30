From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH/RFC 3/5] bridge-netfilter: simplify IP DNAT and fix IP DNAT
 on encapsulated packets
Date: Tue, 30 Mar 2010 16:16:08 +0200
Message-ID: <4BB207A8.6000608@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:53197 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0C3OQK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:16:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

bridge-netfilter: simplify IP DNAT and fix IP DNAT on encapsulated packets

- Add some code in br_device.c::br_dev_xmit() which enables the
removal of br_netfilter.c::br_nf_local_out(). The function
br_nf_local_out() was needed because the PF_BRIDGE::LOCAL_OUT hook
could be called when IP DNAT happens on to-be-bridged traffic. The
new scheme eliminates this mess.
- Speed up IP DNAT. To obtain the correct destination MAC address,
neigh_hh_output() or dst->neighbour->output() is called. In both
cases this results in the queueing of the packet. However, if dst->hh
is available, we already know the MAC address so we can just copy it
instead, removing the need for neigh_hh_output(). This MAC address is
copied in the new function neigh_hh_bridge().
- fix IP DNAT on vlan- or pppoe-encapsulated traffic: The functions
neigh_hh_output() or dst->neighbour->output() overwrite the complete
Ethernet header, although we only need the destination MAC address.
For encapsulated packets, they ended up overwriting the encapsulating
header. The new code copies the Ethernet source MAC address and
protocol number before calling dst->neighbour->output(). The Ethernet
source MAC and protocol number are copied back in place in 
br_nf_pre_routing_finish_bridge_slow(). This also makes the IP DNAT 
more transparent because in the old scheme the source MAC of the 
bridge was copied into the source address in the Ethernet header. We 
also let skb->protocol equal ETH_P_IP resp. ETH_P_IPV6 during the 
execution of the PF_INET resp. PF_INET6 hooks.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>


--- linux-2.6.33/net/bridge/br_netfilter.c	2010-03-30 14:22:31.000000000 +0200
+++ linux-2.6.33-uml/net/bridge/br_netfilter.c	2010-03-30 14:15:53.000000000 +0200
@@ -196,15 +196,24 @@ static inline void nf_bridge_save_header
 					 skb->nf_bridge->data, header_size);
 }
 
-/*
- * When forwarding bridge frames, we save a copy of the original
- * header before processing.
+static inline void nf_bridge_update_protocol(struct sk_buff *skb)
+{
+	if (skb->nf_bridge->mask & BRNF_8021Q)
+		skb->protocol = htons(ETH_P_8021Q);
+	else if (skb->nf_bridge->mask & BRNF_PPPoE)
+		skb->protocol = htons(ETH_P_PPP_SES);
+}
+
+/* Fill in the header for fragmented IP packets handled by
+ * the IPv4 connection tracking code.
  */
 int nf_bridge_copy_header(struct sk_buff *skb)
 {
 	int err;
-	int header_size = ETH_HLEN + nf_bridge_encap_header_len(skb);
+	unsigned int header_size;
 
+	nf_bridge_update_protocol(skb);
+	header_size = ETH_HLEN + nf_bridge_encap_header_len(skb);
 	err = skb_cow_head(skb, header_size);
 	if (err)
 		return err;
@@ -238,6 +247,7 @@ static int br_nf_pre_routing_finish_ipv6
 	skb_dst_set(skb, &rt->u.dst);
 
 	skb->dev = nf_bridge->physindev;
+	nf_bridge_update_protocol(skb);
 	nf_bridge_push_encap_header(skb);
 	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
 		       br_handle_frame_finish, 1);
@@ -245,9 +255,40 @@ static int br_nf_pre_routing_finish_ipv6
 	return 0;
 }
 
+/* Obtain the correct destination MAC address, while preserving the original
+ * source MAC address. If we already know this address, we just copy it. If we
+ * don't, we use the neighbour framework to find out. In both cases, we make
+ * sure that br_handle_frame_finish() is called afterwards.
+ */
+static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
+{
+	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct dst_entry *dst;
+
+	skb->dev = bridge_parent(skb->dev);
+	if (!skb->dev)
+		goto free_skb;
+	dst = skb_dst(skb);
+	if (dst->hh) {
+		neigh_hh_bridge(dst->hh, skb);
+		skb->dev = nf_bridge->physindev;
+		return br_handle_frame_finish(skb);
+	} else if (dst->neighbour) {
+		/* the neighbour function below overwrites the complete
+		 * MAC header, so we save the Ethernet source address and
+		 * protocol number. */
+		skb_copy_from_linear_data_offset(skb, -8, skb->nf_bridge->data, 8);
+		/* tell br_dev_xmit to continue with forwarding */
+		nf_bridge->mask |= BRNF_BRIDGED_DNAT;
+		return dst->neighbour->output(skb);
+	}
+free_skb:
+	kfree_skb(skb);
+	return 0;
+}
+
 /* This requires some explaining. If DNAT has taken place,
- * we will need to fix up the destination Ethernet address,
- * and this is a tricky process.
+ * we will need to fix up the destination Ethernet address.
  *
  * There are two cases to consider:
  * 1. The packet was DNAT'ed to a device in the same bridge
@@ -261,62 +302,29 @@ static int br_nf_pre_routing_finish_ipv6
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
-static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
-{
-	if (skb->pkt_type == PACKET_OTHERHOST) {
-		skb->pkt_type = PACKET_HOST;
-		skb->nf_bridge->mask |= BRNF_PKT_TYPE;
-	}
-	skb->nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
-
-	skb->dev = bridge_parent(skb->dev);
-	if (skb->dev) {
-		struct dst_entry *dst = skb_dst(skb);
-
-		nf_bridge_pull_encap_header(skb);
-
-		if (dst->hh)
-			return neigh_hh_output(dst->hh, skb);
-		else if (dst->neighbour)
-			return dst->neighbour->output(skb);
-	}
-	kfree_skb(skb);
-	return 0;
-}
-
+ * if IP forwarding is enabled. If the output device equals the logical bridge
+ * device, we proceed as if ip_route_input() succeeded. If it differs from the
+ * logical bridge port or if ip_route_output_key() fails we drop the packet.
+ */
 static int br_nf_pre_routing_finish(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
@@ -368,10 +376,8 @@ free_skb:
 		} else {
 			if (skb_dst(skb)->dev == dev) {
 bridged_dnat:
-				/* Tell br_nf_local_out this is a
-				 * bridged frame */
-				nf_bridge->mask |= BRNF_BRIDGED_DNAT;
 				skb->dev = nf_bridge->physindev;
+				nf_bridge_update_protocol(skb);
 				nf_bridge_push_encap_header(skb);
 				NF_HOOK_THRESH(PF_BRIDGE, NF_BR_PRE_ROUTING,
 					       skb, skb->dev, NULL,
@@ -393,6 +399,7 @@ bridged_dnat:
 	}
 
 	skb->dev = nf_bridge->physindev;
+	nf_bridge_update_protocol(skb);
 	nf_bridge_push_encap_header(skb);
 	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
 		       br_handle_frame_finish, 1);
@@ -413,6 +420,10 @@ static struct net_device *setup_pre_rout
 	nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING;
 	nf_bridge->physindev = skb->dev;
 	skb->dev = bridge_parent(skb->dev);
+	if (skb->protocol == htons(ETH_P_8021Q))
+		nf_bridge->mask |= BRNF_8021Q;
+	else if (skb->protocol == htons(ETH_P_PPP_SES))
+		nf_bridge->mask |= BRNF_PPPoE;
 
 	return skb->dev;
 }
@@ -511,6 +522,7 @@ static unsigned int br_nf_pre_routing_ip
 	if (!setup_pre_routing(skb))
 		return NF_DROP;
 
+	skb->protocol = htons(ETH_P_IPV6);
 	NF_HOOK(PF_INET6, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
 		br_nf_pre_routing_finish_ipv6);
 
@@ -583,6 +595,7 @@ static unsigned int br_nf_pre_routing(un
 	if (!setup_pre_routing(skb))
 		return NF_DROP;
 	store_orig_dstaddr(skb);
+	skb->protocol = htons(ETH_P_IP);
 
 	NF_HOOK(PF_INET, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
 		br_nf_pre_routing_finish);
@@ -631,7 +644,9 @@ static int br_nf_forward_finish(struct s
 	} else {
 		in = *((struct net_device **)(skb->cb));
 	}
+	nf_bridge_update_protocol(skb);
 	nf_bridge_push_encap_header(skb);
+
 	NF_HOOK_THRESH(PF_BRIDGE, NF_BR_FORWARD, skb, in,
 		       skb->dev, br_forward_finish, 1);
 	return 0;
@@ -683,6 +698,10 @@ static unsigned int br_nf_forward_ip(uns
 	/* The physdev module checks on this */
 	nf_bridge->mask |= BRNF_BRIDGED;
 	nf_bridge->physoutdev = skb->dev;
+	if (pf == PF_INET)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
 
 	NF_HOOK(pf, NF_INET_FORWARD, skb, bridge_parent(in), parent,
 		br_nf_forward_finish);
@@ -720,59 +739,10 @@ static unsigned int br_nf_forward_arp(un
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
-	NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, realindev, skb->dev,
-		br_forward_finish);
-	return NF_STOLEN;
-}
-
 #if defined(CONFIG_NF_CONNTRACK_IPV4) || defined(CONFIG_NF_CONNTRACK_IPV4_MODULE)
 static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
-	if (skb->nfct != NULL &&
-	    (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb)) &&
+	if (skb->nfct != NULL && skb->protocol == htons(ETH_P_IP) &&
 	    skb->len > skb->dev->mtu &&
 	    !skb_is_gso(skb))
 		return ip_fragment(skb, br_dev_queue_push_xmit);
@@ -796,10 +766,7 @@ static unsigned int br_nf_post_routing(u
 	struct net_device *realoutdev = bridge_parent(skb->dev);
 	u_int8_t pf;
 
-	if (!nf_bridge)
-		return NF_ACCEPT;
-
-	if (!(nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT)))
+	if (!nf_bridge || !(nf_bridge->mask & BRNF_BRIDGED))
 		return NF_ACCEPT;
 
 	if (!realoutdev)
@@ -823,6 +790,10 @@ static unsigned int br_nf_post_routing(u
 
 	nf_bridge_pull_encap_header(skb);
 	nf_bridge_save_header(skb);
+	if (pf == PF_INET)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
 
 	NF_HOOK(pf, NF_INET_POST_ROUTING, skb, NULL, realoutdev,
 		br_nf_dev_queue_xmit);
@@ -846,10 +817,8 @@ static unsigned int ip_sabotage_in(unsig
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
@@ -880,13 +849,6 @@ static struct nf_hook_ops br_nf_ops[] __
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
--- linux-2.6.33/net/bridge/br_device.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33-uml/net/bridge/br_device.c	2010-03-30 14:15:19.000000000 +0200
@@ -15,7 +15,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
-
+#include <linux/netfilter_bridge.h>
 #include <asm/uaccess.h>
 #include "br_private.h"
 
@@ -26,12 +26,19 @@ netdev_tx_t br_dev_xmit(struct sk_buff *
 	const unsigned char *dest = skb->data;
 	struct net_bridge_fdb_entry *dst;
 
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
-
 	skb_reset_mac_header(skb);
 	skb_pull(skb, ETH_HLEN);
 
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (skb->nf_bridge && (skb->nf_bridge->mask & BRNF_BRIDGED_DNAT)) {
+		br_nf_pre_routing_finish_bridge_slow(skb);
+		return NETDEV_TX_OK;
+	}
+#endif
+
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
+
 	if (dest[0] & 1)
 		br_flood_deliver(br, skb);
 	else if ((dst = __br_fdb_get(br, dest)) != NULL)
--- linux-2.6.33/include/linux/netfilter_bridge.h	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33-uml/include/linux/netfilter_bridge.h	2010-03-30 14:15:19.000000000 +0200
@@ -41,9 +41,10 @@ enum nf_br_hook_priorities {
 
 #define BRNF_PKT_TYPE			0x01
 #define BRNF_BRIDGED_DNAT		0x02
-#define BRNF_DONT_TAKE_PARENT		0x04
-#define BRNF_BRIDGED			0x08
-#define BRNF_NF_BRIDGE_PREROUTING	0x10
+#define BRNF_BRIDGED			0x04
+#define BRNF_NF_BRIDGE_PREROUTING	0x08
+#define BRNF_8021Q			0x10
+#define BRNF_PPPoE			0x20
 
 
 /* Only used in br_forward.c */
@@ -68,6 +69,19 @@ static inline unsigned int nf_bridge_enc
 	}
 }
 
+extern int br_handle_frame_finish(struct sk_buff *skb);
+/* Only used in br_device.c */
+static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
+{
+	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+
+	nf_bridge->mask ^= BRNF_BRIDGED_DNAT;
+	skb_copy_to_linear_data_offset(skb, -(ETH_HLEN-ETH_ALEN),
+				       skb->nf_bridge->data, ETH_HLEN-ETH_ALEN);
+	skb->dev = nf_bridge->physindev;
+	return br_handle_frame_finish(skb);
+}
+
 /* This is called by the IP fragmenting code and it ensures there is
  * enough room for the encapsulating header (if there is one). */
 static inline unsigned int nf_bridge_pad(const struct sk_buff *skb)
--- linux-2.6.33/include/net/neighbour.h	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33-uml/include/net/neighbour.h	2010-03-30 14:15:19.000000000 +0200
@@ -300,6 +300,20 @@ static inline int neigh_event_send(struc
 	return 0;
 }
 
+#ifdef CONFIG_BRIDGE_NETFILTER
+static inline int neigh_hh_bridge(struct hh_cache *hh, struct sk_buff *skb)
+{
+	unsigned seq, hh_alen;
+
+	do {
+		seq = read_seqbegin(&hh->hh_lock);
+		hh_alen = HH_DATA_ALIGN(ETH_HLEN);
+		memcpy(skb->data - hh_alen, hh->hh_data, ETH_ALEN + hh_alen - ETH_HLEN);
+	} while (read_seqretry(&hh->hh_lock, seq));
+	return 0;
+}
+#endif
+
 static inline int neigh_hh_output(struct hh_cache *hh, struct sk_buff *skb)
 {
 	unsigned seq;

-- 
Bart De Schuymer
www.artinalgorithms.be
