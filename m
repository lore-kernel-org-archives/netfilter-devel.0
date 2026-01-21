Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20BE1A9F91
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2026 00:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768954145; cv=none; b=mV74WogFv4M/ynye/GPCXvTNVcAq54+gFvKg6n26f2bfJWoCtz09nmf/b3AzI2hPJcxLxYyhihdJiqHETanbncgngmLyczP/ci1Kx/Vh9TOGhWzqf9eaINfiZENLJLqvBPTQ9dhs5CWjqMaUMa2WtkN+lVy7xNXzsN3VtKzbtnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768954145; c=relaxed/simple;
	bh=RnSpzUPjG5xCdHZYy1TeL8IoWKipA9AeJwOtb1l+qmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcTJBlFx4AfSflGrCHM+rSvrxdzvSMJqyuvGJrW5SOV4tbDBarNT76GKrzV0GuAPjqi6eBndAQTBNOsa7xXd46AFMunhrZ8+qahOWuB08K9/xbprQoNKyXX13mOt3FCD6ID1N5X9/NElHBaiFnmSGgbsSYeGLA8ZBDy8xrl2ukI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KCkiCxH7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KCkiCxH7"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1CF6160291;
	Wed, 21 Jan 2026 01:08:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1768954134;
	bh=rqnsuLdq0Wo5ryZsFTTfDXE8KTyKUOMSkqndeowrdW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCkiCxH7VoLUpCI4sZB2pZXps3BpBrnaZNAAREiLhJ7x3YVtjKNN1sJMgoRZk/IHk
	 KP5tfGg303i2W8FOoUDZkzfMRwAUqFBaXdzDPyHjYoQ7mYmDABZCcE3/oqQY/JCFM7
	 r9mDkv+eQl3SAjEKmyYOkSHjkMzG2I/+KxxUzBgaEabBpWLCs/qX+RPp3O2PgVrJE0
	 SSD16p1KuzYzuvChoZPBiEgJWcL7iyQyctx9vadwArvWmMvSr/hNvJYBUwAbrhndCp
	 I6LNeXFQXVyj90IEqaVwgEAaC1plTH5AB022gvIvJPirza213EYVxo8EbxIDRQG5N7
	 uGKjsa7yKqGcA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v2 1/4] netfilter: nf_tables: add .abort_skip_removal flag for set types
Date: Wed, 21 Jan 2026 01:08:44 +0100
Message-ID: <20260121000847.294125-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121000847.294125-1-pablo@netfilter.org>
References: <20260121000847.294125-1-pablo@netfilter.org>
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
v2: fix kdoc error, per Florian Westphal.

 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c     | 3 ++-
 net/netfilter/nft_set_pipapo.c    | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0e266c2d0e7f..f1b67b40dd4d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -452,6 +452,7 @@ struct nft_set_ext;
  *	@init: initialize private data of new set instance
  *	@destroy: destroy private data of set instance
  *	@gc_init: initialize garbage collection
+ *	@abort_skip_removal: skip removal of elements from abort path
  *	@elemsize: element private size
  *
  *	Operations lookup, update and delete have simpler interfaces, are faster
@@ -509,6 +510,7 @@ struct nft_set_ops {
 						   const struct nft_set *set);
 	void				(*gc_init)(const struct nft_set *set);
 
+	bool				abort_skip_removal;
 	unsigned int			elemsize;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 729a92781a1a..2750336b6f28 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7806,7 +7806,8 @@ static bool nft_trans_elems_new_abort(const struct nft_ctx *ctx,
 			continue;
 		}
 
-		if (!te->set->ops->abort || nft_setelem_is_catchall(te->set, te->elems[i].priv))
+		if (!te->set->ops->abort_skip_removal ||
+		    nft_setelem_is_catchall(te->set, te->elems[i].priv))
 			nft_setelem_remove(ctx->net, te->set, te->elems[i].priv);
 
 		if (!nft_setelem_is_catchall(te->set, te->elems[i].priv))
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 6d77a5f0088a..18e1903b1d3d 100644
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

