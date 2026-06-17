Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF4A3DD531
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 08:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781686160; cv=none; b=HOo3ijJWBckHMJ6V4hluxTZJH3CA1BTS18kuEwNrheFnWV6UV9M6LKW9SyHWzHR5H03WwL0sijRXNJORokswTtlM3PE02iecDVA7OSdJXkBDiA1j79MyA5rWoxZsSnHjSwGLSy6MH7b23GyWFtI8o3KO1VQ2r9ov9dMm+ZujZ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781686160; c=relaxed/simple;
	bh=kBiVFD0DWFMujF5G3ef1GKLxc4K1QlDESPp2XnjOtfI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sLV4eTOkTpXjVqWwgG8SbsWNH4k4GwQ3+D4kj94bRtrBurnAIxxrJnAMeFfaRcEs8MAw8rRAWI+gaSevjtp4/OoHrqsD1Fdl0fwPrgFHRNUk5fVSBRQSHOrYisT/wuLSDsHkPizTXEIDD2DGPQ3RL9MwMI4I3nZ93EC73k+XJP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=iHxCwyDq; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="iHxCwyDq"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4ggHQL5v63z3sb0r;
	Wed, 17 Jun 2026 10:41:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1781685688; x=1783500089; bh=tM59zWP2FH
	oCgLN7dcVomBfXPIyD/kvMxSE2nRHb82s=; b=iHxCwyDqmS+S98OwMeUmw1P0Sp
	Xq8BngzcTsW6K9FZWKjVkBFbsd5eJNel6AJQMetX5jOEG7JG+VcHPn/zPu4b+neE
	H2TlcnlRHvol+ZkAuWwCA3v4Qo+0d5EcSvTrwecInOhFCuPFiftiux0udDvVL5f7
	RW2qx7d3vUU1aLEo8=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id tRfxYTamr7RV; Wed, 17 Jun 2026 10:41:28 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4ggHQJ64y1z3sb0b;
	Wed, 17 Jun 2026 10:41:28 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id A583D140498; Wed, 17 Jun 2026 10:41:28 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v3 1/7] netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types
Date: Wed, 17 Jun 2026 10:41:22 +0200
Message-Id: <20260617084128.6603-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260617084128.6603-1-kadlec@netfilter.org>
References: <20260617084128.6603-1-kadlec@netfilter.org>
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

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 04e4627ddfc1..00c27b95207f 100644
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
@@ -1201,7 +1201,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_e=
lem *d,
 			continue;
 		pos =3D smp_load_acquire(&n->pos);
 		for (i =3D 0; i < pos; i++) {
-			if (!test_bit(i, n->used))
+			if (!test_bit_acquire(i, n->used))
 				continue;
 			data =3D ahash_data(n, i, set->dsize);
 			if (!mtype_data_equal(data, d, &multi))
@@ -1259,7 +1259,7 @@ mtype_test(struct ip_set *set, void *value, const s=
truct ip_set_ext *ext,
 	}
 	pos =3D smp_load_acquire(&n->pos);
 	for (i =3D 0; i < pos; i++) {
-		if (!test_bit(i, n->used))
+		if (!test_bit_acquire(i, n->used))
 			continue;
 		data =3D ahash_data(n, i, set->dsize);
 		if (!mtype_data_equal(data, d, &multi))
@@ -1396,7 +1396,7 @@ mtype_list(const struct ip_set *set,
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

