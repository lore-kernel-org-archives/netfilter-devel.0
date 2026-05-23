Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCCE21B192
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 13:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779542125; cv=none; b=F4j5baU5nX3SyOZNP8GDYEHuZLRX7SN7W0Cq/ugBxHqLOsH/8YSyY30ZkfTQeJY5hbZ3TFxdK9YyYwlasgo+XNCiMDZe9z/rwpWhWhV1Rpap0PZiheyHowrvY41W2iWLuoQH/6zUO7uKJDBHUR4Lc3gmliOJ9ocd/j23JJINqqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779542125; c=relaxed/simple;
	bh=AqW/trGO+huLsN/1N4JUDSjuHaYa8YmspIEfXEH9TbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=meQaLLzpYNPmCek8Sus4gDeaEE+UNkSD+26cjSR6vItYLqhGFoSiLx620shj1NWSyEr2F6QjajxvLxQda8v3tIaZEw5RNL6Pc/5oudvgZzuuwkHPgglA/DQDTBYks2VOF+hi8Non0cne8d/QwzrK33rgylGVRLUtTJwobDKsRKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=CTTDp7Qf; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="CTTDp7Qf"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gN2gs2Drcz7s86V;
	Sat, 23 May 2026 15:15:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1779542119; x=1781356520; bh=UjidRbHUaw
	fRn67WkJqYQGZx6l6A4xDzJX+SyZ7voXg=; b=CTTDp7QfHWFlVRjjf7LojH1eIY
	TxowjQQg8y9FNKBV0NxA8U6oGG4aOsI64NHiAII00NEsDz//6JSIeZGEKVc5XEzu
	exdI0SxbckscnVu747iSzhJdFxF5bpIpfeH2jywXgc537vXA+LZ0Fn6FINm6BQiy
	l9HPR+zJiHPi2aa9k=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id ixzeHXBz111h; Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (85-66-106-71.pool.digikabel.hu [85.66.106.71])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4gN2gq2hDkz7s86L;
	Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 3F21D140207; Sat, 23 May 2026 15:15:19 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/6] netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types
Date: Sat, 23 May 2026 15:15:14 +0200
Message-Id: <20260523131519.99953-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260523131519.99953-1-kadlec@netfilter.org>
References: <20260523131519.99953-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: maybeham 3%
Content-Transfer-Encoding: quoted-printable

Sashiko pointed out that there are a few lockless RCU readers
using test_bit() which is a relaxed atomic operation and
provides no memory barrier guarantees. Use test_bit_acquire()
instead where the operation may run parallel with add/del/gc,
i.e. is not one from the next cases

- protected by region lock
- in a set destroy phase
- in a new/temporary set creation phase

Also, add two missing smp_mb__after_atomic() operations.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 04e4627ddfc1..6a31f2db824a 100644
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
@@ -995,6 +995,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	/* Ensure all data writes are visible before updating position */
 	smp_store_release(&n->pos, npos);
 	set_bit(j, n->used);
+	smp_mb__after_atomic();
 	if (old !=3D ERR_PTR(-ENOENT)) {
 		rcu_assign_pointer(hbucket(t, key), n);
 		if (old)
@@ -1201,7 +1202,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_e=
lem *d,
 			continue;
 		pos =3D smp_load_acquire(&n->pos);
 		for (i =3D 0; i < pos; i++) {
-			if (!test_bit(i, n->used))
+			if (!test_bit_acquire(i, n->used))
 				continue;
 			data =3D ahash_data(n, i, set->dsize);
 			if (!mtype_data_equal(data, d, &multi))
@@ -1259,7 +1260,7 @@ mtype_test(struct ip_set *set, void *value, const s=
truct ip_set_ext *ext,
 	}
 	pos =3D smp_load_acquire(&n->pos);
 	for (i =3D 0; i < pos; i++) {
-		if (!test_bit(i, n->used))
+		if (!test_bit_acquire(i, n->used))
 			continue;
 		data =3D ahash_data(n, i, set->dsize);
 		if (!mtype_data_equal(data, d, &multi))
@@ -1396,7 +1397,7 @@ mtype_list(const struct ip_set *set,
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

