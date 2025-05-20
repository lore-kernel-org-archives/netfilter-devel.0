Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B3C25FA13
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 10:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747735908; cv=none; b=D16GrqgdfAIQG3yiIeSWsQWZvMOvpUX8UKtZiIfsnHs21Hor9HleNR+nWhSzsJyJ+e4hmXJm6PJ07JeFboU73U9Y7qSk83ncf3uNT9zGeTPzz4nnGIw5xxqZKCsaXUqpIxLRLNPoA7yt0N3FHsZ+UJBKiodkNb9uqcGXGGhneYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747735908; c=relaxed/simple;
	bh=YnkGiKE4qY+Bkh1xFUVnQwPQlrsinykW3F3lYEJ1v98=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ujCqjLmZCR4E8kjFRVs7ewVMjUDc5jm9xQGXWcm5olyhgYR2IWnTkeDVfyLcazDgcFORPA3YfNirrc6Kzg5iiRz4XmtyuiNMLpOUoRK5cIVhRgwegcua9+TT12XBeoJtnTyGi0zHy74YfERJ2pYhOlIBR02nOk8TP0XtN/DotFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Diex1dBa; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MXRwCNBK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Diex1dBa";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MXRwCNBK"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 91A1E6072C; Tue, 20 May 2025 12:11:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747735904;
	bh=vyVIfPUaFUWgJpfwx69Nz2qnSEuZ9aUNqM8aL+2O0kA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Diex1dBaYw74TY1LwX3onpoXX0fAR/69YmIDFfb8+WBwQDzYTRw2faNfLZt0pPHtu
	 CfqjdXdGQY2jiI6oyZ0FjX/9uDceFzchp2aCXDPvdFuo2hVfAixCRj9M6wunUCb7nZ
	 1DAfwbhhUE2LRmQTzFfnzrMNStNy0MSNxIMr0xM9vKqajeThHB0G+vAFF98C1eGhuM
	 pm+UqRGAkLMjUQitNY3AkxtvVyOrU6+FeHa27hs2vKf+6/kfXvKoHUWomjEpFTQdZO
	 AQsSKqbX195iGkHhLOJIxz9sOKIhquZuLELisG8xKLh+BvVFNdvunSGu+mIXYROFsU
	 HTUkTDb5IE2Pg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C326460765
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 12:09:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747735752;
	bh=vyVIfPUaFUWgJpfwx69Nz2qnSEuZ9aUNqM8aL+2O0kA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MXRwCNBKtM6zziqVyRt45S5KtfP4BphZdwOAm+YT1dw0utfYvPRLVjAXaqVqZTFRV
	 6OXNHg0g31GhX7ldyNSbqY5cOgdCOL5eCAnrAlYrwMECqoGkuTSRHsIaxRYST1jDRH
	 CcFmYRsZHQ9vvtI/hLFyx50yTcMfGGmN9HPrl+ZYVtgPJuN5WnX8Jg9qmZvVHHqVEJ
	 mVk76VSy3piEN/KeO3M3ggRhCT+en4K61gdSLilTZHWa/e8rDFPsN3e7hhsOUFiUdj
	 +jpb5lpSXOHuEotvkD1AS6njFxy56RUqdMKQYLHAO+8bqwFV+lgVzZgyDUEmvr+4ZI
	 7jL8Rk5k+2xSA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 4/4] netfilter: nf_tables: add support for validating incremental ruleset updates
Date: Tue, 20 May 2025 12:09:07 +0200
Message-Id: <20250520100907.191244-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250520100907.191244-1-pablo@netfilter.org>
References: <20250520100907.191244-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the new binding graph to validate incremental ruleset updates.

Perform full validation if the table is new, which is the case of the
initial ruleset reload. Subsequent incremental ruleset updates use the
validation list which contains chains with new rules or chains that can
be now reached via jump/goto from another rule/set element.

When validating a chain from commit/abort phase, backtrack to collect
the basechains that can reach this chain, then perform the validation of
rules in this chain. If no basechains can be reached, then skip
validation for this chain. However, if basechains are off the jump stack
limit, then resort to full ruleset validation. This is to prevent
inconsistent validation between the preparation and commit/abort phase
validations.

As for loop checking, stick to the existing approach which uses the jump
stack limit to detect cycles.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: nft_chain_validate_backtrack() bails out if chain stack is too deep
    or loop is detected, then fallback to full validation. Loops in
    chains that are not linked to basechains are allowed by now, so
    let's fall back to full validation when is loop detected or chain
    stack is too deep.

 net/netfilter/nf_tables_api.c | 196 +++++++++++++++++++++++++++++++++-
 1 file changed, 191 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1a3bc7857f78..ee4bd201ca05 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10397,6 +10397,168 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	},
 };
 
