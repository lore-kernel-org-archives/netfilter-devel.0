Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A432E3719
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2025 21:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753480052; cv=none; b=Uz3pHJLgt3X34z40XSSjWfG1krmKkQsfYLdmJRRUv4qY+9s+H4Ht+Uv1L+61d4/oCLHzmcqpD6l4BKAA9G0Y0aRQrBODkLUQdw0amwSxCmTpO9cXBiMb3F6gWwHkJ2uwOtxIAQEto9+MyTPUM8WdzIXAi5VYaV6WJBRXMm9HwnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753480052; c=relaxed/simple;
	bh=rFwifNLq1m2MIgMACO+mM6ZZU5gsFc45HBb/c44OeQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LaX/0lznbxAND3dDlgxm+IDB4lhIGMF1OTohoSxxQw6pY3/NCi6xQIDZw2FlTLcHYcUd0XxOYZ4Vf8x2se6HBh+XJCwoUpytoYQNy+4gs96/7JX7W9yxxhuc1n7MKOggJRwQNYQ5V7EALMRSMPJgQNIPVRBPWWm6MQoCUAeP6rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZBAUe3il; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZBAUe3il"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fYf2sc+sDAZhQkMMECSyxr7MZBVxvLK9hyxbWu8t6Mc=; b=ZBAUe3ilNjgBZx8y55KKAV1Jtu
	oGW67J1fAcLcjvF/0MYsWTYGZwUXBsWgiycwpszQUE5Q6I6ZQr4Lsheu1flcwRdk9AjSKo25jJlRK
	yZ91HYtUvFTMXiEi2Uj3BzK3seDqYIzbaXLPzcUaOgcU6l6tligo6i0Prf6H9Y6PZmGilYuWlEDKL
	WOzzWTvvAI5Q6ET/5YxTTVrjYDMvYnyNRNyLxurWmu0VQL0SWLmr93Yt0tMNJocDmmsCO8B3Ivxsv
	sXuMr9ualhy1zYed5YeTxs8p+acyeYGUKDDGiherxadfvuOreIIogDSNyAvBHHtanpDLH+HabwLMp
	Qf7itgzQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ufPwD-000000004EE-1AaS;
	Fri, 25 Jul 2025 23:26:45 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] evaluate: Fix for 'meta hour' ranges spanning date boundaries
Date: Fri, 25 Jul 2025 23:26:40 +0200
Message-ID: <20250725212640.26537-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduction of EXPR_RANGE_SYMBOL type inadvertently disabled sanitizing
of meta hour ranges where the lower boundary has a higher value than the
upper boundary. This may happen outside of user control due to the fact
that given ranges are converted to UTC which is the kernel's native
timezone.

Restore the conditional match and op inversion by matching on the new
RHS expression type and also expand it so values are comparable. Since
this replaces the whole range expression, make it replace the
relational's RHS entirely.

While at it extend testsuites to cover these corner-cases.

Fixes: 347039f64509e ("src: add symbol range expression to further compact intervals")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c                          |  25 +++--
 tests/py/any/meta.t                     |   6 ++
 tests/py/any/meta.t.json                | 123 ++++++++++++++++++++++++
 tests/py/any/meta.t.json.output         |  66 +++++++++++++
 tests/py/any/meta.t.payload             |  38 ++++++++
 tests/shell/testcases/listing/meta_time |  11 +++
 6 files changed, 262 insertions(+), 7 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 9c90590860585..b67c81f01c0e2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2421,10 +2421,9 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
