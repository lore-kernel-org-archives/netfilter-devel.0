Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B783277016;
	Thu, 10 Apr 2025 10:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744281418; cv=none; b=h7YE/YFi2BDpCJyJrXvwo+aF+MepzHhR9192TA8HXBBouS3AKbUzoABp9lSlsjbM2/n9H/+KSLAbk/IKgQOLx5m5YEBD4YAblaw8ecrv74APmVFdY4mS0lsW/HjzoHmbLHSTljgfcFsKBgjlFdlYR03u+NmMLWyFor16tJLq1Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744281418; c=relaxed/simple;
	bh=ExCyK2fBqq/zLToa5rN3ial/lijiBIUoOVrGqdEyJFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NMwTMcpNi6FRxv7lgO2kCwTfpSsSs+Yvm4OjdiDoFevu10DyjEAECy2K7SkHeuHzBKcjGQ7+LzqgJAAg8DkNlLF7rfKNsvYY20sYwQ1pAVjxK7L8gWHZ4ApWS4TdL7H5yz6H88O28PLjY5N+ScewFw/LMn6u0RKgjgD91w3ZP4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O3Hww9n6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GXq3ApXC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O3Hww9n6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GXq3ApXC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C4B77606BC; Thu, 10 Apr 2025 12:36:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744281413;
	bh=KXwrG12LCSU/qTyJBT24T9O+fpohmUtgKUoqFWR1LjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3Hww9n62F3ST8/CI2blVn/7Flh/HJoc7V7d6FAzdJ0ZM4OsnBneVryHpwvlKmwxF
	 S2589FcNc+vT2XrwrbROEELr+ASpWP4WrlmVcmNpsfrztl9Gqc7DdweyTl1aG02eqm
	 YtbjDeb2kO9eDVU0+lZx+vW0r4t51O0aIFiUAkJJjvbyjeUPabQ3yfjLqdqK+9BEWO
	 cuIV68xuDA+Vjtfsgr7cteXyBpuPylXZKGwPB8cAejKevNvptKahOpg/7Cr0FLxemk
	 0dCNx/tSGhGBrzRGTs8rNCca1k+6e+Pje6FiPpfkFDrvLQXJ3HMy6T97IYbB0Hr6Te
	 O3VY4B1n8rtZA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1C07E606AC;
	Thu, 10 Apr 2025 12:36:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744281412;
	bh=KXwrG12LCSU/qTyJBT24T9O+fpohmUtgKUoqFWR1LjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXq3ApXCl0GOMiKDf0DK+1TEQ063NuGgBzh/jnvG1ofC4zML7OPHl6yV/qWUL4oXg
	 wUSqnUZLAufeX5eanGlKNpME7/tw0dvs+iCldwzXc6he7nhQkDruE+yeymVBXdFMs4
	 hqqotXqd5iK3vZVuKx9M2iYXk36gnuu2irnu43Dq8p+KC8H9oz0nq0wxALPkCmKuC1
	 yqv1gMr+pD6EkkIzg9/cU9RtsP+QGkUidqlZ2y5DMpujSX1Jw78AbqQSbiId+xx6s7
	 Kt9C7yYD/GvkLZlrrC6p5zyO3fKTE/2bE0E173J+rEfMU8yZff3LfgsYGfS3P5EYWx
	 us2cx7w09Xknw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/2] nft_set_pipapo: fix incorrect avx2 match of 5th field octet
Date: Thu, 10 Apr 2025 12:36:46 +0200
Message-Id: <20250410103647.1030244-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250410103647.1030244-1-pablo@netfilter.org>
References: <20250410103647.1030244-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Given a set element like:

	icmpv6 . dead:beef:00ff::1

The value of 'ff' is irrelevant, any address will be matched
as long as the other octets are the same.

This is because of too-early register clobbering:
ymm7 is reloaded with new packet data (pkt[9])  but it still holds data
of an earlier load that wasn't processed yet.

The existing tests in nft_concat_range.sh selftests do exercise this code
path, but do not trigger incorrect matching due to the network prefix
limitation.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Reported-by: sontu mazumdar <sontu21@gmail.com>
Closes: https://lore.kernel.org/netfilter/CANgxkqwnMH7fXra+VUfODT-8+qFLgskq3set1cAzqqJaV4iEZg@mail.gmail.com/T/#t
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index b8d3c3213efe..c15db28c5ebc 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -994,8 +994,9 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(5, lt,  8,  pkt[8], bsize);
 
 		NFT_PIPAPO_AVX2_AND(6, 2, 3);
+		NFT_PIPAPO_AVX2_AND(3, 4, 7);
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(7, lt,  9,  pkt[9], bsize);
-		NFT_PIPAPO_AVX2_AND(0, 4, 5);
+		NFT_PIPAPO_AVX2_AND(0, 3, 5);
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(1, lt, 10, pkt[10], bsize);
 		NFT_PIPAPO_AVX2_AND(2, 6, 7);
 		NFT_PIPAPO_AVX2_BUCKET_LOAD8(3, lt, 11, pkt[11], bsize);
-- 
2.30.2

