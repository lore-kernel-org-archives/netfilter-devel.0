Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA592EF9D1;
	Fri, 25 Jul 2025 17:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463064; cv=none; b=P9icGCJdu5TM7XMeCghu/XVMfY58HMdhBXrzJbjCd9f2hmJcGqCiLLlDjQcdmNruQRoU05yUbgOGlR/rfOPMwNequCybxrD5eI8P2KD3r/gPIriRwzUlrJ/TtARxLtnXP1Sv6DJ13UPQRYZVgj1/YGlhLGYA8d0oxwgouDgC5oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463064; c=relaxed/simple;
	bh=MmX3+1EPPa4kK00Z5OANv54e7KI9dsMp3mgGhdiT+44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F3nLqOKZj1nnYdLoR1almck3rD4/Yq367pAdJGvyoAnbr9o1EM/zsBQ+D4eIttrAXQ7uuSailqCRB1w55R42GYCNNuszVCZ3+QBX6XMFDaLCuDJfzhx9/Uip0KYWSoEJ3wLgjVTpunB5wDctAnWdKCd+WzwBzQxY+nsuO+r23o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AYWEIC+d; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DjgUAOrn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AYWEIC+d";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DjgUAOrn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4704760288; Fri, 25 Jul 2025 19:04:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463060;
	bh=iiup8jOWzy+IMSVSmQV79KjuFMrLasdDcAU2dmkOMqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYWEIC+dJSY8Q2FQJ2C7+Z/13PttUmAHzaWRQR+PhHQFLJCzUWy6w2IC+C1I6R78q
	 8ifLfkG5Ri5FPR74ZcUAtaRPxskTbjogifqXQkOEVTR2Lp5/hfR0uS1S8aEZ/7ybkv
	 E/1dR1bv0APGZqP0URimbHqTKZ3Cq+f+Wd4XU/zMEm/nBxaOH5Zdw2XWf2BWaZFFaB
	 Z1VhTbu3y4kY/+Hsvps7J4Cv68U4nGu8BTjxlv6VdqiZ5jLAHEVVveqjWr66hXlJCx
	 rs/uvaZsVg7nmoQuETCH83vmeH5jlvmzZV9VhewiACdKwHRHvueMzWrmY7huGMmu7R
	 9TYvvAclnsbBA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B89EF6027F;
	Fri, 25 Jul 2025 19:04:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463053;
	bh=iiup8jOWzy+IMSVSmQV79KjuFMrLasdDcAU2dmkOMqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjgUAOrnsXGyGnC0RaV5ARhmUyyGRt1SNo4k8zKmKdTvUf6x7EFhro6TddNDy07UG
	 r8NCgTqi42W1pkjpslFNwx5qlUQEHOxmPtci251yVWftGb7bQ/x0MhROqYmo0r2G1j
	 ExhEBK75egj8VTwl960kzfiutwwR1jddKFzqA3Z+gMKMnOWt8OeRw6mpcb7EccJlH7
	 t2mfYxFMdkxVt9gmfJK2YodJTJ+zwyf6//u8hzCeLvuCrLXeaXKC50NsPqjiMo7FW8
	 Nr9VhiXW4kGiM0ME9co+C9eAYTLLm/LBlj/CFEqf1EOKEzlc+9dXV7PbWX2dHJrwFb
	 ibm54q5dALMFQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 14/19] netfilter: nft_set: remove indirection from update API call
Date: Fri, 25 Jul 2025 19:03:35 +0200
Message-Id: <20250725170340.21327-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

This stems from a time when sets and nft_dynset resided in different kernel
modules.  We can replace this with a direct call.

We could even remove both ->update and ->delete, given its only
supported by rhashtable, but on the off-chance we'll see runtime
add/delete for other types or a new set type keep that as-is for now.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      | 4 ----
 include/net/netfilter/nf_tables_core.h | 3 +++
 net/netfilter/nft_dynset.c             | 9 ++++-----
 net/netfilter/nft_set_hash.c           | 4 +---
 net/netfilter/nft_set_pipapo_avx2.c    | 1 -
 5 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5b6725475906..891e43a01bdc 100644
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
 
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 6c441e2dc8af..db5d367e43c4 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1137,7 +1137,6 @@ static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, uns
  * @net:	Network namespace
  * @set:	nftables API set representation
  * @key:	nftables API element representation containing key data
- * @ext:	nftables API extension pointer, filled with matching reference
  *
  * For more details, see DOC: Theory of Operation in nft_set_pipapo.c.
  *
-- 
2.30.2

