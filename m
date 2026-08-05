Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0CF4854F1
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785947968; cv=none; b=fGJAJ3gS5TLKoebMKf+SZsVVMCqkQH7lYcTr2SSxNwngxVxTx8JlB4Sndf1sO0hTh6baOu+RX5eFaE49pp2iavpH7B2esSPCBFsrQe+/cjtEyKerx59bj9+myGO6cIUORfoNrx/N27CLFstKm+l8wYFVlHP/sViPTRlt70fhXI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785947968; c=relaxed/simple;
	bh=HXnp9SmZvm1woxBd6B4lMPM0n0r0458iyqfeja6u7SA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=eyfEi5ZZOIyzYi21CX0LfbjYfO9odSlx2AQxuxGr2uBC38ZVQLN5FFJbiIleGSdfGsxZdEEQRxASLX8mVKU26RBC3+fUD6qBFP/esnorI6YWXrmqaS2jEMjCq6gtmtImKj1FHm7LDBK2sjd6vtfFbpbvOt9tzc91DyXefPFXvCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Jqc3c4CR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Jqc3c4CR"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2B47A60193
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 18:39:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785947963;
	bh=+8UQZnu50kyu8NCylv8kFOnPIjlbHMmdOc/tvHGlEfA=;
	h=From:To:Subject:Date:From;
	b=Jqc3c4CRSPS4H6GFbVeF+rjLWW7VblbFTOXDMfRbcbxZU7v43Ghn/dqwGAjC/bcQ1
	 kRPGtDgCmA0ndex6XYbGafrBAjCAkAl1dbcd6NJ5XSGM3XBRCJsYKbMB/ZeXnUJGMC
	 GyT1tlE4cT/7UHEP5XvXCvplpQylLt2sbBPqKsaYQpwA5ZI2nZ8flwGSGVmXq8/oTy
	 L9X9lcgM56qEcbgOL3RAAE92S89rJumkJaVWpJsQ8Gk/d5TxnePWxtyWnPFutt/DwM
	 tGiYhIi6W30prRp4oRv+o11wRBBQUXEvYT2fW8Dx5MgKzE74NOAW3yjcsFxNimTWg1
	 qXBioM/AAAY8w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 1/3] mergesort: use lhs expression when sorting concatenation
