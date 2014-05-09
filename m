From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 10/15] br_netfilter: added per-netns sysctl registration
Date: Sat, 10 May 2014 01:28:22 +0400
Message-ID: <536D4876.4040501@parallels.com>
References: <536A8054.90201@pandora.de> <cover.1399660706.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:3567 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757585AbaEIVaJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:30:09 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

added separate per-netns sysctl tables,
however systcl variables from init_brnf_net are still used

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |   59 +++++++++++++++++++++++++++++++-------------
 1 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 460917c..16b68da 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -66,10 +66,6 @@ static inline struct brnf_net *brnf_net(const struct net *net)
 	return net_generic(net, brnf_net_id);
 }
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table_header *brnf_sysctl_header;
-#endif
-
 #define IS_IP(skb) \
 	(!vlan_tx_tag_present(skb) && skb->protocol == htons(ETH_P_IP))
 
@@ -1063,10 +1059,49 @@ static struct ctl_table brnf_table[] = {
 	},
 	{ }
 };
-#endif
 
+static int brnf_sysctl_net_register(struct brnf_net *bn)
+{
+	struct ctl_table *table;
+	struct ctl_table_header *hdr;
+
+	table = brnf_table;
+	if (!net_eq(bn->net, &init_net)) {
+
+		table = kmemdup(table, sizeof(brnf_table), GFP_KERNEL);
+		if (!table)
+			goto err_alloc;
+	}
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
+#else
 #define brnf_sysctl_net_register(x)	(0)
 #define brnf_sysctl_net_unregister(x)
+#endif
 
 static int __net_init brnf_net_init(struct net *net)
 {
@@ -1105,16 +1140,7 @@ int __init br_netfilter_init(void)
 	ret = register_pernet_subsys(&brnf_net_ops);
 	if (ret < 0)
 		goto err_pernet;
-#ifdef CONFIG_SYSCTL
-	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
-	if (brnf_sysctl_header == NULL) {
-		printk(KERN_WARNING
-		       "br_netfilter: can't register to sysctl.\n");
-		ret = -ENOMEM;
-		unregister_pernet_subsys(&brnf_net_ops);
-		goto err_pernet;
-	}
-#endif
+
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
 	return 0;
 
@@ -1128,9 +1154,6 @@ err_dst:
 
 void br_netfilter_fini(void)
 {
-#ifdef CONFIG_SYSCTL
-	unregister_net_sysctl_table(brnf_sysctl_header);
-#endif
 	unregister_pernet_subsys(&brnf_net_ops);
 	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 	dst_entries_destroy(&fake_dst_ops);
-- 
1.7.5.4

