Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6483FA5CF;
	Fri, 24 Apr 2026 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777057556; cv=none; b=WAJMquZJPoR+5NpU7WDd4m0U6NoPLPeyjl6fT482zXzkTWuKSUYVCLRKKm7C95UYApQ9Od0tpsDGEmHLQKiASauEAFX8nH8lCbtEyKzXfAJX7G7cfnlLuQhruYGGNiu5p+Okf3RFFSicXTSXpiS4Dd6mT0+32SdPJvwXSxKpXfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777057556; c=relaxed/simple;
	bh=5auVh159NgHYnY9KURAEEAM3LkKuat/4fjrsARva74g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+gwxq5YAE7FDKj0or5sSELxXKgCM7ly8dqKqD61mfR7VRF99jt33d+D48Z4Q0LAr1TwJ1YIMn8d8Rlk5B/KoFC4gUfpYvTOPsSaKjMdVjUHwNIHiueh5vZ/psNlg7ycjnZPJ8iozagEcbtdDaHQSx20v60XG4UDhv1Ab/bqlUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Mxp3wkU0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Mxp3wkU0"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C3A2560284;
	Fri, 24 Apr 2026 21:05:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777057553;
	bh=kvO4NiWkgz6Po7XmbFpN2ojH9hOJD7U1mcp/a6giG88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mxp3wkU09wdIEhKbv3xqGmr8WWckbK9o0hazTHE8qLlyyLdSBCfGM1Gm+Jhe7NYs0
	 5k5LZqCDBJoWDL4f2Z+eFm7EnzkralreC3f/U98l09e2o//65b4ClWIDFgge4yM7LQ
	 kmtVKIvAFc1X79TFvm+exEXIzkRkKMdvXUv2GLlltNnc/4i16+P/OtKBDwayNe+8l6
	 kwM300UqNxkurzipXqxe78DSV3gxuC7JGTf8huVlBQwOGSg0Ff5qrx6Ie23pkeePcu
	 +RxppTt2FHADe5vVyfe3kgbWXdx37JjCcMjUET/w2WwS3epKGzZo15ewZPS5nDxVqI
	 Kq0YL18svY/AQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 07/11] netfilter: reject zero shift in nft_bitwise
Date: Fri, 24 Apr 2026 21:05:09 +0200
Message-ID: <20260424190513.32823-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260424190513.32823-1-pablo@netfilter.org>
References: <20260424190513.32823-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Ma <k4729.23098@gmail.com>

Reject zero shift operands for nft_bitwise left and right shift
expressions during initialization.

The carry propagation logic computes the carry from the adjacent 32-bit
word using BITS_PER_TYPE(u32) - shift. A zero shift operand turns this
into a 32-bit shift, which is undefined behaviour.

Reject zero shift operands in the control plane, alongside the existing
check for values greater than or equal to 32, so malformed rules never
reach the packet path.

Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Kai Ma <k4729.23098@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 13808e9cd999..94dccdcfa06b 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -196,7 +196,8 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 	if (err < 0)
 		return err;
 
-	if (priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+	if (!priv->data.data[0] ||
+	    priv->data.data[0] >= BITS_PER_TYPE(u32)) {
 		nft_data_release(&priv->data, desc.type);
 		return -EINVAL;
 	}
-- 
2.47.3

