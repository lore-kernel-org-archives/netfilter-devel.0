Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAEE224B04
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753914352; cv=none; b=tRNAS6ZQF386KxgLG4kvUzFqFVguwiWrvxCbZSebP/VOPX+W4v+c7pzKwStPlYD60enDD9sfHt4KKbhnMblZT1yZH2ij5+Ho0EX7Y8HlxXdEUgSTaHVd+H/8iYwSkgyH5CQ5Gd1FwGUTbitUsMfzzyXKHusL0xS5ie+UxvfzeuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753914352; c=relaxed/simple;
	bh=+sabVDIBt/cuYEegAZylII9VGTRnphZX+p/dzNw+8L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAvfGhVd1oPJO6JWj7BZFDAgvsd4orxcx0Up6NGYymxm3cmoaAo3B69ppYYKs+0z1E8HAcCAx7jdkfjj0RMpYXbYUf2ULWBLdVivo29rGKeTgJXz6q8KcYKkY376sEE39d84GLQFv25omgs64SmEcpcG0ifKzKsRCxj8gvrMJgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qbEGZVVq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qbEGZVVq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FHkzi3o1amI2eqYIVYt9Wese0u8fciQ6VgCSNhXLGYw=; b=qbEGZVVqJtHKo+bGaOVXH+Xv4y
	lMr5evred6cfIAvQoHNJK7dPShC6FMnEsoL/tLOb3pH+Tw61v6BKa0+zxbemc1teWonIZsZRCfu9f
	zbVUaPIxCAPSjEV5HieizkhlpF9dJJUT7EWzcU+Ke4fHByFfA5XMs7H2ilKTs8Y7so/Ug/HWB6xAa
	isTRgOdZj4DDIZfIwPRP1vCTTgENkXX9VIPaOcPXx55E+NynSN/p1VoaKnXuYEMpWGryC6RvBmcLw
	r2PXxAIsK9x5A+WQhAJEMazcDnuhqWth83KnwEaSJnLuKgZZ8SYjybBkVpxSf0Z3T2OtzHYkxb7MB
	63k1bNAA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhFF0-000000004Rj-1krU;
	Thu, 31 Jul 2025 00:25:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 3/3] evaluate: Fix for 'meta hour' ranges spanning date boundaries
Date: Thu, 31 Jul 2025 00:25:36 +0200
Message-ID: <20250730222536.786-4-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250730222536.786-1-phil@nwl.cc>
References: <20250730222536.786-1-phil@nwl.cc>
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

Perform the conditional match and op inversion with the new RHS
expression type as well after expanding it so values are comparable.
Since this replaces the whole range expression, make it replace the
relational's RHS entirely.

While at it extend testsuites to cover these corner-cases.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1805
Fixes: 347039f64509e ("src: add symbol range expression to further compact intervals")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Retain range adjustment for EXPR_RANGE type RHS as seen when using
  variables in nft input
- Extend shell test case to cover for the above

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
 tests/shell/testcases/listing/meta_time |  30 ++++
 7 files changed, 312 insertions(+), 6 deletions(-)

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
index 9c90590860585..a43e052865bd8 100644
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
@@ -2772,7 +2780,14 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 
 	pctx = eval_proto_ctx(ctx);
 
-	if (rel->right->etype == EXPR_RANGE && lhs_is_meta_hour(rel->left)) {
+	if (lhs_is_meta_hour(rel->left) &&
+	    (rel->right->etype == EXPR_RANGE ||
+	     rel->right->etype == EXPR_RANGE_SYMBOL)) {
+		if (rel->right->etype == EXPR_RANGE_SYMBOL) {
+			range = symbol_range_expand(rel->right);
+			expr_free(rel->right);
+			rel->right = range;
+		}
 		ret = __expr_evaluate_range(ctx, &rel->right);
 		if (ret)
 			return ret;
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
index 96a9d5570fd14..91f94bdb17432 100755
--- a/tests/shell/testcases/listing/meta_time
+++ b/tests/shell/testcases/listing/meta_time
@@ -65,3 +65,33 @@ printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 5 0 16 0 >> "$TMP1"
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
+
+$NFT flush chain t c
+TZ=UTC-2 $NFT --debug=eval -f - <<EOF
+define midnight="00:00"
+define threeam="03:00"
+table t {
+	chain c {
+		meta hour \$midnight - "03:00"
+		meta hour 00:00 - \$threeam
+		meta hour \$midnight - \$threeam
+	}
+}
+EOF
+
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 0 0 3 0 > "$TMP1"
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 0 0 3 0 >> "$TMP1"
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 0 0 3 0 >> "$TMP1"
+
+check_decode UTC-2
-- 
2.49.0

