Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5A13DD520
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 07:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780990508; cv=none; b=g2T9ZSe3blYqjgzxVymlmQSYHoMVBtDcC7eKBQSXdjcfJek9JJlYrypEmqW5g0FNzPsCGw4oMuccbe9lyylvmmR/DwQa4Nvq6UOxqt0MCrPARxxIXLnRQwQwM53aDak9MCsKzJbaW1ouqRhyWmmQgiB1IreTPZlRDNFe854t+Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780990508; c=relaxed/simple;
	bh=FrwizPr7unusZnE4hYvtygQjFXP2f0PblG+cICjEQfY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=csp2erSXbL/fvkRNrHYNIv9aTKE89YfaBBkPkvonuiaDeQmpEW3ZIcAqlrjhWW0csDHZhlK1wXfgJ1q2tBSTq310h1FSK+21LwOuQspmXAT6r8QDR+iLZL+jaK7nVkLAajhZZB2rwVV9khxAehAunMLZGy64+EiRKexkKtQTa+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=pi0pVAo7; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="pi0pVAo7"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gZL96558zz7s7wf;
	Tue, 09 Jun 2026 09:27:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1780990072; x=1782804473; bh=RDLzAkX5Ft
	1ElxCMMCiVgTd/bjIloW+74V82/Z6TMWQ=; b=pi0pVAo7k3dLTfBtOwLhwSOkg6
	vm0sq+S5RaWEaR3StqDzlZtxirzsdgiqgCmZPMnC7w20vnB2unD8hI2eFlazryfO
	dCzSWa6xbW3ApEPc1ig60ICO3yiy9KfiN1aWPHkc+oqP1m2ICMSHrvSKgzMqwftF
	mYq68fLNKGLVlMk74=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id XIJ-MurSwS-E; Tue,  9 Jun 2026 09:27:52 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C0692.nat.pool.telekom.hu [37.76.6.146])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4gZL932Zpqz7s7wm;
	Tue, 09 Jun 2026 09:27:51 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 4DEF6140E29; Tue,  9 Jun 2026 09:27:50 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2 5/9] netfilter: ipset: exlude gc when resize is in progress
Date: Tue,  9 Jun 2026 09:27:46 +0200
Message-Id: <20260609072750.318774-6-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260609072750.318774-1-kadlec@netfilter.org>
References: <20260609072750.318774-1-kadlec@netfilter.org>
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
It is both expensive and wastes memory, so better exclude gc
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
 net/netfilter/ipset/ip_set_hash_gen.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 20678116ae32..a41f6cdeed80 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -84,6 +84,7 @@ struct htable {
 	atomic_t uref;		/* References for dumping and gc */
 	u8 htable_bits;		/* size of hash table =3D=3D 2^htable_bits */
 	u32 maxelem;		/* Maxelem per region */
+	spinlock_t gc_lock;	/* Lock to exclude gc and resize */
 	struct ip_set_region *hregion;	/* Region locks and ext sizes */
 	struct hbucket __rcu *bucket[]; /* hashtable buckets */
 };
@@ -581,7 +582,9 @@ mtype_gc(struct work_struct *work)
 	if (next_run < HZ/10)
 		next_run =3D HZ/10;
=20
+	spin_lock_bh(&t->gc_lock);
 	mtype_gc_do(set, h, t, r);
+	spin_unlock_bh(&t->gc_lock);
=20
 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
 		pr_debug("Table destroy after resize by expire: %p\n", t);
@@ -646,6 +649,7 @@ mtype_resize(struct ip_set *set, bool retried)
 #endif
 	orig =3D ipset_dereference_bh_nfnl(h->table);
 	htable_bits =3D orig->htable_bits;
+	spin_lock_bh(&orig->gc_lock);
=20
 retry:
 	ret =3D 0;
@@ -759,6 +763,8 @@ mtype_resize(struct ip_set *set, bool retried)
 	/* There can't be any other writer. */
 	rcu_assign_pointer(h->table, t);
=20
+	spin_unlock_bh(&orig->gc_lock);
+
 	/* Give time to other readers of the set */
 	synchronize_rcu();
=20
@@ -797,6 +803,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	mtype_ahash_destroy(set, t, false);
 	if (ret =3D=3D -EAGAIN)
 		goto retry;
+	spin_unlock_bh(&orig->gc_lock);
 	goto out;
=20
 hbwarn:
@@ -1617,6 +1624,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct=
 ip_set *set,
 	}
 	t->htable_bits =3D hbits;
 	t->maxelem =3D h->maxelem / ahash_numof_locks(hbits);
+	spin_lock_init(&t->gc_lock);
 	RCU_INIT_POINTER(h->table, t);
=20
 	INIT_LIST_HEAD(&h->ad);
--=20
2.39.5

