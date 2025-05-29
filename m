Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BB821ADD3;
	Thu, 29 May 2025 09:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748510326; cv=none; b=X1DXWjkA28c/F6kGNUOPy6IdV/oWGgOsMVfS/z3GP0uSLOXSitc2IZ1MWCqCPeK8KbiajvjudHrA7LP9mZ5DRvAu0Nn9QXAqYXVrfSbAkTeG0Zz58j2lK8CO3AJVFwYmhF9Zh1OaV+52iBPnRA5JTJMY0Kc2Saa/xWWW3ouDkO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748510326; c=relaxed/simple;
	bh=RdNeEZZwPglE1CXBQ9OApkRHu2Hpg4vvZZ+3c4TZjUg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K9lc4PiC9tPkQhNXuRrTErjOFVOPrTUjqSr3uhN6ZqvD4RdEY9hvxdaXOChg8JIDcKZlBhCLzIVVzzHs2xcROTvUXw81Ixp0j0pTyCoxXtdSy3O8RUdZEqADhbdfPnXUBRz7Hohi5SL4PnG25ozFNbBJoJDZEYKIr8TFaAp8SmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nGjh930E; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ulv4ptgV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nGjh930E";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ulv4ptgV"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 864BF60747; Thu, 29 May 2025 11:11:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748509912;
	bh=MMuZyEj9tx421CauxubIk1f2r5PJLdy0O/XpXL/pH2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGjh930EZ11PQvetnV5j6Ex4V145eiUjY3rrXxJEkEssVnl918IEsjh9NUZeIxZFJ
	 Ph8rALAAWMfapM34F0JZ6lYH110bgCPwhpp8pEI73uXSg4b0IqcnemZNT0G7DsI4Ed
	 M0nE6TaiX2N+x/JMjtE7HTF9OoUmqX4ITm+RrnGaVzqGoI4aBktbFizEZHp+PaRmTI
	 w8a0egGeBi4d4IPzkn52UDGXyin6n6JOTCHZ7lmCUYY9IZoWDbXrlEoo0vNngKjm+h
	 Lq/SSN68S51Dd2+wiVHbf5CdVuDWFy3U/fDldpwhRb0qJd+gjGUkF79ncwxe0n8w9e
	 yi+V1RxYWW1bw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 07FF36074A;
	Thu, 29 May 2025 11:11:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748509909;
	bh=MMuZyEj9tx421CauxubIk1f2r5PJLdy0O/XpXL/pH2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ulv4ptgVDTFO6bYmKecKy8/Jzrowg3sH/lp/X44xTWuy4t7LbdyQJAoOkfGevoyrJ
	 JFaLjnmwQXrITbQfvbS+ZRI4AII6hRhlUpCvqhi6tfuVozh03PWUsKx7F2wDPKvnMy
	 sWyC3pvfBSCiIAHDoDXFqjgpciPIbEwJ/mXuxhFiq33mUet0Mxuyrt8BHiGqYh6Fdz
	 cY7Wjuv2rRyZ2GiZnEMr/h6ejJR3GCSZFMFZznFL9lPZT6jE/IMfYipmod4iCyfkI4
	 SKvQPVnxh4Q4vOvXSW2DdNGSwm0LiQZ+ZIuU5XkkUtqEJEDF24q/qKYz5kLRG3EmbL
	 Mnb2preZLMEqA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.4 1/3] netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
Date: Thu, 29 May 2025 11:11:42 +0200
Message-Id: <20250529091144.118355-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250529091144.118355-1-pablo@netfilter.org>
References: <20250529091144.118355-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit 8965d42bcf54d42cbc72fe34a9d0ec3f8527debd upstream.

It would be better to not store nft_ctx inside nft_trans object,
the netlink ctx strucutre is huge and most of its information is
never needed in places that use trans->ctx.

Avoid/reduce its usage if possible, no runtime behaviour change
intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7812cc3cc751..c6f142b5e64f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1675,10 +1675,8 @@ static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 	kvfree(chain->rules_next);
 }
 
-static void nf_tables_chain_destroy(struct nft_ctx *ctx)
+void nf_tables_chain_destroy(struct nft_chain *chain)
 {
-	struct nft_chain *chain = ctx->chain;
-
 	if (WARN_ON(chain->use > 0))
 		return;
 
@@ -1929,7 +1927,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 err_use:
 	nf_tables_unregister_hook(net, table, chain);
 err1:
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(chain);
 
 	return err;
 }
@@ -6905,7 +6903,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		kfree(nft_trans_chain_name(trans));
 		break;
 	case NFT_MSG_DELCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(trans->ctx.chain);
 		break;
 	case NFT_MSG_DELRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -7582,7 +7580,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(trans->ctx.chain);
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -8233,7 +8231,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 	}
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(ctx->chain);
 
 	return 0;
 }
@@ -8300,10 +8298,9 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
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
-- 
2.30.2

