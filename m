Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A531FF1C9
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375747; cv=none; b=oezQcuZs7i3rbAuKNACaJnWx3IwE1XwETGl8R+wHuW7FcnBUHcYTWeN8bscRUXFBfeFsc18RgDFbhZ3ygbOmPPFHQ+CalCwHaG1/Mthla9FquQA+P5EicSiNBO1YooItjSO+ZYUqKogZ9h6ZLoy3A2xp2TtUpo4ZGoD3MspBefw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375747; c=relaxed/simple;
	bh=2LmlLMVBFV5AbmK+YQujdI37dthbhQSFNPmz/iOLq0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCtiB0ZAIRO5zytTsaPu2i9z6WUTOWNDYN3cXyf3wCvt2I4/a5qk722CjzH9AK0GhcZcbF2oav4wdPgCf0skM8AlxjwvdqdZbin1JuCmuBQvSqaVlhwWLxZGgC9l0nf6QK8Pe3bA3atiHgi8otLA1c9DesNJ9q+Uo6Yaet0WXNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dSJsBKzU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Wes9HV6p; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dSJsBKzU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Wes9HV6p; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dSJsBKzU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Wes9HV6p";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dSJsBKzU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Wes9HV6p"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1FB9D1F44F;
	Tue, 27 May 2025 19:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+XfBkPQuFK4nskwYVtnewiI5cRaNBpceL6EmP/W44M8=;
	b=dSJsBKzUcyNssA+eMQMbeR/MsJAKIkdIN7IwUk+rUL3oBxX+TNL3lsA2wuheFxHW2CKjUw
	+jElq1VuKAhaU4ehmfXPFAs3tY43iSgMi0ZALWty+ZQZQgaj1WsXolxqrhtgs6N6+WbSKf
	lftDRSGG5yzmkUqo7sGr+dgqq0kZhhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+XfBkPQuFK4nskwYVtnewiI5cRaNBpceL6EmP/W44M8=;
	b=Wes9HV6ppFxbuUUzUbONdhbtGyg7o8BXsADK6Bg8IEet1jDOWbX4mhw6rbc02DWRO5PmaM
	3IgWq6DzQrLd8aBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+XfBkPQuFK4nskwYVtnewiI5cRaNBpceL6EmP/W44M8=;
	b=dSJsBKzUcyNssA+eMQMbeR/MsJAKIkdIN7IwUk+rUL3oBxX+TNL3lsA2wuheFxHW2CKjUw
	+jElq1VuKAhaU4ehmfXPFAs3tY43iSgMi0ZALWty+ZQZQgaj1WsXolxqrhtgs6N6+WbSKf
	lftDRSGG5yzmkUqo7sGr+dgqq0kZhhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+XfBkPQuFK4nskwYVtnewiI5cRaNBpceL6EmP/W44M8=;
	b=Wes9HV6ppFxbuUUzUbONdhbtGyg7o8BXsADK6Bg8IEet1jDOWbX4mhw6rbc02DWRO5PmaM
	3IgWq6DzQrLd8aBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C23B6136E0;
	Tue, 27 May 2025 19:55:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kEsgLLoYNmhJGgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 May 2025 19:55:38 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 6/7 nft] tunnel: add tunnel object and statement json support
Date: Tue, 27 May 2025 21:54:43 +0200
Message-ID: <3af447ec5882618d74eaa5309750a26ac5478073.1748374810.git.fmancera@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748374810.git.fmancera@suse.de>
References: <cover.1748374810.git.fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/json.h    |   1 +
 include/tunnel.h  |   4 +
 src/json.c        |  94 +++++++++++++++++++++--
 src/parser_json.c | 186 +++++++++++++++++++++++++++++++++++++++++++++-
 src/tunnel.c      |  18 +++++
 5 files changed, 296 insertions(+), 7 deletions(-)

