Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1271542DFF3
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 20:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770236835; cv=none; b=WodBrPnFJQhmysLwlU+1Jb875KaANRqf6YDgDVbDkKGa7OVTPpZfgZ92knmgfk4NAAh7BXrNgnWZUk0tR+pmnFv2e0oRFr/RlLth6oSHu0uxroCLz+gKO5AelRYwB/4TopmXDfTfeOa4gdoMKp3D/0JeK9CSuV6nPSUN8fz9LKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770236835; c=relaxed/simple;
	bh=spX8OY0R91gJkahjHLJOLF8ziANgiXwrDt3EB0arAFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nt9biUmNCeFEZ8r4nh5AUounJ5fhW2OZlqXi3avUwaYb9hlGXkcIdo4CApKnvrjtaDa3U94qqELExB7tepmaaklhgm59eIyveJQAB8OmCv9b7mmA2k33zVwvUE0OserlZEgjQvvCd+Czs7wr4k97pxmOk9kPPOlJM09kmNV0oes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=KdVLq+WH; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="KdVLq+WH"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id B99BB8756;
	Wed,  4 Feb 2026 21:27:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770236833;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QdjvJ2ZN4sNM0g0Diw/Tv3p7j+J5wnOM2a7s3meSbzU=;
	b=KdVLq+WH9VwsM2VxNyQi4NlUxYgM0zOywRj1ReIKAFoRe6y17rL7YC0Vjh63i7Wr
	yaj6fnddn8fjjTuA6cbtrg6/WR56GbFXIlRVByEsYGzX/1aBBzU36nLH7h8k2iv6JRf
	OUdj6gnIiipw/ypNiIssWT8mdIfiJRhTgoC/suD4cu2NWedgxhwtSO/HH2Yg1EBABCm
	pIkro4DyciGybtSxZHpChprR4Ue7+PMcmeNqgw3TA5l4irqTyego5QG0rd8IFdDaSCL
	Y4RQ+WBd8ed5ip0dkUtd5Huk5ZPWu7FmyxUUdawi8ENDaOJ6rUjUdvTjLLg2GpKoqK1
	0Scw1bhxHw==
Received: by smtp.mailfence.com with ESMTPSA ; Wed, 4 Feb 2026 21:27:12 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>
Subject: [PATCH v5 nf-next 3/3] netfilter: nft_quota: use atomic64_xchg for reset
Date: Wed,  4 Feb 2026 14:26:38 -0600
Message-ID: <20260204202639.497235-4-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260204202639.497235-1-brianwitte@mailfence.com>
References: <20260204202639.497235-1-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

Use atomic64_xchg() to atomically read and zero the consumed value
on reset, which is simpler than the previous read+sub pattern and
doesn't require spinlock protection.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
---
 net/netfilter/nft_quota.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index df0798da2329..34c77c872f79 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -140,11 +140,14 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	u64 consumed, consumed_cap, quota;
 	u32 flags = priv->flags;
 
-	/* Since we inconditionally increment consumed quota for each packet
+	/* Since we unconditionally increment consumed quota for each packet
 	 * that we see, don't go over the quota boundary in what we send to
 	 * userspace.
 	 */
-	consumed = atomic64_read(priv->consumed);
+	if (reset)
+		consumed = atomic64_xchg(priv->consumed, 0);
+	else
+		consumed = atomic64_read(priv->consumed);
 	quota = atomic64_read(&priv->quota);
 	if (consumed >= quota) {
 		consumed_cap = quota;
@@ -160,10 +163,9 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	    nla_put_be32(skb, NFTA_QUOTA_FLAGS, htonl(flags)))
 		goto nla_put_failure;
 
-	if (reset) {
-		atomic64_sub(consumed, priv->consumed);
+	if (reset)
 		clear_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags);
-	}
+
 	return 0;
 
 nla_put_failure:
-- 
2.47.3

