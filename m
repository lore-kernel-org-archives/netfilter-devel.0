Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECB31AAC9
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2025 10:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753095457; cv=none; b=XjuDPshPpfOGsbhGEwhV9lIIiT0eAGZZ43nIE92p043WNbrEu7fOz8kMSJ+wDWcNCf+422LkeeoF1t7Fy1umM+KkE0R/i74bBX63jf47ZcBq8IjIlqEyn8LRYYn1W0m49tuQ5+oBlUiDh13MXzZVWCfOiKVXUgvjnPG32c4KGCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753095457; c=relaxed/simple;
	bh=fW3WqkQLwB9o8vrwpS16qojHHJiykB49LEQN91MDsxA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JPhKkm2N5LPqwG/RRt8hvfOIF1OEqdlQ1CBA4LyZMmlANvlD42RaoyhA+/y6TO5VvRvsPGWczacnqrz8zrvbIyvvLRbj7UTK6hTkwYVJnVXLGFtvla1bThk2KAerYDwjbG3JWIe7JRU7OLOXAqJ85+dqS1YJ9XR1p/O7Idv5s2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 24EC8604EE; Mon, 21 Jul 2025 12:57:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: maps: check element data mapping matches set data definition
Date: Mon, 21 Jul 2025 12:57:07 +0200
Message-ID: <20250721105721.2512-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This change is similar to
7f4d7fef31bd ("evaluate: check element key vs. set definition")

but this time for data mappings.

The included bogon asserts with:
BUG: invalid data expression type catch-all set element
nft: src/netlink.c:596: __netlink_gen_data: Assertion `0' failed.

after:
internal:0:0-0: Error: Element mapping mismatches map definition, expected packet mark, not 'invalid'

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 20 +++++++++++
 .../nft-j-f/catchall_as_data_element_assert   | 34 +++++++++++++++++++
 2 files changed, 54 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/catchall_as_data_element_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index f7e97ef7ea10..c20a1d526c1e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2361,6 +2361,20 @@ static bool data_mapping_has_interval(struct expr *data)
 	return false;
 }
 
+static bool elem_data_compatible(const struct expr *set_data,
+				const struct expr *elem_data)
+{
+	if (elem_data->etype == EXPR_RANGE) {
+		/* EXPR_RANGE has invalid_type, use the lhs type.
+		 * It should be impossible to have a EXPR_RANGE where
+		 * lhs and rhs don't have the same dtype.
+		 */
+		return elem_data_compatible(set_data, elem_data->left);
+	}
+
+	return datatype_compatible(set_data->dtype, elem_data->dtype);
+}
+
 static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *mapping = *expr;
@@ -2417,6 +2431,12 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 				  "Object mapping data should be a value, not %s",
 				  expr_name(mapping->right));
 
+	if (set_is_datamap(set->flags) &&
+	    !elem_data_compatible(set->data, mapping->right))
+		return expr_error(ctx->msgs, mapping->right,
+				  "Element mapping mismatches map definition, expected %s, not '%s'",
+				  set->data->dtype->desc, mapping->right->dtype->desc);
+
 	mapping->flags |= EXPR_F_CONSTANT;
 	return 0;
 }
diff --git a/tests/shell/testcases/bogons/nft-j-f/catchall_as_data_element_assert b/tests/shell/testcases/bogons/nft-j-f/catchall_as_data_element_assert
new file mode 100644
index 000000000000..5b224f9bdcbf
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/catchall_as_data_element_assert
@@ -0,0 +1,34 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "1.1.1",
+        "release_name": "Commodore Bullmoose #2",
+        "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "t",
+        "handle": 1
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "m",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 1,
+        "map": "mark",
+        "elem": [
+          [
+            "1.2.3.4",
+            "*"
+          ]
+        ]
+      }
+    }
+  ]
+}
-- 
2.49.1

