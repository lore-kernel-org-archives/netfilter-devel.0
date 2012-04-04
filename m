From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: bridge: optionally set indev to vlan
Date: Wed, 4 Apr 2012 21:57:29 +0200
Message-ID: <20120404195729.GC23461@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45245 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932615Ab2DDT5a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:57:30 -0400
Received: id: fw by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1SFWKf-0006EB-EF
	for netfilter-devel@vger.kernel.org; Wed, 04 Apr 2012 21:57:29 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

if net.bridge.bridge-nf-filter-vlan-tagged sysctl is enabled, bridge
netfilter removes the vlan header temporarily and then feeds the packet
to ip(6)tables.

When the new "bridge-nf-pass-vlan-input-device" sysctl is on
(default off), then bridge netfilter will also change the in/out
interface to the vlan interface; if such an interface exists.

This is needed to make iptables REDIRECT target work with
"vlan-on-top-of-bridge" setups. Also, 'iptables -i' can then be used
to match the vlan device name.

Also update Documentation with current brnf default settings.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Documentation/networking/ip-sysctl.txt |   13 +++++++++-
 net/bridge/br_netfilter.c              |   39 +++++++++++++++++++++++++------
 2 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index ad3e80e..ee0374a 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1294,13 +1294,22 @@ bridge-nf-call-ip6tables - BOOLEAN
 bridge-nf-filter-vlan-tagged - BOOLEAN
 	1 : pass bridged vlan-tagged ARP/IP/IPv6 traffic to {arp,ip,ip6}tables.
 	0 : disable this.
-	Default: 1
+	Default: 0
 
 bridge-nf-filter-pppoe-tagged - BOOLEAN
 	1 : pass bridged pppoe-tagged IP/IPv6 traffic to {ip,ip6}tables.
 	0 : disable this.
-	Default: 1
+	Default: 0
 
+bridge-nf-pass-vlan-input-dev - BOOLEAN
+	1: if bridge-nf-filter-vlan-tagged is enabled, try to find a vlan
+	interface on the bridge and set the netfilter input device to the vlan.
+	This allows use of e.g. "iptables -i br0.1" and makes the REDIRECT
+	target work with vlan-on-top-of-bridge interfaces.  When no matching
+	vlan interface is found, or this switch is off, the input device is
+	set to the bridge interface.
+	0: disable bridge netfilter vlan interface lookup.
+	Default: 0
 
 proc/sys/net/sctp/* Variables:
 
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index dec4f38..1d69feb 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -53,6 +53,7 @@ static int brnf_call_iptables __read_mostly = 1;
 static int brnf_call_ip6tables __read_mostly = 1;
 static int brnf_call_arptables __read_mostly = 1;
 static int brnf_filter_vlan_tagged __read_mostly = 0;
+static int brnf_pass_vlan_indev __read_mostly = 0;
 static int brnf_filter_pppoe_tagged __read_mostly = 0;
 #else
 #define brnf_call_iptables 1
@@ -503,6 +504,19 @@ bridged_dnat:
 	return 0;
 }
 
+static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct net_device *vlan, *br;
+
+	br = bridge_parent(dev);
+	if (brnf_pass_vlan_indev == 0 || !vlan_tx_tag_present(skb))
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
@@ -515,7 +529,7 @@ static struct net_device *setup_pre_routing(struct sk_buff *skb)
 
 	nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING;
 	nf_bridge->physindev = skb->dev;
-	skb->dev = bridge_parent(skb->dev);
+	skb->dev = brnf_get_logical_dev(skb, skb->dev);
 	if (skb->protocol == htons(ETH_P_8021Q))
 		nf_bridge->mask |= BRNF_8021Q;
 	else if (skb->protocol == htons(ETH_P_PPP_SES))
@@ -737,7 +751,7 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 				     int (*okfn)(struct sk_buff *))
 {
 	struct nf_bridge_info *nf_bridge;
-	struct net_device *parent;
+	struct net_device *parent, *indev;
 	u_int8_t pf;
 
 	if (!skb->nf_bridge)
@@ -748,10 +762,6 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 	if (!nf_bridge_unshare(skb))
 		return NF_DROP;
 
-	parent = bridge_parent(out);
-	if (!parent)
-		return NF_DROP;
-
 	if (IS_IP(skb) || IS_VLAN_IP(skb) || IS_PPPOE_IP(skb))
 		pf = PF_INET;
 	else if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb))
@@ -759,6 +769,10 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 	else
 		return NF_ACCEPT;
 
+	parent = brnf_get_logical_dev(skb, out);
+	if (!parent)
+		return NF_DROP;
+
 	nf_bridge_pull_encap_header(skb);
 
 	nf_bridge = skb->nf_bridge;
@@ -778,7 +792,9 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 	else
 		skb->protocol = htons(ETH_P_IPV6);
 
-	NF_HOOK(pf, NF_INET_FORWARD, skb, bridge_parent(in), parent,
+	indev = brnf_get_logical_dev(skb, in);
+
+	NF_HOOK(pf, NF_INET_FORWARD, skb, indev, parent,
 		br_nf_forward_finish);
 
 	return NF_STOLEN;
@@ -850,7 +866,7 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 				       int (*okfn)(struct sk_buff *))
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
-	struct net_device *realoutdev = bridge_parent(skb->dev);
+	struct net_device *realoutdev = brnf_get_logical_dev(skb, out);
 	u_int8_t pf;
 
 	if (!nf_bridge || !(nf_bridge->mask & BRNF_BRIDGED))
@@ -1006,6 +1022,13 @@ static ctl_table brnf_table[] = {
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
+	{
+		.procname	= "bridge-nf-pass-vlan-input-dev",
+		.data		= &brnf_pass_vlan_indev,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= brnf_sysctl_call_tables,
+	},
 	{ }
 };
 
-- 
1.7.3.4
