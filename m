From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 4/8] netfilter: xtables: don't register table hooks in namespace at init time
Date: Fri,  2 Oct 2015 13:49:13 +0200
Message-ID: <1443786557-21315-5-git-send-email-fw@strlen.de>
References: <1443786557-21315-1-git-send-email-fw@strlen.de>
Cc: ebiederm@xmission.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50307 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbbJBLta (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Oct 2015 07:49:30 -0400
In-Reply-To: <1443786557-21315-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

delay hook registration until the table is being requested inside a
namespace.

Historically, a particular table (iptables mangle, ip6tables filter,
etc) was registered on module load.

When netns support was added to iptables only the ip/ip6tables ruleset
was made namespace aware, not the actual hook points.

This means f.e. that when ipt_filter table/module is loaded on a system,
then each namespace on that system has an (empty) iptables filter ruleset.

In other words, if a namespace sends a packet, such skb is 'caught'
by netfilter machinery and fed to hooking points for that table
(i.e. INPUT, FORWARD, etc).

Thanks to Eric Biederman, hooks are no longer global, but per namespace.

This means that we can avoid allocation of empty ruleset in a namespace
and defer hook registration until we need the functionality.

We register a tables hook entry points ONLY in the initial namespace.
When an iptables get/setockopt is issued inside a given namespace,
we check if the table is found in the per-namespace list.

If not, we attempt to find it in the initial namespace, and,
if found, create an empty default table in the requesting namespace
and register the needed hooks.

Hook points are destroyed only once namespace is deleted, there is no
'usage count' (it makes no sense since there is no 'remove table'
operation in xtables api).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h     | 10 ++++-
 net/ipv4/netfilter/arptable_filter.c   | 39 +++++++++++-------
 net/ipv4/netfilter/iptable_filter.c    | 65 ++++++++++++++++++++++--------
 net/ipv4/netfilter/iptable_mangle.c    | 50 ++++++++++++++++++-----
 net/ipv4/netfilter/iptable_nat.c       | 51 ++++++++++++++++--------
 net/ipv4/netfilter/iptable_raw.c       | 50 ++++++++++++++++++-----
 net/ipv4/netfilter/iptable_security.c  | 52 +++++++++++++++++-------
 net/ipv6/netfilter/ip6table_filter.c   | 54 ++++++++++++++++++-------
 net/ipv6/netfilter/ip6table_mangle.c   | 53 +++++++++++++++++-------
 net/ipv6/netfilter/ip6table_nat.c      | 51 ++++++++++++++++--------
 net/ipv6/netfilter/ip6table_raw.c      | 54 ++++++++++++++++++-------
 net/ipv6/netfilter/ip6table_security.c | 53 +++++++++++++++++-------
 net/netfilter/x_tables.c               | 73 +++++++++++++++++++++++++---------
 13 files changed, 475 insertions(+), 180 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index c557741..7e0920e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -200,6 +200,9 @@ struct xt_table {
 	u_int8_t af;		/* address/protocol family */
 	int priority;		/* hook order */
 
+	/* called when table is needed in the given netns */
+	int (*table_init)(struct net *net);
+
 	/* A unique name... */
 	const char name[XT_TABLE_MAXNAMELEN];
 };
@@ -408,8 +411,11 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 	return cnt;
 }
 
-struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
-void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
+struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
+int xt_hook_link_net(struct net *, const struct xt_table *,
+		     const struct nf_hook_ops *);
+void xt_hook_unlink_net(struct net *net, const struct xt_table *,
+			const struct nf_hook_ops *);
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 1897ee1..c77832e 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -17,12 +17,15 @@ MODULE_DESCRIPTION("arptables filter table");
 #define FILTER_VALID_HOOKS ((1 << NF_ARP_IN) | (1 << NF_ARP_OUT) | \
 			   (1 << NF_ARP_FORWARD))
 
+static int __net_init arptable_filter_table_init(struct net *net);
+
 static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_ARP,
 	.priority	= NF_IP_PRI_FILTER,
+	.table_init	= arptable_filter_table_init,
 };
 
 /* The work comes in here from netfilter.c */
@@ -35,26 +38,35 @@ arptable_filter_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_hook_ops *arpfilter_ops __read_mostly;
 
-static int __net_init arptable_filter_net_init(struct net *net)
+static int __net_init arptable_filter_table_init(struct net *net)
 {
 	struct arpt_replace *repl;
-	
+	int err = 0;
+
+	if (net->ipv4.arptable_filter)
+		return 0;
+
 	repl = arpt_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
 		return -ENOMEM;
 	net->ipv4.arptable_filter =
 		arpt_register_table(net, &packet_filter, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.arptable_filter);
+
+	if (PTR_ERR_OR_ZERO(net->ipv4.arptable_filter)) {
+		err = PTR_ERR(net->ipv4.arptable_filter);
+		net->ipv4.arptable_filter = NULL;
+	}
+	return err;
 }
 
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
-	arpt_unregister_table(net->ipv4.arptable_filter);
+	if (net->ipv4.arptable_filter)
+		arpt_unregister_table(net->ipv4.arptable_filter);
 }
 
 static struct pernet_operations arptable_filter_net_ops = {
-	.init = arptable_filter_net_init,
 	.exit = arptable_filter_net_exit,
 };
 
