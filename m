Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99EF1420C9
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 19:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717614950; cv=none; b=XW5dDNrIioEncvz58KrE2tvepg4xNnJWqBNZ+mxEWzdYjXXbi3oOBwsE3YOdXo3WrIAKY6PnftOcPfBTPEb43CDHeA6GJy9w38xc90IlXTPFZ8SCz31GWiDC4C0DbhzD+7QfHjPvCkLTvSO1y8xI09oBN/Sr+k+K92I6TSA6DJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717614950; c=relaxed/simple;
	bh=7iBNLOTIeAZWE/0/8LtYoQ0p0jxDizeBxDW01stTQ2Y=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=KcV8/pjr6rebrvNVzSr/GjcnggbfvxFkY5rASo7R4ZPlxCXbDWir3+jBrf5bK2gMD8TMKOxw1qJjXXnJ6lUIVQ5RBU+q45XroE9h1rOeqLkEzrla1NImKRzck3lRzl9iGuybSyqxmB3UVJ1o0kBDL3/6US3JDa1M0PB2JDVN+bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: missing objects with no memcg accounting
Date: Wed,  5 Jun 2024 21:08:02 +0200
Message-Id: <20240605190802.19525-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several ruleset objects are still not using GFP_KERNEL_ACCOUNT for
memory accounting, update them.

Fixes: 33758c891479 ("memcg: enable accounting for nft objects")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 net/netfilter/nft_compat.c    | 6 +++---
 net/netfilter/nft_meta.c      | 2 +-
 net/netfilter/nft_numgen.c    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index be3b4c90d2ed..36feb42ec280 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6620,7 +6620,7 @@ static int nft_setelem_catchall_insert(const struct net *net,
 		}
 	}
 
-	catchall = kmalloc(sizeof(*catchall), GFP_KERNEL);
+	catchall = kmalloc(sizeof(*catchall), GFP_KERNEL_ACCOUNT);
 	if (!catchall)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index d3d11dede545..85450f601142 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -536,7 +536,7 @@ nft_match_large_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	struct xt_match *m = expr->ops->data;
 	int ret;
 
-	priv->info = kmalloc(XT_ALIGN(m->matchsize), GFP_KERNEL);
+	priv->info = kmalloc(XT_ALIGN(m->matchsize), GFP_KERNEL_ACCOUNT);
 	if (!priv->info)
 		return -ENOMEM;
 
@@ -810,7 +810,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL);
+	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL_ACCOUNT);
 	if (!ops) {
 		err = -ENOMEM;
 		goto err;
@@ -900,7 +900,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL);
+	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL_ACCOUNT);
 	if (!ops) {
 		err = -ENOMEM;
 		goto err;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 9139ce38ea7b..f23faf565b68 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -954,7 +954,7 @@ static int nft_secmark_obj_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_SECMARK_CTX] == NULL)
 		return -EINVAL;
 
-	priv->ctx = nla_strdup(tb[NFTA_SECMARK_CTX], GFP_KERNEL);
+	priv->ctx = nla_strdup(tb[NFTA_SECMARK_CTX], GFP_KERNEL_ACCOUNT);
 	if (!priv->ctx)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 7d29db7c2ac0..bd058babfc82 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -66,7 +66,7 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	priv->counter = kmalloc(sizeof(*priv->counter), GFP_KERNEL);
+	priv->counter = kmalloc(sizeof(*priv->counter), GFP_KERNEL_ACCOUNT);
 	if (!priv->counter)
 		return -ENOMEM;
 
-- 
2.30.2

