From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 027/103] netfilter: xtables: generate initial table on-demand
Date: Tue,  4 Aug 2009 09:25:11 +0200
Message-ID: <1249370787-17583-28-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50626 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549AbZHDH1C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:02 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The static initial tables are pretty large (1K), and after the net
namespace has been instantiated, they just hang around for nothing.
Now they are gone from both your disk and memory. (During
initialization, memory use remains the same.)

Some numbers:
    text    data     bss     dec     hex filename
-4043674  563169  512000 5118843  4e1b7b ./vmlinux[x86_64](before)
+4045071  550177  512000 5107248  4dee30 ./vmlinux[x86_64](after)
=  +1397  -12992
=== -11595

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h     |    1 +
 net/ipv4/netfilter/arptable_filter.c   |   39 ++++-------------------
 net/ipv4/netfilter/iptable_filter.c    |   45 ++++++--------------------
 net/ipv4/netfilter/iptable_mangle.c    |   45 +++-----------------------
 net/ipv4/netfilter/iptable_raw.c       |   35 +++-----------------
 net/ipv4/netfilter/iptable_security.c  |   38 +++-------------------
 net/ipv4/netfilter/nf_nat_rule.c       |   38 +++-------------------
 net/ipv6/netfilter/ip6table_filter.c   |   45 ++++++--------------------
 net/ipv6/netfilter/ip6table_mangle.c   |   44 +++----------------------
 net/ipv6/netfilter/ip6table_raw.c      |   35 +++-----------------
 net/ipv6/netfilter/ip6table_security.c |   38 +++-------------------
 net/netfilter/x_tables.c               |   54 +++++++++++++++++++++++++++++++-
 12 files changed, 123 insertions(+), 334 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 2a47a01..bdcb2f6 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -528,6 +528,7 @@ static inline unsigned long ifname_compare_aligned(const char *_a,
 
 extern struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
 extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
+extern void *xt_repldata_create(const struct xt_table *);
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 11e6ee9..1299f08 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp/arp_tables.h>
 
 MODULE_LICENSE("GPL");
@@ -15,36 +16,6 @@ MODULE_DESCRIPTION("arptables filter table");
 #define FILTER_VALID_HOOKS ((1 << NF_ARP_IN) | (1 << NF_ARP_OUT) | \
 			   (1 << NF_ARP_FORWARD))
 
-static const struct
-{
-	struct arpt_replace repl;
-	struct arpt_standard entries[3];
-	struct arpt_error term;
-} initial_table __net_initdata = {
-	.repl = {
-		.name = "filter",
-		.valid_hooks = FILTER_VALID_HOOKS,
-		.num_entries = 4,
-		.size = sizeof(struct arpt_standard) * 3 + sizeof(struct arpt_error),
-		.hook_entry = {
-			[NF_ARP_IN] = 0,
-			[NF_ARP_OUT] = sizeof(struct arpt_standard),
-			[NF_ARP_FORWARD] = 2 * sizeof(struct arpt_standard),
-		},
-		.underflow = {
-			[NF_ARP_IN] = 0,
-			[NF_ARP_OUT] = sizeof(struct arpt_standard),
-			[NF_ARP_FORWARD] = 2 * sizeof(struct arpt_standard),
-		},
-	},
-	.entries = {
-		ARPT_STANDARD_INIT(NF_ACCEPT),	/* ARP_IN */
-		ARPT_STANDARD_INIT(NF_ACCEPT),	/* ARP_OUT */
-		ARPT_STANDARD_INIT(NF_ACCEPT),	/* ARP_FORWARD */
-	},
-	.term = ARPT_ERROR_INIT,
-};
-
 static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
@@ -66,9 +37,13 @@ static unsigned int arptable_filter_hook(unsigned int hook,
 
 static int __net_init arptable_filter_net_init(struct net *net)
 {
-	/* Register table */
+	struct arpt_replace *repl = xt_repldata_create(&packet_filter);
+
+	if (repl == NULL)
+		return -ENOMEM;
 	net->ipv4.arptable_filter =
-		arpt_register_table(net, &packet_filter, &initial_table.repl);
+		arpt_register_table(net, &packet_filter, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv4.arptable_filter))
 		return PTR_ERR(net->ipv4.arptable_filter);
 	return 0;
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 61b6faa..962d6f5 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -23,36 +23,6 @@ MODULE_DESCRIPTION("iptables filter table");
 			    (1 << NF_INET_FORWARD) | \
 			    (1 << NF_INET_LOCAL_OUT))
 
