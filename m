From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v3 1/2] br_netfilter: common structure for sysctl flags
Date: Mon, 12 May 2014 20:31:53 +0400
Message-ID: <5370F779.1020504@parallels.com>
References: <20140512140706.GA22082@macbook.localnet> <cover.1399909529.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:47296 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758798AbaELQdD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 12:33:03 -0400
In-Reply-To: <cover.1399909529.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduced common structure for sysctl flags

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |   55 ++++++++++++++++++++++++++------------------
 net/bridge/br_private.h   |   13 ++++++++++
 2 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 2acf7fa..31bfd90 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -49,19 +49,28 @@
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
-static int brnf_call_iptables __read_mostly = 1;
-static int brnf_call_ip6tables __read_mostly = 1;
-static int brnf_call_arptables __read_mostly = 1;
-static int brnf_filter_vlan_tagged __read_mostly = 0;
-static int brnf_filter_pppoe_tagged __read_mostly = 0;
-static int brnf_pass_vlan_indev __read_mostly = 0;
-#else
+#endif
+#define brnf_call_arptables 1
 #define brnf_call_iptables 1
 #define brnf_call_ip6tables 1
-#define brnf_call_arptables 1
 #define brnf_filter_vlan_tagged 0
 #define brnf_filter_pppoe_tagged 0
 #define brnf_pass_vlan_indev 0
+
+#ifdef CONFIG_SYSCTL
+static struct brnf_net init_brnf_net = {
+	.hdr			= NULL,
+	.call_arptables		= brnf_call_arptables,
+	.call_iptables		= brnf_call_iptables,
+	.call_ip6tables		= brnf_call_ip6tables,
+	.filter_vlan_tagged	= brnf_filter_vlan_tagged,
+	.filter_pppoe_tagged	= brnf_filter_pppoe_tagged,
+	.pass_vlan_indev	= brnf_pass_vlan_indev,
+};
+
+#define brnf_flag(skb, flag)		init_brnf_net.flag
+#else
+#define brnf_flag(skb, flag)		brnf_##flag
 #endif
 
 #define IS_IP(skb) \
@@ -85,15 +94,15 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
 
 #define IS_VLAN_IP(skb) \
 	(vlan_proto(skb) == htons(ETH_P_IP) && \
-	 brnf_filter_vlan_tagged)
+	 brnf_flag(skb, filter_vlan_tagged))
 
 #define IS_VLAN_IPV6(skb) \
 	(vlan_proto(skb) == htons(ETH_P_IPV6) && \
-	 brnf_filter_vlan_tagged)
+	 brnf_flag(skb, filter_vlan_tagged))
 
 #define IS_VLAN_ARP(skb) \
 	(vlan_proto(skb) == htons(ETH_P_ARP) &&	\
-	 brnf_filter_vlan_tagged)
+	 brnf_flag(skb, filter_vlan_tagged))
 
 static inline __be16 pppoe_proto(const struct sk_buff *skb)
 {
@@ -104,12 +113,12 @@ static inline __be16 pppoe_proto(const struct sk_buff *skb)
 #define IS_PPPOE_IP(skb) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IP) && \
-	 brnf_filter_pppoe_tagged)
+	 brnf_flag(skb, filter_pppoe_tagged))
 
 #define IS_PPPOE_IPV6(skb) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IPV6) && \
-	 brnf_filter_pppoe_tagged)
+	 brnf_flag(skb, filter_pppoe_tagged))
 
 static void fake_update_pmtu(struct dst_entry *dst, struct sock *sk,
 			     struct sk_buff *skb, u32 mtu)
@@ -532,7 +541,7 @@ static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct
 	struct net_device *vlan, *br;
 
 	br = bridge_parent(dev);
-	if (brnf_pass_vlan_indev == 0 || !vlan_tx_tag_present(skb))
+	if (brnf_flag(skb, pass_vlan_indev) == 0 || !vlan_tx_tag_present(skb))
 		return br;
 
 	vlan = __vlan_find_dev_deep(br, skb->vlan_proto,
@@ -690,14 +699,14 @@ static unsigned int br_nf_pre_routing(const struct nf_hook_ops *ops,
 	br = p->br;
 
 	if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb)) {
-		if (!brnf_call_ip6tables && !br->nf_call_ip6tables)
+		if (!brnf_flag(skb, call_ip6tables) && !br->nf_call_ip6tables)
 			return NF_ACCEPT;
 
 		nf_bridge_pull_encap_header_rcsum(skb);
 		return br_nf_pre_routing_ipv6(ops, skb, in, out, okfn);
 	}
 
-	if (!brnf_call_iptables && !br->nf_call_iptables)
+	if (!brnf_flag(skb, call_iptables) && !br->nf_call_iptables)
 		return NF_ACCEPT;
 
 	if (!IS_IP(skb) && !IS_VLAN_IP(skb) && !IS_PPPOE_IP(skb))
@@ -838,7 +847,7 @@ static unsigned int br_nf_forward_arp(const struct nf_hook_ops *ops,
 		return NF_ACCEPT;
 	br = p->br;
 
-	if (!brnf_call_arptables && !br->nf_call_arptables)
+	if (!brnf_flag(skb, call_arptables) && !br->nf_call_arptables)
 		return NF_ACCEPT;
 
 	if (!IS_ARP(skb)) {
@@ -1015,42 +1024,42 @@ int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
 static struct ctl_table brnf_table[] = {
 	{
 		.procname	= "bridge-nf-call-arptables",
-		.data		= &brnf_call_arptables,
+		.data		= &init_brnf_net.call_arptables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-call-iptables",
-		.data		= &brnf_call_iptables,
+		.data		= &init_brnf_net.call_iptables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-call-ip6tables",
-		.data		= &brnf_call_ip6tables,
+		.data		= &init_brnf_net.call_ip6tables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-filter-vlan-tagged",
-		.data		= &brnf_filter_vlan_tagged,
+		.data		= &init_brnf_net.filter_vlan_tagged,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-filter-pppoe-tagged",
-		.data		= &brnf_filter_pppoe_tagged,
+		.data		= &init_brnf_net.filter_pppoe_tagged,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-pass-vlan-input-dev",
-		.data		= &brnf_pass_vlan_indev,
+		.data		= &init_brnf_net.pass_vlan_indev,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 06811d7..25a785e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -312,6 +312,19 @@ struct br_input_skb_cb {
 # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
 #endif
 
+#if defined CONFIG_BRIDGE_NETFILTER && defined CONFIG_SYSCTL
+struct brnf_net {
+	struct net *net;
+	struct ctl_table_header	*hdr;
+	int call_arptables;
+	int call_iptables;
+	int call_ip6tables;
+	int filter_vlan_tagged;
+	int filter_pppoe_tagged;
+	int pass_vlan_indev;
+};
+#endif
+
 #define br_printk(level, br, format, args...)	\
 	printk(level "%s: " format, (br)->dev->name, ##args)
 
-- 
1.7.5.4

