Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A80E46985E;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786987351; cv=none; b=ju3FwHceCKG5pEkloH2g4ECFpUtHkeDrOVFwpLuuUyRLff8T9ejs1FjcuWXxYChxMrPOIbohWJJx/7B4qqoL68Egy5WzmZ5oPOqLjz0dQmnRt7NTkiH815eSyI29GFw80skBeoeihqmSwejDbFvKrEa06kAW9auYEzXphVnCdgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786987351; c=relaxed/simple;
	bh=U1+Ek/3s/WPSEWc+Ji9eDDTMwh4oU/I3rpqWvBD4/dE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eYmUfw64LQcmcJMljRws3rmr7oYpge+Kcjjc1citFIvd8HhahCl8J96AaIZouRcKzO5V6xDTNJvWHpxiZmSnKuItmQbXE9fTHK1M4nRtZkoPBVZpLBGrlBupXX1D710u4Yh+wg46e6UcGO7sb8jVWxlETaDbECQTyspkiwJGqCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifKnws5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifKnws5C"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C97EAC2BCFD;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987350;
	bh=U1+Ek/3s/WPSEWc+Ji9eDDTMwh4oU/I3rpqWvBD4/dE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ifKnws5CPv2vi0ZSSyMwNFx4srNsY5jJt7UxYma2Zri19tbwn1erPuOK9QL3+NuaB
	 +p8V3e3FsUTypKV18FKwrz4jLAdL/JMZN/FwFmuzCvAivepiGFUJPKC6tZ9s4giEv7
	 f4QlUmN+k+1gbYTd5PdZhaQfjJysS0sVO2zgZqeNe9uPOcoRUdcsj5VskHRCYkRc51
	 pkKo0tNfrP4DUjFlryhnf0k7Hl2kaDmVvY2oef7Tm5YiWm60HLv1OQ478ALvHop1fY
	 WoSjf1vTEDHPB9lgjVJFiMu8KzM/8+qOJAVz9kkMeyTDAHZSkxp8LdPLBjsz74uNiu
	 l+iTYjeweruug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41D5C5DF7A;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:16 -0600
Subject: [PATCH 2/9] netfilter/nf_tables: Add folio_scratchpad collector to
 struct nftables_pernet
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-2-0c1d230aa3af@gmail.com>
References: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
In-Reply-To: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Eduard Zingerman <eddyz87@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: netfilter-devel@vger.kernel.org, bpf@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, coreteam@netfilter.org, netdev@vger.kernel.org, 
 Jim Cromie <jim.cromie@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=7401;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=dSEV/cYCZ3Qb6/NhIB64Wuhs+Fc/mi4yHqcEj2j33Gk=;
 b=JwPFc40mfBR4l4YApSTZHSCZ60JTvPi2kTFJYnQLHTMRj0R/cy/XYGAl2tIVO8F41I9bQT35N
 I3eRa3fAx4RD7q8aW/DO5QQmwa/bXaAKx8GdSbIDsNvNBRYUqAEOm6f
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com

From: Jim Cromie <jim.cromie@gmail.com>

Embed a struct folio_scratchpad inside struct nftables_pernet to support
variable-sized region allocations and O(1) bulk teardown for Netfilter
batch transactions.

Route nft_trans_alloc allocations directly to folio_scratchpad_alloc_bytes(),
releasing all transaction objects in O(1) bulk via folio_scratchpad_free()
during commit/abort cleanup workers.

Controlled in-kernel ftrace function profiling on 10,015 netfilter batch
transaction allocations demonstrates ~12% faster allocation and ~7.6%
faster destroy worker teardown compared to standard SLUB.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 51 ++++++++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3be612145c13..b4a6cc1f46af 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1941,6 +1941,8 @@ __printf(2, 3) int nft_request_module(struct net *net, const char *fmt, ...);
 static inline int nft_request_module(struct net *net, const char *fmt, ...) { return -ENOENT; }
 #endif
 
+#include <linux/folio_pool.h>
+
 struct nftables_pernet {
 	struct list_head	tables;
 	struct list_head	commit_list;
@@ -1949,6 +1951,7 @@ struct nftables_pernet {
 	struct list_head	binding_list;
 	struct list_head	module_list;
 	struct list_head	notify_list;
+	struct folio_scratchpad	trans_scratchpad;
 	struct mutex		commit_mutex;
 	u64			table_handle;
 	u64			tstamp;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index af357f6c5070..8b9e0c905d84 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -173,12 +173,17 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	bitmap_zero(ctx->reg_inited, NFT_REG32_NUM);
 }
 
+DEFINE_FOLIO_POOL_STATIC_KEY_PARAM(nft_trans_scratchpad_key, trans_scratchpad,
+				   "Toggle nf_tables transaction folio scratchpad allocator");
+
 static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
 					 int msg_type, u32 size)
 {
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	struct nft_trans *trans;
 
-	trans = kzalloc(size, GFP_KERNEL);
+	trans = folio_scratchpad_alloc_bytes(nft_net, trans_scratchpad, size,
+					     __alignof__(struct nft_trans), GFP_KERNEL);
 	if (trans == NULL)
 		return NULL;
 
@@ -194,6 +199,18 @@ static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
 	return trans;
 }
 
