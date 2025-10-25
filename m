Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281B3093DF;
	Sat, 25 Oct 2025 16:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409149; cv=none; b=Gldl2dKmyJIJ3PopjbjeVJ4EmrTDi6vbvVYsbHtn2ZJnGiUKDqmKNtx9Gmy4YEjdb7CH8lr7yQWePrjxxBz1RFKol6KRDSAoSgiHFlxlYiZc2imJYPDWvn5HG7M3ktrIT/Yp+WVkgvsFBsntyI5kgYRJxJVSuzcDHfj77XE5rjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409149; c=relaxed/simple;
	bh=wrHlvT9NGSd6dIpXwpHqzRvQB03j4gJMxxZs9rXSKQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aNO/mOeqaIMJQwsfkdBws64gGMHD4aw6YX5q3HzdmtPeULc4jAOtr3Eauk32If4Eoa1YW6A4Xa3UqrAuLPXx+kkUcRbhI9GJQ9qkOQoQfTNrAsvU7lnnH4z4PC//nqL8mBHhw4yeuINMJV7kebxcjam1waxyi7BAowMjR70YyeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZ5DNFSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZ5DNFSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793E1C116B1;
	Sat, 25 Oct 2025 16:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409149;
	bh=wrHlvT9NGSd6dIpXwpHqzRvQB03j4gJMxxZs9rXSKQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZ5DNFSc/pJTAXiik6ht9hSFgZsXkUhXB0BmMasVII178prpdnHSo5UNJ0L2VJRG2
	 zrWsDiY48t1FpAdXIbtroyZTuvAdSHSoRQhr5f0vOBPepGzG9Z46Tw390BC+3LSNx7
	 XJtNdm2BPBYpLqvvxGpvWhtzZ8cXGLNzIZ1t3X0s85NYSKN8MyVpj6DMP/6h4eyn+G
	 2p46OB+0NaebwQidS49m60WWqxJI0bGDcpZP+WJgRWup/UW/i3Maiip964SuiQmC2P
	 eZJKAR+xKjjTiXf+aQo9xQnS3VmibaR4Q6BGR/DCnmzSkCNxr3O+fVKs+fQA5VE/jB
	 XdR0c+dhKfL2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH AUTOSEL 6.17] netfilter: nf_tables: all transaction allocations can now sleep
Date: Sat, 25 Oct 2025 11:57:29 -0400
Message-ID: <20251025160905.3857885-218-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 3d95a2e016abab29ccb6f384576b2038e544a5a8 ]

Now that nft_setelem_flush is not called with rcu read lock held or
disabled softinterrupts anymore this can now use GFP_KERNEL too.

This is the last atomic allocation of transaction elements, so remove
all gfp_t arguments and the wrapper function.

This makes attempts to delete large sets much more reliable, before
this was prone to transient memory allocation failures.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

What changed
- Switched all nf_tables transaction element allocations to use
  sleepable allocations and removed gfp plumbing.
  - `nft_trans_alloc()` now always uses `kzalloc(..., GFP_KERNEL)`
    instead of parameterized gfp or `GFP_ATOMIC` via wrapper removal:
    net/netfilter/nf_tables_api.c:154.
  - Set-element transaction collapsing uses `krealloc(..., GFP_KERNEL)`:
    net/netfilter/nf_tables_api.c:457.
  - Removed gfp_t parameters from commit-list helpers and collapse
    logic; `nft_trans_commit_list_add_elem()` no longer takes/propagates
    gfp and simply collapses or enqueues:
    net/netfilter/nf_tables_api.c:535.
  - Bulk element flush paths allocate transactions and enqueue them
    without any atomic gfp flags:
    - `nft_setelem_flush()` allocates with `nft_trans_alloc(...
      GFP_KERNEL)` and enqueues via `nft_trans_commit_list_add_elem()`:
      net/netfilter/nf_tables_api.c:7872,
      net/netfilter/nf_tables_api.c:7893.
    - Catchall flush similarly enqueues with the new helper:
      net/netfilter/nf_tables_api.c:7906,
      net/netfilter/nf_tables_api.c:7912.

