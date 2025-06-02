Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02746213255
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Jun 2025 12:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748866395; cv=none; b=DobVlqI9rB13A386GUonYHDjbxTs2Wg32soSXEkbyWf80TzZct+7v8IjmAOj0LXKppYsfO+vIzEw4uppXeCNulbkVswETvSXPKCdW0YODhhjhgcwlg8LT9DIXtvbxWHu1sbUCvTxJmMOVW1Fj5TDHnFc/EIERbU5MyslcDFMYnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748866395; c=relaxed/simple;
	bh=MRMLo21+O+OQg8bX2pBOY/YmuHdgXxz6PrPDdmwOzX4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ukg8H78sPOwziwLkoia6lQ3sa8qa8DHHWaSvNoyDW0cwZoT7M/k/onj3lpsYupEdZTuhuF5aaqGDgLN8JxCXu+9dsDIqt3LnwU/cWyh18w0H2oh6Ldu4DseSOjsuWfv+WoqXi3VgA+HSw9W/2lTYj+xhffcTW5OMvw3OZdcHz+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ECF1160532; Mon,  2 Jun 2025 14:13:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: work around fuzzer-induced assert crashes
Date: Mon,  2 Jun 2025 14:12:49 +0200
Message-ID: <20250602121254.3469-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fuzzer can cause assert failures due to json_pack() returning a NULL
value and therefore triggering the assert(out) in __json_pack macro.

All instances I saw are due to invalid UTF-8 strings, i.e., table/chain
names with non-text characters in them.

Work around this for now, replace the assert with a plaintext error
message and return NULL instead of abort().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/json.c | 271 +++++++++++++++++++++++++++--------------------------
 1 file changed, 140 insertions(+), 131 deletions(-)

diff --git a/src/json.c b/src/json.c
index cbed9ce9ccb7..53e81446fd35 100644
--- a/src/json.c
+++ b/src/json.c
@@ -33,14 +33,23 @@
 #include <jansson.h>
 #include <syslog.h>
 
-#ifdef DEBUG
-#define __json_pack json_pack
-#define json_pack(...) ({ \
-	json_t *__out = __json_pack(__VA_ARGS__); \
-	assert(__out); \
-	__out; \
-})
-#endif
+static json_t *__nft_json_pack(unsigned int line, const char *fmt, ...)
+{
+	json_error_t error;
+	json_t *value;
+	va_list ap;
+
+	va_start(ap, fmt);
+	value = json_vpack_ex(&error, 0, fmt, ap);
+	va_end(ap);
+
+	if (value)
+		return value;
+
+	fprintf(stderr, "%s:%d: json_pack failure (%s)\n", __FILE__, line, error.text);
+	return NULL;
+}
+#define nft_json_pack(...)	__nft_json_pack(__LINE__, __VA_ARGS__)
 
 static int json_array_extend_new(json_t *array, json_t *other_array)
 {
@@ -84,7 +93,7 @@ static json_t *expr_print_json(const struct expr *expr, struct output_ctx *octx)
 	fclose(octx->output_fp);
 	octx->output_fp = fp;
 
-	return json_pack("s", buf);
+	return nft_json_pack("s", buf);
 }
 
 static json_t *set_dtype_json(const struct expr *key)
@@ -99,7 +108,7 @@ static json_t *set_dtype_json(const struct expr *key)
 		if (!root)
 			root = jtok;
 		else if (json_is_string(root))
-			root = json_pack("[o, o]", root, jtok);
+			root = nft_json_pack("[o, o]", root, jtok);
 		else
 			json_array_append_new(root, jtok);
 		tok = strtok_r(NULL, " .", &tok_safe);
@@ -116,7 +125,7 @@ static json_t *set_key_dtype_json(const struct set *set,
 	if (!use_typeof)
 		return set_dtype_json(set->key);
 
-	return json_pack("{s:o}", "typeof", expr_print_json(set->key, octx));
+	return nft_json_pack("{s:o}", "typeof", expr_print_json(set->key, octx));
 }
 
 static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -139,7 +148,7 @@ static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
 	fclose(octx->output_fp);
 	octx->output_fp = fp;
 
-	return json_pack("s", buf);
+	return nft_json_pack("s", buf);
 }
 
 static json_t *set_stmt_list_json(const struct list_head *stmt_list,
@@ -178,7 +187,7 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 		type = "set";
 	}
 
