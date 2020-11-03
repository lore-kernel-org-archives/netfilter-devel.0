Return-Path: <SRS0=5/tH=EJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57EB9C388F2
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Nov 2020 18:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 225FA20786
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Nov 2020 18:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgKCSVC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgKCSVB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Nov 2020 13:21:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8A2C0613D1
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2020 10:21:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ka0vU-0001d9-4l; Tue, 03 Nov 2020 19:21:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] json: add missing nat_type flag and netmap nat flag
Date:   Tue,  3 Nov 2020 19:20:40 +0100
Message-Id: <20201103182040.24858-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103182040.24858-1-fw@strlen.de>
References: <20201103182040.24858-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

JSON in/output doesn't know about nat_type and thus cannot save/restore
nat mappings involving prefixes or concatenations because the snat
statement lacks the prefix/concat/interval type flags.

Furthermore, bison parser was extended to support netmap.
This is done with an internal 'netmap' flag that is passed to the
kernel.  We need to dump/restore that as well.

Also make sure ip/snat.t passes in json mode.

Fixes: 35a6b10c1bc4 ("src: add netmap support")
Fixes: 9599d9d25a6b ("src: NAT support for intervals in maps")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/json.c              |  43 +++++++++++++---
 src/parser_json.c       |  70 +++++++++++++++++++++++++-
 tests/py/ip/snat.t.json | 108 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 211 insertions(+), 10 deletions(-)

diff --git a/src/json.c b/src/json.c
index a8824d3fc05a..3c4654d6dada 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1288,7 +1288,7 @@ json_t *log_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	return json_pack("{s:o}", "log", root);
 }
 
-static json_t *nat_flags_json(int flags)
+static json_t *nat_flags_json(uint32_t flags)
 {
 	json_t *array = json_array();
 
@@ -1298,9 +1298,37 @@ static json_t *nat_flags_json(int flags)
 		json_array_append_new(array, json_string("fully-random"));
 	if (flags & NF_NAT_RANGE_PERSISTENT)
 		json_array_append_new(array, json_string("persistent"));
+	if (flags & NF_NAT_RANGE_NETMAP)
+		json_array_append_new(array, json_string("netmap"));
 	return array;
 }
 
+static json_t *nat_type_flags_json(uint32_t type_flags)
+{
+	json_t *array = json_array();
+
+	if (type_flags & STMT_NAT_F_INTERVAL)
+		json_array_append_new(array, json_string("interval"));
+	if (type_flags & STMT_NAT_F_PREFIX)
+		json_array_append_new(array, json_string("prefix"));
+	if (type_flags & STMT_NAT_F_CONCAT)
+		json_array_append_new(array, json_string("concat"));
+
+	return array;
+}
+
+static void nat_stmt_add_array(json_t *root, const char *name, json_t *array)
+{
+	if (json_array_size(array) > 1) {
+		json_object_set_new(root, name, array);
+	} else {
+		if (json_array_size(array))
+			json_object_set(root, name,
+					json_array_get(array, 0));
+		json_decref(array);
+	}
+}
+
 json_t *nat_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	json_t *root = json_object();
@@ -1322,13 +1350,12 @@ json_t *nat_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		json_object_set_new(root, "port",
 				    expr_print_json(stmt->nat.proto, octx));
 