@@ -62,26 +74,23 @@ static int __init arptable_filter_init(void)
 {
 	int ret;
 
+	arpfilter_ops = xt_hook_ops_alloc(&packet_filter, arptable_filter_hook);
+	if (IS_ERR(arpfilter_ops))
+		return PTR_ERR(arpfilter_ops);
+
 	ret = register_pernet_subsys(&arptable_filter_net_ops);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(arpfilter_ops);
 		return ret;
-
-	arpfilter_ops = xt_hook_link(&packet_filter, arptable_filter_hook);
-	if (IS_ERR(arpfilter_ops)) {
-		ret = PTR_ERR(arpfilter_ops);
-		goto cleanup_table;
 	}
-	return ret;
 
-cleanup_table:
-	unregister_pernet_subsys(&arptable_filter_net_ops);
 	return ret;
 }
 
 static void __exit arptable_filter_fini(void)
 {
-	xt_hook_unlink(&packet_filter, arpfilter_ops);
 	unregister_pernet_subsys(&arptable_filter_net_ops);
+	kfree(arpfilter_ops);
 }
 
 module_init(arptable_filter_init);
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 397ef2d..18d559f 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -24,12 +24,21 @@ MODULE_DESCRIPTION("iptables filter table");
 			    (1 << NF_INET_FORWARD) | \
 			    (1 << NF_INET_LOCAL_OUT))
 
+static struct nf_hook_ops *filter_ops __read_mostly;
+
+/* Default to forward because I got too much mail already. */
+static bool forward __read_mostly = true;
+module_param(forward, bool, 0000);
+
+static int __net_init iptable_filter_table_init(struct net *net);
+
 static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
 	.priority	= NF_IP_PRI_FILTER,
+	.table_init	= iptable_filter_table_init,
 };
 
 static unsigned int
@@ -45,15 +54,13 @@ iptable_filter_hook(void *priv, struct sk_buff *skb,
 	return ipt_do_table(skb, state, state->net->ipv4.iptable_filter);
 }
 
-static struct nf_hook_ops *filter_ops __read_mostly;
-
-/* Default to forward because I got too much mail already. */
-static bool forward = true;
-module_param(forward, bool, 0000);
-
-static int __net_init iptable_filter_net_init(struct net *net)
+static int __net_init iptable_filter_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
+	int err;
+
+	if (net->ipv4.iptable_filter)
+		return 0;
 
 	repl = ipt_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
@@ -65,12 +72,37 @@ static int __net_init iptable_filter_net_init(struct net *net)
 	net->ipv4.iptable_filter =
 		ipt_register_table(net, &packet_filter, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.iptable_filter);
+	err = PTR_ERR_OR_ZERO(net->ipv4.iptable_filter);
+	if (err)
+		goto err;
+
+	err = xt_hook_link_net(net, net->ipv4.iptable_filter, filter_ops);
+	if (err) {
+		ipt_unregister_table(net, net->ipv4.iptable_filter);
+		goto err;
+	}
+	return err;
+ err:
+	net->ipv4.iptable_filter = NULL;
+	return err;
+}
+
+static int __net_init iptable_filter_net_init(struct net *net)
+{
+	if (net == &init_net || !forward)
+		return iptable_filter_table_init(net);
+
+	return 0;
 }
 
 static void __net_exit iptable_filter_net_exit(struct net *net)
 {
+	if (!net->ipv4.iptable_filter)
+		return;
+
+	xt_hook_unlink_net(net, net->ipv4.iptable_filter, filter_ops);
 	ipt_unregister_table(net, net->ipv4.iptable_filter);
+	net->ipv4.iptable_filter = NULL;
 }
 
 static struct pernet_operations iptable_filter_net_ops = {
@@ -82,15 +114,16 @@ static int __init iptable_filter_init(void)
 {
 	int ret;
 
-	ret = register_pernet_subsys(&iptable_filter_net_ops);
-	if (ret < 0)
-		return ret;
-
-	/* Register hooks */
-	filter_ops = xt_hook_link(&packet_filter, iptable_filter_hook);
+	filter_ops = xt_hook_ops_alloc(&packet_filter, iptable_filter_hook);
 	if (IS_ERR(filter_ops)) {
 		ret = PTR_ERR(filter_ops);
-		unregister_pernet_subsys(&iptable_filter_net_ops);
+		return ret;
+	}
+
+	ret = register_pernet_subsys(&iptable_filter_net_ops);
+	if (ret < 0) {
+		kfree(filter_ops);
+		return ret;
 	}
 
 	return ret;
@@ -98,8 +131,8 @@ static int __init iptable_filter_init(void)
 
 static void __exit iptable_filter_fini(void)
 {
-	xt_hook_unlink(&packet_filter, filter_ops);
 	unregister_pernet_subsys(&iptable_filter_net_ops);
+	kfree(filter_ops);
 }
 
 module_init(iptable_filter_init);
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index ba5d392..0824dce 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -28,12 +28,15 @@ MODULE_DESCRIPTION("iptables mangle table");
 			    (1 << NF_INET_LOCAL_OUT) | \
 			    (1 << NF_INET_POST_ROUTING))
 
+static int __net_init iptable_mangle_table_init(struct net *net);
+
 static const struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
 	.priority	= NF_IP_PRI_MANGLE,
+	.table_init	= iptable_mangle_table_init,
 };
 
 static unsigned int
@@ -92,10 +95,13 @@ iptable_mangle_hook(void *priv,
 }
 
 static struct nf_hook_ops *mangle_ops __read_mostly;
-
-static int __net_init iptable_mangle_net_init(struct net *net)
+static int __net_init iptable_mangle_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
+	int ret;
+
+	if (net->ipv4.iptable_mangle)
+		return 0;
 
 	repl = ipt_alloc_initial_table(&packet_mangler);
 	if (repl == NULL)
@@ -103,16 +109,33 @@ static int __net_init iptable_mangle_net_init(struct net *net)
 	net->ipv4.iptable_mangle =
 		ipt_register_table(net, &packet_mangler, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.iptable_mangle);
