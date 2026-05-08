Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC5635BDC2
	for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2026 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274261; cv=none; b=SIMxgR/gJOjaDJiJhjdxJYYvKxF7S79WR12OnkKEMssD0vN+KJ7Kvp7RNiMa6mIdeDPyIZdSbBuCzGby6aduYNkWFtd1KeeOtQKp6Sji7PBq53RYCSW75IVUm/2/mvam4YO6VDxqSYvQVkWBm0nhR4siCb2hFMilhIk91QkZrto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274261; c=relaxed/simple;
	bh=z9vTmh0fSqwJ1ueufXsV7s1eXltCSepqRBLDjqQ/Xfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eBriEWZTiXT5gdgVhp6Jo00RY/FE1bNGvRvTteLxXVAMjjF8Ckcwu34/nlkKUhMLgYVam0V11nLZKblkFtW4Sk0kxQ5pmoTZRb9iaccxj7cyzktiifi/jKDBSICKN3FkO3RVANcGBtP3rBdxWclKDg8plYtMFO/X6pC4cMccuxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=dKPRXS2Y; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="dKPRXS2Y"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gC1gt4Tmsz3sb9W;
	Fri,  8 May 2026 22:59:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1778273944; x=1780088345; bh=mMbMG0BPl3
	zgbThJJz5+q6tMTVZ/+YN5YNiuckTDl5Q=; b=dKPRXS2YOT8Pl31kUDLLBeB5O2
	SOKEl2cHowmnXIISQR3Pi3U9F0fPlw1goOdNC7OcsLY1dj0Jji1a1A/Ao7NM997F
	Xi1DPFK7r2RaLIYJEz3ckFT6RZyLA9hsbrxA93dGV2cP0bpN1eST+eGrq5nPaZN3
	bKnIsswi2cOk6uCB8=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id bI9vfJQtoP5w; Fri,  8 May 2026 22:59:04 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C131D.nat.pool.telekom.hu [37.76.19.29])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4gC1gr56Jjz3sb8s;
	Fri,  8 May 2026 22:59:04 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id EE85C141D64; Fri,  8 May 2026 22:59:03 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v6 3/8] netfilter: ipset: Fix data race between add and dump in all hash types
Date: Fri,  8 May 2026 22:58:58 +0200
Message-Id: <20260508205903.10238-4-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260508205903.10238-1-kadlec@netfilter.org>
References: <20260508205903.10238-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: 20ham 10%
Content-Transfer-Encoding: quoted-printable

When adding a new entry to the next position in the existing hash bucket,
the position index was incremented too early and parallel dump could
read it before the entry was populated with the value. Move the setting
of the position index after populating the entry.

v2: Position counting fixed, noticed by Florian Westphal.

Reported-by: syzbot+786c889f046e8b003ca6@syzkaller.appspotmail.com
Reported-by: syzbot+1da17e4b41d795df059e@syzkaller.appspotmail.com
Reported-by: syzbot+421c5f3ff8e9493084d9@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index b79e5dd2af03..133ce4611eed 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -844,7 +844,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	const struct mtype_elem *d =3D value;
 	struct mtype_elem *data;
 	struct hbucket *n, *old =3D ERR_PTR(-ENOENT);
-	int i, j =3D -1, ret;
+	int i, j =3D -1, npos =3D 0, ret;
 	bool flag_exist =3D flags & IPSET_FLAG_EXIST;
 	bool deleted =3D false, forceadd =3D false, reuse =3D false;
 	u32 r, key, multi =3D 0, elements, maxelem;
@@ -889,6 +889,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 			ext_size(AHASH_INIT_SIZE, set->dsize);
 		goto copy_elem;
 	}
+	npos =3D n->pos;
 	for (i =3D 0; i < n->pos; i++) {
 		if (!test_bit(i, n->used)) {
 			/* Reuse first deleted entry */
@@ -962,7 +963,8 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	}
=20
 copy_elem:
-	j =3D n->pos++;
+	j =3D npos;
+	npos =3D n->pos + 1;
 	data =3D ahash_data(n, j, set->dsize);
 copy_data:
 	t->hregion[r].elements++;
@@ -985,6 +987,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	if (SET_WITH_TIMEOUT(set))
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
 	smp_mb__before_atomic();
+	n->pos =3D npos;
 	set_bit(j, n->used);
 	if (old !=3D ERR_PTR(-ENOENT)) {
 		rcu_assign_pointer(hbucket(t, key), n);
--=20
2.39.5

