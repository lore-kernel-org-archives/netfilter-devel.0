Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1773F335B5
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 19:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706556304; cv=none; b=ZIu7USlxKS1fbdCkIv9cm/+OQaygUnjxNT2yLHGz80kQJ7UgbpQ6o6gP7gZucftkM1feUstnUnPPKTKYBTwgrVCsQDFUhefq1G21EOU/LBzc5muh80IKKDr77RpTrNQ4iNJz9RXr4JtXPnB3j1mPHllozhI/IZ/tyJi6wLP8rjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706556304; c=relaxed/simple;
	bh=GjG6bOS/anVtVrE49CR832e1AKkxQAxzTgDJ1aTX/TQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=X66ZMYHWfMR7HtD7mNZBBvxSpKRYa11JGTFkJiSHB56OM85jd9lbNZCgSC3ZqB3fwrQH+orJqMhmOiwYTnnVv8YzfCu9yygbhKrnS6bcdfuf1An/fW9XfuhFVFuvd1yPfzRL0ouppkY7Ecpulm806jnJafEFa07XEzJZR0F7Qcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nft_osf: simplify init path
Date: Mon, 29 Jan 2024 20:24:57 +0100
Message-Id: <20240129192457.148381-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove useless branch to check for errors in nft_parse_register_store().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_osf.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 7f61506e5b44..a2fe71fbafcf 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -83,13 +83,9 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 		priv->flags = flags;
 	}
 
-	err = nft_parse_register_store(ctx, tb[NFTA_OSF_DREG], &priv->dreg,
-				       NULL, NFT_DATA_VALUE,
-				       NFT_OSF_MAXGENRELEN);
-	if (err < 0)
-		return err;
-
-	return 0;
+	return nft_parse_register_store(ctx, tb[NFTA_OSF_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE,
+					NFT_OSF_MAXGENRELEN);
 }
 
 static int nft_osf_dump(struct sk_buff *skb,
-- 
2.30.2

