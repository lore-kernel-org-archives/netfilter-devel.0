From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2 10/11] br_netfilter: per-netns sysctl registration
Date: Mon, 12 May 2014 16:58:06 +0400
Message-ID: <5370C55E.2060200@parallels.com>
References: <536FD0FD.8010204@pandora.de> <cover.1399897184.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:23938 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbaELM7Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 08:59:16 -0400
In-Reply-To: <cover.1399897184.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |   56 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index a079c06..ed3b6ce 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -48,9 +48,6 @@
 #define store_orig_dstaddr(skb)	 (skb_origaddr(skb) = ip_hdr(skb)->daddr)
 #define dnat_took_place(skb)	 (skb_origaddr(skb) != ip_hdr(skb)->daddr)
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table_header *brnf_sysctl_header;
-#endif
 #define brnf_call_arptables 1
 #define brnf_call_iptables 1
 #define brnf_call_ip6tables 1
@@ -1076,17 +1073,58 @@ static struct ctl_table brnf_table[] = {
 	{ }
 };
 
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
 static int __net_init brnf_net_init(struct net *net)
 {
 	struct brnf_net *bn = brnf_net(net);
 
 	memcpy(bn, &init_brnf_net, sizeof(struct brnf_net));
 	bn->net = net;
-	return 0;
+	return brnf_sysctl_net_register(bn);
 }
 
 static void __net_exit brnf_net_exit(struct net *net)
 {
+	brnf_sysctl_net_unregister(brnf_net(net));
 }
 
 static struct pernet_operations __net_initdata brnf_net_ops = {
@@ -1110,17 +1148,8 @@ int __init br_netfilter_init(void)
 		goto err_nf;
 
 #ifdef CONFIG_SYSCTL
-	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
-	if (brnf_sysctl_header == NULL) {
-		printk(KERN_WARNING
-		       "br_netfilter: can't register to sysctl.\n");
-		nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
-		dst_entries_destroy(&fake_dst_ops);
-		return -ENOMEM;
-	}
 	ret = register_pernet_subsys(&brnf_net_ops);
 	if (ret < 0) {
-		unregister_net_sysctl_table(brnf_sysctl_header);
 		nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 		goto err_nf;
 	}
@@ -1138,7 +1167,6 @@ void br_netfilter_fini(void)
 {
 #ifdef CONFIG_SYSCTL
 	unregister_pernet_subsys(&brnf_net_ops);
-	unregister_net_sysctl_table(brnf_sysctl_header);
 #endif
 	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 	dst_entries_destroy(&fake_dst_ops);
-- 
1.7.5.4

