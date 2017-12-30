From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC 7/8] netfilter: nf_tables: get rid of struct nft_af_info abstraction
Date: Sun, 31 Dec 2017 00:13:47 +0100
Message-ID: <20171230231348.5497-8-pablo@netfilter.org>
References: <20171230231348.5497-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39216 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750996AbdL3XOB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 18:14:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31116C51B7
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1592F71D6
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16E9871D8
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:56 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9B7C24265A32
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:55 +0100 (CET)
In-Reply-To: <20171230231348.5497-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h       |  23 +--
 net/bridge/netfilter/nf_tables_bridge.c |  25 +--
 net/ipv4/netfilter/nf_tables_arp.c      |  25 +--
 net/ipv4/netfilter/nf_tables_ipv4.c     |  24 +--
 net/ipv6/netfilter/nf_tables_ipv6.c     |  24 +--
 net/netfilter/nf_tables_api.c           | 260 +++++++-------------------------
 net/netfilter/nf_tables_inet.c          |  23 +--
 net/netfilter/nf_tables_netdev.c        |  19 +--
 8 files changed, 72 insertions(+), 351 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 928d50bb3302..5a3b4b9abb1b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -957,28 +957,12 @@ struct nft_table {
 	struct list_head		objects;
 	u64				hgenerator;
 	u32				use;
-	u16				flags:14,
+	u16				family:6,
+					flags:8,
 					genmask:2;
-	struct nft_af_info		*afi;
 	char				*name;
 };
 
-/**
- *	struct nft_af_info - nf_tables address family info
- *
- *	@list: used internally
- *	@family: address family
- *	@owner: module owner
- */
-struct nft_af_info {
-	struct list_head		list;
-	int				family;
-	struct module			*owner;
-};
-
-int nft_register_afinfo(struct nft_af_info *);
-void nft_unregister_afinfo(struct nft_af_info *);
-
 int nft_register_chain_type(const struct nf_chain_type *);
 void nft_unregister_chain_type(const struct nf_chain_type *);
 
@@ -1108,9 +1092,6 @@ void nft_trace_notify(struct nft_traceinfo *info);
 #define nft_dereference(p)					\
 	nfnl_dereference(p, NFNL_SUBSYS_NFTABLES)
 
-#define MODULE_ALIAS_NFT_FAMILY(family)	\
-	MODULE_ALIAS("nft-afinfo-" __stringify(family))
-
 #define MODULE_ALIAS_NFT_CHAIN(family, name) \
 	MODULE_ALIAS("nft-chain-" __stringify(family) "-" name)
 
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index dbf7195f059c..5160cf614176 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -42,11 +42,6 @@ nft_do_chain_bridge(void *priv,
 	return nft_do_chain(&pkt, priv);
 }
 
-static struct nft_af_info nft_af_bridge __read_mostly = {
-	.family		= NFPROTO_BRIDGE,
-	.owner		= THIS_MODULE,
-};
-
 static const struct nf_chain_type filter_bridge = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
