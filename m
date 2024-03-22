Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6610256B79
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2024 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711123615; cv=none; b=sheOFmPZorv48rR+E+3sDU9/HU59Ko8c0ygnaOCgIGQSdtZR0IczfooR2dMoWVOTWDoqzF4MzEmjJ5VYJgYfyBVxx1cI4MkFlBJcwai90mNCr9LJyoeVhPCqUv/JVeEuzdu63tD3was2VNmZkDDwVi6gIgNKVD5VwiaqU5WXP7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711123615; c=relaxed/simple;
	bh=d7Ej/E9vwuTr0Unw7T9N1eo7M02YOqCxrWkPOBBLqss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQe7KzEBv1OojUO7Vom3TwXM5lSRSAREtLvJiqeW1n7C4eseb8mDTuyB1/rujW/QwssigSQzIFGGn5aB22k6EUS4pyAlI7WfA5j3SK37Usv1NTv2BK+N/hx4KGEiOpfQBqs7gvn0882tBhdb+Zojlu1ulyEMzfoLjm8aciS3XLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nX5Ysr+N; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nX5Ysr+N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fLqz55pJfMP1F66C5TH07J4fTLku8WaEZ4RTNXYLAKk=; b=nX5Ysr+NjZCnHWa/DUtP1G5toP
	g47gbmLqTXKqJTW9kmUxb37ooKtF3kj7I8YxN9RMY/HljHdW/v4PFPe6/TZdRmVMJWRcnEdbCFqRo
	tLAL9+taqvP1uMRZftqrlTmzjkRGEzLorRngmp/72T6zGcwTSDeQ0DcGzhL4kIvI7kQdhZHUQaIh9
	BT3vVpsuVnSnNv/2yDPIqm9PqTDCtuvrZ8o7cF5SfiBUFiI2NUInNeYOoEcXm+v3Uo3r6QtThZ/lr
	AV8mXCVBbRj/I1QW5qTPhwxlK4iLVNXg3eSZWOOqDCaYiAcr27JNBUlaiHPBugn4EXvPIpvugy5gR
	tHzpWw7w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rnhPv-000000000ye-2Mx6;
	Fri, 22 Mar 2024 17:06:51 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 1/5] json: Accept more than two operands in binary expressions
Date: Fri, 22 Mar 2024 17:06:41 +0100
Message-ID: <20240322160645.18331-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240322160645.18331-1-phil@nwl.cc>
References: <20240322160645.18331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The most common use case is ORing flags like

| syn | ack | rst

but nft seems to be fine with less intuitive stuff like

| meta mark set ip dscp << 2 << 3

so support all of them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc                     |  18 +--
 src/json.c                                    |  19 +++-
 src/parser_json.c                             |  12 ++
 tests/py/inet/tcp.t.json                      |  67 +----------
 tests/py/inet/tcp.t.json.output               | 104 ++++--------------
 .../dumps/0012different_defines_0.json-nft    |   8 +-
 .../sets/dumps/0055tcpflags_0.json-nft        |  98 ++++-------------
 7 files changed, 91 insertions(+), 235 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index a4adcde2a66a9..a8a6165fde59d 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -1352,15 +1352,17 @@ Perform kernel Forwarding Information Base lookups.
 
 === BINARY OPERATION
 [verse]
-*{ "|": [* 'EXPRESSION'*,* 'EXPRESSION' *] }*
-*{ "^": [* 'EXPRESSION'*,* 'EXPRESSION' *] }*
-*{ "&": [* 'EXPRESSION'*,* 'EXPRESSION' *] }*
-*{ "+<<+": [* 'EXPRESSION'*,* 'EXPRESSION' *] }*
-*{ ">>": [* 'EXPRESSION'*,* 'EXPRESSION' *] }*
-
-All binary operations expect an array of exactly two expressions, of which the
+*{ "|": [* 'EXPRESSION'*,* 'EXPRESSIONS' *] }*
+*{ "^": [* 'EXPRESSION'*,* 'EXPRESSIONS' *] }*
+*{ "&": [* 'EXPRESSION'*,* 'EXPRESSIONS' *] }*
+*{ "+<<+": [* 'EXPRESSION'*,* 'EXPRESSIONS' *] }*
+*{ ">>": [* 'EXPRESSION'*,* 'EXPRESSIONS' *] }*
+'EXPRESSIONS' := 'EXPRESSION' | 'EXPRESSION'*,* 'EXPRESSIONS'
+
+All binary operations expect an array of at least two expressions, of which the
 first element denotes the left hand side and the second one the right hand
-side.
+side. Extra elements are accepted in the given array and appended to the term
+accordingly.
 
 === VERDICT
 [verse]
diff --git a/src/json.c b/src/json.c
index 29fbd0cfdba28..3753017169930 100644
--- a/src/json.c
+++ b/src/json.c
@@ -540,11 +540,24 @@ json_t *flagcmp_expr_json(const struct expr *expr, struct output_ctx *octx)
 			 "right", expr_print_json(expr->flagcmp.value, octx));
 }
 
