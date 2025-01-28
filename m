Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6BE85270
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 12:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738066832; cv=none; b=NzyRJb6p4jlb6KMMrMGupqgSGVmgVnugVfw1IiRnwxFj4f6tLxT7ZT2q3VGYjQC+JHE7ADI5JwG0ByjvLrNVpUHFA3Oue6M/yaMJy5UaIWtxj/42ZA44K6AsZg5LzpBxFdVk1DBlLm3Vkmcpj0AhWlsIS8K4YPOFi+d7rsjPoHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738066832; c=relaxed/simple;
	bh=5qiHJyPFUHs3MRPJ2QS6KmZDxbqVJEKJ587XM4extLE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=mYO67cKLOYbIGrUmx4nfN+uQYIb/GwD0Bacu2XOTRrs+3Ordx/HSt8sQDz/wvIPJ0y4bi8jGfWgM4NrLfw42ftEXMmgAeU761OJk4oZi1GXXNPDW8rm9vjmyqAlLPjOXkaCFVxN4fF15gCNXYD1K2QGFpi4UK3xqNJcEzz1ERqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kT52+ZG6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kT52+ZG6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kT52+ZG6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kT52+ZG6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C166E60286; Tue, 28 Jan 2025 13:20:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738066826;
	bh=7jF82tQ9D8nS8G9VXLOWk9/kruewc170JBxRgDGLD9s=;
	h=From:To:Subject:Date:From;
	b=kT52+ZG6PywsL4a275wb2e/d5gxICVKTUAJ2ifwqDRiivZ9gLb+5KJ+aiCKLSS6C5
	 gsiOsnPk0Tu8Sqm35PhEh1sAYMQFilTa1XAmyl4WbjJdOL0xhEuK3nxCp0QXythGKL
	 91vnkSTORea8UU15ILNtaZot7ylc6P5sQ0QJhd5jkjKFZBc8My+AYKnmpVmP3BNiPw
	 M92/Iju0tzOrAjJY+pzfFdHEtI+iGY7q7MKtrngkJnDduxlqu9Zy0JaxnY/DL26f7V
	 w/weQySRYYUfCdBy1IaPdjutsn3ahMkDE2xPkfj0wKgciNzEhUydJrTfk6PR9r/beD
	 2hCNsCp5ZwfSQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 66BF660284
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 13:20:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738066826;
	bh=7jF82tQ9D8nS8G9VXLOWk9/kruewc170JBxRgDGLD9s=;
	h=From:To:Subject:Date:From;
	b=kT52+ZG6PywsL4a275wb2e/d5gxICVKTUAJ2ifwqDRiivZ9gLb+5KJ+aiCKLSS6C5
	 gsiOsnPk0Tu8Sqm35PhEh1sAYMQFilTa1XAmyl4WbjJdOL0xhEuK3nxCp0QXythGKL
	 91vnkSTORea8UU15ILNtaZot7ylc6P5sQ0QJhd5jkjKFZBc8My+AYKnmpVmP3BNiPw
	 M92/Iju0tzOrAjJY+pzfFdHEtI+iGY7q7MKtrngkJnDduxlqu9Zy0JaxnY/DL26f7V
	 w/weQySRYYUfCdBy1IaPdjutsn3ahMkDE2xPkfj0wKgciNzEhUydJrTfk6PR9r/beD
	 2hCNsCp5ZwfSQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nf_tables: reject mismatching sum of field_len with set key length
Date: Tue, 28 Jan 2025 13:20:21 +0100
Message-Id: <20250128122021.2104-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The field length description provides the length of each separated key
field in the concatenation, each field gets rounded up to 32-bits to
calculate the pipapo rule width from pipapo_init(). The set key length
provides the total size of the key aligned to 32-bits.

Register-based arithmetics still allows for combining mismatching set
key length and field length description, eg. set key length 10 and field
description [ 5, 4 ] leading to pipapo width of 12.

Fixes: 3ce67e3793f4 ("netfilter: nf_tables: do not allow mismatch field size and set key length")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: reject inconsistent input from nft_set_desc_concat() instead of pipapo_init()
    based on Florian's feedback.

 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c4af283356e7..e5662dc087c8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5065,7 +5065,7 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
-	u32 num_regs = 0, key_num_regs = 0;
+	u32 len = 0, num_regs;
 	struct nlattr *attr;
 	int rem, err, i;
 
@@ -5079,12 +5079,12 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
 	}
 
 	for (i = 0; i < desc->field_count; i++)
-		num_regs += DIV_ROUND_UP(desc->field_len[i], sizeof(u32));
+		len += round_up(desc->field_len[i], sizeof(u32));
 
-	key_num_regs = DIV_ROUND_UP(desc->klen, sizeof(u32));
-	if (key_num_regs != num_regs)
+	if (len != desc->klen)
 		return -EINVAL;
 
+	num_regs = DIV_ROUND_UP(desc->klen, sizeof(u32));
 	if (num_regs > NFT_REG32_COUNT)
 		return -E2BIG;
 
-- 
2.30.2

