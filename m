Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92155C00144
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jul 2022 09:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiG2Jbo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 05:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiG2Jbl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 05:31:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 430E5140B1
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2022 02:31:38 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC 2/3] netfilter: nf_tables: add string set API
Date:   Fri, 29 Jul 2022 11:31:28 +0200
Message-Id: <20220729093129.3108-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220729093129.3108-1-pablo@netfilter.org>
References: <20220729093129.3108-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds 6 new netlink commands for the nftables API:

- NFT_MSG_NEWSTRSET, to create a new string set.
- NFT_MSG_DELSTRSET, to delete an existing string set.
- NFT_MSG_GETSTRSET, to fetch the list of existing string sets.
- NFT_MSG_NEWSTRING, to add patterns to a string set.
- NFT_MSG_DELSTRING, to delete patterns to a string set.
- NFT_MSG_GETSTRING, to fetch the patterns in an existing string set.

This API uses the Aho-Corasick implementation coming in the previous
patch. String sets stores two versions of the Aho-Corasick tree: the
active tree which is currently used to search for patterns and the clone
which is used for pending updates.

Tree updates are performed under per-netns nftables mutex, the tree
pointer is protected/accessed through RCU. There is a commit_update
field that specifies that there is a updated clone to replace the stale
tree from the commit step of the 2-phase commit protocol.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   33 +
 include/uapi/linux/netfilter/nf_tables.h |   39 +
 net/netfilter/nf_tables_api.c            | 1286 ++++++++++++++++++----
 3 files changed, 1158 insertions(+), 200 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 64cf655c818c..c4e9a969122a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1158,6 +1158,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	struct list_head		strsets;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
@@ -1339,6 +1340,31 @@ void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
 void nft_register_flowtable_type(struct nf_flowtable_type *type);
 void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
 
+struct ac_tree;
+
+/**
+ *	struct nft_strset - nf_tables string set
+ *
+ *	@list: flow table list node in table list
+ * 	@table: the table the strings is contained in
+ * 	@name: the name of this string collection
+ *	@tree: the aho-corasick tree
+ *	@handle: the string collection handle
+ *	@genmask: generation mask
+ *	@commit_update: data structure needs update on commit
+ *	@use: reference counter
+ */
+struct nft_strset {
+	struct list_head		list;
+	struct nft_table		*table;
+	char				*name;
+	struct ac_tree __rcu		*tree[2];
+	u64				handle;
+	u8				genmask:2,
+					commit_update:1;
+	u32				use;
+};
+
 /**
  *	struct nft_traceinfo - nft tracing information and state
  *
@@ -1607,6 +1633,13 @@ struct nft_trans_flowtable {
 #define nft_trans_flowtable_flags(trans)	\
 	(((struct nft_trans_flowtable *)trans->data)->flags)
 
+struct nft_trans_strset {
+	struct nft_strset		*strset;
+};
+
+#define nft_trans_strset(trans)	\
+	(((struct nft_trans_strset *)trans->data)->strset)
+
 int __init nft_chain_filter_init(void);
 void nft_chain_filter_fini(void);
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 466fd3f4447c..d7a668199611 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -124,6 +124,12 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_NEWSTRSET,
+	NFT_MSG_DELSTRSET,
+	NFT_MSG_GETSTRSET,
+	NFT_MSG_NEWSTRING,
+	NFT_MSG_DELSTRING,
+	NFT_MSG_GETSTRING,
 	NFT_MSG_MAX,
 };
 
@@ -1672,6 +1678,39 @@ enum nft_flowtable_hook_attributes {
 };
 #define NFTA_FLOWTABLE_HOOK_MAX	(__NFTA_FLOWTABLE_HOOK_MAX - 1)
 
+/**
+ * enum nft_strset_hook_attributes - nf_tables string set netlink attributes
+ *
+ * @NFTA_STRSET_TABLE: table name (NLA_STRING)
+ * @NFTA_STRSET_NAME: string set name (NLA_STRING)
+ * @NFTA_STRSET_LIST: list of string elements (NLA_NESTED)
+ * @NFTA_STRSET_HANDLE: string set handle (NLA_U64)
+ * @NFTA_STRSET_USE: use reference counter (NLA_U32)
+ */
+enum nft_strset_hook_attributes {
+	NFTA_STRSET_UNSPEC,
+	NFTA_STRSET_TABLE,
+	NFTA_STRSET_NAME,
+	NFTA_STRSET_LIST,
+	NFTA_STRSET_HANDLE,
+	NFTA_STRSET_USE,
+	NFTA_STRSET_PAD,
+	__NFTA_STRSET_MAX
+};
+#define NFTA_STRSET_MAX	(__NFTA_STRSET_MAX - 1)
+
+/**
+ * enum nft_string_hook_attributes - nf_tables string netlink attributes
+ *
+ * @NFTA_STRING: string (NLA_STRING)
+ */
+enum nft_string_hook_attributes {
+	NFTA_STRING_UNSPEC,
+	NFTA_STRING,
+	__NFTA_STRING_MAX
+};
+#define NFTA_STRING_MAX	(__NFTA_STRING_MAX - 1)
+
 /**
  * enum nft_osf_attributes - nftables osf expression netlink attributes
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 646d5fd53604..736bdf6b9671 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -20,6 +20,7 @@
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
+#include <net/netfilter/ahocorasick.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 
@@ -566,6 +567,24 @@ static int nft_delflowtable(struct nft_ctx *ctx,
 	return err;
 }
 
+static int nft_delstrset(struct nft_ctx *ctx, struct nft_strset *strset)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSTRSET,
+				    sizeof(struct nft_trans_strset),
+				    GFP_KERNEL);
+	if (!trans)
+		return -ENOMEM;
+
+	nft_deactivate_next(ctx->net, strset);
+	ctx->table->use--;
+	nft_trans_strset(trans) = strset;
+	nft_trans_commit_list_add_tail(ctx->net, trans);
+
+	return 0;
+}
+
 static void __nft_reg_track_clobber(struct nft_regs_track *track, u8 dreg)
 {
 	int i;
@@ -1232,6 +1251,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
+	INIT_LIST_HEAD(&table->strsets);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++table_handle;
@@ -1260,6 +1280,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 static int nft_flush_table(struct nft_ctx *ctx)
 {
 	struct nft_flowtable *flowtable, *nft;
+	struct nft_strset *strset, *nst;
 	struct nft_chain *chain, *nc;
 	struct nft_object *obj, *ne;
 	struct nft_set *set, *ns;
@@ -1301,6 +1322,15 @@ static int nft_flush_table(struct nft_ctx *ctx)
 			goto out;
 	}
 
+	list_for_each_entry_safe(strset, nst, &ctx->table->strsets, list) {
+		if (!nft_is_active_next(ctx->net, strset))
+			continue;
+
+		err = nft_delstrset(ctx, strset);
+		if (err < 0)
+			goto out;
+	}
+
 	list_for_each_entry_safe(obj, ne, &ctx->table->objects, list) {
 		if (!nft_is_active_next(ctx->net, obj))
 			continue;
@@ -8074,225 +8104,999 @@ static struct notifier_block nf_tables_flowtable_notifier = {
 	.notifier_call	= nf_tables_flowtable_event,
 };
 
-static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
-				 int event)
-{
-	struct nlmsghdr *nlh = nlmsg_hdr(skb);
-	struct sk_buff *skb2;
-	int err;
+/*
+ * String set
+ */
 
