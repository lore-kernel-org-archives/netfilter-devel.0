Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CD83F5BC3
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jul 2026 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783000035; cv=none; b=OZWmX5izu8FFQm0riuubhZciNxOlUxd1zittEyFjYDqtfXDPpnKDZc6NdHYSTwjwLV9V2ZQvurtRHawiGdhO9QI7Ljtcs8lxOd5ud/lrTbXl7PuImsyjjEcGhKBJRnQP0xJxZjKN2sGCvYNam/8+Vf+bRwyQ3rjY7LpF457b2LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783000035; c=relaxed/simple;
	bh=7q+SxHGDLyh5kuGXS6Tl1TtdmPC+xnGTEXpiFRS0ayU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qv7nve3Ra5+YT07wVjiZQ8n+kS2m9Ld/pFfuWVILJMOvJnK6M9mAbAmHaIIY0rPiqZX2vTWu2v4GkwFhoQzE1F36ztD+hb6cdMmx9BwShvC37YwBI8QVRR7YPgm+Z4b5x1CbbvhnC6zjUkK1EOvQP4/j1sK1y60dvQ5bvwkDbiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=ipvvAGkm; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="ipvvAGkm"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4grdV14XRhz7s7wP;
	Thu, 02 Jul 2026 15:47:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1783000023; x=1784814424; bh=VMg4gpT7FN
	w8pKr3PHE03ddNclGxFSBMWOncH34dqhc=; b=ipvvAGkmrlIBUqy0bfGuSaDJWE
	T7mA+eYFUBKCXqoy4Ibic7sSrGCqk38WtMZna16C742p582lLyrLEjvXRaNsj8iB
	6kHshxHlVaXPvYbPjuRaEMfps/4/AnANWoZpCf+WCsHfwmGW21yR9ESrDqD5wsFd
	0C2k6uHoaXDenkGOk=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id GuFWL5uSC8w6; Thu,  2 Jul 2026 15:47:03 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4grdTx5Twcz7s7wQ;
	Thu, 02 Jul 2026 15:47:01 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 8263A140165; Thu,  2 Jul 2026 15:47:01 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/5] netfilter: ipset: mark the rcu locked areas properly
Date: Thu,  2 Jul 2026 15:46:57 +0200
Message-Id: <20260702134701.207721-2-kadlec@netfilter.org>
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

When we bump the uref counter, there's no need to keep
the rcu lock because the referred hash table can't
disappear. Also, from the same reason in mtype_gc we
need the rcu lock and not a spinlock.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index dedf59b661dd..c9a071766243 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -569,9 +569,10 @@ mtype_gc(struct work_struct *work)
 	set =3D gc->set;
 	h =3D set->data;
=20
-	spin_lock_bh(&set->lock);
-	t =3D ipset_dereference_set(h->table, set);
+	rcu_read_lock_bh();
+	t =3D rcu_dereference_bh(h->table);
 	atomic_inc(&t->uref);
+	rcu_read_unlock_bh();
 	numof_locks =3D ahash_numof_locks(t->htable_bits);
 	r =3D gc->region++;
 	if (r >=3D numof_locks) {
@@ -580,7 +581,6 @@ mtype_gc(struct work_struct *work)
 	next_run =3D (IPSET_GC_PERIOD(set->timeout) * HZ) / numof_locks;
 	if (next_run < HZ/10)
 		next_run =3D HZ/10;
-	spin_unlock_bh(&set->lock);
=20
 	mtype_gc_do(set, h, t, r);
=20
@@ -860,15 +860,13 @@ mtype_add(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 	key =3D HKEY(value, h->initval, t->htable_bits);
 	r =3D ahash_region(key);
 	atomic_inc(&t->uref);
+	rcu_read_unlock_bh();
 	elements =3D t->hregion[r].elements;
 	maxelem =3D t->maxelem;
 	if (elements >=3D maxelem) {
 		u32 e;
-		if (SET_WITH_TIMEOUT(set)) {
-			rcu_read_unlock_bh();
+		if (SET_WITH_TIMEOUT(set))
 			mtype_gc_do(set, h, t, r);
-			rcu_read_lock_bh();
-		}
 		maxelem =3D h->maxelem;
 		elements =3D 0;
 		for (e =3D 0; e < ahash_numof_locks(t->htable_bits); e++)
@@ -876,7 +874,6 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 		if (elements >=3D maxelem && SET_WITH_FORCEADD(set))
 			forceadd =3D true;
 	}
-	rcu_read_unlock_bh();
=20
 	spin_lock_bh(&t->hregion[r].lock);
 	n =3D rcu_dereference_bh(hbucket(t, key));
--=20
2.39.5

