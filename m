From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCH 1/1] bridge: detect NAT66 correctly and change MAC address
Date: Fri,  5 Dec 2014 22:12:25 +0100
Message-ID: <1417813945-5050-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, sven@open-mesh.com,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smarthost1.wvnet.at ([62.212.174.130]:40081 "EHLO
	smarthost2.wvnet.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbaLEVOI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:14:08 -0500
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by smarthost1.wvnet.at (Postfix) with ESMTP id EEB84F7B35A
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Dec 2014 22:14:00 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IPv4 allows to redirect any traffic over a bridge to the local machine using
iptables.

$ sysctl -w net.bridge.bridge-nf-call-iptables=1
$ iptables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 \
  -j REDIRECT --to-ports 81

This didn't work with ip6tables because the redirect was not correctly detected.
The bridge pre-routing (finish) netfilter hook has to check for a possible
redirect and then fix the destination mac address. This makes it possible to
use the ip6tables rules for local DNAT REDIRECT similar to the IPv4 version.

$ sysctl -w net.bridge.bridge-nf-call-ip6tables=1
$ ip6tables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 \
  -j REDIRECT --to-ports 81

Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
[bernhard.thaler@wvnet.at: rebased, adjust function order]
Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
taken from http://marc.info/?l=netfilter-devel&m=140837298123062&w=2
rebased to apply to current net-next

 include/linux/netfilter_bridge.h |    2 +
 net/bridge/br_netfilter.c        |  126 +++++++++++++++++++++++++++++---------
 net/ipv6/route.c                 |    1 +
 3 files changed, 100 insertions(+), 29 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index c755e49..9150e8a 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -2,6 +2,7 @@
 #define __LINUX_BRIDGE_NETFILTER_H
 
 #include <uapi/linux/netfilter_bridge.h>
+#include <uapi/linux/in6.h>
 
 
 enum nf_br_hook_priorities {
@@ -107,6 +108,7 @@ static inline unsigned int nf_bridge_pad(const struct sk_buff *skb)
 struct bridge_skb_cb {
 	union {
 		__be32 ipv4;
+		struct in6_addr ipv6;
 	} daddr;
 };
 
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index c190d22..73ea96a 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
@@ -30,11 +31,13 @@
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_arp.h>
 #include <linux/in_route.h>
+#include <linux/ipv6_route.h>
 #include <linux/inetdevice.h>
 
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/route.h>
+#include <net/ip6_route.h>
 #include <net/netfilter/br_netfilter.h>
 
 #include <asm/uaccess.h>
@@ -45,8 +48,14 @@
 
 #define skb_origaddr(skb)	 (((struct bridge_skb_cb *) \
 				 (skb->nf_bridge->data))->daddr.ipv4)
+#define skb_origaddr6(skb)	 (((struct bridge_skb_cb *) \
+				 (skb->nf_bridge->data))->daddr.ipv6)
 #define store_orig_dstaddr(skb)	 (skb_origaddr(skb) = ip_hdr(skb)->daddr)
+#define store_orig_dstaddr6(skb) (skb_origaddr6(skb) = ipv6_hdr(skb)->daddr)
 #define dnat_took_place(skb)	 (skb_origaddr(skb) != ip_hdr(skb)->daddr)
+#define dnat_took_place6(skb)	 (memcmp(&skb_origaddr6(skb), \
+				 &ipv6_hdr(skb)->daddr, \
+				 sizeof(ipv6_hdr(skb)->daddr)) != 0)
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
@@ -239,35 +248,6 @@ drop:
 	return -1;
 }
 
