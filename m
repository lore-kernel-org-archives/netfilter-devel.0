Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128A155E4C
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040653; cv=none; b=miBzwYt3z60XZJKyeEA5oVU2sQpwGfL+Ck5nWXSzIwFmZv0kAfeaKPWOAQ/G64hFk5eWgN9NDGADgANtm5UvNxUxjOItDLPd53XeCRkdQKVZdmAsSb2w36XyZVUizfFUVR5vEBB7PmeHxsGFjy1Q6aum+SOb8wKfyWW5GxFxHk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040653; c=relaxed/simple;
	bh=tO02K42qIHrhZsmm/Eny6eNMeKbkVku3kg12Zfnjuos=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EZWAEz8CD9Vzk0QJpFujxadHn58Loi8D6jlm5ORWxdDAMQUrK4uU2Nbfbibtfcdom8XqMgkGwELOqEqGdm7eWKmHyh2g4GSPRJGZ5Y26zD0EWn6sj2aupCkkvcwl8DjfiQaswJipko/nPordwsKBJ19ovdwxl7qbcZKdQa3r7lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/8] netfilter: nf_tables: reject element expiration with no timeout
Date: Wed,  7 Aug 2024 16:23:51 +0200
Message-Id: <20240807142357.90493-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240807142357.90493-1-pablo@netfilter.org>
References: <20240807142357.90493-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If element timeout is unset and set provides no default timeout, the
element expiration is silently ignored, reject this instead to let user
know this is unsupported.

While at it, remove unnecesary notation to read default set timeout
under mutex.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0fb8f8f1ef66..79ab90069b84 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6920,6 +6920,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_EXPIRATION] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+		if (timeout == 0)
+			return -EOPNOTSUPP;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_EXPIRATION],
 					    &expiration);
 		if (err)
-- 
2.30.2

