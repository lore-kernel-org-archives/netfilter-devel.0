Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BC7C433E6
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 00:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F36164F30
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 00:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhCRAhS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 20:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhCRAgs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 20:36:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C59FC06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 17:36:48 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DC45762BA4
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Mar 2021 01:36:44 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [nf-next,v2] netfilter: nftables: update table flags from the commit phase
Date:   Thu, 18 Mar 2021 01:36:40 +0100
Message-Id: <20210318003640.27468-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not update table flags from the preparation phase. Store the flags
update into the transaction, then update the flags from the commit
phase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: do not update from the flags from the abort path.

 include/net/netfilter/nf_tables.h |  9 ++++++---
 net/netfilter/nf_tables_api.c     | 31 ++++++++++++++++---------------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fdec57d862b7..67bc36f7f4fb 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1498,13 +1498,16 @@ struct nft_trans_chain {
 
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
index 083c112bee0b..bd5e8122ea5e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -900,6 +900,12 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
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
@@ -929,19 +935,17 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
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
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
@@ -8068,11 +8072,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -8283,11 +8286,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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
2.20.1