+	ret = PTR_ERR_OR_ZERO(net->ipv4.iptable_mangle);
+	if (ret < 0)
+		goto err;
+	/* Register hooks */
+	ret = xt_hook_link_net(net, net->ipv4.iptable_mangle, mangle_ops);
+	if (ret) {
+		ipt_unregister_table(net, net->ipv4.iptable_mangle);
+		goto err;
+	}
+
+	return ret;
+ err:
+	net->ipv4.iptable_mangle = NULL;
+	return ret;
 }
 
 static void __net_exit iptable_mangle_net_exit(struct net *net)
 {
+	if (!net->ipv4.iptable_mangle)
+		return;
+
+	xt_hook_unlink_net(net, net->ipv4.iptable_mangle, mangle_ops);
 	ipt_unregister_table(net, net->ipv4.iptable_mangle);
+	net->ipv4.iptable_mangle = NULL;
 }
 
 static struct pernet_operations iptable_mangle_net_ops = {
-	.init = iptable_mangle_net_init,
 	.exit = iptable_mangle_net_exit,
 };
 
@@ -120,15 +143,22 @@ static int __init iptable_mangle_init(void)
 {
 	int ret;
 
+	mangle_ops = xt_hook_ops_alloc(&packet_mangler, iptable_mangle_hook);
+	if (IS_ERR(mangle_ops)) {
+		ret = PTR_ERR(mangle_ops);
+		return ret;
+	}
+
 	ret = register_pernet_subsys(&iptable_mangle_net_ops);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(mangle_ops);
 		return ret;
+	}
 
