Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CEB37CD29;
	Fri,  4 Sep 2026 18:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548022; cv=none; b=BepW/RS+KbbPNWJCvHwKvfvLfsd6zxH5aLOcZtj8Qw16ZiYn7fqG/i0pj2JbG4syjEQj5agyLBk5GvGT7kLvjgKPsd6kGfMgRKl94rFQR9SAK/g+CRv/jPRUY2HqtkPgGHIWqHsbGWMxKG8/dFiYDubxzKfp9AvvJlPzxryy0HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548022; c=relaxed/simple;
	bh=P7P537Dc8V/nS3XfHG9UWLma5/GgBOb4VKbgf/u9KCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRakUx8OWmmhFqFqRlU0X9kWaC0mx9IUNsOlAaEDEnCjPLCUkvd3XUBthA6utvaqyC39M6dqo2QGo5Dd9O5XoaLIIaPnh49dXHsKXVAAd11xpLZYbVEGuS9h/RYo/JSqADkNIweeRy9nq8kOv/kQR3GwHN7JdjvtsMhIIANnavo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 171316035B; Fri, 04 Sep 2026 20:53:38 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Subject: [PATCH nf-next v4 01/13] rhashtable: add rhashtable_flush_and_free helper
Date: Fri,  4 Sep 2026 20:53:09 +0200
Message-ID: <20260904185321.30313-2-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185321.30313-1-fw@strlen.de>
References: <20260904185321.30313-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Will be used by upcoming ipset rhashtable conversion.

"walk rht with unlink+free" triggers LLM reject pattern:
"possible softirq CPU stall".

"walk rht with unlink+free + cond_resched" triggers
"possibly skipped elements".

Add a helper to detach current hash backend storage from the
rhashtable, then iterate and flush all contained elements.

Cc: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260828152256.8759-1-fw%40strlen.de
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Herbert: If you prefer to take this via the crypto tree, please
 let me know.
 Otherwise, an explicit Ack would be appreciated, so this can
 be handled via nf-next.  Thanks.

 net/ipv6/ila/ could be converted to use this helper too.

 include/linux/rhashtable.h |  19 ++++++
 lib/rhashtable.c           | 127 +++++++++++++++++++++++++++++++++++++
 2 files changed, 146 insertions(+)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 57a2a29bef0e..213e1cb77d45 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -255,6 +255,10 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
 				 void *arg);
 void rhashtable_destroy(struct rhashtable *ht);
 
+void rhashtable_flush_and_free(struct rhashtable *ht,
+			       void (*free_fn)(void *ptr, void *arg),
+			       void *arg);
+
 struct rhash_lock_head __rcu **rht_bucket_nested(
 	const struct bucket_table *tbl, unsigned int hash);
 struct rhash_lock_head __rcu **__rht_bucket_nested(
@@ -1335,4 +1339,19 @@ static inline void rhltable_destroy(struct rhltable *hlt)
 	rhltable_free_and_destroy(hlt, NULL, NULL);
 }
 
+/**
+ * rhltable_flush_and_free - unlink and free all elements in the hash list table
+ * @hlt:	the hash list table to destroy
+ * @free_fn:	callback to release resources of element
+ * @arg:	pointer passed to free_fn
+ *
+ * See documentation for rhashtable_flush_and_free.
+ */
+static inline void rhltable_flush_and_free(struct rhltable *hlt,
+					   void (*free_fn)(void *ptr,
+							   void *arg),
+					   void *arg)
+{
+	rhashtable_flush_and_free(&hlt->ht, free_fn, arg);
+}
 #endif /* _LINUX_RHASHTABLE_H */
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6362896e4f09..656c5021d8b2 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -1339,6 +1339,133 @@ void rhashtable_destroy(struct rhashtable *ht)
 }
 EXPORT_SYMBOL_GPL(rhashtable_destroy);
 