@@ -68,28 +63,12 @@ static const struct nf_chain_type filter_bridge = {
 
 static int __init nf_tables_bridge_init(void)
 {
-	int ret;
-
-	ret = nft_register_afinfo(&nft_af_bridge);
-	if (ret < 0)
-		return ret;
-
-	ret = nft_register_chain_type(&filter_bridge);
-	if (ret < 0)
-		goto err_register_chain;
-
-	return ret;
-
-err_register_chain:
-	nft_unregister_chain_type(&filter_bridge);
-
-	return ret;
+	return nft_register_chain_type(&filter_bridge);
 }
 
 static void __exit nf_tables_bridge_exit(void)
 {
 	nft_unregister_chain_type(&filter_bridge);
-	nft_unregister_afinfo(&nft_af_bridge);
 }
 
 module_init(nf_tables_bridge_init);
@@ -97,4 +76,4 @@ module_exit(nf_tables_bridge_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_FAMILY(AF_BRIDGE);
+MODULE_ALIAS_NFT_CHAIN(AF_BRIDGE, "filter");
diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 07667388ceb5..036c074736b0 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -27,11 +27,6 @@ nft_do_chain_arp(void *priv,
 	return nft_do_chain(&pkt, priv);
 }
 
-static struct nft_af_info nft_af_arp __read_mostly = {
-	.family		= NFPROTO_ARP,
-	.owner		= THIS_MODULE,
-};
-
 static const struct nf_chain_type filter_arp = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
@@ -47,28 +42,12 @@ static const struct nf_chain_type filter_arp = {
 
 static int __init nf_tables_arp_init(void)
 {
-	int ret;
-
-	ret = nft_register_afinfo(&nft_af_arp);
-	if (ret < 0)
-		return ret;
-
-	ret = nft_register_chain_type(&filter_arp);
-	if (ret < 0)
-		goto err_register_chain;
-
-	return 0;
-
-err_register_chain:
-	nft_unregister_chain_type(&filter_arp);
-
-	return ret;
+	return nft_register_chain_type(&filter_arp);
 }
 
 static void __exit nf_tables_arp_exit(void)
 {
 	nft_unregister_chain_type(&filter_arp);
-	nft_unregister_afinfo(&nft_af_arp);
 }
 
 module_init(nf_tables_arp_init);
@@ -76,4 +55,4 @@ module_exit(nf_tables_arp_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_FAMILY(3); /* NFPROTO_ARP */
+MODULE_ALIAS_NFT_CHAIN(3, "filter"); /* NFPROTO_ARP */
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index e1441738acb4..96f955496d5f 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -30,11 +30,6 @@ static unsigned int nft_do_chain_ipv4(void *priv,
 	return nft_do_chain(&pkt, priv);
 }
 
-static struct nft_af_info nft_af_ipv4 __read_mostly = {
-	.family		= NFPROTO_IPV4,
-	.owner		= THIS_MODULE,
-};
-
 static const struct nf_chain_type filter_ipv4 = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
@@ -56,27 +51,12 @@ static const struct nf_chain_type filter_ipv4 = {
 
 static int __init nf_tables_ipv4_init(void)
 {
-	int ret;
-
-	ret = nft_register_afinfo(&nft_af_ipv4);
-	if (ret < 0)
-		return ret;
-
-	ret = nft_register_chain_type(&filter_ipv4);
-	if (ret < 0)
-		goto err_register_chain;
-
-	return 0;
-
-err_register_chain:
-	nft_unregister_afinfo(&nft_af_ipv4);
-	return ret;
+	return nft_register_chain_type(&filter_ipv4);
 }
 
 static void __exit nf_tables_ipv4_exit(void)
 {
 	nft_unregister_chain_type(&filter_ipv4);
-	nft_unregister_afinfo(&nft_af_ipv4);
 }
 
 module_init(nf_tables_ipv4_init);
@@ -84,4 +64,4 @@ module_exit(nf_tables_ipv4_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_FAMILY(AF_INET);
+MODULE_ALIAS_NFT_CHAIN(AF_INET, "filter");
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index 912d0e5516b0..17e03589331c 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -28,11 +28,6 @@ static unsigned int nft_do_chain_ipv6(void *priv,
 	return nft_do_chain(&pkt, priv);
 }
 
-static struct nft_af_info nft_af_ipv6 __read_mostly = {
-	.family		= NFPROTO_IPV6,
-	.owner		= THIS_MODULE,
-};
-
 static const struct nf_chain_type filter_ipv6 = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
@@ -54,26 +49,11 @@ static const struct nf_chain_type filter_ipv6 = {
 
 static int __init nf_tables_ipv6_init(void)
 {
-	int ret;
-
-	ret = nft_register_afinfo(&nft_af_ipv6);
-	if (ret < 0)
-		return ret;
-
-	ret = nft_register_chain_type(&filter_ipv6);
-	if (ret < 0)
-		goto err_register_chain;
-
-	return 0;
-
-err_register_chain:
-	nft_unregister_afinfo(&nft_af_ipv6);
-	return ret;
+	return nft_register_chain_type(&filter_ipv6);
 }
 
 static void __exit nf_tables_ipv6_exit(void)
 {
-	nft_unregister_afinfo(&nft_af_ipv6);
 	nft_unregister_chain_type(&filter_ipv6);
 }
 
@@ -82,4 +62,4 @@ module_exit(nf_tables_ipv6_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_FAMILY(AF_INET6);
+MODULE_ALIAS_NFT_CHAIN(AF_INET6, "filter");
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0e5e0f76a664..93bf276bc602 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -24,71 +24,6 @@
 
 static LIST_HEAD(nf_tables_expressions);
 static LIST_HEAD(nf_tables_objects);
-static LIST_HEAD(nf_tables_af_info);
-
-/**
- *	nft_register_afinfo - register nf_tables address family info
- *
- *	@afi: address family info to register
- *
- *	Register the address family for use with nf_tables. Returns zero on
- *	success or a negative errno code otherwise.
- */
-int nft_register_afinfo(struct nft_af_info *afi)
-{
-	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	list_add_tail_rcu(&afi->list, &nf_tables_af_info);
-	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nft_register_afinfo);
-
-/**
- *	nft_unregister_afinfo - unregister nf_tables address family info
- *
- *	@afi: address family info to unregister
- *
- *	Unregister the address family for use with nf_tables.
- */
-void nft_unregister_afinfo(struct nft_af_info *afi)
-{
-	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	list_del_rcu(&afi->list);
-	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-}
-EXPORT_SYMBOL_GPL(nft_unregister_afinfo);
-
-static struct nft_af_info *nft_afinfo_lookup(struct net *net, int family)
-{
-	struct nft_af_info *afi;
-
-	list_for_each_entry(afi, &net->nft.af_info, list) {
-		if (afi->family == family)
-			return afi;
-	}
-	return NULL;
-}
-
-static struct nft_af_info *
-nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
-{
-	struct nft_af_info *afi;
-
-	afi = nft_afinfo_lookup(net, family);
-	if (afi != NULL)
-		return afi;
-#ifdef CONFIG_MODULES
-	if (autoload) {
-		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-		request_module("nft-afinfo-%u", family);
-		nfnl_lock(NFNL_SUBSYS_NFTABLES);
-		afi = nft_afinfo_lookup(net, family);
-		if (afi != NULL)
-			return ERR_PTR(-EAGAIN);
-	}
-#endif
-	return ERR_PTR(-EAFNOSUPPORT);
-}
 
 static void nft_ctx_init(struct nft_ctx *ctx,
 			 struct net *net,
@@ -354,7 +289,7 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 
 	list_for_each_entry(table, &net->nft.tables, list) {
 		if (!nla_strcmp(nla, table->name) &&
-		    table->afi->family == family &&
+		    table->family == family &&
 		    nft_active_genmask(table, genmask))
 			return table;
 	}
@@ -495,7 +430,7 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 	cb->seq = net->nft.base_seq;
 
 	list_for_each_entry_rcu(table, &net->nft.tables, list) {
-		if (family != NFPROTO_UNSPEC && family != table->afi->family)
+		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
 		if (idx < s_idx)
@@ -509,7 +444,7 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 					      NETLINK_CB(cb->skb).portid,
 					      cb->nlh->nlmsg_seq,
 					      NFT_MSG_NEWTABLE, NLM_F_MULTI,
-					      table->afi->family, table) < 0)
+					      table->family, table) < 0)
 			goto done;
 
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -529,7 +464,6 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_cur(net);
-	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	struct sk_buff *skb2;
 	int family = nfmsg->nfgen_family;
@@ -542,11 +476,7 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 		return netlink_dump_start(nlsk, skb, nlh, &c);
 	}
 
-	afi = nf_tables_afinfo_lookup(net, family, false);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_TABLE_NAME], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_TABLE_NAME], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -666,19 +596,14 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
 	const struct nlattr *name;
-	struct nft_af_info *afi;
 	struct nft_table *table;
 	int family = nfmsg->nfgen_family;
 	u32 flags = 0;
 	struct nft_ctx ctx;
 	int err;
 
-	afi = nf_tables_afinfo_lookup(net, family, true);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
 	name = nla[NFTA_TABLE_NAME];
-	table = nf_tables_table_lookup(net, name, afi->family, genmask);
+	table = nf_tables_table_lookup(net, name, family, genmask);
 	if (IS_ERR(table)) {
 		if (PTR_ERR(table) != -ENOENT)
 			return PTR_ERR(table);
@@ -688,7 +613,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, NULL, nla);
+		nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 		return nf_tables_updtable(&ctx);
 	}
 
@@ -698,39 +623,33 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 			return -EINVAL;
 	}
 
-	err = -EAFNOSUPPORT;
-	if (!try_module_get(afi->owner))
-		goto err1;
-
 	err = -ENOMEM;
 	table = kzalloc(sizeof(*table), GFP_KERNEL);
 	if (table == NULL)
-		goto err2;
+		goto err_kzalloc;
 
 	table->name = nla_strdup(name, GFP_KERNEL);
 	if (table->name == NULL)
-		goto err3;
+		goto err_strdup;
 
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
-	table->afi = afi;
+	table->family = family;
 	table->flags = flags;
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
 	if (err < 0)
-		goto err4;
+		goto err_trans;
 
 	list_add_tail_rcu(&table->list, &net->nft.tables);
 	return 0;
-err4:
+err_trans:
 	kfree(table->name);
-err3:
+err_strdup:
 	kfree(table);
-err2:
-	module_put(afi->owner);
-err1:
+err_kzalloc:
 	return err;
 }
 
