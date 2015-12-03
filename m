From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 03/12] netfilter: xtables: don't register table hooks in namespace at init time
Date: Thu,  3 Dec 2015 10:49:36 +0100
Message-ID: <1449136185-4165-4-git-send-email-fw@strlen.de>
References: <1449136185-4165-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52601 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932593AbbLCJuG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 04:50:06 -0500
In-Reply-To: <1449136185-4165-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

delay hook registration until the table is being requested inside a
namespace.

Historically, a particular table (iptables mangle, ip6tables filter, etc)
was registered on module load.

When netns support was added to iptables only the ip/ip6tables ruleset was
made namespace aware, not the actual hook points.

This means f.e. that when ipt_filter table/module is loaded on a system,
then each namespace on that system has an (empty) iptables filter ruleset.

In other words, if a namespace sends a packet, such skb is 'caught' by
netfilter machinery and fed to hooking points for that table (i.e. INPUT,
FORWARD, etc).

Thanks to Eric Biederman, hooks are no longer global, but per namespace.

This means that we can avoid allocation of empty ruleset in a namespace and
defer hook registration until we need the functionality.

We register a tables hook entry points ONLY in the initial namespace.
When an iptables get/setockopt is issued inside a given namespace, we check
if the table is found in the per-namespace list.

If not, we attempt to find it in the initial namespace, and, if found,
create an empty default table in the requesting namespace and register the
needed hooks.

Hook points are destroyed only once namespace is deleted, there is no
'usage count' (it makes no sense since there is no 'remove table' operation
in xtables api).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
  No changes since v2.
  Changes since v1:
  - perform netns hook registration from xx_register_table() (Pablo Neira)
  - don't make nat table register conntrack hooks (causes hard to resolve
    link order problems w. conntrack initcalls -- followup patch adds expicit
   conntrack-enable calls to MASQUERADE, REDIRECT, etc)

 include/linux/netfilter/x_tables.h        |  6 ++-
 include/linux/netfilter_arp/arp_tables.h  |  9 +++--
 include/linux/netfilter_ipv4/ip_tables.h  |  9 +++--
 include/linux/netfilter_ipv6/ip6_tables.h |  9 +++--
 net/ipv4/netfilter/arp_tables.c           | 66 +++++++++++++++++++------------
 net/ipv4/netfilter/arptable_filter.c      | 40 +++++++++++--------
 net/ipv4/netfilter/ip_tables.c            | 63 +++++++++++++++++------------
 net/ipv4/netfilter/iptable_filter.c       | 55 ++++++++++++++++----------
 net/ipv4/netfilter/iptable_mangle.c       | 41 +++++++++++++------
 net/ipv4/netfilter/iptable_nat.c          | 41 ++++++++++---------
 net/ipv4/netfilter/iptable_raw.c          | 42 +++++++++++++-------
 net/ipv4/netfilter/iptable_security.c     | 44 +++++++++++++--------
 net/ipv6/netfilter/ip6_tables.c           | 65 ++++++++++++++++++------------
 net/ipv6/netfilter/ip6table_filter.c      | 47 +++++++++++++---------
 net/ipv6/netfilter/ip6table_mangle.c      | 45 ++++++++++++---------
 net/ipv6/netfilter/ip6table_nat.c         | 41 ++++++++++---------
 net/ipv6/netfilter/ip6table_raw.c         | 46 ++++++++++++---------
 net/ipv6/netfilter/ip6table_security.c    | 44 +++++++++++++--------
 net/netfilter/x_tables.c                  | 65 ++++++++++++++++++------------
 19 files changed, 475 insertions(+), 303 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index c557741..80a305b 100644
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
@@ -408,8 +411,7 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 	return cnt;
 }
 
-struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
-void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
+struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 6f074db..029b95e 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -48,10 +48,11 @@ struct arpt_error {
 }
 
 extern void *arpt_alloc_initial_table(const struct xt_table *);
