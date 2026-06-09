Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF783DD850
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 07:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780990498; cv=none; b=WkbftYs203QtBJ5qU0NOZ9ObtTLrLwZ/pNwItuKJyBpGPI6wITSzucaQT52HYdabxu7utytH8653bfZyREqj4LKEDPwmlwO+Uvf8UvZs+lss0bT6hxv10IdaVXjPIjBi0Oh9ebt0pxUAT09848zB10ciaV+lJFVjHzJAStjR3i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780990498; c=relaxed/simple;
	bh=AIEH9ERkDWCgk9uDKlbZYpqeOIKTjQaNXBhgEVbJ8mQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WSrASgZBLOB/cjVQGH3cWvcXH+gSHJJ0pDKz2kN8XyjYHYzvbjUX9LXYPQxd/gGzK4TB73OC3LnCSZgnHZuTxRo+3vC1iw1YUH9rXZUZaRGaGp3r8lsSG6eWvpnzoErKtTG/h3T1x4MKa76jaH2Z7ysIo/XB04bx1w/KjFPOJMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=C3KgJVQZ; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="C3KgJVQZ"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4gZL965FQ9zGFDCY;
	Tue, 09 Jun 2026 09:27:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1780990072; x=1782804473; bh=wHR9DUI+CC
	y7K67gXGU9I2tKCa41z0RV5TKcuAiECCc=; b=C3KgJVQZneXnnG3Hmjuo5Oy6mO
	CNeTM3R3kpYtubj4Pl9XhUnlR33Zx9axzUQ6KlHCJoD9MXpIOLDI+nZG8+FHWfhm
	BO+SP/e8rDcQOfQM0YQeic6Q7uh4aEHcE74yDCLZjFB8pGj1Gqfu1EwGRcld3fuY
	hphRE0p1qqpdV3EN8=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 6XRF_sXbazG1; Tue,  9 Jun 2026 09:27:52 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C0692.nat.pool.telekom.hu [37.76.6.146])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4gZL932W3PzGFDCZ;
	Tue, 09 Jun 2026 09:27:51 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 54F0914117B; Tue,  9 Jun 2026 09:27:50 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2 8/9] netfilter: ipset: fix potential torn read in reuse/forceadd cases
Date: Tue,  9 Jun 2026 09:27:49 +0200
Message-Id: <20260609072750.318774-9-kadlec@netfilter.org>
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

Sashiko pointed out that due to using memcpy() to overwrite
already existing entry in reuse/forceadd cases, it can lead to
torn reads for concurrent lockless RCU readers. Delete the element
explicitly before reusing its slot.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 90a84121b925..fb9251c59b5b 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -857,12 +857,16 @@ mtype_add(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 	const struct mtype_elem *d =3D value;
 	struct mtype_elem *data;
 	struct hbucket *n, *old =3D ERR_PTR(-ENOENT);
-	int i, j =3D -1, ret;
+	int i, j, ret;
 	bool flag_exist =3D flags & IPSET_FLAG_EXIST;
-	bool deleted =3D false, forceadd =3D false, reuse =3D false;
-	u32 r, key, multi =3D 0, elements, maxelem;
-	u8 npos =3D 0;
+	bool deleted, forceadd, reuse;
+	u32 r, key, multi, elements, maxelem;
+	u8 npos, retried =3D 0;
=20
+retry:
+	multi =3D 0;
+	j =3D -1;
+	deleted =3D forceadd =3D reuse =3D false;
 	rcu_read_lock_bh();
 	t =3D rcu_dereference_bh(h->table);
 	key =3D HKEY(value, h->initval, t->htable_bits);
@@ -931,6 +935,10 @@ mtype_add(struct ip_set *set, void *value, const str=
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
@@ -939,6 +947,9 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 #endif
 			ip_set_ext_destroy(set, data);
 			t->hregion[r].elements--;
+			spin_unlock_bh(&t->hregion[r].lock);
+			rcu_read_unlock_bh();
+			goto retry;
 		}
 		goto copy_data;
 	}
--=20
2.39.5

