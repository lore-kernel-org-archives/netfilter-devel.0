Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA2934DB52
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779542658; cv=none; b=U2DYF2dOeYGo9NuyhgP54IdEaJ+30r35AiGRtZ7FWbqcWD2RQA2ZLM3agF4Z0d2kQXUI5RMPj0KBDfWhKZHw4MjDs+7h6OaaXD2SJw3MzHxETl7S3vhUHT4NehbazWmi9TEotY/mcau71W6Wjn57xi6FJmARW+hMM6hb5AfW/5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779542658; c=relaxed/simple;
	bh=RTg/GdwJI8Bbf4KJNpxkua1HzHrSD7ideGSwnP35mJE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rr9qWHLh55bzF4sxuGIH/hYs+bMGYyHOI5wwYDQ1Q9/NBDa+Zn+aF2tHYuOL8AEW7IIar1BvgmHXktFCQYryQrRF1ATe4466U04801a5MG2JV/goPzpdDS/Ysq4bxqbLYWYkiH7Jny5kDdhio7uILP/Mb2eWen0KpNn2N0uoBnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=C3ZJbmcT; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="C3ZJbmcT"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4gN2gv1WzpzGFDMM;
	Sat, 23 May 2026 15:15:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1779542121; x=1781356522; bh=i1WeacfPgb
	NntIDHr5gKZYI1Y9vdNB5KGRuvFR4+jKI=; b=C3ZJbmcTA9XDJP6Qr8d7F1rf6F
	YodJ3wmOtvy89SFYTUF5OkpwT4qObjDlYqEYm8aBDpZNtOzNIeYX1WRTUD9YtPfC
	CSIrVe4JsQeycfEaib0ecrXyd4IJf3kV5g2LLO3BY+1GcqDMk6w48BV93jiwbPDm
	ui/8HwogqBgaeIjzs=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id m0fFdAE6NK28; Sat, 23 May 2026 15:15:21 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (85-66-106-71.pool.digikabel.hu [85.66.106.71])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4gN2gq4C1zzGFDMJ;
	Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 4A11D141227; Sat, 23 May 2026 15:15:19 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/6] netfilter: ipset: fix potential torn read in reuse/forceadd cases
Date: Sat, 23 May 2026 15:15:18 +0200
Message-Id: <20260523131519.99953-6-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260523131519.99953-1-kadlec@netfilter.org>
References: <20260523131519.99953-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: maybeham 4%
Content-Transfer-Encoding: quoted-printable

Sashiko pointed out that due to using memcpy() to overwrite
already existing entry in reuse/forceadd cases, it can lead to
torn reads for concurrent lockless RCU readers. Set the element
explicitly to unused before trying to reuse it.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 4928196a737e..d97b783174d6 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -868,7 +868,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	bool flag_exist =3D flags & IPSET_FLAG_EXIST;
 	bool deleted =3D false, forceadd =3D false, reuse =3D false;
 	u32 r, key, multi =3D 0, elements, maxelem;
-	u8 npos =3D 0;
+	u8 npos =3D 0, retried =3D 0;
=20
 	rcu_read_lock_bh();
 	t =3D rcu_dereference_bh(h->table);
@@ -893,6 +893,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 	}
 	rcu_read_unlock_bh();
=20
+retry:
 	spin_lock_bh(&t->hregion[r].lock);
 	n =3D rcu_dereference_bh(hbucket(t, key));
 	if (!n) {
@@ -941,6 +942,10 @@ mtype_add(struct ip_set *set, void *value, const str=
uct ip_set_ext *ext,
 			j =3D 0;
 		data =3D ahash_data(n, j, set->dsize);
 		if (!deleted) {
+			if (retried++)
+				goto set_full;
+			clear_bit(j, n->used);
+			smp_mb__after_atomic();
 #ifdef IP_SET_HASH_WITH_NETS
 			for (i =3D 0; i < IPSET_NET_COUNT; i++)
 				mtype_del_cidr(set, h,
@@ -949,6 +954,8 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 #endif
 			ip_set_ext_destroy(set, data);
 			t->hregion[r].elements--;
+			spin_unlock_bh(&t->hregion[r].lock);
+			goto retry;
 		}
 		goto copy_data;
 	}
--=20
2.39.5

