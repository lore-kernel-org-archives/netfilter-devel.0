Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294C5218ADD
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743460598; cv=none; b=u/znqBiKVIaTrcVp5w+sPyvVs8cDYXBpgxPOohAVEB6WdsBSIw/+vKObPrrZl12S2ZEzeWQuPBTCUXYrapfNsbdHtKjUMgATXnoUABHslB+9xOsYfiD2njd+VeFQm2tqoao+vibrRHbEgyhYcNbw65Eky0TkvFPyjPfZyptGueg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743460598; c=relaxed/simple;
	bh=zXS6522BQ+GAfllW2yQfWzw89hrKyagB54ip3HTZE5A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dw0PGm9hIrWnXKxkC171y/gPkXCz53u+4d8lARvlDMQdnQviagVMud2ST+cJ9L/L9NR8nt3j82n/4TECdzH1A9m9iGSamR0AiYVLd3z6Y4W++9pcx3xgg0MHr9C3TWNRu52JE20+KEM+97tNUMcqmr8ZWNYr3EzUcSnpXk2K+s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bI9beu/f; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iaa/scJk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bI9beu/f";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iaa/scJk"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 07D6060389; Tue,  1 Apr 2025 00:36:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743460592;
	bh=/BoqFHYUqliljFUKwAJ0I3CyD43VyDAFczgd16D+390=;
	h=From:To:Cc:Subject:Date:From;
	b=bI9beu/fLe/OeA17T80+DymFduV074AENL6gnjIbmFqZQBIpmAJVQzQoTgf08L0BB
	 SkwgCakHpfiozVS0+O3CjTZnUTO3OwXkyGVdZwakU+xc733ZZ0yM/TJ/e16chlwJI/
	 kZESb23jDjRtfujiUULUE20NGFaizoVDnP9MzCu+2LiK8hcR6sNKM4MwMBNR4ZrPcG
	 xnj+Ipf8G6E/AofNJhOQ+JMrbpCbDXbK9z6fW+ia2ir3H7pIG5klIKvI4w7thpv0NA
	 vy463JzkW5uIMuAYKIiX6elR5anigI/31tlaQogm0mBbR5OzthOygHJjqGJ0Lg3/aG
	 PDYt7P1xibJ2g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 704E56037D;
	Tue,  1 Apr 2025 00:36:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743460591;
	bh=/BoqFHYUqliljFUKwAJ0I3CyD43VyDAFczgd16D+390=;
	h=From:To:Cc:Subject:Date:From;
	b=iaa/scJkWJZdm20OenKz+NYx3jzjtSoVE22LB9gqgaEks5Q0jX5LEL4LkCvyUbWWa
	 ZTQeYX9mzGsj35Yz2IzQe4y7svpb2xoW77+xxjcAvKWgrxvS2VqKDyyTxbGT+7zB9o
	 1CZduSS7hT5uKpYm/gnJuMkhfdTs2crcpJGsEw8Mmn+Vgk/bs5L20CGBH9a+z2s/0E
	 zEQOCv5pcTQDnjQK/LU54gNnHOsmufWtCfAQXI/gXOuR85oGInUnqttv2UEamRj2tG
	 u8JDAG79m/tCJHbf/vRAAUupJrBSA4o3g1+wRm1xjcHiDPRq6wMxYmCRLCxt22kMMN
	 Z8s9nXKh9XTDg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] expression: incorrect assert() list_expr_to_binop
Date: Tue,  1 Apr 2025 00:36:27 +0200
Message-Id: <20250331223627.931508-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

assert() logic is reversed, all expressions in the list are handled,
including the first.

  src/expression.c:1285: list_expr_to_binop: Assertion `first' failed.

Fixes: 53d6bb992445 ("expression: initialize list of expression to silence gcc compile warning")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index 228754fc2067..cc693b10d759 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1282,7 +1282,7 @@ struct expr *list_expr_to_binop(struct expr *expr)
 		}
 	}
 	/* list with one single item only, this should not happen. */
-	assert(first);
+	assert(!first);
 
 	/* zap list expressions, they have been moved to binop expression. */
 	init_list_head(&expr->expressions);
-- 
2.30.2

