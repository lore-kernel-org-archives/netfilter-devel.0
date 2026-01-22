Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E3A3B4CBA;
	Thu, 22 Jan 2026 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099399; cv=none; b=ga03sLuGCgCzTCJGJKR8pTnxHc1qUAKDOQx95xscE7Ic12PlUhQr4Wf6g1kHfYyKufM91tHayKPACIZBwGiEHOFdJniGjVcIIxDT8mibB/oZLlpDe1XXjHjQyioNiKxsi+RSxfb4aU1djc4Uu7/w6V/xmen/F6Yd86qkar/DmCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099399; c=relaxed/simple;
	bh=4O/Kht/nE9P/Yj7zQ4tiI+ORNV2toJmaMs9JVzbXVt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6cyWRmOgCi3DSqO55FOO382jo4bIXA8VFqPx4CVpYyEAITrPl3htD0DZY+D3ZuQgNFf1vhx64d7vBQaRuTDkKbaDZyCvmqTnkp24dV3bAbWPz2/mSeiu+RekyDiMaXdCONicE5/7yJtT8qJZwPuoO1jxqUpMj5sNJXv9t3XhXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E6357604CF; Thu, 22 Jan 2026 17:29:42 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 1/4] netfilter: nf_tables: add .abort_skip_removal flag for set types
Date: Thu, 22 Jan 2026 17:29:32 +0100
Message-ID: <20260122162935.8581-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122162935.8581-1-fw@strlen.de>
References: <20260122162935.8581-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

The pipapo set backend is the only user of the .abort interface so far.
To speed up pipapo abort path, removals are skipped.

The follow up patch updates the rbtree to use to build an array of
ordered elements, then use binary search. This needs a new .abort
interface but, unlike pipapo, it also need to undo/remove elements.

Add a flag and use it from the pipapo set backend.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c     | 3 ++-
 net/netfilter/nft_set_pipapo.c    | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2597077442e5..31906f90706e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -451,6 +451,7 @@ struct nft_set_ext;
  *	@init: initialize private data of new set instance
  *	@destroy: destroy private data of set instance
  *	@gc_init: initialize garbage collection
+ *	@abort_skip_removal: skip removal of elements from abort path
  *	@elemsize: element private size
  *
  *	Operations lookup, update and delete have simpler interfaces, are faster
@@ -508,6 +509,7 @@ struct nft_set_ops {
 						   const struct nft_set *set);
 	void				(*gc_init)(const struct nft_set *set);
 
+	bool				abort_skip_removal;
 	unsigned int			elemsize;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e7247363c643..be4924aeaf0e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7807,7 +7807,8 @@ static bool nft_trans_elems_new_abort(const struct nft_ctx *ctx,
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
2.52.0

