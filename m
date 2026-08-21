Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BB836896D;
	Fri, 21 Aug 2026 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326756; cv=none; b=jvZK9ODtqbED9dOQGxre9duC029ovhQn3jsT5PxwAWIcwn+h0wX3PX/2HQEwFe6XpBEgr41rxq/in6Wca+EyBaWiGBhBZlHRJN5deauKclDfMTgDFu01YVdnWl43RV0jNCbQgDldrOOBsuFxMEx0NAdOnQtg4G+xO2pCGm8KZk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326756; c=relaxed/simple;
	bh=3mNveH24JBGypCJrCVklJmEi6cTSuGAMD0imu/ESO+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFej8JS+2SY3tWpeJVQi1uUD652uXucNyWxAheRfHpmuhTQwBVEZ/jnccOUIRZwLSwr/tW7biWaNOtdooTiEbdC2KNdHZShlODNYS+X1rWoVOzQn3GOJVQDLNQn00EIsynYj8YLfIsYLMYWLhcFq03z92C3hYILKBDXBNOgw86A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dvDntc6U; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dvDntc6U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787326751;
	bh=4qqhL1YOOTnBhsZaw58FbRJsHj1rXZBcjFtNjJVHoOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvDntc6UukW6eByh/UgtgxjdrW1OeGDHIrGXcOLtIJZSPwWmDlgK0w7LkM7z8wJZl
	 aahbDJM2l3UL9QserLnR+A2pSYBSvkGMSpE8LX9hbIaXipfuFONawjhkuiEj6xN0Oq
	 3u3UkVvx65oPz+TuOOOVE2bjgHq1EmQqsrk5nWhqTK2SPzEJmWUz4Alb4PCLL75nBq
	 pxPYkZe9J2+zQnsmQjV91LPM++77Xl3xgw7f7UvHosr3ZqUk3U8LVfB1ra7LrDYGHi
	 gYE5SkxjeSCliEpJIYd6qnLx5tAhls1ccbTcd3cBdIwW6Dsp0ZA3+0ejxK3lyXjazH
	 SdJHwD26k+Dtg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 049B160056;
	Fri, 21 Aug 2026 17:39:10 +0200 (CEST)
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
Subject: [PATCH net 09/10] netfilter: nf_tables: set on dead bit when performing early element removal
Date: Fri, 21 Aug 2026 17:38:32 +0200
Message-ID: <20260821153833.245589-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821153833.245589-1-pablo@netfilter.org>
References: <20260821153833.245589-1-pablo@netfilter.org>
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
index d160f6ea0dc2..4f3be3b10f2f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10877,6 +10877,10 @@ static void nft_set_commit_update(struct nft_ctx *ctx,
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

