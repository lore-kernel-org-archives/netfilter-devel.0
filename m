Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B85237C938
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 07:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777275282; cv=none; b=TrKruwmgxuNVrujNc8GvkCyUzDtj9t2BS7MtQym/O54VFcE7Ieq/sKuAmTfd+XWaJTfhBfEYFOOEw7Tk4eGDa13E4920DgeAI4hRSwRrsWactjM6YVzrKHjIFbfaPs7rq0n7IgrGunrxz+w+q9dODiVP6/0eTv9Gv38pExPWSo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777275282; c=relaxed/simple;
	bh=gXE9+zLmExyalSg4nEM4Hx+xtDJRSXB51Emy4IJ+GD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yd7SPnsq7sh735KZb2sRovMfIcfELrZ64kTax4mYlV8WxPQGyrZCznrkQ6mXyPu951qB5RRhW7LpJ06mGIkbzi3EBh9FdOmdZuWFuujVMW14vPz+XOP7wnNe4SGe0YF/A0jtFUKsoiQI0S3dh7NxnUqeHJzN3sABI0uU/fZpMzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=FFCB+Ddm; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="FFCB+Ddm"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4g3wLV6TGDz7s85G;
	Mon, 27 Apr 2026 09:34:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1777275265; x=1779089666; bh=e7ByC2pgz8
	Rc4pKTN1avTUBg9+OOXEPEsiZWvkL1Ffc=; b=FFCB+DdmY4RAzfJENoLbNhflkn
	6cWb1AZFCkIJQTQnJqFxInTgjE+maVvETqYjWzbYjSQ5+jhTix7pfYtn5rVEPB5B
	C9ecBTTu07SoOwExzH7+29ugpAtPwFumcBo26GJQWI1j3j9G6IkE0RBPcosgfglJ
	HuSRDovOo99q0vZAc=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id m4HxRpF6lgqb; Mon, 27 Apr 2026 09:34:25 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C0B05.nat.pool.telekom.hu [37.76.11.5])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4g3wLT01B4z7s859;
	Mon, 27 Apr 2026 09:34:24 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 863B714127D; Mon, 27 Apr 2026 09:34:24 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/5] netfilter: ipset: Fix data race between add and dump in all hash types
Date: Mon, 27 Apr 2026 09:34:21 +0200
Message-Id: <20260427073424.573672-3-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260427073424.573672-1-kadlec@netfilter.org>
References: <20260427073424.573672-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: maybeham 9%
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
index 181daa9c2019..f96085b19682 100644
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

