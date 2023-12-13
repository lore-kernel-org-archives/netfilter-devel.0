Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA728124
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 08:30:03 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDS7V-0001HJ-D6; Wed, 13 Dec 2023 17:30:01 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: error out when existing set has incompatible key
Date: Wed, 13 Dec 2023 17:29:50 +0100
Message-ID: <20231213162954.10145-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before:
BUG: invalid range expression type symbol
nft: expression.c:1494: range_expr_value_high: Assertion `0' failed.

After:
range_expr_value_high_assert:5:20-27: Error: Could not resolve protocol name
                elements = { 100-11.0.0.0, }
                                 ^^^^^^^^
range_expr_value_high_assert:7:6-7: Error: set definition has conflicting key (ipv4_addr vs inet_proto)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                       |  3 +++
 .../bogons/nft-f/range_expr_value_high_assert        | 12 ++++++++++++
 2 files changed, 15 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/range_expr_value_high_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index dd1c0b44c278..27adbf7f51ee 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4769,6 +4769,9 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		existing_set = set_cache_find(table, set->handle.set.name);
 		if (!existing_set)
 			set_cache_add(set_get(set), table);
+		else if (!datatype_equal(existing_set->key->dtype, set->key->dtype))
+			return set_error(ctx, set, "%s definition has conflicting key (%s vs %s)\n",
+					 type, set->key->dtype->name, existing_set->key->dtype->name);
 
 		if (existing_set && existing_set->flags & NFT_SET_EVAL) {
 			uint32_t existing_flags = existing_set->flags & ~NFT_SET_EVAL;
diff --git a/tests/shell/testcases/bogons/nft-f/range_expr_value_high_assert b/tests/shell/testcases/bogons/nft-f/range_expr_value_high_assert
new file mode 100644
index 000000000000..a25ac028bb9b
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/range_expr_value_high_assert
@@ -0,0 +1,12 @@
+table inet t {
+	set s3 {
+		type inet_proto
+		flags interval
+		elements = { 100-11.0.0.0, }
+	}
+	set s3 {
+		type ipv4_addr
+		flags interval
+		elements = { 100-11.0.0.0, }
+	}
+}
-- 
2.41.0

