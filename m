Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A74519004A
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779542658; cv=none; b=CGh/4RD3WKR8zJ1USifLoYbfiVuoD7T45KinlqoYHTPbyGp/i1ap8osTPwJL2fVUqaaTIxN/90q3vJMZoU0h9y2Xiu3RWvc14VaWiMg9qj94K3uxwokHJO5e6Ed7Z4NHf1GH94H2FFwsCJBjYYZrXVEuUNyXV6JHdDlTxIelufQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779542658; c=relaxed/simple;
	bh=2cPJpCMxIw5jkVjsOlsgpr9YMFt8s8T1Lq9EEqQzhHw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Aktd2RukfkEYXmRRfi+ofClPvVSoH0mgRc+9943/nhqXANsLjSkn+yrpHUm6P9HRVDlrPB4fedqqmZz5brXMApzGqgxVemnAEkY//9WFG7fkf1yhqP5lAV/2ta3JGadMcw5Ccwkg/kquv1Q5H1BDHxley0AD3gXOaYOttNM0enM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=MldsAEJj; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="MldsAEJj"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4gN2gs2pbYzGFDM8;
	Sat, 23 May 2026 15:15:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1779542119; x=1781356520; bh=NlzOw8rsf9
	wJexm3gOXZ51a5ASOg0hJXJUVsY6+2TdA=; b=MldsAEJjagASJoUjOex/WbqJiy
	5c5KEyDtrxkR1RZQcuvkB1r1AEaFf5lPIV4VLU/65cg36sm6ZU/ZXAbTx/LWPqWy
	M/Ci/KlAAKbJ6MoPezNgQBlaaqsZ0+Dtd7tgTX8dsV1ZaMvEtDxqV+RYLog5LEwK
	Se4H8/I8oFu6e/Ypc=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id ARhA9y53t5fw; Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (85-66-106-71.pool.digikabel.hu [85.66.106.71])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4gN2gq377kzGFDMG;
	Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 477E81411D4; Sat, 23 May 2026 15:15:19 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/6] netfilter: ipset: skip gc when resize is in progress
Date: Sat, 23 May 2026 15:15:17 +0200
Message-Id: <20260523131519.99953-5-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260523131519.99953-1-kadlec@netfilter.org>
References: <20260523131519.99953-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: maybeham 6%
Content-Transfer-Encoding: quoted-printable

Zhengchuan Liang reported that because resize does not copy
the comment extension into the resized set but uses it's pointer,
ongoing gc can free the extension in the original set which then
results stale pointer in the resized one. The proposed patch was
to recreate the extensions for every element in the resized set.
It is both expensive and wastes memory, so better skip gc
when resizing in progress detected: resizing will destroy
the original set anyway, so doing gc on it is unnecessary.

Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reported by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 32 ++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 6a31f2db824a..4928196a737e 100644
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
@@ -573,16 +575,21 @@ mtype_gc(struct work_struct *work)
 	t =3D ipset_dereference_set(h->table, set);
 	atomic_inc(&t->uref);
 	numof_locks =3D ahash_numof_locks(t->htable_bits);
-	r =3D gc->region++;
-	if (r >=3D numof_locks) {
-		r =3D gc->region =3D 0;
-	}
 	next_run =3D (IPSET_GC_PERIOD(set->timeout) * HZ) / numof_locks;
 	if (next_run < HZ/10)
 		next_run =3D HZ/10;
 	spin_unlock_bh(&set->lock);
=20
+	spin_lock_bh(&gc->lock);
+	if (gc->resizing)
+		goto skip_gc;
+	r =3D gc->region++;
+	if (r >=3D numof_locks) {
+		r =3D gc->region =3D 0;
+	}
 	mtype_gc_do(set, h, t, r);
+skip_gc:
+	spin_unlock_bh(&gc->lock);
=20
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by expire: %p\n", t);
@@ -590,7 +597,6 @@ mtype_gc(struct work_struct *work)
 	}
=20
 	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
-
 }
=20
 static void
@@ -646,6 +652,9 @@ mtype_resize(struct ip_set *set, bool retried)
 #endif
 	orig =3D ipset_dereference_bh_nfnl(h->table);
 	htable_bits =3D orig->htable_bits;
+	spin_lock_bh(&h->gc.lock);
+	h->gc.resizing =3D 1;
+	spin_unlock_bh(&h->gc.lock);
=20
 retry:
 	ret =3D 0;
@@ -672,7 +681,11 @@ mtype_resize(struct ip_set *set, bool retried)
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
@@ -692,8 +705,7 @@ mtype_resize(struct ip_set *set, bool retried)
 				if (!test_bit_acquire(j, n->used))
 					continue;
 				data =3D ahash_data(n, j, dsize);
-				if (SET_ELEM_EXPIRED(set, data))
-					continue;
+				/* Expired elements copied as well */
 #ifdef IP_SET_HASH_WITH_NETS
 				/* We have readers running parallel with us,
 				 * so the live data cannot be modified.
@@ -785,6 +797,9 @@ mtype_resize(struct ip_set *set, bool retried)
 	}
=20
 out:
+	spin_lock_bh(&h->gc.lock);
+	h->gc.resizing =3D 0;
+	spin_unlock_bh(&h->gc.lock);
 #ifdef IP_SET_HASH_WITH_NETS
 	kfree(tmp);
 #endif
@@ -1594,6 +1609,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct=
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

