Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C61242A7AD
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jul 2026 13:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783000562; cv=none; b=RPYfuZqHRUt1WHB4HX4QIPBs0NAWPuLrrZSA2yKSmF5iRoBQs65WrmupdO1U3RCHUPVQas/TmNv1XhbQmypAIwxhezl82qaLDbSBYNTW9jvhnlEu47hfhOkRcWMY9ThAwK4eLcR5hI4NIQ2hEwGyH66hJwAwqrWsUMHiuGUHdCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783000562; c=relaxed/simple;
	bh=sWtJM0mlbaPo8wfrrFwmbh+HOz9mzyVaBte2lW4voBU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g2w2+3pN/faI5ctVV/bhtEiJ4z5KD4ZEDKjsuBivle98GJRUMC7OxeSiew/uB2S3trzADNnWjjWLvJgHoJYGaV3Fnaa5O9vK/b367SvSDpPAwpU+UOtbFUkGkQ+L6zwX9BvvYV1bJ2syb0SsvfOa+2yEzrL8HsXTe+RibOHxEY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=PzGmFIqE; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="PzGmFIqE"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4grdTz5B0MzGFDCR;
	Thu, 02 Jul 2026 15:47:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1783000021; x=1784814422; bh=fSu5Q4MUo/
	SnmPW7rboD5r841aLRGunk3ZAtuuBjl2s=; b=PzGmFIqEIHi/gmx6bzBRVXSxp7
	4xcIS6gumKRdiu3IQT7r1JlPgNZzluN7pIJSaJiGvHpuC8HU5feZWsm+T0okLtDF
	FVTWJ8F2Pq7z0lqNLj+5ELbe/D/cUFt+v0kdM6Co9YPbspGYSMXz9jIO8hMG0Mml
	pJ1PYcAvZP4IOCZ5U=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id cUqpx2RQJxLW; Thu,  2 Jul 2026 15:47:01 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4grdTx5MS2zGFDCQ;
	Thu, 02 Jul 2026 15:47:01 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 84FE7140792; Thu,  2 Jul 2026 15:47:01 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/5] netfilter: ipset: exlude gc when resize is in progress
Date: Thu,  2 Jul 2026 15:46:58 +0200
Message-Id: <20260702134701.207721-3-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260702134701.207721-1-kadlec@netfilter.org>
References: <20260702134701.207721-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Zhengchuan Liang and Eulgyu Kim reported that because resize
does not copy the comment extension into the resized set but
uses it's pointer, ongoing gc can free the extension in the
original set which then results stale pointer in the resized
one. The proposed patch was to recreate the extensions for
every element in the resized set. It is both expensive and
wastes memory, so better exclude gc when resizing in progress
detected: resizing will destroy the original set anyway,
so doing gc on it is unnecessary.

