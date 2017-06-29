From: Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH 2/2] nefilter: nf_nat: split nat rewriting from do_chain logic
Date: Thu, 29 Jun 2017 14:28:56 +0200
Message-ID: <20170629122856.28231-3-fw@strlen.de>
References: <20170629122856.28231-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39756 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752601AbdF2M2p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2017 08:28:45 -0400
In-Reply-To: <20170629122856.28231-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the packet rewrite and instantiation of nat NULL bindings
happens from the protocol specific nat backend.

Problem is that this means invocation occurs either via ip(6)table_nat
or the nf_tables nat chain type.

This is a problem for two reasons:
1. Can't use iptables nat and nf_tables nat at the same time,
   as the first user adds a nat binding (we add a NULL binding
   if no nat rule matched so we can detect post-nat tuple collisions).
2. If you use e.g. nft_masq, snat, redir, etc. you need to register
an empty base chain so that the nat core does the reverse translation.

After this change, the nat core deals with null bindings and reverse
translation.  If both iptables and nftables nat exists, the first matching
one is used.

The rewrite/null addition hooks get added/removed once a net namespace
installs the first nat rule in either nftables or xtables nat tables.

The downside of this change is that we need one more hook function in all
the ip stack hook points (except forward),

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c |  32 +-----
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c |  29 +-----
 net/netfilter/nf_nat_core.c              | 174 +++++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+), 56 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index feedd759ca80..1e0a6f2ef74a 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -251,7 +251,6 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
-	struct nf_conn_nat *nat;
 	/* maniptype == SRC for postrouting. */
 	enum nf_nat_manip_type maniptype = HOOK2MANIP(state->hook);
 
@@ -264,8 +263,6 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 	if (!ct)
 		return NF_ACCEPT;
 
-	nat = nfct_nat(ct);
-
 	switch (ctinfo) {
 	case IP_CT_RELATED:
 	case IP_CT_RELATED_REPLY:
@@ -287,36 +284,13 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 			ret = do_chain(priv, skb, state, ct);
 			if (ret != NF_ACCEPT)
 				return ret;
-
-			if (nf_nat_initialized(ct, HOOK2MANIP(state->hook)))
-				break;
-
-			ret = nf_nat_alloc_null_binding(ct, state->hook);
-			if (ret != NF_ACCEPT)
-				return ret;
-		} else {
-			pr_debug("Already setup manip %s for ct %p\n",
-				 maniptype == NF_NAT_MANIP_SRC ? "SRC" : "DST",
-				 ct);
-			if (nf_nat_oif_changed(state->hook, ctinfo, nat,
-					       state->out))
-				goto oif_changed;
 		}
 		break;
-
 	default:
-		/* ESTABLISHED */
-		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
-			     ctinfo == IP_CT_ESTABLISHED_REPLY);
-		if (nf_nat_oif_changed(state->hook, ctinfo, nat, state->out))
-			goto oif_changed;
+		break;
 	}
 
-	return nf_nat_packet(ct, ctinfo, state->hook, skb);
-
-oif_changed:
-	nf_ct_kill_acct(ct, ctinfo, skb);
-	return NF_DROP;
+	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(nf_nat_ipv4_fn);
 
@@ -436,8 +410,8 @@ static int __init nf_nat_l3proto_ipv4_init(void)
 	err = nf_nat_l3proto_register(&nf_nat_l3proto_ipv4);
 	if (err < 0)
 		goto err2;
-	return err;
 
+	return err;
 err2:
 	nf_nat_l4proto_unregister(NFPROTO_IPV4, &nf_nat_l4proto_icmp);
 err1:
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index b2b4f031b3a1..47ed866ec2e0 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -258,7 +258,6 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
-	struct nf_conn_nat *nat;
 	enum nf_nat_manip_type maniptype = HOOK2MANIP(state->hook);
 	__be16 frag_off;
 	int hdrlen;
@@ -273,8 +272,6 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 	if (!ct)
 		return NF_ACCEPT;
 
