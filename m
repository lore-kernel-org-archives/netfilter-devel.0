Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B091DD9AC
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Nov 2025 11:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763204710; cv=none; b=FUSXUekVZ/WJLccidcJOy1UBYv/E295djJ8AZl5y8YG9b2dnBFnuMJhOQCDENdrgsZ/+GTDBwNzKkFB1/n7TuBSxjdPuQ3oKuk4jaTNTz+6Uwv4aft9H6xHJGig6UpYV8JFy52wdNnwi7wwE6YZLOCjAwXnF88/xLK1PqIjYrGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763204710; c=relaxed/simple;
	bh=0nvjzlygikhPDbBgeh6Caraepw4CQe8ndaHbCJsVCEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OmLga7ZWuQPuMuuovGPgyYrDhughZjtByC7jX+rkAaO6FjnlbQGGYu+VRkVB2hznRerVO3ayHy/7dHMmjQGlbPjumR78xqGBpUoxeDDc7xyLOCbtxjNC916ZgrjmSsAD9XZPLaOvQ7JkytByImJo3vScTc2Qxh3jT3oqG0m+/dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CxpVkZ04; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9zh+jlqK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CxpVkZ04; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9zh+jlqK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CxpVkZ04";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9zh+jlqK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CxpVkZ04";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9zh+jlqK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 87A2821215;
	Sat, 15 Nov 2025 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763204705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UxQOcODCUiZmDhrwB7lsygrCjcCAT9BJ3iQhhAamFA0=;
	b=CxpVkZ04nhWy9SLHzb6OamhtkZ2ncYfyWtklT3DNSRZ0UWOipruD0iy/wuBLkFziiyllQI
	AJwSRsBeGLrLsUBCtQamZLj7Rkv92F8wK7aFvZHxArbRPRT99ljuRGDNoXeRxuANA8DKno
	98CjLduy41IWDEs7Lyx2gANO5FKUSjE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763204705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UxQOcODCUiZmDhrwB7lsygrCjcCAT9BJ3iQhhAamFA0=;
	b=9zh+jlqKEb1NpGQiKtQvyrnMtxr7Mp/dVw+wmmWEENRS9X2efC8+RvleP7BDygBUCcgZv3
	ED15EI27S5vWQ5Cg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CxpVkZ04;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9zh+jlqK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763204705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UxQOcODCUiZmDhrwB7lsygrCjcCAT9BJ3iQhhAamFA0=;
	b=CxpVkZ04nhWy9SLHzb6OamhtkZ2ncYfyWtklT3DNSRZ0UWOipruD0iy/wuBLkFziiyllQI
	AJwSRsBeGLrLsUBCtQamZLj7Rkv92F8wK7aFvZHxArbRPRT99ljuRGDNoXeRxuANA8DKno
	98CjLduy41IWDEs7Lyx2gANO5FKUSjE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763204705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UxQOcODCUiZmDhrwB7lsygrCjcCAT9BJ3iQhhAamFA0=;
	b=9zh+jlqKEb1NpGQiKtQvyrnMtxr7Mp/dVw+wmmWEENRS9X2efC8+RvleP7BDygBUCcgZv3
	ED15EI27S5vWQ5Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4236E3EA61;
	Sat, 15 Nov 2025 11:05:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hnAdDWFeGGlBVgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sat, 15 Nov 2025 11:05:05 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nft v2] src: add connlimit stateful object support
Date: Sat, 15 Nov 2025 12:04:46 +0100
Message-ID: <20251115110446.15101-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 87A2821215
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -3.01

Add support for "ct count" stateful object. E.g

table ip mytable {
	ct count ssh-connlimit { to 4 }
	ct count http-connlimit { over 1000 }
        chain mychain {
                type filter hook input priority filter; policy accept;
                ct count name tcp dport map { 22 : "ssh-connlimit", 80 : "http-connlimit" } meta mark set 0x1
        }
}

