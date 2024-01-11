Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7DB58205
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] evaluate: release key expression in error path of implicit map with unknown datatype
Date: Thu, 11 Jan 2024 22:55:19 +0100
Message-Id: <20240111215520.1415-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240111215520.1415-1-pablo@netfilter.org>
References: <20240111215520.1415-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Detected when running:

 # nft -f tests/shell/testcases/bogons/nft-f/mapping_with_invalid_datatype_crash
 ==382584==ERROR: LeakSanitizer: detected memory leaks

 Direct leak of 144 byte(s) in 1 object(s) allocated from:
    #0 0x7fde06ca9e8f in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:145
    #1 0x7fde062924af in xmalloc src/utils.c:31
    #2 0x7fde0629266c in xzalloc src/utils.c:70
    #3 0x7fde06167299 in expr_alloc src/expression.c:46
    #4 0x7fde0616b014 in constant_expr_alloc src/expression.c:420
    #5 0x7fde06128e43 in expr_evaluate_map src/evaluate.c:2027
    #6 0x7fde06137b06 in expr_evaluate src/evaluate.c:2891
    #7 0x7fde06132417 in expr_evaluate_relational src/evaluate.c:2497
    #8 0x7fde06137b36 in expr_evaluate src/evaluate.c:2895
    #9 0x7fde06137d5f in stmt_evaluate_expr src/evaluate.c:2914
    #10 0x7fde061524c8 in stmt_evaluate src/evaluate.c:4646
    #11 0x7fde0615c9ee in rule_evaluate src/evaluate.c:5202
    #12 0x7fde061600c7 in cmd_evaluate_add src/evaluate.c:5422

Fixes: 70054e6e1c87 ("evaluate: catch implicit map expressions without known datatype")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 9b94ea8de940..ad68d47252e0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2030,9 +2030,11 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 						  ctx->ectx.len, NULL);
 		}
 
-		if (!ectx.dtype)
+		if (!ectx.dtype) {
+			expr_free(key);
 			return expr_error(ctx->msgs, map,
 					  "Implicit map expression without known datatype");
+		}
 
 		if (ectx.dtype->type == TYPE_VERDICT) {
 			data = verdict_expr_alloc(&netlink_location, 0, NULL);
-- 
2.30.2

