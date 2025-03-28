Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58CF4B5AE
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2025 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743173365; cv=none; b=XEIh+OwbGChfQVkudihPARJgSNtqSrRs/tSDl8YeGW5i2KGY1qdJzy3Ea5h2J7CNsQY3WTQZh+w7ubvJQsiEhRrRIy6V+C+mr/+cFtpqFowIO0Q/4Ala/Y9vBYeES9hw9e5zGjEGnbO4VrK72cAc6DWBdjmeg1jl+i/+Eu/t8c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743173365; c=relaxed/simple;
	bh=nbVamFKaVTfQvtNrd/8eHB9pw7T3rd188451WcHguh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fjE7fpnjCxqduP9fgZ+sxQxLKxiq/iPFm96S6+miQrg1ivcDQquzX/rhNvGeP54gOd2ehnbkTZiJpOjx3bQyOBZVAKl5KXWoR966ScJNZcYp7G/j0ldwNX54SYSSjntUswWKgVZ0D/SbegYfLSnr5kA775+wcrqDzOyN1CYncmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tyB1N-0007Oh-U4; Fri, 28 Mar 2025 15:49:21 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: fix error protagation when parsing binop lhs/rhs
Date: Fri, 28 Mar 2025 15:49:04 +0100
Message-ID: <20250328144911.21966-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Malformed input returns NULL when decoding left/right side of binop.
This causes a NULL dereference in expr_evaluate_binop; left/right must
point to a valid expression.

Fix this in the parser, else would have to sprinkle NULL checks all over
the evaluation code.

After fix, loading the bogon yields:
internal:0:0-0: Error: Malformed object (too many properties): '{}'.
internal:0:0-0: Error: could not decode binop rhs, '<<'.
internal:0:0-0: Error: Invalid mangle statement value
internal:0:0-0: Error: Parsing expr array at index 1 failed.
internal:0:0-0: Error: Parsing command array at index 3 failed.

Fixes: 0ac39384fd9e ("json: Accept more than two operands in binary expressions")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c                             | 14 ++++
 .../nft-j-f/binop_rhs_decode_error_crash      | 76 +++++++++++++++++++
 2 files changed, 90 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/binop_rhs_decode_error_crash

diff --git a/src/parser_json.c b/src/parser_json.c
index 04d762741e4a..9d5ec2275b30 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1210,11 +1210,25 @@ static struct expr *json_parse_binop_expr(struct json_ctx *ctx,
 
 	if (json_array_size(root) > 2) {
 		left = json_parse_primary_expr(ctx, json_array_get(root, 0));
+		if (!left) {
+			json_error(ctx, "Failed to parse LHS of binop expression.");
+			return NULL;
+		}
 		right = json_parse_primary_expr(ctx, json_array_get(root, 1));
+		if (!right) {
+			json_error(ctx, "Failed to parse RHS of binop expression.");
+			expr_free(left);
+			return NULL;
+		}
 		left = binop_expr_alloc(int_loc, thisop, left, right);
 		for (i = 2; i < json_array_size(root); i++) {
 			jright = json_array_get(root, i);
 			right = json_parse_primary_expr(ctx, jright);
+			if (!right) {
+				json_error(ctx, "Failed to parse RHS of binop expression.");
+				expr_free(left);
+				return NULL;
+			}
 			left = binop_expr_alloc(int_loc, thisop, left, right);
 		}
 		return left;
diff --git a/tests/shell/testcases/bogons/nft-j-f/binop_rhs_decode_error_crash b/tests/shell/testcases/bogons/nft-j-f/binop_rhs_decode_error_crash
new file mode 100644
index 000000000000..c5de17111ff6
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/binop_rhs_decode_error_crash
@@ -0,0 +1,76 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "VERSION",
+        "release_name": "RELEASE_NAME",
+        "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "meta": {
+                  "key": "oif"
+                }
+              },
+              "right": "lo"
+            }
+          },
+          {
+            "mangle": {
+              "key": {
+                "ct": {
+                  "key": "mark"
+                }
+              },
+              "value": {
+                "<<": [
+                  {
+                    "|": [
+                      {
+                        "meta": {
+                          "key": "mark"
+                        }
+                      },
+                      16
+                    ]
+                  },
+    {  },
+                  8
+                ]
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
-- 
2.48.1

