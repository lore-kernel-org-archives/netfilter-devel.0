Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF8034CFDA;
	Fri, 31 Jul 2026 15:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511102; cv=none; b=UUB24YWxOCWdsZqCd54gc1ckA8xHXXvBL6L9nTsuj88Oqv9snsgk90xq+16En7HYERNOKzXlc7fB03bnu2q7IpDvBQySxN0l8ryq4dKAffdbnVzr0RF0bm85gUzf78NtR9x6nhyHDLoug8OoCmHlkEBELla4UjH+qfuFWAC2bt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511102; c=relaxed/simple;
	bh=EhHWjv7sa+LoMs3LIvrUgNEaYwd5vpkMLJ/qnatoV98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9p2XDqkzkJKrfMklM6HCw79AoYwQjNRQrJOjpPtDkZTTH+c925U28JDr9/7GVoMy94jSDQPI7RzChtPTjiPxxqq+ZFTqBEdY++TAYg1RcNfr1w2W4/kC5vVuLDnu11A4ZC+X2hdhMH7YqG5vjY94c/x5UkAHisA/gOKgBZ0vTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PczV2xDL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PczV2xDL"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EAAB360289;
	Fri, 31 Jul 2026 17:18:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785511098;
	bh=ilanA1PhLq33uomWzK5GiUMFP5ypMHixV2XyuUX5RZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PczV2xDLTaTCjkxyF/2Yq7KtFHjVKJEfwrey90ROuM0HVSHtExAxMOkmVxWWYaMBQ
	 uk+UI+B69Ofhz4/PB3bXyHURjPSbJ3jmbG41jwJ4odiB4vrEhGsfCBR/r3lTDC6F6A
	 0KbG6LtlDeJThbFCpTLDKnV+45hw2NDmyvlXhwLPNJtUbvs0myl2G00slpzJzVLkJA
	 3ZyeY+uMJFfpk4bIhrq6Zy24NbzfIWtUzETH9qwgBcOXmYVDE55VdmWSJYd27ADu+q
	 ollbROEl+RKwEsNewzn79a6/Rjm/9WW4AKxkZVhJjpYawPb/Jdchp8dK/+WRYYp6Ib
	 hAkaJ8P6nIUxQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 04/10] netfilter: ipset: switch ext_size to atomic64_t
Date: Fri, 31 Jul 2026 17:18:00 +0200
Message-ID: <20260731151806.849724-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731151806.849724-1-pablo@netfilter.org>
References: <20260731151806.849724-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

The hash types do not acquire set->lock, they use 'region locking' where
only part of the hash table is locked. Parallel inserts and deletes are
possible and CPUs can race on ->ext_size update.  Switch to atomic64_t.

This leaves another bug unresolved: there still can be a race on
comment extension re-init.  This will be handled in a later commit
when converting to rhashtable backend.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h  | 2 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h | 4 ++--
 net/netfilter/ipset/ip_set_core.c       | 6 +++---
 net/netfilter/ipset/ip_set_hash_gen.h   | 2 +-
 net/netfilter/ipset/ip_set_list_set.c   | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index b98331572ad2..cadae9b2578f 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -273,7 +273,7 @@ struct ip_set {
 	/* Number of elements (vs timeout) */
 	u32 elements;
 	/* Size of the dynamic extensions (vs timeout) */
-	size_t ext_size;
+	atomic64_t ext_size;
 	/* Element data size */
 	size_t dsize;
 	/* Offsets to extensions in elements */
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index bb9b5bed10e1..226fdf17b683 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -77,7 +77,7 @@ mtype_flush(struct ip_set *set)
 		mtype_ext_cleanup(set);
 	bitmap_zero(map->members, map->elements);
 	set->elements = 0;
-	set->ext_size = 0;
+	atomic64_set(&set->ext_size, 0);
 }
 
 /* Calculate the actual memory size of the set data */
@@ -93,7 +93,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 {
 	const struct mtype *map = set->data;
 	struct nlattr *nested;
-	size_t memsize = mtype_memsize(map, set->dsize) + set->ext_size;
+	size_t memsize = mtype_memsize(map, set->dsize) + atomic64_read(&set->ext_size);
 
 	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 6cfad152d7d1..822a53a7f502 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -350,7 +350,7 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 	size_t len = ext->comment ? strlen(ext->comment) : 0;
 
 	if (unlikely(c)) {
-		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
+		atomic64_sub(sizeof(*c) + strlen(c->str) + 1, &set->ext_size);
 		rcu_assign_pointer(comment->c, NULL);
 		kfree_rcu(c, rcu);
 	}
@@ -362,7 +362,7 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 	if (unlikely(!c))
 		return;
 	strscpy(c->str, ext->comment, len + 1);
-	set->ext_size += sizeof(*c) + strlen(c->str) + 1;
+	atomic64_add(sizeof(*c) + strlen(c->str) + 1, &set->ext_size);
 	rcu_assign_pointer(comment->c, c);
 }
 EXPORT_SYMBOL_GPL(ip_set_init_comment);
@@ -392,7 +392,7 @@ ip_set_comment_free(struct ip_set *set, void *ptr)
 	c = rcu_dereference_protected(comment->c, 1);
 	if (unlikely(!c))
 		return;
-	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
+	atomic64_sub(sizeof(*c) + strlen(c->str) + 1, &set->ext_size);
 	rcu_assign_pointer(comment->c, NULL);
 	kfree_rcu(c, rcu);
 }
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index dd31992c915c..8841daf28f01 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1373,7 +1373,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	mtype_ext_size(set, &elements, &ext_size);
-	memsize = mtype_ahash_memsize(h, t) + ext_size + set->ext_size;
+	memsize = mtype_ahash_memsize(h, t) + ext_size + atomic64_read(&set->ext_size);
 	htable_bits = t->htable_bits;
 	rcu_read_unlock_bh();
 
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 1cef84f15e8c..ca3ef9479e83 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -421,7 +421,7 @@ list_set_flush(struct ip_set *set)
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
 	set->elements = 0;
-	set->ext_size = 0;
+	atomic64_set(&set->ext_size, 0);
 }
 
 static void
@@ -455,7 +455,7 @@ list_set_head(struct ip_set *set, struct sk_buff *skb)
 {
 	const struct list_set *map = set->data;
 	struct nlattr *nested;
-	size_t memsize = list_set_memsize(map, set->dsize) + set->ext_size;
+	size_t memsize = list_set_memsize(map, set->dsize) + atomic64_read(&set->ext_size);
 
 	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
-- 
2.47.3

