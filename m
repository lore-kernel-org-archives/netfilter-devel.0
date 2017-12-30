From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC 5/8] netfilter: nf_tables: add single table list for all families
Date: Sun, 31 Dec 2017 00:13:45 +0100
Message-ID: <20171230231348.5497-6-pablo@netfilter.org>
References: <20171230231348.5497-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39210 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbdL3XN7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 18:13:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 01618C51A9
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D895A71D6
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB91171D6
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:54 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 961E74265A32
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:54 +0100 (CET)
In-Reply-To: <20171230231348.5497-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   8 +-
 include/net/netns/nftables.h      |   1 +
 net/netfilter/nf_tables_api.c     | 438 ++++++++++++++++++--------------------
 net/netfilter/nf_tables_netdev.c  |  21 +-
 4 files changed, 227 insertions(+), 241 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1575ac12cbf7..fb7b560806f0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -142,22 +142,22 @@ static inline void nft_data_debug(const struct nft_data *data)
  *	struct nft_ctx - nf_tables rule/set context
  *
  *	@net: net namespace
- * 	@afi: address family info
  * 	@table: the table the chain is contained in
  * 	@chain: the chain the rule is contained in
  *	@nla: netlink attributes
  *	@portid: netlink portID of the original message
  *	@seq: netlink sequence number
+ *	@family: protocol family
  *	@report: notify via unicast netlink message
  */
 struct nft_ctx {
 	struct net			*net;
-	struct nft_af_info		*afi;
 	struct nft_table		*table;
 	struct nft_chain		*chain;
 	const struct nlattr * const 	*nla;
 	u32				portid;
 	u32				seq;
+	u8				family;
 	bool				report;
 };
 
@@ -947,6 +947,7 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
  *	@use: number of chain references to this table
  *	@flags: table flag (see enum nft_table_flags)
  *	@genmask: generation mask
