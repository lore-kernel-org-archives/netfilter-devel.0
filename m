Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44023224F0
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 15:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743088655; cv=none; b=lMfZd5uhOn8hZmlT9TT5RoMGf+cXU2atTbegJgpsbwSvqNMgW52j1JRLxZ4nckhCx7mXBltRQFsSI9nNzx1t8RFJY3gMGJYGUmYhKXu4vZ9Ucn5wssv44imw71cz+E1t2tODybnnKjjtoZy0KXnJaJcN9zryXtpKAEY0UF0WxXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743088655; c=relaxed/simple;
	bh=wwJD9tP3Sgt1ioDNyiklzdy0jlpfgl5I+YoZi50s9X0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NtIYlB6SMc9uVD5NyFGNrevsY5eU1QQ09EKZFR1LuELcVAyq+3Eig8VRMNbPOQ+Awp2UKYLcaUGasMT9DwUxBSRzEfvtCP/HAkETwgqgMjSs14l4aqKRl534gyYcmeYnSw4UUMenN8ZqbOzah+mZ/m9lwqRiqlD8I1tYBBMOTRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1txoz5-0007Zj-6C; Thu, 27 Mar 2025 16:17:31 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] expression: don't try to import empty string
Date: Thu, 27 Mar 2025 16:17:11 +0100
Message-ID: <20250327151720.17204-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bogon will trigger the assertion in mpz_import_data:
src/expression.c:418: constant_expr_alloc: Assertion `(((len) + (8) - 1) / (8)) > 0' failed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c                              |  2 +-
 .../bogons/nft-j-f/constant_expr_alloc_assert | 38 +++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/constant_expr_alloc_assert

diff --git a/src/expression.c b/src/expression.c
index 156a66eb37f0..f230f5ad8935 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -494,7 +494,7 @@ struct expr *constant_expr_alloc(const struct location *loc,
 	expr->flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
 
 	mpz_init2(expr->value, len);
-	if (data != NULL)
+	if (data != NULL && len)
 		mpz_import_data(expr->value, data, byteorder,
 				div_round_up(len, BITS_PER_BYTE));
 
diff --git a/tests/shell/testcases/bogons/nft-j-f/constant_expr_alloc_assert b/tests/shell/testcases/bogons/nft-j-f/constant_expr_alloc_assert
new file mode 100644
index 000000000000..9c40030212ef
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/constant_expr_alloc_assert
@@ -0,0 +1,38 @@
+{
+  "nftables": [
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
+        "name": "testchain",
+        "handle": 0
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "testmap",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "verdict",
+        "elem": [
+          [
+            {
+              "jump": {
+                "target": ""
+              }
+            }
+          ]
+        ]
+      }
+    }
+  ]
+}
-- 
2.48.1

