Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E5D200C9
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 10:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rFtSv-0005ES-9x; Wed, 20 Dec 2023 11:06:13 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: don't crash if object map does not refer to a value
Date: Wed, 20 Dec 2023 11:06:04 +0100
Message-ID: <20231220100607.2162-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before:
BUG: Value export of 512 bytes would overflownft: src/netlink.c:474: netlink_gen_prefix: Assertion `0' failed.

After:
66: Error: Object mapping data should be a value, not prefix
synproxy name ip saddr map { 192.168.1.0/24 : "v*" }

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                             | 5 +++++
 tests/shell/testcases/bogons/nft-f/objmap_to_prefix_assert | 6 ++++++
 2 files changed, 11 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/objmap_to_prefix_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 1da6a5711cbf..f7671cc6954c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2179,6 +2179,11 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 		return expr_error(ctx->msgs, mapping->right,
 				  "Value must be a singleton");
 
+	if (set_is_objmap(set->flags) && mapping->right->etype != EXPR_VALUE)
+		return expr_error(ctx->msgs, mapping->right,
+				  "Object mapping data should be a value, not %s",
+				  expr_name(mapping->right));
+
 	mapping->flags |= EXPR_F_CONSTANT;
 	return 0;
 }
diff --git a/tests/shell/testcases/bogons/nft-f/objmap_to_prefix_assert b/tests/shell/testcases/bogons/nft-f/objmap_to_prefix_assert
new file mode 100644
index 000000000000..d880a377cacd
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/objmap_to_prefix_assert
@@ -0,0 +1,6 @@
+table t {
+        chain y {
+                type filter hook input priority filter; policy accept;
+                synproxy name ip saddr map { 192.168.1.0/24 : "x*" }
+        }
+}
-- 
2.41.0