+ *	@afinfo: address family info
  *	@name: name of the table
  */
 struct nft_table {
@@ -958,6 +959,7 @@ struct nft_table {
 	u32				use;
 	u16				flags:14,
 					genmask:2;
+	struct nft_af_info		*afi;
 	char				*name;
 };
 
@@ -967,13 +969,11 @@ struct nft_table {
  *	@list: used internally
  *	@family: address family
  *	@owner: module owner
- *	@tables: used internally
  */
 struct nft_af_info {
 	struct list_head		list;
 	int				family;
 	struct module			*owner;
-	struct list_head		tables;
 };
 
 int nft_register_afinfo(struct net *, struct nft_af_info *);
diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 4109b5f3010f..7f86a63ac21f 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -8,6 +8,7 @@ struct nft_af_info;
 
 struct netns_nftables {
 	struct list_head	af_info;
+	struct list_head	tables;
 	struct list_head	commit_list;
 	struct nft_af_info	*ipv4;
 	struct nft_af_info	*ipv6;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d72182fb447d..3505cca8262f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -35,7 +35,6 @@ static LIST_HEAD(nf_tables_objects);
  */
 int nft_register_afinfo(struct net *net, struct nft_af_info *afi)
 {
-	INIT_LIST_HEAD(&afi->tables);
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	list_add_tail_rcu(&afi->list, &net->nft.af_info);
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
@@ -97,13 +96,13 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 			 struct net *net,
 			 const struct sk_buff *skb,
 			 const struct nlmsghdr *nlh,
-			 struct nft_af_info *afi,
+			 u8 family,
 			 struct nft_table *table,
 			 struct nft_chain *chain,
 			 const struct nlattr * const *nla)
 {
 	ctx->net	= net;
-	ctx->afi	= afi;
+	ctx->family	= family;
 	ctx->table	= table;
 	ctx->chain	= chain;
 	ctx->nla   	= nla;
@@ -349,30 +348,31 @@ static int nft_delobj(struct nft_ctx *ctx, struct nft_object *obj)
  * Tables
  */
 
-static struct nft_table *nft_table_lookup(const struct nft_af_info *afi,
+static struct nft_table *nft_table_lookup(const struct net *net,
 					  const struct nlattr *nla,
-					  u8 genmask)
+					  u8 family, u8 genmask)
 {
 	struct nft_table *table;
 
-	list_for_each_entry(table, &afi->tables, list) {
+	list_for_each_entry(table, &net->nft.tables, list) {
 		if (!nla_strcmp(nla, table->name) &&
+		    table->afi->family == family &&
 		    nft_active_genmask(table, genmask))
 			return table;
 	}
 	return NULL;
 }
 
-static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
+static struct nft_table *nf_tables_table_lookup(const struct net *net,
 						const struct nlattr *nla,
-						u8 genmask)
+						u8 family, u8 genmask)
 {
 	struct nft_table *table;
 
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	table = nft_table_lookup(afi, nla, genmask);
+	table = nft_table_lookup(net, nla, family, genmask);
 	if (table != NULL)
 		return table;
 
@@ -471,7 +471,7 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 		goto err;
 
 	err = nf_tables_fill_table_info(skb, ctx->net, ctx->portid, ctx->seq,
-					event, 0, ctx->afi->family, ctx->table);
+					event, 0, ctx->family, ctx->table);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -488,7 +488,6 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 				 struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	unsigned int idx = 0, s_idx = cb->args[0];
 	struct net *net = sock_net(skb->sk);
@@ -497,30 +496,27 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
 
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
-		if (family != NFPROTO_UNSPEC && family != afi->family)
+	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+		if (family != NFPROTO_UNSPEC && family != table->afi->family)
 			continue;
 
-		list_for_each_entry_rcu(table, &afi->tables, list) {
-			if (idx < s_idx)
-				goto cont;
-			if (idx > s_idx)
-				memset(&cb->args[1], 0,
-				       sizeof(cb->args) - sizeof(cb->args[0]));
-			if (!nft_is_active(net, table))
-				continue;
-			if (nf_tables_fill_table_info(skb, net,
-						      NETLINK_CB(cb->skb).portid,
-						      cb->nlh->nlmsg_seq,
-						      NFT_MSG_NEWTABLE,
-						      NLM_F_MULTI,
-						      afi->family, table) < 0)
-				goto done;
-
-			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+		if (idx < s_idx)
+			goto cont;
+		if (idx > s_idx)
+			memset(&cb->args[1], 0,
+			       sizeof(cb->args) - sizeof(cb->args[0]));
+		if (!nft_is_active(net, table))
+			continue;
+		if (nf_tables_fill_table_info(skb, net,
+					      NETLINK_CB(cb->skb).portid,
+					      cb->nlh->nlmsg_seq,
+					      NFT_MSG_NEWTABLE, NLM_F_MULTI,
+					      table->afi->family, table) < 0)
+			goto done;
+
+		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
-			idx++;
-		}
+		idx++;
 	}
 done:
 	rcu_read_unlock();
@@ -552,7 +548,8 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_TABLE_NAME], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -683,7 +680,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 		return PTR_ERR(afi);
 
 	name = nla[NFTA_TABLE_NAME];
-	table = nf_tables_table_lookup(afi, name, genmask);
+	table = nf_tables_table_lookup(net, name, afi->family, genmask);
 	if (IS_ERR(table)) {
 		if (PTR_ERR(table) != -ENOENT)
 			return PTR_ERR(table);
@@ -693,7 +690,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
+		nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, NULL, nla);
 		return nf_tables_updtable(&ctx);
 	}
 
@@ -719,14 +716,15 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
+	table->afi = afi;
 	table->flags = flags;
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
 	if (err < 0)
 		goto err4;
 
-	list_add_tail_rcu(&table->list, &afi->tables);
+	list_add_tail_rcu(&table->list, &net->nft.tables);
 	return 0;
 err4:
 	kfree(table->name);
@@ -793,30 +791,28 @@ static int nft_flush_table(struct nft_ctx *ctx)
 
 static int nft_flush(struct nft_ctx *ctx, int family)
 {
-	struct nft_af_info *afi;
 	struct nft_table *table, *nt;
 	const struct nlattr * const *nla = ctx->nla;
 	int err = 0;
 
-	list_for_each_entry(afi, &ctx->net->nft.af_info, list) {
-		if (family != AF_UNSPEC && afi->family != family)
+	list_for_each_entry_safe(table, nt, &ctx->net->nft.tables, list) {
+		if (family != AF_UNSPEC && table->afi->family != family)
 			continue;
 
-		ctx->afi = afi;
-		list_for_each_entry_safe(table, nt, &afi->tables, list) {
-			if (!nft_is_active_next(ctx->net, table))
-				continue;
+		ctx->family = table->afi->family;
 
-			if (nla[NFTA_TABLE_NAME] &&
-			    nla_strcmp(nla[NFTA_TABLE_NAME], table->name) != 0)
-				continue;
+		if (!nft_is_active_next(ctx->net, table))
+			continue;
 
-			ctx->table = table;
+		if (nla[NFTA_TABLE_NAME] &&
+		    nla_strcmp(nla[NFTA_TABLE_NAME], table->name) != 0)
+			continue;
 
-			err = nft_flush_table(ctx);
-			if (err < 0)
-				goto out;
-		}
+		ctx->table = table;
+
+		err = nft_flush_table(ctx);
+		if (err < 0)
+			goto out;
 	}
 out:
 	return err;
@@ -834,7 +830,7 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 	int family = nfmsg->nfgen_family;
 	struct nft_ctx ctx;
 
-	nft_ctx_init(&ctx, net, skb, nlh, NULL, NULL, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, 0, NULL, NULL, nla);
 	if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL)
 		return nft_flush(&ctx, family);
 
@@ -842,7 +838,8 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_TABLE_NAME], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -850,7 +847,7 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 	    table->use > 0)
 		return -EBUSY;
 
