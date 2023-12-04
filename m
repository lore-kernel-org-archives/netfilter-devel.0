Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958F519B0
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 09:36:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rACrQ-0001UP-7X; Mon, 04 Dec 2023 18:36:00 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: error out if basetypes are different
Date: Mon,  4 Dec 2023 18:35:45 +0100
Message-ID: <20231204173553.6776-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

prefer
binop_with_different_basetype_assert:3:29-35: Error: Binary operation (<<) with different base types (string vs integer) is not supported
oifname set ip9dscp << 26 | 0x10
            ^^^^^^^~~~~~~
to assertion failure.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                             | 7 +++++--
 .../bogons/nft-f/binop_with_different_basetype_assert      | 5 +++++
 2 files changed, 10 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/binop_with_different_basetype_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index b6670254b9fd..51ae276aac6a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1451,8 +1451,11 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 					 "for %s expressions",
 					 sym, expr_name(right));
 
-	/* The grammar guarantees this */
-	assert(datatype_equal(expr_basetype(left), expr_basetype(right)));
+	if (!datatype_equal(expr_basetype(left), expr_basetype(right)))
+		return expr_binary_error(ctx->msgs, left, op,
+					 "Binary operation (%s) with different base types "
+					 "(%s vs %s) is not supported",
+					 sym, expr_basetype(left)->name, expr_basetype(right)->name);
 
 	switch (op->op) {
 	case OP_LSHIFT:
diff --git a/tests/shell/testcases/bogons/nft-f/binop_with_different_basetype_assert b/tests/shell/testcases/bogons/nft-f/binop_with_different_basetype_assert
new file mode 100644
index 000000000000..e84360088e99
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/binop_with_different_basetype_assert
@@ -0,0 +1,5 @@
+table ip t {
+        chain c {
+                oifname set ip9dscp << 26 | 0x10
+        }
+}
-- 
2.41.0

