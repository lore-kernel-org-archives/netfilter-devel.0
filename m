Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF2A282F2E
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Mar 2026 22:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772489572; cv=none; b=V5gy1m9EKkIDDp5udc0s146v8O9G0W9UoPhHD+lKWdUPgldLhesSsfg3Lw2EPsY8JgMOaEAvhWYNcvjokxfzPx6s5PLvRNadg3+JLstgYjhjqmE5LJ+WJr5fjXGz8cWA3HF1DePQXtqV5bsebiHg0aIKrKCJz+viBtf/f2WcLPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772489572; c=relaxed/simple;
	bh=nNzYpIe4uNcYad1qY6Jn8/BrmYE5/vsB177nFahLtCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RVP9jc+tl22NzdvY28d/kd3+OI9Fz1ijAcd+W/a4ihZ/RkPNgQTBqmIZvY4xH7puznMzv5aaklpGxyC7W0QsAXPZ4eZCCuWX02hC6ZEpy40YzTeEE1GjxMxprXSW1RXwbtjecW8dOVFs1gSni/9SGlIjhEcxvKSJP/7Gyhs0ZSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pv6mPkyu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pv6mPkyu"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6BB93600B9;
	Mon,  2 Mar 2026 23:12:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772489561;
	bh=ey/DONXDzTeIzEXF/bwkD5f6COBYkzHJSbMWOQU0gJM=;
	h=From:To:Cc:Subject:Date:From;
	b=pv6mPkyuEqdVm6rjvlv6esa5iolzKpZIF12YRI1tpJbwXMfL1WVS2EUanChrvI7EO
	 I3AeC11HED8fMFKrY7OqqOykeKpwRDWlD/saP332T8RbGO/Ypxg59sdj9DXDh7pLmH
	 sbZwNnF1Gqwu1LzRkqYxlt8gOOalu1qni3uodMn+4Fv0LjHeaC0zB+PtpESH5cMe5O
	 ng6l9ctWvWxOaDFIaovV+nB9/xF/WCj5s5/pjladucom7EywENKn3Y9al2x8XVoELP
	 nsPDvVZEs4ckM7BgB3mBBKEaRrA4uPmzre+7TN4MlQdcxQ1g0hopM7Yl/GRMcrHz0N
	 oyCUmsPxBRQIQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v2] netfilter: nf_tables: inconditionally bump set->nelems before insertion
Date: Mon,  2 Mar 2026 23:12:37 +0100
Message-ID: <20260302221237.2623791-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case that the set is full, a new element gets published then removed
without waiting for the RCU grace period, while RCU reader can be
walking over it already.

To address this issue, add the element transaction even if set is full,
but toggle the set_full flag to report -ENFILE so the abort path safely
unwinds the set to its previous state.

As for element updates, decrement set->nelems to restore it.

Fixes: 35d0ac9070ef ("netfilter: nf_tables: fix set->nelems counting with no NLM_F_EXCL")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix err_set_size error path per AI report.

 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0c5a4855b97d..08c819578514 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7171,6 +7171,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	bool set_full = false;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7462,10 +7463,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err_elem_free;
 
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = nft_set_maxsize(set), nelems;
+
+		nelems = atomic_inc_return(&set->nelems);
+		if (nelems > max)
+			set_full = true;
+	}
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_free;
+		goto err_set_size;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net);
@@ -7517,7 +7526,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 						ue->priv = elem_priv;
 						nft_trans_commit_list_add_elem(ctx->net, trans);
-						goto err_elem_free;
+						goto err_set_size;
 					}
 				}
 			}
@@ -7535,23 +7544,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
-		unsigned int max = nft_set_maxsize(set);
-
-		if (!atomic_add_unless(&set->nelems, 1, max)) {
-			err = -ENFILE;
-			goto err_set_full;
-		}
-	}
-
 	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
 	nft_trans_commit_list_add_elem(ctx->net, trans);
-	return 0;
 
-err_set_full:
-	nft_setelem_remove(ctx->net, set, elem.priv);
+	return set_full ? -ENFILE : 0;
+
 err_element_clash:
 	kfree(trans);
+err_set_size:
+	if (!(flags & NFT_SET_ELEM_CATCHALL))
+		atomic_dec(&set->nelems);
 err_elem_free:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
-- 
2.47.3

