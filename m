Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BE882C9B
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 08:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801223; cv=none; b=svdkD6NTi5qZGfsvoeM8AzMIluGms/gMsZfF2z9LsddUjj3xm2S1aJx/QnaY5d4O1wPYgfJ8nbcvJilJWZ9/KlcFtVJUYUUGUhM5q8UhYKiT97UqU4pYoUNQTot7GK1VNsb8MQiiFHm0skBcV/XpQ7N506kMvWfRrtK4Jk9oSiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801223; c=relaxed/simple;
	bh=ivtY2hkuvktJxEK+Ok8Jxb+2EcC3qgaIrEkgdOPPdfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtA9a8b/rnbWXy3GvC/uDA/woKfXl5Kj7jMwsJCnVDuhIX4FJzi3tuID08gSKSsLhzuZgqcmbbe1DJ6wb3TFU2ItBVRzUChDyYgBm8lF30IFelHHR+/+0NkeGOrNqQ+GJNFgr488KO4Ii50vfwhOzifYsCAjwmHo5fZnfLwMuSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ri9P0-0005Mb-Dj; Thu, 07 Mar 2024 09:46:58 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 8/9] netfilter: nf_tables: remove expired elements based on key lookup only
Date: Thu,  7 Mar 2024 09:40:12 +0100
Message-ID: <20240307084018.2219-9-fw@strlen.de>
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

Previous change looks up the candidate keys in the set, then
removes those that are expired or marked dead.

Keys that yield no result are skipped, keys where result
is not expired or dead are kept too.

We add new to_free pointer to store those elements
that have been deactivated and await release via call_rcu.

Because sequence checks are still in place, the key lookup
cannot fail and elements are always dead or expired.

Next patch will remove the gc sequence counters.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 28 +++++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6896279edb92..f0b85944e9eb 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1737,7 +1737,7 @@ struct nft_trans_flowtable {
 
 struct nft_trans_gc_key {
 	u32 key[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
-	struct nft_elem_priv	*priv;
+	struct nft_elem_priv	*to_free;
 };
 
 struct nft_trans_gc {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f1edbff734f6..8accb8498479 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9686,14 +9686,22 @@ static void nft_trans_gc_setelem_remove(struct nft_ctx *ctx,
 		memcpy(&elem.key, key->key, sizeof(elem.key));
 
 		err = nft_setelem_get(ctx, trans->set, &elem, NFT_SET_ELEM_GET_DEAD);
-		WARN_ON(err < 0);
-		WARN_ON(key->priv != elem.priv);
+		if (err < 0) {
+			trans->keys[i].to_free = NULL;
+			continue;
+		}
 
 		ext = nft_set_elem_ext(trans->set, elem.priv);
+
+		WARN_ON(nft_setelem_is_catchall(trans->set, elem.priv));
+
 		/* nft_dynset can mark non-expired as DEAD, remove those too */
 		if (nft_set_elem_expired(ext) || nft_set_elem_is_dead(ext)) {
+			key->to_free = elem.priv;
 			nft_setelem_data_deactivate(ctx->net, trans->set, elem.priv);
 			nft_setelem_remove(ctx->net, trans->set, elem.priv);
+		} else {
+			trans->keys[i].to_free = NULL;
 		}
 	}
 
@@ -9718,7 +9726,11 @@ static void nft_trans_gc_trans_free(struct rcu_head *rcu)
 	ctx.net	= read_pnet(&trans->set->net);
 
 	for (i = 0; i < trans->count; i++) {
-		elem_priv = trans->keys[i].priv;
+		elem_priv = trans->keys[i].to_free;
+
+		if (!elem_priv)
+			continue;
+
 		if (!nft_setelem_is_catchall(trans->set, elem_priv))
 			atomic_dec(&trans->set->nelems);
 
@@ -9734,6 +9746,13 @@ static int nft_trans_gc_space(struct nft_trans_gc *trans)
 	return NFT_TRANS_GC_BATCHCOUNT - trans->count;
 }
 
+static void nft_trans_gc_catchall_elem_add(struct nft_trans_gc *trans,
+					   struct nft_elem_priv *to_free)
+{
+	trans->keys[trans->count].to_free = to_free;
+	trans->count++;
+}
+
 static void nft_trans_gc_catchall(struct nft_ctx *ctx, struct nft_set *set)
 {
 	struct nft_set_elem_catchall *catchall, *next;
@@ -9769,7 +9788,7 @@ static void nft_trans_gc_catchall(struct nft_ctx *ctx, struct nft_set *set)
 		elem_priv = catchall->elem;
 		nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 		nft_setelem_catchall_destroy(catchall);
-		nft_trans_gc_elem_add(gc, elem_priv);
+		nft_trans_gc_catchall_elem_add(gc, elem_priv);
 	}
 
 	call_rcu(&gc->rcu, nft_trans_gc_trans_free);
@@ -9865,7 +9884,6 @@ void nft_async_gc_key_add(struct nft_trans_gc *gc, struct nft_elem_priv *priv)
 	ext = nft_set_elem_ext(set, priv);
 	memcpy(gc->keys[gc->count].key, nft_set_ext_key(ext), set->klen);
 
-	gc->keys[gc->count].priv = priv;
 	gc->count++;
 }
 
-- 
2.43.0