Date: Wed,  5 Aug 2026 18:39:18 +0200
Message-ID: <20260805163920.238975-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, concatenations using binary operations hit an assertion.

 # cat ruleset.nft
 table inet t {
        chain c {
                tcp flags . tcp dport vmap { syn | ack . 80 : drop, ack . 90 : accept }
        }
 }
 # nft -f ruleset.nft
 # nft list ruleset
 nft: src/mergesort.c:23: concat_expr_msort_value: Assertion `ilen > 0' failed.
 Aborted

Inspect the left-hand size of the expression for the merge sorting.

This patch includes a new tests/shell unit file.

Fixes: 741a06ac15d2 ("mergesort: find base value expression type via recursion")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1841
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: add tests/shell unit file.

 src/mergesort.c                               |  38 +++-
 .../maps/dumps/vmap_concat_binop.json-nft     | 196 ++++++++++++++++++
 .../maps/dumps/vmap_concat_binop.nft          |  13 ++
 tests/shell/testcases/maps/vmap_concat_binop  |  19 ++
 4 files changed, 262 insertions(+), 4 deletions(-)
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_concat_binop.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_concat_binop.nft
 create mode 100755 tests/shell/testcases/maps/vmap_concat_binop

diff --git a/src/mergesort.c b/src/mergesort.c
index 2e8ddd22f813..f4b4d56b579c 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -12,16 +12,46 @@
 #include <gmputil.h>
 #include <list.h>
 
+static mpz_srcptr concat_expr_msort_value_one(const struct expr *expr,
+					      unsigned int *i_len)
+{
+	mpz_srcptr i_value;
+
+	switch (expr->etype) {
+	case EXPR_BINOP:
+	case EXPR_MAPPING:
+	case EXPR_RANGE:
+		i_value = expr->left->value;
+		*i_len = expr->left->len;
+		break;
+	case EXPR_VALUE:
+		i_value = expr->value;
+		*i_len = expr->len;
+		break;
+	case EXPR_RANGE_VALUE:
+		i_value = expr->range.low;
+		*i_len = expr->len;
+		break;
+	default:
+		BUG("Unknown expression %s", expr_name(expr));
+	}
+
+	*i_len = div_round_up(*i_len, BITS_PER_BYTE);
+
+	return i_value;
+}
+
 static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
 {
-	unsigned int len = 0, ilen;
+	unsigned int len = 0, i_len;
 	const struct expr *i;
+	mpz_srcptr i_value;
 	char data[512];
 
 	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
-		ilen = div_round_up(i->len, BITS_PER_BYTE);
-		mpz_export_data(data + len, i->value, BYTEORDER_BIG_ENDIAN, ilen);
-		len += ilen;
+		i_value = concat_expr_msort_value_one(i, &i_len);
+		mpz_export_data(data + len, i_value, BYTEORDER_BIG_ENDIAN, i_len);
+		len += i_len;
 	}
 
 	mpz_import_data(value, data, BYTEORDER_BIG_ENDIAN, len);
diff --git a/tests/shell/testcases/maps/dumps/vmap_concat_binop.json-nft b/tests/shell/testcases/maps/dumps/vmap_concat_binop.json-nft
new file mode 100644
index 000000000000..502648f53dec
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_concat_binop.json-nft
@@ -0,0 +1,196 @@
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
+        "name": "x",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "z",
+        "handle": 0
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "y",
+        "table": "x",
+        "type": {
+          "typeof": {
+            "concat": [
+              {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "flags"
+                }
+              },
+              {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "dport"
+                }
+              }
+            ]
+          }
+        },
+        "handle": 0,
+        "map": "verdict",
+        "elem": [
+          [
+            {
+              "concat": [
+                {
+                  "|": [
+                    "syn",
+                    "ack"
+                  ]
+                },
+                80
+              ]
+            },
+            {
+              "accept": null
+            }
+          ],
+          [
+            {
+              "concat": [
+                "rst",
+                100
+              ]
+            },
+            {
+              "drop": null
+            }
+          ],
+          [
+            {
+              "concat": [
+                "ack",
+                90
+              ]
+            },
+            {
+              "drop": null
+            }
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "z",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "tcp",
+                      "field": "flags"
+                    }
+                  },
+                  {
+                    "payload": {
+                      "protocol": "tcp",
+                      "field": "dport"
+                    }
+                  }
+                ]
+              },
+              "data": "@y"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "z",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "tcp",
+                      "field": "flags"
+                    }
+                  },
+                  {
+                    "payload": {
+                      "protocol": "tcp",
+                      "field": "dport"
+                    }
+                  }
+                ]
+              },
+              "data": {
+                "set": [
+                  [
+                    {
+                      "concat": [
+                        {
+                          "|": [
+                            "syn",
+                            "ack"
+                          ]
+                        },
+                        80
+                      ]
+                    },
+                    {
+                      "accept": null
+                    }
+                  ],
+                  [
+                    {
+                      "concat": [
+                        "rst",
+                        100
+                      ]
+                    },
+                    {
+                      "drop": null
+                    }
+                  ],
+                  [
+                    {
+                      "concat": [
+                        "ack",
+                        90
+                      ]
+                    },
+                    {
+                      "drop": null
+                    }
+                  ]
+                ]
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/vmap_concat_binop.nft b/tests/shell/testcases/maps/dumps/vmap_concat_binop.nft
new file mode 100644
index 000000000000..92e50a4cbcc1
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_concat_binop.nft
@@ -0,0 +1,13 @@
+table ip x {
+	map y {
+		typeof tcp flags . tcp dport : verdict
+		elements = { syn | ack . 80 : accept,
+			     rst . 100 : drop,
+			     ack . 90 : drop }
+	}
+
+	chain z {
+		tcp flags . tcp dport vmap @y
+		tcp flags . tcp dport vmap { syn | ack . 80 : accept, rst . 100 : drop, ack . 90 : drop }
+	}
+}
diff --git a/tests/shell/testcases/maps/vmap_concat_binop b/tests/shell/testcases/maps/vmap_concat_binop
new file mode 100755
index 000000000000..fc6e9584740b
--- /dev/null
+++ b/tests/shell/testcases/maps/vmap_concat_binop
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+        map y {
+                typeof tcp flags . tcp dport : verdict
+                elements = { syn | ack . 80 : accept,
+                             ack . 90 : drop,
+			     rst . 100 : drop }
+        }
+
+        chain z {
+                tcp flags . tcp dport vmap @y
+                tcp flags . tcp dport vmap { syn | ack . 80 : accept, ack . 90 : drop, rst . 100 : drop }
+        }
+}"
+
+$NFT -f - <<< $RULESET
-- 
2.47.3

