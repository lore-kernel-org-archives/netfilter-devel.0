Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0EB15B998
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 07:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777275857; cv=none; b=Y7DiLoHsGl2F//ev2Mazv+p2QTo2KSqBHN0s42L5B1HpFdD+0HHyocawoLybSLtEEqzIp4JyJq1op6oAAkpPMjnymQREuojvINOXaJPpm3k05XIMm38LFz/bmj8cyjOEOGnk6iC/jvcOvTxs17kU4vbwXn5K5rZ84EAU5qYSZ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777275857; c=relaxed/simple;
	bh=UIeDwwjRQqdxwU/M1vXovEuQO3+DFEXgskZq+ldED2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K0RUNHmG3iCb1ynQq0iYJvnOf6T6HpBLPz+ehemwO7vH9d5bJ3sCbRRMiczoMf9IxwQH1ZXrF/NzHfjPeg05KxCllL3JqWg4IrW1BYz4XWZK8+KKmMcnApvJjSbnvLTppQUGmqlU4sUDjCfyO3JZ8AsPvdY+zJj3T0pM2muguW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=G8ohjPjB; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="G8ohjPjB"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4g3wLW04HMzGFDMK;
	Mon, 27 Apr 2026 09:34:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1777275265; x=1779089666; bh=NI5P9Dh6l+
	d5Rod63Y7iubUz4TbsXNtJwokNDcS54cc=; b=G8ohjPjBv3OlOieGX6Zfq7Iibs
	G67cGZxMtZF+OsVtvzy0k+vutvdNOmHj99aEsNClOwp0DuRXAsqYCoGFsLyUH/pc
	HqEepLsnYX/03+iYwD39NhXMXAp48piixmjAmL9Fm9C4stRi1JwT0/AzrXk6dLXG
	RXyOV8EZXgV1mW1RQ=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id gatE6KFxNKfW; Mon, 27 Apr 2026 09:34:25 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C0B05.nat.pool.telekom.hu [37.76.11.5])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4g3wLT032YzGFDMG;
	Mon, 27 Apr 2026 09:34:24 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 899C71413C5; Mon, 27 Apr 2026 09:34:24 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/5] netfilter: ipset: annotate "pos" for concurrent readers/writers
Date: Mon, 27 Apr 2026 09:34:22 +0200
Message-Id: <20260427073424.573672-4-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260427073424.573672-1-kadlec@netfilter.org>
References: <20260427073424.573672-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: maybeham 5%
Content-Transfer-Encoding: quoted-printable

The "pos" structure member of struct hbucket stores the first
free slot in the hash bucket of a hash type of set and there
are concurrent readers/writers. Annotate accesses properly.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 64 ++++++++++++++++-----------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index f96085b19682..130cab2e2397 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -386,8 +386,9 @@ static void
 mtype_ext_cleanup(struct ip_set *set, struct hbucket *n)
 {
 	int i;
+	u8 pos =3D smp_load_acquire(&n->pos);
=20
-	for (i =3D 0; i < n->pos; i++)
+	for (i =3D 0; i < pos; i++)
 		if (test_bit(i, n->used))
 			ip_set_ext_destroy(set, ahash_data(n, i, set->dsize));
 }
@@ -490,7 +491,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, stru=
ct htable *t, u32 r)
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 k;
 #endif