@@ -794,10 +713,10 @@ static int nft_flush(struct nft_ctx *ctx, int family)
 	int err = 0;
 
 	list_for_each_entry_safe(table, nt, &ctx->net->nft.tables, list) {
-		if (family != AF_UNSPEC && table->afi->family != family)
+		if (family != AF_UNSPEC && table->family != family)
 			continue;
 
-		ctx->family = table->afi->family;
+		ctx->family = table->family;
 
 		if (!nft_is_active_next(ctx->net, table))
 			continue;
@@ -823,7 +742,6 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
-	struct nft_af_info *afi;
 	struct nft_table *table;
 	int family = nfmsg->nfgen_family;
 	struct nft_ctx ctx;
@@ -832,11 +750,7 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 	if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL)
 		return nft_flush(&ctx, family);
 
-	afi = nf_tables_afinfo_lookup(net, family, false);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_TABLE_NAME], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_TABLE_NAME], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -845,7 +759,7 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 	    table->use > 0)
 		return -EBUSY;
 
-	ctx.family = afi->family;
+	ctx.family = family;
 	ctx.table = table;
 
 	return nft_flush_table(&ctx);
@@ -857,7 +771,6 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 
 	kfree(ctx->table->name);
 	kfree(ctx->table);
-	module_put(ctx->table->afi->owner);
 }
 
 int nft_register_chain_type(const struct nf_chain_type *ctype)