-	if (!nlmsg_report(nlh) &&
-	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
-		return;
+static const struct nla_policy nft_strset_policy[NFTA_STRSET_MAX + 1] = {
+	[NFTA_STRSET_TABLE]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
+	[NFTA_STRSET_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
+	[NFTA_STRSET_LIST]	= { .type = NLA_NESTED },
+	[NFTA_STRSET_HANDLE]	= { .type = NLA_U64 },
+};
 
-	skb2 = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
-	if (skb2 == NULL)
-		goto err;
+static struct nft_strset *nft_strset_lookup(const struct net *net,
+					    struct nft_table *table,
+					    const struct nlattr *nla,
+					    u8 genmask)
+{
+	struct nft_strset *strset;
 
-	err = nf_tables_fill_gen_info(skb2, net, NETLINK_CB(skb).portid,
-				      nlh->nlmsg_seq);
-	if (err < 0) {
-		kfree_skb(skb2);
-		goto err;
+	if (nla == NULL)
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry_rcu(strset, &table->strsets, list,
+				lockdep_is_held(&nft_net->commit_mutex)) {
+		if (!nla_strcmp(nla, strset->name) &&
+		    nft_active_genmask(strset, genmask))
+			return strset;
 	}
 
-	nfnetlink_send(skb2, net, NETLINK_CB(skb).portid, NFNLGRP_NFTABLES,
-		       nlmsg_report(nlh), GFP_KERNEL);
-	return;
-err:
-	nfnetlink_set_err(net, NETLINK_CB(skb).portid, NFNLGRP_NFTABLES,
-			  -ENOBUFS);
+	return ERR_PTR(-ENOENT);
 }
 
-static int nf_tables_getgen(struct sk_buff *skb, const struct nfnl_info *info,
-			    const struct nlattr * const nla[])
+static struct nft_strset *
+nft_strset_lookup_byhandle(const struct nft_table *table, u64 handle, u8 genmask)
 {
-	struct sk_buff *skb2;
-	int err;
-
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
-	if (skb2 == NULL)
-		return -ENOMEM;
-
-	err = nf_tables_fill_gen_info(skb2, info->net, NETLINK_CB(skb).portid,
-				      info->nlh->nlmsg_seq);
-	if (err < 0)
-		goto err_fill_gen_info;
+	struct nft_strset *strset;
 
-	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
+	list_for_each_entry(strset, &table->strsets, list) {
+		if (strset->handle == handle &&
+		    nft_active_genmask(strset, genmask))
+			return strset;
+	}
 
-err_fill_gen_info:
-	kfree_skb(skb2);
-	return err;
+	return ERR_PTR(-ENOENT);
 }
 
-static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
-	[NFT_MSG_NEWTABLE] = {
-		.call		= nf_tables_newtable,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_TABLE_MAX,
-		.policy		= nft_table_policy,
-	},
-	[NFT_MSG_GETTABLE] = {
-		.call		= nf_tables_gettable,
-		.type		= NFNL_CB_RCU,
-		.attr_count	= NFTA_TABLE_MAX,
-		.policy		= nft_table_policy,
-	},
-	[NFT_MSG_DELTABLE] = {
-		.call		= nf_tables_deltable,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_TABLE_MAX,
-		.policy		= nft_table_policy,
-	},
-	[NFT_MSG_NEWCHAIN] = {
-		.call		= nf_tables_newchain,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_CHAIN_MAX,
-		.policy		= nft_chain_policy,
-	},
-	[NFT_MSG_GETCHAIN] = {
-		.call		= nf_tables_getchain,
-		.type		= NFNL_CB_RCU,
-		.attr_count	= NFTA_CHAIN_MAX,
-		.policy		= nft_chain_policy,
-	},
-	[NFT_MSG_DELCHAIN] = {
-		.call		= nf_tables_delchain,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_CHAIN_MAX,
-		.policy		= nft_chain_policy,
-	},
-	[NFT_MSG_NEWRULE] = {
-		.call		= nf_tables_newrule,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_RULE_MAX,
-		.policy		= nft_rule_policy,
-	},
-	[NFT_MSG_GETRULE] = {
-		.call		= nf_tables_getrule,
-		.type		= NFNL_CB_RCU,
-		.attr_count	= NFTA_RULE_MAX,
-		.policy		= nft_rule_policy,
-	},
-	[NFT_MSG_DELRULE] = {
-		.call		= nf_tables_delrule,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_RULE_MAX,
-		.policy		= nft_rule_policy,
-	},
-	[NFT_MSG_NEWSET] = {
-		.call		= nf_tables_newset,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_SET_MAX,
-		.policy		= nft_set_policy,
-	},
-	[NFT_MSG_GETSET] = {
-		.call		= nf_tables_getset,
-		.type		= NFNL_CB_RCU,
-		.attr_count	= NFTA_SET_MAX,
-		.policy		= nft_set_policy,
-	},
-	[NFT_MSG_DELSET] = {
-		.call		= nf_tables_delset,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_SET_MAX,
-		.policy		= nft_set_policy,
-	},
-	[NFT_MSG_NEWSETELEM] = {
-		.call		= nf_tables_newsetelem,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
-		.policy		= nft_set_elem_list_policy,
-	},
-	[NFT_MSG_GETSETELEM] = {
-		.call		= nf_tables_getsetelem,
-		.type		= NFNL_CB_RCU,
-		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
-		.policy		= nft_set_elem_list_policy,
-	},
-	[NFT_MSG_DELSETELEM] = {
-		.call		= nf_tables_delsetelem,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
-		.policy		= nft_set_elem_list_policy,
-	},
-	[NFT_MSG_GETGEN] = {
-		.call		= nf_tables_getgen,
-		.type		= NFNL_CB_RCU,
-	},
-	[NFT_MSG_NEWOBJ] = {
-		.call		= nf_tables_newobj,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_OBJ_MAX,
-		.policy		= nft_obj_policy,
-	},
-	[NFT_MSG_GETOBJ] = {
-		.call		= nf_tables_getobj,
-		.type		= NFNL_CB_RCU,
-		.attr_count	= NFTA_OBJ_MAX,
-		.policy		= nft_obj_policy,
-	},
-	[NFT_MSG_DELOBJ] = {
-		.call		= nf_tables_delobj,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_OBJ_MAX,
-		.policy		= nft_obj_policy,
-	},
-	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj,
-		.type		= NFNL_CB_RCU,
-		.attr_count	= NFTA_OBJ_MAX,
-		.policy		= nft_obj_policy,
-	},
-	[NFT_MSG_NEWFLOWTABLE] = {
-		.call		= nf_tables_newflowtable,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_FLOWTABLE_MAX,
-		.policy		= nft_flowtable_policy,
-	},
-	[NFT_MSG_GETFLOWTABLE] = {
-		.call		= nf_tables_getflowtable,
-		.type		= NFNL_CB_RCU,
-		.attr_count	= NFTA_FLOWTABLE_MAX,
-		.policy		= nft_flowtable_policy,
-	},
-	[NFT_MSG_DELFLOWTABLE] = {
-		.call		= nf_tables_delflowtable,
-		.type		= NFNL_CB_BATCH,
-		.attr_count	= NFTA_FLOWTABLE_MAX,
-		.policy		= nft_flowtable_policy,
-	},
-};
-
-static int nf_tables_validate(struct net *net)
+static int nf_tables_newstrset(struct sk_buff *skb, const struct nfnl_info *info,
+			       const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	struct net *net = info->net;
+	struct nft_strset *strset;
+	const struct nlattr *attr;
 	struct nft_table *table;
+	struct nft_trans *trans;
+	struct ac_tree *tree;
+	struct nft_ctx ctx;
+	int err;
 
-	switch (nft_net->validate_state) {
-	case NFT_VALIDATE_SKIP:
-		break;
-	case NFT_VALIDATE_NEED:
-		nft_validate_state_update(net, NFT_VALIDATE_DO);
-		fallthrough;
-	case NFT_VALIDATE_DO:
-		list_for_each_entry(table, &nft_net->tables, list) {
-			if (nft_table_validate(net, table) < 0)
-				return -EAGAIN;
+	lockdep_assert_held(&nft_net->commit_mutex);
+
+	table = nft_table_lookup(net, nla[NFTA_STRSET_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_STRSET_TABLE]);
+		return PTR_ERR(table);
+	}
+
+	if (nla[NFTA_STRSET_NAME]) {
+		attr = nla[NFTA_STRSET_NAME];
+		strset = nft_strset_lookup(net, table, attr, genmask);
+		if (IS_ERR(strset)) {
+			if (PTR_ERR(strset) != -ENOENT) {
+				NL_SET_BAD_ATTR(extack, attr);
+				return PTR_ERR(strset);
+			}
+			strset = NULL;
 		}
-		break;
+	} else {
+		return -EINVAL;
 	}
 
-	return 0;
-}
+	if (strset != NULL) {
+		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
+			NL_SET_BAD_ATTR(extack, attr);
+			return -EEXIST;
+		}
+		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
+			return -EOPNOTSUPP;
 
-/* a drop policy has to be deferred until all rules have been activated,
- * otherwise a large ruleset that contains a drop-policy base chain will
- * cause all packets to get dropped until the full transaction has been
- * processed.
- *
- * We defer the drop policy until the transaction has been finalized.
+		return 0;
+	}
+
+	strset = kmalloc(sizeof(*strset), GFP_KERNEL_ACCOUNT);
+	if (!strset)
+		return -ENOMEM;
+
+	strset->use = 0;
+	strset->table = table;
+
+	strset->name = nla_strdup(nla[NFTA_STRSET_NAME], GFP_KERNEL_ACCOUNT);
+	if (!strset->name) {
+		err = -ENOMEM;
+		goto err_name;
+	}
+
+	tree = ac_create();
+	if (!tree) {
+		err = -ENOMEM;
+		goto err_ac_create;
+	}
+	RCU_INIT_POINTER(strset->tree[0], tree);
+	RCU_INIT_POINTER(strset->tree[1], tree);
+
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+
+	trans = nft_trans_alloc_gfp(&ctx, NFT_MSG_NEWSTRSET,
+				    sizeof(struct nft_trans_strset),
+				    GFP_KERNEL);
+	if (!trans) {
+		err = -ENOMEM;
+		goto err_trans_alloc;
+	}
+
+	nft_trans_strset(trans) = strset;
+	nft_activate_next(info->net, strset);
+	nft_trans_commit_list_add_tail(info->net, trans);
+
+	list_add_tail_rcu(&strset->list, &table->strsets);
+	table->use++;
+
+	return 0;
+
+err_trans_alloc:
+	ac_destroy(tree);
+err_ac_create:
+	kfree(strset->name);
+err_name:
+	kfree(strset);
+
+	return err;
+}
+
+static int nft_strset_fill_info(struct sk_buff *skb, struct net *net,
+				u32 portid, u32 seq, int event, u32 flags,
+				int family, const struct nft_strset *strset)
+{
+	struct nlmsghdr *nlh;
+
+	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
+	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
+			   NFNETLINK_V0, nft_base_seq(net));
+	if (!nlh)
+		goto nla_put_failure;
+
+	if (nla_put_string(skb, NFTA_STRSET_TABLE, strset->table->name) ||
+	    nla_put_string(skb, NFTA_STRSET_NAME, strset->name) ||
+	    nla_put_be32(skb, NFTA_STRSET_USE, htonl(strset->use)) ||
+	    nla_put_be64(skb, NFTA_STRSET_HANDLE, cpu_to_be64(strset->handle),
+			 NFTA_STRSET_PAD))
+		goto nla_put_failure;
+
+	nlmsg_end(skb, nlh);
+
+	return 0;
+
+nla_put_failure:
+	nlmsg_trim(skb, nlh);
+	return -1;
+}
+
+static int nf_tables_dump_strsets(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	unsigned int idx = 0, s_idx = cb->args[0];
+	struct net *net = sock_net(skb->sk);
+	int family = nfmsg->nfgen_family;
+	struct nftables_pernet *nft_net;
+	struct nft_strset *strset;
+	struct nft_table *table;
+
+	rcu_read_lock();
+	nft_net = nft_pernet(net);
+	list_for_each_entry_rcu(table, &nft_net->tables, list) {
+		if (family != NFPROTO_UNSPEC && family != table->family)
+			continue;
+		list_for_each_entry_rcu(strset, &table->strsets, list) {
+			if (idx < s_idx)
+				goto cont;
+			if (idx > s_idx)
+				memset(&cb->args[1], 0,
+				       sizeof(cb->args) - sizeof(cb->args[0]));
+			if (!nft_is_active(net, strset))
+				continue;
+			if (nft_strset_fill_info(skb, net, NETLINK_CB(cb->skb).portid,
+						 cb->nlh->nlmsg_seq, NFT_MSG_NEWSTRSET, 0,
+						 table->family, strset) < 0)
+				goto done;
+cont:
+			idx++;
+		}
+	}
+done:
+	rcu_read_unlock();
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+static int nf_tables_getstrset(struct sk_buff *skb, const struct nfnl_info *info,
+			       const struct nlattr * const nla[])
+{
+	if (nla[NFTA_STRSET_TABLE] ||
+	    nla[NFTA_STRSET_NAME] ||
+	    nla[NFTA_STRSET_HANDLE])
+		return -EOPNOTSUPP;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.dump = nf_tables_dump_strsets,
+			.module = THIS_MODULE,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static void nft_strset_destroy(struct nft_ctx *ctx, struct nft_strset *strset)
+{
+	struct ac_tree *tree_0, *tree_1;
+
+	tree_0 = rcu_dereference_protected(strset->tree[0],
+					   lockdep_commit_lock_is_held(ctx->net));
+	tree_1 = rcu_dereference_protected(strset->tree[1],
+					   lockdep_commit_lock_is_held(ctx->net));
+	ac_destroy(tree_0);
+	ac_destroy(tree_1);
+	kfree(strset->name);
+	kfree(strset);
+}
+
+static int nf_tables_delstrset(struct sk_buff *skb, const struct nfnl_info *info,
+			       const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	struct net *net = info->net;
+	struct nft_strset *strset;
+	const struct nlattr *attr;
+	struct nft_table *table;
+	struct nft_ctx ctx;
+	u64 handle = 0;
+
+	lockdep_assert_held(&nft_net->commit_mutex);
+
+	table = nft_table_lookup(net, nla[NFTA_STRSET_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_STRSET_TABLE]);
+		return PTR_ERR(table);
+	}
+
+	if (nla[NFTA_STRSET_HANDLE]) {
+		attr = nla[NFTA_STRSET_HANDLE];
+		handle = be64_to_cpu(nla_get_be64(attr));
+		strset = nft_strset_lookup_byhandle(table, handle, genmask);
+	} else if (nla[NFTA_STRSET_NAME]) {
+		attr = nla[NFTA_STRSET_NAME];
+		strset = nft_strset_lookup(net, table, attr, genmask);
+	} else
+		return -EINVAL;
+
+	if (IS_ERR(strset)) {
+		NL_SET_BAD_ATTR(extack, attr);
+		return PTR_ERR(strset);
+	}
+
+	if (strset->use > 0) {
+		NL_SET_BAD_ATTR(extack, attr);
+		return -EBUSY;
+	}
+
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+
+	return nft_delstrset(&ctx, strset);
+}
+
+static const struct nla_policy nft_string_policy[NFTA_STRING_MAX + 1] = {
+	[NFTA_STRING]		= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
+};
+
+static struct nlattr *nft_parse_string(struct nlattr *attr)
+{
+	struct nlattr *tb[NFTA_STRING_MAX + 1];
+	int err;
+
+	err = nla_parse_nested_deprecated(tb, NFTA_STRING_MAX, attr,
+					  nft_string_policy, NULL);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	if (!tb[NFTA_STRING])
+		return ERR_PTR(-EINVAL);
+
+	return tb[NFTA_STRING];
+}
+
+static int nft_string_add(struct nft_ctx *ctx, struct nft_strset *strset,
+			  const struct nlattr *attr,
+			  struct netlink_ext_ack *extack, bool create)
+{
+	u8 next_genbit = nft_gencursor_next(ctx->net);
+	struct nlattr *tmp, *str;
+	struct ac_tree *tree;
+	int err, rem;
+
+	nla_for_each_nested(tmp, attr, rem) {
+		err = -EINVAL;
+		if (nla_type(tmp) != NFTA_LIST_ELEM)
+			return err;
+
+		str = nft_parse_string(tmp);
+		if (IS_ERR(str)) {
+			NL_SET_BAD_ATTR(extack, tmp);
+			return PTR_ERR(str);
+		}
+
+		tree = rcu_dereference_protected(strset->tree[next_genbit],
+						 lockdep_commit_lock_is_held(ctx->net));
+
+		err = ac_add(tree, nla_data(str), nla_len(str), create);
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, tmp);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int nf_tables_newstr(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	u8 next_genbit = nft_gencursor_next(info->net);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 cur_genbit = info->net->nft.gencursor;
+	u8 genmask = nft_genmask_next(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	struct ac_tree *tree, *clone;
+	struct net *net = info->net;
+	const struct nlattr *attr;
+	struct nft_strset *strset;
+	struct nft_trans *trans;
+	struct nft_table *table;
+	struct nft_ctx ctx;
+	u64 handle = 0;
+
+	lockdep_assert_held(&nft_net->commit_mutex);
+
+	table = nft_table_lookup(net, nla[NFTA_STRSET_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_STRSET_TABLE]);
+		return PTR_ERR(table);
+	}
+
+	if (nla[NFTA_STRSET_HANDLE]) {
+		attr = nla[NFTA_STRSET_HANDLE];
+		handle = be64_to_cpu(nla_get_be64(attr));
+		strset = nft_strset_lookup_byhandle(table, handle, genmask);
+	} else if (nla[NFTA_STRSET_NAME]) {
+		attr = nla[NFTA_STRSET_NAME];
+		strset = nft_strset_lookup(net, table, attr, genmask);
+	} else
+		return -EINVAL;
+
+	if (IS_ERR(strset)) {
+		NL_SET_BAD_ATTR(extack, attr);
+		return PTR_ERR(strset);
+	}
+
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, NULL);
+
+	if (!strset->commit_update) {
+		tree = rcu_dereference_protected(strset->tree[cur_genbit],
+						 lockdep_commit_lock_is_held(net));
+		clone = ac_clone(tree);
+		if (!clone)
+			return -ENOMEM;
+
+		rcu_assign_pointer(strset->tree[next_genbit], clone);
+		strset->commit_update = 1;
+
+		trans = nft_trans_alloc_gfp(&ctx, NFT_MSG_NEWSTRING,
+					    sizeof(struct nft_trans_strset),
+					    GFP_KERNEL);
+		if (!trans) {
+			ac_destroy(clone);
+			return -ENOMEM;
+		}
+
+		nft_trans_strset(trans) = strset;
+		nft_trans_commit_list_add_tail(net, trans);
+	}
+
+	return nft_string_add(&ctx, strset, nla[NFTA_STRSET_LIST],
+			      extack, info->nlh->nlmsg_flags & NLM_F_EXCL);
+}
+
+static int nft_string_del(struct nft_ctx *ctx, struct nft_strset *strset,
+			  const struct nlattr *attr,
+			  struct netlink_ext_ack *extack)
+{
+	u8 next_genbit = nft_gencursor_next(ctx->net);
+	struct nlattr *tmp, *str;
+	struct ac_tree *tree;
+	int err, rem;
+
+	nla_for_each_nested(tmp, attr, rem) {
+		err = -EINVAL;
+		if (nla_type(tmp) != NFTA_LIST_ELEM)
+			return err;
+
+		str = nft_parse_string(tmp);
+		if (IS_ERR(str)) {
+			NL_SET_BAD_ATTR(extack, tmp);
+			return err;
+		}
+
+		err = -E2BIG;
+		if (nla_len(str) == 0 ||
+		    nla_len(str) > AC_MAXLEN) {
+			NL_SET_BAD_ATTR(extack, str);
+			return err;
+		}
+
+		tree = rcu_dereference_protected(strset->tree[next_genbit],
+						 lockdep_commit_lock_is_held(ctx->net));
+		ac_del(tree, nla_data(str), nla_len(str));
+	}
+
+	return 0;
+}
+
+static int nf_tables_delstr(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	u8 next_genbit = nft_gencursor_next(info->net);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 cur_genbit = info->net->nft.gencursor;
+	u8 genmask = nft_genmask_next(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	struct ac_tree *tree, *clone;
+	struct net *net = info->net;
+	const struct nlattr *attr;
+	struct nft_strset *strset;
+	struct nft_trans *trans;
+	struct nft_table *table;
+	struct nft_ctx ctx;
+	u64 handle = 0;
+
+	lockdep_assert_held(&nft_net->commit_mutex);
+
+	table = nft_table_lookup(net, nla[NFTA_STRSET_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_STRSET_TABLE]);
+		return PTR_ERR(table);
+	}
+
+	if (nla[NFTA_STRSET_HANDLE]) {
+		attr = nla[NFTA_STRSET_HANDLE];
+		handle = be64_to_cpu(nla_get_be64(attr));
+		strset = nft_strset_lookup_byhandle(table, handle, genmask);
+	} else if (nla[NFTA_STRSET_NAME]) {
+		attr = nla[NFTA_STRSET_NAME];
+		strset = nft_strset_lookup(net, table, attr, genmask);
+	} else
+		return -EINVAL;
+
+	if (IS_ERR(strset)) {
+		NL_SET_BAD_ATTR(extack, attr);
+		return PTR_ERR(strset);
+	}
+
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, NULL);
+
+	if (!strset->commit_update) {
+		tree = rcu_dereference_protected(strset->tree[cur_genbit],
+						 lockdep_commit_lock_is_held(net));
+		clone = ac_clone(tree);
+		if (!clone)
+			return -ENOMEM;
+
+		rcu_assign_pointer(strset->tree[next_genbit], clone);
+		strset->commit_update = 1;
+
+		trans = nft_trans_alloc_gfp(&ctx, NFT_MSG_DELSTRING,
+					    sizeof(struct nft_trans_strset),
+					    GFP_KERNEL);
+		if (!trans) {
+			ac_destroy(clone);
+			return -ENOMEM;
+		}
+
+		nft_trans_strset(trans) = strset;
+		nft_trans_commit_list_add_tail(net, trans);
+	}
+
+	return nft_string_del(&ctx, strset, nla[NFTA_STRSET_LIST], extack);
+}
+
+struct nft_strset_dump_ctx {
+	const struct nft_strset	*strset;
+	struct ac_iter		*iter;
+	struct nft_ctx		ctx;
+	u32			genid;
+};
+
+static int nf_tables_dump_str_start(struct netlink_callback *cb)
+{
+	struct nft_strset_dump_ctx *dump_ctx = cb->data;
+	struct net *net = sock_net(cb->skb->sk);
+	struct nftables_pernet *nft_net;
+	struct ac_tree *tree;
+	struct ac_iter *iter;
+	u8 cur_genbit;
+
+	cur_genbit = READ_ONCE(net->nft.gencursor);
+
+	tree = rcu_dereference(dump_ctx->strset->tree[cur_genbit]);
+
+	iter = ac_iter_create(tree);
+	if (!iter)
+		return -ENOMEM;
+
+	cb->data = kmemdup(dump_ctx, sizeof(*dump_ctx), GFP_ATOMIC);
+	if (!cb->data) {
+		ac_iter_destroy(iter);
+		return -ENOMEM;
+	}
+
+	nft_net = nft_pernet(net);
+
+	dump_ctx = cb->data;
+	dump_ctx->iter = iter;
+	dump_ctx->genid = nft_net->base_seq;
+
+	return 0;
+}
+
+static int nf_tables_dump_str_done(struct netlink_callback *cb)
+{
+	struct nft_strset_dump_ctx *dump_ctx = cb->data;
+
+	ac_iter_destroy(dump_ctx->iter);
+	kfree(dump_ctx);
+
+	return 0;
+}
+
+static int nft_iter_str_cb(const char *string, void *data)
+{
+	struct sk_buff *skb = data;
+	unsigned char *b = skb_tail_pointer(skb);
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, NFTA_LIST_ELEM);
+	if (!nest)
+		goto nla_put_failure;
+
+	if (nla_put_string(skb, NFTA_STRING, string))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+
+	return 1;
+
+nla_put_failure:
+	nlmsg_trim(skb, b);
+
+	return -1;
+}
+
+static int nft_string_fill_info(struct net *net, struct sk_buff *skb,
+				const struct nft_table *table,
+				const struct nft_strset *strset,
+				struct nft_strset_dump_ctx *dump_ctx,
+				struct netlink_callback *cb)
+{
+	struct nlmsghdr *nlh;
+	struct nlattr *nest;
+	u32 portid, seq;
+	int event, ret;
+
+	event  = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWSTRING);
+	portid = NETLINK_CB(cb->skb).portid;
+	seq    = cb->nlh->nlmsg_seq;
+
+	nlh = nfnl_msg_put(skb, portid, seq, event, NLM_F_MULTI,
+			   table->family, NFNETLINK_V0, nft_base_seq(net));
+	if (!nlh)
+		goto nla_put_failure;
+
+	if (nla_put_string(skb, NFTA_STRSET_TABLE, table->name))
+		goto nla_put_failure;
+	if (nla_put_string(skb, NFTA_STRSET_NAME, strset->name))
+		goto nla_put_failure;
+
+	nest = nla_nest_start_noflag(skb, NFTA_STRSET_LIST);
+	if (nest == NULL)
+		goto nla_put_failure;
+
+	ret = ac_iterate(dump_ctx->iter, nft_iter_str_cb, skb);
+
+	nla_nest_end(skb, nest);
+	nlmsg_end(skb, nlh);
+
+	return ret;
+
+nla_put_failure:
+	nlmsg_trim(skb, nlh);
+
+	return -1;
+}
+
+static int nf_tables_dump_str(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct nft_strset_dump_ctx *dump_ctx = cb->data;
+	struct net *net = sock_net(skb->sk);
+	struct nftables_pernet *nft_net;
+	bool strset_found = false;
+	struct nft_strset *strset;
+	struct nft_table *table;
+	int ret;
+
+	if (cb->args[0])
+		return 0;
+
+	rcu_read_lock();
+	nft_net = nft_pernet(net);
+	if (dump_ctx->genid != READ_ONCE(nft_net->base_seq)) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	list_for_each_entry_rcu(table, &nft_net->tables, list) {
+		if (dump_ctx->ctx.family != NFPROTO_UNSPEC &&
+		    dump_ctx->ctx.family != table->family)
+			continue;
+
+		if (table != dump_ctx->ctx.table)
+			continue;
+
+		list_for_each_entry_rcu(strset, &table->strsets, list) {
+			if (strset == dump_ctx->strset) {
+				strset_found = true;
+				break;
+			}
+		}
+		break;
+	}
+
+	if (!strset_found) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
+
+	ret = nft_string_fill_info(net, skb, table, strset, dump_ctx, cb);
+	if (ret == 1)
+		cb->args[0] = 1;
+
+	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+
+	rcu_read_unlock();
+
+	return skb->len;
+}
+
+static int nf_tables_getstr(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
+{
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_cur(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	struct nft_strset_dump_ctx dump_ctx;
+	struct net *net = info->net;
+	struct nft_strset *strset;
+	struct nft_table *table;
+	struct nft_ctx ctx;
+
+	if (!nla[NFTA_STRSET_TABLE] ||
+	    !nla[NFTA_STRSET_NAME])
+		return -EINVAL;
+
+	table = nft_table_lookup(net, nla[NFTA_STRSET_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
+	if (!table) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_STRSET_TABLE]);
+		return PTR_ERR(table);
+	}
+
+	strset = nft_strset_lookup(net, table, nla[NFTA_STRSET_NAME], genmask);
+	if (IS_ERR(strset)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_STRSET_HANDLE]);
+		return PTR_ERR(strset);
+	}
+
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, NULL);
+
+	dump_ctx.ctx = ctx;
+	dump_ctx.strset = strset;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dump_str_start,
+			.dump = nf_tables_dump_str,
+			.done = nf_tables_dump_str_done,
+			.data = &dump_ctx,
+			.module = THIS_MODULE,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	return 0;
+}
+
+static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
+				 int event)
+{
+	struct nlmsghdr *nlh = nlmsg_hdr(skb);
+	struct sk_buff *skb2;
+	int err;
+
+	if (!nlmsg_report(nlh) &&
+	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
+		return;
+
+	skb2 = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (skb2 == NULL)
+		goto err;
+
+	err = nf_tables_fill_gen_info(skb2, net, NETLINK_CB(skb).portid,
+				      nlh->nlmsg_seq);
+	if (err < 0) {
+		kfree_skb(skb2);
+		goto err;
+	}
+
+	nfnetlink_send(skb2, net, NETLINK_CB(skb).portid, NFNLGRP_NFTABLES,
+		       nlmsg_report(nlh), GFP_KERNEL);
+	return;
+err:
+	nfnetlink_set_err(net, NETLINK_CB(skb).portid, NFNLGRP_NFTABLES,
+			  -ENOBUFS);
+}
+
+static int nf_tables_getgen(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
+{
+	struct sk_buff *skb2;
+	int err;
+
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (skb2 == NULL)
+		return -ENOMEM;
+
+	err = nf_tables_fill_gen_info(skb2, info->net, NETLINK_CB(skb).portid,
+				      info->nlh->nlmsg_seq);
+	if (err < 0)
+		goto err_fill_gen_info;
+
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
+
+err_fill_gen_info:
+	kfree_skb(skb2);
+	return err;
+}
+
+static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
+	[NFT_MSG_NEWTABLE] = {
+		.call		= nf_tables_newtable,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_TABLE_MAX,
+		.policy		= nft_table_policy,
+	},
+	[NFT_MSG_GETTABLE] = {
+		.call		= nf_tables_gettable,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_TABLE_MAX,
+		.policy		= nft_table_policy,
+	},
+	[NFT_MSG_DELTABLE] = {
+		.call		= nf_tables_deltable,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_TABLE_MAX,
+		.policy		= nft_table_policy,
+	},
+	[NFT_MSG_NEWCHAIN] = {
+		.call		= nf_tables_newchain,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_CHAIN_MAX,
+		.policy		= nft_chain_policy,
+	},
+	[NFT_MSG_GETCHAIN] = {
+		.call		= nf_tables_getchain,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_CHAIN_MAX,
+		.policy		= nft_chain_policy,
+	},
+	[NFT_MSG_DELCHAIN] = {
+		.call		= nf_tables_delchain,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_CHAIN_MAX,
+		.policy		= nft_chain_policy,
+	},
+	[NFT_MSG_NEWRULE] = {
+		.call		= nf_tables_newrule,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_RULE_MAX,
+		.policy		= nft_rule_policy,
+	},
+	[NFT_MSG_GETRULE] = {
+		.call		= nf_tables_getrule,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_RULE_MAX,
+		.policy		= nft_rule_policy,
+	},
+	[NFT_MSG_DELRULE] = {
+		.call		= nf_tables_delrule,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_RULE_MAX,
+		.policy		= nft_rule_policy,
+	},
+	[NFT_MSG_NEWSET] = {
+		.call		= nf_tables_newset,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_SET_MAX,
+		.policy		= nft_set_policy,
+	},
+	[NFT_MSG_GETSET] = {
+		.call		= nf_tables_getset,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_SET_MAX,
+		.policy		= nft_set_policy,
+	},
+	[NFT_MSG_DELSET] = {
+		.call		= nf_tables_delset,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_SET_MAX,
+		.policy		= nft_set_policy,
+	},
+	[NFT_MSG_NEWSETELEM] = {
+		.call		= nf_tables_newsetelem,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
+		.policy		= nft_set_elem_list_policy,
+	},
+	[NFT_MSG_GETSETELEM] = {
+		.call		= nf_tables_getsetelem,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
+		.policy		= nft_set_elem_list_policy,
+	},
+	[NFT_MSG_DELSETELEM] = {
+		.call		= nf_tables_delsetelem,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
+		.policy		= nft_set_elem_list_policy,
+	},
+	[NFT_MSG_GETGEN] = {
+		.call		= nf_tables_getgen,
+		.type		= NFNL_CB_RCU,
+	},
+	[NFT_MSG_NEWOBJ] = {
+		.call		= nf_tables_newobj,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_OBJ_MAX,
+		.policy		= nft_obj_policy,
+	},
+	[NFT_MSG_GETOBJ] = {
+		.call		= nf_tables_getobj,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_OBJ_MAX,
+		.policy		= nft_obj_policy,
+	},
+	[NFT_MSG_DELOBJ] = {
+		.call		= nf_tables_delobj,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_OBJ_MAX,
+		.policy		= nft_obj_policy,
+	},
+	[NFT_MSG_GETOBJ_RESET] = {
+		.call		= nf_tables_getobj,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_OBJ_MAX,
+		.policy		= nft_obj_policy,
+	},
+	[NFT_MSG_NEWFLOWTABLE] = {
+		.call		= nf_tables_newflowtable,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_FLOWTABLE_MAX,
+		.policy		= nft_flowtable_policy,
+	},
+	[NFT_MSG_GETFLOWTABLE] = {
+		.call		= nf_tables_getflowtable,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_FLOWTABLE_MAX,
+		.policy		= nft_flowtable_policy,
+	},
+	[NFT_MSG_DELFLOWTABLE] = {
+		.call		= nf_tables_delflowtable,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_FLOWTABLE_MAX,
+		.policy		= nft_flowtable_policy,
+	},
+	[NFT_MSG_NEWSTRSET] = {
+		.call		= nf_tables_newstrset,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_STRSET_MAX,
+		.policy		= nft_strset_policy,
+	},
+	[NFT_MSG_GETSTRSET] = {
+		.call		= nf_tables_getstrset,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_STRSET_MAX,
+		.policy		= nft_strset_policy,
+	},
+	[NFT_MSG_DELSTRSET] = {
+		.call		= nf_tables_delstrset,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_STRSET_MAX,
+		.policy		= nft_strset_policy,
+	},
+	[NFT_MSG_NEWSTRING] = {
+		.call		= nf_tables_newstr,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_STRSET_MAX,
+		.policy		= nft_strset_policy,
+	},
+	[NFT_MSG_GETSTRING] = {
+		.call		= nf_tables_getstr,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_STRSET_MAX,
+		.policy		= nft_strset_policy,
+	},
+	[NFT_MSG_DELSTRING] = {
+		.call		= nf_tables_delstr,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_STRSET_MAX,
+		.policy		= nft_strset_policy,
+	},
+};
+
+static int nf_tables_validate(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_table *table;
+
+	switch (nft_net->validate_state) {
+	case NFT_VALIDATE_SKIP:
+		break;
+	case NFT_VALIDATE_NEED:
+		nft_validate_state_update(net, NFT_VALIDATE_DO);
+		fallthrough;
+	case NFT_VALIDATE_DO:
+		list_for_each_entry(table, &nft_net->tables, list) {
+			if (nft_table_validate(net, table) < 0)
+				return -EAGAIN;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+/* a drop policy has to be deferred until all rules have been activated,
+ * otherwise a large ruleset that contains a drop-policy base chain will
+ * cause all packets to get dropped until the full transaction has been
+ * processed.
+ *
+ * We defer the drop policy until the transaction has been finalized.
  */
 static void nft_chain_commit_drop_policy(struct nft_trans *trans)
 {
@@ -8388,6 +9192,9 @@ static void nft_commit_release(struct nft_trans *trans)
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
+	case NFT_MSG_DELSTRSET:
+		nft_strset_destroy(&trans->ctx, nft_trans_strset(trans));
+		break;
 	}
 
 	if (trans->put_net)
@@ -8588,6 +9395,54 @@ static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 		nf_tables_commit_chain_free_rules_old(g0);
 }
 
+static int nft_strset_commit_update(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	u8 next_genbit = nft_gencursor_next(net);
+	struct nft_strset *strset;
+	struct nft_table *table;
+	struct ac_tree *tree;
+	int err;
+
+	list_for_each_entry(table, &nft_net->tables, list) {
+		list_for_each_entry(strset, &table->strsets, list) {
+			tree = rcu_dereference(strset->tree[next_genbit]);
+
+			if (!strset->commit_update) {
+				if (strset->tree[0] != strset->tree[1]) {
+					ac_destroy(tree);
+					rcu_assign_pointer(strset->tree[next_genbit],
+							   strset->tree[!next_genbit]);
+				}
+				continue;
+			}
+
+			err = ac_resolve_fail(tree);
+			if (err < 0)
+				return err;
+
+			strset->commit_update = 0;
+		}
+	}
+
+	return 0;
+}
+
+static void nft_strset_abort_update(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_strset *strset;
+	struct nft_table *table;
+
+	list_for_each_entry(table, &nft_net->tables, list) {
+		list_for_each_entry(strset, &table->strsets, list) {
+			if (!strset->commit_update)
+				continue;
+		}
+		strset->commit_update = 0;
+	}
+}
+
 static void nft_obj_del(struct nft_object *obj)
 {
 	rhltable_remove(&nft_objname_ht, &obj->rhlhead, nft_objname_ht_params);
@@ -8766,6 +9621,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	if (nf_tables_validate(net) < 0)
 		return -EAGAIN;
 
+	err = nft_strset_commit_update(net);
+	if (err < 0)
+		return err;
+
 	err = nft_flow_rule_offload_commit(net);
 	if (err < 0)
 		return err;
@@ -8966,6 +9825,13 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 						&nft_trans_flowtable(trans)->hook_list);
 			}
 			break;
