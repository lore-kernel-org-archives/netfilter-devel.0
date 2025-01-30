Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A69F1AB507;
	Thu, 30 Jan 2025 11:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738236810; cv=none; b=WkcknEuLFFxwhjvxPoCXhLFsa9gBQSrAEZRknnnspV1e9JlhBOtJQ9RGCWihcTjzsqO4sYlLK2dy+q/ri97Hzxa+Xf9LDAXQcUKtf3/1XA/JsAZyPHls4Jq3972ZOBVp6WiUAxzgMu2lfqQdGYolYZDCZ20e5yXRCmc7i/fAVIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738236810; c=relaxed/simple;
	bh=cCvyuTywZJOEZd43eSucenVCDBaHeiJEy2+zxsJJOfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MUn4arZZ8ts1nmobVBtbT72L5rTfIP77DLq6sUQpg6ZlPDBNlYqPyPnZrPqlalJdKL/LClLYcmlj5ovnVUzdBV8HsH4SFtRgZR8ReFfSXvOwb4AP66Ir4nM+k5CbOBvlcP7oYafH34vIpgvGwGhduFhzy2C9w2tmEMFbozGRAUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TGGRc7QQ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PB7HjeOm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TGGRc7QQ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PB7HjeOm"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 78BD6602A0; Thu, 30 Jan 2025 12:33:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738236800;
	bh=UDpdvzehFZ6YWDrWZCL4eElqBT+MzmimR4sYE9a+lJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGGRc7QQbc+QWJJxBDd9IZI5w7lZybuv7KDbLsM/rQo9/HnRahhlZlvo0TxkZjKsm
	 AK+w3UHqoyqsEtOsaltHjUPtny/QAvEQbhgkE2nyZYEUtHfJgC0ZKjEpEbuSJRlBEl
	 zW5XN6YGu9CsSoM9fu5p+vIak1PW/TAk1QKO3dXU+gL2BVvYOOTkc2Yu7ui3KA8BiZ
	 vIkUelldQdIYaWJXWAnPvSKWuAb/Rb17xTrYYbx8ICbLyVsbtOvw8kh1zfEzwblM58
	 JRlAMFhcqpS8mWdXWMn91yfulkbR+s3mMIiCr43gHjPzpdZEQ1QuBFTERDc8huj6XD
	 xxJXrKKxXyVDw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B9E0660297;
	Thu, 30 Jan 2025 12:33:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738236799;
	bh=UDpdvzehFZ6YWDrWZCL4eElqBT+MzmimR4sYE9a+lJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PB7HjeOmou3O34rnnn2gJ/BJH3yth2uA9xn+9NOOgA9UMm8Ml8tdG9X+z9mEee4Nx
	 t2RfIcbtlL8akRxqnCryyLIcLKFqRWFTuW2MY4yRTn7JHDfFxXoalIht8dis4ITjVm
	 6P2AgCIexRSMNTzYLFq1/Rl7wQkd/5CjmyhLDPpQbjvGLdpgeMh33EG1Er9p3HTWpf
	 H1JvVT0rf3ab0TsH7SUF4Szka13U/hRbh8/BVyE0d6OeZZrq2fUst2OnaKMmZlLnlE
	 Hg1duPLqXWhSG/ZGK0Bqm1ZzDgPD9Nn8GAiniy2mKIOqvD/7sSsX7+11mPapn/9w5z
	 bvKdTyhvW7oUg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/1] netfilter: nf_tables: reject mismatching sum of field_len with set key length
Date: Thu, 30 Jan 2025 12:33:07 +0100
Message-Id: <20250130113307.2327470-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250130113307.2327470-1-pablo@netfilter.org>
References: <20250130113307.2327470-1-pablo@netfilter.org>
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

Cc: stable@vger.kernel.org
Fixes: 3ce67e3793f4 ("netfilter: nf_tables: do not allow mismatch field size and set key length")
Reported-by: Noam Rathaus <noamr@ssd-disclosure.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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

