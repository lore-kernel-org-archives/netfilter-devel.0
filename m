Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C512082D8F
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 08:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801204; cv=none; b=gkmHPbE4v8kQjcNQ5Njz7xUhQeJFfI6MBVaoq8SjbR+1gESSZZsu9eGr63/9iJFFiwWb+BdVMI4Pg9z32wJWLMnRL4IRmkO9JNwVtUA1c0z2MHosECWsu71oadwD61+DgeMDnFi6tUYi9RE3eLLU57gOpL8TRGlG5QiGezA8R5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801204; c=relaxed/simple;
	bh=IEdVkfCxcq67N10CMQKIJ4DcxgX9JaCup8rjnisLpyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTK4dYqkzD8v/xBFUpWdQ0Mdb+Rv8MsB6o89QRbg6ToTCbGQKfs5hhxh9ZiOwa1BqKFc34JvmFnzseUzxQlpJ/OPYkSZw7nBhhcwAwZG1yO/ZojketSu5LYMVGwiRTMKlNr67KaZRzxDU9gA0uz+YxK+4Rg5R+GohuEt0gLyDvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ri9Oj-0005L9-9K; Thu, 07 Mar 2024 09:46:41 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/9] netfilter: remove nft_trans_gc_catchall_async handling
Date: Thu,  7 Mar 2024 09:40:08 +0100
Message-ID: <20240307084018.2219-5-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307084018.2219-1-fw@strlen.de>
References: <20240307084018.2219-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its not needed: async gc *must* defer removal of expired elements
to the work queue, as it cannot acquire the transaction mutex.

Therefore, just walk the catchall list from the work queue,
where we do hold the transaction mutex.

Then, just do what the catchall_sync() handling is already doing:
1. Detach the element via list_del_rcu
2. release the container structure via kfree_rcu
3. decrement the use counters
4. kfree the real element from call_rcu().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  2 -
 net/netfilter/nf_tables_api.c     | 79 ++++++++++++++++++-------------
 net/netfilter/nft_set_hash.c      |  2 -
 3 files changed, 47 insertions(+), 36 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e27c28b612e4..66808ee0c515 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1758,8 +1758,6 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans);
 
 void nft_trans_gc_elem_add(struct nft_trans_gc *gc, void *priv);
 
-struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
-						 unsigned int gc_seq);
 struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc);
 
 void nft_setelem_data_deactivate(const struct net *net,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d6448d6e9a18..0aba2834863b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9693,6 +9693,52 @@ static void nft_trans_gc_trans_free(struct rcu_head *rcu)
 	nft_trans_gc_destroy(trans);
 }
 
+static int nft_trans_gc_space(struct nft_trans_gc *trans)
+{
+	return NFT_TRANS_GC_BATCHCOUNT - trans->count;
+}
+
+static void nft_trans_gc_catchall(struct nft_ctx *ctx, struct nft_set *set)
+{
+	struct nft_set_elem_catchall *catchall, *next;
+	struct nft_trans_gc *gc = NULL;
+	struct nft_set_ext *ext;
+
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
+
+	list_for_each_entry(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+
+		if (!nft_set_elem_expired(ext))
+			continue;
+
+		gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
+		break;
+	}
+
+	if (!gc)
+		return;
+
+	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
+		struct nft_elem_priv *elem_priv;
+
+		ext = nft_set_elem_ext(set, catchall->elem);
+
+		if (!nft_set_elem_expired(ext))
+			continue;
+
+		if (!nft_trans_gc_space(gc))
+			break;
+
+		elem_priv = catchall->elem;
+		nft_setelem_data_deactivate(ctx->net, set, elem_priv);
+		nft_setelem_catchall_destroy(catchall);
+		nft_trans_gc_elem_add(gc, elem_priv);
+	}
+
+	call_rcu(&gc->rcu, nft_trans_gc_trans_free);
+}
+
 static bool nft_trans_gc_work_done(struct nft_trans_gc *trans)
 {
 	struct nftables_pernet *nft_net;
@@ -9716,6 +9762,7 @@ static bool nft_trans_gc_work_done(struct nft_trans_gc *trans)
 	ctx.table = trans->set->table;
 
 	nft_trans_gc_setelem_remove(&ctx, trans);
+	nft_trans_gc_catchall(&ctx, trans->set);
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return true;
@@ -9777,11 +9824,6 @@ static void nft_trans_gc_queue_work(struct nft_trans_gc *trans)
 	schedule_work(&trans_gc_work);
 }
 
-static int nft_trans_gc_space(struct nft_trans_gc *trans)
-{
-	return NFT_TRANS_GC_BATCHCOUNT - trans->count;
-}
-
 struct nft_trans_gc *nft_trans_gc_queue_async(struct nft_trans_gc *gc,
 					      unsigned int gc_seq, gfp_t gfp)
 {
@@ -9834,33 +9876,6 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans)
 	call_rcu(&trans->rcu, nft_trans_gc_trans_free);
 }
 
-struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
-						 unsigned int gc_seq)
-{
-	struct nft_set_elem_catchall *catchall;
-	const struct nft_set *set = gc->set;
-	struct nft_set_ext *ext;
-
-	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
-		ext = nft_set_elem_ext(set, catchall->elem);
-
-		if (!nft_set_elem_expired(ext))
-			continue;
-		if (nft_set_elem_is_dead(ext))
-			goto dead_elem;
-
-		nft_set_elem_dead(ext);
-dead_elem:
-		gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
-		if (!gc)
-			return NULL;
-
-		nft_trans_gc_elem_add(gc, catchall->elem);
-	}
-
-	return gc;
-}
-
 struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc)
 {
 	struct nft_set_elem_catchall *catchall, *next;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 6b0f84ef4e5f..2e116b1e966e 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -376,8 +376,6 @@ static void nft_rhash_gc(struct work_struct *work)
 		nft_trans_gc_elem_add(gc, he);
 	}
 
-	gc = nft_trans_gc_catchall_async(gc, gc_seq);
-
 try_later:
 	/* catchall list iteration requires rcu read side lock. */
 	rhashtable_walk_stop(&hti);
-- 
2.43.0

