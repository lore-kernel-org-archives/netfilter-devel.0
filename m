Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4985612A14B
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 12:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709814775; cv=none; b=gqPRddYzkxuNQw8TUUku0us+h7CpFuI0T08XwbGTp7imipUBHiQGMXvIz+cSvYMXQIdp2/7HqmfviKEsQmSZw4Ypbfo6HjmdRFWsAL8wHvtr8rHsJ496DcTcB/A8WUOg6cRekcw4jnbC7CEmQduQNFu6gy+cARm66VpqYNOGS5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709814775; c=relaxed/simple;
	bh=qPOewEEoXBeGUiYtAcliv87pQJJesiqGe7ebldsknN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQ3tM58oyssruyK4CuOq8lHTvzb6FiB7oQF58Kl2mB5Md8sxqZfmgXMBQ02MwPRodyOXflIjpznZf5zg7VGZ9lXm3OTPfZUwABf9yvavDyvFLlIZJ8yFl4RjvLlzP0vdpFhWFs1/ViGrHL3R5obDUhmN5hIfXmvrS17RK9y4EN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1riCvb-00073M-Qc; Thu, 07 Mar 2024 13:32:51 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: phil@nwl.cc,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/5] parser_json: add and use CMD_ERR helpers
Date: Thu,  7 Mar 2024 13:26:33 +0100
Message-ID: <20240307122640.29507-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307122640.29507-1-fw@strlen.de>
References: <20240307122640.29507-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upcoming patch will make NULL a valid return value,
indicating that the data was appended to an existing object,
e.g. table->chains, table->objs, chain->rules, etc.