-static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
+static struct expr *symbol_range_expand(struct expr *expr)
 {
-	struct expr *left, *right, *range, *constant_range;
-	struct expr *expr = *exprp;
+	struct expr *left, *right;
 
 	/* expand to symbol and range expressions to consolidate evaluation. */
 	left = symbol_expr_alloc(&expr->location, expr->symtype,
@@ -2433,7 +2432,16 @@ static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
 	right = symbol_expr_alloc(&expr->location, expr->symtype,
 				  (struct scope *)expr->scope,
 				  expr->identifier_range[1]);
-	range = range_expr_alloc(&expr->location, left, right);
+	return range_expr_alloc(&expr->location, left, right);
+}
+
+static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *left, *right, *range, *constant_range;
+	struct expr *expr = *exprp;
+
+	/* expand to symbol and range expressions to consolidate evaluation. */
+	range = symbol_range_expand(expr);
 
 	if (expr_evaluate(ctx, &range) < 0) {
 		expr_free(range);
@@ -2772,12 +2780,15 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 
 	pctx = eval_proto_ctx(ctx);
 
-	if (rel->right->etype == EXPR_RANGE && lhs_is_meta_hour(rel->left)) {
-		ret = __expr_evaluate_range(ctx, &rel->right);
+	if (lhs_is_meta_hour(rel->left) &&
+	    rel->right->etype == EXPR_RANGE_SYMBOL) {
+		range = symbol_range_expand(rel->right);
+		ret = __expr_evaluate_range(ctx, &range);
 		if (ret)
 			return ret;
 
-		range = rel->right;
+		expr_free(rel->right);
+		rel->right = range;
 
 		/*
 		 * We may need to do this for proper cross-day ranges,
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 3f0ef121a8c03..0d0c268636705 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -218,6 +218,12 @@ meta hour "17:00:00" drop;ok;meta hour "17:00" drop
 meta hour "17:00:01" drop;ok
 meta hour "00:00" drop;ok
 meta hour "00:01" drop;ok
+meta hour "01:01" drop;ok
+meta hour "02:02" drop;ok
+meta hour "03:03" drop;ok
+meta hour "00:00"-"02:02" drop;ok
+meta hour "01:01"-"03:03" drop;ok
+meta hour "02:02"-"04:04" drop;ok
 time < "2022-07-01 11:00:00" accept;ok;meta time < "2022-07-01 11:00:00" accept
 time > "2022-07-01 11:00:00" accept;ok;meta time > "2022-07-01 11:00:00" accept
 
diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index 65590388bb80d..b11aae86396c9 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -2723,6 +2723,129 @@
     }
 ]
 
+# meta hour "01:01" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "01:01"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "02:02" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "02:02"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "03:03" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "03:03"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "00:00"-"02:02" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": {
+		"range": [
+		    "00:00",
+		    "02:02"
+		]
+	    }
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "01:01"-"03:03" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": {
+		"range": [
+		    "01:01",
+		    "03:03"
+		]
+            }
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "02:02"-"04:04" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": {
+                "range": [
+                    "02:02",
+                    "04:04"
+                ]
+            }
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
 # time < "2022-07-01 11:00:00" accept
 [
     {
diff --git a/tests/py/any/meta.t.json.output b/tests/py/any/meta.t.json.output
index d46935dee513d..ecb211335b576 100644
--- a/tests/py/any/meta.t.json.output
+++ b/tests/py/any/meta.t.json.output
@@ -646,3 +646,69 @@
     }
 ]
 
+# meta hour "00:00"-"02:02" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "range": [
+                            "02:00",
+                            "02:02"
+                        ]
+                    },
+                    {
+                        "range": [
+                            "00:00",
+                            "02:00"
+                        ]
+                    }
+                ]
+            }
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "01:01"-"03:03" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "range": [
+                            "02:00",
+                            "03:03"
+                        ]
+                    },
+                    {
+                        "range": [
+                            "01:01",
+                            "02:00"
+                        ]
+                    }
+                ]
+            }
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 52c3efa84eb5d..2abb44ea2e868 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1052,6 +1052,44 @@ ip meta-test input
   [ cmp eq reg 1 0x0001359c ]
   [ immediate reg 0 drop ]
 
+# meta hour "01:01" drop
+ip test-ip4 input
+  [ meta load hour => reg 1 ]
+  [ cmp eq reg 1 0x000143ac ]
+  [ immediate reg 0 drop ]
+
+# meta hour "02:02" drop
+ip test-ip4 input
+  [ meta load hour => reg 1 ]
+  [ cmp eq reg 1 0x00000078 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "03:03" drop
+ip test-ip4 input
+  [ meta load hour => reg 1 ]
+  [ cmp eq reg 1 0x00000ec4 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "00:00"-"02:02" drop
+  [ meta load hour => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ range neq reg 1 0x78000000 0x60350100 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "01:01"-"03:03" drop
+ip test-ip4 input
+  [ meta load hour => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ range neq reg 1 0xc40e0000 0xac430100 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "02:02"-"04:04" drop
+ip test-ip4 input
+  [ meta load hour => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ range eq reg 1 0x78000000 0x101d0000 ]
+  [ immediate reg 0 drop ]
+
 # time < "2022-07-01 11:00:00" accept
 ip test-ip4 input
   [ meta load time => reg 1 ]
diff --git a/tests/shell/testcases/listing/meta_time b/tests/shell/testcases/listing/meta_time
index 96a9d5570fd14..61314a99c6498 100755
--- a/tests/shell/testcases/listing/meta_time
+++ b/tests/shell/testcases/listing/meta_time
@@ -65,3 +65,14 @@ printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 5 0 16 0 >> "$TMP1"
 printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 6 0 17 0 >> "$TMP1"
 
 check_decode EADT
+
+$NFT flush chain t c
+TZ=UTC-2 $NFT add rule t c meta hour "00:00"-"01:00"
+TZ=UTC-2 $NFT add rule t c meta hour "00:00"-"03:00"
+TZ=UTC-2 $NFT add rule t c meta hour "01:00"-"04:00"
+
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 0 0 1 0 > "$TMP1"
+printf "\t\tmeta hour { \"02:00\"-\"03:00\", \"00:00\"-\"02:00\" }\n" >> "$TMP1"
+printf "\t\tmeta hour { \"02:00\"-\"04:00\", \"01:00\"-\"02:00\" }\n" >> "$TMP1"
+
+check_decode UTC-2
-- 
2.49.0

