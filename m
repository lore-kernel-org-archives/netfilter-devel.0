Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AA03E00AB;
	Sat, 16 May 2026 11:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932607; cv=none; b=cDP6Ud5fzztWdJEWfmPjhNRsb5HNe9J5UrLZJioH4m7I67tIp8Wfnv9trIkFEPuMc1zqG6UD1tKtEXaks+Eyuzx7+kFK9tM5pE9qf/7cDlklVpLkgBi6HkssvaYf1vYnBYNnnZgYt98z9QGS7ebSf7GWsJnXULrxOhO1rM/P46U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932607; c=relaxed/simple;
	bh=xo5dtxEiMruUNHx0OJv7GlBb+Qyuf+qGyS9ab2nu5Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEYG4wzlMiruNTwON+MzZJABPLwCoE9iVAyXR4xJALRtCf3q2PIYrM/1Ue5W7aZ68qrxV2lAgpy5zmjrUkkv36IcPcwzqEo3I83HrI0iITSYnKMVTTHVonzERDPa5deN4sM9rxtg5KsS3QN545ONPJmt4qnlFkf0YkNTrSsbf1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HbMqo9Ok; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HbMqo9Ok"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A9C31601B0;
	Sat, 16 May 2026 13:56:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778932604;
	bh=3/AbUOC5PGOEa7Oa0rvwZR9BE163ms0c/VClPrG65UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbMqo9Ok/Htr0pY37xWRIXUaVkpylijdOsTZ7kYlznXNk2CaazT0iN9jYiGQBhuUW
	 lmR7jRzggDRwV0WIR644hyKXhbJQlq7pTLSZcG/rjon8cHA1QuWVAMtEfM8pMzulPl
	 pIW1dXmKtobb4gFV545b7onubP86RgOiAi8N8gJYJs6KMkqvLpjH969xRWmrBMkInP
	 ZZ5w0nq40h6zI+uzhJJdPzmkbGmmH8lG9j14uKS+Q6m3vCJfSA1gXuPVFmlDmtzwoT
	 CXXYDeoJ/6ZJwm9KTP1HpNul6kpSX06Wy3EQ8g03QEFEaIkNiQTj39YXzldkEC/PFG
	 CiFiC4oH8tF7Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 10/12] netfilter: ipset: annotate "pos" for concurrent readers/writers
Date: Sat, 16 May 2026 13:56:25 +0200
Message-ID: <20260516115627.967773-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516115627.967773-1-pablo@netfilter.org>
References: <20260516115627.967773-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

The "pos" structure member of struct hbucket stores the first
free slot in the hash bucket of a hash type of set and there
are concurrent readers/writers. Annotate accesses properly.

Fixes: 18f84d41d34f ("netfilter: ipset: Introduce RCU locking in hash:* types")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 62 ++++++++++++++++-----------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 133ce4611eed..04e4627ddfc1 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -386,8 +386,9 @@ static void
 mtype_ext_cleanup(struct ip_set *set, struct hbucket *n)
 {
 	int i;
+	u8 pos = smp_load_acquire(&n->pos);
 
-	for (i = 0; i < n->pos; i++)
+	for (i = 0; i < pos; i++)
 		if (test_bit(i, n->used))
 			ip_set_ext_destroy(set, ahash_data(n, i, set->dsize));
 }
@@ -490,7 +491,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 k;
 #endif
