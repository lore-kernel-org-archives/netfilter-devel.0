Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313F7361679
	for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2026 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274261; cv=none; b=RI6moT4L55emQXOny4X9PS0OmVRuj+i2YiiXajfRGWC37+2MHGFvGxHdBXXI1idG+RKe/QH08EuOY4JtQvwISUfw+IcKUJxL890VOGzmHS31SDTtI3gsX5wi3WQXurY1cTvz8Smfb0OYYYjdODgtYqOtVkK6BANEdDI1UV/m/8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274261; c=relaxed/simple;
	bh=j9IDwMADCNHDAQRRycLHCCBmnD6CmWccaTi7ow3CRVk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bY4II83yQgDy0VgOhuUsCzUSl2nbOkpHHmmAXFnCd1hkLTA/ufZ8qu5ARcGIJf23sSZd2mLKLfBm8zUDf4VsCnBAji38ikU+hy16qd1tAdbYlB9WU5d+foFg0xu4ro1oTn2aN313TyJPuHibkIijg5hWABGhEWR1pesLteYyB/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=G7o1Dc11; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="G7o1Dc11"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gC1gw3s7Tz3sb9B;
	Fri,  8 May 2026 22:59:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1778273946; x=1780088347; bh=CQbQZUzsz8
	8tk+CALMJaG2u7tCysd9JcPbH5uMG7xyY=; b=G7o1Dc110QmxU8eGd4xTl47NVt
	L4Wsl2ilfW7j52c5KnReBjlgW+F3W2WqwnpE3vyYXvUAqzPRJ2j14CLNaFJNw/Sx
	ZZRcwGuEmbv5FaPLLC2Xs/b9jZqQvwTPF7cuS1XHGnxr/1wg+q1spFqVNvSTca2w
	SzKePgev21Mlw4phY=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id Gy7Be4RqH0gJ; Fri,  8 May 2026 22:59:06 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C131D.nat.pool.telekom.hu [37.76.19.29])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4gC1gs1YkRz3sb9S;
	Fri,  8 May 2026 22:59:05 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 084FA141F66; Fri,  8 May 2026 22:59:04 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v6 8/8] netfilter: ipset: fix order of usage counters
Date: Fri,  8 May 2026 22:59:03 +0200
Message-Id: <20260508205903.10238-9-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260508205903.10238-1-kadlec@netfilter.org>
References: <20260508205903.10238-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: ham 1%
Content-Transfer-Encoding: quoted-printable

Eulgyu Kim reported a slab-use-after-free issue when resizing
a set and gc runs in parallel. Resizing may run parallel with
already running gc or gc can start but notice that resizing
started. The operation which finishes last must destroy the
original set. The logic for the testing is: "I was the last
user of the set and it was resized". However setting the
counters in resizing was: "the set will be resized and I'm
going to use the set". That created a small racing window
at the testing phase. Fix the order in the resizing functions.

Reported by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 71b57c731dcb..023a3d7aeba0 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -681,8 +681,9 @@ mtype_resize(struct ip_set *set, bool retried)
 	 * between the original and resized sets.
 	 */
 	orig =3D ipset_dereference_bh_nfnl(h->table);
-	atomic_set(&orig->ref, 1);
 	atomic_inc(&orig->uref);
+	smp_mb__after_atomic();
+	atomic_set(&orig->ref, 1);
 	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
 		 set->name, orig->htable_bits, htable_bits, orig);
 	for (r =3D 0; r < ahash_numof_locks(orig->htable_bits); r++) {
@@ -799,6 +800,7 @@ mtype_resize(struct ip_set *set, bool retried)
 cleanup:
 	rcu_read_unlock_bh();
 	atomic_set(&orig->ref, 0);
+	smp_mb__before_atomic();
 	atomic_dec(&orig->uref);
 	mtype_ahash_destroy(set, t, false);
 	if (ret =3D=3D -EAGAIN)
--=20
2.39.5

