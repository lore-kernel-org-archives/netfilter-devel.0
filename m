Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D2B27EFEE
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 18:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751395989; cv=none; b=Uud7qniHsheAqzOTc0ALN89N4p6cf+jWHDrjwtZgUsXGkfs1kx4yjYo4Vctqt1bjCWxLu0AiUFaN+1NSI1tlo9dCkqa/BubRXbJTOLGT767Md0wYPsL5SnWA7gpqwM4KyvMUEDb+jbCRWPAU+DADN+pvM4e2ou3TtiLPGUUTa3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751395989; c=relaxed/simple;
	bh=dHBR0YCNEfeKdK6YcdmCxf+7naPfc6k0IzT72S7ksDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzyjAUAzUkS7kPZ4zGGRlW1ZUoj02TzrRcUpMaaSY2sKXiYdsalF06U3uBAv0fGaPEzqNrKvo4hg6TEy8AIIrLHOUtLTZ3+jKIo1DfcJRmz7wyLszxBB2Tl4l7cSXdttGaoEbD/AabIMkYgoEeE+qj9cxjYm0epGwPWDLe2biXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5904D61899; Tue,  1 Jul 2025 20:53:06 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/5] netfilter: nft_set: remove indirection from update API call
Date: Tue,  1 Jul 2025 20:52:40 +0200
Message-ID: <20250701185245.31370-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250701185245.31370-1-fw@strlen.de>
References: <20250701185245.31370-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This stems from a time when sets and nft_dynset resided in different kernel
modules.  We can replace this with a direct call.

We could even remove both ->update and ->delete, given its only
supported by rhashtable, but on the off-chance we'll see runtime
add/delete for other types or a new set type keep that as-is for now.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h      | 4 ----
 include/net/netfilter/nf_tables_core.h | 3 +++
 net/netfilter/nft_dynset.c             | 9 ++++-----
 net/netfilter/nft_set_hash.c           | 4 +---
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2da886716adc..a4f254e8b3c9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -464,10 +464,6 @@ struct nft_set_ops {
 						  const u32 *key);
 	const struct nft_set_ext *	(*update)(struct nft_set *set,
 						  const u32 *key,
-						  struct nft_elem_priv *
-							(*new)(struct nft_set *,
-							       const struct nft_expr *,
-							       struct nft_regs *),
 						  const struct nft_expr *expr,
 						  struct nft_regs *regs);
 	bool				(*delete)(const struct nft_set *set,
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 6a52fb97b844..6c2f483d9828 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -188,4 +188,7 @@ void nft_objref_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		     const struct nft_pktinfo *pkt);
 void nft_objref_map_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt);
+struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
+				     const struct nft_expr *expr,
+				     struct nft_regs *regs);
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index e24493d9e776..7807d8129664 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -44,9 +44,9 @@ static int nft_dynset_expr_setup(const struct nft_dynset *priv,
 	return 0;
 }
 
-static struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
-					    const struct nft_expr *expr,
-					    struct nft_regs *regs)
+struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
+				     const struct nft_expr *expr,
+				     struct nft_regs *regs)
 {
 	const struct nft_dynset *priv = nft_expr_priv(expr);
 	struct nft_set_ext *ext;
@@ -91,8 +91,7 @@ void nft_dynset_eval(const struct nft_expr *expr,
 		return;
 	}
 
-	ext = set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
-			     expr, regs);
+	ext = set->ops->update(set, &regs->data[priv->sreg_key], expr, regs);
 	if (ext) {
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 9903c737c9f0..266d0c637225 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -123,8 +123,6 @@ nft_rhash_get(const struct net *net, const struct nft_set *set,
 
 static const struct nft_set_ext *
 nft_rhash_update(struct nft_set *set, const u32 *key,
-		 struct nft_elem_priv *(*new)(struct nft_set *, const struct nft_expr *,
-		 struct nft_regs *regs),
 		 const struct nft_expr *expr, struct nft_regs *regs)
 {
 	struct nft_rhash *priv = nft_set_priv(set);
@@ -141,7 +139,7 @@ nft_rhash_update(struct nft_set *set, const u32 *key,
 	if (he != NULL)
 		goto out;
 
-	elem_priv = new(set, expr, regs);
+	elem_priv = nft_dynset_new(set, expr, regs);
 	if (!elem_priv)
 		goto err1;
 
-- 
2.49.0