-	nat = nfct_nat(ct);
-
 	switch (ctinfo) {
 	case IP_CT_RELATED:
 	case IP_CT_RELATED_REPLY:
@@ -301,35 +298,13 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 			ret = do_chain(priv, skb, state, ct);
 			if (ret != NF_ACCEPT)
 				return ret;
-
-			if (nf_nat_initialized(ct, HOOK2MANIP(state->hook)))
-				break;
-
-			ret = nf_nat_alloc_null_binding(ct, state->hook);
-			if (ret != NF_ACCEPT)
-				return ret;
-		} else {
-			pr_debug("Already setup manip %s for ct %p\n",
-				 maniptype == NF_NAT_MANIP_SRC ? "SRC" : "DST",
-				 ct);
-			if (nf_nat_oif_changed(state->hook, ctinfo, nat, state->out))
-				goto oif_changed;
 		}
 		break;
-
 	default:
-		/* ESTABLISHED */
-		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
-			     ctinfo == IP_CT_ESTABLISHED_REPLY);
-		if (nf_nat_oif_changed(state->hook, ctinfo, nat, state->out))
-			goto oif_changed;
+		break;
 	}
 
-	return nf_nat_packet(ct, ctinfo, state->hook, skb);
-
-oif_changed:
-	nf_ct_kill_acct(ct, ctinfo, skb);
-	return NF_DROP;
+	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(nf_nat_ipv6_fn);
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index cb81a561e9d0..533b30d8d76b 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -29,12 +29,14 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <linux/netfilter/nf_nat.h>
+#include <uapi/linux/netfilter_ipv6.h>
 
 static DEFINE_MUTEX(nf_nat_proto_mutex);
 static const struct nf_nat_l3proto __rcu *nf_nat_l3protos[NFPROTO_NUMPROTO]
 						__read_mostly;
 static const struct nf_nat_l4proto __rcu **nf_nat_l4protos[NFPROTO_NUMPROTO]
 						__read_mostly;