-extern struct xt_table *arpt_register_table(struct net *net,
-					    const struct xt_table *table,
-					    const struct arpt_replace *repl);
-extern void arpt_unregister_table(struct xt_table *table);
+int arpt_register_table(struct net *net, const struct xt_table *table,
+			const struct arpt_replace *repl,
+			const struct nf_hook_ops *ops, struct xt_table **res);
+void arpt_unregister_table(struct net *net, struct xt_table *table,
+			   const struct nf_hook_ops *ops);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index aa598f9..7bfc589 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -24,10 +24,11 @@
 
 extern void ipt_init(void) __init;
 
-extern struct xt_table *ipt_register_table(struct net *net,
-					   const struct xt_table *table,
-					   const struct ipt_replace *repl);
-extern void ipt_unregister_table(struct net *net, struct xt_table *table);
+int ipt_register_table(struct net *net, const struct xt_table *table,
+		       const struct ipt_replace *repl,
+		       const struct nf_hook_ops *ops, struct xt_table **res);
+void ipt_unregister_table(struct net *net, struct xt_table *table,
+			  const struct nf_hook_ops *ops);
 
 /* Standard entry. */
 struct ipt_standard {
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 0f76e5c..b21c392 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -25,10 +25,11 @@
 extern void ip6t_init(void) __init;
 
 extern void *ip6t_alloc_initial_table(const struct xt_table *);
-extern struct xt_table *ip6t_register_table(struct net *net,
-					    const struct xt_table *table,
-					    const struct ip6t_replace *repl);
-extern void ip6t_unregister_table(struct net *net, struct xt_table *table);
+int ip6t_register_table(struct net *net, const struct xt_table *table,
+			const struct ip6t_replace *repl,
+			const struct nf_hook_ops *ops, struct xt_table **res);
+void ip6t_unregister_table(struct net *net, struct xt_table *table,
+			   const struct nf_hook_ops *ops);
 extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b488cac..bf08192 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1780,9 +1780,29 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 	return ret;
 }
 
-struct xt_table *arpt_register_table(struct net *net,
-				     const struct xt_table *table,
-				     const struct arpt_replace *repl)
+static void __arpt_unregister_table(struct xt_table *table)
+{
+	struct xt_table_info *private;
+	void *loc_cpu_entry;
+	struct module *table_owner = table->me;
+	struct arpt_entry *iter;
+
+	private = xt_unregister_table(table);
+
+	/* Decrease module usage counts and free resources */
+	loc_cpu_entry = private->entries;
+	xt_entry_foreach(iter, loc_cpu_entry, private->size)
+		cleanup_entry(iter);
+	if (private->number > private->initial_entries)
+		module_put(table_owner);
+	xt_free_table_info(private);
+}
+
+int arpt_register_table(struct net *net,
+			const struct xt_table *table,
+			const struct arpt_replace *repl,
+			const struct nf_hook_ops *ops,
+			struct xt_table **res)
 {
 	int ret;
 	struct xt_table_info *newinfo;
@@ -1791,10 +1811,8 @@ struct xt_table *arpt_register_table(struct net *net,
 	struct xt_table *new_table;
 
 	newinfo = xt_alloc_table_info(repl->size);
-	if (!newinfo) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!newinfo)
+		return -ENOMEM;
 
 	loc_cpu_entry = newinfo->entries;
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
@@ -1809,30 +1827,28 @@ struct xt_table *arpt_register_table(struct net *net,
 		ret = PTR_ERR(new_table);
 		goto out_free;
 	}
-	return new_table;
+
+	/* set res now, will see skbs right after nf_register_net_hooks */
+	WRITE_ONCE(*res, new_table);
+
+	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
+	if (ret != 0) {
+		__arpt_unregister_table(new_table);
+		*res = NULL;
+	}
+
+	return ret;
 
 out_free:
 	xt_free_table_info(newinfo);
-out:
-	return ERR_PTR(ret);
+	return ret;
 }
 