-	ctx.afi = afi;
+	ctx.family = afi->family;
 	ctx.table = table;
 
 	return nft_flush_table(&ctx);
@@ -862,7 +859,7 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 
 	kfree(ctx->table->name);
 	kfree(ctx->table);
-	module_put(ctx->afi->owner);
+	module_put(ctx->table->afi->owner);
 }
 
 int nft_register_chain_type(const struct nf_chain_type *ctype)
@@ -1063,7 +1060,7 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 		goto err;
 
 	err = nf_tables_fill_chain_info(skb, ctx->net, ctx->portid, ctx->seq,
-					event, 0, ctx->afi->family, ctx->table,
+					event, 0, ctx->family, ctx->table,
 					ctx->chain);
 	if (err < 0) {
 		kfree_skb(skb);
@@ -1081,7 +1078,6 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 				 struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	const struct nft_chain *chain;
 	unsigned int idx = 0, s_idx = cb->args[0];
@@ -1091,31 +1087,30 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
 
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
-		if (family != NFPROTO_UNSPEC && family != afi->family)
+	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+		if (family != NFPROTO_UNSPEC && family != table->afi->family)
 			continue;
 
-		list_for_each_entry_rcu(table, &afi->tables, list) {
-			list_for_each_entry_rcu(chain, &table->chains, list) {
-				if (idx < s_idx)
-					goto cont;
-				if (idx > s_idx)
-					memset(&cb->args[1], 0,
-					       sizeof(cb->args) - sizeof(cb->args[0]));
-				if (!nft_is_active(net, chain))
-					continue;
-				if (nf_tables_fill_chain_info(skb, net,
-							      NETLINK_CB(cb->skb).portid,
-							      cb->nlh->nlmsg_seq,
-							      NFT_MSG_NEWCHAIN,
-							      NLM_F_MULTI,
-							      afi->family, table, chain) < 0)
-					goto done;
+		list_for_each_entry_rcu(chain, &table->chains, list) {
+			if (idx < s_idx)
+				goto cont;
+			if (idx > s_idx)
+				memset(&cb->args[1], 0,
+				       sizeof(cb->args) - sizeof(cb->args[0]));
+			if (!nft_is_active(net, chain))
+				continue;
+			if (nf_tables_fill_chain_info(skb, net,
+						      NETLINK_CB(cb->skb).portid,
+						      cb->nlh->nlmsg_seq,
+						      NFT_MSG_NEWCHAIN,
+						      NLM_F_MULTI,
+						      table->afi->family, table,
+						      chain) < 0)
+				goto done;
 
-				nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
-				idx++;
-			}
+			idx++;
 		}
 	}
 done:
@@ -1149,7 +1144,8 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_CHAIN_TABLE], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -1257,8 +1253,8 @@ struct nft_chain_hook {
 
 static int nft_chain_parse_hook(struct net *net,
 				const struct nlattr * const nla[],
-				struct nft_af_info *afi,
-				struct nft_chain_hook *hook, bool create)
+				struct nft_chain_hook *hook, u8 family,
+				bool create)
 {
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
 	const struct nf_chain_type *type;
@@ -1276,10 +1272,10 @@ static int nft_chain_parse_hook(struct net *net,
 
 	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
-	type = chain_type[afi->family][NFT_CHAIN_T_DEFAULT];
+	type = chain_type[family][NFT_CHAIN_T_DEFAULT];
 	if (nla[NFTA_CHAIN_TYPE]) {
 		type = nf_tables_chain_type_lookup(nla[NFTA_CHAIN_TYPE],
-						   afi->family, create);
+						   family, create);
 		if (IS_ERR(type))
 			return PTR_ERR(type);
 	}
@@ -1296,7 +1292,7 @@ static int nft_chain_parse_hook(struct net *net,
 	hook->type = type;
 
 	hook->dev = NULL;
-	if (afi->family == NFPROTO_NETDEV) {
+	if (family == NFPROTO_NETDEV) {
 		char ifname[IFNAMSIZ];
 
 		if (!ha[NFTA_HOOK_DEV]) {
@@ -1331,7 +1327,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_table *table = ctx->table;
-	struct nft_af_info *afi = ctx->afi;
 	struct nft_base_chain *basechain;
 	struct nft_stats __percpu *stats;
 	struct net *net = ctx->net;
@@ -1345,7 +1340,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		struct nft_chain_hook hook;
 		struct nf_hook_ops *ops;
 
-		err = nft_chain_parse_hook(net, nla, afi, &hook, create);
+		err = nft_chain_parse_hook(net, nla, &hook, family, create);
 		if (err < 0)
 			return err;
 
@@ -1438,7 +1433,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		if (!nft_is_base_chain(chain))
 			return -EBUSY;
 
-		err = nft_chain_parse_hook(ctx->net, nla, ctx->afi, &hook,
+		err = nft_chain_parse_hook(ctx->net, nla, &hook, ctx->family,
 					   create);
 		if (err < 0)
 			return err;
@@ -1531,7 +1526,8 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_CHAIN_TABLE], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -1571,7 +1567,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 		}
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, chain, nla);
 
 	if (chain != NULL) {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
@@ -1605,7 +1601,8 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_CHAIN_TABLE], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -1617,7 +1614,7 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 	    chain->use > 0)
 		return -EBUSY;
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, chain, nla);
 
 	use = chain->use;
 	list_for_each_entry(rule, &chain->rules, list) {
@@ -1782,7 +1779,7 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	type = nft_expr_type_get(ctx->afi->family, tb[NFTA_EXPR_NAME]);
+	type = nft_expr_type_get(ctx->family, tb[NFTA_EXPR_NAME]);
 	if (IS_ERR(type))
 		return PTR_ERR(type);
 
@@ -2005,7 +2002,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 		goto err;
 
 	err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
-				       event, 0, ctx->afi->family, ctx->table,
+				       event, 0, ctx->family, ctx->table,
 				       ctx->chain, rule);
 	if (err < 0) {
 		kfree_skb(skb);
@@ -2029,7 +2026,6 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	const struct nft_rule_dump_ctx *ctx = cb->data;
-	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	const struct nft_chain *chain;
 	const struct nft_rule *rule;
@@ -2040,39 +2036,37 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
 
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
-		if (family != NFPROTO_UNSPEC && family != afi->family)
+	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+		if (family != NFPROTO_UNSPEC && family != table->afi->family)
 			continue;
 
-		list_for_each_entry_rcu(table, &afi->tables, list) {
-			if (ctx && ctx->table &&
-			    strcmp(ctx->table, table->name) != 0)
+		if (ctx && ctx->table && strcmp(ctx->table, table->name) != 0)
+			continue;
+
+		list_for_each_entry_rcu(chain, &table->chains, list) {
+			if (ctx && ctx->chain &&
+			    strcmp(ctx->chain, chain->name) != 0)
 				continue;
 
-			list_for_each_entry_rcu(chain, &table->chains, list) {
-				if (ctx && ctx->chain[0] &&
-				    strcmp(ctx->chain, chain->name) != 0)
-					continue;
-
-				list_for_each_entry_rcu(rule, &chain->rules, list) {
-					if (!nft_is_active(net, rule))
-						goto cont;
-					if (idx < s_idx)
-						goto cont;
-					if (idx > s_idx)
-						memset(&cb->args[1], 0,
-						       sizeof(cb->args) - sizeof(cb->args[0]));
-					if (nf_tables_fill_rule_info(skb, net, NETLINK_CB(cb->skb).portid,
-								      cb->nlh->nlmsg_seq,
-								      NFT_MSG_NEWRULE,
-								      NLM_F_MULTI | NLM_F_APPEND,
-								      afi->family, table, chain, rule) < 0)
-						goto done;
-
-					nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+			list_for_each_entry_rcu(rule, &chain->rules, list) {
+				if (!nft_is_active(net, rule))
+					goto cont;
+				if (idx < s_idx)
+					goto cont;
+				if (idx > s_idx)
+					memset(&cb->args[1], 0,
+					       sizeof(cb->args) - sizeof(cb->args[0]));
+				if (nf_tables_fill_rule_info(skb, net, NETLINK_CB(cb->skb).portid,
+							      cb->nlh->nlmsg_seq,
+							      NFT_MSG_NEWRULE,
+							      NLM_F_MULTI | NLM_F_APPEND,
+							      table->afi->family,
+							      table, chain, rule) < 0)
+					goto done;
+
+				nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
-					idx++;
-				}
+				idx++;
 			}
 		}
 	}
@@ -2150,7 +2144,8 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_RULE_TABLE], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -2227,7 +2222,8 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_RULE_TABLE], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -2266,7 +2262,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 			return PTR_ERR(old_rule);
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, chain, nla);
 
 	n = 0;
 	size = 0;
