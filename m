Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140462309B2
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 04:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779942419; cv=none; b=KscSe4K2nZqopah7r64tAly2XGiqwtahOvrkQJmfs5YVA6xtVq/RrHu5xdGht9yzTKqjjt+qXrKmxcMvBOfWRLFtWf/bGsUUNH4dlmu4XXmcDQD7m6VAN+PP1XECHozzndMtNbTz7eJiQKZM2jR7D7veAuYbHUlfPFYvqYFgono=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779942419; c=relaxed/simple;
	bh=gTB8MKUp15vZOuCVVyd/Ui21m+TcfXi9Qj7NSTAMDgA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=IZUKFrjN/YL42h2z6rVLASXA8lvYuE2ttrpmT6/UvThxI0c07VIFWgh7gFb2q4Nn8Vfp1asd840r39j99bnHGkncVLwRYwPpwZyLCqPSW03oqJZNzLrwJN9D3LzcPwjmCMA4Wzwbq4BfLBbrBlydsKFhOs9k9e4GOzrfeaM/MK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EXroJBaM; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EXroJBaM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779942415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oFg7fGCRxpBqudZ1bVGqhfLcy1qpEnXB43NXXpgiCMI=;
	b=EXroJBaMU4Y6dh3S4O24LIaJxjr22P78YnxlQfsG4C7JTOrPevtvJp63UmxYFfm9Rn2xLw
	9m5pXhl/Hu46ixi0BEZy6DiowAaQk4KnitF9XNcnI4yOdtJt4cenrWJrWRUFFsupwl52cN
	rKCu/MHRSHjJ+bWJiusTFqls5IWPY3M=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_ct: fix OOB in NFT_CT_SRC/DST eval
Date: Thu, 28 May 2026 12:26:20 +0800
Message-ID: <20260528042620.263828-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I noticed this issue while looking at a historic syzbot report [1].

syzbot forces dreg[19] to be used as the storage for the ipv4 address,
together with a raw priority chain, which makes nf_ct_l3num(ct) be 0
so that 16 bytes get copied into dreg[19]. Even when the dreg is not
[19], the same larger-than-expected copy can clobber other regs.

I am not sure whether there are other paths; here we add a check to
fix the deprecated NFT_CT_SRC and NFT_CT_DST branches.

[1]: https://syzkaller.appspot.com/bug?id=389cf09cb72926114fce90dc85a2c3231dcb647c

Fixes: 45d9bcda21f4 ("netfilter: nf_tables: validate len in nft_validate_data_load()")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 net/netfilter/nft_ct.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index fa2cc556331c..813467de1479 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -61,6 +61,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	const struct nf_conntrack_tuple *tuple;
 	const struct nf_conntrack_helper *helper;
 	unsigned int state;
+	u8 addr_len;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
 
@@ -178,14 +179,17 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	}
 
 	tuple = &ct->tuplehash[priv->dir].tuple;
+	addr_len = nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16;
 	switch (priv->key) {
 	case NFT_CT_SRC:
-		memcpy(dest, tuple->src.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		if (priv->len != addr_len)
+			goto err;
+		memcpy(dest, tuple->src.u3.all, addr_len);
 		return;
 	case NFT_CT_DST:
-		memcpy(dest, tuple->dst.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		if (priv->len != addr_len)
+			goto err;
+		memcpy(dest, tuple->dst.u3.all, addr_len);
 		return;
 	case NFT_CT_PROTO_SRC:
 		nft_reg_store16(dest, (__force u16)tuple->src.u.all);
-- 
2.43.0

