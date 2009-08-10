From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/6] netfilter: xtables: generate nf_hook_ops on-demand
Date: Mon, 10 Aug 2009 21:19:49 +0200
Message-ID: <1249931992-18761-4-git-send-email-jengelh@medozas.de>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33982 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZHJTUD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:20:03 -0400
In-Reply-To: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nuking lots of repeated and only slightly deviating data definitions.
This should manifest itself in a few memory savings.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h     |    4 ++
 net/ipv4/netfilter/arptable_filter.c   |   35 ++++-------------
 net/ipv4/netfilter/iptable_filter.c    |   35 ++++-------------
 net/ipv4/netfilter/iptable_mangle.c    |   51 ++++--------------------
 net/ipv4/netfilter/iptable_raw.c       |   29 ++++----------
 net/ipv4/netfilter/iptable_security.c  |   35 ++++-------------
 net/ipv6/netfilter/ip6table_filter.c   |   35 ++++-------------
 net/ipv6/netfilter/ip6table_mangle.c   |   53 +++++---------------------
 net/ipv6/netfilter/ip6table_raw.c      |   28 ++++----------
 net/ipv6/netfilter/ip6table_security.c |   35 ++++-------------
 net/netfilter/x_tables.c               |   66 ++++++++++++++++++++++++++++++++
 11 files changed, 145 insertions(+), 261 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 4fa6e4c..1a1e4d2 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -525,6 +525,10 @@ static inline unsigned long ifname_compare_aligned(const char *_a,
 	return ret;
 }
 
+extern struct nf_hook_ops *xt_hook_link(nf_hookfn *, uint8_t, int,
+	unsigned int, struct module *);
+extern void xt_hook_unlink(struct nf_hook_ops *, unsigned int);
+
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index b48ac6f..e07045b 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -64,30 +64,6 @@ static unsigned int arptable_filter_hook(unsigned int hook,
 	return arpt_do_table(skb, hook, in, out, net->ipv4.arptable_filter);
 }
 