diff --git a/include/json.h b/include/json.h
index b61eeafe..1caeb8f5 100644
--- a/include/json.h
+++ b/include/json.h
@@ -31,6 +31,7 @@ json_t *binop_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *relational_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *range_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *meta_expr_json(const struct expr *expr, struct output_ctx *octx);
+json_t *tunnel_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *payload_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *ct_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *concat_expr_json(const struct expr *expr, struct output_ctx *octx);
diff --git a/include/tunnel.h b/include/tunnel.h
index 9e6bd97a..e2d87d2c 100644
--- a/include/tunnel.h
+++ b/include/tunnel.h
@@ -25,6 +25,10 @@ extern const struct tunnel_template tunnel_templates[];
 	.byteorder	= (__byteorder),			\
 }
 
+struct error_record *tunnel_key_parse(const struct location *loc,
+			       const char *str,
+			       unsigned int *value);
+
 extern struct expr *tunnel_expr_alloc(const struct location *loc,
 				      enum nft_tunnel_keys key);
 
diff --git a/src/json.c b/src/json.c
index a8fc10c4..8ba129c6 100644
--- a/src/json.c
+++ b/src/json.c
@@ -354,7 +354,31 @@ static json_t *timeout_policy_json(uint8_t l4, const uint32_t *timeout)
 	return root ? : json_null();
 }
 
-static json_t *obj_print_json(const struct obj *obj)
+static json_t *tunnel_erspan_print_json(const struct obj *obj)
+{
+	json_t *tunnel;
+
+	switch (obj->tunnel.erspan.version) {
+		case 1:
+			tunnel = json_pack("{s:i, s:i}",
+					   "version", obj->tunnel.erspan.version,
+					   "index", obj->tunnel.erspan.v1.index);
+			break;
+		case 2:
+			tunnel = json_pack("{s:i, s:s, s:i}",
+					   "version", obj->tunnel.erspan.version,
+					   "direction", obj->tunnel.erspan.v2.direction
+							? "egress" : "ingress",
+					   "hwid", obj->tunnel.erspan.v2.hwid);
+			break;
+		default:
+			BUG("Unknown tunnel erspan version %d", obj->tunnel.erspan.version);
+	}
+
+	return tunnel;
+}
+
+static json_t *obj_print_json(struct output_ctx *octx, const struct obj *obj)
 {
 	const char *rate_unit = NULL, *burst_unit = NULL;
 	const char *type = obj_type_name(obj->type);
@@ -469,7 +493,59 @@ static json_t *obj_print_json(const struct obj *obj)
 		json_decref(tmp);
 		break;
 	case NFT_OBJECT_TUNNEL:
-		/* TODO */
+		tmp = json_pack("{s:i, s:o, s:o, s:i, s:i, s:i, s:i}",
+				"id", obj->tunnel.id,
+				"src", expr_print_json(obj->tunnel.src, octx),
+				"dst", expr_print_json(obj->tunnel.dst, octx),
+				"sport", obj->tunnel.sport,
+				"dport", obj->tunnel.dport,
+				"tos", obj->tunnel.tos,
+				"ttl", obj->tunnel.ttl);
+
+		switch (obj->tunnel.type) {
+		case TUNNEL_UNSPEC:
+			break;
+		case TUNNEL_ERSPAN:
+			json_object_set_new(tmp, "type", json_string("erspan"));
+			json_object_set_new(tmp, "tunnel",
+					    tunnel_erspan_print_json(obj));
+			break;
+		case TUNNEL_VXLAN:
+			json_object_set_new(tmp, "type", json_string("vxlan"));
+			json_object_set_new(tmp, "tunnel",
+					    json_pack("{s:i}",
+						      "gbp",
+						      obj->tunnel.vxlan.gbp));
+			break;
+		case TUNNEL_GENEVE:
+			struct tunnel_geneve *geneve;
+			json_t *opts = json_array();
+
+			list_for_each_entry(geneve, &obj->tunnel.geneve_opts, list) {
+				char data_str[256];
+				json_t *opt;
+				int offset;
+
+				data_str[0] = '0';
+				data_str[1] = 'x';
+				offset = 2;
+				for (uint32_t i = 0; i < geneve->data_len; i++)
+					offset += snprintf(data_str + offset,
+							   3, "%x", geneve->data[i]);
+
+				opt = json_pack("{s:i, s:i, s:s}",
+						"class", geneve->geneve_class,
+						"opt-type", geneve->type,
+						"data", data_str);
+				json_array_append_new(opts, opt);
+			}
+
+			json_object_set_new(tmp, "type", json_string("geneve"));
+			json_object_set_new(tmp, "tunnel", opts);
+			break;
+		}
+		json_object_update(root, tmp);
+		json_decref(tmp);
 		break;
 	}
 