@@ -1086,7 +999,7 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 	cb->seq = net->nft.base_seq;
 
 	list_for_each_entry_rcu(table, &net->nft.tables, list) {
-		if (family != NFPROTO_UNSPEC && family != table->afi->family)
+		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
 		list_for_each_entry_rcu(chain, &table->chains, list) {
@@ -1102,7 +1015,7 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 						      cb->nlh->nlmsg_seq,
 						      NFT_MSG_NEWCHAIN,
 						      NLM_F_MULTI,
-						      table->afi->family, table,
+						      table->family, table,
 						      chain) < 0)
 				goto done;
 
@@ -1124,7 +1037,6 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_cur(net);
-	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	const struct nft_chain *chain;
 	struct sk_buff *skb2;
@@ -1138,11 +1050,7 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 		return netlink_dump_start(nlsk, skb, nlh, &c);
 	}
 
-	afi = nf_tables_afinfo_lookup(net, family, false);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_CHAIN_TABLE], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_CHAIN_TABLE], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -1510,7 +1418,6 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 	const struct nlattr * uninitialized_var(name);
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
-	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_chain *chain;
 	u8 policy = NF_ACCEPT;
@@ -1520,11 +1427,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
-	afi = nf_tables_afinfo_lookup(net, family, true);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_CHAIN_TABLE], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_CHAIN_TABLE], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -1565,7 +1468,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 		}
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
 
 	if (chain != NULL) {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
@@ -1586,7 +1489,6 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
-	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule;
@@ -1595,11 +1497,7 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 	u32 use;
 	int err;
 
-	afi = nf_tables_afinfo_lookup(net, family, false);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_CHAIN_TABLE], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_CHAIN_TABLE], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -1612,7 +1510,7 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 	    chain->use > 0)
 		return -EBUSY;
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
 
 	use = chain->use;
 	list_for_each_entry(rule, &chain->rules, list) {
@@ -2035,7 +1933,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	cb->seq = net->nft.base_seq;
 
 	list_for_each_entry_rcu(table, &net->nft.tables, list) {
-		if (family != NFPROTO_UNSPEC && family != table->afi->family)
+		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
 		if (ctx && ctx->table && strcmp(ctx->table, table->name) != 0)
@@ -2058,7 +1956,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 							      cb->nlh->nlmsg_seq,
 							      NFT_MSG_NEWRULE,
 							      NLM_F_MULTI | NLM_F_APPEND,
-							      table->afi->family,
+							      table->family,
 							      table, chain, rule) < 0)
 					goto done;
 
