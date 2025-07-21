Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55480298255
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2025 11:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753096212; cv=none; b=DUY0Wobtq1SukE9OEAUq2OlCS+9MCYg4a+EMykOA6nGx5auiDUqfKzL2BzyvHExBfoB3zLos2F0lvOrqviqlSyUDo6inu8yBJK1B8q2bXL3a1BiPdxBpuyVsrmeaXdq7zVPgrb3bc1ZNLxYcId8X4JiGMx7HPaalBhdInP/QvxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753096212; c=relaxed/simple;
	bh=iloNqkZ+XORd7KGkFBGwNN9qSa4isg6ZuGu9tm7QqOk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PvXqR0EEvaf0XqiJDgi0xrJxMRTYHjNZacYbYh8OYLhinYQTWKjkE/fsX+edQ8ah29AxdmhdCH3uz2iMpMYdP6FtHsoRo59JVsqup1MExxJ7Fsd073E7pp412ja2+StJJ0hP7jG0F3/51SIN//MO2mrIJfdkWH4fGRxVe+nW5bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 13F0A60555; Mon, 21 Jul 2025 13:10:07 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_json: reject non-concat expression
Date: Mon, 21 Jul 2025 13:09:55 +0200
Message-ID: <20250721110959.10322-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before "src: detach set, list and concatenation expression layout":
internal:0:0-0: Error: Concatenation with 0 elements is illegal

After this change, expr->size access triggers assert() failure, add
explicit test for etype to avoid this and error out:

internal:0:0-0: Error: Expected concat element, got symbol.

Fixes: e0d92243be1c ("src: detach set, list and concatenation expression layout")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c                             |  7 ++++
 .../nft-j-f/concat_is_not_concat_assert       | 39 +++++++++++++++++++
 2 files changed, 46 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/concat_is_not_concat_assert

diff --git a/src/parser_json.c b/src/parser_json.c
index bd865de59007..a6f142c68756 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1286,11 +1286,18 @@ static struct expr *json_parse_binop_expr(struct json_ctx *ctx,
 
 static struct expr *json_check_concat_expr(struct json_ctx *ctx, struct expr *e)
 {
+	if (e->etype != EXPR_CONCAT) {
+		json_error(ctx, "Expected concatenation, got %s", expr_name(e));
+		goto err_free;
+	}
+
 	if (expr_concat(e)->size >= 2)
 		return e;
 
 	json_error(ctx, "Concatenation with %d elements is illegal",
 		   expr_concat(e)->size);
+
+err_free:
 	expr_free(e);
 	return NULL;
 }
diff --git a/tests/shell/testcases/bogons/nft-j-f/concat_is_not_concat_assert b/tests/shell/testcases/bogons/nft-j-f/concat_is_not_concat_assert
new file mode 100644
index 000000000000..bdee0351c36b
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/concat_is_not_concat_assert
@@ -0,0 +1,39 @@
+{
+  "nftables": [
+    {
+  "metainfo": {
+"ver": "ION",
+    "rame": "RAME",
+    "json_schema_version": 1
+  }
+    },
+    {
+  "table": { "family": "ip", "name": "filter",
+    "le": 0
+  }
+    },
+    {
+  "set": {
+    "family": "ip",
+    "name": "test_set",
+    "table": "filter",
+    "type": [
+  "iface_index",   "ether_addr",   "ipv4_addr"
+    ],
+    "he": 0,
+    "flags": "interval",
+"elem": [
+  {
+    "elem": {
+  "val": {
+    "concat": [
+ "10.1.2.3"
+    ]   },
+  "comment": "90"
+}
+  }
+    ]
+  }
+}
+  ]
+}
-- 
2.49.1