-/* PF_BRIDGE/PRE_ROUTING *********************************************/
-/* Undo the changes made for ip6tables PREROUTING and continue the
- * bridge PRE_ROUTING hook. */
-static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
-{
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
-	struct rtable *rt;
-
-	if (nf_bridge->mask & BRNF_PKT_TYPE) {
-		skb->pkt_type = PACKET_OTHERHOST;
-		nf_bridge->mask ^= BRNF_PKT_TYPE;
-	}
-	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
-
-	rt = bridge_parent_rtable(nf_bridge->physindev);
-	if (!rt) {
-		kfree_skb(skb);
-		return 0;
-	}
-	skb_dst_set_noref(skb, &rt->dst);
-
-	skb->dev = nf_bridge->physindev;
-	nf_bridge_update_protocol(skb);
-	nf_bridge_push_encap_header(skb);
-	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
-		       br_handle_frame_finish, 1);
-
-	return 0;
-}
 
 /* Obtain the correct destination MAC address, while preserving the original
  * source MAC address. If we already know this address, we just copy it. If we
@@ -314,6 +294,93 @@ free_skb:
 	return 0;
 }
 
+/* PF_BRIDGE/PRE_ROUTING *********************************************/
+/* Undo the changes made for ip6tables PREROUTING and continue the
+ * bridge PRE_ROUTING hook. */
+
+/* This requires some explaining. If DNAT has taken place,
+ * we will need to fix up the destination Ethernet address.
+ *
+ * There are two cases to consider:
+ * 1. The packet was DNAT'ed to a device in the same bridge
+ *    port group as it was received on. We can still bridge
+ *    the packet.
+ * 2. The packet was DNAT'ed to a different device, either
+ *    a non-bridged device or another bridge port group.
+ *    The packet will need to be routed.
+ *
+ * The correct way of distinguishing between these two cases is to
+ * call ip6_route_input() and to look at skb->dst->dev, which is
+ * changed to the destination device if ip6_route_input() succeeds.
+ *
+ * Let's first consider the case that ip6_route_input() succeeds:
+ *
+ * If the output device equals the logical bridge device the packet
+ * came in on, we can consider this bridging. The corresponding MAC
+ * address will be obtained in br_nf_pre_routing_finish_bridge.
+ * Otherwise, the packet is considered to be routed and we just
+ * change the destination MAC address so that the packet will
+ * later be passed up to the IP stack to be routed. For a redirected
+ * packet, ip6_route_input() will give back the localhost as output device,
+ * which differs from the bridge device.
+ *
+ * Let's now consider the case that ip6_route_input() fails:
+ *
+ * This can be because the destination address is martian, in which case
+ * the packet will be dropped.
+ */
+static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
+{
+	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct rtable *rt;
+	struct net_device *dev = skb->dev;
+
+	if (nf_bridge->mask & BRNF_PKT_TYPE) {
+		skb->pkt_type = PACKET_OTHERHOST;
+		nf_bridge->mask ^= BRNF_PKT_TYPE;
+	}
+	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
+
+	if (dnat_took_place6(skb)) {
+		skb_dst_drop(skb);
+		ip6_route_input(skb);
+
+		if (skb_dst(skb)->error) {
+			kfree_skb(skb);
+			return 0;
+		}
+
+		if (skb_dst(skb)->dev == dev) {
+			skb->dev = nf_bridge->physindev;
+			nf_bridge_update_protocol(skb);
+			nf_bridge_push_encap_header(skb);
+			NF_HOOK_THRESH(NFPROTO_BRIDGE,
+				       NF_BR_PRE_ROUTING,
+				       skb, skb->dev, NULL,
+				       br_nf_pre_routing_finish_bridge,
+				       1);
+			return 0;
+		}
+		memcpy(eth_hdr(skb)->h_dest, dev->dev_addr, ETH_ALEN);
+		skb->pkt_type = PACKET_HOST;
+	} else {
+		rt = bridge_parent_rtable(nf_bridge->physindev);
+		if (!rt) {
+			kfree_skb(skb);
+			return 0;
+		}
+		skb_dst_set_noref(skb, &rt->dst);
+	}
+
+	skb->dev = nf_bridge->physindev;
+	nf_bridge_update_protocol(skb);
+	nf_bridge_push_encap_header(skb);
+	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
+		       br_handle_frame_finish, 1);
+
+	return 0;
+}
+
 /* This requires some explaining. If DNAT has taken place,
  * we will need to fix up the destination Ethernet address.
  *
@@ -562,6 +629,7 @@ static unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 	if (!setup_pre_routing(skb))
 		return NF_DROP;
 
+	store_orig_dstaddr6(skb);
 	skb->protocol = htons(ETH_P_IPV6);
 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
 		br_nf_pre_routing_finish_ipv6);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index c910831..91a82de 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1025,6 +1025,7 @@ void ip6_route_input(struct sk_buff *skb)
 
 	skb_dst_set(skb, ip6_route_input_lookup(net, skb->dev, &fl6, flags));
 }
+EXPORT_SYMBOL(ip6_route_input);
 
 static struct rt6_info *ip6_pol_route_output(struct net *net, struct fib6_table *table,
 					     struct flowi6 *fl6, int flags)
-- 
1.7.10.4

