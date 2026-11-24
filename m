Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795564398;
	b=sqN/r7dwe43rkwL3+I47jPzc0tDBpVRQBh7VqfZQaULcZ9JWumcFGLhCVxP8cEdL+wPs
	 +Cw9SBlcqvGNN62Cn69fybIAPMmWju/+sMvWdrlibyr505Id9p+IvPiNjDnHZckTbr8U8
	 OB1YmYLxZKasERCr/f6q8tbM0TnYESI7MLOXphyDVdUmaxZl5Ib23XseEouw3+GNNOkVI
	 HYDjqbbidx1qZOPJpKws6aAInGvpXHGvdw9h9Ri1TGaEgPXrFxM6Mg668JQtUi2MYebcU
	 SmS7oHezkcTmB9dkPmgV27KzY9QpKP0ctLe2eJ+nVKNFFQTSOl1uIVPBBv1yOz0Uq3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795564398;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=p6Sqyy6ilyj9fDQzPd5NDeY4M1FbX5PJFbJTEzEAVeI=;
	b=P9nC5e/k4GWWoDRxcDLa/svir6jW0s8hojI+XjNIbqErQtyopwjusrfjqwU79mvDzy7i
	 yYJWJO8hrTwRMcFhs0cqCaxAlJzJ5WrkyLFykbVzgttfKOtMQGPatm6tbER8f3EXO6bYo
	 ulHBxvkLnuxVrF8/x0QB3b+/6SMcWpEAPKFiQ+bnVB/PlCb9UDjcJb16YZVfmy+2hCDw0
	 Pn0xsQ2u8I19jSCdcQQj9/wD38dqYC4BnGXSHGXiEeASJqbfsGqqoltCqECKH5mKWCdHU
	 7XIqk600VLsgZdcK0jDVLoSNm2pKnihRdDdiPMtbEG9h4wwFEszrYro2vpuMQ1GbCLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZppAGhwZ;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7CA606A31E
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 23:53:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C7CA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZppAGhwZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795564390;
	bh=p6Sqyy6ilyj9fDQzPd5NDeY4M1FbX5PJFbJTEzEAVeI=;
	h=From:To:Cc:Subject:Date:From;
	b=ZppAGhwZNSVQt3jTdGKeehh4x5fQfOim8Aru42Lp76QMJfPATingoeRxemRFQr6VP
	 X63i7ivuiVWefOIXtHrQwirMX4nOH8t3HzMWeiydnpffCIRd0E+b3RvQeggntliAit
	 O3V2TCEIkkxWgGGuailqoJ2dY1tb4WIt0lhI+lqZ102ShHHIzcWNfRgDYc8+mFSzTG
	 ejE0FbWl7Z7Mt0xRJYIZ1yhgt+rvBl3IapYK+HSWTK383nwTV7B2xb2CBl2tcqWRon
	 J5VKciY8C6D/nJLskf4CnVFLg6sHKiXCuxt2DHgtJIms7x4lTxWk25Ocs4GbHLpbuq
	 zwnHNOB8QuT1g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E203160074;
	Wed, 25 Nov 2026 00:53:09 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc
Subject: [PATCH nft] evaluate: set key byteorder when evaluating mapping
Date: Wed, 25 Nov 2026 00:53:06 +0100
Message-ID: <20261124235306.1777-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set->key->dtype is TYPE_INTEGER (see integer_type definition) which uses
BYTEORDER_INVALID by default, this is used to set up the context for
parsing the symbols in the mapping. Set explicit byteorder context to
address this bug.

Fixes: 144d97e151adb ("src: normalize set element with EXPR_MAPPING")
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                |   3 +-
 .../maps/dumps/nat_addr_port.json-nft         | 134 ++++++++++++++++++
 .../testcases/maps/dumps/nat_addr_port.nft    |  18 +++
 tests/shell/testcases/maps/nat_addr_port      |  12 ++
 4 files changed, 166 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8ce37e57a836..61372dd80cdd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2393,7 +2393,8 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	if (!set_is_map(set->flags))
 		return set_error(ctx, set, "set is not a map");
 
-	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
+	__expr_set_context(&ctx->ectx, set->key->dtype, set->key->byteorder, set->key->len, 0);
+
 	ctx->ectx.key = key;
 
 	if (expr_evaluate(ctx, &mapping->left) < 0)
diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft b/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft
index 216761c6f150..288178710387 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft
@@ -65,6 +65,42 @@
         ]
       }
     },
+    {
+      "map": {
+        "family": "ip",
+        "name": "w",
+        "table": "ipfoo",
+        "type": {
+          "typeof": {
+            "numgen": {
+              "mode": "inc",
+              "mod": 3,
+              "offset": 0
+            }
+          }
+        },
+        "handle": 0,
+        "map": "mark",
+        "elem": [
+          [
+            0,
+            9
+          ],
+          [
+            1,
+            8
+          ],
+          [
+            2,
+            7
+          ],
+          [
+            3,
+            6
+          ]
+        ]
+      }
+    },
     {
       "map": {
         "family": "ip",
@@ -411,6 +447,37 @@
         ]
       }
     },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "ipfoo",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "mangle": {
+              "key": {
+                "meta": {
+                  "key": "mark"
+                }
+              },
+              "value": {
+                "map": {
+                  "key": {
+                    "numgen": {
+                      "mode": "inc",
+                      "mod": 2000,
+                      "offset": 0
+                    }
+                  },
+                  "data": "@w"
+                }
+              }
+            }
+          }
+        ]
+      }
+    },
     {
       "table": {
         "family": "ip6",
@@ -469,6 +536,42 @@
         ]
       }
     },
