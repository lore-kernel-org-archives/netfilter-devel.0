Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A9961DB452
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 22:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724106355; cv=none; b=VJuvKjptc/Y+aaqBq0qPWUdeZzJnVebZ1FOf0p7511jwijn1B4XIYGysJF4B/HF8t9q8GgLRyEfLHPUfdF+DuFf500bXIHLpy3cHQ7xuNO1enQz8Ljtsogu2LJeA3sJWR7apvnAtP4QOBCI+28rqKW8M+erJbnRhG3nmiz5Ii+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724106355; c=relaxed/simple;
	bh=8zlfTjTA5lUn8XZaiIwYEc34jopFJhfhzCDm9J6npXo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a7Dk0QH44GUFNKIzWWFd9plSjQATAU2W7L9ZNaPzqH84Lj8tLHY9RQgKff3pqYyKXIVNzVCxLXXPvQ6+ctf6ZBFy6vovvrn5X2jr3F7kmxiX3IhFVM4uZlVWAVW0gseRbQD3RebdUkUTiUnXJrtA4+AnD+JKhOZZR+AxwpAt4JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: sebastian.walz@secunet.com
Subject: [PATCH nft 3/4] parser_json: fix handle memleak from error path
Date: Tue, 20 Aug 2024 00:23:03 +0200
Message-Id: <20240819222304.1041208-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240819222304.1041208-1-pablo@netfilter.org>
References: <20240819222304.1041208-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Based on patch from Sebastian Walz.

Fixes: 586ad210368b ("libnftables: Implement JSON parser")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_json.c | 93 ++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 46 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 8ca44efbb52e..d18188d81b3f 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3168,8 +3168,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 	chain->hook.name = chain_hookname_lookup(hookstr);
 	if (!chain->hook.name) {
 		json_error(ctx, "Invalid chain hook '%s'.", hookstr);
-		chain_free(chain);
-		return NULL;
+		goto err_free_chain;
 	}
 
 	json_unpack(root, "{s:o}", "dev", &devs);
@@ -3178,8 +3177,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		chain->dev_expr = json_parse_devs(ctx, devs);
 		if (!chain->dev_expr) {
 			json_error(ctx, "Invalid chain dev.");
-			chain_free(chain);
-			return NULL;
+			goto err_free_chain;
 		}
 	}
 
@@ -3187,8 +3185,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		chain->policy = parse_policy(policy);
 		if (!chain->policy) {
 			json_error(ctx, "Unknown policy '%s'.", policy);
-			chain_free(chain);
-			return NULL;
+			goto err_free_chain;
 		}
 	}
 
@@ -3197,6 +3194,11 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 
 	handle_merge(&chain->handle, &h);
 	return cmd_alloc(op, obj, &h, int_loc, chain);
+
+err_free_chain:
+	chain_free(chain);
+	handle_free(&h);
+	return NULL;
 }
 
 static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
@@ -3236,6 +3238,7 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 
 	if (!json_is_array(tmp)) {
 		json_error(ctx, "Value of property \"expr\" must be an array.");
+		handle_free(&h);
 		return NULL;
 	}
 
@@ -3255,16 +3258,14 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		if (!json_is_object(value)) {
 			json_error(ctx, "Unexpected expr array element of type %s, expected object.",
 				   json_typename(value));
-			rule_free(rule);
-			return NULL;
+			goto err_free_rule;
 		}
 
 		stmt = json_parse_stmt(ctx, value);
 
 		if (!stmt) {
 			json_error(ctx, "Parsing expr array at index %zd failed.", index);
-			rule_free(rule);
-			return NULL;
+			goto err_free_rule;
 		}
 
 		rule_stmt_append(rule, stmt);
@@ -3274,6 +3275,11 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		json_object_del(root, "handle");
 
 	return cmd_alloc(op, obj, &h, int_loc, rule);
+
+err_free_rule:
+	rule_free(rule);
+	handle_free(&h);
+	return NULL;
 }
 
 static int string_to_nft_object(const char *str)
@@ -3654,8 +3660,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			if (ret < 0 || ret >= (int)sizeof(obj->secmark.ctx)) {
 				json_error(ctx, "Invalid secmark context '%s', max length is %zu.",
 					   tmp, sizeof(obj->secmark.ctx));
-				obj_free(obj);
-				return NULL;
+				goto err_free_obj;
 			}
 		}
 		break;
@@ -3671,8 +3676,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			    ret >= (int)sizeof(obj->ct_helper.name)) {
 				json_error(ctx, "Invalid CT helper type '%s', max length is %zu.",
 					   tmp, sizeof(obj->ct_helper.name));
-				obj_free(obj);
-				return NULL;
+				goto err_free_obj;
 			}
 		}
 		if (!json_unpack(root, "{s:s}", "protocol", &tmp)) {
@@ -3682,15 +3686,13 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 				obj->ct_helper.l4proto = IPPROTO_UDP;
 			} else {
 				json_error(ctx, "Invalid ct helper protocol '%s'.", tmp);
-				obj_free(obj);
-				return NULL;
+				goto err_free_obj;
 			}
 		}
 		if (!json_unpack(root, "{s:s}", "l3proto", &tmp) &&
 		    parse_family(tmp, &l3proto)) {
 			json_error(ctx, "Invalid ct helper l3proto '%s'.", tmp);
-			obj_free(obj);
-			return NULL;
+			goto err_free_obj;
 		}
 		obj->ct_helper.l3proto = l3proto;
 		break;
