Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51497B9
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 09:21:55 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rACdm-0001PG-0A; Mon, 04 Dec 2023 18:21:54 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: handle invalid mapping expressions gracefully
Date: Mon,  4 Dec 2023 18:21:46 +0100
Message-ID: <20231204172149.5204-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before:
BUG: invalid mapping expression binop
nft: src/evaluate.c:2027: expr_evaluate_map: Assertion `0' failed.

After:
tests/shell/testcases/bogons/nft-f/invalid_mapping_expr_binop_assert:1:22-25: Error: invalid mapping expression binop
xy mame ip saddr map h& p p
        ~~~~~~~~     ^^^^
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                                | 4 ++--
 .../testcases/bogons/nft-f/invalid_mapping_expr_binop_assert  | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_mapping_expr_binop_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 64deb31a6ec4..b6428018c398 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2024,8 +2024,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		/* symbol has been already evaluated to set reference */
 		break;
 	default:
-		BUG("invalid mapping expression %s\n",
-		    expr_name(map->mappings));
+		return expr_binary_error(ctx->msgs, map->mappings, map->map,
+					 "invalid mapping expression %s", expr_name(map->mappings));
 	}
 
 	if (!datatype_compatible(map->mappings->set->key->dtype, map->map->dtype))
diff --git a/tests/shell/testcases/bogons/nft-f/invalid_mapping_expr_binop_assert b/tests/shell/testcases/bogons/nft-f/invalid_mapping_expr_binop_assert
new file mode 100644
index 000000000000..7205ff4fde1e
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/invalid_mapping_expr_binop_assert
@@ -0,0 +1 @@
+xy mame ip saddr map h& p p
-- 
2.41.0

