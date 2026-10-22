Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.78.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792701943;
	b=wTxL0NnvXBecKi993dgV0lKwlCDe0a+lXNSQlz/R/K2esQPgf0V6264wR+ocVdKFbP4f
	 /IHnr+txlWttDggJguqruNpUtrLr5pcAnxyZds3TXF/zTJLyYvpGAfdYXOFPnn8GsXsNx
	 8vAhMEyXhFV8Dm9MVZ2a5QMQP0PBPbotK9mMp/ydG+ynV2MjSqOE2rHdl5d51epPjwiBe
	 qgVFSW9fW/kxAQdfrqWQeApUh7awvPBsMVzfklWp/Uvkuszhkm0pNopOVkIVsA9CoS/SH
	 +MjSlPGQUcUxxe33i9RQtNlDdMEgzCWOeJvlpF/D7FSnDgM0LzpnTUERCyN36M8Phhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792701943;
	h=DMARC-Filter:Received:X-ICL-RepId:X-ICL-Out-Info:Dkim-Signature:
	 mail-alias-created-date:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Info-Out:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-JNJ;
	bh=fsf1CCXnDnWCvHaPkNNc5g46CjL9ZdhFgMqREErkUxM=;
	b=IqUoAkYTNnJRpIaqQ7Ai1KsV12HrFUJeAZp5lfc+b/VkRY4h7pXz8UVpxwI8VmVZJQl6
	 WNasUnpQWnh/U3l6z+17WoYm2udsZZ99yTHCWJIH/mrLYC0AQ9VR00lPBraa77iagwU1H
	 mu0nYyzs45K4xp6MnD5q3rMDhTGLaGKKt60M0WSFH/TPIuFXqZVc3lV1MW7PRz5Rxqed0
	 ug3JtImvB6eDD8LtGXUzLSFHEcj70xDm5Ot1hRFHT4wC9mP6kmrq7nQt58MeqkX6gTpT9
	 CMeCyX6gOm/vyF7M08Kg8rCXILQxvGJIP9CVuWqBezyYoXW11od5vkVywLJrGgX6ZyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=seeber.me;
	spf=pass smtp.mailfrom=seeber.me;
	dkim=pass header.d=seeber.me header.i=@seeber.me header.a=rsa-sha256 header.s=sig1 header.b=qIRkx7gf;
	arc=none smtp.remote-ip=57.103.78.81