-	root = json_pack("{s:s, s:s, s:s, s:o, s:I}",
+	root = nft_json_pack("{s:s, s:s, s:s, s:o, s:I}",
 			"family", family2str(set->handle.family),
 			"name", set->handle.set.name,
 			"table", set->handle.table.name,
@@ -192,24 +201,24 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 
 	if (!(set->flags & (NFT_SET_CONSTANT))) {
 		if (set->policy != NFT_SET_POL_PERFORMANCE) {
-			tmp = json_pack("s", set_policy2str(set->policy));
+			tmp = nft_json_pack("s", set_policy2str(set->policy));
 			json_object_set_new(root, "policy", tmp);
 		}
 		if (set->desc.size) {
-			tmp = json_pack("i", set->desc.size);
+			tmp = nft_json_pack("i", set->desc.size);
 			json_object_set_new(root, "size", tmp);
 		}
 	}
 
 	tmp = json_array();
 	if (set->flags & NFT_SET_CONSTANT)
-		json_array_append_new(tmp, json_pack("s", "constant"));
+		json_array_append_new(tmp, nft_json_pack("s", "constant"));
 	if (set->flags & NFT_SET_INTERVAL)
-		json_array_append_new(tmp, json_pack("s", "interval"));
+		json_array_append_new(tmp, nft_json_pack("s", "interval"));
 	if (set->flags & NFT_SET_TIMEOUT)
-		json_array_append_new(tmp, json_pack("s", "timeout"));
+		json_array_append_new(tmp, nft_json_pack("s", "timeout"));
 	if (set->flags & NFT_SET_EVAL)
-		json_array_append_new(tmp, json_pack("s", "dynamic"));
+		json_array_append_new(tmp, nft_json_pack("s", "dynamic"));
 	json_add_array_new(root, "flags", tmp);
 
 	if (set->timeout) {
@@ -217,7 +226,7 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 		json_object_set_new(root, "timeout", tmp);
 	}
 	if (set->gc_int) {
-		tmp = json_pack("i", set->gc_int / 1000);
+		tmp = nft_json_pack("i", set->gc_int / 1000);
 		json_object_set_new(root, "gc-interval", tmp);
 	}
 	if (set->automerge)
@@ -238,7 +247,7 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 				    set_stmt_list_json(&set->stmt_list, octx));
 	}
 
-	return json_pack("{s:o}", type, root);
+	return nft_json_pack("{s:o}", type, root);
 }
 
 /* XXX: Merge with set_print_json()? */
