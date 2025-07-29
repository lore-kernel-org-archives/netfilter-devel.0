Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C3D223DE7
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 16:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753805922; cv=none; b=mhvsixOn9KRAxnw8k2mbnIqt/CruI1oYXjUGO2n30f0K6Q5VGrj7hZUW5DTXPwHKlv1o81ghgAJlvZAO8x7woHatuRVlfoFAGyMXDBS6BnKso/i9frweFxY+zGXb24gdfLmWsF3nVabLQBgu+tVBywPbIxf79Apbs1PU1glqw2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753805922; c=relaxed/simple;
	bh=AJLcEaQnVyUXJqb4vG21Wq8CLIR/lW/k6ivWcnN5Q/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1Mcli6ITFBci7YJ/4XT7HKeYZyznH6HiIIEdJFCh070pOJIgDlK41AOFb1ykwKaaSdB9d6+zYpfYv1Y9aWldzQ6bxLTeXvn4vfgfTlermDNLjIgUzgR7DvppXPB2mcQZITXzqlFlOU2K3mitTEcM83CIQoBTUkS4JfT33/LiMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EbzBN0B9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EbzBN0B9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uddJin8Chak7gIBRnESbITw5K7lT88xuKXgFG/CN0cQ=; b=EbzBN0B9px9UPNQcUPPlxFVpGH
	rbyFweiVO67x9rU3NRKfb7yevXBuDdLR0jhpDydeoI5XWmgm3AVNpqcpcNEH4WyN3dSBhDQeblcw8
	dZXmALIUs4SdpnpFnLGz8y5oxNKRFxRlQNWpGsZCQ2fjMIsIYQ/zTte2EVmSRaziNOnvClL6tuh/M
	A92LaKZcdaB72zIMayE/xx4U1np6EZ6dR2StQ1JMul1c20d0T41xtp5fVLkvYLmII4raMjypD1rzP
	KattEKZlgVigPj1KV/9nHWTUCgYmqyKpKNyAMP80DSi7Ex0nvd0myHk9n5Rza9t2PH8Taj+axFiA7
	S1oaYWQA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ugn2E-000000005Bd-1cOV;
	Tue, 29 Jul 2025 18:18:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 2/3] parser_json: Parse into symbol range expression if possible
Date: Tue, 29 Jul 2025 18:18:31 +0200
Message-ID: <20250729161832.6450-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250729161832.6450-1-phil@nwl.cc>
References: <20250729161832.6450-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Apply the bison parser changes in commit 347039f64509e ("src: add symbol
range expression to further compact intervals") to JSON parser as well.

Fixes: 347039f64509e ("src: add symbol range expression to further compact intervals")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index bd865de59007a..120c814bc7a9b 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1353,7 +1353,7 @@ static struct expr *json_parse_prefix_expr(struct json_ctx *ctx,
 static struct expr *json_parse_range_expr(struct json_ctx *ctx,
 					  const char *type, json_t *root)
 {
-	struct expr *expr_low, *expr_high;
+	struct expr *expr_low, *expr_high, *tmp;
 	json_t *low, *high;
 
 	if (json_unpack_err(ctx, root, "[o, o!]", &low, &high))
@@ -1370,6 +1370,16 @@ static struct expr *json_parse_range_expr(struct json_ctx *ctx,
 		expr_free(expr_low);
 		return NULL;
 	}
+	if (is_symbol_value_expr(expr_low) && is_symbol_value_expr(expr_high)) {
+		tmp = symbol_range_expr_alloc(int_loc,
+					      SYMBOL_VALUE,
+					      expr_low->scope,
+					      expr_low->identifier,
+					      expr_high->identifier);
+		expr_free(expr_low);
+		expr_free(expr_high);
+		return tmp;
+	}
 	return range_expr_alloc(int_loc, expr_low, expr_high);
 }
 
-- 
2.49.0