@@ -3704,23 +3706,19 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 				obj->ct_timeout.l4proto = IPPROTO_UDP;
 			} else {
 				json_error(ctx, "Invalid ct timeout protocol '%s'.", tmp);
-				obj_free(obj);
-				return NULL;
+				goto err_free_obj;
 			}
 		}
 		if (!json_unpack(root, "{s:s}", "l3proto", &tmp) &&
 		    parse_family(tmp, &l3proto)) {
 			json_error(ctx, "Invalid ct timeout l3proto '%s'.", tmp);
-			obj_free(obj);
-			return NULL;
+			goto err_free_obj;
 		}
 		obj->ct_timeout.l3proto = l3proto;
 
 		init_list_head(&obj->ct_timeout.timeout_list);
-		if (json_parse_ct_timeout_policy(ctx, root, obj)) {
-			obj_free(obj);
-			return NULL;
-		}
+		if (json_parse_ct_timeout_policy(ctx, root, obj))
+			goto err_free_obj;
 		break;
 	case NFT_OBJECT_CT_EXPECT:
 		cmd_obj = CMD_OBJ_CT_EXPECT;
@@ -3728,8 +3726,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		if (!json_unpack(root, "{s:s}", "l3proto", &tmp) &&
 		    parse_family(tmp, &l3proto)) {
 			json_error(ctx, "Invalid ct expectation l3proto '%s'.", tmp);
-			obj_free(obj);
-			return NULL;
+			goto err_free_obj;
 		}
 		obj->ct_expect.l3proto = l3proto;
 		if (!json_unpack(root, "{s:s}", "protocol", &tmp)) {
@@ -3739,8 +3736,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 				obj->ct_expect.l4proto = IPPROTO_UDP;
 			} else {
 				json_error(ctx, "Invalid ct expectation protocol '%s'.", tmp);
-				obj_free(obj);
-				return NULL;
+				goto err_free_obj;
 			}
 		}
 		if (!json_unpack(root, "{s:i}", "dport", &i))
@@ -3754,10 +3750,9 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		obj->type = NFT_OBJECT_LIMIT;
 		if (json_unpack_err(ctx, root, "{s:I, s:s}",
 				    "rate", &obj->limit.rate,
-				    "per", &tmp)) {
-			obj_free(obj);
-			return NULL;
-		}
+				    "per", &tmp))
+			goto err_free_obj;
+
 		json_unpack(root, "{s:s}", "rate_unit", &rate_unit);
 		json_unpack(root, "{s:b}", "inv", &inv);
 		json_unpack(root, "{s:i}", "burst", &obj->limit.burst);
@@ -3778,20 +3773,18 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	case CMD_OBJ_SYNPROXY:
 		obj->type = NFT_OBJECT_SYNPROXY;
 		if (json_unpack_err(ctx, root, "{s:i, s:i}",
-				    "mss", &i, "wscale", &j)) {
-			obj_free(obj);
-			return NULL;
-		}
+				    "mss", &i, "wscale", &j))
+			goto err_free_obj;
+
 		obj->synproxy.mss = i;
 		obj->synproxy.wscale = j;
 		obj->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
 		obj->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
 		if (!json_unpack(root, "{s:o}", "flags", &jflags)) {
 			flags = json_parse_synproxy_flags(ctx, jflags);
-			if (flags < 0) {
-				obj_free(obj);
-				return NULL;
-			}
+			if (flags < 0)
+				goto err_free_obj;
+
 			obj->synproxy.flags |= flags;
 		}
 		break;
@@ -3803,6 +3796,11 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		json_object_del(root, "handle");
 
 	return cmd_alloc(op, cmd_obj, &h, int_loc, obj);
+
+err_free_obj:
+	obj_free(obj);
+	handle_free(&h);
+	return NULL;
 }
 
 static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
@@ -3917,8 +3915,7 @@ static struct cmd *json_parse_cmd_replace(struct json_ctx *ctx,
 		if (!json_is_object(value)) {
 			json_error(ctx, "Unexpected expr array element of type %s, expected object.",
 				   json_typename(value));
-			rule_free(rule);
-			return NULL;
+			goto err_free_replace;
 		}
 
 		stmt = json_parse_stmt(ctx, value);
@@ -3926,8 +3923,7 @@ static struct cmd *json_parse_cmd_replace(struct json_ctx *ctx,
 		if (!stmt) {
 			json_error(ctx, "Parsing expr array at index %zd failed.",
 				   index);
-			rule_free(rule);
-			return NULL;
+			goto err_free_replace;
 		}
 
 		rule_stmt_append(rule, stmt);
@@ -3937,6 +3933,11 @@ static struct cmd *json_parse_cmd_replace(struct json_ctx *ctx,
 		json_object_del(root, "handle");
 
 	return cmd_alloc(op, CMD_OBJ_RULE, &h, int_loc, rule);
+
+err_free_replace:
+	rule_free(rule);
+	handle_free(&h);
+	return NULL;
 }
 
 static struct cmd *json_parse_cmd_list_multiple(struct json_ctx *ctx,
-- 
2.30.2