@@ -2401,7 +2397,8 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_RULE_TABLE], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -2412,7 +2409,7 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 			return PTR_ERR(chain);
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, chain, nla);
 
 	if (chain) {
 		if (nla[NFTA_RULE_HANDLE]) {
@@ -2605,13 +2602,13 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
 		if (afi == NULL)
 			return -EAFNOSUPPORT;
 
-		table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE],
-					       genmask);
+		table = nf_tables_table_lookup(net, nla[NFTA_SET_TABLE],
+					       afi->family, genmask);
 		if (IS_ERR(table))
 			return PTR_ERR(table);
 	}
 
-	nft_ctx_init(ctx, net, skb, nlh, afi, table, NULL, nla);
+	nft_ctx_init(ctx, net, skb, nlh, afi->family, table, NULL, nla);
 	return 0;
 }
 
@@ -2738,7 +2735,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 		goto nla_put_failure;
 
 	nfmsg = nlmsg_data(nlh);
-	nfmsg->nfgen_family	= ctx->afi->family;
+	nfmsg->nfgen_family	= ctx->family;
 	nfmsg->version		= NFNETLINK_V0;
 	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
 
@@ -2830,10 +2827,8 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nft_set *set;
 	unsigned int idx, s_idx = cb->args[0];
-	struct nft_af_info *afi;
 	struct nft_table *table, *cur_table = (struct nft_table *)cb->args[2];
 	struct net *net = sock_net(skb->sk);
