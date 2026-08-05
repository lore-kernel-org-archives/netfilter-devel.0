Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CDD485515
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 16:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785947968; cv=none; b=OPA9JWTBqU9NJT0wjavKG3dZNeYTL1bBudUTspjcVnTfJTguIRtBKcUN4HCwhJCbk6aa2nUO/F6ej7AYdfB7mrFuKaDpih2K82judOabYhTTt0gv0vD0x38jiNdiMP+SJOodKiihIe8JtbzmJrvkP2jgodM6pi5M1BIwiLKtkB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785947968; c=relaxed/simple;
	bh=1mwl4+zdOPOFCyQokXzc5bXKkRPtwI/sd23cc7Ljq7U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwMuHCVb8lF1bedIabtQCDt1WEy+ZCYnQWkLKTou4fuB7mt3fousJSbdQ2N1f+RBz0pFkLUHFSr/vFF+CBAPXsWOr2lgjZcbXeh9K04ftDVb1PRMPWPgNsM7zdl+Pfm9dFVbuPFbyd4p4Rmmrmaiuk5GdDdNzhi+HhZ3jgc+6gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=I8EYydEn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="I8EYydEn"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 45E3C60295
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 18:39:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785947964;
	bh=Lggl3u1B+ajwFM3zqIlI1QMMSXEmfE6IdV/iggBs2fU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=I8EYydEnEJwLcbM+9H9EXRZLhVKokk+xOLivhz9KE6nheA8tXWmbposv+wUlagMl2
	 EhAK8N8Gg72Vx4tbTfbKthNezW2+cr6hpdOgY+N2DynsuZUeeE7+/rfn6Rj69S7e4o
	 kA1/NNYkx24g31Ojt5Di0GDxo0qDieO9sNnuhRzmXvnOh7JcwrTF0nSLvS4cbHejYA
	 uOs2vFqNRu0y65p994DzJCau+VeMszYoWMnDiteFPdlNH3DW5ll6G2u+Mpvs6aMIay
	 0TTMb16GX70XSMnXFF1F1+73G/gQJRtjSI6BHBl7wFMGQhwSGpiBEw0tOPEINMb3ID
	 03GeJUXpo27NQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] segtree: basic support for binary operations in concatenated set ranges
