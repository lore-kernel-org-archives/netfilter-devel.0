Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8306D6A02A
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2024 12:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rOGdG-00069I-CQ; Fri, 12 Jan 2024 13:27:30 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] parser: reject raw payload expressions with 0 length
Date: Fri, 12 Jan 2024 13:27:23 +0100
Message-ID: <20240112122725.11964-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reject this at parser stage.  Fix up the json input side too, else
reproducer gives:
nft: src/netlink.c:243: netlink_gen_raw_data: Assertion `len > 0' failed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                            | 23 +++++++++++++++----
 src/parser_json.c                             | 13 +++++++++++
 .../nft-f/payload_expr_with_0_length_assert   |  1 +
 3 files changed, 32 insertions(+), 5 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/payload_expr_with_0_length_assert

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 86fb9f077db8..17edaef8b0bc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -883,6 +883,8 @@ int nft_lex(void *, void *, void *);
 %type <expr>			payload_expr payload_raw_expr
 %destructor { expr_free($$); }	payload_expr payload_raw_expr
 %type <val>			payload_base_spec
+%type <val>			payload_raw_len
+
 %type <expr>			eth_hdr_expr	vlan_hdr_expr
 %destructor { expr_free($$); }	eth_hdr_expr	vlan_hdr_expr
 %type <val>			eth_hdr_field	vlan_hdr_field
@@ -5681,15 +5683,26 @@ payload_expr		:	payload_raw_expr
 			|	gretap_hdr_expr
 			;
 
-payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM	close_scope_at
+payload_raw_len		:	NUM
 			{
-				if ($6 > NFT_MAX_EXPR_LEN_BITS) {
+				if ($1 > NFT_MAX_EXPR_LEN_BITS) {
 					erec_queue(error(&@1, "raw payload length %u exceeds upper limit of %u",
-							 $6, NFT_MAX_EXPR_LEN_BITS),
-							 state->msgs);
+							 $1, NFT_MAX_EXPR_LEN_BITS),
+						 state->msgs);
 					YYERROR;
 				}
 
+				if ($1 == 0) {
+					erec_queue(error(&@1, "raw payload length cannot be 0"), state->msgs);
+					YYERROR;
+				}
+
+				$$ = $1;
+			}
+			;
+
+payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	payload_raw_len	close_scope_at
+			{
 				$$ = payload_expr_alloc(&@$, NULL, 0);
 				payload_init_raw($$, $2, $4, $6);
 				$$->byteorder		= BYTEORDER_BIG_ENDIAN;
@@ -5936,7 +5949,7 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 					YYERROR;
 				}
 			}
-			|	TCP	OPTION	AT	close_scope_at	tcp_hdr_option_type	COMMA	NUM	COMMA	NUM
+			|	TCP	OPTION	AT	close_scope_at	tcp_hdr_option_type	COMMA	NUM	COMMA	payload_raw_len
 			{
 				$$ = tcpopt_expr_alloc(&@$, $5, 0);
 				tcpopt_init_raw($$, $5, $7, $9, 0);
diff --git a/src/parser_json.c b/src/parser_json.c
index 9e02bc344097..a0c9318c83db 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -592,6 +592,13 @@ static struct expr *json_parse_payload_expr(struct json_ctx *ctx,
 			json_error(ctx, "Invalid payload base '%s'.", base);
 			return NULL;
 		}
+
+		if (len <= 0 || len > (int)NFT_MAX_EXPR_LEN_BITS) {
+			json_error(ctx, "Payload length must be between 0 and %lu, got %d",
+				   NFT_MAX_EXPR_LEN_BITS, len);
+			return NULL;
+		}
+
 		expr = payload_expr_alloc(int_loc, NULL, 0);
 		payload_init_raw(expr, val, offset, len);
 		expr->byteorder		= BYTEORDER_BIG_ENDIAN;
@@ -663,6 +670,12 @@ static struct expr *json_parse_tcp_option_expr(struct json_ctx *ctx,
 		if (kind < 0 || kind > 255)
 			return NULL;
 
+		if (len <= 0 || len > (int)NFT_MAX_EXPR_LEN_BITS) {
+			json_error(ctx, "option length must be between 0 and %lu, got %d",
+				   NFT_MAX_EXPR_LEN_BITS, len);
+			return NULL;
+		}
+
 		expr = tcpopt_expr_alloc(int_loc, kind,
 					 TCPOPT_COMMON_KIND);
 
diff --git a/tests/shell/testcases/bogons/nft-f/payload_expr_with_0_length_assert b/tests/shell/testcases/bogons/nft-f/payload_expr_with_0_length_assert
new file mode 100644
index 000000000000..f85a04e7c5de
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/payload_expr_with_0_length_assert
@@ -0,0 +1 @@
+add rule t c @th,0,0 0
-- 
2.41.0

