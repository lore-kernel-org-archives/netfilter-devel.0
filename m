Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7588711F
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 04:42:37 -0800 (PST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] evaluate: reject set definition with no key
Date: Wed,  6 Dec 2023 13:42:30 +0100
Message-Id: <20231206124230.521196-1-pablo@netfilter.org>
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
 src/evaluate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index cf5f32c144d3..6419de572693 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4693,6 +4693,10 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	struct stmt *stmt;
 	const char *type;
 
+	if (set->key == NULL)
+		return set_error(ctx, set, "%s definition does not specify key",
+				 set->flags & NFT_SET_MAP ? "map" : "set");
+
 	if (!set_is_anonymous(set->flags)) {
 		table = table_cache_find(&ctx->nft->cache.table_cache,
 					 set->handle.table.name,
-- 
2.30.2

