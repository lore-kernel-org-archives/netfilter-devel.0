From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v3 2/2] br_netfilter: per-netns copy of structure for
 sysctl flags
Date: Mon, 12 May 2014 20:32:01 +0400
Message-ID: <5370F781.7010909@parallels.com>
References: <20140512140706.GA22082@macbook.localnet> <cover.1399909529.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:26131 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759088AbaELQdL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 12:33:11 -0400
In-Reply-To: <cover.1399909529.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

pernet_operations creates per-netns copy of common structure for sysctl flags
and initialize it values taken from init_brnf_net.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |  104 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 87 insertions(+), 17 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 31bfd90..9886afc 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -40,6 +40,7 @@
 #include "br_private.h"
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
+#include <net/netns/generic.h>
 #endif
 
 #define skb_origaddr(skb)	 (((struct bridge_skb_cb *) \
@@ -47,9 +48,6 @@
 #define store_orig_dstaddr(skb)	 (skb_origaddr(skb) = ip_hdr(skb)->daddr)
 #define dnat_took_place(skb)	 (skb_origaddr(skb) != ip_hdr(skb)->daddr)
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table_header *brnf_sysctl_header;
-#endif
 #define brnf_call_arptables 1
 #define brnf_call_iptables 1
 #define brnf_call_ip6tables 1
@@ -58,6 +56,7 @@ static struct ctl_table_header *brnf_sysctl_header;
 #define brnf_pass_vlan_indev 0
 
 #ifdef CONFIG_SYSCTL
+static int brnf_net_id __read_mostly;
 static struct brnf_net init_brnf_net = {
 	.hdr			= NULL,
 	.call_arptables		= brnf_call_arptables,
@@ -68,7 +67,13 @@ static struct brnf_net init_brnf_net = {
 	.pass_vlan_indev	= brnf_pass_vlan_indev,
 };
 
-#define brnf_flag(skb, flag)		init_brnf_net.flag
+static inline struct brnf_net *brnf_net(const struct net *net)
+{
+	return net_generic(net, brnf_net_id);
+}
+
+#define skb_netns(skb)			net((skb)->dev)
+#define brnf_flag(skb, flag)		brnf_net(skb_netns(skb))->flag
 #else
 #define brnf_flag(skb, flag)		brnf_##flag
 #endif
@@ -1066,6 +1071,70 @@ static struct ctl_table brnf_table[] = {
 	},
 	{ }
 };
+
+static int brnf_sysctl_net_register(struct brnf_net *bn)
+{
+	struct ctl_table *table;
+	struct ctl_table_header *hdr;
+	int i;
+
+	table = brnf_table;
+	if (!net_eq(bn->net, &init_net)) {
+
+		table = kmemdup(table, sizeof(brnf_table), GFP_KERNEL);
+		if (!table)
+			goto err_alloc;
+	}
+	for (i = 0; table[i].data; i++)
+		table[i].data += (char *)bn - (char *)&init_brnf_net;
+
+	hdr = register_net_sysctl(bn->net, "net/bridge", table);
+	if (!hdr)
+		goto err_reg;
+
+	bn->hdr = hdr;
+	return 0;
+
+err_reg:
+	if (!net_eq(bn->net, &init_net))
+		kfree(table);
+err_alloc:
+	return -ENOMEM;
+}
+
+static void brnf_sysctl_net_unregister(struct brnf_net *bn)
+{
+	struct ctl_table *table;
+
+	if (bn->hdr == NULL)
+		return;
+
+	table = bn->hdr->ctl_table_arg;
+	unregister_net_sysctl_table(bn->hdr);
+	if (!net_eq(bn->net, &init_net))
+		kfree(table);
+}
+
+static int __net_init brnf_net_init(struct net *net)
+{
+	struct brnf_net *bn = brnf_net(net);
+
+	memcpy(bn, &init_brnf_net, sizeof(struct brnf_net));
+	bn->net = net;
+	return brnf_sysctl_net_register(bn);
+}
+
+static void __net_exit brnf_net_exit(struct net *net)
+{
+	brnf_sysctl_net_unregister(brnf_net(net));
+}
+
+static struct pernet_operations __net_initdata brnf_net_ops = {
+	.init	= brnf_net_init,
+	.exit	= brnf_net_exit,
+	.id	= &brnf_net_id,
+	.size	= sizeof(struct brnf_net),
+};
 #endif
 
 int __init br_netfilter_init(void)
@@ -1074,32 +1143,33 @@ int __init br_netfilter_init(void)
 
 	ret = dst_entries_init(&fake_dst_ops);
 	if (ret < 0)
-		return ret;
+		goto err_dst;
 
 	ret = nf_register_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
-	if (ret < 0) {
-		dst_entries_destroy(&fake_dst_ops);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_nf;
+
 #ifdef CONFIG_SYSCTL
-	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
-	if (brnf_sysctl_header == NULL) {
-		printk(KERN_WARNING
-		       "br_netfilter: can't register to sysctl.\n");
+	ret = register_pernet_subsys(&brnf_net_ops);
+	if (ret < 0) {
 		nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
-		dst_entries_destroy(&fake_dst_ops);
-		return -ENOMEM;
+		goto err_nf;
 	}
 #endif
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
 	return 0;
+
+err_nf:
+	dst_entries_destroy(&fake_dst_ops);
+err_dst:
+	return ret;
 }
 
 void br_netfilter_fini(void)
 {
-	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 #ifdef CONFIG_SYSCTL
-	unregister_net_sysctl_table(brnf_sysctl_header);
+	unregister_pernet_subsys(&brnf_net_ops);
 #endif
+	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 	dst_entries_destroy(&fake_dst_ops);
 }
-- 
1.7.5.4