+struct rht_flush_arg {
+	struct rhashtable *ht;
+	void (*free_fn)(void *ptr, void *arg);
+	void *arg;
+};
+
+static void flush_cb(void *ptr, void *arg)
+{
+	struct rht_flush_arg *fa = arg;
+
+	atomic_dec(&fa->ht->nelems);
+	if (fa->free_fn)
+		fa->free_fn(ptr, fa->arg);
+}
+
+static void rhashtable_flush_one(struct rhashtable *ht, struct rhash_head *obj,
+				 void (*free_fn)(void *ptr, void *arg),
+				 void *arg)
+{
+	struct rht_flush_arg fa = {
+		.ht = ht,
+		.free_fn = free_fn,
+		.arg = arg,
+	};
+
+	rhashtable_free_one(ht, obj, flush_cb, &fa);
+}
+
+static void rhashtable_flush_chain(struct rhashtable *ht,
+				   struct bucket_table *tbl,
+				   unsigned int hash,
+				   void (*free_fn)(void *ptr, void *arg),
+				   void *arg)
+{
+	struct rhash_lock_head __rcu **bkt = rht_bucket_var(tbl, hash);
+	struct rhash_head *pos, *next;
+	unsigned long flags;
+
+	if (!bkt)
+		return;
+
+	flags = rht_lock(tbl, bkt);
+	pos = rht_ptr(bkt, tbl, hash);
+	rht_assign_unlock(tbl, bkt, NULL, flags);
+
+	/* Nothing can reach @pos through @tbl any more: the bucket has
+	 * been emptied above, and @tbl itself is unreachable from ht->tbl
+	 * (see rhashtable_flush_and_free()). Walk it the same way
+	 * rhashtable_free_and_destroy() walks a table it exclusively
+	 * owns.
+	 */
+	while (!rht_is_a_nulls(pos)) {
+		next = rcu_dereference_raw(pos->next);
+		rhashtable_flush_one(ht, pos, free_fn, arg);
+		pos = next;
+	}
+}
+
+/**
+ * rhashtable_flush_and_free - detach and discard all current elements
+ * @ht:		the hash table to flush
+ * @free_fn:	callback to release resources of an element, may be %NULL
+ * @arg:	pointer passed to free_fn
+ *
+ * Swaps the bucket table backing @ht for a new, empty table.
+ *
+ * The detached table is then walked and every element found is
+ * unlinked, and, if @free_fn is given, handed to it for release.
+ * Note that RCU protected readers may still be accessing the elements.
+ * Releasing of resources must occur in a compatible manner.
+ *
+ * Unlike rhashtable_destroy(), @ht is left fully initialized and may
+ * continue to be used for lookups, insertions, and removals.
+ *
+ * This function may sleep, it cannot be called from atomic context or
+ * RCU read-side critical sections.
+ */
+void rhashtable_flush_and_free(struct rhashtable *ht,
+			       void (*free_fn)(void *ptr, void *arg),
+			       void *arg)
+{
+	struct bucket_table *tbl, *old_tbl, *last_tbl, *new_tbl;
+	struct rhashtable_walker *walker;
+	unsigned int i;
+
+	new_tbl = bucket_table_alloc(ht, rounded_hashtable_size(&ht->p),
+				     GFP_KERNEL);
+	if (!new_tbl)
+		new_tbl = bucket_table_alloc(ht, ht->p.min_size,
+					     GFP_KERNEL | __GFP_NOFAIL);
+
+	mutex_lock(&ht->mutex);
+
+	/* Splice the new, empty table onto the tail of the live table ... */
+	old_tbl = rht_dereference(ht->tbl, ht);
+	do {
+		last_tbl = rhashtable_last_table(ht, old_tbl);
+	} while (rhashtable_rehash_attach(ht, last_tbl, new_tbl));
+
+	/* ...then publish it as ht->tbl. */
+	rcu_assign_pointer(ht->tbl, new_tbl);
+	mutex_unlock(&ht->mutex);
+
+	tbl = old_tbl;
+	do {
+		struct bucket_table *next_tbl = rcu_dereference_raw(tbl->future_tbl);
+
+		for (i = 0; i < tbl->size; i++) {
+			cond_resched();
+			rhashtable_flush_chain(ht, tbl, i, free_fn, arg);
+		}
+
+		spin_lock(&ht->lock);
+		list_for_each_entry(walker, &tbl->walkers, list)
+			walker->tbl = NULL;
+		/* See rhashtable_rehash_table(): done under ->lock so
+		 * rhashtable_walk_stop() can use rcu_head_after_call_rcu()
+		 * to decide whether to re-link the walker onto this table.
+		 */
+		call_rcu(&tbl->rcu, bucket_table_free_rcu);
+		spin_unlock(&ht->lock);
+
+		tbl = next_tbl;
+	} while (tbl && tbl != new_tbl);
+}
+EXPORT_SYMBOL_GPL(rhashtable_flush_and_free);
+
 struct rhash_lock_head __rcu **__rht_bucket_nested(
 	const struct bucket_table *tbl, unsigned int hash)
 {
-- 
2.55.0