@@ -247,7 +256,7 @@ static json_t *element_print_json(struct output_ctx *octx,
 {
 	json_t *root = expr_print_json(set->init, octx);
 
-	return json_pack("{s: {s:s, s:s, s:s, s:o}}", "element",
+	return nft_json_pack("{s: {s:s, s:s, s:s, s:o}}", "element",
 			 "family", family2str(set->handle.family),
 			 "table", set->handle.table.name,
 			 "name", set->handle.set.name,
@@ -260,7 +269,7 @@ static json_t *rule_print_json(struct output_ctx *octx,
 	const struct stmt *stmt;
 	json_t *root, *tmp;
 
-	root = json_pack("{s:s, s:s, s:s, s:I}",
+	root = nft_json_pack("{s:s, s:s, s:s, s:I}",
 			 "family", family2str(rule->handle.family),
 			 "table", rule->handle.table.name,
 			 "chain", rule->handle.chain.name,
@@ -280,7 +289,7 @@ static json_t *rule_print_json(struct output_ctx *octx,
 		json_decref(tmp);
 	}
 
-	return json_pack("{s:o}", "rule", root);
+	return nft_json_pack("{s:o}", "rule", root);
 }
 
 static json_t *chain_print_json(const struct chain *chain)
@@ -288,7 +297,7 @@ static json_t *chain_print_json(const struct chain *chain)
 	json_t *root, *tmp, *devs = NULL;
 	int priority, policy, i;
 
-	root = json_pack("{s:s, s:s, s:s, s:I}",
+	root = nft_json_pack("{s:s, s:s, s:s, s:I}",
 			 "family", family2str(chain->handle.family),
 			 "table", chain->handle.table.name,
 			 "name", chain->handle.chain.name,
@@ -302,7 +311,7 @@ static json_t *chain_print_json(const struct chain *chain)
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
 		mpz_export_data(&policy, chain->policy->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
-		tmp = json_pack("{s:s, s:s, s:i, s:s}",
+		tmp = nft_json_pack("{s:s, s:s, s:i, s:s}",
 				"type", chain->type.str,
 				"hook", hooknum2str(chain->handle.family,
 						    chain->hook.num),
@@ -314,7 +323,7 @@ static json_t *chain_print_json(const struct chain *chain)
 			if (!devs)
 				devs = json_string(dev);
 			else if (json_is_string(devs))
-				devs = json_pack("[o, s]", devs, dev);
+				devs = nft_json_pack("[o, s]", devs, dev);
 			else
 				json_array_append_new(devs, json_string(dev));
 		}
@@ -325,7 +334,7 @@ static json_t *chain_print_json(const struct chain *chain)
 		json_decref(tmp);
 	}
 
-	return json_pack("{s:o}", "chain", root);
+	return nft_json_pack("{s:o}", "chain", root);
 }
 
 static json_t *proto_name_json(uint8_t proto)
@@ -361,28 +370,28 @@ static json_t *obj_print_json(const struct obj *obj)
 	json_t *root, *tmp, *flags;
 	uint64_t rate, burst;
 
-	root = json_pack("{s:s, s:s, s:s, s:I}",
+	root = nft_json_pack("{s:s, s:s, s:s, s:I}",
 			"family", family2str(obj->handle.family),
 			"name", obj->handle.obj.name,
 			"table", obj->handle.table.name,
 			"handle", obj->handle.handle.id);
 
 	if (obj->comment) {
-		tmp = json_pack("{s:s}", "comment", obj->comment);
+		tmp = nft_json_pack("{s:s}", "comment", obj->comment);
 		json_object_update(root, tmp);
 		json_decref(tmp);
 	}
 
 	switch (obj->type) {
 	case NFT_OBJECT_COUNTER:
-		tmp = json_pack("{s:I, s:I}",
+		tmp = nft_json_pack("{s:I, s:I}",
 				"packets", obj->counter.packets,
 				"bytes", obj->counter.bytes);
 		json_object_update(root, tmp);
 		json_decref(tmp);
 		break;
 	case NFT_OBJECT_QUOTA:
-		tmp = json_pack("{s:I, s:I, s:b}",
+		tmp = nft_json_pack("{s:I, s:I, s:b}",
 				"bytes", obj->quota.bytes,
 				"used", obj->quota.used,
 				"inv", obj->quota.flags & NFT_QUOTA_F_INV);
@@ -390,13 +399,13 @@ static json_t *obj_print_json(const struct obj *obj)
 		json_decref(tmp);
 		break;
 	case NFT_OBJECT_SECMARK:
-		tmp = json_pack("{s:s}",
+		tmp = nft_json_pack("{s:s}",
 				"context", obj->secmark.ctx);
 		json_object_update(root, tmp);
 		json_decref(tmp);
 		break;
 	case NFT_OBJECT_CT_HELPER:
-		tmp = json_pack("{s:s, s:o, s:s}",
+		tmp = nft_json_pack("{s:s, s:o, s:s}",
 				"type", obj->ct_helper.name, "protocol",
 				proto_name_json(obj->ct_helper.l4proto),
 				"l3proto", family2str(obj->ct_helper.l3proto));
@@ -406,7 +415,7 @@ static json_t *obj_print_json(const struct obj *obj)
 	case NFT_OBJECT_CT_TIMEOUT:
 		tmp = timeout_policy_json(obj->ct_timeout.l4proto,
 					  obj->ct_timeout.timeout);
-		tmp = json_pack("{s:o, s:s, s:o}",
+		tmp = nft_json_pack("{s:o, s:s, s:o}",
 				"protocol",
 				proto_name_json(obj->ct_timeout.l4proto),
 				"l3proto", family2str(obj->ct_timeout.l3proto),
@@ -415,7 +424,7 @@ static json_t *obj_print_json(const struct obj *obj)
 		json_decref(tmp);
 		break;
 	case NFT_OBJECT_CT_EXPECT:
-		tmp = json_pack("{s:o, s:I, s:I, s:I, s:s}",
+		tmp = nft_json_pack("{s:o, s:I, s:I, s:I, s:s}",
 				"protocol",
 				proto_name_json(obj->ct_expect.l4proto),
 				"dport", obj->ct_expect.dport,
@@ -434,7 +443,7 @@ static json_t *obj_print_json(const struct obj *obj)
 			burst_unit = get_rate(obj->limit.burst, &burst);
 		}
 
-		tmp = json_pack("{s:I, s:s}",
+		tmp = nft_json_pack("{s:I, s:s}",
 				"rate", rate,
 				"per", get_unit(obj->limit.unit));
 
@@ -454,9 +463,9 @@ static json_t *obj_print_json(const struct obj *obj)
 		json_decref(tmp);
 		break;
 	case NFT_OBJECT_SYNPROXY:
-		tmp = json_pack("{s:i, s:i}",
-				"mss", obj->synproxy.mss,
-				"wscale", obj->synproxy.wscale);
+		tmp = nft_json_pack("{s:i, s:i}",
+				    "mss", obj->synproxy.mss,
+				    "wscale", obj->synproxy.wscale);
 
 		flags = json_array();
 		if (obj->synproxy.flags & NF_SYNPROXY_OPT_TIMESTAMP)
@@ -470,7 +479,7 @@ static json_t *obj_print_json(const struct obj *obj)
 		break;
 	}
 
-	return json_pack("{s:o}", type, root);
+	return nft_json_pack("{s:o}", type, root);
 }
 
 static json_t *flowtable_print_json(const struct flowtable *ftable)
@@ -480,7 +489,7 @@ static json_t *flowtable_print_json(const struct flowtable *ftable)
 
 	mpz_export_data(&priority, ftable->priority.expr->value,
 			BYTEORDER_HOST_ENDIAN, sizeof(int));
-	root = json_pack("{s:s, s:s, s:s, s:I, s:s, s:i}",
+	root = nft_json_pack("{s:s, s:s, s:s, s:I, s:s, s:i}",
 			"family", family2str(ftable->handle.family),
 			"name", ftable->handle.flowtable.name,
 			"table", ftable->handle.table.name,
@@ -493,14 +502,14 @@ static json_t *flowtable_print_json(const struct flowtable *ftable)
 		if (!devs)
 			devs = json_string(dev);
 		else if (json_is_string(devs))
-			devs = json_pack("[o, s]", devs, dev);
+			devs = nft_json_pack("[o, s]", devs, dev);
 		else
 			json_array_append_new(devs, json_string(dev));
 	}
 	if (devs)
 		json_object_set_new(root, "dev", devs);
 
-	return json_pack("{s:o}", "flowtable", root);
+	return nft_json_pack("{s:o}", "flowtable", root);
 }
 
 static json_t *table_flags_json(const struct table *table)
@@ -524,7 +533,7 @@ static json_t *table_print_json(const struct table *table)
 {
 	json_t *root;
 
-	root = json_pack("{s:s, s:s, s:I}",
+	root = nft_json_pack("{s:s, s:s, s:I}",
 			 "family", family2str(table->handle.family),
 			 "name", table->handle.table.name,
 			 "handle", table->handle.handle.id);
@@ -533,7 +542,7 @@ static json_t *table_print_json(const struct table *table)
 	if (table->comment)
 		json_object_set_new(root, "comment", json_string(table->comment));
 
-	return json_pack("{s:o}", "table", root);
+	return nft_json_pack("{s:o}", "table", root);
 }
 
 static json_t *
@@ -554,13 +563,13 @@ __binop_expr_json(int op, const struct expr *expr, struct output_ctx *octx)
 
 json_t *binop_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
-	return json_pack("{s:o}", expr_op_symbols[expr->op],
+	return nft_json_pack("{s:o}", expr_op_symbols[expr->op],
 			 __binop_expr_json(expr->op, expr, octx));
 }
 
 json_t *relational_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
-	return json_pack("{s:{s:s, s:o, s:o}}", "match",
+	return nft_json_pack("{s:{s:s, s:o, s:o}}", "match",
 			 "op", expr_op_symbols[expr->op] ? : "in",
 			 "left", expr_print_json(expr->left, octx),
 			 "right", expr_print_json(expr->right, octx));
@@ -573,7 +582,7 @@ json_t *range_expr_json(const struct expr *expr, struct output_ctx *octx)
 
 	octx->flags &= ~NFT_CTX_OUTPUT_SERVICE;
 	octx->flags |= NFT_CTX_OUTPUT_NUMERIC_PROTO;
-	root = json_pack("{s:[o, o]}", "range",
+	root = nft_json_pack("{s:[o, o]}", "range",
 			 expr_print_json(expr->left, octx),
 			 expr_print_json(expr->right, octx));
 	octx->flags = flags;
@@ -583,7 +592,7 @@ json_t *range_expr_json(const struct expr *expr, struct output_ctx *octx)
 
 json_t *meta_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
-	return json_pack("{s:{s:s}}", "meta",
+	return nft_json_pack("{s:{s:s}}", "meta",
 			 "key", meta_templates[expr->meta.key].token);
 }
 
@@ -593,23 +602,23 @@ json_t *payload_expr_json(const struct expr *expr, struct output_ctx *octx)
 
 	if (payload_is_known(expr)) {
 		if (expr->payload.inner_desc) {
-			root = json_pack("{s:s, s:s, s:s}",
+			root = nft_json_pack("{s:s, s:s, s:s}",
 					 "tunnel", expr->payload.inner_desc->name,
 					 "protocol", expr->payload.desc->name,
 					 "field", expr->payload.tmpl->token);
 		} else {
-			root = json_pack("{s:s, s:s}",
+			root = nft_json_pack("{s:s, s:s}",
 					 "protocol", expr->payload.desc->name,
 					 "field", expr->payload.tmpl->token);
 		}
 	} else {
-		root = json_pack("{s:s, s:i, s:i}",
+		root = nft_json_pack("{s:s, s:i, s:i}",
 				 "base", proto_base_tokens[expr->payload.base],
 				 "offset", expr->payload.offset,
 				 "len", expr->len);
 	}
 
-	return json_pack("{s:o}", "payload", root);
+	return nft_json_pack("{s:o}", "payload", root);
 }
 
 json_t *ct_expr_json(const struct expr *expr, struct output_ctx *octx)
@@ -618,7 +627,7 @@ json_t *ct_expr_json(const struct expr *expr, struct output_ctx *octx)
 	enum nft_ct_keys key = expr->ct.key;
 	json_t *root;
 
-	root = json_pack("{s:s}", "key", ct_templates[key].token);
+	root = nft_json_pack("{s:s}", "key", ct_templates[key].token);
 
 	if (expr->ct.direction < 0)
 		goto out;
@@ -626,7 +635,7 @@ json_t *ct_expr_json(const struct expr *expr, struct output_ctx *octx)
 	if (dirstr)
 		json_object_set_new(root, "dir", json_string(dirstr));
 out:
-	return json_pack("{s:o}", "ct", root);
+	return nft_json_pack("{s:o}", "ct", root);
 }
 
 json_t *concat_expr_json(const struct expr *expr, struct output_ctx *octx)
@@ -637,7 +646,7 @@ json_t *concat_expr_json(const struct expr *expr, struct output_ctx *octx)
 	list_for_each_entry(i, &expr->expressions, list)
 		json_array_append_new(array, expr_print_json(i, octx));
 
-	return json_pack("{s:o}", "concat", array);
+	return nft_json_pack("{s:o}", "concat", array);
 }
 
 json_t *set_expr_json(const struct expr *expr, struct output_ctx *octx)
@@ -648,7 +657,7 @@ json_t *set_expr_json(const struct expr *expr, struct output_ctx *octx)
 	list_for_each_entry(i, &expr->expressions, list)
 		json_array_append_new(array, expr_print_json(i, octx));
 
-	return json_pack("{s:o}", "set", array);
+	return nft_json_pack("{s:o}", "set", array);
 }
 
 json_t *set_ref_expr_json(const struct expr *expr, struct output_ctx *octx)
@@ -656,7 +665,7 @@ json_t *set_ref_expr_json(const struct expr *expr, struct output_ctx *octx)
 	if (set_is_anonymous(expr->set->flags)) {
 		return expr_print_json(expr->set->init, octx);
 	} else {
-		return json_pack("s+", "@", expr->set->handle.set.name);
+		return nft_json_pack("s+", "@", expr->set->handle.set.name);
 	}
 }
 
@@ -672,7 +681,7 @@ json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
 	/* these element attributes require formal set elem syntax */
 	if (expr->timeout || expr->expiration || expr->comment ||
 	    !list_empty(&expr->stmt_list)) {
-		root = json_pack("{s:o}", "val", root);
+		root = nft_json_pack("{s:o}", "val", root);
 
 		if (expr->timeout) {
 			tmp = json_integer(expr->timeout / 1000);
@@ -694,7 +703,7 @@ json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
 			/* TODO: only one statement per element. */
 			break;
 		}
-		return json_pack("{s:o}", "elem", root);
+		return nft_json_pack("{s:o}", "elem", root);
 	}
 
 	return root;
@@ -704,7 +713,7 @@ json_t *prefix_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	json_t *root = expr_print_json(expr->prefix, octx);
 
-	return json_pack("{s:{s:o, s:i}}", "prefix",
+	return nft_json_pack("{s:{s:o, s:i}}", "prefix",
 			 "addr", root,
 			 "len", expr->prefix_len);
 }
@@ -717,7 +726,7 @@ json_t *list_expr_json(const struct expr *expr, struct output_ctx *octx)
 	list_for_each_entry(i, &expr->expressions, list)
 		json_array_append_new(array, expr_print_json(i, octx));
 
-	//return json_pack("{s:s, s:o}", "type", "list", "val", array);
+	//return nft_json_pack("{s:s, s:o}", "type", "list", "val", array);
 	return array;
 }
 
@@ -728,7 +737,7 @@ json_t *unary_expr_json(const struct expr *expr, struct output_ctx *octx)
 
 json_t *mapping_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
-	return json_pack("[o, o]",
+	return nft_json_pack("[o, o]",
 			 expr_print_json(expr->left, octx),
 			 expr_print_json(expr->right, octx));
 }
@@ -741,7 +750,7 @@ json_t *map_expr_json(const struct expr *expr, struct output_ctx *octx)
 	    expr->mappings->set->data->dtype->type == TYPE_VERDICT)
 		type = "vmap";
 
-	return json_pack("{s:{s:o, s:o}}", type,
+	return nft_json_pack("{s:{s:o, s:o}}", type,
 			 "key", expr_print_json(expr->map, octx),
 			 "data", expr_print_json(expr->mappings, octx));
 }
@@ -763,36 +772,36 @@ json_t *exthdr_expr_json(const struct expr *expr, struct output_ctx *octx)
 			if (offset < 4)
 				offstr = offstrs[offset];
 
-			root = json_pack("{s:s+}", "name", desc, offstr);
+			root = nft_json_pack("{s:s+}", "name", desc, offstr);
 
 			if (!is_exists)
 				json_object_set_new(root, "field", json_string(field));
 		} else {
-			root = json_pack("{s:i, s:i, s:i}",
+			root = nft_json_pack("{s:i, s:i, s:i}",
 					 "base", expr->exthdr.raw_type,
 					 "offset", expr->exthdr.offset,
 					 "len", expr->len);
 		}
 
-		return json_pack("{s:o}", "tcp option", root);
+		return nft_json_pack("{s:o}", "tcp option", root);
 	}
 
 	if (expr->exthdr.op == NFT_EXTHDR_OP_DCCP) {
-		root = json_pack("{s:i}", "type", expr->exthdr.raw_type);
-		return json_pack("{s:o}", "dccp option", root);
+		root = nft_json_pack("{s:i}", "type", expr->exthdr.raw_type);
+		return nft_json_pack("{s:o}", "dccp option", root);
 	}
 
-	root = json_pack("{s:s}", "name", desc);
+	root = nft_json_pack("{s:s}", "name", desc);
 	if (!is_exists)
 		json_object_set_new(root, "field", json_string(field));
 
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_IPV4:
-		return json_pack("{s:o}", "ip option", root);
+		return nft_json_pack("{s:o}", "ip option", root);
 	case NFT_EXTHDR_OP_SCTP:
-		return json_pack("{s:o}", "sctp chunk", root);
+		return nft_json_pack("{s:o}", "sctp chunk", root);
 	default:
-		return json_pack("{s:o}", "exthdr", root);
+		return nft_json_pack("{s:o}", "exthdr", root);
 	}
 }
 
@@ -829,15 +838,15 @@ json_t *verdict_expr_json(const struct expr *expr, struct output_ctx *octx)
 		return NULL;
 	}
 	if (chain)
-		return json_pack("{s:{s:o}}", name, "target", chain);
+		return nft_json_pack("{s:{s:o}}", name, "target", chain);
 	else
-		return json_pack("{s:n}", name);
+		return nft_json_pack("{s:n}", name);
 }
 
 json_t *rt_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	const char *key = rt_templates[expr->rt.key].token;
-	json_t *root = json_pack("{s:s}", "key", key);
+	json_t *root = nft_json_pack("{s:s}", "key", key);
 	const char *family = NULL;
 
 	switch (expr->rt.key) {
@@ -854,7 +863,7 @@ json_t *rt_expr_json(const struct expr *expr, struct output_ctx *octx)
 	if (family)
 		json_object_set_new(root, "family", json_string(family));
 
-	return json_pack("{s:o}", "rt", root);
+	return nft_json_pack("{s:o}", "rt", root);
 }
 
 json_t *numgen_expr_json(const struct expr *expr, struct output_ctx *octx)
@@ -873,7 +882,7 @@ json_t *numgen_expr_json(const struct expr *expr, struct output_ctx *octx)
 		break;
 	}
 
-	return json_pack("{s:{s:s, s:i, s:i}}", "numgen",
+	return nft_json_pack("{s:{s:s, s:i, s:i}}", "numgen",
 			 "mode", mode,
 			 "mod", expr->numgen.mod,
 			 "offset", expr->numgen.offset);
@@ -895,7 +904,7 @@ json_t *hash_expr_json(const struct expr *expr, struct output_ctx *octx)
 		break;
 	}
 
-	root = json_pack("{s:i}", "mod", expr->hash.mod);
+	root = nft_json_pack("{s:i}", "mod", expr->hash.mod);
 	if (expr->hash.seed_set)
 		json_object_set_new(root, "seed",
 				    json_integer(expr->hash.seed));
@@ -905,7 +914,7 @@ json_t *hash_expr_json(const struct expr *expr, struct output_ctx *octx)
 	if (jexpr)
 		json_object_set_new(root, "expr", jexpr);
 
-	return json_pack("{s:o}", type, root);
+	return nft_json_pack("{s:o}", type, root);
 }
 
 json_t *fib_expr_json(const struct expr *expr, struct output_ctx *octx)
@@ -914,7 +923,7 @@ json_t *fib_expr_json(const struct expr *expr, struct output_ctx *octx)
 	unsigned int flags = expr->fib.flags & ~NFTA_FIB_F_PRESENT;
 	json_t *root;
 
-	root = json_pack("{s:s}", "result", fib_result_str(expr->fib.result));
+	root = nft_json_pack("{s:s}", "result", fib_result_str(expr->fib.result));
 
 	if (flags) {
 		json_t *tmp = json_array();
@@ -931,7 +940,7 @@ json_t *fib_expr_json(const struct expr *expr, struct output_ctx *octx)
 
 		json_add_array_new(root, "flags", tmp);
 	}
-	return json_pack("{s:o}", "fib", root);
+	return nft_json_pack("{s:o}", "fib", root);
 }
 
 static json_t *symbolic_constant_json(const struct symbol_table *tbl,
@@ -1004,7 +1013,7 @@ json_t *constant_expr_json(const struct expr *expr, struct output_ctx *octx)
 
 json_t *socket_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
-	return json_pack("{s:{s:s}}", "socket", "key",
+	return nft_json_pack("{s:{s:s}}", "socket", "key",
 			 socket_templates[expr->socket.key].token);
 }
 
@@ -1013,9 +1022,9 @@ json_t *osf_expr_json(const struct expr *expr, struct output_ctx *octx)
 	json_t *root;
 
 	if (expr->osf.flags & NFT_OSF_F_VERSION)
-		root = json_pack("{s:s}", "key", "version");
+		root = nft_json_pack("{s:s}", "key", "version");
 	else
-		root = json_pack("{s:s}", "key", "name");
+		root = nft_json_pack("{s:s}", "key", "name");
 
 	switch (expr->osf.ttl) {
 	case 1:
@@ -1026,7 +1035,7 @@ json_t *osf_expr_json(const struct expr *expr, struct output_ctx *octx)
 		break;
 	}
 
-	return json_pack("{s:o}", "osf", root);
+	return nft_json_pack("{s:o}", "osf", root);
 }
 
 json_t *xfrm_expr_json(const struct expr *expr, struct output_ctx *octx)
@@ -1063,7 +1072,7 @@ json_t *xfrm_expr_json(const struct expr *expr, struct output_ctx *octx)
 		break;
 	}
 
-	root = json_pack("{s:s}", "key", name);
+	root = nft_json_pack("{s:s}", "key", name);
 
 	if (family)
 		json_object_set_new(root, "family", json_string(family));
@@ -1071,7 +1080,7 @@ json_t *xfrm_expr_json(const struct expr *expr, struct output_ctx *octx)
 	json_object_set_new(root, "dir", json_string(dirstr));
 	json_object_set_new(root, "spnum", json_integer(expr->xfrm.spnum));
 
-	return json_pack("{s:o}", "ipsec", root);
+	return nft_json_pack("{s:o}", "ipsec", root);
 }
 
 json_t *integer_type_json(const struct expr *expr, struct output_ctx *octx)
@@ -1193,21 +1202,21 @@ json_t *expr_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 
 json_t *flow_offload_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	return json_pack("{s:{s:s, s:s+}}", "flow",
+	return nft_json_pack("{s:{s:s, s:s+}}", "flow",
 			 "op", "add", "flowtable",
 			 "@", stmt->flow.table_name);
 }
 
 json_t *payload_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	return json_pack("{s: {s:o, s:o}}", "mangle",
+	return nft_json_pack("{s: {s:o, s:o}}", "mangle",
 			 "key", expr_print_json(stmt->payload.expr, octx),
 			 "value", expr_print_json(stmt->payload.val, octx));
 }
 
 json_t *exthdr_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	return json_pack("{s: {s:o, s:o}}", "mangle",
+	return nft_json_pack("{s: {s:o, s:o}}", "mangle",
 			 "key", expr_print_json(stmt->exthdr.expr, octx),
 			 "value", expr_print_json(stmt->exthdr.val, octx));
 }
@@ -1219,7 +1228,7 @@ json_t *quota_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	json_t *root;
 
 	data_unit = get_rate(stmt->quota.bytes, &bytes);
-	root = json_pack("{s:I, s:s}",
+	root = nft_json_pack("{s:I, s:s}",
 			 "val", bytes,
 			 "val_unit", data_unit);
 
@@ -1231,7 +1240,7 @@ json_t *quota_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		json_object_set_new(root, "used_unit", json_string(data_unit));
 	}
 
-	return json_pack("{s:o}", "quota", root);
+	return nft_json_pack("{s:o}", "quota", root);
 }
 
 json_t *ct_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -1244,7 +1253,7 @@ json_t *ct_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		},
 	};
 
-	return json_pack("{s:{s:o, s:o}}", "mangle",
+	return nft_json_pack("{s:{s:o, s:o}}", "mangle",
 			 "key", ct_expr_json(&expr, octx),
 			 "value", expr_print_json(stmt->ct.expr, octx));
 }
@@ -1262,7 +1271,7 @@ json_t *limit_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		burst_unit = get_rate(stmt->limit.burst, &burst);
 	}
 
-	root = json_pack("{s:I, s:I, s:s}",
+	root = nft_json_pack("{s:I, s:I, s:s}",
 			 "rate", rate,
 			 "burst", burst,
 			 "per", get_unit(stmt->limit.unit));
@@ -1274,14 +1283,14 @@ json_t *limit_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		json_object_set_new(root, "burst_unit",
 				    json_string(burst_unit));
 
-	return json_pack("{s:o}", "limit", root);
+	return nft_json_pack("{s:o}", "limit", root);
 }
 
 json_t *fwd_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	json_t *root, *tmp;
 
-	root = json_pack("{s:o}", "dev", expr_print_json(stmt->fwd.dev, octx));
+	root = nft_json_pack("{s:o}", "dev", expr_print_json(stmt->fwd.dev, octx));
 
 	if (stmt->fwd.addr) {
 		tmp = json_string(family2str(stmt->fwd.family));
@@ -1291,12 +1300,12 @@ json_t *fwd_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		json_object_set_new(root, "addr", tmp);
 	}
 
-	return json_pack("{s:o}", "fwd", root);
+	return nft_json_pack("{s:o}", "fwd", root);
 }
 
 json_t *notrack_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	return json_pack("{s:n}", "notrack");
