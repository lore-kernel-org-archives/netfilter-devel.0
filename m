Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57448BA2D;
	Thu, 13 Jun 2024 01:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240555; cv=none; b=YTnbpsZb0KFrhxW8ubkCtnSnNdp7NgANBdD6EYtM2AnGK58mPFg+UdAJAeF0Csnu6v4OnrzXV5SLj5I7gkVGv/Noe9urcvXFndstDx7jh6O98+QEPnJwpEak60dUnAqJXTQTs6Q8pjdkaLKUD1YbT9/AC4X6PCch+T7ofd7uiMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240555; c=relaxed/simple;
	bh=pNGsEv8GSseglDCdVADodn18Tcg6XDJ4qHxnuI7DJfM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NVcKUONFJIGdgLiAVgoEBKJKI89T2Z6cG3aANbAiQU7yUROIlVAX5tSbwTz3nAtgTjnelQM5OyEex+xft7pHqHRbENGkaIJHVHiXPtCQbuRFmIBfMuFFgd9r1A32JJfLu0oq+u5MYpfwmuFokK4s1ICrG6ekz81/MfFc+TRju+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 23/40] netfilter: nftables: update table flags from the commit phase
Date: Thu, 13 Jun 2024 03:01:52 +0200
Message-Id: <20240613010209.104423-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index ff1e2a1afa1e..d97a988172bc 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1347,13 +1347,16 @@ struct nft_trans_chain {
 
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
index adab83a22f6c..aac013855570 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -868,6 +868,12 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
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
@@ -891,19 +897,17 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
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
@@ -7009,11 +7013,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -7174,11 +7177,9 @@ static int __nf_tables_abort(struct net *net)
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