-	int cur_family = cb->args[3];
 	struct nft_ctx *ctx = cb->data, ctx_set;
 
 	if (cb->args[1])
@@ -2842,51 +2837,44 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
 
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
-		if (ctx->afi && ctx->afi != afi)
+	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+		if (ctx->family != NFPROTO_UNSPEC &&
+		    ctx->family != table->afi->family)
+			continue;
+
+		if (ctx->table && ctx->table != table)
 			continue;
 
-		if (cur_family) {
-			if (afi->family != cur_family)
+		if (cur_table) {
+			if (cur_table != table)
 				continue;
 
-			cur_family = 0;
+			cur_table = NULL;
 		}
-		list_for_each_entry_rcu(table, &afi->tables, list) {
-			if (ctx->table && ctx->table != table)
-				continue;
+		idx = 0;
+		list_for_each_entry_rcu(set, &table->sets, list) {
+			if (idx < s_idx)
+				goto cont;
+			if (!nft_is_active(net, set))
+				goto cont;
 
-			if (cur_table) {
-				if (cur_table != table)
-					continue;
+			ctx_set = *ctx;
+			ctx_set.table = table;
+			ctx_set.family = table->afi->family;
 
-				cur_table = NULL;
+			if (nf_tables_fill_set(skb, &ctx_set, set,
+					       NFT_MSG_NEWSET,
+					       NLM_F_MULTI) < 0) {
+				cb->args[0] = idx;
+				cb->args[2] = (unsigned long) table;
+				goto done;
 			}
-			idx = 0;
-			list_for_each_entry_rcu(set, &table->sets, list) {
-				if (idx < s_idx)
-					goto cont;
-				if (!nft_is_active(net, set))
-					goto cont;
-
-				ctx_set = *ctx;
-				ctx_set.table = table;
-				ctx_set.afi = afi;
-				if (nf_tables_fill_set(skb, &ctx_set, set,
-						       NFT_MSG_NEWSET,
-						       NLM_F_MULTI) < 0) {
-					cb->args[0] = idx;
-					cb->args[2] = (unsigned long) table;
-					cb->args[3] = afi->family;
-					goto done;
-				}
-				nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
-				idx++;
-			}
-			if (s_idx)
-				s_idx = 0;
+			idx++;
 		}
+		if (s_idx)
+			s_idx = 0;
 	}
 	cb->args[1] = 1;
 done:
@@ -3096,11 +3084,12 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_SET_TABLE], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, NULL, nla);
 
 	set = nf_tables_set_lookup(table, nla[NFTA_SET_NAME], genmask);
 	if (IS_ERR(set)) {
@@ -3365,12 +3354,12 @@ static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx, struct net *net,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_SET_ELEM_LIST_TABLE],
-				       genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE],
+				       afi->family, genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	nft_ctx_init(ctx, net, skb, nlh, afi, table, NULL, nla);
+	nft_ctx_init(ctx, net, skb, nlh, afi->family, table, NULL, nla);
 	return 0;
 }
 