-	/* Register hooks */
-	mangle_ops = xt_hook_link(&packet_mangler, iptable_mangle_hook);
-	if (IS_ERR(mangle_ops)) {
-		ret = PTR_ERR(mangle_ops);
+	ret = iptable_mangle_table_init(&init_net);
+	if (ret) {
 		unregister_pernet_subsys(&iptable_mangle_net_ops);
+		kfree(mangle_ops);
 	}
 
 	return ret;
@@ -136,8 +166,8 @@ static int __init iptable_mangle_init(void)
 
 static void __exit iptable_mangle_fini(void)
 {
-	xt_hook_unlink(&packet_mangler, mangle_ops);
 	unregister_pernet_subsys(&iptable_mangle_net_ops);
+	kfree(mangle_ops);
 }
 
 module_init(iptable_mangle_init);
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 3a2e4d8..4e0cc89 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -18,6 +18,8 @@
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_l3proto.h>
 
+static int __net_init iptable_nat_table_init(struct net *net);
+
 static const struct xt_table nf_nat_ipv4_table = {
 	.name		= "nat",
 	.valid_hooks	= (1 << NF_INET_PRE_ROUTING) |
@@ -26,6 +28,7 @@ static const struct xt_table nf_nat_ipv4_table = {
 			  (1 << NF_INET_LOCAL_IN),
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
+	.table_init	= iptable_nat_table_init,
 };
 
 static unsigned int iptable_nat_do_chain(void *priv,
@@ -99,50 +102,64 @@ static struct nf_hook_ops nf_nat_ipv4_ops[] __read_mostly = {
 	},
 };
 
-static int __net_init iptable_nat_net_init(struct net *net)
+static int __net_init iptable_nat_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
+	int ret;
+
+	if (net->ipv4.nat_table)
+		return 0;
 
 	repl = ipt_alloc_initial_table(&nf_nat_ipv4_table);
 	if (repl == NULL)
 		return -ENOMEM;
 	net->ipv4.nat_table = ipt_register_table(net, &nf_nat_ipv4_table, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.nat_table);
+	ret = PTR_ERR_OR_ZERO(net->ipv4.nat_table);
+	if (ret < 0)
+		goto err;
+
+	ret = nf_register_net_hooks(net, nf_nat_ipv4_ops,
+				    ARRAY_SIZE(nf_nat_ipv4_ops));
+	if (ret < 0) {
+		ipt_unregister_table(net, net->ipv4.nat_table);
+		goto err;
+	}
+	return ret;
+ err:
+	net->ipv4.nat_table = NULL;
+	return ret;
 }
 
 static void __net_exit iptable_nat_net_exit(struct net *net)
 {
+	if (!net->ipv4.nat_table)
+		return;
+	nf_unregister_net_hooks(net, nf_nat_ipv4_ops,
+				ARRAY_SIZE(nf_nat_ipv4_ops));
 	ipt_unregister_table(net, net->ipv4.nat_table);
+	net->ipv4.nat_table = NULL;
 }
 
 static struct pernet_operations iptable_nat_net_ops = {
-	.init	= iptable_nat_net_init,
 	.exit	= iptable_nat_net_exit,
 };
 
 static int __init iptable_nat_init(void)
 {
-	int err;
+	int ret = register_pernet_subsys(&iptable_nat_net_ops);
 
-	err = register_pernet_subsys(&iptable_nat_net_ops);
-	if (err < 0)
-		goto err1;
+	if (ret)
+		return ret;
 
-	err = nf_register_hooks(nf_nat_ipv4_ops, ARRAY_SIZE(nf_nat_ipv4_ops));
-	if (err < 0)
-		goto err2;
-	return 0;
-
-err2:
-	unregister_pernet_subsys(&iptable_nat_net_ops);
-err1:
-	return err;
+	ret = iptable_nat_table_init(&init_net);
+	if (ret)
+		unregister_pernet_subsys(&iptable_nat_net_ops);
+	return ret;
 }
 
 static void __exit iptable_nat_exit(void)
 {
-	nf_unregister_hooks(nf_nat_ipv4_ops, ARRAY_SIZE(nf_nat_ipv4_ops));
 	unregister_pernet_subsys(&iptable_nat_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 1ba0281..a72e925 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -10,12 +10,17 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
 
+static struct nf_hook_ops *rawtable_ops __read_mostly;
+
+static int __net_init iptable_raw_table_init(struct net *net);
+
 static const struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks =  RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
 	.af = NFPROTO_IPV4,
 	.priority = NF_IP_PRI_RAW,
+	.table_init = iptable_raw_table_init,
 };
 
 /* The work comes in here from netfilter.c. */
@@ -32,11 +37,13 @@ iptable_raw_hook(void *priv, struct sk_buff *skb,
 	return ipt_do_table(skb, state, state->net->ipv4.iptable_raw);
 }
 
-static struct nf_hook_ops *rawtable_ops __read_mostly;
-
-static int __net_init iptable_raw_net_init(struct net *net)
+static int __net_init iptable_raw_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
+	int ret;
+
+	if (net->ipv4.iptable_raw)
+		return 0;
 
 	repl = ipt_alloc_initial_table(&packet_raw);
 	if (repl == NULL)
@@ -44,16 +51,32 @@ static int __net_init iptable_raw_net_init(struct net *net)
 	net->ipv4.iptable_raw =
 		ipt_register_table(net, &packet_raw, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.iptable_raw);
+	ret = PTR_ERR_OR_ZERO(net->ipv4.iptable_raw);
+	if (ret < 0)
+		goto err;
+	/* Register hooks */
+	ret = xt_hook_link_net(net, net->ipv4.iptable_raw, rawtable_ops);
+	if (ret) {
+		ipt_unregister_table(net, net->ipv4.iptable_raw);
+		goto err;
+	}
+	return ret;
+ err:
+	net->ipv4.iptable_raw = NULL;
+	return ret;
 }
 
 static void __net_exit iptable_raw_net_exit(struct net *net)
 {
+	if (!net->ipv4.iptable_raw)
+		return;
+
+	xt_hook_unlink_net(net, net->ipv4.iptable_raw, rawtable_ops);
 	ipt_unregister_table(net, net->ipv4.iptable_raw);
+	net->ipv4.iptable_raw = NULL;
 }
 
 static struct pernet_operations iptable_raw_net_ops = {
-	.init = iptable_raw_net_init,
 	.exit = iptable_raw_net_exit,
 };
 
@@ -61,15 +84,20 @@ static int __init iptable_raw_init(void)
 {
 	int ret;
 
+	rawtable_ops = xt_hook_ops_alloc(&packet_raw, iptable_raw_hook);
+	if (IS_ERR(rawtable_ops))
+		return PTR_ERR(rawtable_ops);
+
 	ret = register_pernet_subsys(&iptable_raw_net_ops);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(rawtable_ops);
 		return ret;
+	}
 
-	/* Register hooks */
-	rawtable_ops = xt_hook_link(&packet_raw, iptable_raw_hook);
-	if (IS_ERR(rawtable_ops)) {
-		ret = PTR_ERR(rawtable_ops);
+	ret = iptable_raw_table_init(&init_net);
+	if (ret) {
 		unregister_pernet_subsys(&iptable_raw_net_ops);
+		kfree(rawtable_ops);
 	}
 
 	return ret;
@@ -77,8 +105,8 @@ static int __init iptable_raw_init(void)
 
 static void __exit iptable_raw_fini(void)
 {
-	xt_hook_unlink(&packet_raw, rawtable_ops);
 	unregister_pernet_subsys(&iptable_raw_net_ops);
+	kfree(rawtable_ops);
 }
 
 module_init(iptable_raw_init);
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index f534e2f..03b3d0f 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -28,12 +28,15 @@ MODULE_DESCRIPTION("iptables security table, for MAC rules");
 				(1 << NF_INET_FORWARD) | \
 				(1 << NF_INET_LOCAL_OUT)
 
+static int __net_init iptable_security_table_init(struct net *net);
+
 static const struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
 	.priority	= NF_IP_PRI_SECURITY,
+	.table_init	= iptable_security_table_init,
 };
 
 static unsigned int
@@ -51,9 +54,13 @@ iptable_security_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
 
-static int __net_init iptable_security_net_init(struct net *net)
+static int __net_init iptable_security_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
+	int ret;
+
+	if (net->ipv4.iptable_security)
+		return 0;
 
 	repl = ipt_alloc_initial_table(&security_table);
 	if (repl == NULL)
@@ -61,16 +68,32 @@ static int __net_init iptable_security_net_init(struct net *net)
 	net->ipv4.iptable_security =
 		ipt_register_table(net, &security_table, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.iptable_security);
+	ret = PTR_ERR_OR_ZERO(net->ipv4.iptable_security);
+	if (ret < 0)
+		goto err;
+	/* Register hooks */
+	ret = xt_hook_link_net(net, net->ipv4.iptable_security, sectbl_ops);
+	if (ret) {
+		ipt_unregister_table(net, net->ipv4.iptable_security);
+		goto err;
+	}
+	return ret;
+ err:
+	net->ipv4.iptable_security = NULL;
+	return ret;
 }
 
 static void __net_exit iptable_security_net_exit(struct net *net)
 {
+	if (!net->ipv4.iptable_security)
+		return;
+
+	xt_hook_unlink_net(net, net->ipv4.iptable_security, sectbl_ops);
 	ipt_unregister_table(net, net->ipv4.iptable_security);
+	net->ipv4.iptable_security = NULL;
 }
 
 static struct pernet_operations iptable_security_net_ops = {
-	.init = iptable_security_net_init,
 	.exit = iptable_security_net_exit,
 };
 
