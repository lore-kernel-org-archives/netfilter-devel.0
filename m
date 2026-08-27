Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0E147798A;
	Thu, 27 Aug 2026 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840274; cv=none; b=bi6Zrb1tKGSQ1mLW14jzUN5ENrqPRAArOgNBbLAuP6Nkjvu55nrrsGupxGBH/ClHPraOe1qZ4VuNu3OqpPS2D5mqjInQw7UTrVbUIXwzOZs8SFG+QZnCqwwQz6sUY2iXN6cTRzydR/Jl/QilXczzzBT4i+8nqoHhM4WahtWcn4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840274; c=relaxed/simple;
	bh=NVIIbPeKQWkq9gHiV7NfHTv6+4KKV0Rw/4IByq3Bl8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4OFPBz0Rjeb6tHAK1kRm1X/HLq2gDG2XXnjK1SBvhxP7aQW6QMIED0xvBe4mxpZ55d8ZLngR36e+xwlAQqg5SVzG7RccNTtZQx4Q77TvO3XtvxFZR5EgeuTS+oW3F9NmM82iqhIA+VmxPTCcCcdseYTFQxJg1JBEmWUWNGhSA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NiG4y0w+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NiG4y0w+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787840270;
	bh=6/aCHjOvZMEJl36P+vZae9HN5SCf8rcNyiTwotbeSx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiG4y0w+wTJ1DJgBbU/AnVDLi11dqauAFJNStkbBWTyFLU5PiZuGDsbxJjS8+53Xq
	 AyW8IaPbMG668rqZeR/u6KMJ3nmhFV3KU9OcnPfPxhpwJWjHOXhtgVuIAJVPWgUW/m
	 PSmjPkbKc3m/CaLVj2/WMCGU9Ix3jDp1OxCp0NTGyUPK/9wmdJRnPVyxK+f+beqszU
	 9DLoHTgHbYl440/4baVKpG3iVgtrv+C987PpkVcux1Ye77MJmNgH0xZxUREofXAUa/
	 NYwIWR7mrUw4WN8BGQvkdO1bpYB6lfHJNoKgTInwifaeMOC4T8u8U8Yf2zNVDRuN+Z
	 y+K2Dp8R1m3tA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 21D376008F;
	Thu, 27 Aug 2026 16:17:50 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 8/9] netfilter: nf_tables: set on dead bit when performing early element removal
Date: Thu, 27 Aug 2026 16:17:32 +0200
Message-ID: <20260827141733.423453-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827141733.423453-1-pablo@netfilter.org>
References: <20260827141733.423453-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

.commit call for sets is skipped if set->dead flag is set on, but this
flag is set on later in the commit path.

This also reintroduces the bug fixed in commit 7315dc1e122c8
("netfilter: nf_tables: skip set commit for deleted/destroyed sets").

Fixes: 1e3b9e1c77fe ("netfilter: nf_tables: call set ops .commit when building new ruleset blob")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 20c562174b27..9b776f402d14 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10874,6 +10874,10 @@ static void nft_set_commit_update(struct nft_ctx *ctx,
 		nft_ctx_update(ctx, trans);
 
 		switch (trans->msg_type) {
+		case NFT_MSG_DELSET:
+		case NFT_MSG_DESTROYSET:
+			nft_trans_set(trans)->dead = 1;
+			break;
 		case NFT_MSG_DELSETELEM:
 			te = nft_trans_container_elem(trans);
 			if (!te->set->ops->commit)
-- 
2.47.3

