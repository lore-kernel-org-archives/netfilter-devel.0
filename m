Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFD91D6DC6
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 22:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724106354; cv=none; b=C8bGPqJPkl47jrdfqBW+1QOx6VwEVWBS0iQr/aqtFoBSP7imI05Cg9Lk21TFhwaQqfByB7+4PX0vaMKX8BXocIDnWVwbQkhuS6a4A0zVceTsFeSxJO0U80PQwO2zirRuPD1gxlneU4JR2OhjYzAUcESCXmuRFm7/6+DATKfAoA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724106354; c=relaxed/simple;
	bh=vlAOuG0e27YnGooIsEF391EPcakhlnYiEA6g8P5GbCw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YyWk//uIn/WN/YFExbbzIXKv6/K1s9OQjaFPPfyDPHb33r1HK0+vxnzeXo2xB0dWsk3FJjLxn28qe/E3ihcK94HdUJFXta+5//idLdyPoGDI84dvlwk6fRCs/mMPT9SXs4UQKNzPNpMU51730XJAA7UAnEc8XGlTOtVWUZPAX8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: sebastian.walz@secunet.com
Subject: [PATCH nft 2/4] parser_json: fix several expression memleaks from error path
Date: Tue, 20 Aug 2024 00:23:02 +0200
Message-Id: <20240819222304.1041208-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240819222304.1041208-1-pablo@netfilter.org>
References: <20240819222304.1041208-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Sebastian Walz (sivizius)" <sebastian.walz@secunet.com>

Fixes: 586ad210368b ("libnftables: Implement JSON parser")
Signed-off-by: Sebastian Walz (sivizius) <sebastian.walz@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_json.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/parser_json.c b/src/parser_json.c
index fc20fe2969f7..8ca44efbb52e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1308,6 +1308,7 @@ static struct expr *json_parse_range_expr(struct json_ctx *ctx,
 	expr_high = json_parse_primary_expr(ctx, high);
 	if (!expr_high) {
 		json_error(ctx, "Invalid high value in range expression.");
+		expr_free(expr_low);
 		return NULL;
 	}
 	return range_expr_alloc(int_loc, expr_low, expr_high);
@@ -1889,6 +1890,8 @@ static struct stmt *json_parse_mangle_stmt(struct json_ctx *ctx,
 		return stmt;
 	default:
 		json_error(ctx, "Invalid mangle statement key expression type.");
+		expr_free(key);
+		expr_free(value);
 		return NULL;
 	}
 }
@@ -2888,6 +2891,7 @@ static struct stmt *json_parse_optstrip_stmt(struct json_ctx *ctx,
 	    expr->etype != EXPR_EXTHDR ||
 	    expr->exthdr.op != NFT_EXTHDR_OP_TCPOPT) {
 		json_error(ctx, "Illegal TCP optstrip argument");
+		expr_free(expr);
 		return NULL;
 	}
 
-- 
2.30.2