The kernel code has been there for a long time but never used.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: added token "to"
---
 include/rule.h                | 10 ++++
 src/cache.c                   |  7 +++
 src/evaluate.c                |  6 +++
 src/json.c                    | 13 +++++
 src/mnl.c                     |  6 +++
 src/netlink.c                 |  6 +++
 src/parser_bison.y            | 93 +++++++++++++++++++++++++++++++++--
 src/parser_json.c             | 34 ++++++++++---
 src/rule.c                    | 24 +++++++++
 src/scanner.l                 |  6 ++-
 src/statement.c               |  1 +
 tests/py/ip/objects.t         |  7 +++
 tests/py/ip/objects.t.json    | 35 +++++++++++++
 tests/py/ip/objects.t.payload | 12 +++++
 tests/py/nft-test.py          |  4 ++
 15 files changed, 252 insertions(+), 12 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index e8b3c037..dac6996a 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -489,6 +489,11 @@ struct synproxy {
 	uint32_t	flags;
 };
 
+struct connlimit {
+	uint32_t	count;
+	uint32_t	flags;
+};
+
 struct secmark {
 	char		ctx[NFT_SECMARK_CTX_MAXLEN];
 };
@@ -566,6 +571,7 @@ struct obj {
 		struct ct_expect	ct_expect;
 		struct synproxy		synproxy;
 		struct tunnel		tunnel;
+		struct connlimit	connlimit;
 	};
 };
 
@@ -677,6 +683,8 @@ enum cmd_ops {
  * @CMD_OBJ_TUNNEL:	tunnel
  * @CMD_OBJ_TUNNELS:	multiple tunnels
  * @CMD_OBJ_HOOKS:	hooks, used only for dumping
+ * @CMD_OBJ_CONNLIMIT:	connlimit
+ * @CMD_OBJ_CONNLIMITS: connlimits
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -718,6 +726,8 @@ enum cmd_obj {
 	CMD_OBJ_TUNNEL,
 	CMD_OBJ_TUNNELS,
 	CMD_OBJ_HOOKS,
+	CMD_OBJ_CONNLIMIT,
+	CMD_OBJ_CONNLIMITS
 };
 
 struct markup {
diff --git a/src/cache.c b/src/cache.c
index 09aa20bf..ccb290c9 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -47,6 +47,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_SYNPROXY:
 	case CMD_OBJ_FLOWTABLE:
+	case CMD_OBJ_CONNLIMIT:
 		flags |= NFT_CACHE_TABLE;
 		break;
 	case CMD_OBJ_ELEMENTS:
@@ -296,6 +297,10 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 	case CMD_OBJ_SYNPROXYS:
 		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_SYNPROXY);
 		break;
+	case CMD_OBJ_CONNLIMIT:
+	case CMD_OBJ_CONNLIMITS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_CONNLIMIT);
+		break;
 	case CMD_OBJ_RULESET:
 	default:
 		flags |= NFT_CACHE_FULL;
@@ -445,6 +450,8 @@ static int nft_handle_validate(const struct cmd *cmd, struct list_head *msgs)
 	case CMD_OBJ_CT_EXPECTATIONS:
 	case CMD_OBJ_TUNNEL:
 	case CMD_OBJ_TUNNELS:
+	case CMD_OBJ_CONNLIMIT:
+	case CMD_OBJ_CONNLIMITS:
 		if (h->table.name &&
 		    strlen(h->table.name) > NFT_NAME_MAXLEN) {
 			loc = &h->table.location;
diff --git a/src/evaluate.c b/src/evaluate.c
index 5a5e6cb5..9d5ec303 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5974,6 +5974,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_SYNPROXY:
 	case CMD_OBJ_TUNNEL:
+	case CMD_OBJ_CONNLIMIT:
 		handle_merge(&cmd->object->handle, &cmd->handle);
 		return obj_evaluate(ctx, cmd->object);
 	default:
@@ -6147,6 +6148,8 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_TUNNEL:
 		obj_del_cache(ctx, cmd, NFT_OBJECT_TUNNEL);
 		return 0;
+	case CMD_OBJ_CONNLIMIT:
+		obj_del_cache(ctx, cmd, NFT_OBJECT_CONNLIMIT);
 	default:
 		BUG("invalid command object type %u", cmd->obj);
 	}