+    {
+      "map": {
+        "family": "ip6",
+        "name": "w",
+        "table": "ip6foo",
+        "type": {
+          "typeof": {
+            "numgen": {
+              "mode": "inc",
+              "mod": 3,
+              "offset": 0
+            }
+          }
+        },
+        "handle": 0,
+        "map": "mark",
+        "elem": [
+          [
+            0,
+            9
+          ],
+          [
+            1,
+            8
+          ],
+          [
+            2,
+            7
+          ],
+          [
+            3,
+            6
+          ]
+        ]
+      }
+    },
     {
       "map": {
         "family": "ip6",
@@ -788,6 +891,37 @@
         ]
       }
     },
+    {
+      "rule": {
+        "family": "ip6",
+        "table": "ip6foo",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "mangle": {
+              "key": {
+                "meta": {
+                  "key": "mark"
+                }
+              },
+              "value": {
+                "map": {
+                  "key": {
+                    "numgen": {
+                      "mode": "inc",
+                      "mod": 2000,
+                      "offset": 0
+                    }
+                  },
+                  "data": "@w"
+                }
+              }
+            }
+          }
+        ]
+      }
+    },
     {
       "table": {
         "family": "inet",
diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.nft b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
index f4a952e9db42..24315b2981f5 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
@@ -7,6 +7,14 @@ table ip ipfoo {
 		typeof numgen inc mod 2 : ip daddr . tcp dport
 	}
 
+	map w {
+		typeof numgen inc mod 3 : meta mark
+		elements = { 0 : 0x00000009,
+			     1 : 0x00000008,
+			     2 : 0x00000007,
+			     3 : 0x00000006 }
+	}
+
 	map x {
 		type ipv4_addr : ipv4_addr
 	}
@@ -32,6 +40,7 @@ table ip ipfoo {
 		meta l4proto 6 dnat to 10.2.3.4:4242
 		dnat to numgen inc mod 2 map @t1
 		meta l4proto 6 dnat ip to numgen inc mod 2 map @t2
+		meta mark set numgen inc mod 2000 map @w
 	}
 }
 table ip6 ip6foo {
@@ -43,6 +52,14 @@ table ip6 ip6foo {
 		typeof numgen inc mod 2 : ip6 daddr . tcp dport
 	}
 
+	map w {
+		typeof numgen inc mod 3 : meta mark
+		elements = { 0 : 0x00000009,
+			     1 : 0x00000008,
+			     2 : 0x00000007,
+			     3 : 0x00000006 }
+	}
+
 	map x {
 		type ipv6_addr : ipv6_addr
 	}
@@ -66,6 +83,7 @@ table ip6 ip6foo {
 		meta l4proto 6 dnat to [fd00:10:244::4]:6443
 		dnat to numgen inc mod 2 map @t1
 		meta l4proto 6 dnat ip6 to numgen inc mod 2 map @t2
+		meta mark set numgen inc mod 2000 map @w
 	}
 }
 table inet inetfoo {
diff --git a/tests/shell/testcases/maps/nat_addr_port b/tests/shell/testcases/maps/nat_addr_port
index 5f6ff1c49cc0..b1a458d601c6 100755
--- a/tests/shell/testcases/maps/nat_addr_port
+++ b/tests/shell/testcases/maps/nat_addr_port
@@ -11,6 +11,11 @@ table ip ipfoo {
 		typeof numgen inc mod 2 : ip daddr . tcp dport
 	}
 
+	map w {
+		typeof numgen inc mod 3 : meta mark
+		elements = { 0 : 9, 1 : 8, 2 : 7, 3 : 6 }
+	}
+
 	map x {
 		type ipv4_addr : ipv4_addr
 	}
@@ -34,6 +39,7 @@ table ip ipfoo {
 		meta l4proto tcp dnat ip addr . port to 10.2.3.4 . 4242
 		dnat ip to numgen inc mod 2 map @t1
 		meta l4proto tcp dnat ip addr . port to numgen inc mod 2 map @t2
+		meta mark set numgen inc mod 2000 map @w
 	}
 }
 EOF
@@ -55,6 +61,11 @@ table ip6 ip6foo {
 		typeof numgen inc mod 2 : ip6 daddr . tcp dport
 	}
 
+	map w {
+		typeof numgen inc mod 3 : meta mark
+		elements = { 0 : 9, 1 : 8, 2 : 7, 3 : 6 }
+	}
+
 	map x {
 		type ipv6_addr : ipv6_addr
 	}
@@ -76,6 +87,7 @@ table ip6 ip6foo {
 		meta l4proto tcp dnat ip6 addr . port to fd00:10:244::4 . 6443
 		dnat ip6 to numgen inc mod 2 map @t1
 		meta l4proto tcp dnat ip6 addr . port to numgen inc mod 2 map @t2
+		meta mark set numgen inc mod 2000 map @w
 	}
 }
 EOF
-- 
2.47.3

