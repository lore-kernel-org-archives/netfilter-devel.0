Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2295C221F2A
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 21:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747258955; cv=none; b=oUZxic1/3b8HIpqrTW9CdpnJkGH3hmJlV5vP5Rxb5FlpE5XK0DAPaieguW8UZs8Z+7wcUGcIPzUef70kC9VAPywTnw4Un0ep8I7JehDF0h1z6r9VqT9I3arhbe8MuXbpeMUCPEYthL7ZW8fQt0OEyL293Xr5lOTC+s95CUg4xQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747258955; c=relaxed/simple;
	bh=BxNAFFy7W4liFRKeGdojfkcABsgS6sUUhgg4HHe/TSU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QDFyOmRzRNE5NyRU/PumWkBSLp+ooh3TXtwP7GRULSJeQzbbOOqvnLETmM9BDD/Q9sy0yR2oHNX5L1DhxBm1bOP2uGwQzgf9tWRaPPnElSLLMWZYRdthDt/qc4YUqZ1hb95f0ATq6uivxMt4//FI4DS1xNljW3VVggIqfywrNVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MbxlSbMa; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kqz6ZEct; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MbxlSbMa";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kqz6ZEct"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 245FE6073E; Wed, 14 May 2025 23:42:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747258950;
	bh=SwOIkAlZS5WNrlZlm2L7xsvLlR214f3Y04VjZX/0NYY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MbxlSbMaBWmc5VAwM8+bALxx9IoEzBtAWt7bAngkULh3nfSXw5UcUQIEnygug29b7
	 Skzp6GIe5P33YE4B5C/IW0+n61fd1Ftlt6SE04EhXFFYwCDfocX1HB7bG3PUmivKHr
	 AjLIkYKYCbzXpTRZ7jCIFRaLohddyBEU5Z/P4BlcxB6x/OSEwukLfryaiC9sIo4Xji
	 nCBRVnHourIVMJE+glGwmJMLYrm24bb5dz433CFzMAXQF7TtcgEsn+Rz7AeZqLX+re
	 s5l3s+IzT51SB0XWpqnG9MLAGyJdXx4eglYlAmahKgZXmujaTIQg3sjBONFs/hqYeh
	 nopyD0DFYI9bA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8DD006073E
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 23:42:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747258949;
	bh=SwOIkAlZS5WNrlZlm2L7xsvLlR214f3Y04VjZX/0NYY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kqz6ZEctJfoUx18ZNOFjvxmahDWaJP+QRSSP+LM+MGMLoatgkZQXqe8zXkYpAvl34
	 322CD624q96NY+EYDMupt53akHd+ZOwVNiYsHHDRyq3iI1g/xqJZimgCe0nhWYKriY
	 Een5HQwNTVgP9z9YuVfyC/OpH1c/pg8JjT5JS7hTXS/hPHF4QfcciT5AOS133YwHus
	 6Nt/CDqilMQBo3HDlUySYacYpMd1VtFQ/3pzhSL3D/xS2VkjFYhhhkJ8bOjqAw0Faa
	 uTgSYe77w2Ch4CbmYOuIm8LX9ZjwvW7627y64c+7eu+Xc4eYy6L3KCPKQhFcumlsvQ
	 OAv2YEwd5hDqg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 2/6] netfilter: nf_tables: honor validation state in preparation phase
Date: Wed, 14 May 2025 23:42:12 +0200
Message-Id: <20250514214216.828862-3-pablo@netfilter.org>
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

There are three states for table validation:

- SKIP, this is the initial state, skip validation from the preparation
  phase and the commit/abort path.
- NEED, this state is entered from the preparation phase, to validate
  the table from the commit/abort path. In case that validation fails,
  this enters the DO state and the transaction is replayed.
- DO, this state validates updates incremental from the preparation
  step for error reporting.

Currently the NEED state is set on if:
- A new rule contains expressions that require validation, this
  includes jump/goto chain.
- A new set element with jump/goto chain.

However, there are two issues:

- Validation is performed incrementally with new rules and elements
  regardless the states. This patch updates the logic to perform the
  validation only in the DO state.

- Reset validate state in case the transaction is finally aborted with
  with NFNL_ABORT_NONE. Otherwise, the next batch can observe the DO
  state and it performs the validation incrementally.

Fixes: a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 50 ++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d5de843ee773..46465a8c255f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3997,16 +3997,8 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
 	nf_tables_rule_destroy(ctx, rule);
 }
 
-/** nft_chain_validate - loop detection and hook validation
- *
- * @ctx: context containing call depth and base chain
- * @chain: chain to validate
- *
- * Walk through the rules of the given chain and chase all jumps/gotos
- * and set lookups until either the jump limit is hit or all reachable
- * chains have been validated.
- */
-int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
+static int __nft_chain_validate(const struct nft_ctx *ctx,
+				const struct nft_chain *chain)
 {
 	struct nft_expr *expr, *last;
 	struct nft_rule *rule;
@@ -4037,6 +4029,30 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 
 	return 0;
 }
+
+/** nft_chain_validate - loop detection and hook validation
+ *
+ * @ctx: context containing call depth and base chain
+ * @chain: chain to validate
+ *
+ * Walk through the rules of the given chain and chase all jumps/gotos and set
+ * lookups until either the jump limit is hit or all reachable chains have been
+ * validated.
+ *
+ * This function is called from preparation phase: initial state is SKIP which
+ * means that validation can be skipped entirely. However, in case of a new rule
+ * or set element needs validation, then the NEED state is entered and the
+ * validation is performed from the commit/abort phase. In case this fails, the
+ * transaction is aborted and it is replayed in the DO validation state, then
+ * incremental validation is performed for error reporting.
+ */
+int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
+{
+	if (ctx->table->validate_state != NFT_VALIDATE_DO)
+		return 0;
+
+	return __nft_chain_validate(ctx, chain);
+}
 EXPORT_SYMBOL_GPL(nft_chain_validate);
 
 static int nft_table_validate(struct net *net, const struct nft_table *table)
@@ -4044,6 +4060,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	struct nft_chain *chain;
 	struct nft_ctx ctx = {
 		.net	= net,
+		.table	= (struct nft_table *)table,
 		.family	= table->family,
 	};
 	int err;
@@ -4053,7 +4070,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 			continue;
 
 		ctx.chain = chain;
-		err = nft_chain_validate(&ctx, chain);
+		err = __nft_chain_validate(&ctx, chain);
 		if (err < 0)
 			return err;
 
@@ -11063,15 +11080,24 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	struct nft_trans *trans, *next;
 	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
+	struct nft_table *table;
 	struct nft_ctx ctx = {
 		.net = net,
 	};
 	int err = 0;
 
-	if (action == NFNL_ABORT_VALIDATE) {
+	switch (action) {
+	case NFNL_ABORT_NONE:
+		list_for_each_entry(table, &nft_net->tables, list)
+			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
+		break;
+	case NFNL_ABORT_AUTOLOAD:
+		break;
+	case NFNL_ABORT_VALIDATE:
 		err = nf_tables_validate(net);
 		if (err < 0 && err != -EINTR)
 			err = -EAGAIN;
+		break;
 	}
 
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
-- 
2.30.2