@@ -78,28 +101,29 @@ static int __init iptable_security_init(void)
 {
 	int ret;
 
+	sectbl_ops = xt_hook_ops_alloc(&security_table, iptable_security_hook);
+	if (IS_ERR(sectbl_ops))
+		return PTR_ERR(sectbl_ops);
+
 	ret = register_pernet_subsys(&iptable_security_net_ops);
-        if (ret < 0)
+	if (ret < 0) {
+		kfree(sectbl_ops);
 		return ret;
-
-	sectbl_ops = xt_hook_link(&security_table, iptable_security_hook);
-	if (IS_ERR(sectbl_ops)) {
-		ret = PTR_ERR(sectbl_ops);
-		goto cleanup_table;
 	}
 
-	return ret;
+	ret = iptable_security_table_init(&init_net);
+	if (ret) {
+		unregister_pernet_subsys(&iptable_security_net_ops);
+		kfree(sectbl_ops);
+	}
 
-cleanup_table:
-	unregister_pernet_subsys(&iptable_security_net_ops);
 	return ret;
 }
 
 static void __exit iptable_security_fini(void)
 {
-	xt_hook_unlink(&security_table, sectbl_ops);
 	unregister_pernet_subsys(&iptable_security_net_ops);
+	kfree(sectbl_ops);
 }
-
 module_init(iptable_security_init);
 module_exit(iptable_security_fini);
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 8b277b9..dd77384 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -22,12 +22,15 @@ MODULE_DESCRIPTION("ip6tables filter table");
 			    (1 << NF_INET_FORWARD) | \
 			    (1 << NF_INET_LOCAL_OUT))
 
+static int __net_init ip6table_filter_table_init(struct net *net);
+
 static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
 	.priority	= NF_IP6_PRI_FILTER,
+	.table_init	= ip6table_filter_table_init,
 };
 
 /* The work comes in here from netfilter.c. */
@@ -44,9 +47,13 @@ static struct nf_hook_ops *filter_ops __read_mostly;
 static bool forward = true;
 module_param(forward, bool, 0000);
 
-static int __net_init ip6table_filter_net_init(struct net *net)
+static int __net_init ip6table_filter_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	int err;
+
+	if (net->ipv6.ip6table_filter)
+		return 0;
 
 	repl = ip6t_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
@@ -58,12 +65,36 @@ static int __net_init ip6table_filter_net_init(struct net *net)
 	net->ipv6.ip6table_filter =
 		ip6t_register_table(net, &packet_filter, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_filter);
+	err = PTR_ERR_OR_ZERO(net->ipv6.ip6table_filter);
+	if (err)
+		goto err;
+
+	err = xt_hook_link_net(net, net->ipv6.ip6table_filter, filter_ops);
+	if (err) {
+		ip6t_unregister_table(net, net->ipv6.ip6table_filter);
+		goto err;
+	}
+	return err;
+ err:
+	net->ipv6.ip6table_filter = NULL;
+	return err;
+}
+
+static int __net_init ip6table_filter_net_init(struct net *net)
+{
+	if (net == &init_net || !forward)
+		return ip6table_filter_table_init(net);
+
+	return 0;
 }
 
 static void __net_exit ip6table_filter_net_exit(struct net *net)
 {
+	if (!net->ipv6.ip6table_filter)
+		return;
+
 	ip6t_unregister_table(net, net->ipv6.ip6table_filter);
+	net->ipv6.ip6table_filter = NULL;
 }
 
 static struct pernet_operations ip6table_filter_net_ops = {
@@ -75,28 +106,21 @@ static int __init ip6table_filter_init(void)
 {
 	int ret;
 
+	filter_ops = xt_hook_ops_alloc(&packet_filter, ip6table_filter_hook);
+	if (IS_ERR(filter_ops))
+		return PTR_ERR(filter_ops);
+
 	ret = register_pernet_subsys(&ip6table_filter_net_ops);
 	if (ret < 0)
-		return ret;
-
-	/* Register hooks */
-	filter_ops = xt_hook_link(&packet_filter, ip6table_filter_hook);
-	if (IS_ERR(filter_ops)) {
-		ret = PTR_ERR(filter_ops);
-		goto cleanup_table;
-	}
-
-	return ret;
+		kfree(filter_ops);
 
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_filter_net_ops);
 	return ret;
 }
 
 static void __exit ip6table_filter_fini(void)
 {
-	xt_hook_unlink(&packet_filter, filter_ops);
 	unregister_pernet_subsys(&ip6table_filter_net_ops);
+	kfree(filter_ops);
 }
 
 module_init(ip6table_filter_init);
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index abe278b..22cc8db 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -23,12 +23,14 @@ MODULE_DESCRIPTION("ip6tables mangle table");
 			    (1 << NF_INET_LOCAL_OUT) | \
 			    (1 << NF_INET_POST_ROUTING))
 
+static int __net_init ip6table_mangle_table_init(struct net *net);
 static const struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
 	.priority	= NF_IP6_PRI_MANGLE,
+	.table_init	= ip6table_mangle_table_init,
 };
 
 static unsigned int
@@ -88,9 +90,13 @@ ip6table_mangle_hook(void *priv, struct sk_buff *skb,
 }
 
 static struct nf_hook_ops *mangle_ops __read_mostly;
-static int __net_init ip6table_mangle_net_init(struct net *net)
+static int __net_init ip6table_mangle_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	int ret;
+
+	if (net->ipv6.ip6table_mangle)
+		return 0;
 
 	repl = ip6t_alloc_initial_table(&packet_mangler);
 	if (repl == NULL)