@@ -1077,6 +1153,12 @@ json_t *xfrm_expr_json(const struct expr *expr, struct output_ctx *octx)
 	return json_pack("{s:o}", "ipsec", root);
 }
 
+json_t *tunnel_expr_json(const struct expr *expr, struct output_ctx *octx)
+{
+	return json_pack("{s:{s:s}}", "tunnel",
+			 "key", tunnel_templates[expr->tunnel.key].token);
+}
+
 json_t *integer_type_json(const struct expr *expr, struct output_ctx *octx)
 {
 	char buf[1024] = "0x";
@@ -1693,7 +1775,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		json_array_append_new(root, tmp);
 	}
 	list_for_each_entry(obj, &table->obj_cache.list, cache.list) {
-		tmp = obj_print_json(obj);
+		tmp = obj_print_json(&ctx->nft->output, obj);
 		json_array_append_new(root, tmp);
 	}
 	list_for_each_entry(set, &table->set_cache.list, cache.list) {
@@ -1868,7 +1950,7 @@ static json_t *do_list_obj_json(struct netlink_ctx *ctx,
 			     strcmp(cmd->handle.obj.name, obj->handle.obj.name)))
 				continue;
 
-			json_array_append_new(root, obj_print_json(obj));
+			json_array_append_new(root, obj_print_json(&ctx->nft->output, obj));
 		}
 	}
 