Date: Wed,  5 Aug 2026 18:39:19 +0200
Message-ID: <20260805163920.238975-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805163920.238975-1-pablo@netfilter.org>
References: <20260805163920.238975-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use of tcp flags in concatenated set ranges such as (note the 100-110
range):

 table ip x {
       chain y {
             tcp flags . tcp dport vmap { syn | ack . 80 : accept, ack . 90 : drop, rst . 100-110 : drop
       }
 }

is broken when listing the ruleset:

AddressSanitizer:DEADLYSIGNAL
=================================================================
==218685==ERROR: AddressSanitizer: SEGV on unknown address 0x50b000029798 (pc 0x7f8318b8fac0 bp 0x7ffd080a4310 sp 0x7ffd080a4198 T0)
==218685==The signal is caused by a READ memory access.
    #0 0x7f8318b8fac0 in __gmpz_cmp (/lib/x86_64-linux-gnu/libgmp.so.10+0x19ac0) (BuildId: dff5c2156ec812613c5e4431005c576b212dd323)
    #1 0x7f83192fbc3f in concat_range_aggregate src/segtree.c:404
    #2 0x7f8319240889 in netlink_list_setelems src/netlink.c:1774
    #3 0x7f8319115fdd in cache_init_objects src/cache.c:1189
    #4 0x7f8319116f10 in nft_cache_init src/cache.c:1266
    #5 0x7f831911772b in nft_cache_update src/cache.c:1325
    #6 0x7f83191eac34 in nft_evaluate src/libnftables.c:580
    #7 0x7f83191eb8b6 in nft_run_cmd_from_buffer src/libnftables.c:638
    #8 0x558baf3bc403 in main src/main.c:538

add basic support so it works with tcp flags, add a new assertion to
crash safely to ensure expression type is EXPR_VALUE before access
when trying to compose the range (this code only supports EXPR_VALUE
when building a range expression at this stage) and a new test.

This patch includes a new tests/shell unit file.

Fixes: 8ac2f3b2fca3 ("src: Add support for concatenated set ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c                                 |  27 ++-
 .../dumps/vmap_concat_range_binary.json-nft   | 209 ++++++++++++++++++
 .../maps/dumps/vmap_concat_range_binary.nft   |  14 ++
 .../testcases/maps/vmap_concat_range_binary   |  22 ++
 4 files changed, 271 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_concat_range_binary.json-nft
 create mode 100755 tests/shell/testcases/maps/dumps/vmap_concat_range_binary.nft
 create mode 100755 tests/shell/testcases/maps/vmap_concat_range_binary

diff --git a/src/segtree.c b/src/segtree.c
index a721078cfa59..c8a7a3541ac3 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -362,6 +362,29 @@ static int range_mask_len(const mpz_t start, const mpz_t end, unsigned int len)
 	return ret;
 }
 
+static int concat_expr_cmp(const struct expr *r1, const struct expr *r2)
+{
+	int ret;
+
+	assert(r1->etype == r2->etype);
+
+	switch (r1->etype) {
+	case EXPR_BINOP:
+		assert(r1->op == r2->op);
+		ret = 0;
+		ret = mpz_cmp(r1->left->value, r2->left->value);
+		ret |= mpz_cmp(r1->right->value, r2->right->value);
+		break;
+	case EXPR_VALUE:
+		ret = mpz_cmp(r1->value, r2->value);
+		break;
+	default:
+		BUG("unexpected expression %s", expr_name(r1->key));
+	}
+
+	return ret;
+}
+
 /* Given a set with two elements (start and end), transform them into a
  * concatenation of ranges. That is, from a list of start expressions and a list
  * of end expressions, form a list of start - end expressions.
@@ -401,11 +424,13 @@ void concat_range_aggregate(struct expr *set)
 			r2_next = r2->list.next;
 			free_r1 = 0;
 
-			if (!mpz_cmp(r1->value, r2->value)) {
+			if (!concat_expr_cmp(r1, r2)) {
 				free_r1 = 1;
 				goto next;
 			}
 
+			assert(r1->etype == EXPR_VALUE && r1->etype == EXPR_VALUE);
+
 			if (expr_basetype(r1)->type == TYPE_STRING &&
 			    expr_basetype(r2)->type == TYPE_STRING) {
 				string_type = true;
diff --git a/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.json-nft b/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.json-nft
new file mode 100644
index 000000000000..8868f2eb180e
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.json-nft
@@ -0,0 +1,209 @@
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
+        "flags": [
+          "interval"
+        ],
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
+                "ack",
+                90
+              ]
+            },
+            {
+              "drop": null
+            }
+          ],
+          [
+            {
+              "concat": [
+                "rst",
+                {
+                  "range": [
+                    100,
+                    110
+                  ]
+                }
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
+                        "ack",
+                        90
+                      ]
+                    },
+                    {
+                      "drop": null
+                    }
+                  ],
+                  [
+                    {
+                      "concat": [
+                        "rst",
+                        {
+                          "range": [
+                            100,
+                            110
+                          ]
+                        }
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
diff --git a/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.nft b/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.nft
new file mode 100755
index 000000000000..bc74535b852f
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.nft
@@ -0,0 +1,14 @@
+table ip x {
+	map y {
+		typeof tcp flags . tcp dport : verdict
+		flags interval
+		elements = { syn | ack . 80 : accept,
+			     ack . 90 : drop,
+			     rst . 100-110 : drop }
+	}
+
+	chain z {
+		tcp flags . tcp dport vmap @y
+		tcp flags . tcp dport vmap { syn | ack . 80 : accept, ack . 90 : drop, rst . 100-110 : drop }
+	}
+}
diff --git a/tests/shell/testcases/maps/vmap_concat_range_binary b/tests/shell/testcases/maps/vmap_concat_range_binary
new file mode 100755
index 000000000000..ad5ef4a9177e
--- /dev/null
+++ b/tests/shell/testcases/maps/vmap_concat_range_binary
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
+set -e
+
+RULESET="table ip x {
+        map y {
+                typeof tcp flags . tcp dport : verdict
+                flags interval
+                elements = { syn | ack . 80 : accept,
+                             ack . 90 : drop,
+			     rst . 100-110 : drop }
+        }
+
+        chain z {
+                tcp flags . tcp dport vmap @y
+                tcp flags . tcp dport vmap { syn | ack . 80 : accept, ack . 90 : drop, rst . 100-110 : drop }
+        }
+}"
+
+$NFT -f - <<< $RULESET
-- 
2.47.3

