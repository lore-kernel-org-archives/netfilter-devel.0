Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260B98286B
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 08:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801208; cv=none; b=BVW885ymSxM+WzZn4Ob0bpYtjzpIk+ECEx72cCfa2gEzfhV4Yos6S3scyOdZbp8LDYIpIag8NFnnXB4wvqNSaVtfAUibMUP2+cyvlRkwc+R61vCH87ADXobsHDkyoyru/bpRp0YM5Arjz+a7Fy5e6y5MJSxtgVKFI5sMuiOr0I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801208; c=relaxed/simple;
	bh=C5iM9DgFAcrbNFzYy0gIaQmNJ2B2hCt64CLKjwY1/CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pe3YFXFtN6w5HPdcSvqMMN3/ghelne1PAgZqwPnqqCatRg2q/BkUMrj0CHBLkGiyAL43r+6xJi0eYVI1Qu3Rr+6EttrMH2w7xvxDv41KpIcwStR6i0T5n8Ci0WGC07pb59mC+svBuMFc/u5wQFygmsPGQ+ihmBmHdgI+8ONCWpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ri9On-0005Lb-JA; Thu, 07 Mar 2024 09:46:45 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/9] netfilter: nf_tables: condense catchall gc
Date: Thu,  7 Mar 2024 09:40:09 +0100
Message-ID: <20240307084018.2219-6-fw@strlen.de>
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

nft_trans_gc_catchall_sync can now re-use the helper added
in previous commit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 31 ++++++-------------------------
 net/netfilter/nft_set_pipapo.c    |  2 +-
 net/netfilter/nft_set_rbtree.c    |  2 +-
 4 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 66808ee0c515..12a1ded88182 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1758,7 +1758,7 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans);
 
 void nft_trans_gc_elem_add(struct nft_trans_gc *gc, void *priv);
 
-struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc);
+void nft_trans_gc_catchall_sync(const struct nft_trans_gc *gc);
 
 void nft_setelem_data_deactivate(const struct net *net,
 				 const struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0aba2834863b..5b69b3f9153c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9876,33 +9876,14 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans)
 	call_rcu(&trans->rcu, nft_trans_gc_trans_free);
 }
 
-struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc)
+void nft_trans_gc_catchall_sync(const struct nft_trans_gc *gc)
 {
-	struct nft_set_elem_catchall *catchall, *next;
-	u64 tstamp = nft_net_tstamp(gc->net);
-	const struct nft_set *set = gc->set;
-	struct nft_elem_priv *elem_priv;
-	struct nft_set_ext *ext;
-
-	WARN_ON_ONCE(!lockdep_commit_lock_is_held(gc->net));
-
-	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
-		ext = nft_set_elem_ext(set, catchall->elem);
-
-		if (!__nft_set_elem_expired(ext, tstamp))
-			continue;
-
-		gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
-		if (!gc)
-			return NULL;
-
-		elem_priv = catchall->elem;
-		nft_setelem_data_deactivate(gc->net, gc->set, elem_priv);
-		nft_setelem_catchall_destroy(catchall);
-		nft_trans_gc_elem_add(gc, elem_priv);
-	}
+	struct nft_ctx ctx = {
+		.table = gc->set->table,
+		.net = gc->net,
+	};
 
-	return gc;
+	nft_trans_gc_catchall(&ctx, gc->set);
 }
 
 static void nf_tables_module_autoload_cleanup(struct net *net)
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 4797f1aa3c11..35308de428c6 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1716,8 +1716,8 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		}
 	}
 
-	gc = nft_trans_gc_catchall_sync(gc);
 	if (gc) {
+		nft_trans_gc_catchall_sync(gc);
 		nft_trans_gc_queue_sync_done(gc);
 		priv->last_gc = jiffies;
 	}
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 0da94e9378ca..fc23fa76683a 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -678,7 +678,7 @@ static void nft_rbtree_gc(struct nft_set *set)
 try_later:
 
 	if (gc) {
-		gc = nft_trans_gc_catchall_sync(gc);
+		nft_trans_gc_catchall_sync(gc);
 		nft_trans_gc_queue_sync_done(gc);
 		priv->last_gc = jiffies;
 	}
-- 
2.43.0

