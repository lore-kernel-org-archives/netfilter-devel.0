Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720213D890B;
	Sun, 27 Sep 2026 22:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546913; cv=none; b=SHBwI6+LN8zXpLriYLDOxplfrtq/REYqx2aHuFlMqYghzkBKTJXu3x7c8QurRtv+llvY66WFcF3xzkTFYtUdKlBeLQqAzjeZ4zgGBR11L6teduLVDBEB3q0TrlBbFp4hVSqFYYZe/mT/6X7eeO/Sd3snnFy5H7GxKMjHmdqaaVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546913; c=relaxed/simple;
	bh=8vzOGrFkWgI8jYjz3Q67R4wq3+7OJDfWZo4c9QtJucU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8KmzQSmMb+xcf4EvMtJkAwRG0kiB93zSOtJAs3hHLbhkRySuOowpZU0pCNqBhAD6+poyh1DrRTilCxXzI/8QCpAY2f+25j/pVb6Y4oEN0DbPfKjapWPmXwILnemEbm5i4EmTbpUDmfe4S8ySECMkN29mpIwTzP/ACqvIkQuQ4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GCARoqKx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GCARoqKx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546908;
	bh=kCoFU4XIFa6Wo+ZLdkpBKqak8kZCy16d0Dp9cP9wS7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCARoqKx58Ki8/roQCtonY+IHFufcoiTvO4qzjtlevlJabRkXeOCfpZWpqoWvsnab
	 LYOx0J+q1vMVp7hZ4eauVafnqywZo5vQj++RjyPt6GC0OOYae2+Srb7PoH/sp8RpPx
	 JrcATIqjMHRcw14cpwLb9lQNVcQRB9WzrCEKEHiMub9qMJUivpdNy0r0K+U+ntwNAL
	 m2j7uUIWMYASYk5fg74mNGSAeVjFr2APnVPN5LSVvUFT/4t6Hg0sghby1Frycf24TI
	 aRHe9g0ogIrB4w8t9O/5Kpg6gGZStQ+Oovpn62IZ+BokDuakJ9rriTtOrfXZ2Opu16
	 n9lJVrUGw/57Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CD64A603E1;
	Mon, 28 Sep 2026 00:08:27 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 05/11] ipvs: bound LBLCR and LBLC cache growth
Date: Mon, 28 Sep 2026 00:08:10 +0200
Message-ID: <20260927220816.268206-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiling Zou <zhilinz@nebusec.ai>

ip_vs_lblcr_new() and ip_vs_lblc_new() create cache entries for
every previously unseen destination address. The table max_size only
tells the periodic collector to reclaim entries after the cache has
already exceeded the limit. It does not reclaim entries that the
attacker continues to use.

Reject new cache entries once either table reaches max_size * 3 / 2.
The extra headroom lets the periodic collector catch up while the
existing scheduler fallback continues to use the selected destination
when cache creation fails. New traffic therefore stays serviceable
without growing the tables further.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_lblc.c  | 3 +++
 net/netfilter/ipvs/ip_vs_lblcr.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index a2b574904f13..55af77a56929 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -205,6 +205,9 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 		ip_vs_lblc_del(en);
 		atomic_dec(&tbl->entries);
 	}
+	if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
+		return NULL;
+
 	en = kmalloc_obj(*en, GFP_ATOMIC);
 	if (!en)
 		return NULL;
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index f53f05ceea36..858393b1d2d1 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -363,6 +363,9 @@ ip_vs_lblcr_new(struct ip_vs_lblcr_table *tbl, const union nf_inet_addr *daddr,
 
 	en = ip_vs_lblcr_get(af, tbl, daddr);
 	if (!en) {
+		if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
+			return NULL;
+
 		en = kmalloc_obj(*en, GFP_ATOMIC);
 		if (!en)
 			return NULL;
-- 
2.47.3