@@ -2094,7 +1992,6 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_cur(net);
-	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	const struct nft_chain *chain;
 	const struct nft_rule *rule;
@@ -2138,11 +2035,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 		return netlink_dump_start(nlsk, skb, nlh, &c);
 	}
 
-	afi = nf_tables_afinfo_lookup(net, family, false);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_RULE_TABLE], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_RULE_TABLE], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -2200,7 +2093,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
-	struct nft_af_info *afi;
+	int family = nfmsg->nfgen_family;
 	struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *old_rule = NULL;
@@ -2216,11 +2109,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
-	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_RULE_TABLE], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_RULE_TABLE], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -2260,7 +2149,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 			return PTR_ERR(old_rule);
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
 
 	n = 0;
 	size = 0;
@@ -2384,18 +2273,13 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
-	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_chain *chain = NULL;
 	struct nft_rule *rule;
 	int family = nfmsg->nfgen_family, err = 0;
 	struct nft_ctx ctx;
 
-	afi = nf_tables_afinfo_lookup(net, family, false);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_RULE_TABLE], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_RULE_TABLE], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -2407,7 +2291,7 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 			return PTR_ERR(chain);
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
 
 	if (chain) {
 		if (nla[NFTA_RULE_HANDLE]) {
@@ -2587,26 +2471,17 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
 				     u8 genmask)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	struct nft_af_info *afi = NULL;
+	int family = nfmsg->nfgen_family;
 	struct nft_table *table = NULL;
 
-	if (nfmsg->nfgen_family != NFPROTO_UNSPEC) {
-		afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, false);
-		if (IS_ERR(afi))
-			return PTR_ERR(afi);
-	}
-
 	if (nla[NFTA_SET_TABLE] != NULL) {
-		if (afi == NULL)
-			return -EAFNOSUPPORT;
-
 		table = nf_tables_table_lookup(net, nla[NFTA_SET_TABLE],
-					       afi->family, genmask);
+					       family, genmask);
 		if (IS_ERR(table))
 			return PTR_ERR(table);
 	}
 
-	nft_ctx_init(ctx, net, skb, nlh, afi->family, table, NULL, nla);
+	nft_ctx_init(ctx, net, skb, nlh, family, table, NULL, nla);
 	return 0;
 }
 
@@ -2837,7 +2712,7 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 
 	list_for_each_entry_rcu(table, &net->nft.tables, list) {
 		if (ctx->family != NFPROTO_UNSPEC &&
-		    ctx->family != table->afi->family)
+		    ctx->family != table->family)
 			continue;
 
 		if (ctx->table && ctx->table != table)
@@ -2858,7 +2733,7 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 
 			ctx_set = *ctx;
 			ctx_set.table = table;
-			ctx_set.family = table->afi->family;
+			ctx_set.family = table->family;
 
 			if (nf_tables_fill_set(skb, &ctx_set, set,
 					       NFT_MSG_NEWSET,
@@ -2970,8 +2845,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
+	int family = nfmsg->nfgen_family;
 	const struct nft_set_ops *ops;
-	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
@@ -3078,16 +2953,12 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
-	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, create);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_SET_TABLE], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_SET_TABLE], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 
 	set = nf_tables_set_lookup(table, nla[NFTA_SET_NAME], genmask);
 	if (IS_ERR(set)) {
@@ -3345,19 +3216,15 @@ static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx, struct net *net,
 				      u8 genmask)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	struct nft_af_info *afi;
