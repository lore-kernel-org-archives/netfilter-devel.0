From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] bridge: netfilter: don't call iptables on vlan packets if sysctl is off
Date: Thu,  1 Mar 2012 22:42:34 +0100
Message-ID: <1330638154-1142-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>, Jiri Pirko <jpirko@redhat.com>,
	Jesse Gross <jesse@nicira.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60989 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964855Ab2CAVqn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:46:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When net.bridge.bridge-nf-filter-vlan-tagged is 0 (default), vlan packets
arriving should not be sent to ip(6)tables by bridge netfilter.

However, it turns out that we currently always send VLAN packets to
netfilter, if ..
a), CONFIG_VLAN_8021Q is enabled ; or
b), CONFIG_VLAN_8021Q is not set but rx vlan offload is enabled
   on the bridge port.

This is because bridge netfilter treats skb with
skb->protocol == ETH_P_IP{V6} as "non-vlan packet".

With rx vlan offload on or CONFIG_VLAN_8021Q=y, the vlan header has
already been removed here, and we cannot rely on skb->protocol.

Fix this by only using skb->protocol if the skb has no vlan tag,
or if a vlan tag is present and filter-vlan-tagged bridge netfilter
sysctl is enabled.

We cannot remove the skb->protocol == htons(ETH_P_8021Q) test
because the vlan tag is still around in the CONFIG_VLAN_8021Q=n &&
"ethtool -K $itf rxvlan off" case.

reproducer:
iptables -t raw -I PREROUTING -i br0
iptables -t raw -I PREROUTING -i br0.1

Then send packets to an ip address configured on br0.1 interface.
Even with net.bridge.bridge-nf-filter-vlan-tagged=0, the 1st rule
will match instead of the 2nd one.

With this patch applied, the 2nd rule will match instead.
In the non-local address case, netfilter won't be consulted after
this patch unless the sysctl is switched on.

Cc: Jiri Pirko <jpirko@redhat.com>
Cc: Jesse Gross <jesse@nicira.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo,

 since noone has complained about this so far we could
 also add this to next- instead if you think its too invasive/risky to
 put this in now.

 net/bridge/br_netfilter.c |   63 ++++++++++++++++++---------------------------
 1 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 8412247..262ce9d 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -62,27 +62,23 @@ static int brnf_filter_pppoe_tagged __read_mostly = 0;
 #define brnf_filter_pppoe_tagged 0
 #endif
 
-static inline __be16 vlan_proto(const struct sk_buff *skb)
+static bool brnf_skb_is_protocol(const struct sk_buff *skb, __be16 proto)
 {
-	if (vlan_tx_tag_present(skb))
-		return skb->protocol;
-	else if (skb->protocol == htons(ETH_P_8021Q))
-		return vlan_eth_hdr(skb)->h_vlan_encapsulated_proto;
-	else
-		return 0;
+	if (vlan_tx_tag_present(skb)) {
+		if (brnf_filter_vlan_tagged)
+			return skb->protocol == htons(proto);
+		return false;
+	}
+	if (skb->protocol == htons(ETH_P_8021Q) && brnf_filter_vlan_tagged) {
+		u16 vlan_proto = vlan_eth_hdr(skb)->h_vlan_encapsulated_proto;
+		return vlan_proto == htons(proto);
+	}
+	return skb->protocol == htons(proto);
 }
 