@@ -98,16 +104,33 @@ static int __net_init ip6table_mangle_net_init(struct net *net)
 	net->ipv6.ip6table_mangle =
 		ip6t_register_table(net, &packet_mangler, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_mangle);
+	ret = PTR_ERR_OR_ZERO(net->ipv6.ip6table_mangle);
+	if (ret < 0)
+		goto err;
+
+	ret = xt_hook_link_net(net, net->ipv6.ip6table_mangle, mangle_ops);
+	if (ret) {
+		ip6t_unregister_table(net, net->ipv6.ip6table_mangle);
+		goto err;
+	}
+
+	return ret;
+ err:
+	net->ipv6.ip6table_mangle = NULL;
+	return ret;
 }
 
 static void __net_exit ip6table_mangle_net_exit(struct net *net)
 {
+	if (!net->ipv6.ip6table_mangle)
+		return;
+
+	xt_hook_unlink_net(net, net->ipv6.ip6table_mangle, mangle_ops);
 	ip6t_unregister_table(net, net->ipv6.ip6table_mangle);
+	net->ipv6.ip6table_mangle = NULL;
 }
 
 static struct pernet_operations ip6table_mangle_net_ops = {
-	.init = ip6table_mangle_net_init,
 	.exit = ip6table_mangle_net_exit,
 };
 
@@ -115,28 +138,28 @@ static int __init ip6table_mangle_init(void)
 {
 	int ret;
 
+	mangle_ops = xt_hook_ops_alloc(&packet_mangler, ip6table_mangle_hook);
+	if (IS_ERR(mangle_ops))
+		return PTR_ERR(mangle_ops);
+
 	ret = register_pernet_subsys(&ip6table_mangle_net_ops);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(mangle_ops);
 		return ret;
-
-	/* Register hooks */
-	mangle_ops = xt_hook_link(&packet_mangler, ip6table_mangle_hook);
-	if (IS_ERR(mangle_ops)) {
-		ret = PTR_ERR(mangle_ops);
-		goto cleanup_table;
 	}
 
-	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_mangle_net_ops);
+	ret = ip6table_mangle_table_init(&init_net);
+	if (ret) {
+		unregister_pernet_subsys(&ip6table_mangle_net_ops);
+		kfree(mangle_ops);
+	}
 	return ret;
 }
 
 static void __exit ip6table_mangle_fini(void)
 {
-	xt_hook_unlink(&packet_mangler, mangle_ops);
 	unregister_pernet_subsys(&ip6table_mangle_net_ops);
+	kfree(mangle_ops);
 }
 
 module_init(ip6table_mangle_init);
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index abea175..ee6a3fe 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -20,6 +20,8 @@
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_l3proto.h>
 
+static int __net_init ip6table_nat_table_init(struct net *net);
+
 static const struct xt_table nf_nat_ipv6_table = {
 	.name		= "nat",
 	.valid_hooks	= (1 << NF_INET_PRE_ROUTING) |
@@ -28,6 +30,7 @@ static const struct xt_table nf_nat_ipv6_table = {
 			  (1 << NF_INET_LOCAL_IN),
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
+	.table_init	= ip6table_nat_table_init,
 };
 
 static unsigned int ip6table_nat_do_chain(void *priv,
@@ -101,50 +104,64 @@ static struct nf_hook_ops nf_nat_ipv6_ops[] __read_mostly = {
 	},
 };
 
-static int __net_init ip6table_nat_net_init(struct net *net)
+static int __net_init ip6table_nat_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	int ret;
+
+	if (net->ipv6.ip6table_nat)
+		return 0;
 
 	repl = ip6t_alloc_initial_table(&nf_nat_ipv6_table);
 	if (repl == NULL)
 		return -ENOMEM;
 	net->ipv6.ip6table_nat = ip6t_register_table(net, &nf_nat_ipv6_table, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_nat);
+	ret = PTR_ERR_OR_ZERO(net->ipv6.ip6table_nat);
+	if (ret < 0)
+		goto err;
+
+	ret = nf_register_net_hooks(net, nf_nat_ipv6_ops,
+				    ARRAY_SIZE(nf_nat_ipv6_ops));
+	if (ret < 0) {
+		ip6t_unregister_table(net, net->ipv6.ip6table_nat);
+		goto err;
+	}
+	return ret;
+ err:
+	net->ipv6.ip6table_nat = NULL;
+	return ret;
 }
 
 static void __net_exit ip6table_nat_net_exit(struct net *net)
 {
+	if (!net->ipv6.ip6table_nat)
+		return;
+	nf_unregister_net_hooks(net, nf_nat_ipv6_ops,
+				ARRAY_SIZE(nf_nat_ipv6_ops));
 	ip6t_unregister_table(net, net->ipv6.ip6table_nat);
+	net->ipv6.ip6table_nat = NULL;
 }
 
 static struct pernet_operations ip6table_nat_net_ops = {
-	.init	= ip6table_nat_net_init,
 	.exit	= ip6table_nat_net_exit,
 };
 
 static int __init ip6table_nat_init(void)
 {
-	int err;
+	int ret = register_pernet_subsys(&ip6table_nat_net_ops);
 
-	err = register_pernet_subsys(&ip6table_nat_net_ops);
-	if (err < 0)
-		goto err1;
+	if (ret)
+		return ret;
 
-	err = nf_register_hooks(nf_nat_ipv6_ops, ARRAY_SIZE(nf_nat_ipv6_ops));
-	if (err < 0)
-		goto err2;
-	return 0;
-
-err2:
-	unregister_pernet_subsys(&ip6table_nat_net_ops);
-err1:
-	return err;
+	ret = ip6table_nat_table_init(&init_net);
+	if (ret)
+		unregister_pernet_subsys(&ip6table_nat_net_ops);
+	return ret;
 }
 
 static void __exit ip6table_nat_exit(void)
 {
-	nf_unregister_hooks(nf_nat_ipv6_ops, ARRAY_SIZE(nf_nat_ipv6_ops));
 	unregister_pernet_subsys(&ip6table_nat_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 9021963..dc6255f 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -9,12 +9,15 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
 
+static int __net_init ip6table_raw_table_init(struct net *net);
+
 static const struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks = RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
 	.af = NFPROTO_IPV6,
 	.priority = NF_IP6_PRI_RAW,
+	.table_init = ip6table_raw_table_init,
 };
 
 /* The work comes in here from netfilter.c. */
@@ -27,9 +30,13 @@ ip6table_raw_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
 
-static int __net_init ip6table_raw_net_init(struct net *net)
+static int __net_init ip6table_raw_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	int ret;
+
+	if (net->ipv6.ip6table_raw)
+		return 0;
 
 	repl = ip6t_alloc_initial_table(&packet_raw);
 	if (repl == NULL)
@@ -37,16 +44,32 @@ static int __net_init ip6table_raw_net_init(struct net *net)
 	net->ipv6.ip6table_raw =
 		ip6t_register_table(net, &packet_raw, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_raw);
+	ret = PTR_ERR_OR_ZERO(net->ipv6.ip6table_raw);
+	if (ret < 0)
+		goto err;
+	ret = xt_hook_link_net(net, net->ipv6.ip6table_raw, rawtable_ops);
+	if (ret) {
+		ip6t_unregister_table(net, net->ipv6.ip6table_raw);
+		goto err;
+	}
+
+	return ret;
+ err:
+	net->ipv6.ip6table_raw = NULL;
+	return ret;
 }
 
 static void __net_exit ip6table_raw_net_exit(struct net *net)
 {
+	if (!net->ipv6.ip6table_raw)
+		return;
+
+	xt_hook_unlink_net(net, net->ipv6.ip6table_raw, rawtable_ops);
 	ip6t_unregister_table(net, net->ipv6.ip6table_raw);
+	net->ipv6.ip6table_raw = NULL;
 }
 
 static struct pernet_operations ip6table_raw_net_ops = {
-	.init = ip6table_raw_net_init,
 	.exit = ip6table_raw_net_exit,
 };
 