+struct nft_validate_ctx {
+	const struct nft_chain	*chain;
+	int			level;
+
+	const struct nft_chain	**basechain;
+	uint32_t		num_basechains;
+	uint32_t		max_basechains;
+	int			max_level;
+};
+
+static int nft_basechain_array_add(struct nft_validate_ctx *ctx,
+				   const struct nft_chain *chain)
+{
+	const struct nft_chain **new_basechain;
+	uint32_t new_max_basechains;
+
+	if (ctx->num_basechains == ctx->max_basechains) {
+		new_max_basechains = ctx->max_basechains + 16;
+		new_basechain = krealloc_array(ctx->basechain,
+					       new_max_basechains,
+					       sizeof(struct nft_chain *),
+					       GFP_KERNEL);
+		if (!new_basechain)
+			return -ENOMEM;
+
+		ctx->basechain = new_basechain;
+		ctx->max_basechains = new_max_basechains;
+	}
+	ctx->basechain[ctx->num_basechains++] = chain;
+
+	if (ctx->level > ctx->max_level)
+		ctx->max_level = ctx->level;
+
+	return 0;
+}
+
+static int nft_chain_validate_backtrack(struct nft_validate_ctx *ctx,
+					const struct list_head *backbinding_list)
+{
+	struct nft_binding *binding;
+	int err;
+
+	/* Basechain is unreachable, fall back to slow path validation. */
+	if (ctx->level >= NFT_JUMP_STACK_SIZE)
+		return -ELOOP;
+
+	list_for_each_entry(binding, backbinding_list, backlist) {
+		if (binding->from.type == NFT_BIND_CHAIN &&
+		    binding->from.chain->flags & NFT_CHAIN_BASE &&
+		    binding->use > 0) {
+			if (nft_basechain_array_add(ctx, binding->from.chain) < 0)
+				return -ENOMEM;
+
+			continue;
+		}
+
+		switch (binding->from.type) {
+		case NFT_BIND_CHAIN:
+			if (binding->use == 0)
+				break;
+
+			if (ctx->chain == binding->from.chain)
+				return -ELOOP;
+
+			ctx->level++;
+			err = nft_chain_validate_backtrack(ctx,
+							   &binding->from.chain->backbinding_list);
+			if (err < 0)
+				return err;
+
+			ctx->level--;
+			break;
+		case NFT_BIND_SET:
+			if (binding->use == 0)
+				break;
+
+			/* no level update for sets. */
+			err = nft_chain_validate_backtrack(ctx,
+							   &binding->from.set->backbinding_list);
+			if (err < 0)
+				return err;
+
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int nft_chain_validate_incremental(struct net *net,
+					  const struct nft_chain *chain)
+{
+	struct nft_validate_ctx validate_ctx = {
+		.chain	= chain,
+	};
+	uint32_t i;
+	int err;
+
+	validate_ctx.max_basechains = 16;
+	validate_ctx.basechain = kcalloc(16, sizeof(struct nft_chain *), GFP_KERNEL);
+	if (!validate_ctx.basechain)
+		return -ENOMEM;
+
+	if (nft_is_base_chain(chain)) {
+		err = nft_basechain_array_add(&validate_ctx, chain);
+		if (err < 0) {
+			kfree(validate_ctx.basechain);
+			return -ENOMEM;
+		}
+	} else {
+		validate_ctx.level = 1;
+		err = nft_chain_validate_backtrack(&validate_ctx,
+						   &chain->backbinding_list);
+		if (err < 0) {
+			kfree(validate_ctx.basechain);
+			return err;
+		}
+	}
+
+	for (i = 0; i < validate_ctx.num_basechains; i++) {
+		struct nft_ctx ctx = {
+			.net	= net,
+			.family	= chain->table->family,
+			.table	= chain->table,
+			.chain	= (struct nft_chain *)validate_ctx.basechain[i],
+			.level	= validate_ctx.max_level,
+		};
+
+		if (WARN_ON_ONCE(!nft_is_base_chain(validate_ctx.basechain[i])))
+			continue;
+
+		err = nft_chain_validate(&ctx, chain);
+		if (err < 0)
+			break;
+	}
+
+	kfree(validate_ctx.basechain);
+
+	return err;
+}
+
+static int nft_validate_incremental(struct net *net, struct nft_table *table)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_chain *chain, *next;
+	int err;
+
+	err = 0;
+	list_for_each_entry_safe(chain, next, &nft_net->validate_list, validate_list) {
+		if (chain->table != table)
+			continue;
+
+		if (err >= 0)
+			err = nft_chain_validate_incremental(net, chain);
+
+		list_del(&chain->validate_list);
+		chain->validate = 0;
+	}
+
+	return err;
+}
+
 static void nft_validate_chain_release(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -10422,12 +10584,36 @@ static int nf_tables_validate(struct net *net)
 			nft_validate_state_update(table, NFT_VALIDATE_DO);
 			fallthrough;
 		case NFT_VALIDATE_DO:
-			err = nft_table_validate(net, table);
-			if (err < 0) {
-				if (err == -EINTR)
-					goto err_eintr;
+			/* If this table is new, then this is the initial
+			 * ruleset restore, perform full table validation,
+			 * otherwise, perform incremental validation.
+			 */
+			if (!nft_is_active(net, table)) {
+				err = nft_table_validate(net, table);
+				if (err < 0) {
+					if (err == -EINTR)
+						goto err_eintr;
 
-				return -EAGAIN;
+					return -EAGAIN;
+				}
+			} else {
+				err = nft_validate_incremental(net, table);
+				if (err < 0) {
+					if (err != -ENOMEM && err != -ELOOP)
+						return -EAGAIN;
+
+					/* Either no memory or it cannot reach
+					 * basechain, then fallback to full
+					 * validation.
+					 */
+					err = nft_table_validate(net, table);
+					if (err < 0) {
+						if (err == -EINTR)
+							goto err_eintr;
+
+						return -EAGAIN;
+					}
+				}
 			}
 			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
 			break;
-- 
2.30.2

