Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E225F46D08C;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786987352; cv=none; b=m3cMMc3SAPBj3APyH8N3lWno39K/+5TtW+ND9mTZZfxukSq5jD5X3w0k3iptUuBv2Oy0+VRHtMMWGAbca6Ak9KYCmKMbLWZ4LRmrSFw8yu/YWK/fBFFZq5elBNcjih7/JwpI95RHR5SLSEdC4NdfVHfpLKIFnByYBLG3tjCs6v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786987352; c=relaxed/simple;
	bh=fhESJZkT3dt+FWfSd+5ODq+pnQHRM69JmKzx1lJIoGI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Nmr7sxyAdMztc9rVxFnOCEpRfrJQEnaboqof+SEZEZ79OwErWKcXXt93Nk6N9I/Yv5HKHlMUlYtc3CvIeoH4OrtWaO385sGS0alTowRer9o+SriUFQM9yL8Co+fuE4sDWPVT1VYY+lPvJ1SjS47esOSxUWvu/jFhfN2QlmXgops=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nEe1Rgng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nEe1Rgng"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B05C7C2BCB3;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987351;
	bh=fhESJZkT3dt+FWfSd+5ODq+pnQHRM69JmKzx1lJIoGI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nEe1RgngU7hWi6QzG3SRyBWsrwPY+60K2wmtzNihcpvUPASEmjmSLi3gi7hayFCCk
	 IUXJxlZBJpfMvCu0ix6nT0WmIHv8ywF+YEJJeLN9WoltOLIa/xMo2QEQyC7T0RvHMU
	 1t236Sl7V865qlcaHHGP8OUlqYhB4atHWZFKlht/4hjOTfZgupGJYBuRS9eFTN7E0f
	 jR+Pja7ixj40k1SB7C/L2IsWJHMbeo3G+JLMkCwCsU6eVi5a2roTVR6BgVmk3CTMWh
	 hDqmnl+RwffQwdmbzG9iqgz6JfOu1Z0N8UgSaJMrBiYE2Y66FT+e3y5rs3T5xcylVD
	 u2w5eaHQesd0g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870AAC5DF7A;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:21 -0600
Subject: [PATCH 7/9] locking/lockdep: Traverse adjacency lists directly in
 zap_class()
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-7-0c1d230aa3af@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=2976;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=hMKyeAzj/0W3e7KdVMK4R3bJ4a3wyr0GUNnn4brlNlA=;
 b=cVjWa7I7YRjvCbMAMfBdBJT9zR8GIbatJK/6HvfTX7JD0l04eiM+7EquE8bXjJ92ce34JZutn
 a7J6heYfMsLD2cIK/pUbgoI3R654HF7l7BScqyxe7goKAXWygZzkVHY
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com

From: Jim Cromie <jim.cromie@gmail.com>

By definition, every dependency involving a lock class resides in either
its locks_after (forward) or locks_before (backward) list.

During module unload (rmmod) cleanup, zap_class() historically took a
shortcut: it scanned the global list_entries_in_use allocator bitmap,
testing every allocated dependency across the entire kernel against a
fixed static array.

That shortcut worked only because all dependencies were confined to a
single compile-time array. It conflates graph topology with allocator
storage layout, and breaks down the moment lockdep needs to scale beyond
static allocations.

Rework zap_class() to traverse class->locks_after and class->locks_before
directly, unlinking each edge and its matching counterpart on the
connected lock class via RCU while clearing the respective allocation
slot bits.

This restores the canonical graph deletion flow, touches only the edges
connected to the zapped class, and allows lockdep to safely support
dynamic allocators.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/locking/lockdep.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index f0f58db090ff..c8975c9282bb 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -6276,8 +6276,7 @@ static void remove_class_from_lock_chains(struct pending_free *pf,
  */
 static void zap_class(struct pending_free *pf, struct lock_class *class)
 {
-	struct lock_list *entry;
-	int i;
+	struct lock_list *entry, *tmp, *other, *other_tmp;
 
 	WARN_ON_ONCE(!class->key);
 
@@ -6285,11 +6284,29 @@ static void zap_class(struct pending_free *pf, struct lock_class *class)
 	 * Remove all dependencies this lock is
 	 * involved in:
 	 */
-	for_each_set_bit(i, list_entries_in_use, ARRAY_SIZE(list_entries)) {
-		entry = list_entries + i;
-		if (entry->class != class && entry->links_to != class)
-			continue;
-		__clear_bit(i, list_entries_in_use);
+	list_for_each_entry_safe(entry, tmp, &class->locks_after, entry) {
+		list_for_each_entry_safe(other, other_tmp, &entry->links_to->locks_before, entry) {
+			if (other->links_to == class) {
+				__clear_bit(other - list_entries, list_entries_in_use);
+				nr_list_entries--;
+				list_del_rcu(&other->entry);
+				break;
+			}
+		}
+		__clear_bit(entry - list_entries, list_entries_in_use);
+		nr_list_entries--;
+		list_del_rcu(&entry->entry);
+	}
+	list_for_each_entry_safe(entry, tmp, &class->locks_before, entry) {
+		list_for_each_entry_safe(other, other_tmp, &entry->links_to->locks_after, entry) {
+			if (other->links_to == class) {
+				__clear_bit(other - list_entries, list_entries_in_use);
+				nr_list_entries--;
+				list_del_rcu(&other->entry);
+				break;
+			}
+		}
+		__clear_bit(entry - list_entries, list_entries_in_use);
 		nr_list_entries--;
 		list_del_rcu(&entry->entry);
 	}

-- 
2.55.0


