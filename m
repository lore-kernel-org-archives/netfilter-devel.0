Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F9429898F;
	Thu,  3 Sep 2026 00:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788396134; cv=none; b=YbOk76V80E/11fcAzJnEUHUH8pYBwVhQ8eq8xiZbupfDiZ/kgfwj3NeuFZ9+wDmA9Ab/BA55PA8bQynV5M5QHcDTNb0JJSEw4fcq7grHI90Rl/iANk/Fo2jkgWC+37gTPrCt/t6PCvw7U6Bw0V0YO7dlHL6vgMW1cv2H4xDTxJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788396134; c=relaxed/simple;
	bh=FRXYKOnHOeiPFbX+4CKKWM1IGhqOZyjDqqjoRez2Q7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlknUlTJpg2KAulkhT43/gAqEXITlJK/h44/zoe25+gAMozbZvhW3ZkWCjoMHlST+vFqaJyxVu3r+m8F+3H67jvpuzOes2LRGWgsuPtYLl3TERexFIUhZYvvbmEjYZIQ6CBQPKWsHejpmRg1Kyaf9Zo3ohFuPxtDTBPJNLeXGuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rpxSl3Yo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rpxSl3Yo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788396123;
	bh=df5RA8v3auGnlrhDG9gLSowZE1CIu+CKF4JhRGFy3xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpxSl3Yo6tJkXQY92OD4BVlYRzW2v86z9HkL/zcB8+e16uRbWfE02PZW6+S+cZ40M
	 syHmFsMVDrLFr6chlroPCAbGNhgCkZLJ9J/GptLUZN09v2MV2WSMw1UvGmZpvxY8X0
	 KEAvnCmREjLqNp64FrDd9uFjAmO7EmIZ1B64d5e7mKsjlwCG8bjVcTW8kCQsQ56Vhp
	 jy3weix1BgRAZgzoEOQ7ZHqfwZULNKIfqCueEVuYYT8Bi5PVWG4lqIAfL/I4V3ZK/Y
	 B8+/pFuElnZa1tPsPAEq8sDlIttxGjlIAItnNFVfxtKr0bwKOs17Xw6ltm+nLpWy/X
	 ufSVb/qqnsM7w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8EBE9607AD;
	Thu,  3 Sep 2026 02:42:02 +0200 (CEST)
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
Subject: [PATCH net 06/12] ipvs: bound LBLCR and LBLC cache growth
Date: Thu,  3 Sep 2026 02:41:43 +0200
Message-ID: <20260903004149.1037028-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903004149.1037028-1-pablo@netfilter.org>
References: <20260903004149.1037028-1-pablo@netfilter.org>
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
index 693bcc82ccb7..8180a7ba9f53 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -204,6 +204,9 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 			return en;
 		ip_vs_lblc_del(en);
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

