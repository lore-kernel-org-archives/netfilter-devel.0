Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5571C2777EE;
	Tue, 22 Apr 2025 20:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745353442; cv=none; b=b5z9V04lMuuJx37mrJicxvtgCzA1UBvWiqkCfqIHPWptQSwQE0gEfh+c4Jf/shxV1IdtIfeDrjxYAl9tFRD15ZupM5yHGPcyONGLjiLQ3omggf73LaUwOiNDakoBOWeg7v1gdmLE+7toNX81HBR/LEoSbM6zJyFUe5UTtEnLtdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745353442; c=relaxed/simple;
	bh=fOzYwC+1kSuSFJXf1RmjiSpsBTH2v9g6dBB9rqLB7Yw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qpJnA3FldeAdVob4BR/0W3Y92/+TV44yOSYCOStFN8hcq7QqRO9cKleQR4k6Km4qtBciro33l+s09aZyQ5Gm+2JCPKkLnEP4VjS7NwT8yu/1mW9jGMgM5fkut+jRiygFVnhIX9Jp9EuOW3Ti3Ve8BnN5DSG1ZTSGnnsuiLiD2+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rI7p3m2s; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Xp1rKSTp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rI7p3m2s";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Xp1rKSTp"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0F486609CE; Tue, 22 Apr 2025 22:23:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353439;
	bh=W2iPd5dcyQ8M4ppe67DmJVGFeHbT03yeWlCC/k3bkts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rI7p3m2sqGwzR5w3n3+2q5fwVG+TWqSLQJG0dbU2NRDIhIBpSquXrzoC+gjV4gVKD
	 lmyxb1oPXVfsocjEP9h+iCzTlTcM32AoJUxc5tG97uaQuGtIWbgLnGCfOm1AvsfeHg
	 GV2EXcFk+UpAltr6pg/q3ZgigWFn0+BEfX9YzyQhCoVjFBSMaXRbTwm418epZ+Vd7s
	 tqhUrgQrOt78C7I9DgAGKkHSoaXrvWkbSyqic1ynpeWVKUxbLlXNYhIfhfFxCLHr1v
	 s+Q2AvTfYV5WeBdw2bReuhlycD5g9zLk75rlFktC6LY+YWyeCkMEAWmGMsK0L08Kia
	 GLZ+iWNvF2DKw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1AD6E609C4;
	Tue, 22 Apr 2025 22:23:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353432;
	bh=W2iPd5dcyQ8M4ppe67DmJVGFeHbT03yeWlCC/k3bkts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xp1rKSTpOGRQONpvXTkHBTTqMvbRh9DCew0vR0OZC6astuKvhDRUMMJXtyr6VVlnX
	 Cwk3rsg2n0fDGhzr9We7fIJs/Wt5OMNpxe0TT168pW37zkHpXLelULVb4B89X96/18
	 /oEf/1/fnq4Oem7foELy5cFe2XTcJx/+dVP8DueJK2tcHsY4cyhXfXCs/4ReHceV1H
	 UFtysVb0Y4FenrmO0tDOYA60igveQt2EfD6McqpPEsVbNajokEzk1FJtD7IzsvN8Dp
	 NZhbNDC5cCHblADkGpSanzMcgjIg2YxQN0PsYgc2LntG9gFxvxfJYEQYH4WzJsIZNn
	 2rFZfyqPvYv0A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 5/7] netfilter: conntrack: Remove redundant NFCT_ALIGN call
Date: Tue, 22 Apr 2025 22:23:25 +0200
Message-Id: <20250422202327.271536-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250422202327.271536-1-pablo@netfilter.org>
References: <20250422202327.271536-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

The "nf_ct_tmpl_alloc" function had a redundant call to "NFCT_ALIGN" when
aligning the pointer "p". Since "NFCT_ALIGN" always gives the same result
for the same input.

Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7f8b245e287a..de8d50af9b5b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -531,10 +531,8 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 
 		p = tmpl;
 		tmpl = (struct nf_conn *)NFCT_ALIGN((unsigned long)p);
-		if (tmpl != p) {
-			tmpl = (struct nf_conn *)NFCT_ALIGN((unsigned long)p);
+		if (tmpl != p)
 			tmpl->proto.tmpl_padto = (char *)tmpl - (char *)p;
-		}
 	} else {
 		tmpl = kzalloc(sizeof(*tmpl), flags);
 		if (!tmpl)
-- 
2.30.2