@@ -6279,6 +6282,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_CT_EXPECT);
 	case CMD_OBJ_SYNPROXY:
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_SYNPROXY);
+	case CMD_OBJ_CONNLIMIT:
+		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_CONNLIMIT);
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
 	case CMD_OBJ_CT_HELPERS:
@@ -6287,6 +6292,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_FLOWTABLES:
 	case CMD_OBJ_SECMARKS:
 	case CMD_OBJ_SYNPROXYS:
+	case CMD_OBJ_CONNLIMITS:
 	case CMD_OBJ_CT_TIMEOUTS:
 	case CMD_OBJ_CT_EXPECTATIONS:
 		if (cmd->handle.table.name == NULL)
diff --git a/src/json.c b/src/json.c
index 9fb6d715..968a932c 100644
--- a/src/json.c
+++ b/src/json.c
@@ -572,6 +572,15 @@ static json_t *obj_print_json(struct output_ctx *octx, const struct obj *obj,
 		json_object_update(root, tmp);
 		json_decref(tmp);
 		break;
+	case NFT_OBJECT_CONNLIMIT:
+		tmp = json_pack("{s:i}", "val", obj->connlimit.count);
+
+		if (obj->connlimit.flags & NFT_CONNLIMIT_F_INV)
+			json_object_set_new(root, "inv", json_true());
+
+		json_object_update(root, tmp);
+		json_decref(tmp);
+		break;
 	}
 
 out:
@@ -2132,6 +2141,10 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_TUNNELS:
 		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_TUNNEL);
 		break;
+	case CMD_OBJ_CONNLIMIT:
+	case CMD_OBJ_CONNLIMITS:
+		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_CONNLIMIT);
+		break;
 	case CMD_OBJ_FLOWTABLE:
 		root = do_list_flowtable_json(ctx, cmd, table);
 		break;
diff --git a/src/mnl.c b/src/mnl.c
index 0a445189..0de122a3 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1733,6 +1733,12 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		}
 		obj_tunnel_add_opts(nlo, &obj->tunnel);
 		break;
+	case NFT_OBJECT_CONNLIMIT:
+		nftnl_obj_set_u32(nlo, NFTNL_OBJ_CONNLIMIT_COUNT,
+				  obj->connlimit.count);
+		nftnl_obj_set_u32(nlo, NFTNL_OBJ_CONNLIMIT_FLAGS,
+				  obj->connlimit.flags);
+		break;
 	default:
 		BUG("Unknown type %d", obj->type);
 		break;
diff --git a/src/netlink.c b/src/netlink.c
index 26cf07c3..8a0482c6 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2051,6 +2051,12 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 			nftnl_obj_tunnel_opts_foreach(nlo, tunnel_parse_opt_cb, obj);
 		}
 		break;
+	case NFT_OBJECT_CONNLIMIT:
+		obj->connlimit.count =
+			nftnl_obj_get_u32(nlo, NFTNL_OBJ_CONNLIMIT_COUNT);
+		obj->connlimit.flags =
+			nftnl_obj_get_u32(nlo, NFTNL_OBJ_CONNLIMIT_FLAGS);
+		break;
 	default:
 		netlink_io_error(ctx, NULL, "Unknown object type %u", type);
 		obj_free(obj);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 52730f71..7d18255a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -634,6 +634,7 @@ int nft_lex(void *, void *, void *);
 %token LIMITS			"limits"
 %token TUNNELS			"tunnels"
 %token SYNPROXYS		"synproxys"
+%token COUNTS			"counts"
 %token HELPERS			"helpers"
 
 %token LOG			"log"
@@ -786,7 +787,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc geneve_block geneve_block_alloc
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc geneve_block geneve_block_alloc connlimit_block
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
@@ -905,8 +906,8 @@ int nft_lex(void *, void *, void *);
 %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 
-%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj
-%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj
+%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj connlimit_obj
+%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj connlimit_obj
 
 %type <expr>			relational_expr
 %destructor { expr_free($$); }	relational_expr
