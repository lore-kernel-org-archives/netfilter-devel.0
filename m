From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 02/12] netfilter: conntrack: register hooks in netns when needed by ruleset
Date: Thu,  3 Dec 2015 10:49:35 +0100
Message-ID: <1449136185-4165-3-git-send-email-fw@strlen.de>
References: <1449136185-4165-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52600 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932593AbbLCJuC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 04:50:02 -0500
In-Reply-To: <1449136185-4165-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes use of nf_ct_netns_get/put added in previous patch.
We add get/put functions to nf_conntrack_l3proto structure, ipv4 and ipv6
then implement use-count to track how many users (nft or xtables modules)
have a dependency on ipv4 and/or ipv6 connection tracking functionality.

When count reaches zero, the hooks are unregistered.

The main goal of this patch is to delay activation of connection tracking
inside a namespace until a point in time where such functionality is needed
(which might be "never").

This patch will break some use cases, notably setups that *only* use
ctnetlink (e.g. for flow accouting) without any '-m conntrack' packet
filter rules.  The ctnetlink issue is addressed by a later patch in
this series.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v2.

 include/net/netfilter/nf_conntrack_l3proto.h   |  4 ++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 55 ++++++++++++++++++++------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 54 +++++++++++++++++++------
 net/netfilter/nf_conntrack_proto.c             | 38 +++++++++++++++++-
 4 files changed, 127 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index cdc920b..e0238db 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -52,6 +52,10 @@ struct nf_conntrack_l3proto {
 	int (*tuple_to_nlattr)(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *t);
 
+	/* Called when netns wants to use connection tracking */
+	int (*net_ns_get)(struct net *);
+	void (*net_ns_put)(struct net *);
+
 	/*
 	 * Calculate size of tuple nlattr
 	 */
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index e3c46e8..8ed9777 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -31,6 +31,13 @@
 #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
 #include <net/netfilter/nf_log.h>
 
+static int conntrack4_net_id __read_mostly;
+static DEFINE_MUTEX(register_ipv4_hooks);
+
+struct conntrack4_net {
+	unsigned int users;
+};
+
 static bool ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			      struct nf_conntrack_tuple *tuple)
 {
@@ -367,6 +374,38 @@ static int ipv4_init_net(struct net *net)
 	return 0;
 }
 
+static int ipv4_hooks_register(struct net *net)
+{
+	struct conntrack4_net *cnet = net_generic(net, conntrack4_net_id);
+	int err = 0;
+
+	mutex_lock(&register_ipv4_hooks);
+
+	cnet->users++;
+	if (cnet->users > 1)
+		goto out_unlock;
+
+	err = nf_register_net_hooks(net, ipv4_conntrack_ops,
+				    ARRAY_SIZE(ipv4_conntrack_ops));
+
+	if (err)
+		cnet->users = 0;
+ out_unlock:
+	mutex_unlock(&register_ipv4_hooks);
+	return err;
+}
+
+static void ipv4_hooks_unregister(struct net *net)
+{
+	struct conntrack4_net *cnet = net_generic(net, conntrack4_net_id);
+
+	mutex_lock(&register_ipv4_hooks);
+	if (--cnet->users == 0)
+		nf_unregister_net_hooks(net, ipv4_conntrack_ops,
+					ARRAY_SIZE(ipv4_conntrack_ops));
+	mutex_unlock(&register_ipv4_hooks);
+}
+
 struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 	.l3proto	 = PF_INET,
 	.name		 = "ipv4",
@@ -383,6 +422,8 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_NF_CONNTRACK_PROC_COMPAT)
 	.ctl_table_path  = "net/ipv4/netfilter",
 #endif
+	.net_ns_get	 = ipv4_hooks_register,
+	.net_ns_put	 = ipv4_hooks_unregister,
 	.init_net	 = ipv4_init_net,
 	.me		 = THIS_MODULE,
 };
@@ -440,6 +481,8 @@ static void ipv4_net_exit(struct net *net)
 static struct pernet_operations ipv4_net_ops = {
 	.init = ipv4_net_init,
 	.exit = ipv4_net_exit,
+	.id = &conntrack4_net_id,
+	.size = sizeof(struct conntrack4_net),
 };
 
 static int __init nf_conntrack_l3proto_ipv4_init(void)
@@ -461,17 +504,10 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 		goto cleanup_sockopt;
 	}
 
-	ret = nf_register_hooks(ipv4_conntrack_ops,
-				ARRAY_SIZE(ipv4_conntrack_ops));
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register hooks.\n");
-		goto cleanup_pernet;
-	}
-
 	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_tcp4);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv4: can't register tcp4 proto.\n");
-		goto cleanup_hooks;
+		goto cleanup_pernet;
 	}
 
 	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_udp4);
@@ -508,8 +544,6 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp4);
  cleanup_tcp4:
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
- cleanup_hooks:
-	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
  cleanup_pernet:
 	unregister_pernet_subsys(&ipv4_net_ops);
  cleanup_sockopt:
@@ -527,7 +561,6 @@ static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmp);
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp4);
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
-	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
 	unregister_pernet_subsys(&ipv4_net_ops);
 	nf_unregister_sockopt(&so_getorigdst);
 }
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 1aa5848..92a090f 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -34,6 +34,13 @@
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/netfilter/nf_log.h>
 
