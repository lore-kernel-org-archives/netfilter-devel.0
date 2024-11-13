Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3B31632E2
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731513364; cv=none; b=iwbJRGe6fxzE8R+QT96HP8bnNBWuHp1DEEzzA44xm+90bL589BAOgRqWOjvcdTXsEzSJHsVWAgRp9ISZAKVdCgCTFWIjyg4K+iblbbaEZmCpSgxFgYltGybH4RppaqEHlEfKjUpJlaDrSbWeX2ycks8wnsYKTKyvI9W8kHR4bgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731513364; c=relaxed/simple;
	bh=CHhE/H3eZ/AsQLHDiu5HIbzYd6V/yS9pqhJ8bdOdz9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQQdj/Jh5LnUiocGEn1CZMP3epMGCFtOoN8iwpDCBUY40TtRRp7wTQRDORarsmyUZihgYWaBVo7npbT0mCVOYC/Wxim8G51JiYxEQttCpdEWuK22IEOg9ZlVTiccYK2YvtN9bi2qQz81bdfkko7VrjNo08avljLvDj2J4CkxmPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tBFiq-0007Ii-01; Wed, 13 Nov 2024 16:56:00 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v5 1/5] netfilter: nf_tables: add nft_trans_commit_list_add_elem helper
Date: Wed, 13 Nov 2024 16:35:49 +0100
Message-ID: <20241113153557.20302-2-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241113153557.20302-1-fw@strlen.de>
References: <20241113153557.20302-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add and use a wrapper to append trans_elem structures to the
transaction log.

Unlike the existing helper, pass a gfp_t to indicate if sleeping
is allowed.

This will be used by a followup patch to realloc nft_trans_elem
structures after they gain a flexible array member to reduce
number of such container structures on the transaction list.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6090ba9f1bb2..75c84b17ab99 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -421,6 +421,17 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 	}
 }
 
+static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans,
+					   gfp_t gfp)
+{
+	WARN_ON_ONCE(trans->msg_type != NFT_MSG_NEWSETELEM &&
+		     trans->msg_type != NFT_MSG_DELSETELEM);
+
+	might_alloc(gfp);
+
+	nft_trans_commit_list_add_tail(net, trans);
+}
+
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
 {
 	struct nft_trans *trans;
@@ -7205,7 +7216,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					if (update_flags) {
 						nft_trans_elem_priv(trans) = elem_priv;
 						nft_trans_elem_update_flags(trans) = update_flags;
-						nft_trans_commit_list_add_tail(ctx->net, trans);
+						nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 						goto err_elem_free;
 					}
 				}
@@ -7229,7 +7240,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	nft_trans_elem_priv(trans) = elem.priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 	return 0;
 
 err_set_full:
@@ -7446,7 +7457,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
 
 	nft_trans_elem_priv(trans) = elem.priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 	return 0;
 
 fail_ops:
@@ -7482,7 +7493,7 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem_priv(trans) = elem_priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_ATOMIC);
 
 	return 0;
 }
@@ -7499,7 +7510,7 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_priv(trans) = elem_priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 
 	return 0;
 }
-- 
2.45.2