@@ -1330,6 +1331,10 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_TUNNEL, &$2, &@$, $3);
 			}
+			|	CT	COUNT	obj_spec	connlimit_obj	'{' connlimit_block '}' close_scope_ct
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_CONNLIMIT, &$3, &@$, $4);
+			}
 			;
 
 replace_cmd		:	RULE		ruleid_spec	rule
@@ -1437,6 +1442,10 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_TUNNEL, &$2, &@$, $3);
 			}
+			|	CT	COUNT	obj_spec	connlimit_obj	'{' connlimit_block '}' close_scope_ct
+			{
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_CONNLIMIT, &$3, &@$, $4);
+			}
 			;
 
 insert_cmd		:	RULE		rule_position	rule
@@ -1538,6 +1547,10 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TUNNEL, &$2, &@$, NULL);
 			}
+			|	CT	COUNT	obj_or_id_spec	close_scope_ct
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CONNLIMIT, &$3, &@$, NULL);
+			}
 			;
 
 destroy_cmd		:	TABLE		table_or_id_spec
@@ -1609,6 +1622,10 @@ destroy_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_TUNNEL, &$2, &@$, NULL);
 			}
+			|	CT	COUNT	obj_or_id_spec	close_scope_ct
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_CONNLIMIT, &$3, &@$, NULL);
+			}
 			;
 
 
@@ -1737,6 +1754,15 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_HOOKS, &$2, &@$, NULL);
 			}
+			|	CT	COUNT	obj_spec	close_scope_ct
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CONNLIMIT, &$3, &@$, NULL);
+			}
+			|	CT	COUNTS	list_cmd_spec_any
+			{
+
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CONNLIMITS, &$3, &@$, NULL);
+			}
 			;
 
 basehook_device_name	:	DEVICE STRING
@@ -2099,6 +2125,17 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
+			|	table_block	CT	COUNT	obj_identifier
+					obj_block_alloc '{'	connlimit_block	 '}'
+					stmt_separator	close_scope_ct
+			{
+				$5->location = @4;
+				$5->type = NFT_OBJECT_CONNLIMIT;
+				handle_merge(&$5->handle, &$4);
+				handle_free(&$4);
+				list_add_tail(&$5->list, &$1->objs);
+				$$ = $1;
+			}
 			;
 
 chain_block_alloc	:	/* empty */
@@ -2328,6 +2365,7 @@ map_block_alloc		:	/* empty */
 
 ct_obj_type_map		: 	TIMEOUT		{ $$ = NFT_OBJECT_CT_TIMEOUT; }
 			|	EXPECTATION	{ $$ = NFT_OBJECT_CT_EXPECT; }
+			|	COUNT		{ $$ = NFT_OBJECT_CONNLIMIT; }
 			;
 
 map_block_obj_type	:	COUNTER	close_scope_counter { $$ = NFT_OBJECT_COUNTER; }
@@ -2670,6 +2708,23 @@ ct_expect_block		:	/*empty */	{ $$ = $<obj>-1; }
 			}
 			;
 
+connlimit_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       connlimit_block     common_block
+			|       connlimit_block     stmt_separator
+			|       connlimit_block     connlimit_config
+			{
+				$$ = $1;
+			}
+			|       connlimit_block     comment_spec
+			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					free_const($2);
+					YYERROR;
+				}
+				$<obj>1->comment = $2;
+			}
+			;
+
 limit_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       limit_block     common_block
 			|       limit_block     stmt_separator
@@ -3236,6 +3291,12 @@ objref_stmt_ct		:	CT	TIMEOUT		SET	stmt_expr	close_scope_ct
 				$$->objref.type = NFT_OBJECT_CT_EXPECT;
 				$$->objref.expr = $4;
 			}
+			|	CT	COUNT	NAME	stmt_expr	close_scope_ct
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_CONNLIMIT;
+				$$->objref.expr = $4;
+			}
 			;
 
 objref_stmt		:	objref_stmt_counter
@@ -3351,6 +3412,32 @@ ct_limit_stmt_alloc	:	CT	COUNT
 			}
 			;
 