+	int family = nfmsg->nfgen_family;
 	struct nft_table *table;
 
-	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, false);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
 	table = nf_tables_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE],
-				       afi->family, genmask);
+				       family, genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	nft_ctx_init(ctx, net, skb, nlh, afi->family, table, NULL, nla);
+	nft_ctx_init(ctx, net, skb, nlh, family, table, NULL, nla);
 	return 0;
 }
 
@@ -3475,7 +3342,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	rcu_read_lock();
 	list_for_each_entry_rcu(table, &net->nft.tables, list) {
 		if (dump_ctx->ctx.family != NFPROTO_UNSPEC &&
-		    dump_ctx->ctx.family != table->afi->family)
+		    dump_ctx->ctx.family != table->family)
 			continue;
 
 		if (table != dump_ctx->ctx.table)
@@ -3505,7 +3372,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 		goto nla_put_failure;
 
 	nfmsg = nlmsg_data(nlh);
-	nfmsg->nfgen_family = table->afi->family;
+	nfmsg->nfgen_family = table->family;
 	nfmsg->version      = NFNETLINK_V0;
 	nfmsg->res_id	    = htons(net->nft.base_seq & 0xffff);
 
@@ -4456,7 +4323,6 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	const struct nft_object_type *type;
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
-	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_object *obj;
 	struct nft_ctx ctx;
@@ -4468,11 +4334,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	    !nla[NFTA_OBJ_DATA])
 		return -EINVAL;
 
-	afi = nf_tables_afinfo_lookup(net, family, true);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_OBJ_TABLE], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_OBJ_TABLE], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -4491,7 +4353,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 		return 0;
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 
 	type = nft_obj_type_get(objtype);
 	if (IS_ERR(type))
@@ -4583,7 +4445,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	cb->seq = net->nft.base_seq;
 
 	list_for_each_entry_rcu(table, &net->nft.tables, list) {
-		if (family != NFPROTO_UNSPEC && family != table->afi->family)
+		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
 		list_for_each_entry_rcu(obj, &table->objects, list) {
@@ -4606,7 +4468,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 						    cb->nlh->nlmsg_seq,
 						    NFT_MSG_NEWOBJ,
 						    NLM_F_MULTI | NLM_F_APPEND,
-						    table->afi->family, table,
+						    table->family, table,
 						    obj, reset) < 0)
 				goto done;
 
@@ -4662,7 +4524,6 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_cur(net);
 	int family = nfmsg->nfgen_family;
-	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
@@ -4693,11 +4554,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	    !nla[NFTA_OBJ_TYPE])
 		return -EINVAL;
 
-	afi = nf_tables_afinfo_lookup(net, family, false);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_OBJ_TABLE], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_OBJ_TABLE], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -4744,7 +4601,6 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
-	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_object *obj;
 	struct nft_ctx ctx;
@@ -4754,11 +4610,7 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	    !nla[NFTA_OBJ_NAME])
 		return -EINVAL;
 
-	afi = nf_tables_afinfo_lookup(net, family, true);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(net, nla[NFTA_OBJ_TABLE], afi->family,
+	table = nf_tables_table_lookup(net, nla[NFTA_OBJ_TABLE], family,
 				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
@@ -4770,7 +4622,7 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	if (obj->use > 0)
 		return -EBUSY;
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 
 	return nft_delobj(&ctx, obj);
 }
@@ -5818,7 +5670,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 }
 EXPORT_SYMBOL_GPL(__nft_release_basechain);
 
