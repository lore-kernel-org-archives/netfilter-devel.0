Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51AF221F1C
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753914352; cv=none; b=kQaSV9/oBA5tkhio4hBH0iDNxoC3MVtf1HwRqsZas1iK5LLZ5DvjXQ/lEUP7BiCx7lLLxjosccwfsHhprOPHGlVxCzu7dyPLSaH/CdoYEw/JPyNbXdNDuYpX/UkWTr02snj+EzmgdCDkBVXqsNhnFL9oc2IivUfUFzA0NLYxYmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753914352; c=relaxed/simple;
	bh=AJLcEaQnVyUXJqb4vG21Wq8CLIR/lW/k6ivWcnN5Q/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFgvL73FKHi0T/MoC8NS4pgC4orZepbD0zbOC4P9alb4OC0PSRF5R0NqXh7rk1ppZRcdJT83l+G0cROAZ0P1PCONbEMsKN7S01qpqPg0URnNh5526yC+RwTnp6LkTlcsZczhe3gqqMf1VVrM0/rKjzNM3HyarW5sYFQchpLnd9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ozDAggWf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ozDAggWf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uddJin8Chak7gIBRnESbITw5K7lT88xuKXgFG/CN0cQ=; b=ozDAggWfrXbK1LIk2wiBj3mZ63
	UJhV2XIFCMsciRLxXXXTitLDAUoCkQoS5wQ+niUKhFzgrsKF49nKMmyK+XD0UrodeTrAZ1s3K/nFw
	fbUwaydhf272zqpqzaFj1kfq2C8zZBkRGY596KnInsNgshoDyFr5rPuLnJjVOAijMNB4Ixv0ZTr7u
	HIAJi6T5xzFRoWd10pWmbykCBWZ5dvAPC6vUlsQQdzRKXQAhqFAsdW0+tV0IXrK/3hd02y7QNoK6g
	vTfw6F2av7I/JOWpdHx2qq5o18CYUeqez0Lj4C+lhoUc83uRNvye0R2wXez9/f2/85Ytnvbhdy7f8
	WV3O3Olw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhFEz-000000004Re-3ijF;
	Thu, 31 Jul 2025 00:25:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 2/3] parser_json: Parse into symbol range expression if possible
Date: Thu, 31 Jul 2025 00:25:35 +0200
Message-ID: <20250730222536.786-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250730222536.786-1-phil@nwl.cc>
References: <20250730222536.786-1-phil@nwl.cc>
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