+connlimit_obj		:	/* empty */
+			{
+				$$ = obj_alloc(&@$);
+				$$->type = NFT_OBJECT_CONNLIMIT;
+			}
+			;
+
+connlimit_config	:	TO	NUM
+			{
+				struct connlimit *connlimit;
+
+				connlimit = &$<obj>0->connlimit;
+				connlimit->count = $2;
+				connlimit->flags = 0;
+
+			}
+			|	OVER	NUM
+			{
+				struct connlimit *connlimit;
+
+				connlimit = &$<obj>0->connlimit;
+				connlimit->count = $2;
+				connlimit->flags = NFT_CONNLIMIT_F_INV;
+			}
+			;
+
 connlimit_stmt		:	ct_limit_stmt_alloc	ct_limit_args
 			;
 
diff --git a/src/parser_json.c b/src/parser_json.c
index 7b4f3384..987d8781 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2835,17 +2835,26 @@ static struct stmt *json_parse_connlimit_stmt(struct json_ctx *ctx,
 					      const char *key, json_t *value)
 {
 	struct stmt *stmt = connlimit_stmt_alloc(int_loc);
+	uint32_t tmp;
+
+	if (!json_unpack(value, "{s:i}", "val", &tmp)) {
+		stmt = connlimit_stmt_alloc(int_loc);
+		stmt->connlimit.count = tmp;
+		json_unpack(value, "{s:b}", "inv", &stmt->connlimit.flags);
+		if (stmt->connlimit.flags)
+			stmt->connlimit.flags = NFT_CONNLIMIT_F_INV;
+		return stmt;
+	}
 
-	if (json_unpack_err(ctx, value, "{s:i}",
-			    "val", &stmt->connlimit.count)) {
+	stmt = objref_stmt_alloc(int_loc);
+	stmt->objref.type = NFT_OBJECT_CONNLIMIT;
+	stmt->objref.expr = json_parse_stmt_expr(ctx, value);
+	if (!stmt->objref.expr) {
+		json_error(ctx, "Invalid connlimit reference.");
 		stmt_free(stmt);
 		return NULL;
 	}
 
-	json_unpack(value, "{s:b}", "inv", &stmt->connlimit.flags);
-	if (stmt->connlimit.flags)
-		stmt->connlimit.flags = NFT_CONNLIMIT_F_INV;
-
 	return stmt;
 }
 
@@ -3249,6 +3258,7 @@ static int string_to_nft_object(const char *str)
 		[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
 		[NFT_OBJECT_SYNPROXY]	= "synproxy",
 		[NFT_OBJECT_TUNNEL]	= "tunnel",
+		[NFT_OBJECT_CONNLIMIT]	= "ct count",
 	};
 	unsigned int i;
 
@@ -3946,6 +3956,15 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			break;
 		}
 		break;
+	case CMD_OBJ_CONNLIMIT:
+		obj->type = NFT_OBJECT_CONNLIMIT;
+		if (json_unpack_err(ctx, root, "{s:i}", "val", &obj->connlimit.count))
+			goto err_free_obj;
+
+		json_unpack(root, "{s:b}", "inv", &obj->connlimit.flags);
+		if (obj->connlimit.flags)
+			obj->connlimit.flags = NFT_CONNLIMIT_F_INV;
+		break;
 	default:
 		BUG("Invalid CMD '%d'", cmd_obj);
 	}
@@ -3985,7 +4004,8 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 		{ "tunnel", NFT_OBJECT_TUNNEL, json_parse_cmd_add_object },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "secmark", CMD_OBJ_SECMARK, json_parse_cmd_add_object },
-		{ "synproxy", CMD_OBJ_SYNPROXY, json_parse_cmd_add_object }
+		{ "synproxy", CMD_OBJ_SYNPROXY, json_parse_cmd_add_object },
+		{ "ct count", CMD_OBJ_CONNLIMIT, json_parse_cmd_add_object },
 	};
 	unsigned int i;
 	json_t *tmp;
