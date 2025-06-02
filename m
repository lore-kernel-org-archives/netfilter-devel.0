Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8CF225388;
	Mon,  2 Jun 2025 14:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874947; cv=none; b=mk3YBYUU8YFTfAJQ4Q6BJsXbplpb0XmWPuXfLOHsCAoplD0mALyquGVB3QBY15cE2dbJUYGi+3SN6rTwgiHUzCCvEb12k9GY0kKovKUDfa7+wsoFoNpXQTP2MJrXvaR9puY/+7HKeEVvhm0SJ/teuDIPMKw3id1maJjEReNvXX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874947; c=relaxed/simple;
	bh=rwXqm+jKbJqHLIWzQr1UCl/OBgyDtI+gEGl9u8XbRHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJXu+p6r7af32LR+sV+RbGg+hbkHYf9PxXjC6o0+ChsaLQf4D2ytTjvS/eaKql2lThhIm18Cwswg82R5SMceEMvnKwhZNuqxIC2VgN6W+3qWN4HNVmctIlWfm38FYJJxI3NCD7hcp1vnmk4EuHIa7V9V1CgFrMVjseeXk6IsqoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfQx7QzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfQx7QzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC54C4CEEB;
	Mon,  2 Jun 2025 14:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874947;
	bh=rwXqm+jKbJqHLIWzQr1UCl/OBgyDtI+gEGl9u8XbRHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfQx7QzASIAqQEM1OyVno/NK++ywF3V1ioRU8lA6+R7fLfhcf9yqWsJtKLk3aOpfo
	 fq+LlJcIzjTx6V6sPJvcMZ8RYQJeL8KrBocUV26k/O6b8Xz/MCYWtez7K4q8IX3sGO
	 3VOw8+g1+EwSN4Vj05AQL6Om+scQB3siaz8Pm9i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 185/204] netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
Date: Mon,  2 Jun 2025 15:48:38 +0200
Message-ID: <20250602134302.943322623@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 8965d42bcf54d42cbc72fe34a9d0ec3f8527debd upstream.

It would be better to not store nft_ctx inside nft_trans object,
the netlink ctx strucutre is huge and most of its information is
never needed in places that use trans->ctx.

Avoid/reduce its usage if possible, no runtime behaviour change
intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1675,10 +1675,8 @@ static void nf_tables_chain_free_chain_r
 	kvfree(chain->rules_next);
 }
 
-static void nf_tables_chain_destroy(struct nft_ctx *ctx)
+void nf_tables_chain_destroy(struct nft_chain *chain)
 {
-	struct nft_chain *chain = ctx->chain;
-
 	if (WARN_ON(chain->use > 0))
 		return;
 
@@ -1929,7 +1927,7 @@ err2:
 err_use:
 	nf_tables_unregister_hook(net, table, chain);
 err1:
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(chain);
 
 	return err;
 }
@@ -6905,7 +6903,7 @@ static void nft_commit_release(struct nf
 		kfree(nft_trans_chain_name(trans));
 		break;
 	case NFT_MSG_DELCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(trans->ctx.chain);
 		break;
 	case NFT_MSG_DELRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -7582,7 +7580,7 @@ static void nf_tables_abort_release(stru
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(trans->ctx.chain);
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -8233,7 +8231,7 @@ int __nft_release_basechain(struct nft_c
 	}
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(ctx->chain);
 
 	return 0;
 }
@@ -8300,10 +8298,9 @@ static void __nft_release_table(struct n
 		nft_obj_destroy(&ctx, obj);
 	}
 	list_for_each_entry_safe(chain, nc, &table->chains, list) {
-		ctx.chain = chain;
 		nft_chain_del(chain);
 		nft_use_dec(&table->use);
-		nf_tables_chain_destroy(&ctx);
+		nf_tables_chain_destroy(chain);
 	}
 	list_del(&table->list);
 	nf_tables_table_destroy(&ctx);