@@ -3475,7 +3464,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
 	struct net *net = sock_net(skb->sk);
-	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_set_dump_args args;
@@ -3487,21 +3475,19 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	int event;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
-		if (afi != dump_ctx->ctx.afi)
+	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+		if (dump_ctx->ctx.family != NFPROTO_UNSPEC &&
+		    dump_ctx->ctx.family != table->afi->family)
 			continue;
 
-		list_for_each_entry_rcu(table, &afi->tables, list) {
-			if (table != dump_ctx->ctx.table)
-				continue;
+		if (table != dump_ctx->ctx.table)
+			continue;
 
-			list_for_each_entry_rcu(set, &table->sets, list) {
-				if (set == dump_ctx->set) {
-					set_found = true;
-					break;
-				}
+		list_for_each_entry_rcu(set, &table->sets, list) {
+			if (set == dump_ctx->set) {
+				set_found = true;
+				break;
 			}
-			break;
 		}
 		break;
 	}
@@ -3521,7 +3507,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 		goto nla_put_failure;
 
 	nfmsg = nlmsg_data(nlh);
-	nfmsg->nfgen_family = afi->family;
+	nfmsg->nfgen_family = table->afi->family;
 	nfmsg->version      = NFNETLINK_V0;
 	nfmsg->res_id	    = htons(net->nft.base_seq & 0xffff);
 
@@ -3584,7 +3570,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	nfmsg = nlmsg_data(nlh);
-	nfmsg->nfgen_family	= ctx->afi->family;
+	nfmsg->nfgen_family	= ctx->family;
 	nfmsg->version		= NFNETLINK_V0;
 	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
 
@@ -3941,7 +3927,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		list_for_each_entry(binding, &set->bindings, list) {
 			struct nft_ctx bind_ctx = {
 				.net	= ctx->net,
-				.afi	= ctx->afi,
+				.family	= ctx->family,
 				.table	= ctx->table,
 				.chain	= (struct nft_chain *)binding->chain,
 			};
@@ -4488,7 +4474,8 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_OBJ_TABLE], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_OBJ_TABLE], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -4506,7 +4493,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 		return 0;
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, NULL, nla);
 
 	type = nft_obj_type_get(objtype);
 	if (IS_ERR(type))
