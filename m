From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 nf-next 5/7] netfilter: conntrack: register hooks in netns when needed by ruleset
Date: Tue, 15 Nov 2016 21:36:43 +0100
Message-ID: <1479242205-21675-6-git-send-email-fw@strlen.de>
References: <1479242205-21675-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45094 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932333AbcKOUgo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 15:36:44 -0500
In-Reply-To: <1479242205-21675-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes use of nf_ct_netns_get/put added in previous patch.
We add get/put functions to nf_conntrack_l3proto structure, ipv4 and ipv6
then implement use-count to track how many users (nft or xtables modules)
have a dependency on ipv4 and/or ipv6 connection tracking functionality.

When count reaches zero, the hooks are unregistered.

This delays activation of connection tracking inside a namespace until
stateful firewall rule or nat rule gets added.

This patch breaks backwards compatibility in the sense that connection
tracking won't be active anymore when the protocol tracker module is
loaded.  This breaks e.g. setups that ctnetlink for flow accounting and
the like, without any '-m conntrack' packet filter rules.

Followup patch restores old behavour and makes new delayed scheme
optional via sysctl.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No changes since v3.

 include/net/netfilter/nf_conntrack_l3proto.h   |  4 ++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 55 ++++++++++++++++++++------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 54 +++++++++++++++++++------
 net/netfilter/nf_conntrack_proto.c             | 38 +++++++++++++++++-
 4 files changed, 127 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index cf8f3dfd810d..e7dcd72be21c 100644
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
index 823cf3331b9d..999d47bd2c9f 100644
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
@@ -307,6 +314,38 @@ static struct nf_sockopt_ops so_getorigdst = {
 	.owner		= THIS_MODULE,
 };
 
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
+	if (cnet->users && (--cnet->users == 0))
+		nf_unregister_net_hooks(net, ipv4_conntrack_ops,
+					ARRAY_SIZE(ipv4_conntrack_ops));
+	mutex_unlock(&register_ipv4_hooks);
+}
+
 struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 	.l3proto	 = PF_INET,
 	.name		 = "ipv4",
@@ -320,6 +359,8 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 	.nlattr_to_tuple = ipv4_nlattr_to_tuple,
 	.nla_policy	 = ipv4_nla_policy,
 #endif
+	.net_ns_get	 = ipv4_hooks_register,
+	.net_ns_put	 = ipv4_hooks_unregister,
 	.me		 = THIS_MODULE,
 };
 
@@ -363,6 +404,8 @@ static void ipv4_net_exit(struct net *net)
 static struct pernet_operations ipv4_net_ops = {
 	.init = ipv4_net_init,
 	.exit = ipv4_net_exit,
+	.id = &conntrack4_net_id,
+	.size = sizeof(struct conntrack4_net),
 };
 
 static int __init nf_conntrack_l3proto_ipv4_init(void)
@@ -384,17 +427,10 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 		goto cleanup_sockopt;
 	}
 
-	ret = nf_register_hooks(ipv4_conntrack_ops,
-				ARRAY_SIZE(ipv4_conntrack_ops));
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register hooks.\n");
-		goto cleanup_pernet;
-	}
-
 	ret = nf_ct_l4proto_register(builtin_l4proto4,
 				     ARRAY_SIZE(builtin_l4proto4));
 	if (ret < 0)
-		goto cleanup_hooks;
+		goto cleanup_pernet;
 
 	ret = nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv4);
 	if (ret < 0) {
@@ -406,8 +442,6 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 cleanup_l4proto:
 	nf_ct_l4proto_unregister(builtin_l4proto4,
 				 ARRAY_SIZE(builtin_l4proto4));
- cleanup_hooks:
-	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
  cleanup_pernet:
 	unregister_pernet_subsys(&ipv4_net_ops);
  cleanup_sockopt:
@@ -421,7 +455,6 @@ static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 	nf_ct_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
 	nf_ct_l4proto_unregister(builtin_l4proto4,
 				 ARRAY_SIZE(builtin_l4proto4));
-	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
 	unregister_pernet_subsys(&ipv4_net_ops);
 	nf_unregister_sockopt(&so_getorigdst);
 }
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 500be28ff563..7582a24704f4 100644
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
+	if (cnet->users && (--cnet->users == 0))
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
 
@@ -370,6 +409,8 @@ static void ipv6_net_exit(struct net *net)
 static struct pernet_operations ipv6_net_ops = {
 	.init = ipv6_net_init,
 	.exit = ipv6_net_exit,
+	.id = &conntrack6_net_id,
+	.size = sizeof(struct conntrack6_net),
 };
 
 static int __init nf_conntrack_l3proto_ipv6_init(void)
@@ -389,18 +430,10 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
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
 	ret = nf_ct_l4proto_register(builtin_l4proto6,
 				     ARRAY_SIZE(builtin_l4proto6));
 	if (ret < 0)
-		goto cleanup_hooks;
+		goto cleanup_pernet;
 
 	ret = nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv6);
 	if (ret < 0) {
@@ -411,8 +444,6 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 cleanup_l4proto:
 	nf_ct_l4proto_unregister(builtin_l4proto6,
 				 ARRAY_SIZE(builtin_l4proto6));
- cleanup_hooks:
-	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
  cleanup_pernet:
 	unregister_pernet_subsys(&ipv6_net_ops);
  cleanup_sockopt:
@@ -426,7 +457,6 @@ static void __exit nf_conntrack_l3proto_ipv6_fini(void)
 	nf_ct_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
 	nf_ct_l4proto_unregister(builtin_l4proto6,
 				 ARRAY_SIZE(builtin_l4proto6));
-	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
 	unregister_pernet_subsys(&ipv6_net_ops);
 	nf_unregister_sockopt(&so_getorigdst6);
 }
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 948f1e2fc80b..758688b25fd8 100644
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
2.7.3