-static struct nf_hook_ops arpt_ops[] __read_mostly = {
-	{
-		.hook		= arptable_filter_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_ARP,
-		.hooknum	= NF_ARP_IN,
-		.priority	= NF_IP_PRI_FILTER,
-	},
-	{
-		.hook		= arptable_filter_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_ARP,
-		.hooknum	= NF_ARP_OUT,
-		.priority	= NF_IP_PRI_FILTER,
-	},
-	{
-		.hook		= arptable_filter_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_ARP,
-		.hooknum	= NF_ARP_FORWARD,
-		.priority	= NF_IP_PRI_FILTER,
-	},
-};
-
 static int __net_init arptable_filter_net_init(struct net *net)
 {
 	/* Register table */
@@ -108,6 +84,8 @@ static struct pernet_operations arptable_filter_net_ops = {
 	.exit = arptable_filter_net_exit,
 };
 
+static struct nf_hook_ops *arpfilter_ops;
+
 static int __init arptable_filter_init(void)
 {
 	int ret;
@@ -116,9 +94,12 @@ static int __init arptable_filter_init(void)
 	if (ret < 0)
 		return ret;
 
-	ret = nf_register_hooks(arpt_ops, ARRAY_SIZE(arpt_ops));
-	if (ret < 0)
+	arpfilter_ops = xt_hook_link(arptable_filter_hook, NFPROTO_ARP,
+	                NF_IP_PRI_FILTER, FILTER_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(arpfilter_ops)) {
+		ret = PTR_ERR(arpfilter_ops);
 		goto cleanup_table;
+	}
 	return ret;
 
 cleanup_table:
@@ -128,7 +109,7 @@ cleanup_table:
 
 static void __exit arptable_filter_fini(void)
 {
-	nf_unregister_hooks(arpt_ops, ARRAY_SIZE(arpt_ops));
+	xt_hook_unlink(arpfilter_ops, FILTER_VALID_HOOKS);
 	unregister_pernet_subsys(&arptable_filter_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 73bda90..edfa552 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -78,30 +78,6 @@ iptable_filter_hook(unsigned int hook,
 	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_filter);
 }
 
-static struct nf_hook_ops ipt_ops[] __read_mostly = {
-	{
-		.hook		= iptable_filter_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_FILTER,
-	},
-	{
-		.hook		= iptable_filter_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_FORWARD,
-		.priority	= NF_IP_PRI_FILTER,
-	},
-	{
-		.hook		= iptable_filter_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_OUT,
-		.priority	= NF_IP_PRI_FILTER,
-	},
-};
-
 /* Default to forward because I got too much mail already. */
 static int forward = NF_ACCEPT;
 module_param(forward, bool, 0000);
@@ -126,6 +102,8 @@ static struct pernet_operations iptable_filter_net_ops = {
 	.exit = iptable_filter_net_exit,
 };
 
+static struct nf_hook_ops *filter_ops;
+
 static int __init iptable_filter_init(void)
 {
 	int ret;
@@ -143,9 +121,12 @@ static int __init iptable_filter_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
-	if (ret < 0)
+	filter_ops = xt_hook_link(iptable_filter_hook, NFPROTO_IPV4,
+	             NF_IP_PRI_FILTER, FILTER_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(filter_ops)) {
+		ret = PTR_ERR(filter_ops);
 		goto cleanup_table;
+	}
 
 	return ret;
 
@@ -156,7 +137,7 @@ static int __init iptable_filter_init(void)
 
 static void __exit iptable_filter_fini(void)
 {
-	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
+	xt_hook_unlink(filter_ops, FILTER_VALID_HOOKS);
 	unregister_pernet_subsys(&iptable_filter_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 0dd4c67..a6840f6 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -96,7 +96,7 @@ ipt_local_hook(unsigned int hook,
 	daddr = iph->daddr;
 	tos = iph->tos;
 
-	ret = ipt_do_table(skb, hook, in, out,
+	ret = ipt_do_table(skb, NF_INET_LOCAL_OUT, NULL, out,
 			   dev_net(out)->ipv4.iptable_mangle);
 	/* Reroute for ANY change. */
 	if (ret != NF_DROP && ret != NF_STOLEN && ret != NF_QUEUE) {
@@ -129,44 +129,6 @@ iptable_mangle_hook(unsigned int hook,
 	       dev_net(in)->ipv4.iptable_mangle);
 }
 
-static struct nf_hook_ops ipt_ops[] __read_mostly = {
-	{
-		.hook		= iptable_mangle_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_PRE_ROUTING,
-		.priority	= NF_IP_PRI_MANGLE,
-	},
-	{
-		.hook		= iptable_mangle_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_MANGLE,
-	},
-	{
-		.hook		= iptable_mangle_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_FORWARD,
-		.priority	= NF_IP_PRI_MANGLE,
-	},
-	{
-		.hook		= iptable_mangle_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_OUT,
-		.priority	= NF_IP_PRI_MANGLE,
-	},
-	{
-		.hook		= iptable_mangle_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP_PRI_MANGLE,
-	},
-};
-
 static int __net_init iptable_mangle_net_init(struct net *net)
 {
 	/* Register table */
@@ -187,6 +149,8 @@ static struct pernet_operations iptable_mangle_net_ops = {
 	.exit = iptable_mangle_net_exit,
 };
 
+static struct nf_hook_ops *mangle_ops;
+
 static int __init iptable_mangle_init(void)
 {
 	int ret;
@@ -196,9 +160,12 @@ static int __init iptable_mangle_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
-	if (ret < 0)
+	mangle_ops = xt_hook_link(iptable_mangle_hook, NFPROTO_IPV4,
+	             NF_IP_PRI_MANGLE, MANGLE_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(mangle_ops)) {
+		ret = PTR_ERR(mangle_ops);
 		goto cleanup_table;
+	}
 
 	return ret;
 
@@ -209,7 +176,7 @@ static int __init iptable_mangle_init(void)
 
 static void __exit iptable_mangle_fini(void)
 {
-	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
+	xt_hook_unlink(mangle_ops, MANGLE_VALID_HOOKS);
 	unregister_pernet_subsys(&iptable_mangle_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 5fe83b2..9f85c9a 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -62,24 +62,6 @@ iptable_raw_hook(unsigned int hook,
 	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_raw);
 }
 
-/* 'raw' is the very first table. */
-static struct nf_hook_ops ipt_ops[] __read_mostly = {
-	{
-		.hook = iptable_raw_hook,
-		.pf = NFPROTO_IPV4,
-		.hooknum = NF_INET_PRE_ROUTING,
-		.priority = NF_IP_PRI_RAW,
-		.owner = THIS_MODULE,
-	},
-	{
-		.hook = iptable_raw_hook,
-		.pf = NFPROTO_IPV4,
-		.hooknum = NF_INET_LOCAL_OUT,
-		.priority = NF_IP_PRI_RAW,
-		.owner = THIS_MODULE,
-	},
-};
-
 static int __net_init iptable_raw_net_init(struct net *net)
 {
 	/* Register table */
@@ -100,6 +82,8 @@ static struct pernet_operations iptable_raw_net_ops = {
 	.exit = iptable_raw_net_exit,
 };
 
+static struct nf_hook_ops *rawtable_ops;
+
 static int __init iptable_raw_init(void)
 {
 	int ret;
@@ -109,9 +93,12 @@ static int __init iptable_raw_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
-	if (ret < 0)
+	rawtable_ops = xt_hook_link(iptable_raw_hook, NFPROTO_IPV4,
+	               NF_IP_PRI_FIRST, RAW_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(rawtable_ops)) {
+		ret = PTR_ERR(rawtable_ops);
 		goto cleanup_table;
+	}
 
 	return ret;
 
@@ -122,7 +109,7 @@ static int __init iptable_raw_init(void)
 
 static void __exit iptable_raw_fini(void)
 {
-	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
+	xt_hook_unlink(rawtable_ops, RAW_VALID_HOOKS);
 	unregister_pernet_subsys(&iptable_raw_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index a308219..ccb527e 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -82,30 +82,6 @@ iptable_security_hook(unsigned int hook,
 	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_security);
 }
 
-static struct nf_hook_ops ipt_ops[] __read_mostly = {
-	{
-		.hook		= iptable_security_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_SECURITY,
-	},
-	{
-		.hook		= iptable_security_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_FORWARD,
-		.priority	= NF_IP_PRI_SECURITY,
-	},
-	{
-		.hook		= iptable_security_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_OUT,
-		.priority	= NF_IP_PRI_SECURITY,
-	},
-};
-
 static int __net_init iptable_security_net_init(struct net *net)
 {
 	net->ipv4.iptable_security =
@@ -127,6 +103,8 @@ static struct pernet_operations iptable_security_net_ops = {
 	.exit = iptable_security_net_exit,
 };
 
+static struct nf_hook_ops *sectbl_ops;
+
 static int __init iptable_security_init(void)
 {
 	int ret;
@@ -135,9 +113,12 @@ static int __init iptable_security_init(void)
         if (ret < 0)
 		return ret;
 
-	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
-	if (ret < 0)
+	sectbl_ops = xt_hook_link(iptable_security_hook, NFPROTO_IPV4,
+	             NF_IP_PRI_SECURITY, SECURITY_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(sectbl_ops)) {
+		ret = PTR_ERR(sectbl_ops);
 		goto cleanup_table;
+	}
 
 	return ret;
 
@@ -148,7 +129,7 @@ cleanup_table:
 
 static void __exit iptable_security_fini(void)
 {
-	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
+	xt_hook_unlink(sectbl_ops, SECURITY_VALID_HOOKS);
 	unregister_pernet_subsys(&iptable_security_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index c6ad7cd..2be11ee 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -71,30 +71,6 @@ ip6table_filter_hook(unsigned int hook,
 	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_filter);
 }
 
-static struct nf_hook_ops ip6t_ops[] __read_mostly = {
-	{
-		.hook		= ip6table_filter_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP6_PRI_FILTER,
-	},
-	{
-		.hook		= ip6table_filter_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_FORWARD,
-		.priority	= NF_IP6_PRI_FILTER,
-	},
-	{
-		.hook		= ip6table_filter_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_OUT,
-		.priority	= NF_IP6_PRI_FILTER,
-	},
-};
-
 /* Default to forward because I got too much mail already. */
 static int forward = NF_ACCEPT;
 module_param(forward, bool, 0000);
@@ -119,6 +95,8 @@ static struct pernet_operations ip6table_filter_net_ops = {
 	.exit = ip6table_filter_net_exit,
 };
 
+static struct nf_hook_ops *filter_ops;
+
 static int __init ip6table_filter_init(void)
 {
 	int ret;
@@ -136,9 +114,12 @@ static int __init ip6table_filter_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
-	if (ret < 0)
+	filter_ops = xt_hook_link(ip6table_filter_hook, NFPROTO_IPV6,
+	             NF_IP6_PRI_FILTER, FILTER_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(filter_ops)) {
+		ret = PTR_ERR(filter_ops);
 		goto cleanup_table;
+	}
 
 	return ret;
 
@@ -149,7 +130,7 @@ static int __init ip6table_filter_init(void)
 
 static void __exit ip6table_filter_fini(void)
 {
-	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
+	xt_hook_unlink(filter_ops, FILTER_VALID_HOOKS);
 	unregister_pernet_subsys(&ip6table_filter_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 63abcec..500bfbe 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -96,7 +96,7 @@ ip6t_local_out_hook(unsigned int hook,
 	/* flowlabel and prio (includes version, which shouldn't change either */
 	flowlabel = *((u_int32_t *)ipv6_hdr(skb));
 
-	ret = ip6t_do_table(skb, hook, in, out,
+	ret = ip6t_do_table(skb, NF_INET_LOCAL_OUT, NULL, out,
 			    dev_net(out)->ipv6.ip6table_mangle);
 
 	if (ret != NF_DROP && ret != NF_STOLEN
@@ -118,51 +118,13 @@ ip6table_mangle_hook(unsigned int hook,
 	 int (*okfn)(struct sk_buff *))
 {
 	if (hook == NF_INET_LOCAL_OUT)
-		return ip6t_loacl_out_hook(hook, skb, hook, in, okfn);
+		return ip6t_local_out_hook(hook, skb, in, out, okfn);
 
 	/* INPUT/FORWARD */
 	return ip6t_do_table(skb, hook, in, out,
 			     dev_net(in)->ipv6.ip6table_mangle);
 }
 
-static struct nf_hook_ops ip6t_ops[] __read_mostly = {
-	{
-		.hook		= ip6table_mangle_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_PRE_ROUTING,
-		.priority	= NF_IP6_PRI_MANGLE,
-	},
-	{
-		.hook		= ip6table_mangle_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP6_PRI_MANGLE,
-	},
-	{
-		.hook		= ip6table_mangle_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_FORWARD,
-		.priority	= NF_IP6_PRI_MANGLE,
-	},
-	{
-		.hook		= ip6table_mangle_out_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_OUT,
-		.priority	= NF_IP6_PRI_MANGLE,
-	},
-	{
-		.hook		= ip6table_mangle_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP6_PRI_MANGLE,
-	},
-};
-
 static int __net_init ip6table_mangle_net_init(struct net *net)
 {
 	/* Register table */
@@ -183,6 +145,8 @@ static struct pernet_operations ip6table_mangle_net_ops = {
 	.exit = ip6table_mangle_net_exit,
 };
 
+static struct nf_hook_ops *mangle_ops;
+
 static int __init ip6table_mangle_init(void)
 {
 	int ret;
@@ -192,9 +156,12 @@ static int __init ip6table_mangle_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
-	if (ret < 0)
+	mangle_ops = xt_hook_link(ip6table_mangle_hook, NFPROTO_IPV6,
+	             NF_IP6_PRI_MANGLE, MANGLE_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(mangle_ops)) {
+		ret = PTR_ERR(mangle_ops);
 		goto cleanup_table;
+	}
 
 	return ret;
 
@@ -205,7 +172,7 @@ static int __init ip6table_mangle_init(void)
 
 static void __exit ip6table_mangle_fini(void)
 {
-	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
+	xt_hook_unlink(mangle_ops, MANGLE_VALID_HOOKS);
 	unregister_pernet_subsys(&ip6table_mangle_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index f7eaf54..b8f9b41 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -55,23 +55,6 @@ ip6table_raw_hook(unsigned int hook,
 	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_raw);
 }
 
-static struct nf_hook_ops ip6t_ops[] __read_mostly = {
-	{
-	  .hook = ip6table_raw_hook,
-	  .pf = NFPROTO_IPV6,
-	  .hooknum = NF_INET_PRE_ROUTING,
-	  .priority = NF_IP6_PRI_FIRST,
-	  .owner = THIS_MODULE,
-	},
-	{
-	  .hook = ip6table_raw_hook,
-	  .pf = NFPROTO_IPV6,
-	  .hooknum = NF_INET_LOCAL_OUT,
-	  .priority = NF_IP6_PRI_FIRST,
-	  .owner = THIS_MODULE,
-	},
-};
-
 static int __net_init ip6table_raw_net_init(struct net *net)
 {
 	/* Register table */
@@ -92,6 +75,8 @@ static struct pernet_operations ip6table_raw_net_ops = {
 	.exit = ip6table_raw_net_exit,
 };
 
+static struct nf_hook_ops *rawtable_ops;
+
 static int __init ip6table_raw_init(void)
 {
 	int ret;
@@ -101,9 +86,12 @@ static int __init ip6table_raw_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
-	if (ret < 0)
+	rawtable_ops = xt_hook_link(ip6table_raw_hook, NFPROTO_IPV6,
+	               NF_IP6_PRI_FIRST, RAW_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(rawtable_ops)) {
+		ret = PTR_ERR(rawtable_ops);
 		goto cleanup_table;
+	}
 
 	return ret;
 
@@ -114,7 +102,7 @@ static int __init ip6table_raw_init(void)
 
 static void __exit ip6table_raw_fini(void)
 {
-	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
+	xt_hook_unlink(rawtable_ops, RAW_VALID_HOOKS);
 	unregister_pernet_subsys(&ip6table_raw_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 9c9fe7e..6eab20d 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -75,30 +75,6 @@ ip6table_security_hook(unsigned int hook,
 	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_security);
 }
 
-static struct nf_hook_ops ip6t_ops[] __read_mostly = {
-	{
-		.hook		= ip6table_security_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP6_PRI_SECURITY,
-	},
-	{
-		.hook		= ip6table_security_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_FORWARD,
-		.priority	= NF_IP6_PRI_SECURITY,
-	},
-	{
-		.hook		= ip6table_security_hook,
-		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_OUT,
-		.priority	= NF_IP6_PRI_SECURITY,
-	},
-};
-
 static int __net_init ip6table_security_net_init(struct net *net)
 {
 	net->ipv6.ip6table_security =
@@ -120,6 +96,8 @@ static struct pernet_operations ip6table_security_net_ops = {
 	.exit = ip6table_security_net_exit,
 };
 
+static struct nf_hook_ops *sectbl_ops;
+
 static int __init ip6table_security_init(void)
 {
 	int ret;
@@ -128,9 +106,12 @@ static int __init ip6table_security_init(void)
 	if (ret < 0)
 		return ret;
 
-	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
-	if (ret < 0)
+	sectbl_ops = xt_hook_link(ip6table_security_hook, NFPROTO_IPV6,
+	             NF_IP6_PRI_SECURITY, SECURITY_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(sectbl_ops)) {
+		ret = PTR_ERR(sectbl_ops);
 		goto cleanup_table;
+	}
 
 	return ret;
 
@@ -141,7 +122,7 @@ cleanup_table:
 
 static void __exit ip6table_security_fini(void)
 {
-	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
+	xt_hook_unlink(sectbl_ops, SECURITY_VALID_HOOKS);
 	unregister_pernet_subsys(&ip6table_security_net_ops);
 }
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 025d1a0..7e3f51d 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1090,6 +1090,72 @@ static const struct file_operations xt_target_ops = {
 
 #endif /* CONFIG_PROC_FS */
 
+static unsigned int xt_hookmask_bitcount(unsigned int mask)
+{
+	unsigned int bits = 0;
+
+	for (; mask != 0; mask >>= 1)
+		if (mask & 1)
+			++bits;
+	return bits;
+}
+
+/**
+ * xt_hook_link - set up hooks for a new table
+ * @fn:		Hook function
+ * @nfproto:	%NFPROTO_*
+ * @prio:	n'th place within @nfproto's hook list (%NF_IP_PRI_*, etc.)
+ * @hook_mask:	Requested hooks
+ *
+ * This function will take care of creating and registering the necessary
+ * Netfilter hooks for XT tables.
+ */
+struct nf_hook_ops *xt_hook_link(nf_hookfn *fn, uint8_t nfproto, int prio,
+    unsigned int hook_mask, struct module *owner)
+{
+	uint8_t i, num_hooks = xt_hookmask_bitcount(hook_mask);
+	uint8_t hooknum;
+	struct nf_hook_ops *ops;
+	int ret;
+
+	ops = kmalloc(sizeof(*ops) * num_hooks, GFP_KERNEL);
+	if (ops == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0, hooknum = 0; i < num_hooks && hook_mask != 0;
+	     hook_mask >>= 1, ++hooknum) {
+		if (!(hook_mask & 1))
+			continue;
+		ops[i].hook     = fn;
+		ops[i].owner    = owner;
+		ops[i].pf       = nfproto;
+		ops[i].hooknum  = hooknum;
+		ops[i].priority = prio;
+		++i;
+	}
+
+	ret = nf_register_hooks(ops, num_hooks);
+	if (ret < 0) {
+		kfree(ops);
+		return ERR_PTR(ret);
+	}
+
+	return ops;
+}
+EXPORT_SYMBOL_GPL(xt_hook_link);
+
+/**
+ * xt_hook_unlink - remove hooks for a table
+ * @ops:	nf_hook_ops array as returned by nf_hook_link
+ * @hook_mask:	the very same mask that was passed to nf_hook_link
+ */
+void xt_hook_unlink(struct nf_hook_ops *ops, unsigned int hook_mask)
+{
+	nf_unregister_hooks(ops, xt_hookmask_bitcount(hook_mask));
+	kfree(ops);
+}
+EXPORT_SYMBOL_GPL(xt_hook_unlink);
+
 int xt_proto_init(struct net *net, u_int8_t af)
 {
 #ifdef CONFIG_PROC_FS
-- 
1.6.4

