Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1753B13AD05;
	Thu,  5 Jun 2025 08:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749113867; cv=none; b=pxJ8HzJENUHliNJpopSpBmLIzsAoruIGkDJXQeoJvLkTvXh4ieH3TFlBwJEVKSXN7sg4lncztWxyFp+dWJSl2RYsmhcs23z16bnWVj6g3LI+Ry7kmse7VPO3B3nvJlrxgy+0sn1/Sk6DjCX4YSZt4Dbsvp70gACUg68YzMkZvUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749113867; c=relaxed/simple;
	bh=siDvmvN19kvpcwgGHXBk0D/CmSGzLUXntmUI6Z34X1U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S8YeHxprFUxiCOM2eD94OSqUzfO3OGhDCZQXj+IYYLK0rVSTiv7qR6ognuKtdqZI5Tj/TUz5chUl17DbBEcGW1T9ghLXG/a+ldEkjIe5AgeYN7uJGsawNjjot2TxUWFM0fLVdgh5f8ylq2vx+qJhkHi5uVSVprhD2jOODkP9Pnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Xk7/pYo3; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oabxxzQO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Xk7/pYo3";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oabxxzQO"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6A60760767; Thu,  5 Jun 2025 10:57:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113863;
	bh=npENtcXRMFbFz6uB5OF8n5c0G2GoiIGx0JTR8CVryQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xk7/pYo3VVVG+uRi0OfF8SxsAFn9Pfx9DkIZpMTsdFIBfOJPWby5CwKlEbJQSxhIP
	 iPLZAebRCBLowkFV3FkDZUFYZZ/mfP3EGWtWbL9D6Tl+w4X88fgGyIBA0zlTCwrTwR
	 8NyEeOx2GLq9HTVLZ1pfx7t1jf1Mn9OqAvlFGot8vfoEeRHaEv7t/FrZZwRdGWiej8
	 pd5FA6wC6bJLcO4l8YiKDIJJErR7rc0f6rmCA5c/FZHZX+ZylU+5NCZzNlDPwXzpKQ
	 cAri8eWOSynwb2UzIsRJSA8eXqsdQ4I1z/m+w5yQ/AOEKy4kzjhK1aSlC74b1sZD/s
	 moboUYBJR7Uzg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 274CC60753;
	Thu,  5 Jun 2025 10:57:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113860;
	bh=npENtcXRMFbFz6uB5OF8n5c0G2GoiIGx0JTR8CVryQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oabxxzQOwX94AFA+Pogfv5kHxfod8uyyOLpqYeh6Hp///GDosUDt2JuS8MXlbyeWE
	 Q5KnMFV1PsMaMVXoq574pH/M+Srs9VhzBFk0Gs+Bo02TZYCgK5Xh9esNazSgVoOA0Y
	 b1ysLWZPYVKzcitSXT4veUu/8WrVLbyTZBBnEnccqnVbc60ajxAooih58O0EYcXkH2
	 lgF3XGM4e/JErr/bnkke1Za5TCWbC/8/Wwct9JT68dsdcivgYzUlfht9b4mwH5WnT2
	 c3FMLrrp6Qj3Qp4a/61Ly0zzmw1uu4nmQlHFXATu83cYOlKXBAiwe7bgSpa10P5ECJ
	 G5UeUUbJ+AFMg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/5] netfilter: nf_set_pipapo_avx2: fix initial map fill
Date: Thu,  5 Jun 2025 10:57:31 +0200
Message-Id: <20250605085735.52205-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250605085735.52205-1-pablo@netfilter.org>
References: <20250605085735.52205-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

If the first field doesn't cover the entire start map, then we must zero
out the remainder, else we leak those bits into the next match round map.

The early fix was incomplete and did only fix up the generic C
implementation.

A followup patch adds a test case to nft_concat_range.sh.

Fixes: 791a615b7ad2 ("netfilter: nf_set_pipapo: fix initial map fill")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index c15db28c5ebc..be7c16c79f71 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1113,6 +1113,25 @@ bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
+/**
+ * pipapo_resmap_init_avx2() - Initialise result map before first use
+ * @m:		Matching data, including mapping table
+ * @res_map:	Result map
+ *
+ * Like pipapo_resmap_init() but do not set start map bits covered by the first field.
+ */
+static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, unsigned long *res_map)
+{
+	const struct nft_pipapo_field *f = m->f;
+	int i;
+
+	/* Starting map doesn't need to be set to all-ones for this implementation,
+	 * but we do need to zero the remaining bits, if any.
+	 */
+	for (i = f->bsize; i < m->bsize_max; i++)
+		res_map[i] = 0ul;
+}
+
 /**
  * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
  * @net:	Network namespace
@@ -1171,7 +1190,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	res  = scratch->map + (map_index ? m->bsize_max : 0);
 	fill = scratch->map + (map_index ? 0 : m->bsize_max);
 
-	/* Starting map doesn't need to be set for this implementation */
+	pipapo_resmap_init_avx2(m, res);
 
 	nft_pipapo_avx2_prepare();
 
-- 
2.30.2