-static struct
-{
-	struct ipt_replace repl;
-	struct ipt_standard entries[3];
-	struct ipt_error term;
-} initial_table __net_initdata = {
-	.repl = {
-		.name = "filter",
-		.valid_hooks = FILTER_VALID_HOOKS,
-		.num_entries = 4,
-		.size = sizeof(struct ipt_standard) * 3 + sizeof(struct ipt_error),
-		.hook_entry = {
-			[NF_INET_LOCAL_IN] = 0,
-			[NF_INET_FORWARD] = sizeof(struct ipt_standard),
-			[NF_INET_LOCAL_OUT] = sizeof(struct ipt_standard) * 2,
-		},
-		.underflow = {
-			[NF_INET_LOCAL_IN] = 0,
-			[NF_INET_FORWARD] = sizeof(struct ipt_standard),
-			[NF_INET_LOCAL_OUT] = sizeof(struct ipt_standard) * 2,
-		},
-	},
-	.entries = {
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
-	},
-	.term = IPT_ERROR_INIT,			/* ERROR */
-};
-
 static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
@@ -86,9 +56,17 @@ module_param(forward, bool, 0000);
 
 static int __net_init iptable_filter_net_init(struct net *net)
 {
-	/* Register table */
+	struct ipt_replace *repl = xt_repldata_create(&packet_filter);
+
+	if (repl == NULL)
+		return -ENOMEM;
+	/* Entry 1 is the FORWARD hook */
+	((struct ipt_standard *)repl->entries)[1].target.verdict =
+		-forward - 1;
+
 	net->ipv4.iptable_filter =
-		ipt_register_table(net, &packet_filter, &initial_table.repl);
+		ipt_register_table(net, &packet_filter, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv4.iptable_filter))
 		return PTR_ERR(net->ipv4.iptable_filter);
 	return 0;
@@ -115,9 +93,6 @@ static int __init iptable_filter_init(void)
 		return -EINVAL;
 	}
 
-	/* Entry 1 is the FORWARD hook */
-	initial_table.entries[1].target.verdict = -forward - 1;
-
 	ret = register_pernet_subsys(&iptable_filter_net_ops);
 	if (ret < 0)
 		return ret;
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index c178bf1..8434f57 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -27,43 +27,6 @@ MODULE_DESCRIPTION("iptables mangle table");
 			    (1 << NF_INET_LOCAL_OUT) | \
 			    (1 << NF_INET_POST_ROUTING))
 
-/* Ouch - five different hooks? Maybe this should be a config option..... -- BC */
-static const struct
-{
-	struct ipt_replace repl;
-	struct ipt_standard entries[5];
-	struct ipt_error term;
-} initial_table __net_initdata = {
-	.repl = {
-		.name = "mangle",
-		.valid_hooks = MANGLE_VALID_HOOKS,
-		.num_entries = 6,
-		.size = sizeof(struct ipt_standard) * 5 + sizeof(struct ipt_error),
-		.hook_entry = {
-			[NF_INET_PRE_ROUTING] 	= 0,
-			[NF_INET_LOCAL_IN] 	= sizeof(struct ipt_standard),
-			[NF_INET_FORWARD] 	= sizeof(struct ipt_standard) * 2,
-			[NF_INET_LOCAL_OUT] 	= sizeof(struct ipt_standard) * 3,
-			[NF_INET_POST_ROUTING] 	= sizeof(struct ipt_standard) * 4,
-		},
-		.underflow = {
-			[NF_INET_PRE_ROUTING] 	= 0,
-			[NF_INET_LOCAL_IN] 	= sizeof(struct ipt_standard),
-			[NF_INET_FORWARD] 	= sizeof(struct ipt_standard) * 2,
-			[NF_INET_LOCAL_OUT] 	= sizeof(struct ipt_standard) * 3,
-			[NF_INET_POST_ROUTING]	= sizeof(struct ipt_standard) * 4,
-		},
-	},
-	.entries = {
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* POST_ROUTING */
-	},
-	.term = IPT_ERROR_INIT,			/* ERROR */
-};
-
 static const struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
