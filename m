Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B05C77B71
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Apr 2023 15:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjDMPOH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Apr 2023 11:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjDMPOD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2023 11:14:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BDDE67
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2023 08:13:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pmyds-0001rc-Mf; Thu, 13 Apr 2023 17:13:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: nf_tables: make validation state per table
Date:   Thu, 13 Apr 2023 17:13:20 +0200
Message-Id: <20230413151320.16683-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413151320.16683-1-fw@strlen.de>
References: <20230413151320.16683-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We only need to validate tables that saw changes in the current
transaction.

The existing code revalidates all tables, but this isn't needed as
cross-table jumps are not allowed (chains have table scope).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  3 ++-
 net/netfilter/nf_tables_api.c     | 38 +++++++++++++++----------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9430128aae99..a925b3b71506 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1193,6 +1193,7 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
  *	@genmask: generation mask
  *	@afinfo: address family info
  *	@name: name of the table
+ *	@validate_state: internal, set when transaction adds jumps
  */
 struct nft_table {
 	struct list_head		list;
@@ -1211,6 +1212,7 @@ struct nft_table {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
+	u8				validate_state;
 };
 
 static inline bool nft_table_has_owner(const struct nft_table *table)
@@ -1684,7 +1686,6 @@ struct nftables_pernet {
 	struct mutex		commit_mutex;
 	u64			table_handle;
 	unsigned int		base_seq;
-	u8			validate_state;
 };
 
 extern unsigned int nf_tables_net_id;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 201101e0669b..c26673bf3da5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -102,11 +102,9 @@ static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
 	[NFT_MSG_DELFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
 };
 
-static void nft_validate_state_update(struct net *net, u8 new_validate_state)
+static void nft_validate_state_update(struct nft_table *table, u8 new_validate_state)
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
-
-	switch (nft_net->validate_state) {
+	switch (table->validate_state) {
 	case NFT_VALIDATE_SKIP:
 		WARN_ON_ONCE(new_validate_state == NFT_VALIDATE_DO);
 		break;
@@ -117,7 +115,7 @@ static void nft_validate_state_update(struct net *net, u8 new_validate_state)
 			return;
 	}
 
-	nft_net->validate_state = new_validate_state;
+	table->validate_state = new_validate_state;
 }
 static void nf_tables_trans_destroy_work(struct work_struct *w);
 static DECLARE_WORK(trans_destroy_work, nf_tables_trans_destroy_work);
@@ -1224,6 +1222,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (table == NULL)
 		goto err_kzalloc;
 
+	table->validate_state = NFT_VALIDATE_SKIP;
 	table->name = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (table->name == NULL)
 		goto err_strdup;
@@ -3608,7 +3607,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 		}
 
 		if (expr_info[i].ops->validate)
-			nft_validate_state_update(net, NFT_VALIDATE_NEED);
+			nft_validate_state_update(table, NFT_VALIDATE_NEED);
 
 		expr_info[i].ops = NULL;
 		expr = nft_expr_next(expr);
@@ -3658,7 +3657,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (flow)
 		nft_trans_flow_rule(trans) = flow;
 
-	if (nft_net->validate_state == NFT_VALIDATE_DO)
+	if (table->validate_state == NFT_VALIDATE_DO)
 		return nft_table_validate(net, table);
 
 	return 0;
@@ -6265,7 +6264,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			if (desc.type == NFT_DATA_VERDICT &&
 			    (elem.data.val.verdict.code == NFT_GOTO ||
 			     elem.data.val.verdict.code == NFT_JUMP))
-				nft_validate_state_update(ctx->net,
+				nft_validate_state_update(ctx->table,
 							  NFT_VALIDATE_NEED);
 		}
 
@@ -6390,7 +6389,6 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 				const struct nfnl_info *info,
 				const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -6429,7 +6427,7 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 		}
 	}
 
-	if (nft_net->validate_state == NFT_VALIDATE_DO)
+	if (table->validate_state == NFT_VALIDATE_DO)
 		return nft_table_validate(net, table);
 
 	return 0;
@@ -8581,19 +8579,20 @@ static int nf_tables_validate(struct net *net)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_table *table;
 
-	switch (nft_net->validate_state) {
-	case NFT_VALIDATE_SKIP:
-		break;
-	case NFT_VALIDATE_NEED:
-		nft_validate_state_update(net, NFT_VALIDATE_DO);
-		fallthrough;
-	case NFT_VALIDATE_DO:
-		list_for_each_entry(table, &nft_net->tables, list) {
+	list_for_each_entry(table, &nft_net->tables, list) {
+		switch (table->validate_state) {
+		case NFT_VALIDATE_SKIP:
+			continue;
+		case NFT_VALIDATE_NEED:
+			nft_validate_state_update(table, NFT_VALIDATE_DO);
+			fallthrough;
+		case NFT_VALIDATE_DO:
 			if (nft_table_validate(net, table) < 0)
 				return -EAGAIN;
+
+			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
 		}
 
-		nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 		break;
 	}
 
@@ -10310,7 +10309,6 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
 	nft_net->base_seq = 1;
-	nft_net->validate_state = NFT_VALIDATE_SKIP;
 
 	return 0;
 }
-- 
2.39.2

