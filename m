Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6902F8E91
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 01:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779155726; cv=none; b=eBGpzGm3/F4thbqEueshKf+XcSSrR2TpLQePVds1obhqp59LDkMsvLld+XC+MFi/dPJY0X8QXYSKK3Dyx/BUoFdT+qGsNy2GQRGHPUNehuk+4W0szaUnX6gG3G2+TJZRxdj2F8TOrnMsyqVyW/Qg79cqTQXyG8vqbpQ6oiFHLqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779155726; c=relaxed/simple;
	bh=VLgfShC+GnqWUvnm2T1qwLmUj4i+nQ5Lf0c0ffK125E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mu7a7rbf0Dg9rMY6Rm3Y880TGT0zNlBxYzRGLu3PSRUjoFpL4rsrm1G8csQsDVCldM1Uu9WYCIsfKW8uVD83x7LKGmsXUsHSAMezN6T4NBOrpHisBjZx4NA/5RnhDw3arPz9UYrI5VQM6B6JY9NYcb0XdD2xZcPah7J4MVVRhYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cm1O+m+Q; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cm1O+m+Q"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2bc763e2ba8so12955715ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 18:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779155724; x=1779760524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CrLsXHJrmnZC07Rq0XCc6PS/mOpD2keMwqnjxffoI7k=;
        b=cm1O+m+QrGjkF/sIHe6KGD2ZTAlf/HGzAhsqpBxhlls91i/eg9CALUeBWwCFtfZJ63
         s2WLotJq77USlrd+eAORSLOgMITKfXev8WFZsjf5KdnNZENhKzIugHGqJzD1g0yC8pfu
         ObzMLXUU3yKt+mW+4BWqKLKWlcHyevCNx1e6ngp9WTgCKuW2awR2R4WFC0uVMFvESvF1
         dJOA1Mz01EqRv2MckBMSdGWpfH9bykCUNNNSP60+NzaPDb8Tfh5wu6N4Lx07sNsBABG7
         tIbZ5kaDGVHI755exmoIlmzEmE4vz5trNmdqSPbci9kfPxt7BYB836snljDq+KcRWSvb
         Soeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779155724; x=1779760524;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CrLsXHJrmnZC07Rq0XCc6PS/mOpD2keMwqnjxffoI7k=;
        b=bwSzWC87HWnxLFt3A9G6HdCziDzwW5+nRnK0aPuml5r5L/Mp2KJLXPWY4hZ+O7H9kQ
         2teDFuiak95sV+RrUHt/vuRMnfsSZH2lltYnyd5KAn+O9/rtSnPRkEFwU/xhD1lP9PNM
         MXR0RNilqfTeJG7IfDalJMLIc9gBFj3t+OFwDCchAax6ZbwqRNk5vUFzVDayKwUAuYtl
         Sp0r7mGiY/6/gweeFfIYk9fqHoLC3hgRq9notnBufS868HsEd3RXUBaZH0zxnlL3IT1I
         43VX2L/l8FjnXnTkgasfWvL3ApcKqUls08Ytx170oz6Vkfb1Pic0Z7XttGGPOthmHDaM
         kyzg==
X-Gm-Message-State: AOJu0YyEgCIShXiGNRCe8HZ+ig1RuNKHu3LfjBb/U6QQWR4xbuooWI7u
	g5sLs7Yica57UC+F4DIWJ71TrsDb8AOVsmuIvWTlBooj4a+gZeFQPDi/BfVxtXxS
X-Gm-Gg: Acq92OEmcbfWX2HfxSAq1J+kmO7OFFtuZb9jIgoPwip906ZF+vfdOqnm6NwmQDIFHhw
	7gqtF6t6rQn7LxuijNZlr8NiFzmfwhQmMY+lj2EhI5EUlH79h1dGlqCMqKcEygbyQOAjBMQcoXX
	k/wnpNQiHdSNBBfG3KfiZIMvL/LMf5B6nb/IfprxSMJatq1kD468MvhKzXMSa/0RUxLdRDt6dQk
	RxJTqfBk4Hg1QzVYd66fIJVpjwK+Ur8DwXp294ED5BSmYdIiYpNd5VNsLA3KsJ6L3h3pjXmcD81
	9uHBKzjCHH0xSjteDetNDxTKIEyRXMo60/9f5PS9QFYM3wg1Ird7n2n0vkxUIYdlVqdr0W/Wg/3
	/POOI7jGJFW887fLkyQdgXdQHACANlp5HZJx3paf7e0Je3TfAV3C/M5LKtwBEX/YQtNJoJ6VtAz
	G9tOSw5E34S/XIq6VdY3y/O2P1fFsZpczaUtU6bQeHV2XTuTYGeITKycJihHIqOLWkbEdK0Xa9c
	PFTfz9cjuQ98BKyL5eVIPT6FvyOSulHI1I=
X-Received: by 2002:a17:903:37ce:b0:2bd:a403:1d82 with SMTP id d9443c01a7336-2bda4031ef2mr126868885ad.21.1779155724515;
        Mon, 18 May 2026 18:55:24 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d235e04sm169927115ad.80.2026.05.18.18.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 18:55:23 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org (open list:IPVS),
	lvs-devel@vger.kernel.org (open list:IPVS),
	coreteam@netfilter.org (open list:NETFILTER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ipvs: Use flexible array for MH lookup table
Date: Mon, 18 May 2026 18:55:06 -0700
Message-ID: <20260519015506.634185-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Store the Maglev hash lookup table in the scheduler state
allocation instead of allocating it separately.

This keeps the lookup table tied to the RCU-freed state lifetime and
simplifies the allocation and cleanup paths.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 net/netfilter/ipvs/ip_vs_mh.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
index 020863047562..d31d3c6d4216 100644
--- a/net/netfilter/ipvs/ip_vs_mh.c
+++ b/net/netfilter/ipvs/ip_vs_mh.c
@@ -59,11 +59,11 @@ static int primes[] = {251, 509, 1021, 2039, 4093,
 
 struct ip_vs_mh_state {
 	struct rcu_head			rcu_head;
-	struct ip_vs_mh_lookup		*lookup;
 	struct ip_vs_mh_dest_setup	*dest_setup;
 	hsiphash_key_t			hash1, hash2;
 	int				gcd;
 	int				rshift;
+	struct ip_vs_mh_lookup		lookup[];
 };
 
 static inline void generate_hash_secret(hsiphash_key_t *hash1,
@@ -372,7 +372,6 @@ static void ip_vs_mh_state_free(struct rcu_head *head)
 	struct ip_vs_mh_state *s;
 
 	s = container_of(head, struct ip_vs_mh_state, rcu_head);
-	kfree(s->lookup);
 	kfree(s);
 }
 
@@ -382,16 +381,10 @@ static int ip_vs_mh_init_svc(struct ip_vs_service *svc)
 	struct ip_vs_mh_state *s;
 
 	/* Allocate the MH table for this service */
-	s = kzalloc_obj(*s);
+	s = kzalloc_flex(*s, lookup, IP_VS_MH_TAB_SIZE);
 	if (!s)
 		return -ENOMEM;
 
-	s->lookup = kzalloc_objs(struct ip_vs_mh_lookup, IP_VS_MH_TAB_SIZE);
-	if (!s->lookup) {
-		kfree(s);
-		return -ENOMEM;
-	}
-
 	generate_hash_secret(&s->hash1, &s->hash2);
 	s->gcd = ip_vs_mh_gcd_weight(svc);
 	s->rshift = ip_vs_mh_shift_weight(svc, s->gcd);
-- 
2.54.0

