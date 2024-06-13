Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6600E2B9C6;
	Thu, 13 Jun 2024 01:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240552; cv=none; b=l/xp6TQBkEweDjpAua5CTvvf6S7nGZ/v3I9zRySTZ0vY5J9I91kDmAiTy+zZlmj9iFOHwft/dkGFEwpG8ey6qeADn3FPdbjJafH7xawxUYNstn1mZJhevEYRbAqV0Z3ZeSW4YmQd6XkPLNGEn4pjiY2l2z8HxZaZ++xcp80f+xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240552; c=relaxed/simple;
	bh=0VkQgmPnbB/+XlzyThYBUaNzxM2v3PtgyEQGhZBnCas=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iFAOWxawjrrCKXIxH1YRsvf6i+jx8EqMVRV/249FrZbZDWXtA6ojDkpedF1Ea4fQqbiaTXKnZzxs3jhR7C2T/1NZSFgcm+LZMqwxFgBEw+Xzkwy5W5AbqleawCOVyYa0ZD5dRjWur1NVSQMjijapQJUFBM/hKVG2/PJOlJlQcfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 20/40] netfilter: nf_tables: fix memleak when more than 255 elements expired
Date: Thu, 13 Jun 2024 03:01:49 +0200
Message-Id: <20240613010209.104423-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit cf5000a7787cbc10341091d37245a42c119d26c5 upstream.

When more than 255 elements expired we're supposed to switch to a new gc
container structure.

This never happens: u8 type will wrap before reaching the boundary
and nft_trans_gc_space() always returns true.

This means we recycle the initial gc container structure and
lose track of the elements that came before.

While at it, don't deref 'gc' after we've passed it to call_rcu.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 70fdfe6d410b..ff1e2a1afa1e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1389,7 +1389,7 @@ struct nft_trans_gc {
 	struct net		*net;
 	struct nft_set		*set;
 	u32			seq;
-	u8			count;
+	u16			count;
 	void			*priv[NFT_TRANS_GC_BATCHCOUNT];
 	struct rcu_head		rcu;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a48e92114bdc..1f303d29597e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6857,12 +6857,15 @@ static int nft_trans_gc_space(struct nft_trans_gc *trans)
 struct nft_trans_gc *nft_trans_gc_queue_async(struct nft_trans_gc *gc,
 					      unsigned int gc_seq, gfp_t gfp)
 {
+	struct nft_set *set;
+
 	if (nft_trans_gc_space(gc))
 		return gc;
 
+	set = gc->set;
 	nft_trans_gc_queue_work(gc);
 
-	return nft_trans_gc_alloc(gc->set, gc_seq, gfp);
+	return nft_trans_gc_alloc(set, gc_seq, gfp);
 }
 EXPORT_SYMBOL_GPL(nft_trans_gc_queue_async);
 
@@ -6879,15 +6882,18 @@ EXPORT_SYMBOL_GPL(nft_trans_gc_queue_async_done);
 
 struct nft_trans_gc *nft_trans_gc_queue_sync(struct nft_trans_gc *gc, gfp_t gfp)
 {
+	struct nft_set *set;
+
 	if (WARN_ON_ONCE(!lockdep_commit_lock_is_held(gc->net)))
 		return NULL;
 
 	if (nft_trans_gc_space(gc))
 		return gc;
 
+	set = gc->set;
 	call_rcu(&gc->rcu, nft_trans_gc_trans_free);
 
-	return nft_trans_gc_alloc(gc->set, 0, gfp);
+	return nft_trans_gc_alloc(set, 0, gfp);
 }
 EXPORT_SYMBOL_GPL(nft_trans_gc_queue_sync);
 
-- 
2.30.2