-	u8 htable_bits = t->htable_bits;
+	u8 pos, htable_bits = t->htable_bits;
 
 	spin_lock_bh(&t->hregion[r].lock);
 	for (i = ahash_bucket_start(r, htable_bits);
@@ -498,7 +499,8 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 		n = __ipset_dereference(hbucket(t, i));
 		if (!n)
 			continue;
-		for (j = 0, d = 0; j < n->pos; j++) {
+		pos = smp_load_acquire(&n->pos);
+		for (j = 0, d = 0; j < pos; j++) {
 			if (!test_bit(j, n->used)) {
 				d++;
 				continue;
@@ -534,7 +536,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 				/* Still try to delete expired elements. */
 				continue;
 			tmp->size = n->size - AHASH_INIT_SIZE;
-			for (j = 0, d = 0; j < n->pos; j++) {
+			for (j = 0, d = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
@@ -623,7 +625,7 @@ mtype_resize(struct ip_set *set, bool retried)
 {
 	struct htype *h = set->data;
 	struct htable *t, *orig;
-	u8 htable_bits;
+	u8 pos, htable_bits;
 	size_t hsize, dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
@@ -685,7 +687,8 @@ mtype_resize(struct ip_set *set, bool retried)
 			n = __ipset_dereference(hbucket(orig, i));
 			if (!n)
 				continue;
-			for (j = 0; j < n->pos; j++) {
+			pos = smp_load_acquire(&n->pos);
+			for (j = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
@@ -809,9 +812,10 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 {
 	struct htype *h = set->data;
 	const struct htable *t;
-	u32 i, j, r;
 	struct hbucket *n;
 	struct mtype_elem *data;
+	u32 i, j, r;
+	u8 pos;
 
 	t = rcu_dereference_bh(h->table);
 	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
@@ -820,7 +824,8 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 			n = rcu_dereference_bh(hbucket(t, i));
 			if (!n)
 				continue;
-			for (j = 0; j < n->pos; j++) {
+			pos = smp_load_acquire(&n->pos);
+			for (j = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, set->dsize);
@@ -844,10 +849,11 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	const struct mtype_elem *d = value;
 	struct mtype_elem *data;
 	struct hbucket *n, *old = ERR_PTR(-ENOENT);
-	int i, j = -1, npos = 0, ret;
+	int i, j = -1, ret;
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
 	bool deleted = false, forceadd = false, reuse = false;
 	u32 r, key, multi = 0, elements, maxelem;
+	u8 npos = 0;
 
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
@@ -889,8 +895,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			ext_size(AHASH_INIT_SIZE, set->dsize);
 		goto copy_elem;
 	}
-	npos = n->pos;
-	for (i = 0; i < n->pos; i++) {
+	npos = smp_load_acquire(&n->pos);
+	for (i = 0; i < npos; i++) {
 		if (!test_bit(i, n->used)) {
 			/* Reuse first deleted entry */
 			if (j == -1) {
@@ -934,7 +940,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (elements >= maxelem)
 		goto set_full;
 	/* Create a new slot */
-	if (n->pos >= n->size) {
+	if (npos >= n->size) {
 #ifdef IP_SET_HASH_WITH_MULTI
 		if (h->bucketsize >= AHASH_MAX_TUNED)
 			goto set_full;
@@ -963,8 +969,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 
 copy_elem:
-	j = npos;
-	npos = n->pos + 1;
+	j = npos++;
 	data = ahash_data(n, j, set->dsize);
 copy_data:
 	t->hregion[r].elements++;
@@ -987,7 +992,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (SET_WITH_TIMEOUT(set))
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
 	smp_mb__before_atomic();
-	n->pos = npos;
+	/* Ensure all data writes are visible before updating position */
+	smp_store_release(&n->pos, npos);
 	set_bit(j, n->used);
 	if (old != ERR_PTR(-ENOENT)) {
 		rcu_assign_pointer(hbucket(t, key), n);
@@ -1046,6 +1052,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int i, j, k, r, ret = -IPSET_ERR_EXIST;
 	u32 key, multi = 0;
 	size_t dsize = set->dsize;
+	u8 pos;
 
 	/* Userspace add and resize is excluded by the mutex.
 	 * Kernespace add does not trigger resize.
@@ -1061,7 +1068,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	n = rcu_dereference_bh(hbucket(t, key));
 	if (!n)
 		goto out;
-	for (i = 0, k = 0; i < n->pos; i++) {
+	pos = smp_load_acquire(&n->pos);
+	for (i = 0, k = 0; i < pos; i++) {
 		if (!test_bit(i, n->used)) {
 			k++;
 			continue;
@@ -1075,8 +1083,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		ret = 0;
 		clear_bit(i, n->used);
 		smp_mb__after_atomic();
-		if (i + 1 == n->pos)
-			n->pos--;
+		if (i + 1 == pos)
+			smp_store_release(&n->pos, --pos);
 		t->hregion[r].elements--;
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j = 0; j < IPSET_NET_COUNT; j++)
@@ -1097,11 +1105,11 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 				x->flags = flags;
 			}
 		}
-		for (; i < n->pos; i++) {
+		for (; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				k++;
 		}
-		if (k == n->pos) {
+		if (k == pos) {
 			t->hregion[r].ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
@@ -1112,7 +1120,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			if (!tmp)
 				goto out;
 			tmp->size = n->size - AHASH_INIT_SIZE;
-			for (j = 0, k = 0; j < n->pos; j++) {
+			for (j = 0, k = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
@@ -1173,6 +1181,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 	int ret, i, j = 0;
 #endif
 	u32 key, multi = 0;
+	u8 pos;
 
 	pr_debug("test by nets\n");
 	for (; j < NLEN && h->nets[j].cidr[0] && !multi; j++) {
@@ -1190,7 +1199,8 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 		n = rcu_dereference_bh(hbucket(t, key));
 		if (!n)
 			continue;
-		for (i = 0; i < n->pos; i++) {
+		pos = smp_load_acquire(&n->pos);
+		for (i = 0; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				continue;
 			data = ahash_data(n, i, set->dsize);
@@ -1224,6 +1234,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct mtype_elem *data;
 	int i, ret = 0;
 	u32 key, multi = 0;
+	u8 pos;
 
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
@@ -1246,7 +1257,8 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		ret = 0;
 		goto out;
 	}
-	for (i = 0; i < n->pos; i++) {
+	pos = smp_load_acquire(&n->pos);
+	for (i = 0; i < pos; i++) {
 		if (!test_bit(i, n->used))
 			continue;
 		data = ahash_data(n, i, set->dsize);
@@ -1363,6 +1375,7 @@ mtype_list(const struct ip_set *set,
 	/* We assume that one hash bucket fills into one page */
 	void *incomplete;
 	int i, ret = 0;
+	u8 pos;
 
 	atd = nla_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
@@ -1381,7 +1394,8 @@ mtype_list(const struct ip_set *set,
 			 cb->args[IPSET_CB_ARG0], t, n);
 		if (!n)
 			continue;
-		for (i = 0; i < n->pos; i++) {
+		pos = smp_load_acquire(&n->pos);
+		for (i = 0; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				continue;
 			e = ahash_data(n, i, set->dsize);
-- 
2.47.3

