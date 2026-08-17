Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442CB46AF0A;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786987351; cv=none; b=ntGsVSKz58GzVxTtDg1L1uCMBPnkSH9s6pKLpx08RGAKjTRUnpK74kfmlPuA/0WtOgW58LP4/PI0mhB4mypSiWb3NvFwmnutkuseR7thPlrGi3CxkFCuOzAoLqttff7aE/hC8pFHRvrAko9vQyZTZV1C2DD93YBxG7gx3ln7W9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786987351; c=relaxed/simple;
	bh=zTdYOCGpPbvo6ufi809Rri+YRM94kX0f0IXePRW5ia8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gBUuTIwSv+5/SGRmeidtgn9yqW3j/9fqKqGCQD2sQEZDpQNLMo86bu77cxjhA70NTZir1c04o40d1bzWTPp7CoViH2CRUfEm7TXYS0wZoUB6yi0SdTJAC7JOo37SGhDNm3BTZmgw+kMDcni2bd3SYoSbTBpOJFz67m7OeuYOoTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P52QHUq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P52QHUq3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3897C2BCFF;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987351;
	bh=zTdYOCGpPbvo6ufi809Rri+YRM94kX0f0IXePRW5ia8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=P52QHUq3/xcorcXZu7r6tCjygUQFwidPFzHoCJgQuXjwkzo58DSIP80l4FJrf3if4
	 IGJxZWmoAC6om3/Pwce84778ATkDQKcLgVIMAL0vOMFlBmmca6FD8oaYdBTTYcRfZ5
	 EwrO5S4MitRZmQnMm/3v8xxyfFsB1FsDgnA7FwMEr8WSS5Yb6prfvV8wyAyRX+eCnc
	 esGFRuBzJWG3k2DAO7rcs6fN0+sDoukjnFGeEJUdWErwJzMVBxQvpKluM3rNFGa/V7
	 iNCV3jOh4HXj8ubJZ22K3sPGKlOfUxoRrbJPaJtK7kADVDB/zshSt1nESuDBIygr9W
	 zIG63CTRAn3Xw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5935C5B572;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:17 -0600
Subject: [PATCH 3/9] bpf/verifier: Route verifier stack state node
 allocations to folio_pool
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-3-0c1d230aa3af@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=3668;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=wd43RzukeW/QIRUOsguKGysZSVWNap+EkJQwmYjEf9A=;
 b=RF7O0cJ6UhuZWtoBFwIEZu/Uet9+m63ZwGntlkc7HifWVQ9cB6lvVPZZZ7oAkyvhDWt0UEWjL
 GN7mnVJCnK5CEvsqbKbNn1jrRMc23jiFMLCZ23LsNR5YNbIQiBnNZdV
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com

From: Jim Cromie <jim.cromie@gmail.com>

Embed a struct folio_pool inside struct bpf_verifier_env to allocate
transient bpf_verifier_stack_elem frames using direct-map large folios,
releasing all frames in bulk at the end of bpf_check().

Use folio_pool_alloc_obj() to preserve strict type specificity at callsites.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/bpf_verifier.h |  3 +++
 kernel/bpf/verifier.c        | 16 +++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 39a851e690ec..43f5f0eaffac 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -898,6 +898,8 @@ struct bpf_scc_info {
 
 struct bpf_liveness;
 
+#include <linux/folio_pool.h>
+
 /* single container for all structs
  * one verifier_env per bpf_check() call
  */
@@ -907,6 +909,7 @@ struct bpf_verifier_env {
 	struct bpf_prog *prog;		/* eBPF program being verified */
 	const struct bpf_verifier_ops *ops;
 	struct module *attach_btf_mod;	/* The owner module of prog->aux->attach_btf */
+	struct folio_pool state_pool;	/* pool for transient state nodes */
 	struct bpf_verifier_stack_elem *head; /* stack of verifier states to be processed */
 	int stack_size;			/* number of states to be processed */
 	bool strict_alignment;		/* perform strict pointer alignment checks */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fdc5fbb1f78c..8a9e66ce4dc8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1725,7 +1725,7 @@ static int pop_stack(struct bpf_verifier_env *env, int *prev_insn_idx,
 		*prev_insn_idx = head->prev_insn_idx;
 	elem = head->next;
 	bpf_free_verifier_state(&head->st, false);
-	kfree(head);
+	folio_pool_free_elem(head);
 	env->head = elem;
 	env->stack_size--;
 	return 0;
@@ -1743,6 +1743,8 @@ static bool error_recoverable_with_nospec(int err)
 	return err == -EPERM || err == -EACCES || err == -EINVAL;
 }
 
+DEFINE_STATIC_KEY_TRUE(bpf_state_pool_key);
+
 static struct bpf_verifier_state *push_stack(struct bpf_verifier_env *env,
 					     int insn_idx, int prev_insn_idx,
 					     bool speculative)
@@ -1751,7 +1753,9 @@ static struct bpf_verifier_state *push_stack(struct bpf_verifier_env *env,
 	struct bpf_verifier_stack_elem *elem;
 	int err;
 
-	elem = kzalloc_obj(struct bpf_verifier_stack_elem, GFP_KERNEL_ACCOUNT);
+	elem = folio_pool_alloc_obj(env, state_pool,
+				    struct bpf_verifier_stack_elem,
+				    GFP_KERNEL_ACCOUNT);
 	if (!elem)
 		return ERR_PTR(-ENOMEM);
 
@@ -2275,7 +2279,9 @@ static struct bpf_verifier_state *push_async_cb(struct bpf_verifier_env *env,
 	struct bpf_verifier_stack_elem *elem;
 	struct bpf_func_state *frame;
 
-	elem = kzalloc_obj(struct bpf_verifier_stack_elem, GFP_KERNEL_ACCOUNT);
+	elem = folio_pool_alloc_obj(env, state_pool,
+				    struct bpf_verifier_stack_elem,
+				    GFP_KERNEL_ACCOUNT);
 	if (!elem)
 		return ERR_PTR(-ENOMEM);
 
@@ -19789,6 +19795,9 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr,
 	if (!env)
 		return -ENOMEM;
 
+	folio_pool_init_key(&env->state_pool, sizeof(struct bpf_verifier_stack_elem),
+			    get_order(SZ_64K), &bpf_state_pool_key);
+
 	env->bt.env = env;
 
 	len = (*prog)->len;
@@ -20055,6 +20064,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr,
 	bpf_clear_insn_aux_data(env, 0, env->prog->len);
 err_free_env:
 	bpf_stack_liveness_free(env);
+	folio_pool_free(&env->state_pool);
 	kvfree(env->cfg.insn_postorder);
 	kvfree(env->scc_info);
 	kvfree(env->succ);

-- 
2.55.0