@@ -4583,7 +4570,6 @@ struct nft_obj_filter {
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	unsigned int idx = 0, s_idx = cb->args[0];
 	struct nft_obj_filter *filter = cb->data;
@@ -4598,38 +4584,37 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
 
-	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
-		if (family != NFPROTO_UNSPEC && family != afi->family)
+	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+		if (family != NFPROTO_UNSPEC && family != table->afi->family)
 			continue;
 
-		list_for_each_entry_rcu(table, &afi->tables, list) {
-			list_for_each_entry_rcu(obj, &table->objects, list) {
-				if (!nft_is_active(net, obj))
-					goto cont;
-				if (idx < s_idx)
-					goto cont;
-				if (idx > s_idx)
-					memset(&cb->args[1], 0,
-					       sizeof(cb->args) - sizeof(cb->args[0]));
-				if (filter && filter->table[0] &&
-				    strcmp(filter->table, table->name))
-					goto cont;
-				if (filter &&
-				    filter->type != NFT_OBJECT_UNSPEC &&
-				    obj->ops->type->type != filter->type)
-					goto cont;
+		list_for_each_entry_rcu(obj, &table->objects, list) {
+			if (!nft_is_active(net, obj))
+				goto cont;
+			if (idx < s_idx)
+				goto cont;
+			if (idx > s_idx)
+				memset(&cb->args[1], 0,
+				       sizeof(cb->args) - sizeof(cb->args[0]));
+			if (filter && filter->table[0] &&
+			    strcmp(filter->table, table->name))
+				goto cont;
+			if (filter &&
+			    filter->type != NFT_OBJECT_UNSPEC &&
+			    obj->ops->type->type != filter->type)
+				goto cont;
 
-				if (nf_tables_fill_obj_info(skb, net, NETLINK_CB(cb->skb).portid,
-							    cb->nlh->nlmsg_seq,
-							    NFT_MSG_NEWOBJ,
-							    NLM_F_MULTI | NLM_F_APPEND,
-							    afi->family, table, obj, reset) < 0)
-					goto done;
+			if (nf_tables_fill_obj_info(skb, net, NETLINK_CB(cb->skb).portid,
+						    cb->nlh->nlmsg_seq,
+						    NFT_MSG_NEWOBJ,
+						    NLM_F_MULTI | NLM_F_APPEND,
+						    table->afi->family, table,
+						    obj, reset) < 0)
+				goto done;
 
-				nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
-				idx++;
-			}
+			idx++;
 		}
 	}
 done:
@@ -4714,7 +4699,8 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_OBJ_TABLE], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_OBJ_TABLE], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -4774,7 +4760,8 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_OBJ_TABLE], genmask);
+	table = nf_tables_table_lookup(net, nla[NFTA_OBJ_TABLE], afi->family,
+				       genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -4785,7 +4772,7 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	if (obj->use > 0)
 		return -EBUSY;
 
-	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, nlh, afi->family, table, NULL, nla);
 
 	return nft_delobj(&ctx, obj);
 }
