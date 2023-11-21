Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F619C636F2
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbjKUMN6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbjKUMN5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:13:57 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 643D8131;
        Tue, 21 Nov 2023 04:13:54 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.4 23/26] netfilter: nftables: update table flags from the commit phase
Date:   Tue, 21 Nov 2023 13:13:30 +0100
Message-Id: <20231121121333.294238-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231121121333.294238-1-pablo@netfilter.org>
References: <20231121121333.294238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

commit 0ce7cf4127f14078ca598ba9700d813178a59409 upstream.

Do not update table flags from the preparation phase. Store the flags
update into the transaction, then update the flags from the commit
phase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  9 ++++++---
 net/netfilter/nf_tables_api.c     | 31 ++++++++++++++++---------------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ee86f78bf93e..59dd0845605a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1392,13 +1392,16 @@ struct nft_trans_chain {
 
 struct nft_trans_table {
 	bool				update;
-	bool				enable;
+	u8				state;
+	u32				flags;
 };
 
 #define nft_trans_table_update(trans)	\
 	(((struct nft_trans_table *)trans->data)->update)
-#define nft_trans_table_enable(trans)	\
-	(((struct nft_trans_table *)trans->data)->enable)
+#define nft_trans_table_state(trans)	\
+	(((struct nft_trans_table *)trans->data)->state)
+#define nft_trans_table_flags(trans)	\
+	(((struct nft_trans_table *)trans->data)->flags)
 
 struct nft_trans_elem {
 	struct nft_set			*set;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index afa7aebf75ef..ffe586d8cdcb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -893,6 +893,12 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 	nft_table_disable(net, table, 0);
 }
 
+enum {
+	NFT_TABLE_STATE_UNCHANGED	= 0,
+	NFT_TABLE_STATE_DORMANT,
+	NFT_TABLE_STATE_WAKEUP
+};
+
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
@@ -916,19 +922,17 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
 	if ((flags & NFT_TABLE_F_DORMANT) &&
 	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
-		nft_trans_table_enable(trans) = false;
+		nft_trans_table_state(trans) = NFT_TABLE_STATE_DORMANT;
 	} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 		   ctx->table->flags & NFT_TABLE_F_DORMANT) {
-		ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
 		ret = nf_tables_table_enable(ctx->net, ctx->table);
 		if (ret >= 0)
-			nft_trans_table_enable(trans) = true;
-		else
-			ctx->table->flags |= NFT_TABLE_F_DORMANT;
+			nft_trans_table_state(trans) = NFT_TABLE_STATE_WAKEUP;
 	}
 	if (ret < 0)
 		goto err;
 
+	nft_trans_table_flags(trans) = flags;
 	nft_trans_table_update(trans) = true;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 	return 0;
@@ -7298,11 +7302,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
-				if (!nft_trans_table_enable(trans)) {
-					nf_tables_table_disable(net,
-								trans->ctx.table);
-					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
-				}
+				if (nft_trans_table_state(trans) == NFT_TABLE_STATE_DORMANT)
+					nf_tables_table_disable(net, trans->ctx.table);
+
+				trans->ctx.table->flags = nft_trans_table_flags(trans);
 			} else {
 				nft_clear(net, trans->ctx.table);
 			}
@@ -7497,11 +7500,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
-				if (nft_trans_table_enable(trans)) {
-					nf_tables_table_disable(net,
-								trans->ctx.table);
-					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
-				}
+				if (nft_trans_table_state(trans) == NFT_TABLE_STATE_WAKEUP)
+					nf_tables_table_disable(net, trans->ctx.table);
+
 				nft_trans_destroy(trans);
 			} else {
 				list_del_rcu(&trans->ctx.table->list);
-- 
2.30.2

