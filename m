From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 15/15] netfilter: bridge: adapt it to pernet hooks
Date: Mon, 15 Jun 2015 17:46:57 +0200
Message-ID: <1434383217-13732-16-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36936 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbbFOPmA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:42:00 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch replaces the global brnf_call_* variables to make them per
netnamespace. Moreover, this registers hooks at pernet level too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/br_netfilter.h |   52 +++++++++++
 include/net/netns/netfilter.h        |   13 +++
 net/bridge/br_netfilter.c            |  171 +++++++++++++++++++++-------------
 3 files changed, 169 insertions(+), 67 deletions(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 2aa6048..26b3591 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -3,4 +3,56 @@
 
 void br_netfilter_enable(void);
 
+#ifdef CONFIG_SYSCTL
+static inline bool brnf_call_iptables(struct net_device *dev)
+{
+	return dev_net(dev)->nf.brnf_call_iptables;
+}
+static inline bool brnf_call_ip6tables(struct net_device *dev)
+{
+	return dev_net(dev)->nf.brnf_call_ip6tables;
+}
+static inline bool brnf_call_arptables(struct net_device *dev)
+{
+	return dev_net(dev)->nf.brnf_call_arptables;
+}
+static inline bool brnf_filter_vlan_tagged(struct net_device *dev)
+{
+	return dev_net(dev)->nf.brnf_filter_vlan_tagged;
+}
+static inline bool brnf_filter_pppoe_tagged(struct net_device *dev)
+{
+	return dev_net(dev)->nf.brnf_filter_pppoe_tagged;
+}
+static inline bool brnf_pass_vlan_indev(struct net_device *dev)
+{
+	return dev_net(dev)->nf.brnf_pass_vlan_indev;
+}
+#else
+static inline bool brnf_call_iptables(void)
+{
+	return true;
+}
+static inline bool brnf_call_ip6tables(void)
+{
+	return true;
+}
+static inline bool brnf_call_arptables(void)
+{
+	return true;
+}
+static inline bool brnf_filter_vlan_tagged(void)
+{
+	return false;
+}
+static inline bool brnf_filter_pppoe_tagged(void)
+{
+	return false;
+}
+static inline bool brnf_pass_vlan_indev(void)
+{
+	return false;
+}
+#endif /* CONFIG_SYSCTL */
+
 #endif /* _BR_NETFILTER_H_ */
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index 89925e3..604b8f0 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -24,5 +24,18 @@ struct netns_nf {
 #ifdef CONFIG_SECURITY
 	struct nf_hook_ops *selinux_ops;
 #endif
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+#ifdef CONFIG_SYSCTL
+	struct ctl_table *brnf_table;
+	struct ctl_table_header *brnf_sysctl_header;
+	int brnf_call_iptables;
+	int brnf_call_ip6tables;
+	int brnf_call_arptables;
+	int brnf_filter_vlan_tagged;
+	int brnf_filter_pppoe_tagged;
+	int brnf_pass_vlan_indev;
+#endif
+	struct nf_hook_ops *brnf_ops;
+#endif
 };
 #endif
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index af14ef1..af47cfe 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -44,23 +44,6 @@
 #include <linux/sysctl.h>
 #endif
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table_header *brnf_sysctl_header;
-static int brnf_call_iptables __read_mostly = 1;
-static int brnf_call_ip6tables __read_mostly = 1;
-static int brnf_call_arptables __read_mostly = 1;
-static int brnf_filter_vlan_tagged __read_mostly = 0;
-static int brnf_filter_pppoe_tagged __read_mostly = 0;
-static int brnf_pass_vlan_indev __read_mostly = 0;
-#else
-#define brnf_call_iptables 1
-#define brnf_call_ip6tables 1
-#define brnf_call_arptables 1
-#define brnf_filter_vlan_tagged 0
-#define brnf_filter_pppoe_tagged 0
-#define brnf_pass_vlan_indev 0
-#endif
-
 #define IS_IP(skb) \
 	(!skb_vlan_tag_present(skb) && skb->protocol == htons(ETH_P_IP))
 
@@ -80,17 +63,17 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
 		return 0;
 }
 
-#define IS_VLAN_IP(skb) \
+#define IS_VLAN_IP(skb, dev) \
 	(vlan_proto(skb) == htons(ETH_P_IP) && \
-	 brnf_filter_vlan_tagged)
+	 brnf_filter_vlan_tagged(dev))
 
-#define IS_VLAN_IPV6(skb) \
+#define IS_VLAN_IPV6(skb, dev) \
 	(vlan_proto(skb) == htons(ETH_P_IPV6) && \
-	 brnf_filter_vlan_tagged)
+	 brnf_filter_vlan_tagged(dev))
 
-#define IS_VLAN_ARP(skb) \
+#define IS_VLAN_ARP(skb, dev) \
 	(vlan_proto(skb) == htons(ETH_P_ARP) &&	\
-	 brnf_filter_vlan_tagged)
+	 brnf_filter_vlan_tagged(dev))
 
 static inline __be16 pppoe_proto(const struct sk_buff *skb)
 {
@@ -98,15 +81,15 @@ static inline __be16 pppoe_proto(const struct sk_buff *skb)
 			    sizeof(struct pppoe_hdr)));
 }
 
