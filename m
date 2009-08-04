From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 023/103] netfilter: xtables: generate nf_hook_ops on-demand
Date: Tue,  4 Aug 2009 09:25:07 +0200
Message-ID: <1249370787-17583-24-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50626 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557AbZHDH06 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:58 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nuking lots of repeated and only slightly deviating data definitions.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h     |    4 ++
 net/ipv4/netfilter/arptable_filter.c   |   33 ++----------
 net/ipv4/netfilter/iptable_filter.c    |   35 +++----------
 net/ipv4/netfilter/iptable_mangle.c    |   83 ++++++++++----------------------
 net/ipv4/netfilter/iptable_raw.c       |   29 +++--------
 net/ipv4/netfilter/iptable_security.c  |   35 +++----------
 net/ipv6/netfilter/ip6table_filter.c   |   35 +++----------
 net/ipv6/netfilter/ip6table_mangle.c   |   82 +++++++++----------------------
 net/ipv6/netfilter/ip6table_raw.c      |   28 +++--------
 net/ipv6/netfilter/ip6table_security.c |   35 +++----------
 net/netfilter/x_tables.c               |   66 +++++++++++++++++++++++++
 11 files changed, 173 insertions(+), 292 deletions(-)

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
index 3092d74..c1a3797 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -63,30 +63,6 @@ static unsigned int arptable_filter_hook(unsigned int hook,
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
@@ -107,6 +83,8 @@ static struct pernet_operations arptable_filter_net_ops = {
 	.exit = arptable_filter_net_exit,
 };
 
+static struct nf_hook_ops *arpfilter_ops;
+
 static int __init arptable_filter_init(void)
 {
 	int ret;
@@ -115,15 +93,16 @@ static int __init arptable_filter_init(void)
 	if (ret < 0)
 		return ret;
 
-	ret = nf_register_hooks(arpt_ops, ARRAY_SIZE(arpt_ops));
-	if (ret < 0)
+	arpfilter_ops = xt_hook_link(arptable_filter_hook, NFPROTO_ARP,
+	                NF_IP_PRI_FILTER, FILTER_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(arpfilter_ops))
 		unregister_pernet_subsys(&arptable_filter_net_ops);
 	return ret;
 }
 
 static void __exit arptable_filter_fini(void)
 {
-	nf_unregister_hooks(arpt_ops, ARRAY_SIZE(arpt_ops));
+	xt_hook_unlink(arpfilter_ops, FILTER_VALID_HOOKS);
 	unregister_pernet_subsys(&arptable_filter_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 8eaef4a..212757f 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -79,30 +79,6 @@ iptable_filter_hook(unsigned int hook,
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
@@ -127,6 +103,8 @@ static struct pernet_operations iptable_filter_net_ops = {
 	.exit = iptable_filter_net_exit,
 };
 
+static struct nf_hook_ops *filter_ops;
+
 static int __init iptable_filter_init(void)
 {
 	int ret;
@@ -144,16 +122,19 @@ static int __init iptable_filter_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
-	if (ret < 0)
+	filter_ops = xt_hook_link(iptable_filter_hook, NFPROTO_IPV4,
+	             NF_IP_PRI_FILTER, FILTER_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(filter_ops)) {
 		unregister_pernet_subsys(&iptable_filter_net_ops);
+		return PTR_ERR(filter_ops);
+	}
 
 	return ret;
 }
 
 static void __exit iptable_filter_fini(void)
 {
-	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
+	xt_hook_unlink(filter_ops, FILTER_VALID_HOOKS);
 	unregister_pernet_subsys(&iptable_filter_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index c55c371..9a2f0b5 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -73,22 +73,8 @@ static struct xt_table packet_mangler = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-iptable_mangle_hook(unsigned int hook,
-		     struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
-{
-	const struct net *net = dev_net((in != NULL) ? in : out);
-	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_mangle);
-}
-
-static unsigned int
-iptable_mangle_out_hook(unsigned int hook,
-		   struct sk_buff *skb,
-		   const struct net_device *in,
-		   const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
+iptable_mangle_out_hook(struct sk_buff *skb, const struct net_device *out,
+                        const struct net *net)
 {
 	unsigned int ret;
 	const struct iphdr *iph;
@@ -108,8 +94,8 @@ iptable_mangle_out_hook(unsigned int hook,
 	daddr = iph->daddr;
 	tos = iph->tos;
 
-	ret = ipt_do_table(skb, hook, in, out,
-			   dev_net(out)->ipv4.iptable_mangle);
+	ret = ipt_do_table(skb, NF_INET_LOCAL_OUT, NULL, out,
+			   net->ipv4.iptable_mangle);
 	/* Reroute for ANY change. */
 	if (ret != NF_DROP && ret != NF_STOLEN && ret != NF_QUEUE) {
 		iph = ip_hdr(skb);
@@ -125,43 +111,19 @@ iptable_mangle_out_hook(unsigned int hook,
 	return ret;
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
-		.hook		= iptable_mangle_out_hook,
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
+static unsigned int
+iptable_mangle_hook(unsigned int hook, struct sk_buff *skb,
+                    const struct net_device *in,
+                    const struct net_device *out,
+                    int (*okfn)(struct sk_buff *))
+{
+	const struct net *net = dev_net((in != NULL) ? in : out);
+
+	if (hook == NF_INET_LOCAL_OUT)
+		return iptable_mangle_out_hook(skb, out, net);
+
+	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_mangle);
+}
 
 static int __net_init iptable_mangle_net_init(struct net *net)
 {
@@ -183,6 +145,8 @@ static struct pernet_operations iptable_mangle_net_ops = {
 	.exit = iptable_mangle_net_exit,
 };
 
+static struct nf_hook_ops *mangle_ops;
+
 static int __init iptable_mangle_init(void)
 {
 	int ret;
@@ -192,16 +156,19 @@ static int __init iptable_mangle_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
-	if (ret < 0)
+	mangle_ops = xt_hook_link(iptable_mangle_hook, NFPROTO_IPV4,
+	             NF_IP_PRI_MANGLE, MANGLE_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(mangle_ops)) {
 		unregister_pernet_subsys(&iptable_mangle_net_ops);
+		return PTR_ERR(mangle_ops);
+	}
 
 	return ret;
 }
 
 static void __exit iptable_mangle_fini(void)
 {
-	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
+	xt_hook_unlink(mangle_ops, MANGLE_VALID_HOOKS);
 	unregister_pernet_subsys(&iptable_mangle_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index b7d5257..c454ee9 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -63,24 +63,6 @@ iptable_raw_hook(unsigned int hook,
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
@@ -101,6 +83,8 @@ static struct pernet_operations iptable_raw_net_ops = {
 	.exit = iptable_raw_net_exit,
 };
 
+static struct nf_hook_ops *rawtable_ops;
+
 static int __init iptable_raw_init(void)
 {
 	int ret;
@@ -110,16 +94,19 @@ static int __init iptable_raw_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
-	if (ret < 0)
+	rawtable_ops = xt_hook_link(iptable_raw_hook, NFPROTO_IPV4,
+	               NF_IP_PRI_FIRST, RAW_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(rawtable_ops)) {
 		unregister_pernet_subsys(&iptable_raw_net_ops);
+		return PTR_ERR(rawtable_ops);
+	}
 
 	return ret;
 }
 
 static void __exit iptable_raw_fini(void)
 {
-	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
+	xt_hook_unlink(rawtable_ops, RAW_VALID_HOOKS);
 	unregister_pernet_subsys(&iptable_raw_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index d8ceb64..cab6baf 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -83,30 +83,6 @@ iptable_security_hook(unsigned int hook,
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
@@ -128,6 +104,8 @@ static struct pernet_operations iptable_security_net_ops = {
 	.exit = iptable_security_net_exit,
 };
 
+static struct nf_hook_ops *sectbl_ops;
+
 static int __init iptable_security_init(void)
 {
 	int ret;
@@ -136,16 +114,19 @@ static int __init iptable_security_init(void)
         if (ret < 0)
 		return ret;
 
-	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
-	if (ret < 0)
+	sectbl_ops = xt_hook_link(iptable_security_hook, NFPROTO_IPV4,
+	             NF_IP_PRI_SECURITY, SECURITY_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(sectbl_ops)) {
 		unregister_pernet_subsys(&iptable_security_net_ops);
+		return PTR_ERR(sectbl_ops);
+	}
 
 	return ret;
 }
 
 static void __exit iptable_security_fini(void)
 {
-	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
+	xt_hook_unlink(sectbl_ops, SECURITY_VALID_HOOKS);
 	unregister_pernet_subsys(&iptable_security_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 79a302e..0b5f24b 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -70,30 +70,6 @@ ip6table_filter_hook(unsigned int hook,
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
@@ -118,6 +94,8 @@ static struct pernet_operations ip6table_filter_net_ops = {
 	.exit = ip6table_filter_net_exit,
 };
 
+static struct nf_hook_ops *filter_ops;
+
 static int __init ip6table_filter_init(void)
 {
 	int ret;
@@ -135,16 +113,19 @@ static int __init ip6table_filter_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
-	if (ret < 0)
+	filter_ops = xt_hook_link(ip6table_filter_hook, NFPROTO_IPV6,
+	             NF_IP6_PRI_FILTER, FILTER_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(filter_ops)) {
 		unregister_pernet_subsys(&ip6table_filter_net_ops);
+		return PTR_ERR(filter_ops);
+	}
 
 	return ret;
 }
 
 static void __exit ip6table_filter_fini(void)
 {
-	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
+	xt_hook_unlink(filter_ops, FILTER_VALID_HOOKS);
 	unregister_pernet_subsys(&ip6table_filter_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 6fd2c37..c663d9c 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -66,22 +66,8 @@ static struct xt_table packet_mangler = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6table_mangle_hook(unsigned int hook,
-	 struct sk_buff *skb,
-	 const struct net_device *in,
-	 const struct net_device *out,
-	 int (*okfn)(struct sk_buff *))
-{
-	const struct net *net = dev_net((in != NULL) ? in : out);
-	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_mangle);
-}
-
-static unsigned int
-ip6table_mangle_out_hook(unsigned int hook,
-		   struct sk_buff *skb,
-		   const struct net_device *in,
-		   const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
+ip6table_mangle_out(struct sk_buff *skb, const struct net_device *out,
+                    const struct net *net)
 {
 
 	unsigned int ret;
@@ -108,8 +94,8 @@ ip6table_mangle_out_hook(unsigned int hook,
 	/* flowlabel and prio (includes version, which shouldn't change either */
 	flowlabel = *((u_int32_t *)ipv6_hdr(skb));
 
-	ret = ip6t_do_table(skb, hook, in, out,
-			    dev_net(out)->ipv6.ip6table_mangle);
+	ret = ip6t_do_table(skb, NF_INET_LOCAL_OUT, NULL, out,
+			    net->ipv6.ip6table_mangle);
 
 	if (ret != NF_DROP && ret != NF_STOLEN
 		&& (memcmp(&ipv6_hdr(skb)->saddr, &saddr, sizeof(saddr))
@@ -121,43 +107,18 @@ ip6table_mangle_out_hook(unsigned int hook,
 	return ret;
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
+static unsigned int
+ip6table_mangle_hook(unsigned int hook, struct sk_buff *skb,
+                     const struct net_device *in,
+                     const struct net_device *out,
+                     int (*okfn)(struct sk_buff *))
+{
+	const struct net *net = dev_net((in != NULL) ? in : out);
+
+	if (hook == NF_INET_LOCAL_OUT)
+		return ip6table_mangle_out(skb, out, net);
+	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_mangle);
+}
 
 static int __net_init ip6table_mangle_net_init(struct net *net)
 {
@@ -179,6 +140,8 @@ static struct pernet_operations ip6table_mangle_net_ops = {
 	.exit = ip6table_mangle_net_exit,
 };
 
+static struct nf_hook_ops *mangle_ops;
+
 static int __init ip6table_mangle_init(void)
 {
 	int ret;
@@ -188,16 +151,19 @@ static int __init ip6table_mangle_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
-	if (ret < 0)
+	mangle_ops = xt_hook_link(ip6table_mangle_hook, NFPROTO_IPV6,
+	             NF_IP6_PRI_MANGLE, MANGLE_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(mangle_ops)) {
 		unregister_pernet_subsys(&ip6table_mangle_net_ops);
+		return PTR_ERR(mangle_ops);
+	}
 
 	return ret;
 }
 
 static void __exit ip6table_mangle_fini(void)
 {
-	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
+	xt_hook_unlink(mangle_ops, MANGLE_VALID_HOOKS);
 	unregister_pernet_subsys(&ip6table_mangle_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 75c5c44..17d32d4 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -54,23 +54,6 @@ ip6table_raw_hook(unsigned int hook,
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
@@ -91,6 +74,8 @@ static struct pernet_operations ip6table_raw_net_ops = {
 	.exit = ip6table_raw_net_exit,
 };
 
+static struct nf_hook_ops *rawtable_ops;
+
 static int __init ip6table_raw_init(void)
 {
 	int ret;
@@ -100,16 +85,19 @@ static int __init ip6table_raw_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
-	if (ret < 0)
+	rawtable_ops = xt_hook_link(ip6table_raw_hook, NFPROTO_IPV6,
+	               NF_IP6_PRI_FIRST, RAW_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(rawtable_ops)) {
 		unregister_pernet_subsys(&ip6table_raw_net_ops);
+		return PTR_ERR(rawtable_ops);
+	}
 
 	return ret;
 }
 
 static void __exit ip6table_raw_fini(void)
 {
-	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
+	xt_hook_unlink(rawtable_ops, RAW_VALID_HOOKS);
 	unregister_pernet_subsys(&ip6table_raw_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 7d9781e..b402437 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -74,30 +74,6 @@ ip6table_security_hook(unsigned int hook,
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
@@ -119,6 +95,8 @@ static struct pernet_operations ip6table_security_net_ops = {
 	.exit = ip6table_security_net_exit,
 };
 
+static struct nf_hook_ops *sectbl_ops;
+
 static int __init ip6table_security_init(void)
 {
 	int ret;
@@ -127,16 +105,19 @@ static int __init ip6table_security_init(void)
 	if (ret < 0)
 		return ret;
 
-	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
-	if (ret < 0)
+	sectbl_ops = xt_hook_link(ip6table_security_hook, NFPROTO_IPV6,
+	             NF_IP6_PRI_SECURITY, SECURITY_VALID_HOOKS, THIS_MODULE);
+	if (IS_ERR(sectbl_ops)) {
 		unregister_pernet_subsys(&ip6table_security_net_ops);
+		return PTR_ERR(sectbl_ops);
+	}
 
 	return ret;
 }
 
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
1.6.3.3

