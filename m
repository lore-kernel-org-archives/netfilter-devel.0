Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABE23DFC73
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 08:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778748936; cv=none; b=nBtqZa0mG3gihgJAVjdljp4YFA9tQXyqcWkiL7Lfee4ztpLVR2wTkNnujNFxLrfYbcSqZDapSkyxBz2IF3q5IaX9VyLzWJXFnWkzyfR7RyXj0flBFHYXlQLdmfs6uILAcJm1pSS/NGSLDQoO1cQf43049jMvI0jNoGkYlvL04W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778748936; c=relaxed/simple;
	bh=AqW/trGO+huLsN/1N4JUDSjuHaYa8YmspIEfXEH9TbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CY74ktiuOR3SJDzFN0mdBtISOpOeC8QYI5ZHYVlyI9/kGeqgYOITmFRigiUcOgrG3ipEQ7AQvNaPKuIfBN/Ih3elJVuUwgmho03AMqgbIBBYdtJAh9P6tP9VFgU7g5XS5n1uSX4+3Jk2RKORjcGpvTjh6fnyZ+WHbguAdh/0rrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=jY+BGtue; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="jY+BGtue"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4gGPL310wHzGFDNN;
	Thu, 14 May 2026 10:55:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1778748921; x=1780563322; bh=UjidRbHUaw
	fRn67WkJqYQGZx6l6A4xDzJX+SyZ7voXg=; b=jY+BGtueWRfcHBxRQQNFzqiNGg
	92YCdk3WGSVZ6ZtSkNT4VpBNUCnl479FafoFRsRqJm2cbND9yXx4nobzBbPW+MJZ
	QgcusWlqN7bKIubf3J4N7Dk6AGxHfWJ2e0mHOcGWBAB12epWCOkMRIFjgULb1SB3
	5cB4U9jw+V33JHPks=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id imTPRdBg2gVk; Thu, 14 May 2026 10:55:21 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (guest-144-149.eduroam.kfki.hu [148.6.144.149])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4gGPKz3PdHzGFDNQ;
	Thu, 14 May 2026 10:55:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 0AB40140B4F; Thu, 14 May 2026 10:55:20 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v7 05/10] netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types
Date: Thu, 14 May 2026 10:55:14 +0200
Message-Id: <20260514085519.12729-6-kadlec@netfilter.org>
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

