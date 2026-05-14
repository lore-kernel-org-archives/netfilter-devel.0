Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611803DF006
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 08:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778748938; cv=none; b=T2yzANqpWWDF0zCL3UI2AjEKCkWQHXXbUQEF8ByaLAnHgsA3nDbFVG5yAnyvKlRwYg7guzF1BfDfdLPu68X78OF9gwXSi1zTD5HVXcT9Cd6Q7hKyL1JFj32m023u8/ij4mLFiPbpHIoyeKAfAYUjzjnKDAn8JAEQIi64Oj+98GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778748938; c=relaxed/simple;
	bh=uXhEKHdDl4WnrovN6UHaH6hD2nSZAkmM8tGmr7OGc54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YQI7/KyPmivSaS52WrOL/fg2GF/pf4yXaDPuNhFCp9K6RXjvd7JVIzlXhAimZgO+oqNvIefzN5+sAGvlqrgvNXQvsvnrjX3/GWuYMtGkbqA5U3m81OL1HxPfJzVZnddvuwUutZuUMXzxGaF7encNUghoeq9XGn9RDmerBfzeICA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=I3jBCVw4; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="I3jBCVw4"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4gGPL50K6jzGFDNQ;
	Thu, 14 May 2026 10:55:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1778748923; x=1780563324; bh=nmhbrxjjU4
	xZ/4sTseBUEhY1BAx/xwL/ErzzK7qQJmI=; b=I3jBCVw424YNqk0JXESmNj6uJ9
	ayicbMY6/JKl6wIXGrxlRlYILjQwSpOQ0F0FkTS8xjJX1Cq98kYy+xI98eG1QbqN
	rHszH/k/IpMaMsrOia9hXsUd9IKKTN/jNRSNlgAEEYrIMxG1k4u2dfmALhGHenES
	Q/3OWz20xPiYmN/WM=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id AmN7P_fDXR9f; Thu, 14 May 2026 10:55:23 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (guest-144-149.eduroam.kfki.hu [148.6.144.149])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4gGPKz3SLgzGFDNR;
	Thu, 14 May 2026 10:55:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 11ACF140E92; Thu, 14 May 2026 10:55:20 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v7 08/10] netfilter: ipset: skip gc when resize is in progress
Date: Thu, 14 May 2026 10:55:17 +0200
Message-Id: <20260514085519.12729-9-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260514085519.12729-1-kadlec@netfilter.org>
References: <20260514085519.12729-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Zhengchuan Liang reported that because resize does not copy
the comment extension into the resized set but uses it's pointer,
ongoing gc can free the extension in the original set which then
results stale pointer in the resized one. The proposed patch was
to recreate the extensions for every element in the resized set.
It is both expensive and wastes memory, so better skip gc
when resizing in progress detected: resizing will destroy
the original set anyway, so doing gc on it unnecessary.

Reported by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 40 ++++++++++++++++-----------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 6a31f2db824a..ba560ebb4719 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -75,7 +75,9 @@ struct hbucket {
 struct htable_gc {
 	struct delayed_work dwork;
 	struct ip_set *set;	/* Set the gc belongs to */
+	spinlock_t lock;	/* Lock to exclude gc and resize */
 	u32 region;		/* Last gc run position */
+	bool resizing;		/* Signal resize in progress */
 };
=20
 /* The hash table: the table size stored here in order to make resizing =
easy */
@@ -569,28 +571,24 @@ mtype_gc(struct work_struct *work)
 	set =3D gc->set;
 	h =3D set->data;
=20
-	spin_lock_bh(&set->lock);
 	t =3D ipset_dereference_set(h->table, set);
-	atomic_inc(&t->uref);
 	numof_locks =3D ahash_numof_locks(t->htable_bits);
-	r =3D gc->region++;
-	if (r >=3D numof_locks) {
-		r =3D gc->region =3D 0;
-	}
 	next_run =3D (IPSET_GC_PERIOD(set->timeout) * HZ) / numof_locks;
 	if (next_run < HZ/10)
 		next_run =3D HZ/10;
-	spin_unlock_bh(&set->lock);
-
-	mtype_gc_do(set, h, t, r);
=20
-	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
-		pr_debug("Table destroy after resize by expire: %p\n", t);
-		mtype_ahash_destroy(set, t, false);
+	spin_lock_bh(&gc->lock);
+	if (gc->resizing)
+		goto skip_gc;
+	r =3D gc->region++;
+	if (r >=3D numof_locks) {
+		r =3D gc->region =3D 0;
 	}
+	mtype_gc_do(set, h, t, r);
+skip_gc:
+	spin_unlock_bh(&gc->lock);
=20
 	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
-
 }
=20
 static void
@@ -646,6 +644,9 @@ mtype_resize(struct ip_set *set, bool retried)
 #endif
 	orig =3D ipset_dereference_bh_nfnl(h->table);
 	htable_bits =3D orig->htable_bits;
+	spin_lock_bh(&h->gc.lock);
+	h->gc.resizing =3D 1;
+	spin_unlock_bh(&h->gc.lock);
=20
 retry:
 	ret =3D 0;
@@ -672,7 +673,11 @@ mtype_resize(struct ip_set *set, bool retried)
 		spin_lock_init(&t->hregion[i].lock);
=20
 	/* There can't be another parallel resizing,
-	 * but dumping, gc, kernel side add/del are possible
+	 * but dumping, kernel side add/del are possible.
+	 *
+	 * Parallel gc is explicitly excluded because
+	 * resize destroys the old set and its extensions
+	 * which can interfere with an ongoing gc.
 	 */
 	orig =3D ipset_dereference_bh_nfnl(h->table);
 	atomic_set(&orig->ref, 1);
@@ -692,8 +697,7 @@ mtype_resize(struct ip_set *set, bool retried)
 				if (!test_bit_acquire(j, n->used))
 					continue;
 				data =3D ahash_data(n, j, dsize);
-				if (SET_ELEM_EXPIRED(set, data))
-					continue;
+				/* Expired elements copied as well */
 #ifdef IP_SET_HASH_WITH_NETS
 				/* We have readers running parallel with us,
 				 * so the live data cannot be modified.
@@ -785,6 +789,9 @@ mtype_resize(struct ip_set *set, bool retried)
 	}
=20
 out:
+	spin_lock_bh(&h->gc.lock);
+	h->gc.resizing =3D 0;
+	spin_unlock_bh(&h->gc.lock);
 #ifdef IP_SET_HASH_WITH_NETS
 	kfree(tmp);
 #endif
@@ -1594,6 +1601,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct=
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