Introduce a new spinlock to exclude parallel gc and resize.
Because we just set and check a bool value, there's no need
for the parameter to be atomic_t and rename it for better
readability.

Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reported by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 31 +++++++++++++++++----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index c9a071766243..8104dbac02fa 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -75,12 +75,13 @@ struct hbucket {
 struct htable_gc {
 	struct delayed_work dwork;
 	struct ip_set *set;	/* Set the gc belongs to */
+	spinlock_t lock;	/* Lock to exclude gc and resize */
 	u32 region;		/* Last gc run position */
 };
=20
 /* The hash table: the table size stored here in order to make resizing =
easy */
 struct htable {
-	atomic_t ref;		/* References for resizing */
+	bool resizing;		/* Mark ongoing resize */
 	atomic_t uref;		/* References for dumping and gc */
 	u8 htable_bits;		/* size of hash table =3D=3D 2^htable_bits */
 	u32 maxelem;		/* Maxelem per region */
@@ -582,9 +583,12 @@ mtype_gc(struct work_struct *work)
 	if (next_run < HZ/10)
 		next_run =3D HZ/10;
=20
-	mtype_gc_do(set, h, t, r);
+	spin_lock_bh(&gc->lock);
+	if (!t->resizing)
+		mtype_gc_do(set, h, t, r);
+	spin_unlock_bh(&gc->lock);
=20
-	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+	if (atomic_dec_and_test(&t->uref) && t->resizing) {
 		pr_debug("Table destroy after resize by expire: %p\n", t);
 		mtype_ahash_destroy(set, t, false);
 	}
@@ -672,11 +676,13 @@ mtype_resize(struct ip_set *set, bool retried)
 		spin_lock_init(&t->hregion[i].lock);
=20
 	/* There can't be another parallel resizing,
-	 * but dumping, gc, kernel side add/del are possible
+	 * but dumping and kernel side add/del are possible
 	 */
 	orig =3D ipset_dereference_bh_nfnl(h->table);
-	atomic_set(&orig->ref, 1);
 	atomic_inc(&orig->uref);
+	spin_lock_bh(&h->gc.lock);
+	orig->resizing =3D true;
+	spin_unlock_bh(&h->gc.lock);
 	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
 		 set->name, orig->htable_bits, htable_bits, orig);
 	for (r =3D 0; r < ahash_numof_locks(orig->htable_bits); r++) {
@@ -792,7 +798,9 @@ mtype_resize(struct ip_set *set, bool retried)
=20
 cleanup:
 	rcu_read_unlock_bh();
-	atomic_set(&orig->ref, 0);
+	spin_lock_bh(&h->gc.lock);
+	orig->resizing =3D false;
+	spin_unlock_bh(&h->gc.lock);
 	atomic_dec(&orig->uref);
 	mtype_ahash_destroy(set, t, false);
 	if (ret =3D=3D -EAGAIN)
@@ -1000,7 +1008,7 @@ mtype_add(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 	ret =3D 0;
 resize:
 	spin_unlock_bh(&t->hregion[r].lock);
-	if (atomic_read(&t->ref) && ext->target) {
+	if (t->resizing && ext && ext->target) {
 		/* Resize is in process and kernel side add, save values */
 		struct mtype_resize_ad *x;
=20
@@ -1027,7 +1035,7 @@ mtype_add(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 unlock:
 	spin_unlock_bh(&t->hregion[r].lock);
 out:
-	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+	if (atomic_dec_and_test(&t->uref) && t->resizing) {
 		pr_debug("Table destroy after resize by add: %p\n", t);
 		mtype_ahash_destroy(set, t, false);
 	}
@@ -1090,7 +1098,7 @@ mtype_del(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 #endif
 		ip_set_ext_destroy(set, data);
=20
-		if (atomic_read(&t->ref) && ext->target) {
+		if (t->resizing && ext && ext->target) {
 			/* Resize is in process and kernel side del,
 			 * save values
 			 */
@@ -1141,7 +1149,7 @@ mtype_del(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 		list_add(&x->list, &h->ad);
 		spin_unlock_bh(&set->lock);
 	}
-	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+	if (atomic_dec_and_test(&t->uref) && t->resizing) {
 		pr_debug("Table destroy after resize by del: %p\n", t);
 		mtype_ahash_destroy(set, t, false);
 	}
@@ -1350,7 +1358,7 @@ mtype_uref(struct ip_set *set, struct netlink_callb=
ack *cb, bool start)
 		rcu_read_unlock_bh();
 	} else if (cb->args[IPSET_CB_PRIVATE]) {
 		t =3D (struct htable *)cb->args[IPSET_CB_PRIVATE];
-		if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+		if (atomic_dec_and_test(&t->uref) && t->resizing) {
 			pr_debug("Table destroy after resize "
 				 " by dump: %p\n", t);
 			mtype_ahash_destroy(set, t, false);
@@ -1590,6 +1598,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct=
 ip_set *set,
 		return -ENOMEM;
 	}
 	h->gc.set =3D set;
+	spin_lock_init(&h->gc.lock);
 	for (i =3D 0; i < ahash_numof_locks(hbits); i++)
 		spin_lock_init(&t->hregion[i].lock);
 	h->maxelem =3D maxelem;
--=20
2.39.5