+	return nft_json_pack("{s:n}", "notrack");
 }
 
 json_t *dup_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -1304,27 +1313,27 @@ json_t *dup_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	json_t *root;
 
 	if (stmt->dup.to) {
-		root = json_pack("{s:o}", "addr", expr_print_json(stmt->dup.to, octx));
+		root = nft_json_pack("{s:o}", "addr", expr_print_json(stmt->dup.to, octx));
 		if (stmt->dup.dev)
 			json_object_set_new(root, "dev",
 					    expr_print_json(stmt->dup.dev, octx));
 	} else {
 		root = json_null();
 	}
-	return json_pack("{s:o}", "dup", root);
+	return nft_json_pack("{s:o}", "dup", root);
 }
 
 json_t *meta_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	json_t *root;
 
-	root = json_pack("{s:{s:s}}", "meta",
+	root = nft_json_pack("{s:{s:s}}", "meta",
 			 "key", meta_templates[stmt->meta.key].token);
-	root = json_pack("{s:o, s:o}",
+	root = nft_json_pack("{s:o, s:o}",
 			 "key", root,
 			 "value", expr_print_json(stmt->meta.expr, octx));
 
-	return json_pack("{s:o}", "mangle", root);
+	return nft_json_pack("{s:o}", "mangle", root);
 }
 
 json_t *log_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -1373,7 +1382,7 @@ json_t *log_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		root = json_null();
 	}
 