Why this is safe now (sleepable paths are guaranteed)
- The iter callback used for set-element flushing (`.fn =
  nft_setelem_flush`) runs in a context where sleeping is allowed during
  UPDATE walks:
  - Hash backend creates a snapshot under RCU and then iterates that
    snapshot with `commit_mutex` held so the callback “can sleep”
    (explicitly documented): net/netfilter/nft_set_hash.c:324–332,
    372–383.
  - Rbtree backend asserts `commit_mutex` for UPDATE walks and calls
    `iter->fn` under that mutex (no BH/RCU read section):
    net/netfilter/nft_set_rbtree.c:609–627.
  - Bitmap backend traverses with RCU but protected by `commit_mutex`
    (writer lock allowed for traversal) and calls `iter->fn` under that
    protection (sleepable): net/netfilter/nft_set_bitmap.c:230–241.
- The bulk delete entry point (`nf_tables_delsetelem`) sets up UPDATE
  walk (`.type = NFT_ITER_UPDATE`) and uses `nft_set_flush()` which
  wires `nft_setelem_flush` as the callback, ensuring it executes in the
  above sleepable contexts: net/netfilter/nf_tables_api.c:7940–7955.
- Transaction element additions/deletions are performed from netlink
  processing paths (process context), not hardirq/softirq handlers, so
  allocating with `GFP_KERNEL` is appropriate in all call sites shown by
  the new helpers: net/netfilter/nf_tables_api.c:7568–7597, 7847–7895,
  7906–7912.

User-visible impact (bug fix)
- Deleting large sets previously used `GFP_ATOMIC` along the
  flush/commit-item path, making allocations prone to transient failures
  under memory pressure. By switching to `GFP_KERNEL` and permitting
  sleeping, large set deletions become substantially more reliable,
  aligning with the commit message intent.
  - The collapsing path (`nft_trans_collapse_set_elem`) that may
    `krealloc` the transaction to coalesce elements now does so with
    `GFP_KERNEL`, reducing failure rates:
    net/netfilter/nf_tables_api.c:457–468.

Scope and risk
- Scope: confined to nf_tables internal transaction allocation/path; no
  UAPI changes, no semantic changes to ruleset behavior.
- Architectural changes: none; this is a cleanup following prior design
  changes that made iter callbacks sleepable.
- Side effects: allocations may now sleep. This is intended and correct
  given the current walk/flush call paths hold `commit_mutex` or operate
  on snapshot lists designed for sleepable callbacks, as shown above.
- Regression risk: low in trees that already have the reworked set
  walk/flush semantics (snapshot under RCU or commit_mutex-protected
  UPDATE walks). If a target stable tree does not include those enabling
  changes, backporting this patch alone would be unsafe because it could
  sleep in contexts that used to run under RCU read lock or with
  softirqs disabled. In such cases, this commit should be backported
  together with the prerequisite walk/flush changes (e.g., the
  hash/rbtree/bitmap UPDATE-walk designs that explicitly allow
  sleeping).

Conclusion
- This is a contained reliability fix that removes the last atomic
  allocation along nf_tables transaction element paths and is consistent
  with the current, sleepable UPDATE-walk design. It reduces transient
  ENOMEM failures when deleting large sets with minimal risk, provided
  the prerequisite sleepable-walk changes are present in the target
  stable series. Recommended for stable backport with that dependency
  consideration.

 net/netfilter/nf_tables_api.c | 47 ++++++++++++++---------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c3c73411c40c4..eed434e0a9702 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -151,12 +151,12 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	bitmap_zero(ctx->reg_inited, NFT_REG32_NUM);
 }
 
-static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
-					     int msg_type, u32 size, gfp_t gfp)
+static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
+					 int msg_type, u32 size)
 {
 	struct nft_trans *trans;
 
-	trans = kzalloc(size, gfp);
+	trans = kzalloc(size, GFP_KERNEL);
 	if (trans == NULL)
 		return NULL;
 
@@ -172,12 +172,6 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
 	return trans;
 }
 