-void arpt_unregister_table(struct xt_table *table)
+void arpt_unregister_table(struct net *net, struct xt_table *table,
+			   const struct nf_hook_ops *ops)
 {
-	struct xt_table_info *private;
-	void *loc_cpu_entry;
-	struct module *table_owner = table->me;
-	struct arpt_entry *iter;
-
-	private = xt_unregister_table(table);
-
-	/* Decrease module usage counts and free resources */
-	loc_cpu_entry = private->entries;
-	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		cleanup_entry(iter);
-	if (private->number > private->initial_entries)
-		module_put(table_owner);
-	xt_free_table_info(private);
+	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+	__arpt_unregister_table(table);
 }
 
 /* The built-in targets: standard (NULL) and error. */
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 1897ee1..aa0ad5a 100644
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
@@ -35,26 +38,32 @@ arptable_filter_hook(void *priv, struct sk_buff *skb,
 
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
-	net->ipv4.arptable_filter =
-		arpt_register_table(net, &packet_filter, repl);
+	err = arpt_register_table(net, &packet_filter, repl, arpfilter_ops,
+				  &net->ipv4.arptable_filter);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.arptable_filter);
+	return err;
 }
 
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
-	arpt_unregister_table(net->ipv4.arptable_filter);
+	if (net->ipv4.arptable_filter)
+		arpt_unregister_table(net, net->ipv4.arptable_filter,
+				      arpfilter_ops);
+	net->ipv4.arptable_filter = NULL;
 }
 
 static struct pernet_operations arptable_filter_net_ops = {
-	.init = arptable_filter_net_init,
 	.exit = arptable_filter_net_exit,
 };
 
@@ -62,26 +71,23 @@ static int __init arptable_filter_init(void)
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
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index b99affa..e53f8d6 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2062,9 +2062,27 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	return ret;
 }
 
-struct xt_table *ipt_register_table(struct net *net,
-				    const struct xt_table *table,
-				    const struct ipt_replace *repl)
+static void __ipt_unregister_table(struct net *net, struct xt_table *table)
+{
+	struct xt_table_info *private;
+	void *loc_cpu_entry;
+	struct module *table_owner = table->me;
+	struct ipt_entry *iter;
+
+	private = xt_unregister_table(table);
+
+	/* Decrease module usage counts and free resources */
+	loc_cpu_entry = private->entries;
+	xt_entry_foreach(iter, loc_cpu_entry, private->size)
+		cleanup_entry(iter, net);
+	if (private->number > private->initial_entries)
+		module_put(table_owner);
+	xt_free_table_info(private);
+}
+
+int ipt_register_table(struct net *net, const struct xt_table *table,
+		       const struct ipt_replace *repl,
+		       const struct nf_hook_ops *ops, struct xt_table **res)
 {
 	int ret;
 	struct xt_table_info *newinfo;
@@ -2073,10 +2091,8 @@ struct xt_table *ipt_register_table(struct net *net,
 	struct xt_table *new_table;
 
 	newinfo = xt_alloc_table_info(repl->size);
-	if (!newinfo) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!newinfo)
+		return -ENOMEM;
 
 	loc_cpu_entry = newinfo->entries;
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
@@ -2091,30 +2107,27 @@ struct xt_table *ipt_register_table(struct net *net,
 		goto out_free;
 	}
 
-	return new_table;
+	/* set res now, will see skbs right after nf_register_net_hooks */
+	WRITE_ONCE(*res, new_table);
+
+	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
+	if (ret != 0) {
+		__ipt_unregister_table(net, new_table);
+		*res = NULL;
+	}
+
+	return ret;
 
 out_free:
 	xt_free_table_info(newinfo);
-out:
-	return ERR_PTR(ret);
+	return ret;
 }
 
-void ipt_unregister_table(struct net *net, struct xt_table *table)
+void ipt_unregister_table(struct net *net, struct xt_table *table,
+			  const struct nf_hook_ops *ops)
 {
-	struct xt_table_info *private;
-	void *loc_cpu_entry;
-	struct module *table_owner = table->me;
-	struct ipt_entry *iter;
-
-	private = xt_unregister_table(table);
-
-	/* Decrease module usage counts and free resources */
-	loc_cpu_entry = private->entries;
-	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		cleanup_entry(iter, net);
-	if (private->number > private->initial_entries)
-		module_put(table_owner);
-	xt_free_table_info(private);
+	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+	__ipt_unregister_table(net, table);
 }
 
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 397ef2d..49e8d35 100644
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
@@ -62,15 +69,26 @@ static int __net_init iptable_filter_net_init(struct net *net)
 	((struct ipt_standard *)repl->entries)[1].target.verdict =
 		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
 
