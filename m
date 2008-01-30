From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 20/69]: arp_tables: per-netns arp_tables FILTER
Date: Wed, 30 Jan 2008 21:17:23 +0100 (MET)
Message-ID: <20080130201721.29874.14466.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60687 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbYA3URZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:25 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: arp_tables: per-netns arp_tables FILTER

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e612deed898a9b2984bd7c2f4fef1a5a93f8160b
tree 044a732a14be924f70a60258ac8424de575ac8f4
parent 5f826e6f0ca7a6d45279d1c4ed6860a4bf7bbf26
author Alexey Dobriyan <adobriyan@sw.ru> Tue, 29 Jan 2008 16:22:01 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:17 +0100

 include/net/netns/ipv4.h             |    1 +
 net/ipv4/netfilter/arptable_filter.c |   38 +++++++++++++++++++++++++---------
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index aeb0c3b..a9b4f60 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -31,6 +31,7 @@ struct netns_ipv4 {
 	struct xt_table		*iptable_filter;
 	struct xt_table		*iptable_mangle;
 	struct xt_table		*iptable_raw;
+	struct xt_table		*arptable_filter;
 #endif
 };
 #endif
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 1a68860..4e9c496 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -20,7 +20,7 @@ static struct
 	struct arpt_replace repl;
 	struct arpt_standard entries[3];
 	struct arpt_error term;
-} initial_table __initdata = {
+} initial_table __net_initdata = {
 	.repl = {
 		.name = "filter",
 		.valid_hooks = FILTER_VALID_HOOKS,
@@ -45,7 +45,7 @@ static struct
 	.term = ARPT_ERROR_INIT,
 };
 
-static struct arpt_table __packet_filter = {
+static struct arpt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
@@ -53,7 +53,6 @@ static struct arpt_table __packet_filter = {
 	.me		= THIS_MODULE,
 	.af		= NF_ARP,
 };
-static struct arpt_table *packet_filter;
 
 /* The work comes in here from netfilter.c */
 static unsigned int arpt_hook(unsigned int hook,
@@ -62,7 +61,7 @@ static unsigned int arpt_hook(unsigned int hook,
 			      const struct net_device *out,
 			      int (*okfn)(struct sk_buff *))
 {
-	return arpt_do_table(skb, hook, in, out, packet_filter);
+	return arpt_do_table(skb, hook, in, out, init_net.ipv4.arptable_filter);
 }
 
 static struct nf_hook_ops arpt_ops[] __read_mostly = {
@@ -86,14 +85,33 @@ static struct nf_hook_ops arpt_ops[] __read_mostly = {
 	},
 };
 
+static int __net_init arptable_filter_net_init(struct net *net)
+{
+	/* Register table */
+	net->ipv4.arptable_filter =
+		arpt_register_table(net, &packet_filter, &initial_table.repl);
+	if (IS_ERR(net->ipv4.arptable_filter))
+		return PTR_ERR(net->ipv4.arptable_filter);
+	return 0;
+}
+
+static void __net_exit arptable_filter_net_exit(struct net *net)
+{
+	arpt_unregister_table(net->ipv4.arptable_filter);
+}
+
+static struct pernet_operations arptable_filter_net_ops = {
+	.init = arptable_filter_net_init,
+	.exit = arptable_filter_net_exit,
+};
+
 static int __init arptable_filter_init(void)
 {
 	int ret;
 
-	/* Register table */
-	packet_filter = arpt_register_table(&init_net, &__packet_filter, &initial_table.repl);
-	if (IS_ERR(packet_filter))
-		return PTR_ERR(packet_filter);
+	ret = register_pernet_subsys(&arptable_filter_net_ops);
+	if (ret < 0)
+		return ret;
 
 	ret = nf_register_hooks(arpt_ops, ARRAY_SIZE(arpt_ops));
 	if (ret < 0)
@@ -101,14 +119,14 @@ static int __init arptable_filter_init(void)
 	return ret;
 
 cleanup_table:
-	arpt_unregister_table(packet_filter);
+	unregister_pernet_subsys(&arptable_filter_net_ops);
 	return ret;
 }
 
 static void __exit arptable_filter_fini(void)
 {
 	nf_unregister_hooks(arpt_ops, ARRAY_SIZE(arpt_ops));
-	arpt_unregister_table(packet_filter);
+	unregister_pernet_subsys(&arptable_filter_net_ops);
 }
 
 module_init(arptable_filter_init);