+/*
+ * nft_trans_free - release a transaction object.
+ *
+ * Scratchpad-backed objects are not individually freed; they are reclaimed in
+ * bulk by folio_scratchpad_free() at batch commit/abort boundary.  Kzalloc'd
+ * objects reside on slab pages and are released immediately via kfree().
+ */
+static inline void nft_trans_free(struct nft_trans *trans)
+{
+	folio_scratchpad_free_elem(trans);
+}
+
 static struct nft_trans_binding *nft_trans_get_binding(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
@@ -219,7 +236,7 @@ static void nft_trans_list_del(struct nft_trans *trans)
 static void nft_trans_destroy(struct nft_trans *trans)
 {
 	nft_trans_list_del(trans);
-	kfree(trans);
+	nft_trans_free(trans);
 }
 
 static void __nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set,
@@ -519,8 +536,10 @@ static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 	/* krealloc might free tail which invalidates list pointers */
 	list_del_init(&tail->nft_trans.list);
 
-	new_trans = krealloc(tail, struct_size(tail, elems, nelems),
-			     GFP_KERNEL);
+	new_trans = folio_scratchpad_realloc(tail,
+					     struct_size(tail, elems, old_nelems),
+					     struct_size(tail, elems, nelems),
+					     GFP_KERNEL);
 	if (!new_trans) {
 		list_add_tail(&tail->nft_trans.list,
 			      &nft_net->commit_list);
@@ -600,7 +619,7 @@ static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *tr
 		     trans->msg_type != NFT_MSG_DELSETELEM);
 
 	if (nft_trans_try_collapse(nft_net, trans)) {
-		kfree(trans);
+		nft_trans_free(trans);
 		return;
 	}
 
@@ -3068,7 +3087,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 err_trans:
 	free_percpu(stats);
-	kfree(trans);
+	nft_trans_free(trans);
 err_hooks:
 	if (nla[NFTA_CHAIN_HOOK]) {
 		list_for_each_entry_safe(h, next, &hook.list, list) {
@@ -7636,7 +7655,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	return set_full ? -ENFILE : 0;
 
 err_element_clash:
-	kfree(trans);
+	nft_trans_free(trans);
 err_set_size:
 	if (!(flags & NFT_SET_ELEM_CATCHALL))
 		atomic_dec(&set->nelems);
@@ -7904,7 +7923,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 
 fail_ops:
-	kfree(trans);
+	nft_trans_free(trans);
 fail_trans:
 	kfree(elem.priv);
 fail_elem_key_end:
@@ -8287,7 +8306,7 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	return 0;
 
 err_free_trans:
-	kfree(trans);
+	nft_trans_free(trans);
 err_trans:
 	module_put(type->owner);
 	return err;
@@ -10253,7 +10272,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	if (trans->put_net)
 		put_net(trans->net);
 
-	kfree(trans);
+	nft_trans_free(trans);
 }
 
 static void nf_tables_trans_destroy_work(struct work_struct *w)
@@ -10275,6 +10294,8 @@ static void nf_tables_trans_destroy_work(struct work_struct *w)
 		nft_trans_list_del(trans);
 		nft_commit_release(trans);
 	}
+
+	folio_scratchpad_reset(&nft_net->trans_scratchpad);
 }
 
 void nf_tables_trans_destroy_flush_work(struct net *net)
@@ -11244,7 +11265,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
 	}
-	kfree(trans);
+	nft_trans_free(trans);
 }
 
 static void nft_set_abort_update(struct list_head *set_update_list)
@@ -11468,6 +11489,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		nf_tables_abort_release(trans);
 	}
 
+	folio_scratchpad_reset(&nft_net->trans_scratchpad);
+
 	return err;
 }
 
@@ -11499,6 +11522,9 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 	else
 		nf_tables_module_autoload_cleanup(net);
 
+	folio_scratchpad_free(&nft_net->trans_scratchpad);
+	folio_scratchpad_init(&nft_net->trans_scratchpad, 4);
+
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
@@ -12142,6 +12168,8 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->binding_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
+	folio_scratchpad_init_key(&nft_net->trans_scratchpad, get_order(SZ_64K),
+				  &nft_trans_scratchpad_key);
 	mutex_init(&nft_net->commit_mutex);
 	net->nft.base_seq = 1;
 	nft_net->gc_seq = 0;
@@ -12186,6 +12214,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->notify_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->destroy_list));
+	folio_scratchpad_free(&nft_net->trans_scratchpad);
 }
 
 static void nf_tables_exit_batch(struct list_head *net_exit_list)

-- 
2.55.0