Switch all return locations queueing erros to return CMD_ERR_PTR(-1).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 128 ++++++++++++++++++++++++++--------------------
 1 file changed, 73 insertions(+), 55 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 7540df59dc8f..91c1e01cee52 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -63,6 +63,18 @@ struct json_ctx {
 #define is_DTYPE(ctx)	(ctx->flags & CTX_F_DTYPE)
 #define is_SET_RHS(ctx)	(ctx->flags & CTX_F_SET_RHS)
 
+static inline bool CMD_IS_ERR(struct cmd *cmd)
+{
+	long x = (long)cmd;
+
+	return x < 0;
+}
+
+static inline struct cmd *CMD_ERR_PTR(long err)
+{
+	return (struct cmd *)err;
+}
+
 struct json_cmd_assoc {
 	struct json_cmd_assoc *next;
 	struct hlist_node hnode;
@@ -2976,22 +2988,22 @@ static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 
 	if (json_unpack_err(ctx, root, "{s:s}",
 			    "family", &family))
-		return NULL;
+		return CMD_ERR_PTR(-1);
 
 	if (op != CMD_DELETE) {
 		if (json_unpack_err(ctx, root, "{s:s}", "name", &h.table.name))
-			return NULL;
+			return CMD_ERR_PTR(-1);
 
 		json_unpack(root, "{s:s}", "comment", &comment);
 	} else if (op == CMD_DELETE &&
 		   json_unpack(root, "{s:s}", "name", &h.table.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
 		json_error(ctx, "Either name or handle required to delete a table.");
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 	if (parse_family(family, &h.family)) {
 		json_error(ctx, "Unknown family '%s'.", family);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 	if (h.table.name)
 		h.table.name = xstrdup(h.table.name);
@@ -3072,21 +3084,21 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
 			    "table", &h.table.name))
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	if (op != CMD_DELETE) {
 		if (json_unpack_err(ctx, root, "{s:s}", "name", &h.chain.name))
-			return NULL;
+			return CMD_ERR_PTR(-1);
 
 		json_unpack(root, "{s:s}", "comment", &comment);
 	} else if (op == CMD_DELETE &&
 		   json_unpack(root, "{s:s}", "name", &h.chain.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
 		json_error(ctx, "Either name or handle required to delete a chain.");
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 	if (parse_family(family, &h.family)) {
 		json_error(ctx, "Unknown family '%s'.", family);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 	h.table.name = xstrdup(h.table.name);
 	if (h.chain.name)
@@ -3118,7 +3130,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 	if (!chain->hook.name) {
 		json_error(ctx, "Invalid chain hook '%s'.", hookstr);
 		chain_free(chain);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 
 	json_unpack(root, "{s:o}", "dev", &devs);
@@ -3128,7 +3140,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		if (!chain->dev_expr) {
 			json_error(ctx, "Invalid chain dev.");
 			chain_free(chain);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 	}
 
@@ -3137,7 +3149,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		if (!chain->policy) {
 			json_error(ctx, "Unknown policy '%s'.", policy);
 			chain_free(chain);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 	}
 
@@ -3165,17 +3177,17 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 			    "family", &family,
 			    "table", &h.table.name,
 			    "chain", &h.chain.name))
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	if (op != CMD_DELETE &&
 	    json_unpack_err(ctx, root, "{s:o}", "expr", &tmp))
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	else if ((op == CMD_DELETE || op == CMD_DESTROY) &&
 		 json_unpack_err(ctx, root, "{s:I}", "handle", &h.handle.id))
-		return NULL;
+		return CMD_ERR_PTR(-1);
 
 	if (parse_family(family, &h.family)) {
 		json_error(ctx, "Unknown family '%s'.", family);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 	h.table.name = xstrdup(h.table.name);
 	h.chain.name = xstrdup(h.chain.name);
@@ -3185,7 +3197,7 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 
 	if (!json_is_array(tmp)) {
 		json_error(ctx, "Value of property \"expr\" must be an array.");
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 
 	if (!json_unpack(root, "{s:I}", "index", &h.index.id)) {
@@ -3205,7 +3217,7 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 			json_error(ctx, "Unexpected expr array element of type %s, expected object.",
 				   json_typename(value));
 			rule_free(rule);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 
 		stmt = json_parse_stmt(ctx, value);
@@ -3213,7 +3225,7 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		if (!stmt) {
 			json_error(ctx, "Parsing expr array at index %zd failed.", index);
 			rule_free(rule);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 
 		rule_stmt_append(rule, stmt);
@@ -3273,15 +3285,15 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
 			    "table", &h.table.name))
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	if (op != CMD_DELETE &&
 	    json_unpack_err(ctx, root, "{s:s}", "name", &h.set.name)) {
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	} else if ((op == CMD_DELETE || op == CMD_DESTROY) &&
 		   json_unpack(root, "{s:s}", "name", &h.set.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
 		json_error(ctx, "Either name or handle required to delete a set.");
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 
 	if (parse_family(family, &h.family)) {
@@ -3309,14 +3321,14 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 		json_error(ctx, "Invalid set type.");
 		set_free(set);
 		handle_free(&h);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 	set->key = json_parse_dtype_expr(ctx, tmp);
 	if (!set->key) {
 		json_error(ctx, "Invalid set type.");
 		set_free(set);
 		handle_free(&h);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 
 	if (!json_unpack(root, "{s:s}", "map", &dtype_ext)) {
@@ -3334,7 +3346,7 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 			json_error(ctx, "Invalid map type '%s'.", dtype_ext);
 			set_free(set);
 			handle_free(&h);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 	}
 	if (!json_unpack(root, "{s:s}", "policy", &policy)) {
@@ -3346,7 +3358,7 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 			json_error(ctx, "Unknown set policy '%s'.", policy);
 			set_free(set);
 			handle_free(&h);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 	}
 	if (!json_unpack(root, "{s:o}", "flags", &tmp)) {
@@ -3361,7 +3373,7 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 				json_error(ctx, "Invalid set flag at index %zu.", index);
 				set_free(set);
 				handle_free(&h);
-				return NULL;
+				return CMD_ERR_PTR(-1);
 			}
 			set->flags |= flag;
 		}
@@ -3372,7 +3384,7 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 			json_error(ctx, "Invalid set elem expression.");
 			set_free(set);
 			handle_free(&h);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 	}
 	if (!json_unpack(root, "{s:I}", "timeout", &set->timeout))
@@ -3407,11 +3419,11 @@ static struct cmd *json_parse_cmd_add_element(struct json_ctx *ctx,
 			    "table", &h.table.name,
 			    "name", &h.set.name,
 			    "elem", &tmp))
-		return NULL;
+		return CMD_ERR_PTR(-1);
 
 	if (parse_family(family, &h.family)) {
 		json_error(ctx, "Unknown family '%s'.", family);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 	h.table.name = xstrdup(h.table.name);
 	h.set.name = xstrdup(h.set.name);
@@ -3420,7 +3432,7 @@ static struct cmd *json_parse_cmd_add_element(struct json_ctx *ctx,
 	if (!expr) {
 		json_error(ctx, "Invalid set.");
 		handle_free(&h);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 	return cmd_alloc(op, cmd_obj, &h, int_loc, expr);
 }
@@ -3438,21 +3450,21 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
 			    "table", &h.table.name))
-		return NULL;
+		return CMD_ERR_PTR(-1);
 
 	if (op != CMD_DELETE &&
 	    json_unpack_err(ctx, root, "{s:s}", "name", &h.flowtable.name)) {
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	} else if ((op == CMD_DELETE || op == CMD_DESTROY) &&
 		   json_unpack(root, "{s:s}", "name", &h.flowtable.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
 		json_error(ctx, "Either name or handle required to delete a flowtable.");
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 
 	if (parse_family(family, &h.family)) {
 		json_error(ctx, "Unknown family '%s'.", family);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 	h.table.name = xstrdup(h.table.name);
 	if (h.flowtable.name)
@@ -3465,7 +3477,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 			    "hook", &hook,
 			    "prio", &prio)) {
 		handle_free(&h);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 
 	json_unpack(root, "{s:o}", "dev", &devs);
@@ -3474,7 +3486,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 	if (!hookstr) {
 		json_error(ctx, "Invalid flowtable hook '%s'.", hook);
 		handle_free(&h);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 
 	flowtable = flowtable_alloc(int_loc);
@@ -3490,7 +3502,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 			json_error(ctx, "Invalid flowtable dev.");
 			flowtable_free(flowtable);
 			handle_free(&h);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 	}
 	return cmd_alloc(op, cmd_obj, &h, int_loc, flowtable);
@@ -3542,22 +3554,22 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
 			    "table", &h.table.name))
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	if ((op != CMD_DELETE ||
 	     cmd_obj == NFT_OBJECT_CT_HELPER) &&
 	    json_unpack_err(ctx, root, "{s:s}", "name", &h.obj.name)) {
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	} else if ((op == CMD_DELETE || op == CMD_DESTROY) &&
 		   cmd_obj != NFT_OBJECT_CT_HELPER &&
 		   json_unpack(root, "{s:s}", "name", &h.obj.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
 		json_error(ctx, "Either name or handle required to delete an object.");
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 
 	if (parse_family(family, &h.family)) {
 		json_error(ctx, "Unknown family '%s'.", family);
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 	h.table.name = xstrdup(h.table.name);
 	if (h.obj.name)
@@ -3598,7 +3610,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 				json_error(ctx, "Invalid secmark context '%s', max length is %zu.",
 					   tmp, sizeof(obj->secmark.ctx));
 				obj_free(obj);
-				return NULL;
+				return CMD_ERR_PTR(-1);
 			}
 		}
 		break;
@@ -3615,7 +3627,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 				json_error(ctx, "Invalid CT helper type '%s', max length is %zu.",
 					   tmp, sizeof(obj->ct_helper.name));
 				obj_free(obj);
-				return NULL;
+				return CMD_ERR_PTR(-1);
 			}
 		}
 		if (!json_unpack(root, "{s:s}", "protocol", &tmp)) {
@@ -3626,14 +3638,14 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			} else {
 				json_error(ctx, "Invalid ct helper protocol '%s'.", tmp);
 				obj_free(obj);
-				return NULL;
+				return CMD_ERR_PTR(-1);
 			}
 		}
 		if (!json_unpack(root, "{s:s}", "l3proto", &tmp) &&
 		    parse_family(tmp, &l3proto)) {
 			json_error(ctx, "Invalid ct helper l3proto '%s'.", tmp);
 			obj_free(obj);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 		obj->ct_helper.l3proto = l3proto;
 		break;
@@ -3648,21 +3660,21 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			} else {
 				json_error(ctx, "Invalid ct timeout protocol '%s'.", tmp);
 				obj_free(obj);
-				return NULL;
+				return CMD_ERR_PTR(-1);
 			}
 		}
 		if (!json_unpack(root, "{s:s}", "l3proto", &tmp) &&
 		    parse_family(tmp, &l3proto)) {
 			json_error(ctx, "Invalid ct timeout l3proto '%s'.", tmp);
 			obj_free(obj);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 		obj->ct_timeout.l3proto = l3proto;
 
 		init_list_head(&obj->ct_timeout.timeout_list);
 		if (json_parse_ct_timeout_policy(ctx, root, obj)) {
 			obj_free(obj);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 		break;
 	case NFT_OBJECT_CT_EXPECT:
@@ -3672,7 +3684,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		    parse_family(tmp, &l3proto)) {
 			json_error(ctx, "Invalid ct expectation l3proto '%s'.", tmp);
 			obj_free(obj);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 		obj->ct_expect.l3proto = l3proto;
 		if (!json_unpack(root, "{s:s}", "protocol", &tmp)) {
@@ -3683,7 +3695,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			} else {
 				json_error(ctx, "Invalid ct expectation protocol '%s'.", tmp);
 				obj_free(obj);
-				return NULL;
+				return CMD_ERR_PTR(-1);
 			}
 		}
 		if (!json_unpack(root, "{s:i}", "dport", &i))
@@ -3699,7 +3711,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 				    "rate", &obj->limit.rate,
 				    "per", &tmp)) {
 			obj_free(obj);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 		json_unpack(root, "{s:s}", "rate_unit", &rate_unit);
 		json_unpack(root, "{s:b}", "inv", &inv);
@@ -3723,7 +3735,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		if (json_unpack_err(ctx, root, "{s:i, s:i}",
 				    "mss", &i, "wscale", &j)) {
 			obj_free(obj);
-			return NULL;
+			return CMD_ERR_PTR(-1);
 		}
 		obj->synproxy.mss = i;
 		obj->synproxy.wscale = j;
@@ -3778,7 +3790,7 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 	if (!json_is_object(root)) {
 		json_error(ctx, "Value of add command must be object (got %s instead).",
 			   json_typename(root));
-		return NULL;
+		return CMD_ERR_PTR(-1);
 	}
 
 	for (i = 0; i < array_size(cmd_obj_table); i++) {
@@ -3794,7 +3806,7 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 		return cmd_obj_table[i].cb(ctx, tmp, op, cmd_obj_table[i].obj);
 	}
 	json_error(ctx, "Unknown object passed to add command.");
-	return NULL;
+	return CMD_ERR_PTR(-1);
 }
 
 static struct cmd *json_parse_cmd_replace(struct json_ctx *ctx,
@@ -4142,11 +4154,17 @@ static int json_parse_cmd(struct json_ctx *ctx, json_t *root)
 			continue;
 
 		cmd = parse_cb_table[i].cb(ctx, tmp, parse_cb_table[i].op);
-		goto out;
+		if (!CMD_IS_ERR(cmd))
+			goto out;
+
+		return -1;
 	}
 
 	/* to accept 'list ruleset' output 1:1, try add command */
 	cmd = json_parse_cmd_add(ctx, root, CMD_ADD);
+	if (CMD_IS_ERR(cmd))
+		return -1;
+
 out:
 	if (cmd) {
 		list_add_tail(&cmd->list, ctx->cmds);
-- 
2.43.0