-	return json_pack("{s:o}", "log", root);
+	return nft_json_pack("{s:o}", "log", root);
 }
 
 static json_t *nat_flags_json(uint32_t flags)
@@ -1435,7 +1444,7 @@ json_t *nat_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		root = json_null();
 	}
 
-	return json_pack("{s:o}", nat_etype2str(stmt->nat.type), root);
+	return nft_json_pack("{s:o}", nat_etype2str(stmt->nat.type), root);
 }
 
 json_t *reject_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -1465,7 +1474,7 @@ json_t *reject_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	}
 
 	if (!type && !jexpr)
-		return json_pack("{s:n}", "reject");
+		return nft_json_pack("{s:n}", "reject");
 
 	root = json_object();
 	if (type)
@@ -1473,15 +1482,15 @@ json_t *reject_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	if (jexpr)
 		json_object_set_new(root, "expr", jexpr);
 
-	return json_pack("{s:o}", "reject", root);
+	return nft_json_pack("{s:o}", "reject", root);
 }
 
 json_t *counter_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	if (nft_output_stateless(octx))
-		return json_pack("{s:n}", "counter");
+		return nft_json_pack("{s:n}", "counter");
 
-	return json_pack("{s:{s:I, s:I}}", "counter",
+	return nft_json_pack("{s:{s:I, s:I}}", "counter",
 			 "packets", stmt->counter.packets,
 			 "bytes", stmt->counter.bytes);
 }
