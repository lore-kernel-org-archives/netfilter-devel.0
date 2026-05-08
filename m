Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589E72F531F
	for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2026 21:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274259; cv=none; b=DdpPwBggDMeQmN8R44dXgRSs8jFvSFvgt1MobXG36SlGJ3OzUuLhqBAQPa+cwE4SvESH8f1r85vpYbzlWbvi55eEjN465h0z0OfHasWEAfl1V1SZYK+DKuWUScRpqrjXXOYM6JevnAWt4D7wxzzPphTeEejlPavfTdHjchkDu6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274259; c=relaxed/simple;
	bh=5NL3MjkUPgK/Pezvlj7QGmQYmUuh96pFKP8PLa8YQBY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q1ktUylUMvZkVLNIIe2rl9vPE711j3PnkjwodhOhQVH2W8j06C7X1bmqSM1k+bbDE/Z6Uw6FaZkyo7tdCiVNUEbpmCeVtngd/uDknSWe9/DmDJRBczICVTxkKzpoW9fe1QYiBpb3ijqTVlsYaR50weFziPCPA4eeb0abrlQKhPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=dhVNKybZ; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="dhVNKybZ"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4gC1gv0YGMzGFDNK;
	Fri,  8 May 2026 22:59:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1778273945; x=1780088346; bh=gth3Ex/Xg2
	Evx/YBOd0gwYeCdiqu0URZc0p6m739BIo=; b=dhVNKybZGqP4+0kbdBzZIc+DAq
	0hFqHTFlZF6BKLWdZe1Ob5kug8Ok+432RiSWV2wO6yRWUWN5ie7lkhVZI+X7eIRl
	9+BNHe524m0J6Qop9MICqoQGjNSh1Hj2NLnVeo5dA8nEzsPy/xozNnMSCnFguhdV
	UotXx4lyILab00kmI=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 9bkcAWyh2cfo; Fri,  8 May 2026 22:59:05 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C131D.nat.pool.telekom.hu [37.76.19.29])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4gC1gs1FLzzGFDNP;
	Fri,  8 May 2026 22:59:05 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 02C24141EC7; Fri,  8 May 2026 22:59:04 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v6 6/8] netfilter: ipset: fix potential torn read in reuse/forceadd cases
Date: Fri,  8 May 2026 22:59:01 +0200
Message-Id: <20260508205903.10238-7-kadlec@netfilter.org>
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

Sashiko pointed out that due to using memcpy() to overwrite
already existing entry in reuse/forceadd cases, it can lead to
torn reads for concurrent lockless RCU readers. Set the element
explicitly to unused before reusing it.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 6a31f2db824a..377b4be9e4d5 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -926,6 +926,8 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 			j =3D 0;
 		data =3D ahash_data(n, j, set->dsize);
 		if (!deleted) {
+			clear_bit(j, n->used);
+			smp_mb__after_atomic();
 #ifdef IP_SET_HASH_WITH_NETS
 			for (i =3D 0; i < IPSET_NET_COUNT; i++)
 				mtype_del_cidr(set, h,
--=20
2.39.5