+static int conntrack6_net_id;
+static DEFINE_MUTEX(register_ipv6_hooks);
+
+struct conntrack6_net {
+	unsigned int users;
+};
+
 static bool ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			      struct nf_conntrack_tuple *tuple)
 {
@@ -308,6 +315,36 @@ static int ipv6_nlattr_tuple_size(void)
 }
 #endif
 
+static int ipv6_hooks_register(struct net *net)
+{
+	struct conntrack6_net *cnet = net_generic(net, conntrack6_net_id);
+	int err = 0;
+
+	mutex_lock(&register_ipv6_hooks);
+	cnet->users++;
+	if (cnet->users > 1)
+		goto out_unlock;
+
+	err = nf_register_net_hooks(net, ipv6_conntrack_ops,
+				    ARRAY_SIZE(ipv6_conntrack_ops));
+	if (err)
+		cnet->users = 0;
+ out_unlock:
+	mutex_unlock(&register_ipv6_hooks);
+	return err;
+}
+
+static void ipv6_hooks_unregister(struct net *net)
+{
+	struct conntrack6_net *cnet = net_generic(net, conntrack6_net_id);
+
+	mutex_lock(&register_ipv6_hooks);
+	if (--cnet->users == 0)
+		nf_unregister_net_hooks(net, ipv6_conntrack_ops,
+					ARRAY_SIZE(ipv6_conntrack_ops));
+	mutex_unlock(&register_ipv6_hooks);
+}
+
 struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 __read_mostly = {
 	.l3proto		= PF_INET6,
 	.name			= "ipv6",
@@ -321,6 +358,8 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 __read_mostly = {
 	.nlattr_to_tuple	= ipv6_nlattr_to_tuple,
 	.nla_policy		= ipv6_nla_policy,
 #endif
+	.net_ns_get		= ipv6_hooks_register,
+	.net_ns_put		= ipv6_hooks_unregister,
 	.me			= THIS_MODULE,
 };
 
@@ -382,6 +421,8 @@ static void ipv6_net_exit(struct net *net)
 static struct pernet_operations ipv6_net_ops = {
 	.init = ipv6_net_init,
 	.exit = ipv6_net_exit,
+	.id = &conntrack6_net_id,
+	.size = sizeof(struct conntrack6_net),
 };
 
 static int __init nf_conntrack_l3proto_ipv6_init(void)
@@ -401,18 +442,10 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 	if (ret < 0)
 		goto cleanup_sockopt;
 
-	ret = nf_register_hooks(ipv6_conntrack_ops,
-				ARRAY_SIZE(ipv6_conntrack_ops));
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv6: can't register pre-routing defrag "
-		       "hook.\n");
-		goto cleanup_pernet;
-	}
-
 	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_tcp6);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv6: can't register tcp6 proto.\n");
-		goto cleanup_hooks;
+		goto cleanup_pernet;
 	}
 
 	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_udp6);
@@ -440,8 +473,6 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp6);
  cleanup_tcp6:
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
- cleanup_hooks:
-	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
  cleanup_pernet:
 	unregister_pernet_subsys(&ipv6_net_ops);
  cleanup_sockopt:
@@ -456,7 +487,6 @@ static void __exit nf_conntrack_l3proto_ipv6_fini(void)
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp6);
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmpv6);
-	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
 	unregister_pernet_subsys(&ipv6_net_ops);
 	nf_unregister_sockopt(&so_getorigdst6);
 }
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 609c789..1fb11b6 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -127,12 +127,48 @@ EXPORT_SYMBOL_GPL(nf_ct_l3proto_module_put);
 
 int nf_ct_netns_get(struct net *net, u8 nfproto)
 {
-	return nf_ct_l3proto_try_module_get(nfproto);
+	const struct nf_conntrack_l3proto *l3proto;
+	int ret;
+
+	might_sleep();
+
+	ret = nf_ct_l3proto_try_module_get(nfproto);
+	if (ret < 0)
+		return ret;
+
+	/* we already have a reference, can't fail */
+	rcu_read_lock();
+	l3proto = __nf_ct_l3proto_find(nfproto);
+	rcu_read_unlock();
+
+	if (!l3proto->net_ns_get)
+		return 0;
+
+	ret = l3proto->net_ns_get(net);
+	if (ret < 0)
+		nf_ct_l3proto_module_put(nfproto);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_netns_get);
 
 void nf_ct_netns_put(struct net *net, u8 nfproto)
 {
+	const struct nf_conntrack_l3proto *l3proto;
+
+	might_sleep();
+
+	/* same as nf_conntrack_netns_get(), reference assumed */
+	rcu_read_lock();
+	l3proto = __nf_ct_l3proto_find(nfproto);
+	rcu_read_unlock();
+
+	if (WARN_ON(!l3proto))
+		return;
+
+	if (l3proto->net_ns_put)
+		l3proto->net_ns_put(net);
+
 	nf_ct_l3proto_module_put(nfproto);
 }
 EXPORT_SYMBOL_GPL(nf_ct_netns_put);
-- 
2.4.10

