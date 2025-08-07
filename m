Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D59279DC3;
	Thu,  7 Aug 2025 11:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566216; cv=none; b=VC085TH26yo5b/Q84j8y9UTFLHghjcEXl3HJ7zej0V5OmLuzGQ7i7jIDDSOAz1Rcv23hJcz78pDE4uohjZpGB6jn27p6DzCy6I2KfggCmIKBZW+6qkH4uvYIppiauwT4cM0ouyUIQZszfE1NC2XvM3ob6FztPzvc13LZbOywqgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566216; c=relaxed/simple;
	bh=btli/ivPsBoCjZCyudWcmxnjfvYytg34mbjj/iMtePU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SUcuOkfWH3LB8oETdzxAQlmQSKoyFEDIzGZgXWRGsUrfI7VW0adxEiIABTSNffPvWmak7e94gdqKsj/QAj2yuXo2euNiP5yJFrIcDy7L5o//ro7iVMUWfCQUgYiGYK+X+8b4c7KwqcX8xK7tbVW3Zt+d22RGG21lAfM5tdUyMXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=beY6WUZc; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z4jNZNI9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="beY6WUZc";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z4jNZNI9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1C74460961; Thu,  7 Aug 2025 13:30:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566206;
	bh=NChWi23z6JxROgqDZ2oGQAUphTbrChWFoy2rK1kEVnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beY6WUZcze142g6PmLuP0DI5uNGCOl7Mga5nwjevpmrOMjA+8GkY9qp5BWrutR/Gk
	 rjtxVBXGQW9PzKuGvLJVtBZsof6Hxa50v/TscbZm2oa1W0vFDDczcTzK2zEAkYMfbT
	 YK11+ngnK0WpAp2Hwt6jPjtCZBEFEbpwYitiL63jye07+TVWjurt1DcOhVXBInc08/
	 TYblRa8IBeZsHgt4juhoat7UGJ0sqsyPor2JApl6cjQjaq976HS4EMtXZeEvn0+Z3T
	 +Z3OcX+lXccffzVtzczk1j19N9ene2NE46ourwN/LufdhGixs86skPVJ+z8dIKKl06
	 tYSId2Zhlp+hQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AB9B060628;
	Thu,  7 Aug 2025 13:29:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566198;
	bh=NChWi23z6JxROgqDZ2oGQAUphTbrChWFoy2rK1kEVnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4jNZNI9+gYlxqeKbo5EIse1WQwIvUuCDEKrfeSELTBLSKfCQTk4Txweo8Vw2cd3E
	 FtC/DKphrp6vli4Rrhce2jxFvpAn6LFmGDtL0w2V6G0+wmoZGg1sPIdBXQzXwUgOo+
	 ENEb/O8Xiw/rY1NckEktHcw3ECP/ABo8xkv7nnDpdICwP+ZebNFkEqL4bLqX/Y3i02
	 yhentxMhBNU8WlKAXd/FVnudzRGMcKlhMAFnhvCVRpEkBQQYFoMiOuKLeBu9vesyVa
	 7UnR+1c6ULk4W8oP4LyGZXTYUT4f1THcQNTFkfLNNMm8rH6ltcd3s6wMdrSK4PkzBj
	 ACHaz5adosNkA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 5/7] netfilter: nft_set_pipapo: don't return bogus extension pointer
Date: Thu,  7 Aug 2025 13:29:46 +0200
Message-Id: <20250807112948.1400523-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250807112948.1400523-1-pablo@netfilter.org>
References: <20250807112948.1400523-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Dan Carpenter says:
Commit 17a20e09f086 ("netfilter: nft_set: remove one argument from
lookup and update functions") [..] leads to the following Smatch
static checker warning:

 net/netfilter/nft_set_pipapo_avx2.c:1269 nft_pipapo_avx2_lookup()
 error: uninitialized symbol 'ext'.

Fix this by initing ext to NULL and set it only once we've found
a match.

Fixes: 17a20e09f086 ("netfilter: nft_set: remove one argument from lookup and update functions")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/netfilter-devel/aJBzc3V5wk-yPOnH@stanley.mountain/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index db5d367e43c4..2f090e253caf 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1150,12 +1150,12 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 		       const u32 *key)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
+	const struct nft_set_ext *ext = NULL;
 	struct nft_pipapo_scratch *scratch;
 	u8 genmask = nft_genmask_cur(net);
 	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
 	const u8 *rp = (const u8 *)key;
-	const struct nft_set_ext *ext;
 	unsigned long *res, *fill;
 	bool map_index;
 	int i;
@@ -1246,13 +1246,13 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 			goto out;
 
 		if (last) {
-			ext = &f->mt[ret].e->ext;
-			if (unlikely(nft_set_elem_expired(ext) ||
-				     !nft_set_elem_active(ext, genmask))) {
-				ext = NULL;
+			const struct nft_set_ext *e = &f->mt[ret].e->ext;
+
+			if (unlikely(nft_set_elem_expired(e) ||
+				     !nft_set_elem_active(e, genmask)))
 				goto next_match;
-			}
 
+			ext = e;
 			goto out;
 		}
 
-- 
2.30.2