@@ -1489,16 +1498,16 @@ json_t *counter_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 json_t *last_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	if (nft_output_stateless(octx) || stmt->last.set == 0)
-		return json_pack("{s:n}", "last");
+		return nft_json_pack("{s:n}", "last");
 
-	return json_pack("{s:{s:I}}", "last", "used", stmt->last.used);
+	return nft_json_pack("{s:{s:I}}", "last", "used", stmt->last.used);
 }
 
 json_t *set_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	json_t *root;
 
-	root = json_pack("{s:s, s:o, s:s+}",
+	root = nft_json_pack("{s:s, s:o, s:s+}",
 			 "op", set_stmt_op_names[stmt->set.op],
 			 "elem", expr_print_json(stmt->set.key, octx),
 			 "set", "@", stmt->set.set->set->handle.set.name);
@@ -1509,14 +1518,14 @@ json_t *set_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 						       octx));
 	}
 
-	return json_pack("{s:o}", "set", root);
+	return nft_json_pack("{s:o}", "set", root);
 }
 
 json_t *map_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	json_t *root;
 
-	root = json_pack("{s:s, s:o, s:o, s:s+}",
+	root = nft_json_pack("{s:s, s:o, s:o, s:s+}",
 			 "op", set_stmt_op_names[stmt->map.op],
 			 "elem", expr_print_json(stmt->map.key, octx),
 			 "data", expr_print_json(stmt->map.data, octx),
@@ -1528,7 +1537,7 @@ json_t *map_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 						       octx));
 	}
 
