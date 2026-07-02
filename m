Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D8B4963CC
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jul 2026 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783000034; cv=none; b=HN5MmK5gpN2CjG4WEbm8XW1IcAXAixrtUkm/0YcQRYVGGQRZ8HGpTaiTHL6jmiUmlE9LdBXukm/sZsGW3GT7IIMgOOaPchQ5MRO+3wcE21+IYIwgyOigQ1GHvnjX7bFBKxrIUMrMTc3askez/UHDghPqSF/7CxTRRiEkWEYxabw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783000034; c=relaxed/simple;
	bh=5nuw1guYBTlbk4KQYOKnjvJaVmUeJskMmvjRD3WGS64=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kzdhjfAIlva2DIk7Jd5gUJoJOxc/PYxP2gdgycED1T0nM4idTH/YO2RVDCzYLrfhNYVtasFeY3V3Fa8fNizEm4vJD5vAvC67v0DRS+GnGKsZhpKv4PjIL27l09Uc1eBmCzd46r1xcja9YbhZdm3SZGZCAmApJFOE+xzUBIUppsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=hdDwWy2S; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="hdDwWy2S"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4grdV14dSzz7s7wS;
	Thu, 02 Jul 2026 15:47:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1783000023; x=1784814424; bh=1+w1GoVOf2
	G7hJSIq2TcKMBKBA8fY+WFmVxHmqLoO5k=; b=hdDwWy2Sv2q42iiw2DVR3eMWIX
	OoMzun9ONiuSs2Y+RaqBOr1Ov1Wn36WBj/9jVJEiBJugDrc1rC+nElWNLl2hJ2qi
	Tsir6qylYLlVsmz/dDAWDvQ3YzGSXwCZJapHz/mGd3W6P/do0h50zqzlmexErGzN
	h57Hukhl/p6Wyd4ko=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id pdAOEmzyILPS; Thu,  2 Jul 2026 15:47:03 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4grdTx5f57z7s7wR;
	Thu, 02 Jul 2026 15:47:01 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 878051408F2; Thu,  2 Jul 2026 15:47:01 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/5] netfilter: ipset: cleanup the add/del backlog when resize failed
Date: Thu,  2 Jul 2026 15:46:59 +0200
Message-Id: <20260702134701.207721-4-kadlec@netfilter.org>
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

Sashiko pointed out that the add/del backlog was not cleaned up
when resize failed. Fix it in the corresponding error path. Also,
make sure that the add/del backlog is htable-specific so when
resize creates a new htable, old/new backlog can't be mixed up.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 28 +++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 8104dbac02fa..c0132d0f4cc0 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -85,6 +85,7 @@ struct htable {
 	atomic_t uref;		/* References for dumping and gc */
 	u8 htable_bits;		/* size of hash table =3D=3D 2^htable_bits */
 	u32 maxelem;		/* Maxelem per region */
+	struct list_head ad;	/* Resize add|del backlist */
 	struct ip_set_region *hregion;	/* Region locks and ext sizes */
 	struct hbucket __rcu *bucket[]; /* hashtable buckets */
 };
@@ -302,7 +303,6 @@ struct htype {
 	u8 netmask;		/* netmask value for subnets to store */
 	union nf_inet_addr bitmask;	/* stores bitmask */
 #endif
-	struct list_head ad;	/* Resize add|del backlist */
 	struct mtype_elem next; /* temporary storage for uadd */
 #ifdef IP_SET_HASH_WITH_NETS
 	struct net_prefixes nets[NLEN]; /* book-keeping of prefixes */
@@ -452,13 +452,14 @@ static void
 mtype_destroy(struct ip_set *set)
 {
 	struct htype *h =3D set->data;
+	struct htable *t =3D (__force struct htable *)h->table;
 	struct list_head *l, *lt;
=20
-	mtype_ahash_destroy(set, (__force struct htable *)h->table, true);
-	list_for_each_safe(l, lt, &h->ad) {
+	list_for_each_safe(l, lt, &t->ad) {
 		list_del(l);
 		kfree(l);
 	}
+	mtype_ahash_destroy(set, t, true);
 	kfree(h);
=20
 	set->data =3D NULL;
@@ -672,6 +673,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	}
 	t->htable_bits =3D htable_bits;
 	t->maxelem =3D h->maxelem / ahash_numof_locks(htable_bits);
+	INIT_LIST_HEAD(&t->ad);
 	for (i =3D 0; i < ahash_numof_locks(htable_bits); i++)
 		spin_lock_init(&t->hregion[i].lock);
=20
@@ -774,7 +776,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	 * Kernel-side add cannot trigger a resize and userspace actions
 	 * are serialized by the mutex.
 	 */
-	list_for_each_safe(l, lt, &h->ad) {
+	list_for_each_safe(l, lt, &orig->ad) {
 		x =3D list_entry(l, struct mtype_resize_ad, list);
 		if (x->ad =3D=3D IPSET_ADD) {
 			mtype_add(set, &x->d, &x->ext, &x->mext, x->flags);
@@ -801,10 +803,21 @@ mtype_resize(struct ip_set *set, bool retried)
 	spin_lock_bh(&h->gc.lock);
 	orig->resizing =3D false;
 	spin_unlock_bh(&h->gc.lock);
+	/* Make sure parallel readers see that orig->resizing is false
+	 * before we decrement uref */
+	synchronize_rcu();
 	atomic_dec(&orig->uref);
 	mtype_ahash_destroy(set, t, false);
 	if (ret =3D=3D -EAGAIN)
 		goto retry;
+
+	/* Cleanup the backlog of ADD/DEL elements */
+	spin_lock_bh(&set->lock);
+	list_for_each_safe(l, lt, &orig->ad) {
+		list_del(l);
+		kfree(l);
+	}
+	spin_unlock_bh(&set->lock);
 	goto out;
=20
 hbwarn:
@@ -1022,7 +1035,7 @@ mtype_add(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 		memcpy(&x->mext, mext, sizeof(struct ip_set_ext));
 		x->flags =3D flags;
 		spin_lock_bh(&set->lock);
-		list_add_tail(&x->list, &h->ad);
+		list_add_tail(&x->list, &t->ad);
 		spin_unlock_bh(&set->lock);
 	}
 	goto out;
@@ -1146,7 +1159,7 @@ mtype_del(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 	spin_unlock_bh(&t->hregion[r].lock);
 	if (x) {
 		spin_lock_bh(&set->lock);
-		list_add(&x->list, &h->ad);
+		list_add(&x->list, &t->ad);
 		spin_unlock_bh(&set->lock);
 	}
 	if (atomic_dec_and_test(&t->uref) && t->resizing) {
@@ -1625,9 +1638,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct=
 ip_set *set,
 	}
 	t->htable_bits =3D hbits;
 	t->maxelem =3D h->maxelem / ahash_numof_locks(hbits);
+	INIT_LIST_HEAD(&t->ad);
 	RCU_INIT_POINTER(h->table, t);
-
-	INIT_LIST_HEAD(&h->ad);
 	set->data =3D h;
 #ifndef IP_SET_PROTO_UNDEF
 	if (set->family =3D=3D NFPROTO_IPV4) {
--=20
2.39.5

