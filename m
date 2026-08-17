Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A98E46C4BF;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786987351; cv=none; b=DxkjwFGzYNUZgQ1Jv5r27c1U5txDaSotY8V8uvcnawQjZ+V7K8CnmTAr78Olr/Nh5xEDWfsIBLDNzd15tDipOHLtk91gkQal9HCBNDpmQ4CrEHhmeJJB7AvAeIBcQtEUj0a3a0LPqlnJkoztwKWEBddD/lkhcoHhJp4NhnzMk4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786987351; c=relaxed/simple;
	bh=VljahOe7p0VAPWPJ3YuDXhxu24pzuwulFn3TWrtzzxw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q8d8S5ciIjxkDN+W/0X58ZCTxojlszyfjS3SELDQP3TgdExXCMtdkArz92LDrMFTylPjroIawNFvkBzgHVfsz6VQEhqmGR6LfLCCzlp1fagflblFPn8MlK3gMmNI+PxWfsxEsUPvfsqkbRnhdTox/bS94UKIuKruyEtbcHtf+Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZlR7Gvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZlR7Gvl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49D00C2BCB3;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987351;
	bh=VljahOe7p0VAPWPJ3YuDXhxu24pzuwulFn3TWrtzzxw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OZlR7Gvl1KE/j9ReXCRHP7Rt86OUBhV/ePaNwQDyxcSXkkG5ol2WLsDDGFfjNCBcV
	 PVIxF+ltwYjsXvOKAVy0xT+OFtG/i2egwaPIEq+RSrBCEqfBwsbu0GbdftUrtK0AMA
	 gGyxvRwfi/0LSmYuoH7CUu6+igpzb2LmBbmOGT9OQgMTCdtZBSOc1C7pEq3X4e11gR
	 YQhh8T1NPYniY1M0Ph059yqC59e10h8OudFMBZ3j7XV2N3EqMPAjGj+nbuz6HxS0z0
	 AdXgrz48igGjkaF05KQEDMxDTaOpxI7mwNwQtTNHR1zDXvoFTR68QNRpp1EvLon2X/
	 CvyjSfvtEP8Cg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2782DC5DF70;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:19 -0600
Subject: [PATCH 5/9] bpf/syscall: Route generic_map_update_batch key/value
 allocations to folio_scratchpad
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-5-0c1d230aa3af@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=2199;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=vm1aaD+pwQaXZSzhLFkT2JsY0U2BVsRDPtRXCFebL2I=;
 b=yxcUp3EtGyfmt7m8wjQpy/d4ZRch/7Ef/TJRKDqN6xOkUjagZRS1UvxqNUT9srZNE0A5I/Kqf
 Rvrf7VwYNhcAwfea2Ce5fgAe4ET6iLCh6mOiZH9iu26PxjqF38ObHo2
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com

From: Jim Cromie <jim.cromie@gmail.com>

Use struct folio_scratchpad to allocate transient key and value buffers
during map update batch operations, bypassing SLUB cache churn.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/bpf/syscall.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6db306d23b47..8ef48673b933 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -19,6 +19,7 @@
 #include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/folio_pool.h>
 #include <linux/license.h>
 #include <linux/filter.h>
 #include <linux/kernel.h>
@@ -2059,12 +2060,15 @@ int generic_map_delete_batch(struct bpf_map *map,
 	return err;
 }
 
+DEFINE_STATIC_KEY_TRUE(bpf_batch_scratchpad_key);
+
 int generic_map_update_batch(struct bpf_map *map, struct file *map_file,
 			     const union bpf_attr *attr,
 			     union bpf_attr __user *uattr)
 {
 	void __user *values = u64_to_user_ptr(attr->batch.values);
 	void __user *keys = u64_to_user_ptr(attr->batch.keys);
+	struct folio_scratchpad batch_sp;
 	u32 value_size, cp, max_count;
 	void *key, *value;
 	int err = 0;
@@ -2083,13 +2087,17 @@ int generic_map_update_batch(struct bpf_map *map, struct file *map_file,
 	if (put_user(0, &uattr->batch.count))
 		return -EFAULT;
 
-	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
+	folio_scratchpad_init_key(&batch_sp, 0, &bpf_batch_scratchpad_key);
+
+	key = folio_scratchpad_alloc(&batch_sp, map->key_size,
+				     sizeof(void *), GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
 
-	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = folio_scratchpad_alloc(&batch_sp, value_size,
+				       sizeof(void *), GFP_USER | __GFP_NOWARN);
 	if (!value) {
-		kvfree(key);
+		folio_scratchpad_free(&batch_sp);
 		return -ENOMEM;
 	}
 
@@ -2111,8 +2119,7 @@ int generic_map_update_batch(struct bpf_map *map, struct file *map_file,
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
 		err = -EFAULT;
 
-	kvfree(value);
-	kvfree(key);
+	folio_scratchpad_free(&batch_sp);
 
 	return err;
 }

-- 
2.55.0