@@ -128,9 +91,13 @@ iptable_mangle_hook(unsigned int hook, struct sk_buff *skb,
 
 static int __net_init iptable_mangle_net_init(struct net *net)
 {
-	/* Register table */
+	struct ipt_replace *repl = xt_repldata_create(&packet_mangler);
+
+	if (repl == NULL)
+		return -ENOMEM;
 	net->ipv4.iptable_mangle =
-		ipt_register_table(net, &packet_mangler, &initial_table.repl);
+		ipt_register_table(net, &packet_mangler, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv4.iptable_mangle))
 		return PTR_ERR(net->ipv4.iptable_mangle);
 	return 0;
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 9dcdad0..243329c 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -9,33 +9,6 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
 
-static const struct
-{
-	struct ipt_replace repl;
-	struct ipt_standard entries[2];
-	struct ipt_error term;
-} initial_table __net_initdata = {
-	.repl = {
-		.name = "raw",
-		.valid_hooks = RAW_VALID_HOOKS,
-		.num_entries = 3,
-		.size = sizeof(struct ipt_standard) * 2 + sizeof(struct ipt_error),
-		.hook_entry = {
-			[NF_INET_PRE_ROUTING] = 0,
-			[NF_INET_LOCAL_OUT] = sizeof(struct ipt_standard)
-		},
-		.underflow = {
-			[NF_INET_PRE_ROUTING] = 0,
-			[NF_INET_LOCAL_OUT]  = sizeof(struct ipt_standard)
-		},
-	},
-	.entries = {
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
-	},
-	.term = IPT_ERROR_INIT,			/* ERROR */
-};
-
 static const struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks =  RAW_VALID_HOOKS,
@@ -66,9 +39,13 @@ iptable_raw_hook(unsigned int hook,
 
 static int __net_init iptable_raw_net_init(struct net *net)
 {
-	/* Register table */
+	struct ipt_replace *repl = xt_repldata_create(&packet_raw);
+
+	if (repl == NULL)
+		return -ENOMEM;
 	net->ipv4.iptable_raw =
-		ipt_register_table(net, &packet_raw, &initial_table.repl);
+		ipt_register_table(net, &packet_raw, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv4.iptable_raw))
 		return PTR_ERR(net->ipv4.iptable_raw);
 	return 0;
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 67d54c2..d2aed39 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -27,36 +27,6 @@ MODULE_DESCRIPTION("iptables security table, for MAC rules");
 				(1 << NF_INET_FORWARD) | \
 				(1 << NF_INET_LOCAL_OUT)
 
-static const struct
-{
-	struct ipt_replace repl;
-	struct ipt_standard entries[3];
-	struct ipt_error term;
-} initial_table __net_initdata = {
-	.repl = {
-		.name = "security",
-		.valid_hooks = SECURITY_VALID_HOOKS,
-		.num_entries = 4,
-		.size = sizeof(struct ipt_standard) * 3 + sizeof(struct ipt_error),
-		.hook_entry = {
-			[NF_INET_LOCAL_IN] 	= 0,
-			[NF_INET_FORWARD] 	= sizeof(struct ipt_standard),
-			[NF_INET_LOCAL_OUT] 	= sizeof(struct ipt_standard) * 2,
-		},
-		.underflow = {
-			[NF_INET_LOCAL_IN] 	= 0,
-			[NF_INET_FORWARD] 	= sizeof(struct ipt_standard),
-			[NF_INET_LOCAL_OUT] 	= sizeof(struct ipt_standard) * 2,
-		},
-	},
-	.entries = {
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
-	},
-	.term = IPT_ERROR_INIT,			/* ERROR */
-};
-
 static const struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
@@ -86,9 +56,13 @@ iptable_security_hook(unsigned int hook,
 
 static int __net_init iptable_security_net_init(struct net *net)
 {
-	net->ipv4.iptable_security =
-		ipt_register_table(net, &security_table, &initial_table.repl);
+	struct ipt_replace *repl = xt_repldata_create(&security_table);
 
+	if (repl == NULL)
+		return -ENOMEM;
+	net->ipv4.iptable_security =
+		ipt_register_table(net, &security_table, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv4.iptable_security))
 		return PTR_ERR(net->ipv4.iptable_security);
 
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 9e81e0d..57f9d1d 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -28,36 +28,6 @@
 			 (1 << NF_INET_POST_ROUTING) | \
 			 (1 << NF_INET_LOCAL_OUT))
 
-static const struct
-{
-	struct ipt_replace repl;
-	struct ipt_standard entries[3];
-	struct ipt_error term;
-} nat_initial_table __net_initdata = {
-	.repl = {
-		.name = "nat",
-		.valid_hooks = NAT_VALID_HOOKS,
-		.num_entries = 4,
-		.size = sizeof(struct ipt_standard) * 3 + sizeof(struct ipt_error),
-		.hook_entry = {
-			[NF_INET_PRE_ROUTING] = 0,
-			[NF_INET_POST_ROUTING] = sizeof(struct ipt_standard),
-			[NF_INET_LOCAL_OUT] = sizeof(struct ipt_standard) * 2
-		},
-		.underflow = {
-			[NF_INET_PRE_ROUTING] = 0,
-			[NF_INET_POST_ROUTING] = sizeof(struct ipt_standard),
-			[NF_INET_LOCAL_OUT] = sizeof(struct ipt_standard) * 2
-		},
-	},
-	.entries = {
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* POST_ROUTING */
-		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
-	},
-	.term = IPT_ERROR_INIT,			/* ERROR */
-};
-
 static const struct xt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
@@ -186,8 +156,12 @@ static struct xt_target ipt_dnat_reg __read_mostly = {
 
 static int __net_init nf_nat_rule_net_init(struct net *net)
 {
-	net->ipv4.nat_table = ipt_register_table(net, &nat_table,
-						 &nat_initial_table.repl);
+	struct ipt_replace *repl = xt_repldata_create(&nat_table);
+
+	if (repl == NULL)
+		return -ENOMEM;
+	net->ipv4.nat_table = ipt_register_table(net, &nat_table, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv4.nat_table))
 		return PTR_ERR(net->ipv4.nat_table);
 	return 0;
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 8c8b218..5b8e67e 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -21,36 +21,6 @@ MODULE_DESCRIPTION("ip6tables filter table");
 			    (1 << NF_INET_FORWARD) | \
 			    (1 << NF_INET_LOCAL_OUT))
 
-static struct
-{
-	struct ip6t_replace repl;
-	struct ip6t_standard entries[3];
-	struct ip6t_error term;
-} initial_table __net_initdata = {
-	.repl = {
-		.name = "filter",
-		.valid_hooks = FILTER_VALID_HOOKS,
-		.num_entries = 4,
-		.size = sizeof(struct ip6t_standard) * 3 + sizeof(struct ip6t_error),
-		.hook_entry = {
-			[NF_INET_LOCAL_IN] = 0,
-			[NF_INET_FORWARD] = sizeof(struct ip6t_standard),
-			[NF_INET_LOCAL_OUT] = sizeof(struct ip6t_standard) * 2
-		},
-		.underflow = {
-			[NF_INET_LOCAL_IN] = 0,
-			[NF_INET_FORWARD] = sizeof(struct ip6t_standard),
-			[NF_INET_LOCAL_OUT] = sizeof(struct ip6t_standard) * 2
-		},
-	},
-	.entries = {
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
-	},
-	.term = IP6T_ERROR_INIT,		/* ERROR */
-};
-
 static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
@@ -77,9 +47,17 @@ module_param(forward, bool, 0000);
 
 static int __net_init ip6table_filter_net_init(struct net *net)
 {
-	/* Register table */
+	struct ip6t_replace *repl = xt_repldata_create(&packet_filter);
+
+	if (repl == NULL)
+		return -ENOMEM;
+	/* Entry 1 is the FORWARD hook */
+	((struct ip6t_standard *)repl->entries)[1].target.verdict =
+		-forward - 1;
+
 	net->ipv6.ip6table_filter =
-		ip6t_register_table(net, &packet_filter, &initial_table.repl);
+		ip6t_register_table(net, &packet_filter, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv6.ip6table_filter))
 		return PTR_ERR(net->ipv6.ip6table_filter);
 	return 0;
@@ -106,9 +84,6 @@ static int __init ip6table_filter_init(void)
 		return -EINVAL;
 	}
 
-	/* Entry 1 is the FORWARD hook */
-	initial_table.entries[1].target.verdict = -forward - 1;
-
 	ret = register_pernet_subsys(&ip6table_filter_net_ops);
 	if (ret < 0)
 		return ret;
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index e13adec..5d841e6 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -21,42 +21,6 @@ MODULE_DESCRIPTION("ip6tables mangle table");
 			    (1 << NF_INET_LOCAL_OUT) | \
 			    (1 << NF_INET_POST_ROUTING))
 
