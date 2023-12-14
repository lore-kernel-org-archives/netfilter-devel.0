Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EF010A
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 00:39:23 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDhFZ-00070Y-Nd; Thu, 14 Dec 2023 09:39:21 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: fix gmp assertion with too-large reject code
Date: Thu, 14 Dec 2023 09:39:13 +0100
Message-ID: <20231214083917.2430-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before:
nft: gmputil.c:77: mpz_get_uint8: Assertion `cnt <= 1' failed.
After: Error: reject code must be integer in range 0-255

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                             | 7 +++++++
 .../testcases/bogons/nft-f/icmp_reject_type_uint8_assert   | 1 +
 2 files changed, 8 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/icmp_reject_type_uint8_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index c78cfd7a1d6e..89b84cd03864 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3598,6 +3598,13 @@ static int stmt_evaluate_reject_icmp(struct eval_ctx *ctx, struct stmt *stmt)
 		erec_queue(erec, ctx->msgs);
 		return -1;
 	}
+
+	if (mpz_cmp_ui(code->value, 255) > 0) {
+		expr_free(code);
+		return expr_error(ctx->msgs, stmt->reject.expr,
+				  "reject code must be integer in range 0-255");
+	}
+
 	stmt->reject.icmp_code = mpz_get_uint8(code->value);
 	expr_free(code);
 
diff --git a/tests/shell/testcases/bogons/nft-f/icmp_reject_type_uint8_assert b/tests/shell/testcases/bogons/nft-f/icmp_reject_type_uint8_assert
new file mode 100644
index 000000000000..1fc85b2938cc
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/icmp_reject_type_uint8_assert
@@ -0,0 +1 @@
+rule t c reject with icmp 512
-- 
2.41.0

