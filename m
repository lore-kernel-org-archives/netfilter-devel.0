From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv4 3/3] netfilter: bridge: detect NAT66 correctly and change MAC address
Date: Sat, 30 May 2015 15:27:40 +0200
Message-ID: <1432992460-4057-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>,
	Sven Eckelmann <sven@open-mesh.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.135]:16228 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbbE3N2Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 May 2015 09:28:24 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 5F2B11107EA8
	for <netfilter-devel@vger.kernel.org>; Sat, 30 May 2015 15:28:23 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IPv4 iptables allows to REDIRECT/DNAT/SNAT any traffic over a bridge.

e.g. REDIRECT
$ sysctl -w net.bridge.bridge-nf-call-iptables=1
$ iptables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 \
  -j REDIRECT --to-ports 81

This does not work with ip6tables on a bridge in NAT66 scenario
because the REDIRECT/DNAT/SNAT is not correctly detected.

The bridge pre-routing (finish) netfilter hook has to check for a possible
redirect and then fix the destination mac address. This allows to use the
ip6tables rules for local REDIRECT/DNAT/SNAT REDIRECT similar to the IPv4
iptables version.

e.g. REDIRECT
$ sysctl -w net.bridge.bridge-nf-call-ip6tables=1
$ ip6tables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 \
  -j REDIRECT --to-ports 81

This patch makes it possible to use IPv6 NAT66 on a bridge. It was tested
on a bridge with two interfaces using SNAT/DNAT NAT66 rules.

Reported-by: Artie Hamilton <artiemhamilton@yahoo.com>
Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
[bernhard.thaler@wvnet.at: rebased, add indirect call to ip6_route_input()]
[bernhard.thaler@wvnet.at: rebased, split into separate patches]
Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
Patch revision history:

v4
* re-base again to davem's current net-next
* split into several patches

v3
* re-base again to davem's current net-next
* changed subject to include netfilter 

v2
* re-base again to davem's current net-next
* add indirect call to ip6_route_input via nf_ipv6_ops to avoid 
  direct dependency to ipv6.ko just because of function calls

v1
* rebase "bridge: Allow to redirect IPv6 traffic to local machine"
  to davem's current net-next
* adjust function order to avoid prototype for br_nf_pre_routing_finish_bridge
   
(v0)
* problem first mentioned by Artie Hamilton in "BUG: ip6tables IPv6-REDIRECT
  over bridges"
* originally there were two similar patches solving this problem
* Patch from Sven Eckelmann was chosen to base solution on 
  see: bridge: Allow to redirect IPv6 traffic to local machine
  see: bridge: Fix NAT66ed IPv6 packets not being bridged correctly

 include/linux/netfilter_ipv6.h |    1 +
 include/linux/skbuff.h         |    6 ++++-
 net/bridge/br_netfilter.c      |   55 +++++++++++++++++++++++++++++++++-------
 net/ipv6/netfilter.c           |    1 +
 4 files changed, 53 insertions(+), 10 deletions(-)

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
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6b41c15..5b57cee 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -36,6 +36,7 @@
 #include <linux/sched.h>
 #include <net/flow_dissector.h>
 #include <linux/splice.h>
+#include <linux/in6.h>
 
 /* A. Checksumming of received packets by device.
  *
@@ -179,7 +180,10 @@ struct nf_bridge_info {
 		struct net_device *physoutdev;
 		char neigh_header[8];
 	};
-	__be32			ipv4_daddr;
+	union {
+		__be32          ipv4_daddr;
+		struct in6_addr ipv6_daddr;
+	};
 };
 #endif
 
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 6cb642c..9ac0c64 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -326,30 +326,63 @@ free_skb:
 static bool daddr_was_changed(const struct sk_buff *skb,
 			      const struct nf_bridge_info *nf_bridge)
 {
-	return ip_hdr(skb)->daddr != nf_bridge->ipv4_daddr;
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		return ip_hdr(skb)->daddr != nf_bridge->ipv4_daddr;
+	case htons(ETH_P_IPV6):
+		return memcmp(&nf_bridge->ipv6_daddr, &ipv6_hdr(skb)->daddr,
+			      sizeof(ipv6_hdr(skb)->daddr)) != 0;
+	default:
+		return false;
+	}
 }
 
-/* PF_BRIDGE/PRE_ROUTING *********************************************/
-/* Undo the changes made for ip6tables PREROUTING and continue the
- * bridge PRE_ROUTING hook.
+/* PF_BRIDGE/PRE_ROUTING: Undo the changes made for ip6tables
+ * PREROUTING and continue the bridge PRE_ROUTING hook. See comment
+ * for br_nf_pre_routing_finish(), same logic is used here but
+ * equivalent IPv6 function ip6_route_input() called indirectly.
  */
 static int br_nf_pre_routing_finish_ipv6(struct sock *sk, struct sk_buff *skb)
 {
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 	struct rtable *rt;
+	struct net_device *dev = skb->dev;
+	const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
 
 	if (nf_bridge->pkt_otherhost) {
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->pkt_otherhost = false;
 	}
 	nf_bridge->mask &= ~BRNF_NF_BRIDGE_PREROUTING;
+	if (daddr_was_changed(skb, nf_bridge)) {
+		skb_dst_drop(skb);
+		v6ops->route_input(skb);
 
-	rt = bridge_parent_rtable(nf_bridge->physindev);
-	if (!rt) {
-		kfree_skb(skb);
-		return 0;
+		if (skb_dst(skb)->error) {
+			kfree_skb(skb);
+			return 0;
+		}
+
+		if (skb_dst(skb)->dev == dev) {
+			skb->dev = nf_bridge->physindev;
+			nf_bridge_update_protocol(skb);
+			nf_bridge_push_encap_header(skb);
+			NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING,
+				       sk, skb, skb->dev, NULL,
+				       br_nf_pre_routing_finish_bridge,
+				       1);
+			return 0;
+		}
+		ether_addr_copy(eth_hdr(skb)->h_dest, dev->dev_addr);
+		skb->pkt_type = PACKET_HOST;
+	} else {
+		rt = bridge_parent_rtable(nf_bridge->physindev);
+		if (!rt) {
+			kfree_skb(skb);
+			return 0;
+		}
+		skb_dst_set_noref(skb, &rt->dst);
 	}
-	skb_dst_set_noref(skb, &rt->dst);
 
 	skb->dev = nf_bridge->physindev;
 	nf_bridge_update_protocol(skb);
@@ -579,6 +612,7 @@ static unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 					   struct sk_buff *skb,
 					   const struct nf_hook_state *state)
 {
+	struct nf_bridge_info *nf_bridge;
 	const struct ipv6hdr *hdr;
 	u32 pkt_len;
 
@@ -610,6 +644,9 @@ static unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 	if (!setup_pre_routing(skb))
 		return NF_DROP;
 
+	nf_bridge = nf_bridge_info_get(skb);
+	nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;
+
 	skb->protocol = htons(ETH_P_IPV6);
 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->sk, skb,
 		skb->dev, NULL,
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index d958718..bbca09f 100644
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

