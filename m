Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAB1379C55
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779542658; cv=none; b=sHrXAkVuzqsrDCCigEny41ZpH9mfhsmP2SR9prQsEWwsop8sVi+HnvQrhVDCBRHdKulRDiiE45M1KVgz9pAm8uMHjCdBjnDuL+PLwTchS15qQzRg74ky1ui0XuBhW+SPwYxlSFbNQtr4HpGZx7QcbN5K7VK8mKOl1u5nmoiGKyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779542658; c=relaxed/simple;
	bh=CjGRWk0k39FcBbmvxcFOFxYhcopi99AkFcZIcU1hwvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nmj/kqBLizHzZ6NOWQtMeOqVv0XmimFem6/S+f3hU/BGA8AZVETCElPMGCK/iiIIlf5O0OOQu6RtpPW6/9BYAflxT26NMV7m3rVOJjoamk0QakvZztJCXxYCJHTAUBN471JfcLCgSEAW89LP5wnO/QspFRMlElKZ1z+Onm+BPt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=N9ADWG1U; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="N9ADWG1U"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4gN2gs2MCZzGFDMK;
	Sat, 23 May 2026 15:15:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1779542119; x=1781356520; bh=HpKT2nDUSH
	vvzwgFakPNUZP/wnQyobsAXLm9nTVf6JA=; b=N9ADWG1UmwKKb/nG7e/tY7gQwQ
	1tnEyCFLdWq+XiTI5kZ3UZl8FmaVFsCthxg4YKxnvFgWzn4zbKPQ3IrX7aq4TIJL
	44wau8EE3NRtK1dlm1MNTb4xr0eNpFW5MT9pRd4+mXXCue92EGQDKo8qaFbZD2c/
	rcjwVeKVo5RgTZ620=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id z-FNSJaamreG; Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (85-66-106-71.pool.digikabel.hu [85.66.106.71])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4gN2gq2r2LzGFDM8;
	Sat, 23 May 2026 15:15:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 42624140FFA; Sat, 23 May 2026 15:15:19 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/6] netfilter: ipset: Don't use test_bit() in lockless RCU readers in bitmap types
Date: Sat, 23 May 2026 15:15:15 +0200
Message-Id: <20260523131519.99953-3-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260523131519.99953-1-kadlec@netfilter.org>
References: <20260523131519.99953-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: ham 1%
Content-Transfer-Encoding: quoted-printable

The pair of the patch "netfilter: ipset: Don't use test_bit() in lockless
RCU readers in hash types" for the bitmap types.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipse=
t/ip_set_bitmap_gen.h
index 798c7993635e..71aeb3bd9b49 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -51,7 +51,7 @@ mtype_ext_cleanup(struct ip_set *set)
 	u32 id;
=20
 	for (id =3D 0; id < map->elements; id++)
-		if (test_bit(id, map->members))
+		if (test_bit_acquire(id, map->members))
 			ip_set_ext_destroy(set, get_ext(set, map, id));
 }
=20
@@ -142,6 +142,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 			ret =3D 0;
 		} else if (!(flags & IPSET_FLAG_EXIST)) {
 			set_bit(e->id, map->members);
+			smp_mb__after_atomic();
 			return -IPSET_ERR_EXIST;
 		}
 		/* Element is re-added, cleanup extensions */
@@ -166,6 +167,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
=20
 	/* Activate element */
 	set_bit(e->id, map->members);
+	smp_mb__after_atomic();
 	set->elements++;
=20
 	return 0;
@@ -219,7 +221,7 @@ mtype_list(const struct ip_set *set,
 		cond_resched_rcu();
 		id =3D cb->args[IPSET_CB_ARG0];
 		x =3D get_ext(set, map, id);
-		if (!test_bit(id, map->members) ||
+		if (!test_bit_acquire(id, map->members) ||
 		    (SET_WITH_TIMEOUT(set) &&
 #ifdef IP_SET_BITMAP_STORED_TIMEOUT
 		     mtype_is_filled(x) &&
@@ -278,6 +280,7 @@ mtype_gc(struct timer_list *t)
 			x =3D get_ext(set, map, id);
 			if (ip_set_timeout_expired(ext_timeout(x, set))) {
 				clear_bit(id, map->members);
+				smp_mb__after_atomic();
 				ip_set_ext_destroy(set, x);
 				set->elements--;
 			}
--=20
2.39.5