+static json_t *
+__binop_expr_json(int op, const struct expr *expr, struct output_ctx *octx)
+{
+	json_t *a = json_array();
+
+	if (expr->etype == EXPR_BINOP && expr->op == op) {
+		json_array_extend(a, __binop_expr_json(op, expr->left, octx));
+		json_array_extend(a, __binop_expr_json(op, expr->right, octx));
+	} else {
+		json_array_append_new(a, expr_print_json(expr, octx));
+	}
+	return a;
+}
+
 json_t *binop_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
-	return json_pack("{s:[o, o]}", expr_op_symbols[expr->op],
-			 expr_print_json(expr->left, octx),
-			 expr_print_json(expr->right, octx));
+	return json_pack("{s:o}", expr_op_symbols[expr->op],
+			 __binop_expr_json(expr->op, expr, octx));
 }
 
 json_t *relational_expr_json(const struct expr *expr, struct output_ctx *octx)
diff --git a/src/parser_json.c b/src/parser_json.c
index 04255688ca04c..55d65c415bf5c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1204,6 +1204,18 @@ static struct expr *json_parse_binop_expr(struct json_ctx *ctx,
 		return NULL;
 	}
 
+	if (json_array_size(root) > 2) {
+		left = json_parse_primary_expr(ctx, json_array_get(root, 0));
+		right = json_parse_primary_expr(ctx, json_array_get(root, 1));
+		left = binop_expr_alloc(int_loc, thisop, left, right);
+		for (i = 2; i < json_array_size(root); i++) {
+			jright = json_array_get(root, i);
+			right = json_parse_primary_expr(ctx, jright);
+			left = binop_expr_alloc(int_loc, thisop, left, right);
+		}
+		return left;
+	}
+
 	if (json_unpack_err(ctx, root, "[o, o!]", &jleft, &jright))
 		return NULL;
 
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index d3a846cf9a400..bd589cf0091fe 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -954,12 +954,12 @@
                         }
                     },
                     {
-                        "|": [ "fin", { "|": [ "syn", { "|": [ "rst", { "|": [ "psh", { "|": [ "ack", { "|": [ "urg", { "|": [ "ecn", "cwr" ] } ] } ] } ] } ] } ] } ]
+                        "|": [ "fin", "syn", "rst", "psh", "ack", "urg", "ecn", "cwr" ]
                     }
                 ]
             },
             "op": "==",
-            "right": { "|": [ "fin", { "|": [ "syn", { "|": [ "rst", { "|": [ "psh", { "|": [ "ack", { "|": [ "urg", { "|": [ "ecn", "cwr" ] } ] } ] } ] } ] } ] } ] }
+            "right": { "|": [ "fin", "syn", "rst", "psh", "ack", "urg", "ecn", "cwr" ] }
         }
     }
 ]
@@ -1395,55 +1395,15 @@
                             "protocol": "tcp"
                         }
                     },
-                    {
-                        "|": [
-                            {
-                                "|": [
-                                    {
-                                        "|": [
-                                            {
-                                                "|": [
-                                                    {
-                                                        "|": [
-                                                            "fin",
-                                                            "syn"
-                                                        ]
-                                                    },
-                                                    "rst"
-                                                ]
-                                            },
-                                            "psh"
-                                        ]
-                                    },
-                                    "ack"
-                                ]
-                            },
-                            "urg"
-                        ]
-                    }
+                    { "|": [ "fin", "syn", "rst", "psh", "ack", "urg" ] }
                 ]
             },
             "op": "==",
             "right": {
                 "set": [
-                    {
-                        "|": [
-                            {
-                                "|": [
-                                    "fin",
-                                    "psh"
-                                ]
-                            },
-                            "ack"
-                        ]
-                    },
+                    { "|": [ "fin", "psh", "ack" ] },
                     "fin",
-                    {
-                        "|": [
-                            "psh",
-                            "ack"
-                        ]
-                    },
+                    { "|": [ "psh", "ack" ] },
                     "ack"
                 ]
             }
@@ -1780,22 +1740,7 @@
                             "protocol": "tcp"
                         }
                     },
-                    {
-                        "|": [
-                            {
-                                "|": [
-                                    {
-                                        "|": [
-                                            "fin",
-                                            "syn"
-                                        ]
-                                    },
-                                    "rst"
-                                ]
-                            },
-                            "ack"
-                        ]
-                    }
+                    { "|": [ "fin", "syn", "rst", "ack" ] }
                 ]
             },
             "op": "!=",
diff --git a/tests/py/inet/tcp.t.json.output b/tests/py/inet/tcp.t.json.output
index e186e127fd671..3f03c0ddd1586 100644
--- a/tests/py/inet/tcp.t.json.output
+++ b/tests/py/inet/tcp.t.json.output
@@ -155,27 +155,11 @@
                     },
                     {
                         "|": [
-                            {
-                                "|": [
-                                    {
-                                        "|": [
-                                            {
-                                                "|": [
-                                                    {
-                                                        "|": [
-                                                            "fin",
-                                                            "syn"
-                                                        ]
-                                                    },
-                                                    "rst"
-                                                ]
-                                            },
-                                            "psh"
-                                        ]
-                                    },
-                                    "ack"
-                                ]
-                            },
+                            "fin",
+                            "syn",
+                            "rst",
+                            "psh",
+                            "ack",
                             "urg"
                         ]
                     }