-	net->ipv4.iptable_filter =
-		ipt_register_table(net, &packet_filter, repl);
+	err = ipt_register_table(net, &packet_filter, repl, filter_ops,
+				 &net->ipv4.iptable_filter);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.iptable_filter);
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
-	ipt_unregister_table(net, net->ipv4.iptable_filter);
+	if (!net->ipv4.iptable_filter)
+		return;
+	ipt_unregister_table(net, net->ipv4.iptable_filter, filter_ops);
+	net->ipv4.iptable_filter = NULL;
 }
 
 static struct pernet_operations iptable_filter_net_ops = {
@@ -82,24 +100,21 @@ static int __init iptable_filter_init(void)
 {
 	int ret;
 
+	filter_ops = xt_hook_ops_alloc(&packet_filter, iptable_filter_hook);
+	if (IS_ERR(filter_ops))
+		return PTR_ERR(filter_ops);
+
 	ret = register_pernet_subsys(&iptable_filter_net_ops);
 	if (ret < 0)
-		return ret;
-
-	/* Register hooks */
-	filter_ops = xt_hook_link(&packet_filter, iptable_filter_hook);
-	if (IS_ERR(filter_ops)) {
-		ret = PTR_ERR(filter_ops);
-		unregister_pernet_subsys(&iptable_filter_net_ops);
-	}
+		kfree(filter_ops);
 
 	return ret;
 }
 
 static void __exit iptable_filter_fini(void)
 {
-	xt_hook_unlink(&packet_filter, filter_ops);
 	unregister_pernet_subsys(&iptable_filter_net_ops);
+	kfree(filter_ops);
 }
 
 module_init(iptable_filter_init);
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index ba5d392..57fc97c 100644
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
@@ -92,27 +95,32 @@ iptable_mangle_hook(void *priv,
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
 		return -ENOMEM;
-	net->ipv4.iptable_mangle =
-		ipt_register_table(net, &packet_mangler, repl);
+	ret = ipt_register_table(net, &packet_mangler, repl, mangle_ops,
+				 &net->ipv4.iptable_mangle);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.iptable_mangle);
+	return ret;
 }
 
 static void __net_exit iptable_mangle_net_exit(struct net *net)
 {
-	ipt_unregister_table(net, net->ipv4.iptable_mangle);
+	if (!net->ipv4.iptable_mangle)
+		return;
+	ipt_unregister_table(net, net->ipv4.iptable_mangle, mangle_ops);
+	net->ipv4.iptable_mangle = NULL;
 }
 
 static struct pernet_operations iptable_mangle_net_ops = {
-	.init = iptable_mangle_net_init,
 	.exit = iptable_mangle_net_exit,
 };
 