-	return json_pack("{s:o}", "map", root);
+	return nft_json_pack("{s:o}", "map", root);
 }
 
 json_t *objref_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -1540,7 +1549,7 @@ json_t *objref_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	else
 		name = objref_type_name(stmt->objref.type);
 
-	return json_pack("{s:o}", name, expr_print_json(stmt->objref.expr, octx));
+	return nft_json_pack("{s:o}", name, expr_print_json(stmt->objref.expr, octx));
 }
 
 json_t *meter_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -1552,7 +1561,7 @@ json_t *meter_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	tmp = stmt_print_json(stmt->meter.stmt, octx);
 	octx->flags = flags;
 
-	root = json_pack("{s:o, s:o, s:i}",
+	root = nft_json_pack("{s:o, s:o, s:i}",
 			 "key", expr_print_json(stmt->meter.key, octx),
 			 "stmt", tmp,
 			 "size", stmt->meter.size);
@@ -1561,7 +1570,7 @@ json_t *meter_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		json_object_set_new(root, "name", tmp);
 	}
 
-	return json_pack("{s:o}", "meter", root);
+	return nft_json_pack("{s:o}", "meter", root);
 }
 
 json_t *queue_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -1586,7 +1595,7 @@ json_t *queue_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		root = json_null();
 	}
 
