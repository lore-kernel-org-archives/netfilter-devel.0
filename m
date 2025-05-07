Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE65289346
	for <netfilter-devel@vger.kernel.org>; Wed,  7 May 2025 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630493; cv=none; b=GpQmXbuOtpqAMVwasrAKyXH4tz3LhO2MrH9wIzdJv+j3t4spzJs0no+mcReG2Dv6xv/hsqeFLcUYlT7qkl4ys2jVNtdhj4hStK3dFUzEtFreThZi4Y0fvd365zbV6THyQ8t9Blr1BSwFCNLxyAAH06B/rsNT2fReUDcxv3rE8/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630493; c=relaxed/simple;
	bh=CQqyO6wgg9beQo2HIl910R9nPW6fVr8LAg4YBqwzp0U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l8kHIri/tiw2m6uDETsTYLgRnWpKO5BFYvhXu0JZEDTAoh9LxtSYuXEbg9GPy+xzSghFxVMJMMA/RMtA7wC9ybxwQ/uJqaRlSzepwMMcoidLDYnFfp/fNP2HRg49mN4wHeDMyl7ycghYJY2hYrkM0SQvoExkkFpNVSnyW8pLMx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=NNXSGv6i; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="NNXSGv6i"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 0D8EF5C001AE;
	Wed,  7 May 2025 17:02:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1746630119; x=1748444520; bh=liVYMJp31a
	x6W0eew+5AV2eyhBm+jsCB57DNVBV2PV4=; b=NNXSGv6iA/KPOKaCgXSOinw6DM
	ZhcJnjZlkAwmcjbC0Xi4ZbwAkogfXDPIdWZV9FsNO/ru8PhWv1g8y2b9PdF/ywkt
	0jeQAuu8LBqsAKGNPtv6oNCFmvhoQeaJ0yZfZSx+S1Cbx1RDzhBAbAAYPnIFdVzX
	oq+YbSMlISYuIjSlw=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id ictIm4MPWQzp; Wed,  7 May 2025 17:01:59 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 1FC165C001A8;
	Wed,  7 May 2025 17:01:59 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 173DE343169; Wed,  7 May 2025 17:01:59 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/1] netfilter: ipset: fix region locking in hash types
Date: Wed,  7 May 2025 17:01:59 +0200
Message-Id: <20250507150159.3443812-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250507150159.3443812-1-kadlec@netfilter.org>
References: <20250507150159.3443812-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Region locking introduced in v5.6-rc4 contained three macros to handle
the region locks: ahash_bucket_start(), ahash_bucket_end() which gave
back the start and end hash bucket values belonging to a given region
lock and ahash_region() which should give back the region lock belonging
to a given hash bucket. The latter was incorrect which can lead to a
race condition between the garbage collector and adding new elements
when a hash type of set is defined with timeouts.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in =
hash_xxx" reports")
Reported-by: Kota Toda <kota.toda@gmo-cybersecurity.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index cf3ce72c3de6..5251524b96af 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -64,7 +64,7 @@ struct hbucket {
 #define ahash_sizeof_regions(htable_bits)		\
 	(ahash_numof_locks(htable_bits) * sizeof(struct ip_set_region))
 #define ahash_region(n, htable_bits)		\
-	((n) % ahash_numof_locks(htable_bits))
+	((n) / jhash_size(HTABLE_REGION_BITS))
 #define ahash_bucket_start(h,  htable_bits)	\
 	((htable_bits) < HTABLE_REGION_BITS ? 0	\
 		: (h) * jhash_size(HTABLE_REGION_BITS))
--=20
2.39.5

