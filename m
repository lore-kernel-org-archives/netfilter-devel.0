Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6AE567D
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 01:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608950; cv=none; b=UT5QVjSwGoTRG4hZCLJ2+IRYnQ9F6yb/iTeo56rMkw4H7G9Of0StPw9/i6PncJa6sUZMGVHp/ClqNfGrk+gSetNlIxTNzWYQFAynOW5WOa2FRPkiS//yk7G0gWBLJsk1u1qEalh50srEnq2MYK7P7OV1N+eV5u948zPsPBZH8sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608950; c=relaxed/simple;
	bh=jQLn/kI9vWu3bcU2YouagoDuRGHPKi4veLs8uAgwej4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1WysFP7JbP/kMRz+gzrX7TO4FUhs8NbijF0dyJ+M13QYgsuFFXliTfoft8I4Plw9CbXD/E5YpPi6yngNpSF8T3+poh8i+Yjg8ITbqXKeZDWP2nfb5tfLYup+68IMx50ShzVpdVsDmQaaVt85tTI9talt3cpdUkCK/c6Cfwmcvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sz49T-0006yB-39; Fri, 11 Oct 2024 03:09:07 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/5] netfilter: nf_tables: add nft_trans_commit_list_add_elem helper
Date: Fri, 11 Oct 2024 02:33:00 +0200
Message-ID: <20241011003315.5017-3-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241011003315.5017-1-fw@strlen.de>
References: <20241011003315.5017-1-fw@strlen.de>
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
index 2f85f4a10c50..8afcd24f9901 100644
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
@@ -7183,7 +7194,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					if (update_flags) {
 						nft_trans_elem_priv(trans) = elem_priv;
 						nft_trans_elem_update_flags(trans) = update_flags;
-						nft_trans_commit_list_add_tail(ctx->net, trans);
+						nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 						goto err_elem_free;
 					}
 				}
@@ -7207,7 +7218,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	nft_trans_elem_priv(trans) = elem.priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 	return 0;
 
 err_set_full:
@@ -7424,7 +7435,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
 
 	nft_trans_elem_priv(trans) = elem.priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 	return 0;
 
 fail_ops:
@@ -7460,7 +7471,7 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem_priv(trans) = elem_priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_ATOMIC);
 
 	return 0;
 }
@@ -7477,7 +7488,7 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_priv(trans) = elem_priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 
 	return 0;
 }
-- 
2.45.2