-	return json_pack("{s:o}", "queue", root);
+	return nft_json_pack("{s:o}", "queue", root);
 }
 
 json_t *verdict_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -1596,12 +1605,12 @@ json_t *verdict_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 
 json_t *connlimit_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	json_t *root = json_pack("{s:i}", "val", stmt->connlimit.count);
+	json_t *root = nft_json_pack("{s:i}", "val", stmt->connlimit.count);
 
 	if (stmt->connlimit.flags & NFT_CONNLIMIT_F_INV)
 		json_object_set_new(root, "inv", json_true());
 
-	return json_pack("{s:o}", "ct count", root);
+	return nft_json_pack("{s:o}", "ct count", root);
 }
 
 json_t *tproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -1624,7 +1633,7 @@ json_t *tproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		json_object_set_new(root, "port", tmp);
 	}
 
-	return json_pack("{s:o}", "tproxy", root);
+	return nft_json_pack("{s:o}", "tproxy", root);
 }
 
 json_t *synproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
@@ -1649,12 +1658,12 @@ json_t *synproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		root = json_null();
 	}
 
-	return json_pack("{s:o}", "synproxy", root);
+	return nft_json_pack("{s:o}", "synproxy", root);
 }
 
 json_t *optstrip_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	return json_pack("{s:o}", "reset",
+	return nft_json_pack("{s:o}", "reset",
 			 expr_print_json(stmt->optstrip.expr, octx));
 }
 
@@ -1666,7 +1675,7 @@ json_t *xt_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		[NFT_XT_WATCHER]        = "watcher",
 	};
 
-	return json_pack("{s:{s:s, s:s}}", "xt",
+	return nft_json_pack("{s:{s:s, s:s}}", "xt",
 			 "type", xt_typename[stmt->xt.type],
 			 "name", stmt->xt.name);
 }
@@ -1811,7 +1820,7 @@ static json_t *do_list_set_json(struct netlink_ctx *ctx,
 			return json_null();
 	}
 
-	return json_pack("[o]", set_print_json(&ctx->nft->output, set));
+	return nft_json_pack("[o]", set_print_json(&ctx->nft->output, set));
 }
 
 static json_t *do_list_sets_json(struct netlink_ctx *ctx, struct cmd *cmd)
@@ -1909,7 +1918,7 @@ static json_t *do_list_flowtables_json(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static json_t *generate_json_metainfo(void)
 {
-	return json_pack("{s: {s:s, s:s, s:i}}", "metainfo",
+	return nft_json_pack("{s: {s:s, s:s, s:i}}", "metainfo",
 			 "version", PACKAGE_VERSION,
 			 "release_name", RELEASE_NAME,
 			 "json_schema_version", JSON_SCHEMA_VERSION);
@@ -2027,7 +2036,7 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	json_array_insert_new(root, 0, generate_json_metainfo());
 
-	root = json_pack("{s:o}", "nftables", root);
+	root = nft_json_pack("{s:o}", "nftables", root);
 	json_dumpf(root, ctx->nft->output.output_fp, 0);
 	json_decref(root);
 	fprintf(ctx->nft->output.output_fp, "\n");
@@ -2040,7 +2049,7 @@ static void monitor_print_json(struct netlink_mon_handler *monh,
 {
 	struct nft_ctx *nft = monh->ctx->nft;
 
-	obj = json_pack("{s:o}", cmd, obj);
+	obj = nft_json_pack("{s:o}", cmd, obj);
 	if (nft_output_echo(&nft->output) && !nft->json_root) {
 		json_array_append_new(nft->json_echo, obj);
 	} else {
-- 
2.49.0