-	if (json_array_size(array) > 1) {
-		json_object_set_new(root, "flags", array);
-	} else {
-		if (json_array_size(array))
-			json_object_set(root, "flags",
-					json_array_get(array, 0));
-		json_decref(array);
+	nat_stmt_add_array(root, "flags", array);
+
+	if (stmt->nat.type_flags) {
+		array = nat_type_flags_json(stmt->nat.type_flags);
+
+		nat_stmt_add_array(root, "type_flags", array);
 	}
 
 	if (!json_object_size(root)) {
diff --git a/src/parser_json.c b/src/parser_json.c
index ac89166ec8a9..136239121427 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1358,8 +1358,8 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		{ "set", json_parse_set_expr, CTX_F_RHS | CTX_F_STMT }, /* allow this as stmt expr because that allows set references */
 		{ "map", json_parse_map_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS },
 		/* below three are multiton_rhs_expr */
-		{ "prefix", json_parse_prefix_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_CONCAT },
-		{ "range", json_parse_range_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_CONCAT },
+		{ "prefix", json_parse_prefix_expr, CTX_F_RHS | CTX_F_SET_RHS | CTX_F_STMT | CTX_F_CONCAT },
+		{ "range", json_parse_range_expr, CTX_F_RHS | CTX_F_SET_RHS | CTX_F_STMT | CTX_F_CONCAT },
 		{ "payload", json_parse_payload_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "exthdr", json_parse_exthdr_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "tcp option", json_parse_tcp_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
@@ -1861,6 +1861,7 @@ static int json_parse_nat_flag(struct json_ctx *ctx,
 		{ "random", NF_NAT_RANGE_PROTO_RANDOM },
 		{ "fully-random", NF_NAT_RANGE_PROTO_RANDOM_FULLY },
 		{ "persistent", NF_NAT_RANGE_PERSISTENT },
+		{ "netmap", NF_NAT_RANGE_NETMAP },
 	};
 	const char *flag;
 	unsigned int i;
@@ -1905,6 +1906,60 @@ static int json_parse_nat_flags(struct json_ctx *ctx, json_t *root)
 	return flags;
 }
 
+static int json_parse_nat_type_flag(struct json_ctx *ctx,
+			       json_t *root, int *flags)
+{
+	const struct {
+		const char *flag;
+		int val;
+	} flag_tbl[] = {
+		{ "interval", STMT_NAT_F_INTERVAL },
+		{ "prefix", STMT_NAT_F_PREFIX },
+		{ "concat", STMT_NAT_F_CONCAT },
+	};
+	const char *flag;
+	unsigned int i;
+
+	assert(flags);
+
+	if (!json_is_string(root)) {
+		json_error(ctx, "Invalid nat type flag type %s, expected string.",
+			   json_typename(root));
+		return 1;
+	}
+	flag = json_string_value(root);
+	for (i = 0; i < array_size(flag_tbl); i++) {
+		if (!strcmp(flag, flag_tbl[i].flag)) {
+			*flags |= flag_tbl[i].val;
+			return 0;
+		}
+	}
+	json_error(ctx, "Unknown nat type flag '%s'.", flag);
+	return 1;
+}
+
+static int json_parse_nat_type_flags(struct json_ctx *ctx, json_t *root)
+{
+	int flags = 0;
+	json_t *value;
+	size_t index;
+
+	if (json_is_string(root)) {
+		json_parse_nat_type_flag(ctx, root, &flags);
+		return flags;
+	} else if (!json_is_array(root)) {
+		json_error(ctx, "Invalid nat flags type %s.",
+			   json_typename(root));
+		return -1;
+	}
+	json_array_foreach(root, index, value) {
+		if (json_parse_nat_type_flag(ctx, value, &flags))
+			json_error(ctx, "Parsing nat type flag at index %zu failed.",
+				   index);
+	}
+	return flags;
+}
+
 static int nat_type_parse(const char *type)
 {
 	const char * const nat_etypes[] = {
@@ -1967,6 +2022,17 @@ static struct stmt *json_parse_nat_stmt(struct json_ctx *ctx,
 		}
 		stmt->nat.flags = flags;
 	}
+
+	if (!json_unpack(value, "{s:o}", "type_flags", &tmp)) {
+		int flags = json_parse_nat_type_flags(ctx, tmp);
+
+		if (flags < 0) {
+			stmt_free(stmt);
+			return NULL;
+		}
+		stmt->nat.type_flags = flags;
+	}
+
 	return stmt;
 }
 
diff --git a/tests/py/ip/snat.t.json b/tests/py/ip/snat.t.json
index e87b524ee667..62c6e61bea7c 100644
--- a/tests/py/ip/snat.t.json
+++ b/tests/py/ip/snat.t.json
@@ -166,3 +166,111 @@
     }
 ]
 
+# snat ip addr . port to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
+[
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "10.141.11.4",
+                                {
+                                    "concat": [
+                                        "192.168.2.3",
+                                        80
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    }
+                }
+            },
+            "family": "ip",
+            "type_flags": "concat"
+        }
+    }
+]
+
+# snat ip interval to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }
+[
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "10.141.11.4",
+                                {
+                                    "range": [
+                                        "192.168.2.2",
+                                        "192.168.2.4"
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    }
+                }
+            },
+            "family": "ip",
+            "type_flags": "interval"
+        }
+    }
+]
+
+# snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }
+[
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "prefix": {
+                                        "addr": "10.141.11.0",
+                                        "len": 24
+                                    }
+                                },
+                                {
+                                    "prefix": {
+                                        "addr": "192.168.2.0",
+                                        "len": 24
+                                    }
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    }
+                }
+            },
+            "family": "ip",
+            "flags": "netmap",
+            "type_flags": [
+                "interval",
+                "prefix"
+            ]
+        }
+    }
+]
+
-- 
2.26.2