@@ -120,15 +128,22 @@ static int __init iptable_mangle_init(void)
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
@@ -136,8 +151,8 @@ static int __init iptable_mangle_init(void)
 
 static void __exit iptable_mangle_fini(void)
 {
-	xt_hook_unlink(&packet_mangler, mangle_ops);
 	unregister_pernet_subsys(&iptable_mangle_net_ops);
+	kfree(mangle_ops);
 }
 
 module_init(iptable_mangle_init);
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index ae2cd27..138a24b 100644
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
@@ -95,50 +98,50 @@ static struct nf_hook_ops nf_nat_ipv4_ops[] __read_mostly = {
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
-	net->ipv4.nat_table = ipt_register_table(net, &nf_nat_ipv4_table, repl);
+	ret = ipt_register_table(net, &nf_nat_ipv4_table, repl,
+				 nf_nat_ipv4_ops, &net->ipv4.nat_table);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.nat_table);
+	return ret;
 }
 
 static void __net_exit iptable_nat_net_exit(struct net *net)
 {
-	ipt_unregister_table(net, net->ipv4.nat_table);
+	if (!net->ipv4.nat_table)
+		return;
+	ipt_unregister_table(net, net->ipv4.nat_table, nf_nat_ipv4_ops);
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
index 1ba0281..ca83ed8 100644
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
@@ -32,28 +37,32 @@ iptable_raw_hook(void *priv, struct sk_buff *skb,
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
 		return -ENOMEM;
-	net->ipv4.iptable_raw =
-		ipt_register_table(net, &packet_raw, repl);
+	ret = ipt_register_table(net, &packet_raw, repl, rawtable_ops,
+				 &net->ipv4.iptable_raw);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.iptable_raw);
+	return ret;
 }
 
 static void __net_exit iptable_raw_net_exit(struct net *net)
 {
-	ipt_unregister_table(net, net->ipv4.iptable_raw);
+	if (!net->ipv4.iptable_raw)
+		return;
+	ipt_unregister_table(net, net->ipv4.iptable_raw, rawtable_ops);
+	net->ipv4.iptable_raw = NULL;
 }
 
 static struct pernet_operations iptable_raw_net_ops = {
-	.init = iptable_raw_net_init,
 	.exit = iptable_raw_net_exit,
 };
 
@@ -61,15 +70,20 @@ static int __init iptable_raw_init(void)
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
@@ -77,8 +91,8 @@ static int __init iptable_raw_init(void)
 
 static void __exit iptable_raw_fini(void)
 {
-	xt_hook_unlink(&packet_raw, rawtable_ops);
 	unregister_pernet_subsys(&iptable_raw_net_ops);
+	kfree(rawtable_ops);
 }
 
 module_init(iptable_raw_init);
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index c2e23d5..ff22659 100644
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
@@ -51,26 +54,33 @@ iptable_security_hook(void *priv, struct sk_buff *skb,
 
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
 		return -ENOMEM;
-	net->ipv4.iptable_security =
-		ipt_register_table(net, &security_table, repl);
+	ret = ipt_register_table(net, &security_table, repl, sectbl_ops,
+				 &net->ipv4.iptable_security);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.iptable_security);
+	return ret;
 }
 
 static void __net_exit iptable_security_net_exit(struct net *net)
 {
-	ipt_unregister_table(net, net->ipv4.iptable_security);
+	if (!net->ipv4.iptable_security)
+		return;
+
+	ipt_unregister_table(net, net->ipv4.iptable_security, sectbl_ops);
+	net->ipv4.iptable_security = NULL;
 }
 
 static struct pernet_operations iptable_security_net_ops = {
-	.init = iptable_security_net_init,
 	.exit = iptable_security_net_exit,
 };
 
@@ -78,27 +88,29 @@ static int __init iptable_security_init(void)
 {
 	int ret;
 
+	sectbl_ops = xt_hook_ops_alloc(&security_table, iptable_security_hook);
+	if (IS_ERR(sectbl_ops))
+		return PTR_ERR(sectbl_ops);
+
 	ret = register_pernet_subsys(&iptable_security_net_ops);
-	if (ret < 0)
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
 
 module_init(iptable_security_init);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 99425cf..84f9baf 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2071,9 +2071,28 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	return ret;
 }
 