@@ -54,28 +77,29 @@ static int __init ip6table_raw_init(void)
 {
 	int ret;
 
+	/* Register hooks */
+	rawtable_ops = xt_hook_ops_alloc(&packet_raw, ip6table_raw_hook);
+	if (IS_ERR(rawtable_ops))
+		return PTR_ERR(rawtable_ops);
+
 	ret = register_pernet_subsys(&ip6table_raw_net_ops);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(rawtable_ops);
 		return ret;
-
-	/* Register hooks */
-	rawtable_ops = xt_hook_link(&packet_raw, ip6table_raw_hook);
-	if (IS_ERR(rawtable_ops)) {
-		ret = PTR_ERR(rawtable_ops);
-		goto cleanup_table;
 	}
 
-	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_raw_net_ops);
+	ret = ip6table_raw_table_init(&init_net);
+	if (ret) {
+		unregister_pernet_subsys(&ip6table_raw_net_ops);
+		kfree(rawtable_ops);
+	}
 	return ret;
 }
 
 static void __exit ip6table_raw_fini(void)
 {
-	xt_hook_unlink(&packet_raw, rawtable_ops);
 	unregister_pernet_subsys(&ip6table_raw_net_ops);
+	kfree(rawtable_ops);
 }
 
 module_init(ip6table_raw_init);
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 0d856fe..b4ea40d 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -27,12 +27,15 @@ MODULE_DESCRIPTION("ip6tables security table, for MAC rules");
 				(1 << NF_INET_FORWARD) | \
 				(1 << NF_INET_LOCAL_OUT)
 
+static int __net_init ip6table_security_table_init(struct net *net);
+
 static const struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
 	.priority	= NF_IP6_PRI_SECURITY,
+	.table_init     = ip6table_security_table_init,
 };
 
 static unsigned int
@@ -44,9 +47,13 @@ ip6table_security_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
 
-static int __net_init ip6table_security_net_init(struct net *net)
+static int __net_init ip6table_security_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	int ret;
+
+	if (net->ipv6.ip6table_security)
+		return 0;
 
 	repl = ip6t_alloc_initial_table(&security_table);
 	if (repl == NULL)
@@ -54,16 +61,33 @@ static int __net_init ip6table_security_net_init(struct net *net)
 	net->ipv6.ip6table_security =
 		ip6t_register_table(net, &security_table, repl);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_security);
+	ret = PTR_ERR_OR_ZERO(net->ipv6.ip6table_security);
+	if (ret < 0)
+		goto err;
+
+	ret = xt_hook_link_net(net, net->ipv6.ip6table_security, sectbl_ops);
+	if (ret) {
+		ip6t_unregister_table(net, net->ipv6.ip6table_security);
+		goto err;
+	}
+
+	return ret;
+ err:
+	net->ipv6.ip6table_security = NULL;
+	return ret;
 }
 
 static void __net_exit ip6table_security_net_exit(struct net *net)
 {
+	if (!net->ipv6.ip6table_security)
+		return;
+
+	xt_hook_unlink_net(net, net->ipv6.ip6table_security, sectbl_ops);
 	ip6t_unregister_table(net, net->ipv6.ip6table_security);
+	net->ipv6.ip6table_security = NULL;
 }
 
 static struct pernet_operations ip6table_security_net_ops = {
-	.init = ip6table_security_net_init,
 	.exit = ip6table_security_net_exit,
 };
 
