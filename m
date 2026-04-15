Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3EB3CE490
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 08:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776241252; cv=none; b=LOTB+NKB4XV8gT/5PRlnxhQTl8nuMq4JbOmFPK0YqcGm3Y44Cj5rP2WdaIVAgo0YnP5B36fcv2Kr6MNhY1ly7nW0aw/TTqZbdYwvb277JOwNyscPH2zBmjZ2Sbhk0SgnB/V3r8c1lbbttxuNu8X7Cdk8OeiGgJCS0BezGS10ZKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776241252; c=relaxed/simple;
	bh=7wJz8M5itl9ddWgUW+XiTHkA05ViTfddCZzXlzDMkFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A2Qnze414LWpbX3+ZkcjJXU/50fpq0Jh/epsH7SxrlZyg4ioo6Boxnc3lHMybNcjBAPIorsH1Pv1qNppXInUtY7SkO0VGRMsrmURVSbvl8e+ZkZ1WH2SZDcTb0xSh9TbcqC0ZQDoOvU9Zq6/kNuJae3eyvgshcM9CW5UFuKPqcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=fddcGkcZ; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="fddcGkcZ"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4fwYxP4sCszGFDN4;
	Wed, 15 Apr 2026 10:20:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1776241239; x=1778055640; bh=P40TgG6IZR
	YVNAuSkuuChW80ik5S+J42hc9xOA5y6Kg=; b=fddcGkcZf50hWK2dzQ5Zzg1fan
	NxiQU7x9sDDKvxBPrQchh7Eca8abL7F6gSydYgSbicRRHG7m9mCuGHLLGc6IDu37
	hSjl+gklZfEnExhV9FW12O/EEvFqU+ylyqIYJTgOBMcNibs3PtSpC5reX6ZUYaYL
	q1JdyQWVuXzIzaybY=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id cJx6cgtuFf1W; Wed, 15 Apr 2026 10:20:39 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4fwYxM5XKxzGFDN3;
	Wed, 15 Apr 2026 10:20:39 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id B09B434316C; Wed, 15 Apr 2026 10:20:39 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] netfilter: ipset: Fix data race between add and dump in all hash types
Date: Wed, 15 Apr 2026 10:20:39 +0200
Message-Id: <20260415082039.4133308-3-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260415082039.4133308-1-kadlec@netfilter.org>
References: <20260415082039.4133308-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

When adding a new entry to the next position in the existing hash bucket,
the position index was incremented too early and parallel dump could
read it before the entry was populated with the value. Move the setting
of the position index after populating the entry.

Reported-by: syzbot+786c889f046e8b003ca6@syzkaller.appspotmail.com
Reported-by: syzbot+1da17e4b41d795df059e@syzkaller.appspotmail.com
Reported-by: syzbot+421c5f3ff8e9493084d9@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index b79e5dd2af03..0da02a8dfbae 100644
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
@@ -962,7 +963,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	}
=20
 copy_elem:
-	j =3D n->pos++;
+	j =3D npos =3D n->pos + 1;
 	data =3D ahash_data(n, j, set->dsize);
 copy_data:
 	t->hregion[r].elements++;
@@ -985,6 +986,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
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

