Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE2C3446B2
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 12:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768481014; cv=none; b=Y2GjH3lhCdkgc9zfzMMwvgGamYb2j4ilhsoBaKf+knIWpUfPE7fcumh4VZg4Pw8PuOxaWL92WBqGpsniiV2H2g9EPKNhtqtZsm1xcDcEzO+Oq/5kqDQquwE9TiRtFA+OKnccFBQ9TAuHAphrS63Tde4e/wnneu8CIES7+KR4+cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768481014; c=relaxed/simple;
	bh=Rz7rSnVZLYVaL5vvJDEHYh2eAr5azRZRbHABXrSE5xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVFf+GgGC7ON3Vb8iXc3xSJstnAcFQO+erHoGoSB34xXTkUXFhDYo4Nn1zOXMhZnvhDZFbZrZGMJwdaACuJzj3NVHqb2SyRBX9LEwyopASzFFOjpP2VX6QyzJOjb9YUcZoLH2Q4rlWY3zkQgN2FBYLOvc3S85tQ49IGIWEoY90I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RJa6YZDw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RJa6YZDw"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 38A33605F3;
	Thu, 15 Jan 2026 13:43:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1768481011;
	bh=vux0p3mt05a7dvDmDxNNchgLbD42eZmUhSjl+6t12lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJa6YZDwdV/mCNQUPg8BexdM33F8lx0JnDWrQQicC7JPYAQwoscXjnGGqtZW0+Pfb
	 FMXxSrO45G3q1gmaNQii2QEYYyiQIRZSe38+ryHpRfz8tYkZmQIMkpreugK/gLC05U
	 3YTXPS/BhHhEc4DU4C2R8oPwGMC2rpSTXyxW1bHKdbmY62HXMISO0ElH3FP1fBmVDJ
	 KYQ97QBGhH9znmQWCj2UO6mYdYX2KedTAL1qsBoL9DRT3FBvbgVOkkklJEPvbrYhRU
	 jAcv0lwwAra8AzMvrSkWMpVY7y3mSdIXcLZ8fefra+D7uyVMPf/XABKLQgSMYaUa18
	 29070adz9NLOQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v1 1/3] netfilter: nf_tables: add .abort_skip_removal flag for set types
Date: Thu, 15 Jan 2026 13:43:20 +0100
Message-ID: <20260115124322.90712-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115124322.90712-1-pablo@netfilter.org>
References: <20260115124322.90712-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pipapo set backend is the only user of the .abort interface so far.
To speed up pipapo abort path, removals are skipped.

The follow up patch updates the rbtree to use to build an array of
ordered elements, then use binary search. This needs a new .abort
interface but, unlike pipapo, it also need to undo/remove elements.

Add a flag and use it from the pipapo set backend.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 1 +
 net/netfilter/nf_tables_api.c     | 2 +-
 net/netfilter/nft_set_pipapo.c    | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fab7dc73f738..21af1a2a6d3d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -509,6 +509,7 @@ struct nft_set_ops {
 						   const struct nft_set *set);
 	void				(*gc_init)(const struct nft_set *set);
 
+	bool				abort_skip_removal;
 	unsigned int			elemsize;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3de2f9bbebf..8f5ad4e89715 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7744,7 +7744,7 @@ static bool nft_trans_elems_new_abort(const struct nft_ctx *ctx,
 			continue;
 		}
 
-		if (!te->set->ops->abort || nft_setelem_is_catchall(te->set, te->elems[i].priv))
+		if (!te->set->ops->abort_skip_removal || nft_setelem_is_catchall(te->set, te->elems[i].priv))
 			nft_setelem_remove(ctx->net, te->set, te->elems[i].priv);
 
 		if (!nft_setelem_is_catchall(te->set, te->elems[i].priv))
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 112fe46788b6..412a1f1eafd8 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2370,6 +2370,7 @@ const struct nft_set_type nft_set_pipapo_type = {
 		.gc_init	= nft_pipapo_gc_init,
 		.commit		= nft_pipapo_commit,
 		.abort		= nft_pipapo_abort,
+		.abort_skip_removal = true,
 		.elemsize	= offsetof(struct nft_pipapo_elem, ext),
 	},
 };
@@ -2394,6 +2395,7 @@ const struct nft_set_type nft_set_pipapo_avx2_type = {
 		.gc_init	= nft_pipapo_gc_init,
 		.commit		= nft_pipapo_commit,
 		.abort		= nft_pipapo_abort,
+		.abort_skip_removal = true,
 		.elemsize	= offsetof(struct nft_pipapo_elem, ext),
 	},
 };
-- 
2.47.3