@@ -4823,7 +4810,7 @@ static void nf_tables_obj_notify(const struct nft_ctx *ctx,
 				 struct nft_object *obj, int event)
 {
 	nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid, ctx->seq, event,
-		       ctx->afi->family, ctx->report, GFP_KERNEL);
+		       ctx->family, ctx->report, GFP_KERNEL);
 }
 
 static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
@@ -5816,6 +5803,7 @@ EXPORT_SYMBOL_GPL(nft_data_dump);
 static int __net_init nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.af_info);
+	INIT_LIST_HEAD(&net->nft.tables);
 	INIT_LIST_HEAD(&net->nft.commit_list);
 	net->nft.base_seq = 1;
 	return 0;
@@ -5851,10 +5839,10 @@ static void __nft_release_afinfo(struct net *net, struct nft_af_info *afi)
 	struct nft_set *set, *ns;
 	struct nft_ctx ctx = {
 		.net	= net,
-		.afi	= afi,
+		.family	= afi->family,
 	};
 
-	list_for_each_entry_safe(table, nt, &afi->tables, list) {
+	list_for_each_entry_safe(table, nt, &net->nft.tables, list) {
 		list_for_each_entry(chain, &table->chains, list)
 			nf_tables_unregister_hook(net, table, chain);
 		/* No packets are walking on these chains anymore. */
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index c7f671daa7d0..01b61a67a2ac 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -107,7 +107,6 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_chain *chain, *nr;
 	struct nft_ctx ctx = {
@@ -119,20 +118,18 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		return NOTIFY_DONE;
 
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	list_for_each_entry(afi, &dev_net(dev)->nft.af_info, list) {
-		ctx.afi = afi;
-		if (afi->family != NFPROTO_NETDEV)
+	list_for_each_entry(table, &ctx.net->nft.tables, list) {
+		if (table->afi->family != NFPROTO_NETDEV)
 			continue;
 
-		list_for_each_entry(table, &afi->tables, list) {
-			ctx.table = table;
-			list_for_each_entry_safe(chain, nr, &table->chains, list) {
-				if (!nft_is_base_chain(chain))
-					continue;
+		ctx.family = table->afi->family;
+		ctx.table = table;
+		list_for_each_entry_safe(chain, nr, &table->chains, list) {
+			if (!nft_is_base_chain(chain))
+				continue;
 
-				ctx.chain = chain;
-				nft_netdev_event(event, dev, &ctx);
-			}
+			ctx.chain = chain;
+			nft_netdev_event(event, dev, &ctx);
 		}
 	}
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-- 
2.11.0

