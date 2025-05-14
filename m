Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B99222590
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 21:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747258957; cv=none; b=RlaLKbKCCLfqQUnnpyyMlLGDQtaB651G3t/laiyBbrYPOmy7FTb8qE+3K/GN0RYhIKQt2pIZtnHQj2m6jUMR1Yt9I4pZrWXHfnw2Bc+d0TNSghapcFiIoEKpBAYj6L1ryXQrgyZDnxhBml1K3BJcQXVsUj/1ECy0bNH/mTTVr84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747258957; c=relaxed/simple;
	bh=WVRzIbhEAKIwtc66tOxUxP7Nw7KOOX/Uv51u+yqEiaw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RHFw0qWLpbGOak9B+J0uVIZ5Xzs7Yr0h2hNcXJpeTGxL03YyqRhvwaxHBuMAinWGVbGtYoj0DMZ3VG0PjGzADulfDpQXihTlJdP4FI13RsNJ8hk3epQuUfQ/R/sldE/u4EBLPAi5JQae1kYcTqqJdgyNuMcOoJ7iPL1J+5S9VNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JJCXIQI1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cqrv7b3P; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JJCXIQI1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cqrv7b3P"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 50CC260746; Wed, 14 May 2025 23:42:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747258952;
	bh=zoFFxGf4Wd0ugl7NFox+NgVCw9jheIvcCpOBjQhn86s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JJCXIQI1ZpauyHmlINAqyA4Dn3w0lDbidlQlTBRde0SYNTJdjsVkfRd9CpidLTfUX
	 8mp1+TOzmyTX2OmX69uo7FiGVLBYfcyS/2N+pRG7MKtYadC+FubxrNO1VkuWW4GSwR
	 RXIbYscdlKNRVeGWv4V+N4T3Kphruu8Dx10GAy2SEQ6DLVcJhn3KoKI0o4Lg/aHgiD
	 EIYe68FFr5t2/SJuRLAiV768EBuQzMcG0Wxeqqmzuc8ND0onCNkC4Wj4HeJHyZw5xk
	 DjdAzfpO8HG+d8b/YfrIAEFFKj7oaxbHbOp11cEv5q+N1mO9VjyaZwCQieHZTrYE+D
	 pzL6Q6KPYH6Aw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5FB5860744
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 23:42:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747258951;
	bh=zoFFxGf4Wd0ugl7NFox+NgVCw9jheIvcCpOBjQhn86s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cqrv7b3PAotWbvL4Kb4fQfTVaK/R+EEOEw2UebyiUFUlcI3dKyXCG+yKI8U12B+kU
	 /uldkRLNXLFPfdaUfut+diQQY2Zzi+WW0vwpBzvTGZ4YuPEOUcTl8GjGpsFXhmIq2e
	 bqSlOSGjAWiwpUv2lggSblvYaNCHxd06FJzJ5wTErQh0PRGOFmSHKb1BPSdFpPJoDw
	 dx0d/zrjJDktLnChZA2EkuGIBjB7MuzVyv71nF4MTr4FqPAPTl/f0+TVpfxv0EZ2G+
	 URa0FHRQsHD058SxPgrmtG3C1dnM0brMgU+C7bggUzLMQ6h5V6XAlNRbCyofm5HilQ
	 00WCNOOUeqVeA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 6/6] netfilter: nf_tables: add support for validating incremental ruleset updates
Date: Wed, 14 May 2025 23:42:16 +0200
Message-Id: <20250514214216.828862-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250514214216.828862-1-pablo@netfilter.org>
References: <20250514214216.828862-1-pablo@netfilter.org>
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
 net/netfilter/nf_tables_api.c | 188 +++++++++++++++++++++++++++++++++-
 1 file changed, 183 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e92cccc834d9..0f183abbc94f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10397,6 +10397,160 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	},
 };
 