-	u8 htable_bits =3D t->htable_bits;
+	u8 pos, htable_bits =3D t->htable_bits;
=20
 	spin_lock_bh(&t->hregion[r].lock);
 	for (i =3D ahash_bucket_start(r, htable_bits);
@@ -498,7 +499,8 @@ mtype_gc_do(struct ip_set *set, struct htype *h, stru=
ct htable *t, u32 r)
 		n =3D __ipset_dereference(hbucket(t, i));
 		if (!n)
 			continue;
-		for (j =3D 0, d =3D 0; j < n->pos; j++) {
+		pos =3D smp_load_acquire(&n->pos);
+		for (j =3D 0, d =3D 0; j < pos; j++) {
 			if (!test_bit(j, n->used)) {
 				d++;
 				continue;
@@ -534,7 +536,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, stru=
ct htable *t, u32 r)
 				/* Still try to delete expired elements. */
 				continue;
 			tmp->size =3D n->size - AHASH_INIT_SIZE;
-			for (j =3D 0, d =3D 0; j < n->pos; j++) {
+			for (j =3D 0, d =3D 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data =3D ahash_data(n, j, dsize);
@@ -623,7 +625,7 @@ mtype_resize(struct ip_set *set, bool retried)
 {
 	struct htype *h =3D set->data;
 	struct htable *t, *orig;
-	u8 htable_bits;
+	u8 pos, htable_bits;
 	size_t hsize, dsize =3D set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
@@ -685,7 +687,8 @@ mtype_resize(struct ip_set *set, bool retried)
 			n =3D __ipset_dereference(hbucket(orig, i));
 			if (!n)
 				continue;
-			for (j =3D 0; j < n->pos; j++) {
+			pos =3D smp_load_acquire(&n->pos);
+			for (j =3D 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data =3D ahash_data(n, j, dsize);
@@ -809,9 +812,10 @@ mtype_ext_size(struct ip_set *set, u32 *elements, si=
ze_t *ext_size)
 {
 	struct htype *h =3D set->data;
 	const struct htable *t;
-	u32 i, j, r;
 	struct hbucket *n;
 	struct mtype_elem *data;
+	u32 i, j, r;
+	u8 pos;
=20
 	t =3D rcu_dereference_bh(h->table);
 	for (r =3D 0; r < ahash_numof_locks(t->htable_bits); r++) {
@@ -820,7 +824,8 @@ mtype_ext_size(struct ip_set *set, u32 *elements, siz=
e_t *ext_size)
 			n =3D rcu_dereference_bh(hbucket(t, i));
 			if (!n)
 				continue;
-			for (j =3D 0; j < n->pos; j++) {
+			pos =3D smp_load_acquire(&n->pos);
+			for (j =3D 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data =3D ahash_data(n, j, set->dsize);
@@ -844,10 +849,11 @@ mtype_add(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 	const struct mtype_elem *d =3D value;
 	struct mtype_elem *data;
 	struct hbucket *n, *old =3D ERR_PTR(-ENOENT);
-	int i, j =3D -1, npos =3D 0, ret;
+	int i, j =3D -1, ret;
 	bool flag_exist =3D flags & IPSET_FLAG_EXIST;
 	bool deleted =3D false, forceadd =3D false, reuse =3D false;
 	u32 r, key, multi =3D 0, elements, maxelem;
+	u8 npos =3D 0;
=20
 	rcu_read_lock_bh();
 	t =3D rcu_dereference_bh(h->table);
@@ -889,8 +895,8 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 			ext_size(AHASH_INIT_SIZE, set->dsize);
 		goto copy_elem;
 	}
-	npos =3D n->pos;
-	for (i =3D 0; i < n->pos; i++) {
+	npos =3D smp_load_acquire(&n->pos);;
+	for (i =3D 0; i < npos; i++) {
 		if (!test_bit(i, n->used)) {
 			/* Reuse first deleted entry */
 			if (j =3D=3D -1) {
@@ -934,7 +940,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	if (elements >=3D maxelem)
 		goto set_full;
 	/* Create a new slot */
-	if (n->pos >=3D n->size) {
+	if (npos >=3D n->size) {
 #ifdef IP_SET_HASH_WITH_MULTI
 		if (h->bucketsize >=3D AHASH_MAX_TUNED)
 			goto set_full;
@@ -963,8 +969,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	}
=20
 copy_elem:
-	j =3D npos;
-	npos =3D n->pos + 1;
+	j =3D npos++;
 	data =3D ahash_data(n, j, set->dsize);
 copy_data:
 	t->hregion[r].elements++;
@@ -986,8 +991,8 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	/* Must come last for the case when timed out entry is reused */
 	if (SET_WITH_TIMEOUT(set))
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
-	smp_mb__before_atomic();
-	n->pos =3D npos;
+	/* Ensure all data writes are visible before updating position */
+	smp_store_release(&n->pos, npos);
 	set_bit(j, n->used);
 	if (old !=3D ERR_PTR(-ENOENT)) {
 		rcu_assign_pointer(hbucket(t, key), n);
@@ -1046,6 +1051,7 @@ mtype_del(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 	int i, j, k, r, ret =3D -IPSET_ERR_EXIST;
 	u32 key, multi =3D 0;
 	size_t dsize =3D set->dsize;
+	u8 pos;
=20
 	/* Userspace add and resize is excluded by the mutex.
 	 * Kernespace add does not trigger resize.
@@ -1061,7 +1067,8 @@ mtype_del(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 	n =3D rcu_dereference_bh(hbucket(t, key));
 	if (!n)
 		goto out;
-	for (i =3D 0, k =3D 0; i < n->pos; i++) {
+	pos =3D smp_load_acquire(&n->pos);
+	for (i =3D 0, k =3D 0; i < pos; i++) {
 		if (!test_bit(i, n->used)) {
 			k++;
 			continue;
@@ -1074,9 +1081,8 @@ mtype_del(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
=20
 		ret =3D 0;
 		clear_bit(i, n->used);
-		smp_mb__after_atomic();
-		if (i + 1 =3D=3D n->pos)
-			n->pos--;
+		if (i + 1 =3D=3D pos)
+			smp_store_release(&n->pos, --pos)
 		t->hregion[r].elements--;
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j =3D 0; j < IPSET_NET_COUNT; j++)
@@ -1097,11 +1103,11 @@ mtype_del(struct ip_set *set, void *value, const =
struct ip_set_ext *ext,
 				x->flags =3D flags;
 			}
 		}
-		for (; i < n->pos; i++) {
+		for (; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				k++;
 		}
-		if (n->pos =3D=3D 0 && k =3D=3D 0) {
+		if (pos =3D=3D 0 && k =3D=3D 0) {
 			t->hregion[r].ext_size -=3D ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
@@ -1112,7 +1118,7 @@ mtype_del(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 			if (!tmp)
 				goto out;
 			tmp->size =3D n->size - AHASH_INIT_SIZE;
-			for (j =3D 0, k =3D 0; j < n->pos; j++) {
+			for (j =3D 0, k =3D 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data =3D ahash_data(n, j, dsize);
@@ -1173,6 +1179,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_e=
lem *d,
 	int ret, i, j =3D 0;
 #endif
 	u32 key, multi =3D 0;
+	u8 pos;
=20
 	pr_debug("test by nets\n");
 	for (; j < NLEN && h->nets[j].cidr[0] && !multi; j++) {
@@ -1190,7 +1197,8 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_e=
lem *d,
 		n =3D rcu_dereference_bh(hbucket(t, key));
 		if (!n)
 			continue;
-		for (i =3D 0; i < n->pos; i++) {
+		pos =3D smp_load_acquire(&n->pos);
+		for (i =3D 0; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				continue;
 			data =3D ahash_data(n, i, set->dsize);
@@ -1224,6 +1232,7 @@ mtype_test(struct ip_set *set, void *value, const s=
truct ip_set_ext *ext,
 	struct mtype_elem *data;
 	int i, ret =3D 0;
 	u32 key, multi =3D 0;
+	u8 pos;
=20
 	rcu_read_lock_bh();
 	t =3D rcu_dereference_bh(h->table);
@@ -1246,7 +1255,8 @@ mtype_test(struct ip_set *set, void *value, const s=
truct ip_set_ext *ext,
 		ret =3D 0;
 		goto out;
 	}
-	for (i =3D 0; i < n->pos; i++) {
+	pos =3D smp_load_acquire(&n->pos);
+	for (i =3D 0; i < pos; i++) {
 		if (!test_bit(i, n->used))
 			continue;
 		data =3D ahash_data(n, i, set->dsize);
@@ -1363,6 +1373,7 @@ mtype_list(const struct ip_set *set,
 	/* We assume that one hash bucket fills into one page */
 	void *incomplete;
 	int i, ret =3D 0;
+	u8 pos;
=20
 	atd =3D nla_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
@@ -1381,7 +1392,8 @@ mtype_list(const struct ip_set *set,
 			 cb->args[IPSET_CB_ARG0], t, n);
 		if (!n)
 			continue;
-		for (i =3D 0; i < n->pos; i++) {
+		pos =3D smp_load_acquire(&n->pos);
+		for (i =3D 0; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				continue;
 			e =3D ahash_data(n, i, set->dsize);
--=20
2.39.5