-static const struct
-{
-	struct ip6t_replace repl;
-	struct ip6t_standard entries[5];
-	struct ip6t_error term;
-} initial_table __net_initdata = {
-	.repl = {
-		.name = "mangle",
-		.valid_hooks = MANGLE_VALID_HOOKS,
-		.num_entries = 6,
-		.size = sizeof(struct ip6t_standard) * 5 + sizeof(struct ip6t_error),
-		.hook_entry = {
-			[NF_INET_PRE_ROUTING] 	= 0,
-			[NF_INET_LOCAL_IN]	= sizeof(struct ip6t_standard),
-			[NF_INET_FORWARD]	= sizeof(struct ip6t_standard) * 2,
-			[NF_INET_LOCAL_OUT] 	= sizeof(struct ip6t_standard) * 3,
-			[NF_INET_POST_ROUTING]	= sizeof(struct ip6t_standard) * 4,
-		},
-		.underflow = {
-			[NF_INET_PRE_ROUTING] 	= 0,
-			[NF_INET_LOCAL_IN]	= sizeof(struct ip6t_standard),
-			[NF_INET_FORWARD]	= sizeof(struct ip6t_standard) * 2,
-			[NF_INET_LOCAL_OUT] 	= sizeof(struct ip6t_standard) * 3,
-			[NF_INET_POST_ROUTING]	= sizeof(struct ip6t_standard) * 4,
-		},
-	},
-	.entries = {
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* POST_ROUTING */
-	},
-	.term = IP6T_ERROR_INIT,		/* ERROR */
-};
-
 static const struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
