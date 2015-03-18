From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv2 1/4] bridge: detect NAT66 correctly and change MAC address
Date: Wed, 18 Mar 2015 22:52:11 +0100
Message-ID: <1426715531-16862-1-git-send-email-bernhard.thaler@wvnet.at>
References: <54AF1B47.7020601@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>,
	Sven Eckelmann <sven@open-mesh.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smarthost1.wvnet.at ([62.212.174.130]:20998 "EHLO
	smarthost2.wvnet.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756973AbbCRV7W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 17:59:22 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by smarthost1.wvnet.at (Postfix) with ESMTP id 96C45FD5F81
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2015 22:53:01 +0100 (CET)
In-Reply-To: <54AF1B47.7020601@wvnet.at>
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
[bernhard.thaler@wvnet.at: rebased, add indirect call to ip6_route_input]
Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
Patch revision history:

v2
* re-base again to davem's current net-next
* add indirect call to ip6_route_input via nf_ipv6_ops to avoid 
  direct dependency to ipv6.ko just because of function calls

v1
* rebase "bridge: Allow to redirect IPv6 traffic to local machine"
  to davem's current net-next
* adjust function order to avoid prototype for br_nf_pre_routing_finish_bridge
   
(v0)
* originally there were two patches solving this problem
* Patch from Sven Eckelmann was chosen to base solution on 
  see: bridge: Allow to redirect IPv6 traffic to local machine
  see: bridge: Fix NAT66ed IPv6 packets not being bridged correctly

 include/linux/netfilter_bridge.h |    2 +
 include/linux/netfilter_ipv6.h   |    1 +
 net/bridge/br_netfilter.c        |  128 +++++++++++++++++++++++++++++---------
 net/ipv6/netfilter.c             |    1 +
 4 files changed, 102 insertions(+), 30 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index bb39113..419f3db 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -2,6 +2,7 @@
 #define __LINUX_BRIDGE_NETFILTER_H
 
 #include <uapi/linux/netfilter_bridge.h>
+#include <uapi/linux/in6.h>
 
 
 enum nf_br_hook_priorities {
@@ -57,6 +58,7 @@ static inline unsigned int nf_bridge_pad(const struct sk_buff *skb)
 struct bridge_skb_cb {
 	union {
 		__be32 ipv4;
+		struct in6_addr ipv6;
 	} daddr;
 };
 
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 64dad1cc..e2d1969 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -25,6 +25,7 @@ void ipv6_netfilter_fini(void);
 struct nf_ipv6_ops {
 	int (*chk_addr)(struct net *net, const struct in6_addr *addr,
 			const struct net_device *dev, int strict);
+	void (*route_input)(struct sk_buff *skb);
 };
 
 extern const struct nf_ipv6_ops __rcu *nf_ipv6_ops;
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index b260a97..775d638 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -45,8 +45,14 @@
 
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
@@ -247,36 +253,6 @@ static void nf_bridge_update_protocol(struct sk_buff *skb)
 		skb->protocol = htons(ETH_P_PPP_SES);
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
-
 /* Obtain the correct destination MAC address, while preserving the original
  * source MAC address. If we already know this address, we just copy it. If we
  * don't, we use the neighbour framework to find out. In both cases, we make
@@ -322,6 +298,97 @@ free_skb:
 	return 0;
 }
 
+/* PF_BRIDGE/PRE_ROUTING *********************************************/
+/* Undo the changes made for ip6tables PREROUTING and continue the
+ * bridge PRE_ROUTING hook.
+ */
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
+ * ip6_route_input() is called indirectly via v6ops->route_input to
+ * avoid direct dependency to ipv6.ko due to function calls.
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
+	const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
+
+	if (nf_bridge->mask & BRNF_PKT_TYPE) {
+		skb->pkt_type = PACKET_OTHERHOST;
+		nf_bridge->mask ^= BRNF_PKT_TYPE;
+	}
+	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
+
+	if (dnat_took_place6(skb)) {
+		skb_dst_drop(skb);
+		v6ops->route_input(skb);
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
@@ -570,6 +637,7 @@ static unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 	if (!setup_pre_routing(skb))
 		return NF_DROP;
 
+	store_orig_dstaddr6(skb);
 	skb->protocol = htons(ETH_P_IPV6);
 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
 		br_nf_pre_routing_finish_ipv6);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 398377a..0cd8ec9 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -191,6 +191,7 @@ static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 
 static const struct nf_ipv6_ops ipv6ops = {
 	.chk_addr	= ipv6_chk_addr,
+	.route_input    = ip6_route_input
 };
 
 static const struct nf_afinfo nf_ip6_afinfo = {
-- 
1.7.10.4