@@ -2087,7 +2169,9 @@ void monitor_print_element_json(struct netlink_mon_handler *monh,
 void monitor_print_obj_json(struct netlink_mon_handler *monh,
 			    const char *cmd, struct obj *o)
 {
-	monitor_print_json(monh, cmd, obj_print_json(o));
+	struct output_ctx *octx = &monh->ctx->nft->output;
+
+	monitor_print_json(monh, cmd, obj_print_json(octx, o));
 }
 
 void monitor_print_flowtable_json(struct netlink_mon_handler *monh,
diff --git a/src/parser_json.c b/src/parser_json.c
index c1bd7570..6d614c99 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -439,6 +439,23 @@ static struct expr *json_parse_meta_expr(struct json_ctx *ctx,
 	return meta_expr_alloc(int_loc, key);
 }
 
+static struct expr *json_parse_tunnel_expr(struct json_ctx *ctx,
+					   const char *type, json_t *root)
+{
+	struct error_record *erec;
+	unsigned int key;
+	const char *name;
+
+	if (json_unpack_err(ctx, root, "{s:s}", "key", &name))
+		return NULL;
+	erec = tunnel_key_parse(int_loc, name, &key);
+	if (erec) {
+		erec_queue(erec, ctx->msgs);
+		return NULL;
+	}
+	return tunnel_expr_alloc(int_loc, key);
+}
+
 static struct expr *json_parse_osf_expr(struct json_ctx *ctx,
 					const char *type, json_t *root)
 {
@@ -1616,6 +1633,7 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		{ "rt", json_parse_rt_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "ct", json_parse_ct_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "numgen", json_parse_numgen_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ "tunnel", json_parse_tunnel_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SES | CTX_F_MAP },
 		/* below two are hash expr */
 		{ "jhash", json_parse_hash_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "symhash", json_parse_hash_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
@@ -2176,6 +2194,23 @@ static struct stmt *json_parse_secmark_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
+static struct stmt *json_parse_tunnel_stmt(struct json_ctx *ctx,
+					   const char *key, json_t *value)
+{
+	struct stmt *stmt;
+
+	stmt = objref_stmt_alloc(int_loc);
+	stmt->objref.type = NFT_OBJECT_TUNNEL;
+	stmt->objref.expr = json_parse_stmt_expr(ctx, value);
+	if (!stmt->objref.expr) {
+		json_error(ctx, "Invalid tunnel reference.");
+		stmt_free(stmt);
+		return NULL;
+	}
+
+	return stmt;
+}
+
 static unsigned int json_parse_nat_flag(const char *flag)
 {
 	const struct {
@@ -2844,6 +2879,7 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 		{ "synproxy", json_parse_synproxy_stmt },
 		{ "reset", json_parse_optstrip_stmt },
 		{ "secmark", json_parse_secmark_stmt },
+		{ "tunnel", json_parse_tunnel_stmt },
 	};
 	const char *type;
 	unsigned int i;
@@ -3467,6 +3503,73 @@ static int json_parse_ct_timeout_policy(struct json_ctx *ctx,
 	return 0;
 }
 
+static int json_parse_tunnel_erspan(struct json_ctx *ctx,
+				    json_t *root, struct obj *obj)
+{
+	const char *dir;
+	json_t *tmp;
+	int i;
+
+	if (json_unpack_err(ctx, root, "{s:o}", "tunnel", &tmp))
+		return 1;
+
+	if (json_unpack_err(ctx, tmp, "{s:i}", "version", &obj->tunnel.erspan.version))
+		return 1;
+
+	switch (obj->tunnel.erspan.version) {
+	case 1:
+		if (json_unpack_err(ctx, tmp, "{s:i}",
+				    "index", &obj->tunnel.erspan.v1.index))
+			return 1;
+		break;
+	case 2:
+		if (json_unpack_err(ctx, tmp, "{s:s, s:i}",
+				   "direction", &dir,
+				   "hwid", &i))
+			return 1;
+		obj->tunnel.erspan.v2.hwid = i;
+
+		if (!strcmp(dir, "ingress")) {
+			obj->tunnel.erspan.v2.direction = 0;
+		} else if (!strcmp(dir, "egress")) {
+			obj->tunnel.erspan.v2.direction = 1;
+		} else {
+			json_error(ctx, "Invalid direction '%s'.", dir);
+			return 1;
+		}
+		break;
+	default:
+		json_error(ctx, "Invalid erspan version %u" , obj->tunnel.erspan.version);
+		return 1;
+	}
+
+	return 0;
+}
+
+static enum tunnel_type json_parse_tunnel_type(struct json_ctx *ctx,
+					       const char *type)
+{
+	const struct {
+		const char *type;
+		int val;
+	} type_tbl[] = {
+		{ "erspan", TUNNEL_ERSPAN },
+		{ "vxlan", TUNNEL_VXLAN },
+		{ "geneve", TUNNEL_GENEVE },
+	};
+	unsigned int i;
+
+	if (!type)
+		return TUNNEL_UNSPEC;
+
+	for (i = 0; i < array_size(type_tbl); i++) {
+		if (!strcmp(type, type_tbl[i].type))
+			return type_tbl[i].val;
+	}
+
+	return TUNNEL_UNSPEC;
+}
+
 static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 					     json_t *root, enum cmd_ops op,
 					     enum cmd_obj cmd_obj)
@@ -3475,6 +3578,8 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	uint32_t l3proto = NFPROTO_UNSPEC;
 	int inv = 0, flags = 0, i, j;
 	struct handle h = { 0 };
+	struct expr *expr;
+	json_t *tmp_json;
 	struct obj *obj;
 
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
@@ -3662,8 +3767,85 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 
 		obj->synproxy.flags |= flags;
 		break;
-	case CMD_OBJ_TUNNEL:
-		/* TODO */
+	case NFT_OBJECT_TUNNEL:
+		cmd_obj = CMD_OBJ_TUNNEL;
+		obj->type = NFT_OBJECT_TUNNEL;
+		if (json_unpack_err(ctx, root, "{s:o}", "src", &tmp_json))
+			goto err_free_obj;
+		expr = json_parse_expr(ctx, tmp_json);
+		if (!expr)
+			goto err_free_obj;
+		obj->tunnel.src = expr;
+
+		if (json_unpack_err(ctx, root, "{s:o}", "dst", &tmp_json))
+			goto err_free_obj;
+		expr = json_parse_expr(ctx, tmp_json);
+		if (!expr)
+			goto err_free_obj;
+		obj->tunnel.dst = expr;
+
+		json_unpack(root, "{s:i}", "id", &obj->tunnel.id);
+		json_unpack(root, "{s:i}", "sport", &i);
+		obj->tunnel.sport = i;
+		json_unpack(root, "{s:i}", "dport", &i);
+		obj->tunnel.sport = i;
+		json_unpack(root, "{s:i}", "ttl", &i);
+		obj->tunnel.ttl = i;
+		json_unpack(root, "{s:i}", "tos", &i);
+		obj->tunnel.tos = i;
+		json_unpack(root, "{s:s}", "type", &tmp);
+
+		obj->tunnel.type = json_parse_tunnel_type(ctx, tmp);
+		switch (obj->tunnel.type) {
+		case TUNNEL_UNSPEC:
+			break;
+		case TUNNEL_ERSPAN:
+			if (json_parse_tunnel_erspan(ctx, root, obj))
+				goto err_free_obj;
+			break;
+		case TUNNEL_VXLAN:
+			if (json_unpack_err(ctx, root,
+					    "{s:o}", "tunnel", &tmp_json))
+				goto err_free_obj;
+
+			json_unpack(tmp_json, "{s:i}",
+				    "gbp", &obj->tunnel.vxlan.gbp);
+			break;
+		case TUNNEL_GENEVE:
+			json_t *value;
+			size_t index;
+
+			if (json_unpack_err(ctx, root,
+					    "{s:o}", "tunnel", &tmp_json))
+				goto err_free_obj;
+
+			json_array_foreach(tmp_json, index, value) {
+				struct tunnel_geneve *geneve = xmalloc(sizeof(struct tunnel_geneve));
+
+				if (json_unpack_err(ctx, value, "{s:i, s:i, s:s}",
+						    "class", &i,
+						    "opt-type", &j,
+						    "data", &tmp)) {
+					free(geneve);
+					goto err_free_obj;
+				}
+				geneve->geneve_class = i;
+				geneve->type = j;
+
+				if (tunnel_geneve_data_str2array(tmp,
+								 geneve->data,
+								 &geneve->data_len)) {
+					free(geneve);
+					goto err_free_obj;
+				}
+
+				if (index == 0)
+					init_list_head(&obj->tunnel.geneve_opts);
+
+				list_add_tail(&geneve->list, &obj->tunnel.geneve_opts);
+			}
+			break;
+		}
 		break;
 	default:
 		BUG("Invalid CMD '%d'", cmd_obj);
diff --git a/src/tunnel.c b/src/tunnel.c
index d03f853a..5685be2c 100644
--- a/src/tunnel.c
+++ b/src/tunnel.c
@@ -6,6 +6,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <nft.h>
+
 #include <errno.h>
 #include <limits.h>
 #include <stddef.h>
@@ -38,6 +40,21 @@ const struct tunnel_template tunnel_templates[] = {
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 };
 
+struct error_record *tunnel_key_parse(const struct location *loc,
+				      const char *str,
+				      unsigned int *value)
+{
+	for (unsigned int i = 0; i < array_size(tunnel_templates); i++) {
+		if (!tunnel_templates[i].token || strcmp(tunnel_templates[i].token, str))
+			continue;
+
+		*value = i;
+		return NULL;
+	}
+
+	return error(loc, "syntax error, unexpected %s", str);
+}
+
 static void tunnel_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	nft_print(octx, "tunnel %s",
@@ -58,6 +75,7 @@ const struct expr_ops tunnel_expr_ops = {
 	.type		= EXPR_TUNNEL,
 	.name		= "tunnel",
 	.print		= tunnel_expr_print,
+	.json		= tunnel_expr_json,
 	.cmp		= tunnel_expr_cmp,
 	.clone		= tunnel_expr_clone,
 };
-- 
2.49.0