-static void __nft_release_afinfo(struct net *net)
+static void __nft_release_table(struct net *net)
 {
 	struct nft_table *table, *nt;
 	struct nft_chain *chain, *nc;
@@ -5830,7 +5682,7 @@ static void __nft_release_afinfo(struct net *net)
 	};
 
 	list_for_each_entry_safe(table, nt, &net->nft.tables, list) {
-		ctx.family = table->afi->family;
+		ctx.family = table->family;
 
 		list_for_each_entry(chain, &table->chains, list)
 			nf_tables_unregister_hook(net, table, chain);
@@ -5875,7 +5727,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
-	__nft_release_afinfo(net);
+	__nft_release_table(net);
 }
 
 static struct pernet_operations nf_tables_net_ops = {
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
index c77b27b501c7..94ba72f4dc6d 100644
--- a/net/netfilter/nf_tables_inet.c
+++ b/net/netfilter/nf_tables_inet.c
@@ -59,11 +59,6 @@ static unsigned int nft_inet_output(void *priv, struct sk_buff *skb,
 	return nft_do_chain(&pkt, priv);
 }
 
-static struct nft_af_info nft_af_inet __read_mostly = {
-	.family		= NFPROTO_INET,
-	.owner		= THIS_MODULE,
-};
-
 static const struct nf_chain_type filter_inet = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
@@ -85,26 +80,12 @@ static const struct nf_chain_type filter_inet = {
 
 static int __init nf_tables_inet_init(void)
 {
-	int ret;
-
-	if (nft_register_afinfo(&nft_af_inet) < 0)
-		return ret;
-
-	ret = nft_register_chain_type(&filter_inet);
-	if (ret < 0)
-		goto err_register_chain;
-
-	return ret;
-
-err_register_chain:
-	nft_unregister_afinfo(&nft_af_inet);
-	return ret;
+	return nft_register_chain_type(&filter_inet);
 }
 
 static void __exit nf_tables_inet_exit(void)
 {
 	nft_unregister_chain_type(&filter_inet);
-	nft_unregister_afinfo(&nft_af_inet);
 }
 
 module_init(nf_tables_inet_init);
@@ -112,4 +93,4 @@ module_exit(nf_tables_inet_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_FAMILY(1);
++MODULE_ALIAS_NFT_CHAIN(1, "filter");
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 404b49acb125..4041fafca934 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -38,11 +38,6 @@ nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 	return nft_do_chain(&pkt, priv);
 }
 
-static struct nft_af_info nft_af_netdev __read_mostly = {
-	.family		= NFPROTO_NETDEV,
-	.owner		= THIS_MODULE,
-};
-
 static const struct nf_chain_type nft_filter_chain_netdev = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
@@ -91,10 +86,10 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	list_for_each_entry(table, &ctx.net->nft.tables, list) {
-		if (table->afi->family != NFPROTO_NETDEV)
+		if (table->family != NFPROTO_NETDEV)
 			continue;
 
-		ctx.family = table->afi->family;
+		ctx.family = table->family;
 		ctx.table = table;
 		list_for_each_entry_safe(chain, nr, &table->chains, list) {
 			if (!nft_is_base_chain(chain))
@@ -117,12 +112,9 @@ static int __init nf_tables_netdev_init(void)
 {
 	int ret;
 
-	if (nft_register_afinfo(&nft_af_netdev) < 0)
-		return ret;
-
 	ret = nft_register_chain_type(&nft_filter_chain_netdev);
 	if (ret)
-		goto err_register_chain_type;
+		return ret;
 
 	ret = register_netdevice_notifier(&nf_tables_netdev_notifier);
 	if (ret)
@@ -132,8 +124,6 @@ static int __init nf_tables_netdev_init(void)
 
 err_register_netdevice_notifier:
 	nft_unregister_chain_type(&nft_filter_chain_netdev);
-err_register_chain_type:
-	nft_unregister_afinfo(&nft_af_netdev);
 
 	return ret;
 }
@@ -142,7 +132,6 @@ static void __exit nf_tables_netdev_exit(void)
 {
 	unregister_netdevice_notifier(&nf_tables_netdev_notifier);
 	nft_unregister_chain_type(&nft_filter_chain_netdev);
-	nft_unregister_afinfo(&nft_af_netdev);
 }
 
 module_init(nf_tables_netdev_init);
@@ -150,4 +139,4 @@ module_exit(nf_tables_netdev_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NFT_FAMILY(5); /* NFPROTO_NETDEV */
+MODULE_ALIAS_NFT_CHAIN(5, "filter"); /* NFPROTO_NETDEV */
-- 
2.11.0

