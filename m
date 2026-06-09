Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6493DD53C
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 07:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780990507; cv=none; b=AB3Zp7kA5hg6lVwWanMdS8c5wo6H81n4XsQMfvK6IBI/b10nhRoVL1J9uHFKdsDPSrYkyIMIVIyWOBTGShVYACp9kXKzo11umZXpDdJ96VTbz8d6IEpOPw1IgUOOURqp9mxeDTyBgeKRq1spwzSZEV2+ui+BxYX6wvd3CdslG2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780990507; c=relaxed/simple;
	bh=UeSiGZttUpcrAPimU3hSYulqiW2TAkWgDL8x/h6Ts4g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C6ANSomfV3a0UDC0AcYxLndjx4fpJuOQOvzHKkvCYwCnECNtXlVW2Bxo/oJq+Q5ufCQ+t0rE8Nwib0KyB9yGW4MJ+luYfJYk6tpoXC2pIK99bxgoM6UEO7vN/IRXpsqnikhJopOSTcflI6fR+Ra3v/+nQGaPz1ou9gw4p98nCQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=tg9vO1gf; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="tg9vO1gf"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gZL945ttkz7s7wp;
	Tue, 09 Jun 2026 09:27:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1780990070; x=1782804471; bh=0reP2age/t
	g+HISpfDh5GxjT+A+qBFKmZpIfKfjv3w4=; b=tg9vO1gfGLnZJvGWBJ2M1rjqgO
	XHNJSBywsGUgrUJlxWHMKwk6gfQVcVAy1Txw6UcmUTNri5x/3VEXINB45iDBpHPh
	liuThKlW9GdBVCI6Yt1X6Dt2JZoHoipNpf06HnQTcIIpcZfwjToUbhS/lkWUVAYV
	K4GNQfCrd5EUlnXyY=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id pk-fBOZDzzsD; Tue,  9 Jun 2026 09:27:50 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C0692.nat.pool.telekom.hu [37.76.6.146])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4gZL925YZ6z7s7wc;
	Tue, 09 Jun 2026 09:27:50 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 44C1714026C; Tue,  9 Jun 2026 09:27:50 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2 1/9] netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types
Date: Tue,  9 Jun 2026 09:27:42 +0200
Message-Id: <20260609072750.318774-2-kadlec@netfilter.org>
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

Sashiko pointed out that there are a few lockless RCU readers
using test_bit() which is a relaxed atomic operation and
provides no memory barrier guarantees. Use test_bit_acquire()
instead where the operation may run parallel with add/del/gc,
i.e. is not one from the next cases

- protected by region lock
- in a set destroy phase
- in a new/temporary set creation phase

Also, add missing smp_mb__[after|before]_atomic() operations.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 04e4627ddfc1..6ab32d3a827e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -689,7 +689,7 @@ mtype_resize(struct ip_set *set, bool retried)
 				continue;
 			pos =3D smp_load_acquire(&n->pos);
 			for (j =3D 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
+				if (!test_bit_acquire(j, n->used))
 					continue;
 				data =3D ahash_data(n, j, dsize);
 				if (SET_ELEM_EXPIRED(set, data))
@@ -826,7 +826,7 @@ mtype_ext_size(struct ip_set *set, u32 *elements, siz=
e_t *ext_size)
 				continue;
 			pos =3D smp_load_acquire(&n->pos);
 			for (j =3D 0; j < pos; j++) {
-				if (!test_bit(j, n->used))
+				if (!test_bit_acquire(j, n->used))
 					continue;
 				data =3D ahash_data(n, j, set->dsize);
 				if (!SET_ELEM_EXPIRED(set, data))
@@ -991,8 +991,8 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	/* Must come last for the case when timed out entry is reused */
 	if (SET_WITH_TIMEOUT(set))
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
-	smp_mb__before_atomic();
 	/* Ensure all data writes are visible before updating position */
+	smp_mb__before_atomic();
 	smp_store_release(&n->pos, npos);
 	set_bit(j, n->used);
 	if (old !=3D ERR_PTR(-ENOENT)) {
@@ -1201,7 +1201,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_e=
lem *d,
 			continue;
 		pos =3D smp_load_acquire(&n->pos);
 		for (i =3D 0; i < pos; i++) {
-			if (!test_bit(i, n->used))
+			if (!test_bit_acquire(i, n->used))
 				continue;
 			data =3D ahash_data(n, i, set->dsize);
 			if (!mtype_data_equal(data, d, &multi))
@@ -1259,7 +1259,7 @@ mtype_test(struct ip_set *set, void *value, const s=
truct ip_set_ext *ext,
 	}
 	pos =3D smp_load_acquire(&n->pos);
 	for (i =3D 0; i < pos; i++) {
-		if (!test_bit(i, n->used))
+		if (!test_bit_acquire(i, n->used))
 			continue;
 		data =3D ahash_data(n, i, set->dsize);
 		if (!mtype_data_equal(data, d, &multi))
@@ -1396,7 +1396,7 @@ mtype_list(const struct ip_set *set,
 			continue;
 		pos =3D smp_load_acquire(&n->pos);
 		for (i =3D 0; i < pos; i++) {
-			if (!test_bit(i, n->used))
+			if (!test_bit_acquire(i, n->used))
 				continue;
 			e =3D ahash_data(n, i, set->dsize);
 			if (SET_ELEM_EXPIRED(set, e))
--=20
2.39.5