-#define IS_VLAN_IP(skb) \
-	(vlan_proto(skb) == htons(ETH_P_IP) && \
-	 brnf_filter_vlan_tagged)
-
-#define IS_VLAN_IPV6(skb) \
-	(vlan_proto(skb) == htons(ETH_P_IPV6) && \
-	 brnf_filter_vlan_tagged)
-
-#define IS_VLAN_ARP(skb) \
-	(vlan_proto(skb) == htons(ETH_P_ARP) &&	\
-	 brnf_filter_vlan_tagged)
+#define IS_IP(skb) brnf_skb_is_protocol(skb, ETH_P_IP)
+#define IS_IPV6(skb) brnf_skb_is_protocol(skb, ETH_P_IPV6)
+#define IS_ARP(skb) brnf_skb_is_protocol(skb, ETH_P_ARP)
 
 static inline __be16 pppoe_proto(const struct sk_buff *skb)
 {
@@ -639,8 +635,7 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
 		return NF_DROP;
 	br = p->br;
 
-	if (skb->protocol == htons(ETH_P_IPV6) || IS_VLAN_IPV6(skb) ||
-	    IS_PPPOE_IPV6(skb)) {
+	if (IS_IPV6(skb) || IS_PPPOE_IPV6(skb)) {
 		if (!brnf_call_ip6tables && !br->nf_call_ip6tables)
 			return NF_ACCEPT;
 
@@ -651,8 +646,7 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
 	if (!brnf_call_iptables && !br->nf_call_iptables)
 		return NF_ACCEPT;
 
-	if (skb->protocol != htons(ETH_P_IP) && !IS_VLAN_IP(skb) &&
-	    !IS_PPPOE_IP(skb))
+	if (!IS_IP(skb) && !IS_PPPOE_IP(skb))
 		return NF_ACCEPT;
 
 	nf_bridge_pull_encap_header_rcsum(skb);
@@ -701,7 +695,7 @@ static int br_nf_forward_finish(struct sk_buff *skb)
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 	struct net_device *in;
 
-	if (skb->protocol != htons(ETH_P_ARP) && !IS_VLAN_ARP(skb)) {
+	if (!IS_ARP(skb)) {
 		in = nf_bridge->physindev;
 		if (nf_bridge->mask & BRNF_PKT_TYPE) {
 			skb->pkt_type = PACKET_OTHERHOST;
@@ -744,11 +738,9 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 	if (!parent)
 		return NF_DROP;
 
-	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb) ||
-	    IS_PPPOE_IP(skb))
+	if (IS_IP(skb) || IS_PPPOE_IP(skb))
 		pf = PF_INET;
-	else if (skb->protocol == htons(ETH_P_IPV6) || IS_VLAN_IPV6(skb) ||
-		 IS_PPPOE_IPV6(skb))
+	else if (IS_IPV6(skb) || IS_PPPOE_IPV6(skb))
 		pf = PF_INET6;
 	else
 		return NF_ACCEPT;
@@ -795,15 +787,12 @@ static unsigned int br_nf_forward_arp(unsigned int hook, struct sk_buff *skb,
 	if (!brnf_call_arptables && !br->nf_call_arptables)
 		return NF_ACCEPT;
 
-	if (skb->protocol != htons(ETH_P_ARP)) {
-		if (!IS_VLAN_ARP(skb))
-			return NF_ACCEPT;
-		nf_bridge_pull_encap_header(skb);
-	}
+	if (!IS_ARP(skb))
+		return NF_ACCEPT;
+	nf_bridge_pull_encap_header(skb);
 
 	if (arp_hdr(skb)->ar_pln != 4) {
-		if (IS_VLAN_ARP(skb))
-			nf_bridge_push_encap_header(skb);
+		nf_bridge_push_encap_header(skb);
 		return NF_ACCEPT;
 	}
 	*d = (struct net_device *)in;
@@ -853,11 +842,9 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 	if (!realoutdev)
 		return NF_DROP;
 
-	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb) ||
-	    IS_PPPOE_IP(skb))
+	if (IS_IP(skb) || IS_PPPOE_IP(skb))
 		pf = PF_INET;
-	else if (skb->protocol == htons(ETH_P_IPV6) || IS_VLAN_IPV6(skb) ||
-		 IS_PPPOE_IPV6(skb))
+	else if (IS_IPV6(skb) || IS_PPPOE_IPV6(skb))
 		pf = PF_INET6;
 	else
 		return NF_ACCEPT;
-- 
1.7.3.4

