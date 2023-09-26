Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A0BE7E644
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 16:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjIZQC2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 12:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjIZQC2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 12:02:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76C2110A
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 09:02:20 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 3/3,v2] netlink_linearize: skip set element expression in map statement key
Date:   Tue, 26 Sep 2023 18:02:16 +0200
Message-Id: <20230926160216.152549-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This fix is similar to 22d201010919 ("netlink_linearize: skip set element
expression in set statement key") to fix map statement.

netlink_gen_map_stmt() relies on the map key, that is expressed as a set
element. Use the set element key instead to skip the set element wrap,
otherwise get_register() abort execution:

  nft: netlink_linearize.c:650: netlink_gen_expr: Assertion `dreg < ctx->reg_low' failed.

This includes JSON support to make this feature complete and it updates
tests/shell to cover for this support.

Reported-by: Luci Stanescu <luci@cnix.ro>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - refer to JSON support.
    - use stmt->map instead of stmt->set.
    Both reported by Phil Sutter.

 include/json.h                     |  1 +
 src/json.c                         | 19 ++++++++++
 src/netlink_linearize.c            |  6 ++--
 src/parser_json.c                  | 58 ++++++++++++++++++++++++++++++
 src/statement.c                    |  1 +
 tests/py/ip/sets.t                 |  3 ++
 tests/py/ip/sets.t.json            | 31 ++++++++++++++++
 tests/py/ip/sets.t.payload.inet    |  9 +++++
 tests/py/ip/sets.t.payload.ip      |  8 +++++
 tests/py/ip/sets.t.payload.netdev  | 10 ++++++
 tests/py/ip6/sets.t                |  4 +++
 tests/py/ip6/sets.t.json           | 32 +++++++++++++++++
 tests/py/ip6/sets.t.payload.inet   |  9 +++++
 tests/py/ip6/sets.t.payload.ip6    |  7 ++++
 tests/py/ip6/sets.t.payload.netdev |  9 +++++
 15 files changed, 204 insertions(+), 3 deletions(-)

diff --git a/include/json.h b/include/json.h
index da605ed9e83d..abeeb044a87c 100644
--- a/include/json.h
+++ b/include/json.h
@@ -84,6 +84,7 @@ json_t *nat_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *reject_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *counter_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *set_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
+json_t *map_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *log_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *objref_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *meter_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
diff --git a/src/json.c b/src/json.c
index 220ce0f79f2f..1be58221c699 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1520,6 +1520,25 @@ json_t *set_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	return json_pack("{s:o}", "set", root);
 }
 
+json_t *map_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
+{
+	json_t *root;
+
+	root = json_pack("{s:s, s:o, s:o, s:s+}",
+			 "op", set_stmt_op_names[stmt->map.op],
+			 "elem", expr_print_json(stmt->map.key, octx),
+			 "data", expr_print_json(stmt->map.data, octx),
+			 "map", "@", stmt->map.set->set->handle.set.name);
+
+	if (!list_empty(&stmt->map.stmt_list)) {
+		json_object_set_new(root, "stmt",
+				    set_stmt_list_json(&stmt->map.stmt_list,
+						       octx));
+	}
+
+	return json_pack("{s:o}", "map", root);
+}
+
 json_t *objref_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	const char *name;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 53a318aa2e62..c91211582b3d 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1585,13 +1585,13 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
 	int num_stmts = 0;
 	struct stmt *this;
 
-	sreg_key = get_register(ctx, stmt->map.key);
-	netlink_gen_expr(ctx, stmt->map.key, sreg_key);
+	sreg_key = get_register(ctx, stmt->map.key->key);
+	netlink_gen_expr(ctx, stmt->map.key->key, sreg_key);
 
 	sreg_data = get_register(ctx, stmt->map.data);
 	netlink_gen_expr(ctx, stmt->map.data, sreg_data);
 
-	release_register(ctx, stmt->map.key);
+	release_register(ctx, stmt->map.key->key);
 	release_register(ctx, stmt->map.data);
 
 	nle = alloc_nft_expr("dynset");
diff --git a/src/parser_json.c b/src/parser_json.c
index 16961d6013af..78895befbc6c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2416,6 +2416,63 @@ static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
+static struct stmt *json_parse_map_stmt(struct json_ctx *ctx,
+					const char *key, json_t *value)
+{
+	struct expr *expr, *expr2, *expr_data;
+	json_t *elem, *data, *stmt_json;
+	const char *opstr, *set;
+	struct stmt *stmt;
+	int op;
+
+	if (json_unpack_err(ctx, value, "{s:s, s:o, s:o, s:s}",
+			    "op", &opstr, "elem", &elem, "data", &data, "map", &set))
+		return NULL;
+
+	if (!strcmp(opstr, "add")) {
+		op = NFT_DYNSET_OP_ADD;
+	} else if (!strcmp(opstr, "update")) {
+		op = NFT_DYNSET_OP_UPDATE;
+	} else if (!strcmp(opstr, "delete")) {
+		op = NFT_DYNSET_OP_DELETE;
+	} else {
+		json_error(ctx, "Unknown set statement op '%s'.", opstr);
+		return NULL;
+	}
+
+	expr = json_parse_set_elem_expr_stmt(ctx, elem);
+	if (!expr) {
+		json_error(ctx, "Illegal set statement element.");
+		return NULL;
+	}
+
+	expr_data = json_parse_set_elem_expr_stmt(ctx, data);
+	if (!expr_data) {
+		json_error(ctx, "Illegal map expression data.");
+		expr_free(expr);
+		return NULL;
+	}
+
+	if (set[0] != '@') {
+		json_error(ctx, "Illegal set reference in set statement.");
+		expr_free(expr);
+		expr_free(expr_data);
+		return NULL;
+	}
+	expr2 = symbol_expr_alloc(int_loc, SYMBOL_SET, NULL, set + 1);
+
+	stmt = map_stmt_alloc(int_loc);
+	stmt->map.op = op;
+	stmt->map.key = expr;
+	stmt->map.data = expr_data;
+	stmt->map.set = expr2;
+
+	if (!json_unpack(value, "{s:o}", "stmt", &stmt_json))
+		json_parse_set_stmt_list(ctx, &stmt->set.stmt_list, stmt_json);
+
+	return stmt;
+}
+
 static int json_parse_log_flag(struct json_ctx *ctx,
 			       json_t *root, int *flags)
 {
@@ -2840,6 +2897,7 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 		{ "redirect", json_parse_nat_stmt },
 		{ "reject", json_parse_reject_stmt },
 		{ "set", json_parse_set_stmt },
+		{ "map", json_parse_map_stmt },
 		{ "log", json_parse_log_stmt },
 		{ "ct helper", json_parse_cthelper_stmt },
 		{ "ct timeout", json_parse_cttimeout_stmt },
diff --git a/src/statement.c b/src/statement.c
index 66424eb420ab..a9fefc365650 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -848,6 +848,7 @@ static const struct stmt_ops map_stmt_ops = {
 	.name		= "map",
 	.print		= map_stmt_print,
 	.destroy	= map_stmt_destroy,
+	.json		= map_stmt_json,
 };
 
 struct stmt *map_stmt_alloc(const struct location *loc)
diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index a224d0fef13d..46d9686b7ddd 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -52,6 +52,9 @@ ip saddr != @set33 drop;fail
 ip saddr . ip daddr @set5 drop;ok
 add @set5 { ip saddr . ip daddr };ok
 
+!map1 type ipv4_addr . ipv4_addr : mark;ok
+add @map1 { ip saddr . ip daddr : meta mark };ok
+
 # test nested anonymous sets
 ip saddr { { 1.1.1.0, 3.3.3.0 }, 2.2.2.0 };ok;ip saddr { 1.1.1.0, 2.2.2.0, 3.3.3.0 }
 ip saddr { { 1.1.1.0/24, 3.3.3.0/24 }, 2.2.2.0/24 };ok;ip saddr { 1.1.1.0/24, 2.2.2.0/24, 3.3.3.0/24 }
diff --git a/tests/py/ip/sets.t.json b/tests/py/ip/sets.t.json
index d24b3918dc6d..44ca1528c0de 100644
--- a/tests/py/ip/sets.t.json
+++ b/tests/py/ip/sets.t.json
@@ -272,3 +272,34 @@
     }
 ]
 
+# add @map1 { ip saddr . ip daddr : meta mark }
+[
+    {
+        "map": {
+            "data": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "elem": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip"
+                        }
+                    }
+                ]
+            },
+            "map": "@map1",
+            "op": "add"
+        }
+    }
+]
+
diff --git a/tests/py/ip/sets.t.payload.inet b/tests/py/ip/sets.t.payload.inet
index d7d70b0c2537..fd6517a52160 100644
--- a/tests/py/ip/sets.t.payload.inet
+++ b/tests/py/ip/sets.t.payload.inet
@@ -75,6 +75,15 @@ inet
   [ lookup reg 1 set set6 ]
   [ immediate reg 0 drop ]
 
+# add @map1 { ip saddr . ip daddr : meta mark }
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ meta load mark => reg 10 ]
+  [ dynset add reg_key 1 set map1 sreg_data 10 ]
+
 # ip saddr vmap { 1.1.1.1 : drop, * : accept }
 __map%d test-inet b
 __map%d test-inet 0
diff --git a/tests/py/ip/sets.t.payload.ip b/tests/py/ip/sets.t.payload.ip
index 97a9669354b6..d9cc32b60ef0 100644
--- a/tests/py/ip/sets.t.payload.ip
+++ b/tests/py/ip/sets.t.payload.ip
@@ -73,3 +73,11 @@ ip
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
+
+# add @map1 { ip saddr . ip daddr : meta mark }
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ meta load mark => reg 10 ]
+  [ dynset add reg_key 1 set map1 sreg_data 10 ]
+
diff --git a/tests/py/ip/sets.t.payload.netdev b/tests/py/ip/sets.t.payload.netdev
index d4317d290fc4..d41b9e8bae19 100644
--- a/tests/py/ip/sets.t.payload.netdev
+++ b/tests/py/ip/sets.t.payload.netdev
@@ -95,3 +95,13 @@ netdev
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
+
+# add @map1 { ip saddr . ip daddr : meta mark }
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ meta load mark => reg 10 ]
+  [ dynset add reg_key 1 set map1 sreg_data 10 ]
+
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index 3b99d6619df7..17fd62f5e8c1 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -41,4 +41,8 @@ ip6 saddr != @set33 drop;fail
 !set5 type ipv6_addr . ipv6_addr;ok
 ip6 saddr . ip6 daddr @set5 drop;ok
 add @set5 { ip6 saddr . ip6 daddr };ok
+
+!map1 type ipv6_addr . ipv6_addr : mark;ok
+add @map1 { ip6 saddr . ip6 daddr : meta mark };ok
+
 delete @set5 { ip6 saddr . ip6 daddr };ok
diff --git a/tests/py/ip6/sets.t.json b/tests/py/ip6/sets.t.json
index 948c1f168d0f..2029d2b5894b 100644
--- a/tests/py/ip6/sets.t.json
+++ b/tests/py/ip6/sets.t.json
@@ -116,3 +116,35 @@
         }
     }
 ]
+
+# add @map1 { ip6 saddr . ip6 daddr : meta mark }
+[
+    {
+        "map": {
+            "data": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "elem": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip6"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip6"
+                        }
+                    }
+                ]
+            },
+            "map": "@map1",
+            "op": "add"
+        }
+    }
+]
+
diff --git a/tests/py/ip6/sets.t.payload.inet b/tests/py/ip6/sets.t.payload.inet
index 47ad86a20864..2bbd5573ff0a 100644
--- a/tests/py/ip6/sets.t.payload.inet
+++ b/tests/py/ip6/sets.t.payload.inet
@@ -31,6 +31,15 @@ inet test-inet input
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset add reg_key 1 set set5 ]
 
+# add @map1 { ip6 saddr . ip6 daddr : meta mark }
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ payload load 16b @ network header + 24 => reg 2 ]
+  [ meta load mark => reg 3 ]
+  [ dynset add reg_key 1 set map1 sreg_data 3 ]
+
 # delete @set5 { ip6 saddr . ip6 daddr }
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/sets.t.payload.ip6 b/tests/py/ip6/sets.t.payload.ip6
index a5febb9fe591..c59f7b5c9c81 100644
--- a/tests/py/ip6/sets.t.payload.ip6
+++ b/tests/py/ip6/sets.t.payload.ip6
@@ -29,3 +29,10 @@ ip6 test-ip6 input
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset delete reg_key 1 set set5 ]
 
+# add @map1 { ip6 saddr . ip6 daddr : meta mark }
+ip6 test-ip6 input
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ payload load 16b @ network header + 24 => reg 2 ]
+  [ meta load mark => reg 3 ]
+  [ dynset add reg_key 1 set map1 sreg_data 3 ]
+
diff --git a/tests/py/ip6/sets.t.payload.netdev b/tests/py/ip6/sets.t.payload.netdev
index dab74159a098..1866d26b9a92 100644
--- a/tests/py/ip6/sets.t.payload.netdev
+++ b/tests/py/ip6/sets.t.payload.netdev
@@ -39,3 +39,12 @@ netdev test-netdev ingress
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset delete reg_key 1 set set5 ]
 
+# add @map1 { ip6 saddr . ip6 daddr : meta mark }
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ payload load 16b @ network header + 24 => reg 2 ]
+  [ meta load mark => reg 3 ]
+  [ dynset add reg_key 1 set map1 sreg_data 3 ]
+
-- 
2.30.2

