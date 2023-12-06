Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71703D3
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 04:59:23 -0800 (PST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft,v2] evaluate: reject set definition with no key
Date: Wed,  6 Dec 2023 13:59:19 +0100
Message-Id: <20231206125919.672569-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 tests/shell/testcases/bogons/nft-f/set_definition_with_no_key_assert
 BUG: unhandled key type 2
 nft: src/intervals.c:59: setelem_expr_to_range: Assertion `0' failed.

This patch adds a new unit tests/shell courtesy of Florian Westphal.

Fixes: 3975430b12d9 ("src: expand table command before evaluation")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: I realize there is a type const char * already around that can be use
    to print either "set" or "map", reuse it.

 src/evaluate.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index cf5f32c144d3..5021ae80bbfa 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4693,6 +4693,12 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	struct stmt *stmt;
 	const char *type;
 
+	type = set_is_map(set->flags) ? "map" : "set";
+
+	if (set->key == NULL)
+		return set_error(ctx, set, "%s definition does not specify key",
+				 type);
+
 	if (!set_is_anonymous(set->flags)) {
 		table = table_cache_find(&ctx->nft->cache.table_cache,
 					 set->handle.table.name,
@@ -4716,8 +4722,6 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	if (!(set->flags & NFT_SET_INTERVAL) && set->automerge)
 		return set_error(ctx, set, "auto-merge only works with interval sets");
 
-	type = set_is_map(set->flags) ? "map" : "set";
-
 	if (set->key == NULL)
 		return set_error(ctx, set, "%s definition does not specify key",
 				 type);
-- 
2.30.2