@@ -187,12 +171,8 @@
                     "fin",
                     {
                         "|": [
-                            {
-                                "|": [
-                                    "fin",
-                                    "psh"
-                                ]
-                            },
+                            "fin",
+                            "psh",
                             "ack"
                         ]
                     },
@@ -280,17 +260,9 @@
                     },
                     {
                         "|": [
-                            {
-                                "|": [
-                                    {
-                                        "|": [
-                                            "fin",
-                                            "syn"
-                                        ]
-                                    },
-                                    "rst"
-                                ]
-                            },
+                            "fin",
+                            "syn",
+                            "rst",
                             "ack"
                         ]
                     }
@@ -316,17 +288,9 @@
                     },
                     {
                         "|": [
-                            {
-                                "|": [
-                                    {
-                                        "|": [
-                                            "fin",
-                                            "syn"
-                                        ]
-                                    },
-                                    "rst"
-                                ]
-                            },
+                            "fin",
+                            "syn",
+                            "rst",
                             "ack"
                         ]
                     }
@@ -352,17 +316,9 @@
                     },
                     {
                         "|": [
-                            {
-                                "|": [
-                                    {
-                                        "|": [
-                                            "fin",
-                                            "syn"
-                                        ]
-                                    },
-                                    "rst"
-                                ]
-                            },
+                            "fin",
+                            "syn",
+                            "rst",
                             "ack"
                         ]
                     }
@@ -388,17 +344,9 @@
                     },
                     {
                         "|": [
-                            {
-                                "|": [
-                                    {
-                                        "|": [
-                                            "fin",
-                                            "syn"
-                                        ]
-                                    },
-                                    "rst"
-                                ]
-                            },
+                            "fin",
+                            "syn",
+                            "rst",
                             "ack"
                         ]
                     }
@@ -429,17 +377,9 @@
                     },
                     {
                         "|": [
-                            {
-                                "|": [
-                                    {
-                                        "|": [
-                                            "fin",
-                                            "syn"
-                                        ]
-                                    },
-                                    "rst"
-                                ]
-                            },
+                            "fin",
+                            "syn",
+                            "rst",
                             "ack"
                         ]
                     }
diff --git a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
index 8f3f3a81a9bc8..1b2e342047f4b 100644
--- a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
@@ -169,12 +169,8 @@
               },
               "right": {
                 "|": [
-                  {
-                    "|": [
-                      "established",
-                      "related"
-                    ]
-                  },
+                  "established",
+                  "related",
                   "new"
                 ]
               }
diff --git a/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft b/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
index cd39f0909e120..6a3511515f785 100644
--- a/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
@@ -27,39 +27,23 @@
         "elem": [
           {
             "|": [
-              {
-                "|": [
-                  {
-                    "|": [
-                      "fin",
-                      "psh"
-                    ]
-                  },
-                  "ack"
-                ]
-              },
+              "fin",
+              "psh",
+              "ack",
               "urg"
             ]
           },
           {
             "|": [
-              {
-                "|": [
-                  "fin",
-                  "psh"
-                ]
-              },
+              "fin",
+              "psh",
               "ack"
             ]
           },
           {
             "|": [
-              {
-                "|": [
-                  "fin",
-                  "ack"
-                ]
-              },
+              "fin",
+              "ack",
               "urg"
             ]
           },
@@ -71,39 +55,23 @@
           },
           {
             "|": [
-              {
-                "|": [
-                  {
-                    "|": [
-                      "syn",
-                      "psh"
-                    ]
-                  },
-                  "ack"
-                ]
-              },
+              "syn",
+              "psh",
+              "ack",
               "urg"
             ]
           },
           {
             "|": [
-              {
-                "|": [
-                  "syn",
-                  "psh"
-                ]
-              },
+              "syn",
+              "psh",
               "ack"
             ]
           },
           {
             "|": [
-              {
-                "|": [
-                  "syn",
-                  "ack"
-                ]
-              },
+              "syn",
+              "ack",
               "urg"
             ]
           },
@@ -116,39 +84,23 @@
           "syn",
           {
             "|": [
-              {
-                "|": [
-                  {
-                    "|": [
-                      "rst",
-                      "psh"
-                    ]
-                  },
-                  "ack"
-                ]
-              },
+              "rst",
+              "psh",
+              "ack",
               "urg"
             ]
           },
           {
             "|": [
-              {
-                "|": [
-                  "rst",
-                  "psh"
-                ]
-              },
+              "rst",
+              "psh",
               "ack"
             ]
           },
           {
             "|": [
-              {
-                "|": [
-                  "rst",
-                  "ack"
-                ]
-              },
+              "rst",
+              "ack",
               "urg"
             ]
           },
@@ -161,12 +113,8 @@
           "rst",
           {
             "|": [
-              {
-                "|": [
-                  "psh",
-                  "ack"
-                ]
-              },
+              "psh",
+              "ack",
               "urg"
             ]
           },
-- 
2.43.0