@@ -71,27 +95,28 @@ static int __init ip6table_security_init(void)
 {
 	int ret;
 
+	sectbl_ops = xt_hook_ops_alloc(&security_table, ip6table_security_hook);
+	if (IS_ERR(sectbl_ops))
+		return PTR_ERR(sectbl_ops);
+
 	ret = register_pernet_subsys(&ip6table_security_net_ops);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(sectbl_ops);
 		return ret;
-
-	sectbl_ops = xt_hook_link(&security_table, ip6table_security_hook);
-	if (IS_ERR(sectbl_ops)) {
-		ret = PTR_ERR(sectbl_ops);
-		goto cleanup_table;
 	}
 
-	return ret;
-
-cleanup_table:
-	unregister_pernet_subsys(&ip6table_security_net_ops);
+	ret = ip6table_security_table_init(&init_net);
+	if (ret) {
+		unregister_pernet_subsys(&ip6table_security_net_ops);
+		kfree(sectbl_ops);
+	}
 	return ret;
 }
 
 static void __exit ip6table_security_fini(void)
 {
-	xt_hook_unlink(&security_table, sectbl_ops);
 	unregister_pernet_subsys(&ip6table_security_net_ops);
+	kfree(sectbl_ops);
 }
 
 module_init(ip6table_security_init);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 9b42b5e..d768ea5 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -693,12 +693,45 @@ EXPORT_SYMBOL(xt_free_table_info);
 struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name)
 {
-	struct xt_table *t;
+	struct xt_table *t, *found = NULL;
 
 	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &net->xt.tables[af], list)
 		if (strcmp(t->name, name) == 0 && try_module_get(t->me))
 			return t;
+
+	if (net == &init_net)
+		goto out;
+
+	/* Table doesn't exist in this netns, re-try init */
+	list_for_each_entry(t, &init_net.xt.tables[af], list) {
+		if (strcmp(t->name, name))
+			continue;
+		if (!try_module_get(t->me))
+			return NULL;
+
+		mutex_unlock(&xt[af].mutex);
+		if (t->table_init(net) != 0) {
+			module_put(t->me);
+			return NULL;
+		}
+
+		found = t;
+
+		mutex_lock(&xt[af].mutex);
+		break;
+	}
+
+	if (!found)
+		goto out;
+
+	/* and once again: */
+	list_for_each_entry(t, &net->xt.tables[af], list)
+		if (strcmp(t->name, name) == 0)
+			return t;
+
+	module_put(found->me);
+ out:
 	mutex_unlock(&xt[af].mutex);
 	return NULL;
 }
@@ -1169,20 +1202,20 @@ static const struct file_operations xt_target_ops = {
 #endif /* CONFIG_PROC_FS */
 
 /**
- * xt_hook_link - set up hooks for a new table
+ * xt_hook_ops_alloc - set up hooks for a new table
  * @table:	table with metadata needed to set up hooks
  * @fn:		Hook function
  *
- * This function will take care of creating and registering the necessary
- * Netfilter hooks for XT tables.
+ * This function will create the nf_hook_ops that the x_table needs
+ * to hand to xt_hook_link_net().
  */
-struct nf_hook_ops *xt_hook_link(const struct xt_table *table, nf_hookfn *fn)
+struct nf_hook_ops *
+xt_hook_ops_alloc(const struct xt_table *table, nf_hookfn *fn)
 {
 	unsigned int hook_mask = table->valid_hooks;
 	uint8_t i, num_hooks = hweight32(hook_mask);
 	uint8_t hooknum;
 	struct nf_hook_ops *ops;
-	int ret;
 
 	ops = kmalloc(sizeof(*ops) * num_hooks, GFP_KERNEL);
 	if (ops == NULL)
@@ -1200,27 +1233,29 @@ struct nf_hook_ops *xt_hook_link(const struct xt_table *table, nf_hookfn *fn)
 		++i;
 	}
 
-	ret = nf_register_hooks(ops, num_hooks);
-	if (ret < 0) {
-		kfree(ops);
-		return ERR_PTR(ret);
-	}
-
 	return ops;
 }
-EXPORT_SYMBOL_GPL(xt_hook_link);
+EXPORT_SYMBOL_GPL(xt_hook_ops_alloc);
+
+int xt_hook_link_net(struct net *net, const struct xt_table *table,
+		     const struct nf_hook_ops *ops)
+{
+	return nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
+}
+EXPORT_SYMBOL_GPL(xt_hook_link_net);
 
 /**
- * xt_hook_unlink - remove hooks for a table
+ * xt_hook_unlink_net - remove hooks for a table in this netns
+ * @net:	netns that should get the table hook removed
+ * @table:	the table hook to remove in this netns
  * @ops:	nf_hook_ops array as returned by nf_hook_link
- * @hook_mask:	the very same mask that was passed to nf_hook_link
  */
-void xt_hook_unlink(const struct xt_table *table, struct nf_hook_ops *ops)
+void xt_hook_unlink_net(struct net *net, const struct xt_table *table,
+			const struct nf_hook_ops *ops)
 {
-	nf_unregister_hooks(ops, hweight32(table->valid_hooks));
-	kfree(ops);
+	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
 }
-EXPORT_SYMBOL_GPL(xt_hook_unlink);
+EXPORT_SYMBOL_GPL(xt_hook_unlink_net);
 
 int xt_proto_init(struct net *net, u_int8_t af)
 {
-- 
2.0.5

