Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246AF23BF9C
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236067; cv=none; b=WexnPhCStrCSFJ7AaDwP96zh7zUevwj8EtqpJkncdzTGLHbqUoHUHVq8jS0GAvUJeWtK11Ia8cCfNiyrKypJT9yJwAnomOnzReU20t0aaEobnpyNx/Pjwn3eP8TQIKYVQR0ASoYieYizjdvMaZ0MmIunu9522/W5HF6eNkUsl/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236067; c=relaxed/simple;
	bh=quu9pIlJ0yB/nHBaiRsMJnLO7vnBI3JCIxNo9NLbTd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhnYexp4gBxgpwj/0LFL/onPxBJr5g3eP7Bw5vY8r6Yd+BDNOVxh/3WmAdLsdedci8vjqIRogIbjSPwkmuxtXdZQ6D70u8nkhTu814Q0HB0zfEuxZKKP8sKS3B6e0EX8Hmi+5SvJ6em1Yl7ymCrZ4rQLVefAfVGjAGgXmWDh4rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jr07JZqG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jr07JZqG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lRJDyxgANdg/tbMX/XRCLl5buVptovYFy2SItwuzaQk=; b=jr07JZqG00bQ2RiTyNKh9l7yC4
	Z57PI967HOc0NfaY/ZyEiQ6FhJjuFo332xQBIfQlIZvobNdblQxT2RQYsnN2fO03HM1V5q2brwMzE
	GPJkuALx9mxjio5eQlp0TeNsv87daqEKb6zsAG8shA1wc19ZcXgDRpxNuqC35Dez/zGUuNpgAuUiI
	Szxu9RX6A6vCLbPx1q2rbDWAIjdxXsSkl8/6u5M+eq2qCoNfld1iEe2FxiNvd86jaWzSxgcDSJYrJ
	cAzVbCMIeY68aXE5uj8x37nJcjFnp5NWD+44wrP2C4UbguPgvMMiZNjVMwXOuZsfAafhgVZ5ILePp
	4biHNsag==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxI-0000000004u-1f9A;
	Thu, 23 Oct 2025 18:14:24 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 10/28] datatype: Increase symbolic constant printer robustness
Date: Thu, 23 Oct 2025 18:13:59 +0200
Message-ID: <20251023161417.13228-11-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not segfault if passed symbol table is NULL.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/datatype.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 7104ae8119ec6..55cd0267055bd 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -254,15 +254,19 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 	mpz_export_data(constant_data_ptr(val, expr->len), expr->value,
 			expr->byteorder, len);
 
+	if (nft_output_numeric_symbol(octx) || !tbl)
+		goto basetype_print;
+
 	for (s = tbl->symbols; s->identifier != NULL; s++) {
 		if (val == s->value)
 			break;
 	}
-
-	if (s->identifier == NULL || nft_output_numeric_symbol(octx))
-		return expr_basetype(expr)->print(expr, octx);
-
-	nft_print(octx, quotes ? "\"%s\"" : "%s", s->identifier);
+	if (s->identifier) {
+		nft_print(octx, quotes ? "\"%s\"" : "%s", s->identifier);
+		return;
+	}
+basetype_print:
+	expr_basetype(expr)->print(expr, octx);
 }
 
 static void switch_byteorder(void *data, unsigned int len)
-- 
2.51.0