+struct basechain_array {
+	const struct nft_chain	**basechain;
+	uint32_t		num_basechains;
+	uint32_t		max_basechains;
+	int			max_level;
+};
+
+static int basechain_array_add(struct basechain_array *array,
+			       const struct nft_chain *chain, int level)
+{
+	const struct nft_chain **new_basechain;
+	uint32_t new_max_basechains;
+
+	if (array->num_basechains == array->max_basechains) {
+		new_max_basechains = array->max_basechains + 16;
+		new_basechain = krealloc_array(array->basechain, new_max_basechains, sizeof(struct nft_chain *), GFP_KERNEL);
+		if (!new_basechain)
+			return -ENOMEM;
+
+		array->basechain = new_basechain;
+		array->max_basechains = new_max_basechains;
+	}
+	array->basechain[array->num_basechains++] = chain;
+
+	if (level > array->max_level)
+		array->max_level = level;
+
+	return 0;
+}
+
+static int nft_chain_validate_backtrack(struct basechain_array *array,
+					const struct list_head *backbinding_list,
+					int *level)
+{
+	struct nft_binding *binding;
+	int err;
+
+	/* Basechain is unreachable, fall back to slow path validation. */
+	if (*level >= NFT_JUMP_STACK_SIZE)
+		return -ENOENT;
+
+	list_for_each_entry(binding, backbinding_list, backlist) {
+		if (binding->from.type == NFT_BIND_CHAIN &&
+		    binding->from.chain->flags & NFT_CHAIN_BASE &&
+		    binding->use > 0) {
+			if (basechain_array_add(array, binding->from.chain, *level) < 0)
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
+			(*level)++;
+			err = nft_chain_validate_backtrack(array,
+							   &binding->from.chain->backbinding_list,
+							   level);
+			if (err < 0)
+				return err;
+
+			(*level)--;
+			break;
+		case NFT_BIND_SET:
+			if (binding->use == 0)
+				break;
+
+			/* no level update for sets. */
+			err = nft_chain_validate_backtrack(array,
+							   &binding->from.set->backbinding_list,
+							   level);
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
+	struct basechain_array array = {};
+	uint32_t i, level = 1;
+	int err;
+
+	array.max_basechains = 16;
+	array.basechain = kcalloc(16, sizeof(struct nft_chain *), GFP_KERNEL);
+	if (!array.basechain)
+		return -ENOMEM;
+
+	if (nft_is_base_chain(chain)) {
+		err = basechain_array_add(&array, chain, 0);
+		if (err < 0) {
+			kfree(array.basechain);
+			return -ENOMEM;
+		}
+	} else {
+		err = nft_chain_validate_backtrack(&array,
+						   &chain->backbinding_list,
+						   &level);
+		if (err < 0) {
+			kfree(array.basechain);
+			return err;
+		}
+	}
+
+	for (i = 0; i < array.num_basechains; i++) {
+		struct nft_ctx ctx = {
+			.net	= net,
+			.family	= chain->table->family,
+			.table	= chain->table,
+			.chain	= (struct nft_chain *)array.basechain[i],
+			.level	= array.max_level,
+		};
+
+		if (WARN_ON_ONCE(!nft_is_base_chain(array.basechain[i])))
+			continue;
+
+		err = nft_chain_validate(&ctx, chain);
+		if (err < 0)
+			break;
+	}
+
+	kfree(array.basechain);
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
@@ -10422,12 +10576,36 @@ static int nf_tables_validate(struct net *net)
 			nft_validate_state_update(table, NFT_VALIDATE_DO);
 			fallthrough;
 		case NFT_VALIDATE_DO:
-			err = nft_table_validate(net, table);
-			if (err < 0) {
-				if (err == EINTR)
-					goto err_eintr;
+			/* If this table is new, then this is the initial
+			 * ruleset restore, perform full table validation,
+			 * otherwise, perform incremental validation.
+			 */
+			if (!nft_is_active(net, table)) {
+				err = nft_table_validate(net, table);
+				if (err < 0) {
+					if (err == EINTR)
+						goto err_eintr;
 
-				return -EAGAIN;
+					return -EAGAIN;
+				}
+			} else {
+				err = nft_validate_incremental(net, table);
+				if (err < 0) {
+					if (err != -ENOMEM && err != -ENOENT)
+						return -EAGAIN;
+
+					/* Either no memory or it cannot reach
+					 * basechain, then fallback to full
+					 * validation.
+					 */
+					err = nft_table_validate(net, table);
+					if (err < 0) {
+						if (err == EINTR)
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

