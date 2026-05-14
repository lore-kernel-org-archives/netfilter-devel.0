Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919513DFC6E
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 08:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778748934; cv=none; b=UoUbxZAqCONA7gGPOVtTS5rgOL1ayaIi2L20lHkxw16jNsIGmUcNEvzp58MbNC8GSwEWZ4M0/L42bScCOn52C2seJRsT+zLhR53u1M/56Ds+o6zTVn4/BDqXJhlRfGjquke0SSM2Kyf6ISgS5vWX0HpKD5/uiD5md5UrLDV7b2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778748934; c=relaxed/simple;
	bh=YAqe7SqZyqmni4zcCZTNhdVPNtax0cCzakq47Zyq5s8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h8Kwm83JJXHnTJyB0cI0sKSykjdZzXV3AHdJ8JmQnkUcYFjgE5fGem0r8LWirhfou8xPRf2/Hs2GPZkD2qr4gTM+JZFJ1+7lWUFNz4BLy4xohaSh4fSpxaYE8DprAcdpX2P1rl3tKGEGBZgtAdNSRM9RlDYEQh5dM55Y7J0APNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=pClwZvz2; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="pClwZvz2"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gGPL138lXz3sbCw;
	Thu, 14 May 2026 10:55:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1778748919; x=1780563320; bh=rrseQhIS3K
	35Gv42Mz2Q3p+ELdsdoe6J6FhR6lxktx0=; b=pClwZvz2oVPliqvs1WpSVQFOdk
	2AFEeT2y3qciFQOsMJWdBL5LXl3/dlFldspqv6kPh20GP4d8t5un2iXgOTI9C+ZD
	FnU/a8g/NTl6xEof1wv4hA6h/9ZsnC9wSiIGCtflFU0uCVN+WqvmEDjrcgqY2RZm
	a/Hw5ZGu+NAnxuUog=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id ElCaUUQ6xJBJ; Thu, 14 May 2026 10:55:19 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (guest-144-149.eduroam.kfki.hu [148.6.144.149])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4gGPKz3pW6z3sbCc;
	Thu, 14 May 2026 10:55:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 13E44140EDF; Thu, 14 May 2026 10:55:20 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v7 09/10] netfilter: ipset: fix potential torn read in reuse/forceadd cases
Date: Thu, 14 May 2026 10:55:18 +0200
Message-Id: <20260514085519.12729-10-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260514085519.12729-1-kadlec@netfilter.org>
References: <20260514085519.12729-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Sashiko pointed out that due to using memcpy() to overwrite
already existing entry in reuse/forceadd cases, it can lead to
torn reads for concurrent lockless RCU readers. Set the element
explicitly to unused before reusing it.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index ba560ebb4719..9d1fcf6c8328 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -933,6 +933,12 @@ mtype_add(struct ip_set *set, void *value, const str=
uct ip_set_ext *ext,
 			j =3D 0;
 		data =3D ahash_data(n, j, set->dsize);
 		if (!deleted) {
+			clear_bit(j, n->used);
+			/* Give time to other readers of the set
+			 * to avoid torn reads due to the memcpy()
+			 * below.
+			 */
+			synchronize_rcu();
 #ifdef IP_SET_HASH_WITH_NETS
 			for (i =3D 0; i < IPSET_NET_COUNT; i++)
 				mtype_del_cidr(set, h,
--=20
2.39.5

