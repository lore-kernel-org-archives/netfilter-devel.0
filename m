Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDC7143C48;
	Thu, 13 Jun 2024 11:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279169; cv=none; b=p/MKc3+Gogh1QGl4sqh7/vpiM5njQ4Y1IGcW0zBsxGhrDp45dV6WhKZgsp166ZV1fXFvvuQjO5+fEaoL5Gi4X0XDcF0qSRo5EsJuJh5pDigXOD5n/UA86HePn1fTozjzco8F2DnUIN7CG29+DEYsso7EnA65Xha1U1lRzcPsQxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279169; c=relaxed/simple;
	bh=Hp5NoI2makNpJzklLylBPXf3W1gSfyR1zrEurhgofnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHOLcQ4o98bphQcvbZ5EmqlIRzoOmYixkQEmygNuf6Px5WK8NK5rPffM2y9zUDEzEEyXLPLp6AqELn2d9oGsfiUg4Aw9+bHooPR5buPKbQ/S7+VIxgHobr9sbAFbe5EBLJDFA42ytliUcEEt7Y1BM4NJJZvVazlA2giD7ig4szs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G82UGffj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G82UGffj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AECBC2BBFC;
	Thu, 13 Jun 2024 11:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279169;
	bh=Hp5NoI2makNpJzklLylBPXf3W1gSfyR1zrEurhgofnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G82UGffjFJ3rOh+Ui0RYj7iqbQ0jzIORedQZ7pIshC7H62E/f3gKvWcVmchFdVm33
	 tCuVF7Jagyeld5BMfuVHp/diyHvabkMoJt0whzx630103xTwSzazKc7+SbzKUVprsL
	 fDwgrLNu4lMaepzrQrhN9i8iHo8L0q0ZQPyI5Rho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 181/213] netfilter: nftables: update table flags from the commit phase
Date: Thu, 13 Jun 2024 13:33:49 +0200
Message-ID: <20240613113234.964140434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 0ce7cf4127f14078ca598ba9700d813178a59409 upstream.

Do not update table flags from the preparation phase. Store the flags
update into the transaction, then update the flags from the commit
phase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    9 ++++++---
 net/netfilter/nf_tables_api.c     |   31 ++++++++++++++++---------------
 2 files changed, 22 insertions(+), 18 deletions(-)

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
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -868,6 +868,12 @@ static void nf_tables_table_disable(stru
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
@@ -891,19 +897,17 @@ static int nf_tables_updtable(struct nft
 
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
@@ -7009,11 +7013,10 @@ static int nf_tables_commit(struct net *
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
@@ -7174,11 +7177,9 @@ static int __nf_tables_abort(struct net
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


