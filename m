Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E8D37CD2F
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 07:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777275280; cv=none; b=cpLBPneuUZ6GYgoSEVzRAwusCzPRi66xEAGci4NHtmQj9lgWOjtqhj1+6HQMY1NL0R1xzuWzRbP45vAt5pmkHRRnZb6ys0HtEmgy1Av6mWCoBr7gd+RVAwEX0fICinQKzME9Y6u+psynv54wtmbr4bb7jcRBBH7eGB1zXNQ+TX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777275280; c=relaxed/simple;
	bh=t+kRscEBI2+D+uD3AqkPMOhXiVd4gcNrb+y7fxrRYus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m5TPBvnvl/DKpjVd8Y1QR6VpmMvncQHq+CtdTHibh4otiMUNd1vFtn8vJrJazeRRP5S2Z0W9P6F5iMpLmwZb7Je2phAr5F0GixOKicTDjlWMfKcAptaDQ/sTeIcDH6eDoZ122EmR9lZHlLdR100oeUsfryz4iUeL5X1tV9yBxT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=dgUCS14H; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="dgUCS14H"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4g3wLX5vZHz3sb8d;
	Mon, 27 Apr 2026 09:34:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1777275267; x=1779089668; bh=fn3n8JCXdq
	36CQ2y1j2vOaw8HvPRf9K+wccG3dbI0JY=; b=dgUCS14H2kxZtg0ctc/IDXjzg/
	R1c3tRNBTNX/68T/qe0xbhhTs4jR3hq29ppoas0gGwOfAcWopNwBB+WnQ1RwPwGq
	dfYWpkFGFULI3685sLpNE/6ZTAIjlYt5Fbn4nrem2FtuV3E5AbPlIX+5vNSeQOAj
	RQz1at8+cQTfITV34=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 4i6guerB8e6S; Mon, 27 Apr 2026 09:34:27 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C0B05.nat.pool.telekom.hu [37.76.11.5])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4g3wLT3lTbz3sb9v;
	Mon, 27 Apr 2026 09:34:25 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 8F8ED1414AF; Mon, 27 Apr 2026 09:34:24 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5] netfilter: ipset: fix order of usage counters
Date: Mon, 27 Apr 2026 09:34:24 +0200
Message-Id: <20260427073424.573672-6-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260427073424.573672-1-kadlec@netfilter.org>
References: <20260427073424.573672-1-kadlec@netfilter.org>
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
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index cdb681708b0d..f79fe654f716 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -681,8 +681,8 @@ mtype_resize(struct ip_set *set, bool retried)
 	 * between the original and resized sets.
 	 */
 	orig =3D ipset_dereference_bh_nfnl(h->table);
-	atomic_set(&orig->ref, 1);
 	atomic_inc(&orig->uref);
+	atomic_set(&orig->ref, 1);
 	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
 		 set->name, orig->htable_bits, htable_bits, orig);
 	for (r =3D 0; r < ahash_numof_locks(orig->htable_bits); r++) {
--=20
2.39.5