-struct xt_table *ip6t_register_table(struct net *net,
-				     const struct xt_table *table,
-				     const struct ip6t_replace *repl)
+static void __ip6t_unregister_table(struct net *net, struct xt_table *table)
+{
+	struct xt_table_info *private;
+	void *loc_cpu_entry;
+	struct module *table_owner = table->me;
+	struct ip6t_entry *iter;
+
+	private = xt_unregister_table(table);
+
+	/* Decrease module usage counts and free resources */
+	loc_cpu_entry = private->entries;
+	xt_entry_foreach(iter, loc_cpu_entry, private->size)
+		cleanup_entry(iter, net);
+	if (private->number > private->initial_entries)
+		module_put(table_owner);
+	xt_free_table_info(private);
+}
+
+int ip6t_register_table(struct net *net, const struct xt_table *table,
+			const struct ip6t_replace *repl,
+			const struct nf_hook_ops *ops,
+			struct xt_table **res)
 {
 	int ret;
 	struct xt_table_info *newinfo;
@@ -2082,10 +2101,8 @@ struct xt_table *ip6t_register_table(struct net *net,
 	struct xt_table *new_table;
 
 	newinfo = xt_alloc_table_info(repl->size);
-	if (!newinfo) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!newinfo)
+		return -ENOMEM;
 
 	loc_cpu_entry = newinfo->entries;
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
@@ -2099,30 +2116,28 @@ struct xt_table *ip6t_register_table(struct net *net,
 		ret = PTR_ERR(new_table);
 		goto out_free;
 	}
-	return new_table;
+
+	/* set res now, will see skbs right after nf_register_net_hooks */
+	WRITE_ONCE(*res, new_table);
+
+	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
+	if (ret != 0) {
+		__ip6t_unregister_table(net, new_table);
+		*res = NULL;
+	}
+
+	return ret;
 
 out_free:
 	xt_free_table_info(newinfo);
-out:
-	return ERR_PTR(ret);
+	return ret;
 }
 
-void ip6t_unregister_table(struct net *net, struct xt_table *table)
+void ip6t_unregister_table(struct net *net, struct xt_table *table,
+			   const struct nf_hook_ops *ops)
 {
-	struct xt_table_info *private;
-	void *loc_cpu_entry;
-	struct module *table_owner = table->me;
-	struct ip6t_entry *iter;
-
-	private = xt_unregister_table(table);
-
-	/* Decrease module usage counts and free resources */
-	loc_cpu_entry = private->entries;
-	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		cleanup_entry(iter, net);
-	if (private->number > private->initial_entries)
-		module_put(table_owner);
-	xt_free_table_info(private);
+	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+	__ip6t_unregister_table(net, table);
 }
 
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 8b277b9..1343077 100644
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
@@ -55,15 +62,26 @@ static int __net_init ip6table_filter_net_init(struct net *net)
 	((struct ip6t_standard *)repl->entries)[1].target.verdict =
 		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
 
-	net->ipv6.ip6table_filter =
-		ip6t_register_table(net, &packet_filter, repl);
+	err = ip6t_register_table(net, &packet_filter, repl, filter_ops,
+				  &net->ipv6.ip6table_filter);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_filter);
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
-	ip6t_unregister_table(net, net->ipv6.ip6table_filter);
+	if (!net->ipv6.ip6table_filter)
+		return;
+	ip6t_unregister_table(net, net->ipv6.ip6table_filter, filter_ops);
+	net->ipv6.ip6table_filter = NULL;
 }
 
 static struct pernet_operations ip6table_filter_net_ops = {
@@ -75,28 +93,21 @@ static int __init ip6table_filter_init(void)
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
+		kfree(filter_ops);
 
 	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_filter_net_ops);
-	return ret;
 }
 
 static void __exit ip6table_filter_fini(void)
 {
-	xt_hook_unlink(&packet_filter, filter_ops);
 	unregister_pernet_subsys(&ip6table_filter_net_ops);
+	kfree(filter_ops);
 }
 
 module_init(ip6table_filter_init);
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index abe278b..bc09dc8 100644
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
@@ -88,26 +90,33 @@ ip6table_mangle_hook(void *priv, struct sk_buff *skb,
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
 		return -ENOMEM;
-	net->ipv6.ip6table_mangle =
-		ip6t_register_table(net, &packet_mangler, repl);
+	ret = ip6t_register_table(net, &packet_mangler, repl, mangle_ops,
+				  &net->ipv6.ip6table_mangle);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_mangle);
+	return ret;
 }
 
 static void __net_exit ip6table_mangle_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net, net->ipv6.ip6table_mangle);
+	if (!net->ipv6.ip6table_mangle)
+		return;
+
+	ip6t_unregister_table(net, net->ipv6.ip6table_mangle, mangle_ops);
+	net->ipv6.ip6table_mangle = NULL;
 }
 
 static struct pernet_operations ip6table_mangle_net_ops = {
-	.init = ip6table_mangle_net_init,
 	.exit = ip6table_mangle_net_exit,
 };
 
