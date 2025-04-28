Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FAA21322F;
	Mon, 28 Apr 2025 22:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745878402; cv=none; b=qJ1IZ90lnqxLIlxE+gVPEXOcfCNO2UvO6xri9E2mGB+R8JYyvxRa7nfnrc9Vb4k5VPxKIDQ6fjsgoyJISIxh9tJiI3fSAiRrY30BW2fZ28psRG2qMqLZQJmM5n5vuuveH+xEyFH+hVWiNv4u5tEmJeR7JYvpQwOF+Hc6kkKy7m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745878402; c=relaxed/simple;
	bh=fOzYwC+1kSuSFJXf1RmjiSpsBTH2v9g6dBB9rqLB7Yw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V1ZVgbNgrDG6paGShfMKxO7wUYNyOe3MTulOXtHVg/uOLKxD5PNBWYEdz5+gyNFWhzuNfXHzI3g2w5Ws8y6gcEwaYparwtT3i51dDE8vRwPDsXLF6kNUyXaLUC5KpVwsehpA+jko0e2cLd78Yg7dlY2FlV0yBGgCBzvSSMcCE5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vbqEBgzm; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=k7xkhLP2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vbqEBgzm";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="k7xkhLP2"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8055D6064C; Tue, 29 Apr 2025 00:13:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878398;
	bh=W2iPd5dcyQ8M4ppe67DmJVGFeHbT03yeWlCC/k3bkts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbqEBgzmP3XnRBPVMsT/xJLbzdhNGMfS5H7pXqHtRq4BN2HsfAl98j65kcoHBlbAE
	 uMjNLdLz8mED4pbbSq125XcD9gPbq0B1m/dYXQA7LuzRkVwPBFweuNzGXqwm14Oge1
	 n4xYjym3jtjBPfLwD2DeuPGF6gze55ohSbVG6PbyYyWK0H9qrmWyehGbeKAyCYRDU/
	 Kn0+kNOBHei6LYJWDNbYdxjIHP2j/bxzE0lgXTgx0mUUUN7SFVyONEglmY3raea7B9
	 tH4xtkhHfHsPAehd3ihAeFcT1Rmg38Cqadbb3mULeq1BtlqAkiErYypjqYueZ2+5XS
	 Y17b6R/uGzDCQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BBD5460549;
	Tue, 29 Apr 2025 00:13:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878395;
	bh=W2iPd5dcyQ8M4ppe67DmJVGFeHbT03yeWlCC/k3bkts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7xkhLP2efHvmivHJoXYcxsjXqQDhDGMULU4SNBPl/GGcMvWtaD/OKlhNwpQc6Ncw
	 MQtU73Q++rYgoaLI6/RW0hpwizzU5VyKF0RoNq67QSPYVx/zAxzqcodHwQPsDvspW9
	 QrvSwWzwG6kp3WFLI/wZviV26icFI5lrStf9HuB+9pMbl+yyboVzgV8XKhrlktiVl9
	 BjzEfRhrvVqMlooy7zfXIc05xMz6bJ7dOc/DQzzon3qvf2LwQfEDfq/enM15hG2VuC
	 oFsQO/4uflvbFqy6Uzx8KAMD7BhrglMoOX8Ja/rZcB4XrXOt52KfmSkEkWXVsuBPXR
	 6OUkVdxS7SpHg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 4/6] netfilter: conntrack: Remove redundant NFCT_ALIGN call
Date: Tue, 29 Apr 2025 00:12:52 +0200
Message-Id: <20250428221254.3853-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250428221254.3853-1-pablo@netfilter.org>
References: <20250428221254.3853-1-pablo@netfilter.org>
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