@@ -123,9 +87,13 @@ ip6table_mangle_hook(unsigned int hook, struct sk_buff *skb,
 
 static int __net_init ip6table_mangle_net_init(struct net *net)
 {
-	/* Register table */
+	struct ip6t_replace *repl = xt_repldata_create(&packet_mangler);
+
+	if (repl == NULL)
+		return -ENOMEM;
 	net->ipv6.ip6table_mangle =
-		ip6t_register_table(net, &packet_mangler, &initial_table.repl);
+		ip6t_register_table(net, &packet_mangler, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv6.ip6table_mangle))
 		return PTR_ERR(net->ipv6.ip6table_mangle);
 	return 0;
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index b7c535d..b24b14a 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -8,33 +8,6 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
 
-static const struct
-{
-	struct ip6t_replace repl;
-	struct ip6t_standard entries[2];
-	struct ip6t_error term;
-} initial_table __net_initdata = {
-	.repl = {
-		.name = "raw",
-		.valid_hooks = RAW_VALID_HOOKS,
-		.num_entries = 3,
-		.size = sizeof(struct ip6t_standard) * 2 + sizeof(struct ip6t_error),
-		.hook_entry = {
-			[NF_INET_PRE_ROUTING] = 0,
-			[NF_INET_LOCAL_OUT] = sizeof(struct ip6t_standard)
-		},
-		.underflow = {
-			[NF_INET_PRE_ROUTING] = 0,
-			[NF_INET_LOCAL_OUT] = sizeof(struct ip6t_standard)
-		},
-	},
-	.entries = {
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
-	},
-	.term = IP6T_ERROR_INIT,		/* ERROR */
-};
-
 static const struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks = RAW_VALID_HOOKS,
@@ -57,9 +30,13 @@ ip6table_raw_hook(unsigned int hook,
 
 static int __net_init ip6table_raw_net_init(struct net *net)
 {
-	/* Register table */
+	struct ip6t_replace *repl = xt_repldata_create(&packet_raw);
+
+	if (repl == NULL)
+		return -ENOMEM;
 	net->ipv6.ip6table_raw =
-		ip6t_register_table(net, &packet_raw, &initial_table.repl);
+		ip6t_register_table(net, &packet_raw, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv6.ip6table_raw))
 		return PTR_ERR(net->ipv6.ip6table_raw);
 	return 0;
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index ef3ad0b..c039db8 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -26,36 +26,6 @@ MODULE_DESCRIPTION("ip6tables security table, for MAC rules");
 				(1 << NF_INET_FORWARD) | \
 				(1 << NF_INET_LOCAL_OUT)
 
-static const struct
-{
-	struct ip6t_replace repl;
-	struct ip6t_standard entries[3];
-	struct ip6t_error term;
-} initial_table __net_initdata = {
-	.repl = {
-		.name = "security",
-		.valid_hooks = SECURITY_VALID_HOOKS,
-		.num_entries = 4,
-		.size = sizeof(struct ip6t_standard) * 3 + sizeof(struct ip6t_error),
-		.hook_entry = {
-			[NF_INET_LOCAL_IN] 	= 0,
-			[NF_INET_FORWARD] 	= sizeof(struct ip6t_standard),
-			[NF_INET_LOCAL_OUT] 	= sizeof(struct ip6t_standard) * 2,
-		},
-		.underflow = {
-			[NF_INET_LOCAL_IN] 	= 0,
-			[NF_INET_FORWARD] 	= sizeof(struct ip6t_standard),
-			[NF_INET_LOCAL_OUT] 	= sizeof(struct ip6t_standard) * 2,
-		},
-	},
-	.entries = {
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
-		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
-	},
-	.term = IP6T_ERROR_INIT,		/* ERROR */
-};
-
 static const struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
@@ -77,9 +47,13 @@ ip6table_security_hook(unsigned int hook,
 
 static int __net_init ip6table_security_net_init(struct net *net)
 {
-	net->ipv6.ip6table_security =
-		ip6t_register_table(net, &security_table, &initial_table.repl);
+	struct ip6t_replace *repl = xt_repldata_create(&security_table);
 
+	if (repl == NULL)
+		return -ENOMEM;
+	net->ipv6.ip6table_security =
+		ip6t_register_table(net, &security_table, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv6.ip6table_security))
 		return PTR_ERR(net->ipv6.ip6table_security);
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 46e0120..eff972f 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -26,7 +26,9 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp.h>
-
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_arp/arp_tables.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
@@ -1155,6 +1157,56 @@ void xt_hook_unlink(const struct xt_table *table, struct nf_hook_ops *ops)
 }
 EXPORT_SYMBOL_GPL(xt_hook_unlink);
 
+/*
+ * Today's hack: quantum tunneling in structs
+ *
+ * 'entries' and 'term' are never anywhere referenced by word in code. In fact,
+ * they serve as the hanging-off data accessed through repl.data[]!
+ */
+#define xt_repldata_mk(type, typ2) \
+	struct { \
+		struct type##_replace repl; \
+		struct type##_standard entries[nhooks]; \
+		struct type##_error term; \
+	} *tbl = kzalloc(sizeof(*tbl), GFP_KERNEL); \
+	if (tbl == NULL) \
+		return NULL; \
+	strncpy(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
+	tbl->term = (struct type##_error)typ2##_ERROR_INIT;  \
+	tbl->repl.valid_hooks = hook_mask; \
+	tbl->repl.num_entries = nhooks + 1; \
+	tbl->repl.size = nhooks * sizeof(struct type##_standard) + \
+	                 sizeof(struct type##_error); \
+	for (; hook_mask != 0; hook_mask >>= 1, ++hooknum) { \
+		if (!(hook_mask & 1)) \
+			continue; \
+		tbl->repl.hook_entry[hooknum] = bytes; \
+		tbl->repl.underflow[hooknum]  = bytes; \
+		tbl->entries[i++] = (struct type##_standard) \
+			typ2##_STANDARD_INIT(NF_ACCEPT); \
+		bytes += sizeof(struct type##_standard); \
+	}
+
+void *xt_repldata_create(const struct xt_table *info)
+{
+	unsigned int hook_mask = info->valid_hooks;
+	unsigned int nhooks = xt_hookmask_bitcount(hook_mask);
+	unsigned int bytes = 0, hooknum = 0, i = 0;
+
+	if (info->af == NFPROTO_IPV6) {
+		xt_repldata_mk(ip6t, IP6T);
+		return tbl;
+	} else if (info->af == NFPROTO_IPV4) {
+		xt_repldata_mk(ipt, IPT);
+		return tbl;
+	} else if (info->af == NFPROTO_ARP) {
+		xt_repldata_mk(arpt, ARPT);
+		return tbl;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(xt_repldata_create);
+
 int xt_proto_init(struct net *net, u_int8_t af)
 {
 #ifdef CONFIG_PROC_FS
-- 
1.6.3.3

