Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794416516;
	b=emQZPxLs80Z8WG0PbFsMgRToeCY6Tq2n3IBPx3l6WESkwYdOaXPxGz1Ve+JVKEY7ADA3
	 IaN92T+jYRqys6+zNrLc0I03kPtpuwNh1zCxKrk01MNmaqlCT2pL+VwZ8Ix1/D0Gamg3d
	 1P9U+89ZNS/ELmguJBJF7+/zEB8T2MZZWzsAhI5jgpLDZGBM1DHbg1FGkZQtUXKS0hS5F
	 aEr5IMGeWM+AWhq7zog11ewk+QofodeoIXjIM9NfFsy39LTs9UFJXw+3klAaCkCZXRizB
	 iPJ8YGXF8lzugaN8/bv/rsBga8/G3bDCHVeUEsXb+Y04moxsiP08mbCJtv1f/9MCgxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794416516;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=I+bHRPjNNdT4BLe7ciRYA4FKZWlfC92f642TS29Yp94=;
	b=sGLXFCoRmVAMaa1FYUKtiloHlSvRAb5l/XsJdLHx9blX8Lf9g+070XYHSjTswb5ge00u
	 FAxAcJ+USxAJeg8zwkR6iBCa4sPJZ9zeehZbIWmLxJU1xuiAvqAaP0RH6TSz9d7QREGk0
	 a7m8+KKvEkjz8OlBs/cxko0+EvUUFyD2hNGvatd1U48f1X4f+X3cKlf6zjh/9QUi3IKoq
	 LtlJ2XeHjHEzwVK9CC01a78fs6gdFd6eiXG8Uqm72EIRJn+uoKD2xRsKvTYnrF/aIN6Sa
	 Cd4598hwxX/s1RxNtIfhv9AgYET08yqgpHgV9IkaTEBeHxzpPUdJS6aoVFIV4hOBEHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=StrIOOLE;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0748B606A32D
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 17:01:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0748B606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=StrIOOLE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I+bHRPjNNdT4BLe7ciRYA4FKZWlfC92f642TS29Yp94=; b=StrIOOLEPgg1JzGoOPBWBSvOak
	BD1IoipVFu/YKASROqVQ98o4VTX7KKG7RqH3lRJJUdEVYp2V9csnX0E/NR2gNVBOAlAZRfkjEfbRD
	BfzwHyjdUWrRpTsnpzC+oquBko0HmA6d30jU5+K9zUNrqy1DeRwmsUPYHja6dqeBqL6zk7SvqlBfT
	LtHYKaVgCmJpo3lJVkMzCmAzxByM27o/MGALz4rgNZ3bxwb9HJk22dAqCQiclrMLqPx9whbVUrcd/
	QnXOTsczxMv8LnDCtAMJS9BmBVOEhZ40u8+waC1iU+kJHa0CCinBRArrJDIE62WXzt0eJcDlztsW5
	6XtzXQhw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xRBhp-000000006yZ-0Ykb;
	Wed, 11 Nov 2026 18:01:53 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/3] parser_json: Avoid storage leak in json_parse_set_expr error path
Date: Wed, 11 Nov 2026 18:01:45 +0100
Message-ID: <20261111170147.47501-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261111170147.47501-1-phil@nwl.cc>
References: <20261111170147.47501-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If parsing jright fails, code frees 'expr' and 'set_expr' before
returning but 'elem' may have been allocated as well. To avoid extra
conditionals when freeing it, parse jright earlier so the code following
conditional 'elem' allocation becomes error-path-free.

Fixes: 144d97e151adb ("src: normalize set element with EXPR_MAPPING")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 14259ea39777b..224cbb79de1b8 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1493,13 +1493,6 @@ static struct expr *json_parse_set_expr(struct json_ctx *ctx,
 				return NULL;
 			}
 
-			if (expr->etype != EXPR_SET_ELEM) {
-				elem = set_elem_expr_alloc(int_loc, expr);
-			} else {
-				elem = expr;
-				expr = expr->key;
-			}
-
 			expr2 = json_parse_set_rhs_expr(ctx, jright);
 			if (!expr2) {
 				json_error(ctx, "Invalid set elem at index %zu.", index);
@@ -1507,6 +1500,14 @@ static struct expr *json_parse_set_expr(struct json_ctx *ctx,
 				expr_free(set_expr);
 				return NULL;
 			}
+
+			if (expr->etype != EXPR_SET_ELEM) {
+				elem = set_elem_expr_alloc(int_loc, expr);
+			} else {
+				elem = expr;
+				expr = expr->key;
+			}
+
 			expr2 = mapping_expr_alloc(int_loc, expr, expr2);
 			elem->key = expr2;
 			expr = elem;
-- 
2.54.0