-#define IS_PPPOE_IP(skb) \
+#define IS_PPPOE_IP(skb, dev) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IP) && \
-	 brnf_filter_pppoe_tagged)
+	 brnf_filter_pppoe_tagged(dev))
 
-#define IS_PPPOE_IPV6(skb) \
+#define IS_PPPOE_IPV6(skb, dev) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IPV6) && \
-	 brnf_filter_pppoe_tagged)
+	 brnf_filter_pppoe_tagged(dev))
 
 /* largest possible L2 header, see br_nf_dev_queue_xmit() */
 #define NF_BRIDGE_MAX_MAC_HEADER_LENGTH (PPPOE_SES_HLEN + ETH_HLEN)
@@ -626,7 +609,8 @@ static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct
 	struct net_device *vlan, *br;
 
 	br = bridge_parent(dev);
-	if (brnf_pass_vlan_indev == 0 || !skb_vlan_tag_present(skb))
+	if (dev_net(dev)->nf.brnf_pass_vlan_indev == 0 ||
+	    !skb_vlan_tag_present(skb))
 		return br;
 
 	vlan = __vlan_find_dev_deep_rcu(br, skb->vlan_proto,
@@ -711,18 +695,22 @@ static unsigned int br_nf_pre_routing(const struct nf_hook_ops *ops,
 		return NF_DROP;
 	br = p->br;
 
-	if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb)) {
-		if (!brnf_call_ip6tables && !br->nf_call_ip6tables)
+	if (IS_IPV6(skb) ||
+	    IS_VLAN_IPV6(skb, state->in) ||
+	    IS_PPPOE_IPV6(skb, state->in)) {
+		if (!brnf_call_ip6tables(state->in) && !br->nf_call_ip6tables)
 			return NF_ACCEPT;
 
 		nf_bridge_pull_encap_header_rcsum(skb);
 		return br_nf_pre_routing_ipv6(ops, skb, state);
 	}
 
-	if (!brnf_call_iptables && !br->nf_call_iptables)
+	if (!brnf_call_iptables(state->in) && !br->nf_call_iptables)
 		return NF_ACCEPT;
 
-	if (!IS_IP(skb) && !IS_VLAN_IP(skb) && !IS_PPPOE_IP(skb))
+	if (!IS_IP(skb) &&
+	    !IS_VLAN_IP(skb, state->in) &&
+	    !IS_PPPOE_IP(skb, state->in))
 		return NF_ACCEPT;
 
 	nf_bridge_pull_encap_header_rcsum(skb);
@@ -770,8 +758,7 @@ static int br_nf_forward_finish(struct sock *sk, struct sk_buff *skb)
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 	struct net_device *in;
 
-	if (!IS_ARP(skb) && !IS_VLAN_ARP(skb)) {
-
+	if (!IS_ARP(skb) && !IS_VLAN_ARP(skb, skb->dev)) {
 		if (skb->protocol == htons(ETH_P_IP))
 			nf_bridge->frag_max_size = IPCB(skb)->frag_max_size;
 
@@ -824,9 +811,13 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 	if (!parent)
 		return NF_DROP;
 
-	if (IS_IP(skb) || IS_VLAN_IP(skb) || IS_PPPOE_IP(skb))
+	if (IS_IP(skb) ||
+	    IS_VLAN_IP(skb, state->out) ||
+	    IS_PPPOE_IP(skb, state->out))
 		pf = NFPROTO_IPV4;
-	else if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb))
+	else if (IS_IPV6(skb) ||
+		 IS_VLAN_IPV6(skb, state->out) ||
+		 IS_PPPOE_IPV6(skb, state->out))
 		pf = NFPROTO_IPV6;
 	else
 		return NF_ACCEPT;
@@ -876,17 +867,17 @@ static unsigned int br_nf_forward_arp(const struct nf_hook_ops *ops,
 		return NF_ACCEPT;
 	br = p->br;
 
-	if (!brnf_call_arptables && !br->nf_call_arptables)
+	if (!brnf_call_arptables(state->out) && !br->nf_call_arptables)
 		return NF_ACCEPT;
 
 	if (!IS_ARP(skb)) {
-		if (!IS_VLAN_ARP(skb))
+		if (!IS_VLAN_ARP(skb, state->out))
 			return NF_ACCEPT;
 		nf_bridge_pull_encap_header(skb);
 	}
 
 	if (arp_hdr(skb)->ar_pln != 4) {
-		if (IS_VLAN_ARP(skb))
+		if (IS_VLAN_ARP(skb, state->out))
 			nf_bridge_push_encap_header(skb);
 		return NF_ACCEPT;
 	}
@@ -1040,9 +1031,13 @@ static unsigned int br_nf_post_routing(const struct nf_hook_ops *ops,
 	if (!realoutdev)
 		return NF_DROP;
 
-	if (IS_IP(skb) || IS_VLAN_IP(skb) || IS_PPPOE_IP(skb))
+	if (IS_IP(skb) ||
+	    IS_VLAN_IP(skb, state->out) ||
+	    IS_PPPOE_IP(skb, state->out))
 		pf = NFPROTO_IPV4;
-	else if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb))
+	else if (IS_IPV6(skb) ||
+		 IS_VLAN_IPV6(skb, state->out) ||
+		 IS_PPPOE_IPV6(skb, state->out))
 		pf = NFPROTO_IPV6;
 	else
 		return NF_ACCEPT;
@@ -1196,44 +1191,38 @@ int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
 }
 
 static struct ctl_table brnf_table[] = {
-	{
+	[0] = {
 		.procname	= "bridge-nf-call-arptables",
-		.data		= &brnf_call_arptables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
-	{
+	[1] = {
 		.procname	= "bridge-nf-call-iptables",
-		.data		= &brnf_call_iptables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
-	{
+	[2] = {
 		.procname	= "bridge-nf-call-ip6tables",
-		.data		= &brnf_call_ip6tables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
-	{
+	[3] = {
 		.procname	= "bridge-nf-filter-vlan-tagged",
-		.data		= &brnf_filter_vlan_tagged,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
-	{
+	[4] = {
 		.procname	= "bridge-nf-filter-pppoe-tagged",
-		.data		= &brnf_filter_pppoe_tagged,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
-	{
+	[5] = {
 		.procname	= "bridge-nf-pass-vlan-input-dev",
-		.data		= &brnf_pass_vlan_indev,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
@@ -1242,23 +1231,75 @@ static struct ctl_table brnf_table[] = {
 };
 #endif
 
+static int __net_init br_nf_net_init(struct net *net)
+{
+	int err = -ENOMEM;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table *brnf_table_net;
+
+	net->nf.brnf_call_arptables = 1;
+	net->nf.brnf_call_iptables = 1;
+	net->nf.brnf_call_ip6tables = 1;
+
+	brnf_table_net = kmemdup(brnf_table, sizeof(brnf_table), GFP_KERNEL);
+	if (brnf_table_net == NULL)
+		return -ENOMEM;
+
+	net->nf.brnf_table[0].data = &net->nf.brnf_call_arptables;
+	net->nf.brnf_table[1].data = &net->nf.brnf_call_iptables;
+	net->nf.brnf_table[2].data = &net->nf.brnf_call_ip6tables;
+	net->nf.brnf_table[3].data = &net->nf.brnf_filter_vlan_tagged;
+	net->nf.brnf_table[4].data = &net->nf.brnf_filter_pppoe_tagged;
+	net->nf.brnf_table[5].data = &net->nf.brnf_pass_vlan_indev;
+
+	net->nf.brnf_sysctl_header =
+		register_net_sysctl(net, "net/bridge", brnf_table_net);
+	if (net->nf.brnf_sysctl_header == NULL)
+		goto err1;
+#endif
+
+	net->nf.brnf_ops = kmemdup(br_nf_ops, sizeof(br_nf_ops), GFP_KERNEL);
+	if (net->nf.brnf_ops == NULL)
+		goto err2;
+
+	err = nf_register_hooks(net, net->nf.brnf_ops, ARRAY_SIZE(br_nf_ops));
+	if (err < 0)
+		goto err3;
+
+	return 0;
+err3:
+	kfree(net->nf.brnf_ops);
+err2:
+	unregister_net_sysctl_table(net->nf.brnf_sysctl_header);
+#ifdef CONFIG_SYSCTL
+err1:
+	kfree(brnf_table_net);
+#endif
+	return err;
+}
+
+static void __net_exit br_nf_net_exit(struct net *net)
+{
+#ifdef CONFIG_SYSCTL
+	unregister_net_sysctl_table(net->nf.brnf_sysctl_header);
+#endif
+	nf_unregister_hooks(net->nf.brnf_ops, ARRAY_SIZE(br_nf_ops));
+	kfree(net->nf.brnf_ops);
+}
+
+static struct pernet_operations br_nf_net_ops = {
+	.init = br_nf_net_init,
+	.exit = br_nf_net_exit,
+};
+
 static int __init br_netfilter_init(void)
 {
 	int ret;
 
-	ret = nf_register_hooks(&init_net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
+	ret = register_pernet_subsys(&br_nf_net_ops);
 	if (ret < 0)
 		return ret;
 
-#ifdef CONFIG_SYSCTL
-	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
-	if (brnf_sysctl_header == NULL) {
-		printk(KERN_WARNING
-		       "br_netfilter: can't register to sysctl.\n");
-		nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
-		return -ENOMEM;
-	}
-#endif
 	RCU_INIT_POINTER(nf_br_ops, &br_ops);
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
 	return 0;
@@ -1267,10 +1308,6 @@ static int __init br_netfilter_init(void)
 static void __exit br_netfilter_fini(void)
 {
 	RCU_INIT_POINTER(nf_br_ops, NULL);
-	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
-#ifdef CONFIG_SYSCTL
-	unregister_net_sysctl_table(brnf_sysctl_header);
-#endif
 }
 
 module_init(br_netfilter_init);
-- 
1.7.10.4

