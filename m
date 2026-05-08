Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4F2372ED6
	for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2026 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274260; cv=none; b=TsH2HQXJMXrS4sqiWiGD54AWavhYZqEezTGm2SXhqRa6orXmYcL7qdY+893hwMdNVSQ3n9KtEn4RKnpTOHdNZ/uTVAp1NdptENvs7feAfuHQjJ1P4+x8hm82NXoZkKQVFBq2wAkjjD8NFyvDk9MpybSP74LgtakpT1JIIVF9Tkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274260; c=relaxed/simple;
	bh=91z/RSxDy3sYGkJq5ng7B3vpyUG2K0GJSt3zBKRfBkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ul5MXG4/zwTdU+JKcQydUDI3w1B2ftzleDpHPBRgASuydYDvPks+KWTPGYWK6Da8Ajk1ip3TqvxVbpVzYgofATAwn0aACCnYJ0WnMgT4F2obcoMNBZwNXexMryP3MO6ahkj8IjuJpxfSxwXKvK2GML/vyncjVtIhqzGgKUSYkUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=VBrPWrIY; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="VBrPWrIY"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gC1gw31NLz7s863;
	Fri,  8 May 2026 22:59:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1778273946; x=1780088347; bh=RRrMIYqUbp
	eFzzD4DBUfXMMBFzNX+/w2F9sE/pdnVF4=; b=VBrPWrIYB7JRen93gWAF6Bj7P+
	fgEQZidC31yz0fyXByO/acyaAoM81hAWJm1Dfdn5bleYiVYSe8hvujNu+FkQj1++
	ymYCBr+HcvccLkl7ObTsCTg1waXXe1yDA8T8JvLPKsSMQPHdHJCEYtD7eJOeFqWD
	WeslUsq+kvQDkOaIw=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id cwW-czt_Qx9I; Fri,  8 May 2026 22:59:06 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C131D.nat.pool.telekom.hu [37.76.19.29])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4gC1gs1l4Yz7s864;
	Fri,  8 May 2026 22:59:05 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 05BCC141ED1; Fri,  8 May 2026 22:59:04 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v6 7/8] netfilter: ipset: skip gc when resize is in progress
Date: Fri,  8 May 2026 22:59:02 +0200
Message-Id: <20260508205903.10238-8-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260508205903.10238-1-kadlec@netfilter.org>
References: <20260508205903.10238-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: maybeham 3%
Content-Transfer-Encoding: quoted-printable

Zhengchuan Liang reported that because resize does not copy
the comment extension into the resized set but uses it's pointer,
ongoing gc can free the extension in the original set which then
results stale pointer in the resized one. The proposed patch was
to recreate the extensions for every element in the resized set.
It is both expensive and wastes memory, so better skip gc
when resizing in progress detected: resizing will destroy
the original set anyway, so doing gc on it unnecessary.

Reported by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 377b4be9e4d5..71b57c731dcb 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -501,6 +501,8 @@ mtype_gc_do(struct ip_set *set, struct htype *h, stru=
ct htable *t, u32 r)
 			continue;
 		pos =3D smp_load_acquire(&n->pos);
 		for (j =3D 0, d =3D 0; j < pos; j++) {
+			if (atomic_read(&t->ref))
+				goto resize_in_progress;
 			if (!test_bit(j, n->used)) {
 				d++;
 				continue;
@@ -552,6 +554,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, stru=
ct htable *t, u32 r)
 			kfree_rcu(n, rcu);
 		}
 	}
+resize_in_progress:
 	spin_unlock_bh(&t->hregion[r].lock);
 }
=20
@@ -672,7 +675,10 @@ mtype_resize(struct ip_set *set, bool retried)
 		spin_lock_init(&t->hregion[i].lock);
=20
 	/* There can't be another parallel resizing,
-	 * but dumping, gc, kernel side add/del are possible
+	 * but dumping, kernel side add/del are possible.
+	 * gc must detect ongoing resize when comments are in use
+	 * in order not to free the comment extension area shared
+	 * between the original and resized sets.
 	 */
 	orig =3D ipset_dereference_bh_nfnl(h->table);
 	atomic_set(&orig->ref, 1);
--=20
2.39.5

