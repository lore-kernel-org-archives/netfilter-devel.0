From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] netfilter: xtables: generate initial table on-demand
Date: Sun,  7 Feb 2010 12:49:44 +0100
Message-ID: <1265543385-7420-5-git-send-email-jengelh@medozas.de>
References: <1265543385-7420-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50124 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab0BGLtv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:49:51 -0500
In-Reply-To: <1265543385-7420-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The static initial tables are pretty large, and after the net
namespace has been instantiated, they just hang around for nothing.
This commit removes them and creates tables on-demand at runtime when
needed.

Size shrinks by 7735 bytes (x86_64).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h        |    1 +
 include/linux/netfilter_arp/arp_tables.h  |    1 +
 include/linux/netfilter_ipv4/ip_tables.h  |    1 +
 include/linux/netfilter_ipv6/ip6_tables.h |    1 +
 net/ipv4/netfilter/arp_tables.c           |    7 ++++
 net/ipv4/netfilter/arptable_filter.c      |   39 ++++--------------------
 net/ipv4/netfilter/ip_tables.c            |    7 ++++
 net/ipv4/netfilter/iptable_filter.c       |   45 ++++++----------------------
 net/ipv4/netfilter/iptable_mangle.c       |   45 ++++-------------------------
 net/ipv4/netfilter/iptable_raw.c          |   35 ++++------------------
 net/ipv4/netfilter/iptable_security.c     |   38 ++++--------------------
 net/ipv4/netfilter/nf_nat_rule.c          |   38 ++++--------------------
 net/ipv6/netfilter/ip6_tables.c           |    7 ++++
 net/ipv6/netfilter/ip6table_filter.c      |   45 ++++++----------------------
 net/ipv6/netfilter/ip6table_mangle.c      |   44 ++++------------------------
 net/ipv6/netfilter/ip6table_raw.c         |   35 ++++------------------
 net/ipv6/netfilter/ip6table_security.c    |   38 ++++--------------------
 net/netfilter/x_tables.c                  |    8 ++++-
 net/netfilter/xt_repldata.h               |   35 ++++++++++++++++++++++
 19 files changed, 135 insertions(+), 335 deletions(-)
 create mode 100644 net/netfilter/xt_repldata.h

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index fdd3342..a6a93ee 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -523,6 +523,7 @@ static inline unsigned long ifname_compare_aligned(const char *_a,
 	return ret;
 }
 
+extern unsigned int xt_hookmask_bitcount(unsigned int);
 extern struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
 extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index f233652..0b33980 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -258,6 +258,7 @@ struct arpt_error {
 	.target.errorname = "ERROR",					       \
 }
 
+extern void *arpt_alloc_initial_table(const struct xt_table *);
 extern struct xt_table *arpt_register_table(struct net *net,
 					    const struct xt_table *table,
 					    const struct arpt_replace *repl);
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 8d1f273..364973b 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -282,6 +282,7 @@ struct ipt_error {
 	.target.errorname = "ERROR",					       \
 }
 
