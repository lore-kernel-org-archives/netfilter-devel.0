Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B45B38DC6A
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 18:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436759; cv=none; b=eWX+NxRifZUi9DtB3GJ7vNfyadnmsrcwr4mi7dEJGkp1EeiJytE0o/w4vGqXv55iZNUA0a6bqT+ddocD8MMGzoGMkRe4tdfDjS2oqnAdhaf6GjGH6dmuhwWS4sP6ZxwPKy3hjR9gFvyjpTEFKpAX+iV9Pljmfm6/V/6t9+Ju6IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436759; c=relaxed/simple;
	bh=CIfmLOMbeUOBZDYRqdAi00KCCt84N/e+ySQF/wCtvwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqSlXeR4Fm0ZYNTWm8bg30oFglqS7cT/8AD52XxVWNI4yduVLWL+l5GTnIKhrrVVwRb8XklOjyEQFD4GjQZ0qW51ZMnxbrll75uisnAWt5AUKGYkgTulrqmuq2oLl6PoHNpg8XXQguk3fVBN7kbKL6mm6npGfW8dAMtWV7q5AQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7D4A1604DA; Thu, 30 Jul 2026 20:39:07 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/5] netfilter: ipset: switch ext_size to atomic64_t
Date: Thu, 30 Jul 2026 20:38:50 +0200
Message-ID: <20260730183853.21868-3-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260730183853.21868-1-fw@strlen.de>
References: <20260730183853.21868-1-fw@strlen.de>
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
2.54.0