Received: from outbound.st.icloud.com (st-2002j-snip4-8.eps.apple.com [57.103.78.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EF5606A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 20:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01EF5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seeber.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seeber.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=seeber.me header.i=@seeber.me header.a=rsa-sha256 header.s=sig1 header.b=qIRkx7gf
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPS id 8A4891800227;
	Thu, 22 Oct 2026 20:45:41 +0000 (UTC)
X-ICL-RepId: 01a1655c-c72b-7adb-beff-1dcb70f53f72
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQFMHVwDWhxEDlYCWAZLVxQEElwOXw5cMEodVg9SGRwdXFhVCQoYVxVbHUFDWg4SAlpFBU1fDl4fBBdGGVUERx5dVkAZGQJRHFYNV0NUBF9QSQxBUGxaAEcXSB1dGVlvUF0cDh5SDlAVS1ZeCBcGWxQERAFdBV0DQAtKAV0DXgFEF00HXwVSH0IUElwOXw5cMEodVg9SGRwdXEYTGU4bV01aDUAZWAZtFFYVUgRZ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seeber.me; s=sig1; t=1792701942; x=1824237942; bh=fsf1CCXnDnWCvHaPkNNc5g46CjL9ZdhFgMqREErkUxM=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=qIRkx7gf4XGw/+toj0CMl09ShU2XPlBByD0WLC3ktlTKSHAJU7sHatxwOmIQN+HcV/WeQ3HHYUt50IOjNAQQAiMzgfnHz6edCsbfjI2/yCL7crF0mpL11ksHI/ZpeK/RNflmoB/UZFkIU7evYO48uZusfa+MQHqr2MEK01AY9HSV3fjwqW7chA4eZ3S9uWQVllNFFfqbPaUQVI/H0jieiWepzY8ZBQTZlNQPAhjw6ZT0tvUtlMKnEcKthaGC83/LHa/BvF8hml8ajuBo0g5izFVNeYQun/alpIMelZaAeHo2qr4dU8WrdgDGUvopxq2I85DVEKK5U8/71zrU52ZxLw==
mail-alias-created-date: 1307199970000
Received: from localhost.localdomain (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPSA id 7A7751800096;
	Thu, 22 Oct 2026 20:45:40 +0000 (UTC)
From: Jochen Seeber <jochen@seeber.me>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	jeremy@azazel.net,
	Jochen Seeber <jochen@seeber.me>
Subject: [PATCH nft 1/3] src: allow map lookups as operands of bitwise binops
Date: Thu, 22 Oct 2026 22:45:32 +0200
Message-ID: <20261022204534.54229-2-jochen@seeber.me>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022204534.54229-1-jochen@seeber.me>
References: <20261022204534.54229-1-jochen@seeber.me>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA4MiBTYWx0ZWRfX6/MVklSz0IW8
 qHaJXeUexjc2t1n1PlsWwpbPX0ChqUnzzHMCoid+5ScaC6/8sWKUUfKyINQaRsM4mgSzwLvY8Mw
 42Hjd/b1OPUakdWki/+vfvX2jUIFoDT1+6Jins7MPheiZ9eWM0d+SqsvPgG+5Egpyw4aChWff3w
 5wkYQqwSmMYhYMUZ1iezCSXEmooTmN0y43/dZE6oQULBxH5tG9SUPQxGBJ1QgZ8iPeNsGY4n3r+
 OZX9tOLAIpra3Y+AuV1MYMuX8NIEiuNNlqhJQT905CO4g6YdGN5zNgXqa7siTHgs77hJwVMx+6z
 LpGVGwDnOK2qkFTjJR3r0czlSZqhrrk1UhU4ju4aZ3eVK88vl1G/9ecvZ3YZeU=
X-Authority-Info-Out: v=2.4 cv=J8qnLQnS c=1 sm=1 tr=0 ts=6ada75f5
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=MKtGQD3n3ToA:10 a=1oJP67jkp3AA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=PSO4xYwZUUep2cFDZPQA:9
 a=Hj7XuWabhHpBS0h9:21
X-Proofpoint-ORIG-GUID: 2DQW_x3-3U81nXTw0i0E21EeFZa_r5iV
X-Proofpoint-GUID: 2DQW_x3-3U81nXTw0i0E21EeFZa_r5iV
X-JNJ: AAAAAAABJB7TyppnEVN3LYUdLY+KpVl4+mG9oLSBSfMGz+WwLet4n4Hl81+l0ghyV868LfyZfZGwMgX+qh5DOizQRLPovqmzNWf0DRORU+PJS/5mfWuBO5nLJQItd04wS5nD4REks66SedL+KbnZS3o/O4OQA8Dnvswt1PdXt3ggpsfN4OEJrRoUeonlEwspUhmMZvsphu+7jdszknZM0fDdaY8DK5S3GTvn3uxivjqT+VEXzrYkQrY2fO6IdBXksrJRGFBDvoOI5eHuvYHw9zFSb5Q4zfKMnaDt1mjiDReyTbFPsnc5tAut16j3oQnUE/LRhD1bp9A7T8fXoC6i0qZbvW7utdLkB+DA0IJPlDo40pDceGxDBqz9oFPtRhEBrPi5Igwr/dun8kyj3s4+//SDQCu+Wby+oCUi5dvhBopPBKukpfYtxtBbmZH2A5EEDoxBaeSIpIpBKSxuRHhtex/VZZhPs36qCzxwnESs3kRiTgKmSo4cfvkknrPoQ6ZpwB+AQxUtz3xzTZ9VL3l14/GXXSvGEWEtiuUhgzzGG1pfCuHX0q6RanlzMfq48W221lJHvPhBnRJelJCV9TU3F7zEc/+PjUF7AlrfnWFzz3i4srZNKU3isJ/faFNU5Q1MPnVmc6owRmyO2r5vn0typTGMZ4FnC5dTCS3vbbyrrDFbkWFHIiUa3lDslYqEnronxL/9JlRbVuF9vL/zJvboKmFdAqtve+UGKHldkAq9PvAY+3c2oH1D0gLK3VSbO1d7+Tmx3C8LabPnEKCDcVIQCVulHO47EMd7a1F/Yeq/msOGFVaYaJfhzF0L

Since Linux 6.13, the kernel performs AND, OR and XOR on two registers,
and nft accepts variable right-hand operands such as:

  ct mark set ct mark & 0xffff0000 | meta mark & 0xffff

A map lookup could not be such an operand, though. Setting part of the
packet mark from a map took a chain per map value, or a detour through
the conntrack mark.

Accept a map lookup enclosed in parentheses as operand of a binop in
statement expressions, e.g.:

  meta mark set meta mark & 0xffffff80 | (ip daddr . ip saddr map @m)

which yields:

  [ meta load mark => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0xffffff80 ) ^ 0x00000000 ]
  [ payload load 4b @ network header + 16 => reg 2 ]
  [ payload load 4b @ network header + 12 => reg 13 ]
  [ lookup reg 2 set m dreg 2 ]
  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
  [ meta set mark with reg 1 ]

The parentheses are required: without them, the existing grammar takes
"meta mark & 0xffffff80 | ip daddr . ip saddr" as the map key.

The evaluator flags map lookups as constant, so that statements use the
map data as is. Clear the flag on binop operands, so that they take the
register-to-register path, and keep the statement length, which map
evaluation resets. List map operands in parentheses, so that the output
parses back.

The new grammar rule also admits a map lookup as concatenation
component, which linearizes but cannot be listed. Reject it in the
evaluator.

In JSON, accept a map as right-hand binop operand in statement context
and parse map key and data independently of the operand position.

This requires Linux kernel >= 6.13.

Signed-off-by: Jochen Seeber <jochen@seeber.me>
---
 doc/statements.txt |  7 +++++++
 src/evaluate.c     | 26 +++++++++++++++++++++++---
 src/expression.c   |  2 ++
 src/parser_bison.y |  4 ++++
 src/parser_json.c  | 15 ++++++++++++++-
 5 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 7f7b5e60..12d0c508 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -932,6 +932,9 @@ ____
 The 'key' is a value returned by 'expression'.
 // XXX: Write about where map statement can be used (list of statements?)
 
+Enclosed in parentheses, a map lookup can also be an operand of the binary
+operations *&*, *|* and *^*. This requires Linux kernel 6.13 or later.
+
 .Using the map statement
 ------------------------
 # select DNAT target based on TCP dport:
@@ -943,6 +946,10 @@ nft add rule ip nat prerouting dnat tcp dport map { 80 : 192.168.1.100, 8888 : 1
 # packets from net 192.168.1.0/24 will appear as originating from 10.0.0.1,
 # packets from net 192.168.2.0/24 will appear as originating from 10.0.0.2
 nft add rule ip nat postrouting snat to ip saddr map { 192.168.1.0/24 : 10.0.0.1, 192.168.2.0/24 : 10.0.0.2 }
+
+# replace the lower 7 bits of the packet mark by the value mapped to the
+# destination and source address, keep the other bits
+nft add rule ip mangle output 'meta mark set meta mark and 0xffffff80 or (ip daddr . ip saddr map @marks)'
 ------------------------
 
 VMAP STATEMENT
diff --git a/src/evaluate.c b/src/evaluate.c
index f424b987..4fff4b60 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1522,6 +1522,26 @@ static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+/*
+ * Map lookups are flagged constant so that statements use the map data as is.
+ * As a binop operand, a map lookup is a value only known at runtime.
+ */
+static int expr_evaluate_binop_operand(struct eval_ctx *ctx,
+				       struct expr **operand)
+{
+	uint32_t stmt_len = ctx->stmt_len;
+
+	if (expr_evaluate(ctx, operand) < 0)
+		return -1;
+
+	if ((*operand)->etype == EXPR_MAP) {
+		(*operand)->flags &= ~EXPR_F_CONSTANT;
+		ctx->stmt_len = stmt_len;
+	}
+
+	return 0;
+}
+
 /*
  * Binop expression: both sides must be of integer base type. The left-hand side
  * may be either constant or non-constant; if it is constant, it must be a
@@ -1543,7 +1563,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 					 ctx->recursion.binop);
 	ctx->recursion.binop++;
 
-	if (expr_evaluate(ctx, &op->left) < 0)
+	if (expr_evaluate_binop_operand(ctx, &op->left) < 0)
 		return -1;
 	left = op->left;
 
@@ -1555,7 +1575,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 				   left->byteorder, max_shift_len, 0);
 	}
 
-	if (expr_evaluate(ctx, &op->right) < 0)
+	if (expr_evaluate_binop_operand(ctx, &op->right) < 0)
 		return -1;
 	right = op->right;
 
@@ -1741,7 +1761,6 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		case EXPR_BINOP:
 		case EXPR_RELATIONAL:
 		case EXPR_CONCAT:
-		case EXPR_MAP:
 		case EXPR_PAYLOAD:
 		case EXPR_EXTHDR:
 		case EXPR_META:
@@ -1780,6 +1799,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		case EXPR_LIST:
 		case EXPR_SET:
 		case EXPR_SET_REF:
+		case EXPR_MAP:
 		case EXPR_MAPPING:
 		case EXPR_SET_ELEM_CATCHALL:
 		case EXPR_RANGE_SYMBOL:
diff --git a/src/expression.c b/src/expression.c
index 870c7ee1..a1696a24 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -839,6 +839,8 @@ static void binop_arg_print(const struct expr *op, const struct expr *arg,
 	    expr_binop_precedence[op->op] != 0 &&
 	    expr_binop_precedence[op->op] < expr_binop_precedence[arg->op])
 		prec = 1;
+	else if (arg->etype == EXPR_MAP)
+		prec = 1;
 
 	if (prec)
 		nft_print(octx, "(");
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 83c0f323..bb56cfe0 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4000,6 +4000,10 @@ primary_stmt_expr	:	symbol_expr			{ $$ = $1; }
 			|	fib_expr			{ $$ = $1; }
 			|	osf_expr			{ $$ = $1; }
 			|	'('	basic_stmt_expr	')'	{ $$ = $2; }
+			|	'('	concat_stmt_expr	MAP	map_stmt_expr_set	')'
+			{
+				$$ = map_expr_alloc(&@$, $2, $4);
+			}
 			;
 
 shift_stmt_expr		:	primary_stmt_expr
diff --git a/src/parser_json.c b/src/parser_json.c
index 14259ea3..33bdba17 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1533,20 +1533,33 @@ static struct expr *json_parse_set_expr(struct json_ctx *ctx,
 static struct expr *json_parse_map_expr(struct json_ctx *ctx,
 					const char *type, json_t *root)
 {
+	uint32_t old_flags = ctx->flags;
 	json_t *jkey, *jdata;
 	struct expr *key, *data;
 
+	/* on the RHS, a map is only valid as binop operand in a statement */
+	if (is_RHS(ctx) && !is_STMT(ctx)) {
+		json_error(ctx, "Expression type map not allowed in context (%s).",
+			   ctx_flags_to_string(ctx));
+		return NULL;
+	}
+
 	if (json_unpack_err(ctx, root, "{s:o, s:o}",
 			    "key", &jkey, "data", &jdata))
 		return NULL;
 
+	/* key and data do not depend on the map being a binop operand */
+	ctx->flags &= ~(CTX_F_PRIMARY | CTX_F_RHS);
+
 	key = json_parse_map_lhs_expr(ctx, jkey);
 	if (!key) {
 		json_error(ctx, "Illegal map expression key.");
+		ctx->flags = old_flags;
 		return NULL;
 	}
 
 	data = json_parse_rhs_expr(ctx, jdata);
+	ctx->flags = old_flags;
 	if (!data) {
 		json_error(ctx, "Illegal map expression data.");
 		expr_free(key);
@@ -1652,7 +1665,7 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 	} cb_tbl[] = {
 		{ "concat", json_parse_concat_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_DTYPE | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
 		{ "set", json_parse_set_expr, CTX_F_RHS | CTX_F_STMT }, /* allow this as stmt expr because that allows set references */
-		{ "map", json_parse_map_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS },
+		{ "map", json_parse_map_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS },
 		/* below three are multiton_rhs_expr */
 		{ "prefix", json_parse_prefix_expr, CTX_F_RHS | CTX_F_SET_RHS | CTX_F_STMT | CTX_F_CONCAT },
 		{ "range", json_parse_range_expr, CTX_F_RHS | CTX_F_SET_RHS | CTX_F_STMT | CTX_F_CONCAT },
-- 
2.56.0