+		case NFT_MSG_NEWSTRSET:
+			nft_clear(net, nft_trans_strset(trans));
+			nft_trans_destroy(trans);
+			break;
+		case NFT_MSG_DELSTRSET:
+			list_del_rcu(&nft_trans_strset(trans)->list);
+			break;
 		}
 	}
 
@@ -9021,6 +9887,9 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
+	case NFT_MSG_NEWSTRSET:
+		nft_strset_destroy(&trans->ctx, nft_trans_strset(trans));
+		break;
 	}
 	kfree(trans);
 }
@@ -9035,6 +9904,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	    nf_tables_validate(net) < 0)
 		return -EAGAIN;
 
+	nft_strset_abort_update(net);
+
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
 		switch (trans->msg_type) {
@@ -9168,6 +10039,15 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			nft_trans_destroy(trans);
 			break;
+		case NFT_MSG_NEWSTRSET:
+			trans->ctx.table->use--;
+			list_del_rcu(&nft_trans_strset(trans)->list);
+			break;
+		case NFT_MSG_DELSTRSET:
+			trans->ctx.table->use++;
+			nft_clear(trans->ctx.net, nft_trans_strset(trans));
+			nft_trans_destroy(trans);
+			break;
 		}
 	}
 
@@ -9833,6 +10713,7 @@ static void __nft_release_hooks(struct net *net)
 static void __nft_release_table(struct net *net, struct nft_table *table)
 {
 	struct nft_flowtable *flowtable, *nf;
+	struct nft_strset *strset, *nst;
 	struct nft_chain *chain, *nc;
 	struct nft_object *obj, *ne;
 	struct nft_rule *rule, *nr;
@@ -9873,6 +10754,11 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		table->use--;
 		nf_tables_chain_destroy(&ctx);
 	}
+	list_for_each_entry_safe(strset, nst, &table->strsets, list) {
+		list_del(&strset->list);
+		table->use--;
+		nft_strset_destroy(&ctx, strset);
+	}
 	nf_tables_table_destroy(&ctx);
 }
 
-- 
2.30.2