diff --git a/src/rule.c b/src/rule.c
index bb6f62c8..8368db8d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1454,6 +1454,7 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_SECMARK:
 		case CMD_OBJ_SYNPROXY:
 		case CMD_OBJ_TUNNEL:
+		case CMD_OBJ_CONNLIMIT:
 			obj_free(cmd->object);
 			break;
 		case CMD_OBJ_FLOWTABLE:
@@ -1555,6 +1556,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_SYNPROXY:
 	case CMD_OBJ_TUNNEL:
+	case CMD_OBJ_CONNLIMIT:
 		return mnl_nft_obj_add(ctx, cmd, flags);
 	case CMD_OBJ_FLOWTABLE:
 		return mnl_nft_flowtable_add(ctx, cmd, flags);
@@ -1637,6 +1639,8 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_SYNPROXY);
 	case CMD_OBJ_TUNNEL:
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_TUNNEL);
+	case CMD_OBJ_CONNLIMIT:
+		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_CONNLIMIT);
 	case CMD_OBJ_FLOWTABLE:
 		return mnl_nft_flowtable_del(ctx, cmd);
 	default:
@@ -2140,6 +2144,21 @@ static void obj_print_data(const struct obj *obj,
 			break;
 		}
 
+		nft_print(octx, "%s", opts->stmt_separator);
+		break;
+	case NFT_OBJECT_CONNLIMIT:
+		nft_print(octx, " %s {", obj->handle.obj.name);
+		if (nft_output_handle(octx))
+			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+
+		obj_print_comment(obj, opts, octx);
+
+		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
+		if (obj->connlimit.flags & NFT_CONNLIMIT_F_INV)
+			nft_print(octx, "over %u", obj->connlimit.count);
+		else
+			nft_print(octx, "to %u", obj->connlimit.count);
+
 		nft_print(octx, "%s", opts->stmt_separator);
 		break;
 	default:
@@ -2158,6 +2177,7 @@ static const char * const obj_type_name_array[] = {
 	[NFT_OBJECT_SYNPROXY]	= "synproxy",
 	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
 	[NFT_OBJECT_TUNNEL]	= "tunnel",
+	[NFT_OBJECT_CONNLIMIT]	= "ct count"
 };
 
 const char *obj_type_name(unsigned int type)
@@ -2177,6 +2197,7 @@ static uint32_t obj_type_cmd_array[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_SYNPROXY]	= CMD_OBJ_SYNPROXY,
 	[NFT_OBJECT_CT_EXPECT]	= CMD_OBJ_CT_EXPECT,
 	[NFT_OBJECT_TUNNEL]	= CMD_OBJ_TUNNEL,
+	[NFT_OBJECT_CONNLIMIT]	= CMD_OBJ_CONNLIMIT,
 };
 
 enum cmd_obj obj_type_to_cmd(uint32_t type)
@@ -2651,6 +2672,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_TUNNEL:
 	case CMD_OBJ_TUNNELS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_TUNNEL);
+	case CMD_OBJ_CONNLIMIT:
+	case CMD_OBJ_CONNLIMITS:
+		return do_list_obj(ctx, cmd, NFT_OBJECT_CONNLIMIT);
 	case CMD_OBJ_FLOWTABLE:
 		return do_list_flowtable(ctx, cmd, table);
 	case CMD_OBJ_FLOWTABLES:
diff --git a/src/scanner.l b/src/scanner.l
index 8085c93b..c8dfa822 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -351,7 +351,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "jump"			{ return JUMP; }
 "goto"			{ return GOTO; }
 "return"		{ return RETURN; }
-<SCANSTATE_EXPR_QUEUE,SCANSTATE_STMT_DUP,SCANSTATE_STMT_FWD,SCANSTATE_STMT_NAT,SCANSTATE_STMT_TPROXY,SCANSTATE_IP,SCANSTATE_IP6>"to"			{ return TO; } /* XXX: SCANSTATE_IP is a workaround */
+<SCANSTATE_EXPR_QUEUE,SCANSTATE_STMT_DUP,SCANSTATE_STMT_FWD,SCANSTATE_STMT_NAT,SCANSTATE_STMT_TPROXY,SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_CT>"to"			{ return TO; } /* XXX: SCANSTATE_IP is a workaround */
 
 "inet"			{ return INET; }
 "netdev"		{ return NETDEV; }
