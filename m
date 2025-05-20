Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337D922D7A8;
	Tue, 20 May 2025 13:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749576; cv=none; b=PxCFkzpzrOahrReK2UihAd8SUXBFo0weTXDK2A7RA0efPD1HjsfHfPik8BLcnrlGhND7mN4U7uTxTFzkZXMqxacHE0NazlLOyJ4wgJqvJGznZVe7ZQuSYT+S24J90SheO7gx63sMvPe/AUIyNkg+DKz2KRD5ABh4kPcD3pDTSto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749576; c=relaxed/simple;
	bh=rike2Iya2BKqGpSKrATIBsPE38qyS+ukB48gvvLwdQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQFrIDB3rQLBZNhMaRtmjc6aKZt4fxUy56GOjg3be/tBvU8jzaCp4Rj5PVX66cHJFUl8PiycJD5gkYChQlTY5SpRXPM8ARV4Th+KWBUzKKSxRt9VeG3nR6vRuGUVUaq8rs9X9IU0SFrfkRJLaVuiHvWCLkrbXJj/Lltht2o8S0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukxPXqnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukxPXqnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AAAC4CEE9;
	Tue, 20 May 2025 13:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749576;
	bh=rike2Iya2BKqGpSKrATIBsPE38qyS+ukB48gvvLwdQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukxPXqnuxRnf2xSByYIPoQFAjftdwkYKerEq4CZTIaBchjULzTvbnotQRtL7qAhYe
	 lOuR91hzHhWkiVIxSl6E9M+lIvxAjSiLojkgAp0JnYszrUmnojSbF8HzIz1LDt8YUh
	 1imxMBMFZiUAM3wgM57odUbN4d7PTwnA3/Pu/lg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 88/97] netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
Date: Tue, 20 May 2025 15:50:53 +0200
Message-ID: <20250520125804.115742516@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    2 +-
 net/netfilter/nf_tables_api.c     |   17 ++++++++---------
 net/netfilter/nft_immediate.c     |    2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1121,7 +1121,7 @@ static inline bool nft_chain_is_bound(st
 
 int nft_chain_add(struct nft_table *table, struct nft_chain *chain);
 void nft_chain_del(struct nft_chain *chain);
-void nf_tables_chain_destroy(struct nft_ctx *ctx);
+void nf_tables_chain_destroy(struct nft_chain *chain);
 
 struct nft_stats {
 	u64			bytes;
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2034,9 +2034,9 @@ static void nf_tables_chain_free_chain_r
 	kvfree(chain->blob_next);
 }
 
-void nf_tables_chain_destroy(struct nft_ctx *ctx)
+void nf_tables_chain_destroy(struct nft_chain *chain)
 {
-	struct nft_chain *chain = ctx->chain;
+	const struct nft_table *table = chain->table;
 	struct nft_hook *hook, *next;
 
 	if (WARN_ON(chain->use > 0))
@@ -2048,7 +2048,7 @@ void nf_tables_chain_destroy(struct nft_
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
-		if (nft_base_chain_netdev(ctx->family, basechain->ops.hooknum)) {
+		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
@@ -2515,7 +2515,7 @@ err_chain_add:
 err_trans:
 	nft_use_dec_restore(&table->use);
 err_destroy_chain:
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(chain);
 
 	return err;
 }
@@ -8994,7 +8994,7 @@ static void nft_commit_release(struct nf
 		kfree(nft_trans_chain_name(trans));
 		break;
 	case NFT_MSG_DELCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_DELRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -9955,7 +9955,7 @@ static void nf_tables_abort_release(stru
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -10677,7 +10677,7 @@ int __nft_release_basechain(struct nft_c
 	}
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(ctx->chain);
 
 	return 0;
 }
@@ -10753,10 +10753,9 @@ static void __nft_release_table(struct n
 		nft_obj_destroy(&ctx, obj);
 	}
 	list_for_each_entry_safe(chain, nc, &table->chains, list) {
-		ctx.chain = chain;
 		nft_chain_del(chain);
 		nft_use_dec(&table->use);
-		nf_tables_chain_destroy(&ctx);
+		nf_tables_chain_destroy(chain);
 	}
 	nf_tables_table_destroy(&ctx);
 }
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -221,7 +221,7 @@ static void nft_immediate_destroy(const
 			list_del(&rule->list);
 			nf_tables_rule_destroy(&chain_ctx, rule);
 		}
-		nf_tables_chain_destroy(&chain_ctx);
+		nf_tables_chain_destroy(chain);
 		break;
 	default:
 		break;