+static int nat_net_id __read_mostly;
 
 struct nf_nat_conn_key {
 	const struct net *net;
@@ -42,6 +44,10 @@ struct nf_nat_conn_key {
 	const struct nf_conntrack_zone *zone;
 };
 
+struct nat_net {
+	unsigned int users[NFPROTO_NUMPROTO];
+};
+
 static struct rhltable nf_nat_bysource_table;
 
 inline const struct nf_nat_l3proto *
@@ -818,8 +824,97 @@ static struct nf_ct_helper_expectfn follow_master_nat = {
 	.expectfn	= nf_nat_follow_master,
 };
 
+static unsigned int nf_nat_do(void *priv, struct sk_buff *skb,
+			      const struct nf_hook_state *state)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	struct nf_conn_nat *nat;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return NF_ACCEPT;
+
+	switch (ctinfo) {
+	case IP_CT_NEW:
+		if (!nf_nat_initialized(ct, HOOK2MANIP(state->hook))) {
+			int ret = nf_nat_alloc_null_binding(ct, state->hook);
+
+			if (ret != NF_ACCEPT)
+				return ret;
+			break;
+		}
+		/* fallthrough */
+	default:
+		nat = nfct_nat(ct);
+		if (nf_nat_oif_changed(state->hook, ctinfo, nat, state->out))
+			goto oif_changed;
+		break;
+	}
+
+	return nf_nat_packet(ct, ctinfo, state->hook, skb);
+oif_changed:
+	nf_ct_kill_acct(ct, ctinfo, skb);
+	return NF_DROP;
+}
+
+static struct nf_hook_ops nf_nat_ipv4_ops[] __read_mostly = {
+	{
+		.hook		= nf_nat_do,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_PRE_ROUTING,
+		.priority	= NF_IP_PRI_NAT_DST + 1,
+	},
+	{
+		.hook		= nf_nat_do,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP_PRI_NAT_SRC + 1,
+	},
+	{
+		.hook		= nf_nat_do,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_LOCAL_OUT,
+		.priority	= NF_IP_PRI_NAT_DST + 1,
+	},
+	{
+		.hook		= nf_nat_do,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP_PRI_NAT_SRC + 1,
+	},
+};
+
+static struct nf_hook_ops nf_nat_ipv6_ops[] __read_mostly = {
+	{
+		.hook		= nf_nat_do,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_PRE_ROUTING,
+		.priority	= NF_IP6_PRI_NAT_DST + 1,
+	},
+	{
+		.hook		= nf_nat_do,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP6_PRI_NAT_SRC + 1,
+	},
+	{
+		.hook		= nf_nat_do,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_LOCAL_OUT,
+		.priority	= NF_IP6_PRI_NAT_DST + 1,
+	},
+	{
+		.hook		= nf_nat_do,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP6_PRI_NAT_SRC + 1,
+	},
+};
+
 int nf_nat_netns_get(struct net *net, u8 nfproto)
 {
+	struct nat_net *nat_net = net_generic(net, nat_net_id);
 	int ret;
 
 	if (WARN_ON(nfproto >= ARRAY_SIZE(nat_net->users)))
@@ -829,19 +924,90 @@ int nf_nat_netns_get(struct net *net, u8 nfproto)
 	if (ret < 0)
 		return ret;
 
+	mutex_lock(&nf_nat_proto_mutex);
+	if (WARN_ON(nat_net->users[nfproto] == UINT_MAX)) {
+		ret = -EOVERFLOW;
+		goto err_unlock;
+	}
+
+	if (nat_net->users[nfproto] == 0) {
+		switch (nfproto) {
+		case NFPROTO_IPV4:
+			ret = nf_register_net_hooks(net, nf_nat_ipv4_ops,
+						    ARRAY_SIZE(nf_nat_ipv4_ops));
+			break;
+		case NFPROTO_IPV6:
+			ret = nf_register_net_hooks(net, nf_nat_ipv6_ops,
+						    ARRAY_SIZE(nf_nat_ipv6_ops));
+			break;
+		default:
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		if (ret)
+			goto err_unlock;
+	}
+	nat_net->users[nfproto]++;
+	mutex_unlock(&nf_nat_proto_mutex);
+	return ret;
+
+err_unlock:
+	mutex_unlock(&nf_nat_proto_mutex);
+	nf_ct_netns_put(net, nfproto);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_nat_netns_get);
 
 void nf_nat_netns_put(struct net *net, u8 nfproto)
 {
+	struct nat_net *nat_net = net_generic(net, nat_net_id);
+
 	if (WARN_ON(nfproto >= ARRAY_SIZE(nat_net->users)))
 		goto out;
+
+	mutex_lock(&nf_nat_proto_mutex);
+	if (WARN_ON(nat_net->users[nfproto] == 0))
+		goto out_unlock;
+
+	nat_net->users[nfproto]--;
+	if (nat_net->users[nfproto])
+		goto out_unlock;
+
+	switch (nfproto) {
+	case NFPROTO_IPV4:
+		nf_unregister_net_hooks(net, nf_nat_ipv4_ops,
+					ARRAY_SIZE(nf_nat_ipv4_ops));
+		break;
+	case NFPROTO_IPV6:
+		nf_unregister_net_hooks(net, nf_nat_ipv6_ops,
+					ARRAY_SIZE(nf_nat_ipv6_ops));
+		break;
+	}
+out_unlock:
+	mutex_unlock(&nf_nat_proto_mutex);
 out:
 	nf_ct_netns_put(net, nfproto);
 }
 EXPORT_SYMBOL_GPL(nf_nat_netns_put);
 
+static void nat_net_exit(struct net *net)
+{
+	struct nat_net *nat_net = net_generic(net, nat_net_id);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nat_net->users); i++) {
+		if (nat_net->users[i])
+			nf_nat_netns_put(net, i);
+	}
+}
+
+static struct pernet_operations nat_net_ops = {
+	.exit = nat_net_exit,
+	.id = &nat_net_id,
+	.size = sizeof(struct nat_net),
+};
+
 static int __init nf_nat_init(void)
 {
 	int ret;
@@ -857,6 +1023,13 @@ static int __init nf_nat_init(void)
 		return ret;
 	}
 
+	ret = register_pernet_subsys(&nat_net_ops);
+	if (ret < 0) {
+		nf_ct_extend_unregister(&nat_extend);
+		rhltable_destroy(&nf_nat_bysource_table);
+		return ret;
+	}
+
 	nf_ct_helper_expectfn_register(&follow_master_nat);
 
 	BUG_ON(nfnetlink_parse_nat_setup_hook != NULL);
@@ -888,6 +1061,7 @@ static void __exit nf_nat_cleanup(void)
 		kfree(nf_nat_l4protos[i]);
 
 	rhltable_destroy(&nf_nat_bysource_table);
+	unregister_pernet_subsys(&nat_net_ops);
 }
 
 MODULE_LICENSE("GPL");
-- 
2.13.0

