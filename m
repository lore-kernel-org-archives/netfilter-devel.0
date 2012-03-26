From: Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH] netfilter: bridge: change indev name to vlan if vlan tag
 present
Date: Mon, 26 Mar 2012 22:23:26 +0200
Message-ID: <20120326202326.GB15638@Chamillionaire.breakpoint.cc>
References: <20120326202124.GA15638@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60572 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709Ab2CZUX1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:23:27 -0400
Received: id: fw by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1SCGRq-0004bz-8m
	for netfilter-devel@vger.kernel.org; Mon, 26 Mar 2012 22:23:26 +0200
Content-Disposition: inline
In-Reply-To: <20120326202124.GA15638@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If net.bridge.bridge-nf-filter-vlan-tagged is on, bridge
netfilter will remove skbs vlan header, then feeds the packet
to ip(6)tables.

This changes the in/out interface to the vlan interface; if such
an interface has been configured, to allow iptables rules to
determine the original vlan the packet arrived on (e.g.
-i br0.1 will now work if a br0.1 vlan exists on top of br0 bridge
interface).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_netfilter.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index dec4f38..087fbd1 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -503,6 +503,19 @@ bridged_dnat:
 	return 0;
 }
 
+static struct net_device *brnf_find_logical_dev(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct net_device *vlan, *br;
+
+	br = bridge_parent(dev);
+	if (!vlan_tx_tag_present(skb))
+		return br;
+
+	vlan = __vlan_find_dev_deep(br, vlan_tx_tag_get(skb) & VLAN_VID_MASK);
+
+	return vlan ? vlan : br;
+}
+
 /* Some common code for IPv4/IPv6 */
 static struct net_device *setup_pre_routing(struct sk_buff *skb)
 {
@@ -515,7 +528,7 @@ static struct net_device *setup_pre_routing(struct sk_buff *skb)
 
 	nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING;
 	nf_bridge->physindev = skb->dev;
-	skb->dev = bridge_parent(skb->dev);
+	skb->dev = brnf_find_logical_dev(skb, skb->dev);
 	if (skb->protocol == htons(ETH_P_8021Q))
 		nf_bridge->mask |= BRNF_8021Q;
 	else if (skb->protocol == htons(ETH_P_PPP_SES))
@@ -737,7 +750,7 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 				     int (*okfn)(struct sk_buff *))
 {
 	struct nf_bridge_info *nf_bridge;
-	struct net_device *parent;
+	struct net_device *parent, *indev;
 	u_int8_t pf;
 
 	if (!skb->nf_bridge)
@@ -748,10 +761,6 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 	if (!nf_bridge_unshare(skb))
 		return NF_DROP;
 
-	parent = bridge_parent(out);
-	if (!parent)
-		return NF_DROP;
-
 	if (IS_IP(skb) || IS_VLAN_IP(skb) || IS_PPPOE_IP(skb))
 		pf = PF_INET;
 	else if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb))
@@ -759,6 +768,10 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 	else
 		return NF_ACCEPT;
 
+	parent = brnf_find_logical_dev(skb, out);
+	if (!parent)
+		return NF_DROP;
+
 	nf_bridge_pull_encap_header(skb);
 
 	nf_bridge = skb->nf_bridge;
@@ -778,7 +791,9 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 	else
 		skb->protocol = htons(ETH_P_IPV6);
 
-	NF_HOOK(pf, NF_INET_FORWARD, skb, bridge_parent(in), parent,
+	indev = brnf_find_logical_dev(skb, in);
+
+	NF_HOOK(pf, NF_INET_FORWARD, skb, indev, parent,
 		br_nf_forward_finish);
 
 	return NF_STOLEN;
@@ -850,7 +865,7 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 				       int (*okfn)(struct sk_buff *))
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
-	struct net_device *realoutdev = bridge_parent(skb->dev);
+	struct net_device *realoutdev = brnf_find_logical_dev(skb, out);
 	u_int8_t pf;
 
 	if (!nf_bridge || !(nf_bridge->mask & BRNF_BRIDGED))
-- 
1.7.3.4