@@ -406,11 +406,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"synproxys"		{ return SYNPROXYS; }
 	"tunnel"		{ return TUNNEL; }
 	"tunnels"		{ return TUNNELS; }
+	"count"			{ return COUNT; }
+	"counts"		{ return COUNTS; }
 	"hooks"			{ return HOOKS; }
 }
 
 "counter"		{ scanner_push_start_cond(yyscanner, SCANSTATE_COUNTER); return COUNTER; }
-<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF,SCANSTATE_TUNNEL>"name"			{ return NAME; }
+<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF,SCANSTATE_TUNNEL,SCANSTATE_CT>"name"	{ return NAME; }
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"		{ return PACKETS; }
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes"	{ return BYTES; }
 
diff --git a/src/statement.c b/src/statement.c
index d0993dde..9cfbe9b3 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -295,6 +295,7 @@ static const char *objref_type[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_SECMARK]	= "secmark",
 	[NFT_OBJECT_SYNPROXY]	= "synproxy",
 	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
+	[NFT_OBJECT_CONNLIMIT]	= "ct count",
 };
 
 const char *objref_type_name(uint32_t type)
diff --git a/tests/py/ip/objects.t b/tests/py/ip/objects.t
index 71d5ffe4..e09be68b 100644
--- a/tests/py/ip/objects.t
+++ b/tests/py/ip/objects.t
@@ -56,3 +56,10 @@ ct expectation set "ctexpect1";ok
 %synproxy2 type synproxy mss 1460 wscale 7 timestamp sack-perm;ok
 
 synproxy name tcp dport map {443 : "synproxy1", 80 : "synproxy2"};ok
+
+# connlimit
+%connlimit1 type ct count { over 5 };ok
+%connlimit2 type ct count { to 4 };ok
+
+ct count name tcp dport map {22 : "connlimit1", 80 : "connlimit2"};ok
+ct count name "connlimit1";ok
diff --git a/tests/py/ip/objects.t.json b/tests/py/ip/objects.t.json
index a70dd9e2..1cc16376 100644
--- a/tests/py/ip/objects.t.json
+++ b/tests/py/ip/objects.t.json
@@ -227,3 +227,38 @@
         }
     }
 ]
+
+# ct count name tcp dport map {22 : "connlimit1", 80 : "connlimit2"}
+[
+    {
+        "ct count": {
+            "map": {
+                "data": {
+                    "set": [
+                        [
+                            22,
+                            "connlimit1"
+                        ],
+                        [
+                            80,
+                            "connlimit2"
+                        ]
+                    ]
+                },
+                "key": {
+                    "payload": {
+                        "field": "dport",
+                        "protocol": "tcp"
+                    }
+                }
+            }
+        }
+    }
+]
+
+# ct count name "connlimit1"
+[
+    {
+        "ct count": "connlimit1"
+    }
+]
diff --git a/tests/py/ip/objects.t.payload b/tests/py/ip/objects.t.payload
index 3da4b285..cce99a45 100644
--- a/tests/py/ip/objects.t.payload
+++ b/tests/py/ip/objects.t.payload
@@ -77,3 +77,15 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d ]
+
+# ct count name tcp dport map {22 : "connlimit1", 80 : "connlimit2"}
+        element 00001600  : 0 [end]     element 00005000  : 0 [end]
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ objref sreg 1 set __objmap%d ]
+
+# ct count name "connlimit1"
+ip test-ip4 input
+  [ objref type 5 name connlimit1 ]
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index ff2412ac..de4860f8 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1254,6 +1254,10 @@ def obj_process(obj_line, filename, lineno):
        obj_type = "ct expectation"
        tokens[3] = ""
 
+    if obj_type == "ct" and tokens[3] == "count":
+       obj_type = "ct count"
+       tokens[3] = ""
+
     if len(tokens) > 3:
         obj_spcf = " ".join(tokens[3:])
 
-- 
2.51.1