@@ -115,28 +124,28 @@ static int __init ip6table_mangle_init(void)
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
index de2a10a..7d2bd94 100644
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
@@ -97,50 +100,50 @@ static struct nf_hook_ops nf_nat_ipv6_ops[] __read_mostly = {
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
-	net->ipv6.ip6table_nat = ip6t_register_table(net, &nf_nat_ipv6_table, repl);
+	ret = ip6t_register_table(net, &nf_nat_ipv6_table, repl,
+				  nf_nat_ipv6_ops, &net->ipv6.ip6table_nat);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_nat);
+	return ret;
 }
 
 static void __net_exit ip6table_nat_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net, net->ipv6.ip6table_nat);
+	if (!net->ipv6.ip6table_nat)
+		return;
+	ip6t_unregister_table(net, net->ipv6.ip6table_nat, nf_nat_ipv6_ops);
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
index 9021963..d4bc564 100644
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
@@ -27,26 +30,32 @@ ip6table_raw_hook(void *priv, struct sk_buff *skb,
 
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
 		return -ENOMEM;
-	net->ipv6.ip6table_raw =
-		ip6t_register_table(net, &packet_raw, repl);
+	ret = ip6t_register_table(net, &packet_raw, repl, rawtable_ops,
+				  &net->ipv6.ip6table_raw);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_raw);
+	return ret;
 }
 
 static void __net_exit ip6table_raw_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net, net->ipv6.ip6table_raw);
+	if (!net->ipv6.ip6table_raw)
+		return;
+	ip6t_unregister_table(net, net->ipv6.ip6table_raw, rawtable_ops);
+	net->ipv6.ip6table_raw = NULL;
 }
 
 static struct pernet_operations ip6table_raw_net_ops = {
-	.init = ip6table_raw_net_init,
 	.exit = ip6table_raw_net_exit,
 };
 
@@ -54,28 +63,29 @@ static int __init ip6table_raw_init(void)
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
index 0d856fe..cf26ccb 100644
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
@@ -44,26 +47,32 @@ ip6table_security_hook(void *priv, struct sk_buff *skb,
 
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
 		return -ENOMEM;
-	net->ipv6.ip6table_security =
-		ip6t_register_table(net, &security_table, repl);
+	ret = ip6t_register_table(net, &security_table, repl, sectbl_ops,
+				  &net->ipv6.ip6table_security);
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_security);
+	return ret;
 }
 
 static void __net_exit ip6table_security_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net, net->ipv6.ip6table_security);
+	if (!net->ipv6.ip6table_security)
+		return;
+	ip6t_unregister_table(net, net->ipv6.ip6table_security, sectbl_ops);
+	net->ipv6.ip6table_security = NULL;
 }
 
 static struct pernet_operations ip6table_security_net_ops = {
-	.init = ip6table_security_net_init,
 	.exit = ip6table_security_net_exit,
 };
 
@@ -71,27 +80,28 @@ static int __init ip6table_security_init(void)
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
index c8a0b7d..d0cd2b9 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -694,12 +694,45 @@ EXPORT_SYMBOL(xt_free_table_info);
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
@@ -1170,20 +1203,20 @@ static const struct file_operations xt_target_ops = {
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
@@ -1200,27 +1233,9 @@ struct nf_hook_ops *xt_hook_link(const struct xt_table *table, nf_hookfn *fn)
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
-
-/**
- * xt_hook_unlink - remove hooks for a table
- * @ops:	nf_hook_ops array as returned by nf_hook_link
- * @hook_mask:	the very same mask that was passed to nf_hook_link
- */
-void xt_hook_unlink(const struct xt_table *table, struct nf_hook_ops *ops)
-{
-	nf_unregister_hooks(ops, hweight32(table->valid_hooks));
-	kfree(ops);
-}
-EXPORT_SYMBOL_GPL(xt_hook_unlink);
+EXPORT_SYMBOL_GPL(xt_hook_ops_alloc);
 
 int xt_proto_init(struct net *net, u_int8_t af)
 {
-- 
2.4.10