-static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
-					 int msg_type, u32 size)
-{
-	return nft_trans_alloc_gfp(ctx, msg_type, size, GFP_KERNEL);
-}
-
 static struct nft_trans_binding *nft_trans_get_binding(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
@@ -442,8 +436,7 @@ static bool nft_trans_collapse_set_elem_allowed(const struct nft_trans_elem *a,
 
 static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 					struct nft_trans_elem *tail,
-					struct nft_trans_elem *trans,
-					gfp_t gfp)
+					struct nft_trans_elem *trans)
 {
 	unsigned int nelems, old_nelems = tail->nelems;
 	struct nft_trans_elem *new_trans;
@@ -466,9 +459,11 @@ static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 	/* krealloc might free tail which invalidates list pointers */
 	list_del_init(&tail->nft_trans.list);
 
-	new_trans = krealloc(tail, struct_size(tail, elems, nelems), gfp);
+	new_trans = krealloc(tail, struct_size(tail, elems, nelems),
+			     GFP_KERNEL);
 	if (!new_trans) {
-		list_add_tail(&tail->nft_trans.list, &nft_net->commit_list);
+		list_add_tail(&tail->nft_trans.list,
+			      &nft_net->commit_list);
 		return false;
 	}
 
@@ -484,7 +479,7 @@ static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 }
 
 static bool nft_trans_try_collapse(struct nftables_pernet *nft_net,
-				   struct nft_trans *trans, gfp_t gfp)
+				   struct nft_trans *trans)
 {
 	struct nft_trans *tail;
 
@@ -501,7 +496,7 @@ static bool nft_trans_try_collapse(struct nftables_pernet *nft_net,
 	case NFT_MSG_DELSETELEM:
 		return nft_trans_collapse_set_elem(nft_net,
 						   nft_trans_container_elem(tail),
-						   nft_trans_container_elem(trans), gfp);
+						   nft_trans_container_elem(trans));
 	}
 
 	return false;
@@ -537,17 +532,14 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 	}
 }
 
-static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans,
-					   gfp_t gfp)
+static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	WARN_ON_ONCE(trans->msg_type != NFT_MSG_NEWSETELEM &&
 		     trans->msg_type != NFT_MSG_DELSETELEM);
 
-	might_alloc(gfp);
-
-	if (nft_trans_try_collapse(nft_net, trans, gfp)) {
+	if (nft_trans_try_collapse(nft_net, trans)) {
 		kfree(trans);
 		return;
 	}
@@ -7573,7 +7565,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 						}
 
 						ue->priv = elem_priv;
-						nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+						nft_trans_commit_list_add_elem(ctx->net, trans);
 						goto err_elem_free;
 					}
 				}
@@ -7597,7 +7589,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 	return 0;
 
 err_set_full:
@@ -7863,7 +7855,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
 
 	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 	return 0;
 
 fail_ops:
@@ -7888,9 +7880,8 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	if (!nft_set_elem_active(ext, iter->genmask))
 		return 0;
 
-	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM,
-				    struct_size_t(struct nft_trans_elem, elems, 1),
-				    GFP_ATOMIC);
+	trans = nft_trans_alloc(ctx, NFT_MSG_DELSETELEM,
+				struct_size_t(struct nft_trans_elem, elems, 1));
 	if (!trans)
 		return -ENOMEM;
 
@@ -7901,7 +7892,7 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	nft_trans_elem_set(trans) = set;
 	nft_trans_container_elem(trans)->nelems = 1;
 	nft_trans_container_elem(trans)->elems[0].priv = elem_priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_ATOMIC);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 
 	return 0;
 }
@@ -7918,7 +7909,7 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_container_elem(trans)->elems[0].priv = elem_priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 
 	return 0;
 }
-- 
2.51.0