+extern void *ipt_alloc_initial_table(const struct xt_table *);
 extern unsigned int ipt_do_table(struct sk_buff *skb,
 				 unsigned int hook,
 				 const struct net_device *in,
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index d2952d2..8031eb4 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -297,6 +297,7 @@ ip6t_get_target(struct ip6t_entry *e)
 #include <linux/init.h>
 extern void ip6t_init(void) __init;
 
+extern void *ip6t_alloc_initial_table(const struct xt_table *);
 extern struct xt_table *ip6t_register_table(struct net *net,
 					    const struct xt_table *table,
 					    const struct ip6t_replace *repl);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 0663276..0c2ff37 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -27,6 +27,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp/arp_tables.h>
+#include "../../netfilter/xt_repldata.h"
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David S. Miller <davem@redhat.com>");
@@ -58,6 +59,12 @@ do {								\
 #define ARP_NF_ASSERT(x)
 #endif
 
+void *arpt_alloc_initial_table(const struct xt_table *info)
+{
+	return xt_repldata_mk(arpt, ARPT);
+}
+EXPORT_SYMBOL_GPL(arpt_alloc_initial_table);
+
 static inline int arp_devaddr_compare(const struct arpt_devaddr_info *ap,
 				      const char *hdr_addr, int len)
 {
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 51d126a..8bea42e 100644
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
@@ -69,9 +40,13 @@ static struct nf_hook_ops *arpfilter_ops __read_mostly;
 
 static int __net_init arptable_filter_net_init(struct net *net)
 {
-	/* Register table */
+	struct arpt_replace *repl = arpt_alloc_initial_table(&packet_filter);
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
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7fde8f6..99e474a 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -28,6 +28,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/netfilter/nf_log.h>
+#include "../../netfilter/xt_repldata.h"
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
@@ -66,6 +67,12 @@ do {								\
 #define inline
 #endif
 
+void *ipt_alloc_initial_table(const struct xt_table *info)
+{
+	return xt_repldata_mk(ipt, IPT);
+}
+EXPORT_SYMBOL_GPL(ipt_alloc_initial_table);
+
 /*
    We keep a set of rules for each CPU, so we can avoid write-locking
    them in the softirq when updating the counters and therefore
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 6b2b74f..120dad1 100644
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
@@ -87,9 +57,17 @@ module_param(forward, bool, 0000);
 
 static int __net_init iptable_filter_net_init(struct net *net)
 {
-	/* Register table */
+	struct ipt_replace *repl = ipt_alloc_initial_table(&packet_filter);
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
@@ -114,9 +92,6 @@ static int __init iptable_filter_init(void)
 		return -EINVAL;
 	}
 
-	/* Entry 1 is the FORWARD hook */
-	initial_table.entries[1].target.verdict = -forward - 1;
-
 	ret = register_pernet_subsys(&iptable_filter_net_ops);
 	if (ret < 0)
 		return ret;
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 2355a22..6fa1956 100644
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
@@ -134,9 +97,13 @@ static struct nf_hook_ops *mangle_ops __read_mostly;
 
 static int __net_init iptable_mangle_net_init(struct net *net)
 {
-	/* Register table */
+	struct ipt_replace *repl = ipt_alloc_initial_table(&packet_mangler);
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
index 2367953..41dc8ca 100644
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
@@ -67,9 +40,13 @@ static struct nf_hook_ops *rawtable_ops __read_mostly;
 
 static int __net_init iptable_raw_net_init(struct net *net)
 {
-	/* Register table */
+	struct ipt_replace *repl = ipt_alloc_initial_table(&packet_raw);
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
index 2cea93f..2950572 100644
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
@@ -87,9 +57,13 @@ static struct nf_hook_ops *sectbl_ops __read_mostly;
 
 static int __net_init iptable_security_net_init(struct net *net)
 {
-	net->ipv4.iptable_security =
-		ipt_register_table(net, &security_table, &initial_table.repl);
+	struct ipt_replace *repl = ipt_alloc_initial_table(&security_table);
 
+	if (repl == NULL)
+		return -ENOMEM;
+	net->ipv4.iptable_security =
+		ipt_register_table(net, &security_table, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv4.iptable_security))
 		return PTR_ERR(net->ipv4.iptable_security);
 
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 85da34f..5433418 100644
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
+	struct ipt_replace *repl = ipt_alloc_initial_table(&nat_table);
+
+	if (repl == NULL)
+		return -ENOMEM;
+	net->ipv4.nat_table = ipt_register_table(net, &nat_table, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv4.nat_table))
 		return PTR_ERR(net->ipv4.nat_table);
 	return 0;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0376ed6..d89a459 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -29,6 +29,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
 #include <net/netfilter/nf_log.h>
+#include "../../netfilter/xt_repldata.h"
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
@@ -67,6 +68,12 @@ do {								\
 #define inline
 #endif
 
+void *ip6t_alloc_initial_table(const struct xt_table *info)
+{
+	return xt_repldata_mk(ip6t, IP6T);
+}
+EXPORT_SYMBOL_GPL(ip6t_alloc_initial_table);
+
 /*
    We keep a set of rules for each CPU, so we can avoid write-locking
    them in the softirq when updating the counters and therefore
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 1221942..aa687db 100644
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
@@ -80,9 +50,17 @@ module_param(forward, bool, 0000);
 
 static int __net_init ip6table_filter_net_init(struct net *net)
 {
-	/* Register table */
+	struct ip6t_replace *repl = ip6t_alloc_initial_table(&packet_filter);
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
@@ -107,9 +85,6 @@ static int __init ip6table_filter_init(void)
 		return -EINVAL;
 	}
 
-	/* Entry 1 is the FORWARD hook */
-	initial_table.entries[1].target.verdict = -forward - 1;
-
 	ret = register_pernet_subsys(&ip6table_filter_net_ops);
 	if (ret < 0)
 		return ret;
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 95f850f..e67e961 100644
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
@@ -128,9 +92,13 @@ ip6table_mangle_hook(unsigned int hook,
 static struct nf_hook_ops *mangle_ops __read_mostly;
 static int __net_init ip6table_mangle_net_init(struct net *net)
 {
-	/* Register table */
+	struct ip6t_replace *repl = ip6t_alloc_initial_table(&packet_mangler);
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
index 7e40f9c..970399d 100644
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
@@ -60,9 +33,13 @@ static struct nf_hook_ops *rawtable_ops __read_mostly;
 
 static int __net_init ip6table_raw_net_init(struct net *net)
 {
-	/* Register table */
+	struct ip6t_replace *repl = ip6t_alloc_initial_table(&packet_raw);
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
index 0851392..94e3dc8 100644
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
@@ -80,9 +50,13 @@ static struct nf_hook_ops *sectbl_ops __read_mostly;
 
 static int __net_init ip6table_security_net_init(struct net *net)
 {
-	net->ipv6.ip6table_security =
-		ip6t_register_table(net, &security_table, &initial_table.repl);
+	struct ip6t_replace *repl = ip6t_alloc_initial_table(&security_table);
 
+	if (repl == NULL)
+		return -ENOMEM;
+	net->ipv6.ip6table_security =
+		ip6t_register_table(net, &security_table, repl);
+	kfree(repl);
 	if (IS_ERR(net->ipv6.ip6table_security))
 		return PTR_ERR(net->ipv6.ip6table_security);
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 1200dd4..aef0699 100644
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
@@ -1091,7 +1093,8 @@ static const struct file_operations xt_target_ops = {
 
 #endif /* CONFIG_PROC_FS */
 
-static unsigned int xt_hookmask_bitcount(unsigned int mask)
+/* move to asm-generic/bitops/popcnt.h? */
+unsigned int xt_hookmask_bitcount(unsigned int mask)
 {
 	unsigned int bits = 0;
 
@@ -1100,6 +1103,7 @@ static unsigned int xt_hookmask_bitcount(unsigned int mask)
 			++bits;
 	return bits;
 }
+EXPORT_SYMBOL_GPL(xt_hookmask_bitcount);
 
 /**
  * xt_hook_link - set up hooks for a new table
diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
new file mode 100644
index 0000000..182dd2a
--- /dev/null
+++ b/net/netfilter/xt_repldata.h
@@ -0,0 +1,35 @@
+/*
+ * Today's hack: quantum tunneling in structs
+ *
+ * 'entries' and 'term' are never anywhere referenced by word in code. In fact,
+ * they serve as the hanging-off data accessed through repl.data[]!
+ */
+
+#define xt_repldata_mk(type, typ2) ({ \
+	unsigned int hook_mask = info->valid_hooks; \
+	unsigned int nhooks = xt_hookmask_bitcount(hook_mask); \
+	unsigned int bytes = 0, hooknum = 0, i = 0; \
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
+	} \
+	tbl; \
+})
-- 
1.6.6.1

