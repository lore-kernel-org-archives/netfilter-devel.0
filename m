Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A090A1
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 10:13:26 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rD7G0-0001sy-Ag; Tue, 12 Dec 2023 19:13:24 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft] src: reject large raw payload and concat expressions
Date: Tue, 12 Dec 2023 19:13:14 +0100
Message-ID: <20231212181318.1393-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel will reject this too, but unfortunately nft may try
to cram the data into the underlying libnftnl expr.

This causes heap corruption or
BUG: nld buffer overflow: want to copy 132, max 64

After:

Error: Concatenation of size 544 exceeds maximum size of 512
udp length . @th,0,512 . @th,512,512 { 47-63 . 0xe373135363130 . 0x33131303735353203 }
                           ^^^^^^^^^

resp. same warning for an over-sized raw expression.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Squash of:

   [nft] parser_bison: reject large raw payload expressions
   [nft] evaluate: error out if concat expression becomes too large

   I will mark both as 'superseded'.

 with a new, unified NFT_MAX_EXPR_LEN_BITS instead of copypasted
 define.

 I also added this test to set_expr_evaluate_concat().

 include/expression.h                                      | 2 ++
 src/evaluate.c                                            | 8 ++++++++
 src/parser_bison.y                                        | 7 +++++++
 .../bogons/nft-f/stack_overflow_via_large_concat_expr     | 5 +++++
 .../bogons/nft-f/stack_overflow_via_large_raw_expr        | 5 +++++
 5 files changed, 27 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/stack_overflow_via_large_concat_expr
 create mode 100644 tests/shell/testcases/bogons/nft-f/stack_overflow_via_large_raw_expr

diff --git a/include/expression.h b/include/expression.h
index aede223db741..e4fb3b40c4ba 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -11,6 +11,8 @@
 #include <json.h>
 #include <libnftnl/udata.h>
 
+#define NFT_MAX_EXPR_LEN_BITS (NFT_REG32_COUNT * sizeof(uint32_t) * BITS_PER_BYTE)
+
 /**
  * enum expr_types
  *
diff --git a/src/evaluate.c b/src/evaluate.c
index 1b3e8097454d..d497ba5d73eb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1591,6 +1591,10 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		}
 
 		ctx->inner_desc = NULL;
+
+		if (size > NFT_MAX_EXPR_LEN_BITS)
+			return expr_error(ctx->msgs, i, "Concatenation of size %u exceeds maximum size of %u",
+					  size, NFT_MAX_EXPR_LEN_BITS);
 	}
 
 	(*expr)->flags |= flags;
@@ -4690,6 +4694,10 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 
 		(*expr)->field_len[(*expr)->field_count++] = dsize_bytes;
 		size += netlink_padded_len(i->len);
+
+		if (size > NFT_MAX_EXPR_LEN_BITS)
+			return expr_error(ctx->msgs, i, "Concatenation of size %u exceeds maximum size of %u",
+					  size, NFT_MAX_EXPR_LEN_BITS);
 	}
 
 	(*expr)->flags |= flags;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 85cc9b6b0a80..026570e9627d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5641,6 +5641,13 @@ payload_expr		:	payload_raw_expr
 
 payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM	close_scope_at
 			{
+				if ($6 > NFT_MAX_EXPR_LEN_BITS) {
+					erec_queue(error(&@1, "raw payload length %u exceeds upper limit of %u",
+							 $6, NFT_MAX_EXPR_LEN_BITS),
+							 state->msgs);
+					YYERROR;
+				}
+
 				$$ = payload_expr_alloc(&@$, NULL, 0);
 				payload_init_raw($$, $2, $4, $6);
 				$$->byteorder		= BYTEORDER_BIG_ENDIAN;
diff --git a/tests/shell/testcases/bogons/nft-f/stack_overflow_via_large_concat_expr b/tests/shell/testcases/bogons/nft-f/stack_overflow_via_large_concat_expr
new file mode 100644
index 000000000000..8b0d27444c22
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/stack_overflow_via_large_concat_expr
@@ -0,0 +1,5 @@
+table t {
+	chain c {
+		udp length . @th,0,512 . @th,512,512 { 47-63 . 0xe373135363130 . 0x33131303735353203 }
+	}
+}
diff --git a/tests/shell/testcases/bogons/nft-f/stack_overflow_via_large_raw_expr b/tests/shell/testcases/bogons/nft-f/stack_overflow_via_large_raw_expr
new file mode 100644
index 000000000000..66bd6bf87732
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/stack_overflow_via_large_raw_expr
@@ -0,0 +1,5 @@
+table t {
+	chain c {
+		 @th,160,1272 gt 0
+	}
+}
-- 
2.41.0

