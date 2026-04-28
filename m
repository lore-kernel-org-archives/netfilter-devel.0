Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EC2359A6C
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 15:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777389567; cv=none; b=nuY9SEAyNQeGzpC2/cqY19QV0kaHUxOkqkifTt36XqBAQc2Qy1x/I50khW2mJi5XKYOTAXLOYwncpMGvCydA7TJrPlw48kJKqRSlIaPU32yyzBMw7PbKctum2CNfMIIVz6jXbLQhmD33/ncAV2qODYW5EraFFf2EarupRxSOL+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777389567; c=relaxed/simple;
	bh=4PR3s4ldTqxK1IGlliu6c4u0Nh+fexsvb2N/I/y//FU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L5ppiW2p7QmRWOZC1pPQTS6z+RilPbWKF4rAVIPlj72P4LKyMIiONd427tu5x6/CXndxXCT9gUyUrm2JH7dw4ZiGmNoAF3nue2scLjTXHZ3UsK8JFv5/aWjmX6E+XSXm0AD9oUIC+CF0hPkcb/25OVq33LA9GIIs67M4WI3Oxtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=QpMTFViJ; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="QpMTFViJ"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4g4kcP2ndvzGFDMp;
	Tue, 28 Apr 2026 17:19:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1777389555; x=1779203956; bh=+xEURBhmlT
	Ydd40zS6SZGv9bqG2AzPA3XWbRQNRV1X0=; b=QpMTFViJmSI3+p1gck0Qz5jeVc
	i4ZZwgxVz1S0AtrGFbAQTqdVUloxIXcJTLdNJBe8lI3j4gY0ieatvtWoohewxh/8
	ntrOnyStYMPnTVdfb9GxszSYDS1MIFntcbQ8Ca4urUa7XeE8VKXq/hES8PSL+NXd
	s4wi5jsoCj90fG4FY=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 0sR2Fo5mGjpz; Tue, 28 Apr 2026 17:19:15 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4g4kcK61mgzGFDMr;
	Tue, 28 Apr 2026 17:19:13 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 81F191414AF; Tue, 28 Apr 2026 17:19:13 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5] netfilter: ipset: fix order of usage counters
Date: Tue, 28 Apr 2026 17:19:13 +0200
Message-Id: <20260428151913.584739-6-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260428151913.584739-1-kadlec@netfilter.org>
References: <20260428151913.584739-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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
index cc490460c52b..29af68347799 100644
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

