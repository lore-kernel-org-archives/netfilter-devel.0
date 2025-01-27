Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554B5194137
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jan 2025 23:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738021761; cv=none; b=dUUvxk57bP85m0UdnzNz9LKSMo7zcD6IU/kN2LNIk50YY4KQf7vG/GS9fU3gahb6xIb13uVG7qZTJEs3I8Grgb2WMzaec/W6XvkyOeDqoCjX75jOjUCk2RJM1ICJhnvxZL8VBBUWobHjrokuW1IUZ1DTDNbhK+oFdm6+eSE+Bhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738021761; c=relaxed/simple;
	bh=qVvkFCYJHLtvaXZKG5KRbt7ZackyZUP56QPXetYm2Ck=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=qUf5p7m8S8H35/l6yOQfnEgT+J/Sq+Doi+UWbc7gu4NVeCEJK0nfgi6bovcwsUqZlstPk+5Y1r02SzZDjVjvMsj3hOy2T4VQTD6KP8o3sbvXZaIigYDkDWyOcW96zsoAJqWRUAkh1G32tx9MSx/Wt1vf2htwVHb+hB6U2ZYrtDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UPCVgkV4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UPCVgkV4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UPCVgkV4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UPCVgkV4"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EE7D4602E1; Tue, 28 Jan 2025 00:49:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738021748;
	bh=SshsGsi80Ncg2kybfgfQsZXNFvKYHkLJ5zgn+OyIKkg=;
	h=From:To:Subject:Date:From;
	b=UPCVgkV41kKZZPJ8Kb3GgpeTOFTotlyqXagS2q4t19B/f0MUWlCfgKSmt4ydHwjby
	 rukxMi4HC6gwncQVp8JbPKD+KRNAaNZMIoAn4feykMV8FmoZegNZ1NJCYSaWsLcBri
	 THdZRIV9fLH9zeCzMQ4+lkEcJS1SxcCA7vrrNtg/Kib18580HJpYGAnwYj3bU57bhP
	 ZGl32dsXiKocHyN4j14EvILnrTBgOIm93oRWKvO2Vk4k8GdwsHJ/btiA0PbQArkjHR
	 ZyXOF5UHYzKcB+9hnrnTCPVJe2rl+dpbkUQwE+3de9jruT1FxDVZM+EdYk+Bslds2c
	 kjhaCfdx69Y3g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 96F8E602DF
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 00:49:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738021748;
	bh=SshsGsi80Ncg2kybfgfQsZXNFvKYHkLJ5zgn+OyIKkg=;
	h=From:To:Subject:Date:From;
	b=UPCVgkV41kKZZPJ8Kb3GgpeTOFTotlyqXagS2q4t19B/f0MUWlCfgKSmt4ydHwjby
	 rukxMi4HC6gwncQVp8JbPKD+KRNAaNZMIoAn4feykMV8FmoZegNZ1NJCYSaWsLcBri
	 THdZRIV9fLH9zeCzMQ4+lkEcJS1SxcCA7vrrNtg/Kib18580HJpYGAnwYj3bU57bhP
	 ZGl32dsXiKocHyN4j14EvILnrTBgOIm93oRWKvO2Vk4k8GdwsHJ/btiA0PbQArkjHR
	 ZyXOF5UHYzKcB+9hnrnTCPVJe2rl+dpbkUQwE+3de9jruT1FxDVZM+EdYk+Bslds2c
	 kjhaCfdx69Y3g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_set_pipapo: reject mismatched sum of field_len with key length
Date: Tue, 28 Jan 2025 00:49:04 +0100
Message-Id: <20250127234904.407398-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The field length description provides the length of each separated key
fields in the concatenation. The set key length provides the total size
of the key aligned to 32-bits for the pipapo set backend. Reject with
EINVAL if the field length description and set key length provided by
userspace are inconsistent.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7be342b495f5..3b1a53e68989 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2235,6 +2235,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 	struct nft_pipapo_match *m;
 	struct nft_pipapo_field *f;
 	int err, i, field_count;
+	unsigned int len = 0;
 
 	BUILD_BUG_ON(offsetof(struct nft_pipapo_elem, priv) != 0);
 
@@ -2246,6 +2247,12 @@ static int nft_pipapo_init(const struct nft_set *set,
 	if (field_count > NFT_PIPAPO_MAX_FIELDS)
 		return -EINVAL;
 
+	for (i = 0; i < field_count; i++)
+		len += round_up(desc->field_len[i], sizeof(u32));
+
+	if (len != set->klen)
+		return -EINVAL;
+
 	m = kmalloc(struct_size(m, f, field_count), GFP_KERNEL);
 	if (!m)
 		return -ENOMEM;
-- 
2.30.2

