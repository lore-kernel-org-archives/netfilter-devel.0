Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C03846AA62;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786987351; cv=none; b=ikIzB3MaNOgaEEmCQTU4z+t+uqGj2134a98ZVqnGbGD2MTxKRkb1O2V0myNmtrGY6S8shefU3+YsbuzxRXFhME2ZPFD/I/F4k0qnRfpz+vG+QSn4xivjq81MsORKiYYsSwjSvmJrXOfU9veUiqhg8uMSZEu11zqKtdj3poCnGXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786987351; c=relaxed/simple;
	bh=kuEHwBXtGwctLu6qKXdhOx+wx0UojFjK0d0zFur0xrI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z4mVwRraJ7w/B36jWQrzWK201LBz+pcxUDaO02UPAzdi5/wMi2iumC94Vnuz6wvoCikt/FMifkE6wmBPf+tWhLge/Zifw02FNtd3zOTV0SDL8C2Yem8THL/3GQCIaxfMsZ/p5H9VHrG1e1UuyBkT3l9Ou3FEeyR+uuXdR9AojJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kG43H0jB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kG43H0jB"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D4A9C2BD04;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987351;
	bh=kuEHwBXtGwctLu6qKXdhOx+wx0UojFjK0d0zFur0xrI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kG43H0jBu0rVsrd1NgkPvUPGMVMYK1kcKXsqFvXQLFPW25EqEaT4L8YJtveEm67Xp
	 xC2Eo58kMX6Xkx0/UTlExtNVLTnnDeS7WAheSzyLL2lYCwJ6gkfBLmDDmMlX70yQ/h
	 5j2WkCHzpipz91qd/luctZvN68eIOKYZ/+nl3PYMicNksHUsDxpxIcCt72EqAuE113
	 uSbjPK0MfO5S1+wbLj5kwrYh72yXDi+OgaEZ/I8oBGhrtc4ExYRjMSb1QycWxONZOh
	 Btzx7BoGq3Xq7JiAoNB73R5znsZd6vQwAYUuYUZerPMkj6dgBlKV4B/Hp4XlUyt0n+
	 ztyybcMMTRNxA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E31C5DF66;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:18 -0600
Subject: [PATCH 4/9] drm/gpuvm: Route gpuva_op allocations to
 folio_scratchpad
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-4-0c1d230aa3af@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=2727;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=hfnn2JXUUX2MnAJuI+XocbzOzt9nFPPM4gsyoKFfaV8=;
 b=tOf7FwZgeFhwjRf2P61V+1ciBVYTcBIRJ4/DWzCwZDYpfrvSen9nBPACUBxDKUMeVVJ8v4CaP
 mkzXUqlmIs3DYZ8/WvkgAQUjjUavZdG8d4TJsDC7vinDqpN8OckRK7E
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com

From: Jim Cromie <jim.cromie@gmail.com>

Embed a struct folio_scratchpad inside struct drm_gpuvm and route
default gpuva_op allocations in gpuva_op_alloc() to
folio_scratchpad_alloc_obj(), with O(1) bulk teardown in
drm_gpuvm_fini().

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/gpu/drm/drm_gpuvm.c | 11 +++++++++--
 include/drm/drm_gpuvm.h     |  6 ++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpuvm.c b/drivers/gpu/drm/drm_gpuvm.c
index c422c5af1f4b..6bb82ac9e2d6 100644
--- a/drivers/gpu/drm/drm_gpuvm.c
+++ b/drivers/gpu/drm/drm_gpuvm.c
@@ -1109,6 +1109,8 @@ drm_gpuvm_init(struct drm_gpuvm *gpuvm, const char *name,
 	spin_lock_init(&gpuvm->evict.lock);
 
 	init_llist_head(&gpuvm->bo_defer);
+	folio_scratchpad_init_key(&gpuvm->va_scratchpad, get_order(SZ_64K),
+				  &gpuvm_scratchpad_key);
 
 	kref_init(&gpuvm->kref);
 
@@ -1155,6 +1157,7 @@ drm_gpuvm_fini(struct drm_gpuvm *gpuvm)
 	drm_WARN(gpuvm->drm, !llist_empty(&gpuvm->bo_defer),
 		 "VM BO cleanup list should be empty.\n");
 
+	folio_scratchpad_free(&gpuvm->va_scratchpad);
 	drm_gem_object_put(gpuvm->r_obj);
 }
 
@@ -2849,6 +2852,9 @@ drm_gpuvm_sm_unmap_exec_lock(struct drm_gpuvm *gpuvm, struct drm_exec *exec,
 }
 EXPORT_SYMBOL_GPL(drm_gpuvm_sm_unmap_exec_lock);
 
+DEFINE_FOLIO_POOL_STATIC_KEY_PARAM(gpuvm_scratchpad_key, va_scratchpad,
+				   "Toggle DRM GPUVM range folio scratchpad allocator");
+
 static struct drm_gpuva_op *
 gpuva_op_alloc(struct drm_gpuvm *gpuvm)
 {
@@ -2858,7 +2864,8 @@ gpuva_op_alloc(struct drm_gpuvm *gpuvm)
 	if (fn && fn->op_alloc)
 		op = fn->op_alloc();
 	else
-		op = kzalloc_obj(*op);
+		op = folio_scratchpad_alloc_obj(gpuvm, va_scratchpad,
+						struct drm_gpuva_op, GFP_KERNEL);
 
 	if (unlikely(!op))
 		return NULL;
@@ -2875,7 +2882,7 @@ gpuva_op_free(struct drm_gpuvm *gpuvm,
 	if (fn && fn->op_free)
 		fn->op_free(op);
 	else
-		kfree(op);
+		folio_scratchpad_free_elem(op);
 }
 
 static int
diff --git a/include/drm/drm_gpuvm.h b/include/drm/drm_gpuvm.h
index 655bd9104ffb..362b1d88d30d 100644
--- a/include/drm/drm_gpuvm.h
+++ b/include/drm/drm_gpuvm.h
@@ -30,6 +30,7 @@
 #include <linux/llist.h>
 #include <linux/rbtree.h>
 #include <linux/types.h>
+#include <linux/folio_pool.h>
 
 #include <drm/drm_device.h>
 #include <drm/drm_gem.h>
@@ -338,6 +339,11 @@ struct drm_gpuvm {
 	 * @bo_defer: structure holding vm_bos that need to be destroyed
 	 */
 	struct llist_head bo_defer;
+
+	/**
+	 * @va_scratchpad: folio scratchpad for transient GPU VA range allocations
+	 */
+	struct folio_scratchpad va_scratchpad;
 };
 
 void drm_gpuvm_init(struct drm_gpuvm *gpuvm, const char *name,

-- 
2.55.0


