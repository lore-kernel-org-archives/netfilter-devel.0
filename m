Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2366F2236F0
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 16:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753805923; cv=none; b=pnnIsgXOckqeeWr1b0yEbkUYpfnE7sCxT/3+cHAxh5ZHlLFjNlaXJm83M6pMbyBUYYd4kz60Rp4Sl2X9xyEhl8ILqnwbPluJLDxkjsn2NY6L1Bn+xDpKNYJQAVR2zOAtZdy2tNyeRACQps5tEGQ6WyKv/PHJT0u7H4nAOoogLlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753805923; c=relaxed/simple;
	bh=BGwHxsK56PcVrWbwdTbRHhGTJFSPzN38B2CfMOxNrBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGWkhCA5Gcn+jw81rF7Fcf+BXtwYn7t56XbsKLro9eu9PIrZ79r2fk4A/CykTxcoVcCZ+1tpbnLSQBpOL2hleDP7nFg1HF1uBXAhlqJbbuJoEYAlnU+GWE+t1sh3g652RbVAo4uZXohbDXRhj1Z4vwpSpjD+6p7M6bf0y4uGjug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ECEJm0U6; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ECEJm0U6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gpNPthFTuy0f1kWT5XbzW8g+IEQoHeO+2zGciP9G6Ac=; b=ECEJm0U6/DmZ5MDKW0hXjopQdH
	VYIWBy/CgwsH+tJE2sY9px6hz8nbmgzsNkke/WbEXoMPyevybJ/8Zbquja4gHw/ap8IhmYNmrNfm9
	2132zNK5DO44g15TroKSWCFq7FIZ7f4+4dZ3pYH1SA00vx85qNL7EMnXFleoaF49rp7TnAKleNruT
	IvIWh9fWPc2cbq6ttT9DXQ+pljO6/f+N2QX/jIhp2n+dRucNje9vqZ+Scj4B3M3b4McEzMml4lgPN
	lWuz/RpnPNuRItH9ahsSPZGp0rUrnWh2GuGebYvqLyNFWoaFr8dGGFg3AHFdsM2c82ge51khPv4QD
	wL/83vFw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ugn2D-000000005BR-3PpK;
	Tue, 29 Jul 2025 18:18:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 3/3] evaluate: Fix for 'meta hour' ranges spanning date boundaries
Date: Tue, 29 Jul 2025 18:18:32 +0200
Message-ID: <20250729161832.6450-4-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250729161832.6450-1-phil@nwl.cc>
References: <20250729161832.6450-1-phil@nwl.cc>
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

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1805
Fixes: 347039f64509e ("src: add symbol range expression to further compact intervals")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Add BZ link
- Describe expected values in nft.8
- Add test cases for "24:00", "23:59:60" and a range where upper
  boundary becomes 0:00 after conversion
- Fix JSON equivalents in py testsuite and shell testsuite expected
  results - these were leftovers from an earlier attempt at a fix
---
 doc/primary-expression.txt              |   3 +-
 src/evaluate.c                          |  25 +++-
 tests/py/any/meta.t                     |   9 ++
 tests/py/any/meta.t.json                | 182 ++++++++++++++++++++++++
 tests/py/any/meta.t.json.output         |  18 +++
 tests/py/any/meta.t.payload             |  51 +++++++
 tests/shell/testcases/listing/meta_time |  11 ++
 7 files changed, 291 insertions(+), 8 deletions(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 2266724e72598..d5495e2c86291 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -137,7 +137,8 @@ Day of week|
 Integer (8 bit) or string
 |hour|
 Hour of day|
-String
+String value in the form HH:MM or HH:MM:SS. Values are expected to be less than
+24:00, although for technical reasons, 23:59:60 is accepted, too.
 |====================
 
 .Meta expression specific types
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
index 3f0ef121a8c03..74e4ba28343d9 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -218,6 +218,15 @@ meta hour "17:00:00" drop;ok;meta hour "17:00" drop
 meta hour "17:00:01" drop;ok
 meta hour "00:00" drop;ok
 meta hour "00:01" drop;ok
+meta hour "01:01" drop;ok
+meta hour "02:02" drop;ok
+meta hour "03:03" drop;ok
+meta hour "24:00" drop;fail
+meta hour "23:59:60" drop;ok;meta hour "00:00" drop
+meta hour "00:00"-"02:02" drop;ok
+meta hour "01:01"-"03:03" drop;ok
+meta hour "02:02"-"04:04" drop;ok
+meta hour "21:00"-"02:00" drop;ok
 time < "2022-07-01 11:00:00" accept;ok;meta time < "2022-07-01 11:00:00" accept
 time > "2022-07-01 11:00:00" accept;ok;meta time > "2022-07-01 11:00:00" accept
 
diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index 65590388bb80d..8dcd1e13243de 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -2723,6 +2723,188 @@
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
+# meta hour "24:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "24:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "23:59:60" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "23:59:60"
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
+            "op": "in",
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
+            "op": "in",
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
+# meta hour "21:00"-"02:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "in",
+            "right": {
+                "range": [
+                    "21:00",
+                    "02:00"
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
index d46935dee513d..8f4d597a5034e 100644
--- a/tests/py/any/meta.t.json.output
+++ b/tests/py/any/meta.t.json.output
@@ -646,3 +646,21 @@
     }
 ]
 
+# meta hour "23:59:60" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "00:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 52c3efa84eb5d..3f9f3f22aecf9 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1052,6 +1052,57 @@ ip meta-test input
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
+# meta hour "23:59:60" drop
+ip test-ip4 input
+  [ meta load hour => reg 1 ]
+  [ cmp eq reg 1 0x00013560 ]
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
+# meta hour "21:00"-"02:00" drop
+ip test-ip4 input
+  [ meta load hour => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ range neq reg 1 0x00000000 0x300b0100 ]
+  [ immediate reg 0 drop ]
+
 # time < "2022-07-01 11:00:00" accept
 ip test-ip4 input
   [ meta load time => reg 1 ]
diff --git a/tests/shell/testcases/listing/meta_time b/tests/shell/testcases/listing/meta_time
index 96a9d5570fd14..0f5bdec942f0a 100755
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
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 0 0 3 0 >> "$TMP1"
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 1 0 4 0 >> "$TMP1"
+
+check_decode UTC-2
-- 
2.49.0

