Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F3B535AB
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 23:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707349648; cv=none; b=svhCGxWxnujsMaPg4bK8Mng/3JIPoyC/vIhc17QSPFDIJdDyXK95//QFmF2a8jBinwHNU875pvM5HNEpHXO9yHkZ0+M9LfhhNx6glkf/h4Oi2bv2k0fIZ5hAIQvr2Pv0Y+Uc3djUc1dz8DEFg7CuAuQEoM48IWLi+5orrRRQy3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707349648; c=relaxed/simple;
	bh=M+dz0NFvaS6m+/XUIpf43h+i5MUB9o/qWau8PyS9kA4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=V2orxoUN9pVIfen1VAMYbHKd/mvWnzUxJtFJqt9XMRhD0L7sErNZYdRBOUCwV99yzaaAw1pGljSGqZ/rdEMMfGuSdfPnYJNzStRduhUzusuqmQJHhi+l92OQquiBLOQw8X0RcZnWzfzX6/7IaeAzDOOVXyExQvxW85J4uNnkjF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: skip byteorder conversion for selector smaller than 2 bytes
Date: Thu,  8 Feb 2024 00:47:21 +0100
Message-Id: <20240207234721.381747-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add unary expression to trigger byteorder conversion for host byteorder
selectors only if selectors length is less than 2 bytes.

 # cat test.nft
 table ip x {
        set test {
                type ipv4_addr . ether_addr . inet_proto
                flags interval
        }

        chain y {
                ip saddr . ether saddr . meta l4proto @test counter
        }
 }

 # nft -f test.nft
 ip x y
  [ meta load iiftype => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ payload load 6b @ link header + 6 => reg 9 ]
  [ meta load l4proto => reg 11 ]
  [ byteorder reg 11 = hton(reg 11, 2, 1) ] <--- should not be here
  [ lookup reg 1 set test ]
  [ counter pkts 0 bytes 0 ]

Fixes: 1017d323cafa ("src: support for selectors with different byteorder with interval concatenations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                   | 12 ++++++----
 tests/py/inet/meta.t             |  1 +
 tests/py/inet/meta.t.json        | 41 ++++++++++++++++++++++++++++++++
 tests/py/inet/meta.t.json.output | 41 ++++++++++++++++++++++++++++++++
 tests/py/inet/meta.t.payload     | 14 +++++++++++
 5 files changed, 104 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1b430b72de20..a9e6959aa3e5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -199,12 +199,14 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 
 			assert(basetype == TYPE_INTEGER);
 
-			op = byteorder_conversion_op(i, byteorder);
-			unary = unary_expr_alloc(&i->location, op, i);
-			if (expr_evaluate(ctx, &unary) < 0)
-				return -1;
+			if (div_round_up(i->len, BITS_PER_BYTE) < 2) {
+				op = byteorder_conversion_op(i, byteorder);
+				unary = unary_expr_alloc(&i->location, op, i);
+				if (expr_evaluate(ctx, &unary) < 0)
+					return -1;
 
-			list_replace(&i->list, &unary->list);
+				list_replace(&i->list, &unary->list);
+			}
 		}
 
 		return 0;
diff --git a/tests/py/inet/meta.t b/tests/py/inet/meta.t
index 5c062b39b8a9..7d2515c97f47 100644
--- a/tests/py/inet/meta.t
+++ b/tests/py/inet/meta.t
@@ -25,6 +25,7 @@ meta mark set ct mark >> 8;ok
 meta mark . tcp dport { 0x0000000a-0x00000014 . 80-90, 0x00100000-0x00100123 . 100-120 };ok
 ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 1.2.3.6-1.2.3.8 . 0x00000200-0x00000300 };ok
 ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 5.6.7.8 . 0x00000200 };ok
+ip saddr . ether saddr . meta l4proto { 1.2.3.4 . aa:bb:cc:dd:ee:ff . 6 };ok
 
 meta mark set ip dscp;ok
 meta mark set ip dscp | 0x40;ok
diff --git a/tests/py/inet/meta.t.json b/tests/py/inet/meta.t.json
index 3ba0fd1dee2a..0fee165ff18a 100644
--- a/tests/py/inet/meta.t.json
+++ b/tests/py/inet/meta.t.json
@@ -526,3 +526,44 @@
     }
 ]
 
+# ip saddr . ether saddr . meta l4proto { 1.2.3.4 . aa:bb:cc:dd:ee:ff . 6 }
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ether"
+                        }
+                    },
+                    {
+                        "meta": {
+                            "key": "l4proto"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "1.2.3.4",
+                            "aa:bb:cc:dd:ee:ff",
+                            "tcp"
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/meta.t.json.output b/tests/py/inet/meta.t.json.output
index 3e7dd2145e67..8697d5a2b9e2 100644
--- a/tests/py/inet/meta.t.json.output
+++ b/tests/py/inet/meta.t.json.output
@@ -51,3 +51,44 @@
     }
 ]
 
+# ip saddr . ether saddr . meta l4proto { 1.2.3.4 . aa:bb:cc:dd:ee:ff . 6 }
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ether"
+                        }
+                    },
+                    {
+                        "meta": {
+                            "key": "l4proto"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "1.2.3.4",
+                            "aa:bb:cc:dd:ee:ff",
+                            6
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
index c53b5077f9a6..7184fa0c0c9d 100644
--- a/tests/py/inet/meta.t.payload
+++ b/tests/py/inet/meta.t.payload
@@ -173,3 +173,17 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0xffffffbf ) ^ 0x00000040 ]
   [ meta set mark with reg 1 ]
 
+# ip saddr . ether saddr . meta l4proto { 1.2.3.4 . aa:bb:cc:dd:ee:ff . 6 }
+__set%d test-inet 3 size 1
+__set%d test-inet 0
+	element 04030201 ddccbbaa 0000ffee 00000006  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 6b @ link header + 6 => reg 9 ]
+  [ meta load l4proto => reg 11 ]
+  [ lookup reg 1 set __set%d ]
+
-- 
2.30.2

