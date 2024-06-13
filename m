Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4587413D512;
	Thu, 13 Jun 2024 11:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279113; cv=none; b=RWKKp68Hlpd4/e80mMwdV7OYqn6ZUbaWG++lhCEQR58BpJCtEWboI0WUz5EtPfx64mva+aKgi8c5NJbVhE4tj2hHzi52az2PF/ZP4KHJauJl4EoMml2pxX7CIlEArFk9kXF+uCN/OHjxQxH78ZJ43hbfpibKlhSb5Sy7pZ4OTy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279113; c=relaxed/simple;
	bh=av1XUW+BTT85GCu/Sqb3B3x4M3F5gJ2N4cFTosDrZdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0MR8zPVNTe2PIamyxuhpdq5LM8Jz1/F6pGIpoOh8mmCGrBYXD/V7khCqD7ZyrWQRKly2n3P5mOiey+sgFkXCEcuTr9iIE6TPBcAWHqdWB2vaKM0chyvwHtd6L2d2MxK8tAZhags6URtOBNSSeRBszVwMchX7OJNsotYtUsgRb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfeOsY8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfeOsY8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3599C2BBFC;
	Thu, 13 Jun 2024 11:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279113;
	bh=av1XUW+BTT85GCu/Sqb3B3x4M3F5gJ2N4cFTosDrZdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfeOsY8ltmoBcE05rV2gFCiFGlVF96iysjYRzpT21jPxAPkwW1qwBaghzBtER4K6A
	 S/bAHjURHaSpdQ2W5CqAT9SND8AC2qU2DqTYd44CFEeMMiBL3bh2rmRD27c0OXN/NZ
	 yWdsZGcypNB4fqTXb9E4pXDhmEaSWndsNRs3wEgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.19 178/213] netfilter: nf_tables: fix memleak when more than 255 elements expired
Date: Thu, 13 Jun 2024 13:33:46 +0200
Message-ID: <20240613113234.848034243@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    2 +-
 net/netfilter/nf_tables_api.c     |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

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
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6857,12 +6857,15 @@ static int nft_trans_gc_space(struct nft
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
 
@@ -6879,15 +6882,18 @@ EXPORT_SYMBOL_GPL(nft_trans_gc_queue_asy
 
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
 


