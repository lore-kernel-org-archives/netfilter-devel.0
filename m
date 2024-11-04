Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7481AE877
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2024 09:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713477; cv=none; b=p9GBr21QUIpXS/XzZ83qPGA1LWBAJV394TJqeQtc8p9Sj+XZJR7D6qCfYa+GoKrr4Z8oDH+ip3jNvij52sDzqzvM2K1UK+6/epTjv5IWqvyp4Cbzizn6gvwQ9xfGZsGOo0yGPjbi3g4kf4fhAjXv6YweGxnMeeQIDXFfT0r/S7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713477; c=relaxed/simple;
	bh=XNjUX0YXKzf7SnR28sKLgw3UEnWJEtIXUmPhARbma6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pK/b6TzPZqtzzHpj3+QVWKuyoKytb0iyOzN6Hlt/gXHN+DQArTnJ5sUbmhsTn+3TbWrt2PcS6yIQPaSRKWsYYsTy9NPDbxGvosTnOZlPrn1wOGxX641cESLJqg/g822UwvRLoqbeyxJ0HnTYmmqfkM+j7+hxTFuiSaxCr2tTVes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t7tdS-0003dG-KA; Mon, 04 Nov 2024 10:44:34 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 6/7] netfilter: nf_tables: must hold rcu read lock while iterating expression type list
Date: Mon,  4 Nov 2024 10:41:18 +0100
Message-ID: <20241104094126.16917-7-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241104094126.16917-1-fw@strlen.de>
References: <20241104094126.16917-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft shell tests trigger:
 WARNING: suspicious RCU usage
 net/netfilter/nf_tables_api.c:3125 RCU-list traversed in non-reader section!!
 1 lock held by nft/2068:
  #0: ffff888106c6f8c8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_valid_genid+0x3c/0xf0

But the transaction mutex doesn't protect this list, the nfnl subsystem
mutex would, but we can't acquire it here without risk of ABBA
deadlocks.

Acquire the rcu read lock to avoid this issue.

v3: add a comment that explains the ->inner_ops check implies
expression is builtin and lack of a module owner reference is ok.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3b5154f2dd79..de8e48a5c62d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3296,25 +3296,37 @@ int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 	if (!tb[NFTA_EXPR_DATA] || !tb[NFTA_EXPR_NAME])
 		return -EINVAL;
 
+	rcu_read_lock();
+
 	type = __nft_expr_type_get(ctx->family, tb[NFTA_EXPR_NAME]);
-	if (!type)
-		return -ENOENT;
+	if (!type) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
 
-	if (!type->inner_ops)
-		return -EOPNOTSUPP;
+	if (!type->inner_ops) {
+		err = -EOPNOTSUPP;
+		goto out_unlock;
+	}
 
 	err = nla_parse_nested_deprecated(info->tb, type->maxattr,
 					  tb[NFTA_EXPR_DATA],
 					  type->policy, NULL);
 	if (err < 0)
-		goto err_nla_parse;
+		goto out_unlock;
 
 	info->attr = nla;
 	info->ops = type->inner_ops;
 
+	/* No module reference will be taken on type->owner.
+	 * Presence of type->inner_ops implies that the expression
+	 * is builtin, so it cannot go away.
+	 */
+	rcu_read_unlock();
 	return 0;
 
-err_nla_parse:
+out_unlock:
+	rcu_read_unlock();
 	return err;
 }
 
-- 
2.45.2

