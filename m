Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE94ACE79D3
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 13:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjITNRG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbjITNRE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 09:17:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FFAB4
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 06:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695215770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lpLjnsZb+Ro6a0o4lQLCLTY/W+ePzdDV8uz+VuigkuA=;
        b=ayVDLi3rscVMNT3FZQkoYDPFggBYdmLktQcMQBhOybN1B3eD4oZXXKBy/JxDEFaD2rFCUl
        JLzjeCk4CZEWTIijdfV+Maii6eAJDMBlRP2BCbM6sUDvRDC+U8x00zG7M4VldMZz5/wG1/
        rtGaG87+VZ9W32QWQUWhakS6Z39T2KI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-6l7kVLtgNT29N2FNeYfj7A-1; Wed, 20 Sep 2023 09:16:08 -0400
X-MC-Unique: 6l7kVLtgNT29N2FNeYfj7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A58EE185A79C
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:16:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 24539C15BB8;
        Wed, 20 Sep 2023 13:16:08 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 4/4] all: remove xfree() and use plain free()
Date:   Wed, 20 Sep 2023 15:13:41 +0200
Message-ID: <20230920131554.204899-5-thaller@redhat.com>
In-Reply-To: <20230920131554.204899-1-thaller@redhat.com>
References: <20230920131554.204899-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

xmalloc() (and similar x-functions) are used for allocation.  They wrap
malloc()/realloc() but will abort the program on ENOMEM.

The meaning of xmalloc() is that it wraps malloc() but aborts on
failure. I don't think it should have the notion, that this were
potentially a different allocator that requires its own xfree().

Even if the original intent was that the allocator is abstracted (and
possibly not backed by standard malloc()), then that doesn't seem a good
idea. Nowadays libc allocators are pretty good, and we would need a very
special use cases to switch to something else. In other words, this will
never happen.

Also there were a few places, where a xmalloc() was already "wrongly"
paired with free() (for example, iface_cache_release(), exit_cookie(),
nft_run_cmd_from_buffer()).

Or note how pid2name() returns an allocated string from fscanf(), which
needs to be freed with free() (and not xfree()). This requirement
bubbles up via the callers portid2name() and name_by_portid(). This was
actually handled correctly and the buffer was freed with free(). But it
shows that mixing different allocators is cumbersome to get right.  Of
course, we won't have different allocators and xfree() serves no actual
purpose.

Note that xfree() also used to accept const pointers. That seems a bad
to do unconditionally for all deallocations. Instead prefer to use plain
free(). To free a const pointer use free_const() which just wraps free,
as the name indicates.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/utils.h         |  1 -
 src/cache.c             |  6 +++---
 src/datatype.c          |  4 ++--
 src/erec.c              |  6 +++---
 src/evaluate.c          |  4 ++--
 src/expression.c        |  2 +-
 src/json.c              |  2 +-
 src/libnftables.c       | 12 ++++++------
 src/meta.c              |  4 ++--
 src/misspell.c          |  2 +-
 src/mnl.c               |  4 ++--
 src/netlink_linearize.c |  4 ++--
 src/optimize.c          | 10 +++++-----
 src/parser_bison.y      | 12 ++++++------
 src/rule.c              | 32 ++++++++++++++++----------------
 src/scanner.l           |  2 +-
 src/segtree.c           |  4 ++--
 src/statement.c         |  2 +-
 src/utils.c             |  5 -----
 src/xt.c                |  8 ++++----
 20 files changed, 60 insertions(+), 66 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 36a28f893667..e18fabec56ba 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -142,7 +142,6 @@ extern void __memory_allocation_error(const char *filename, uint32_t line) __nor
 #define memory_allocation_error()		\
 	__memory_allocation_error(__FILE__, __LINE__);
 
-extern void xfree(const void *ptr);
 extern void *xmalloc(size_t size);
 extern void *xmalloc_array(size_t nmemb, size_t size);
 extern void *xrealloc(void *ptr, size_t size);
diff --git a/src/cache.c b/src/cache.c
index 4e89fe1338f3..b7f46c001d6e 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -126,9 +126,9 @@ void nft_cache_filter_fini(struct nft_cache_filter *filter)
 		struct nft_filter_obj *obj, *next;
 
 		list_for_each_entry_safe(obj, next, &filter->obj[i].head, list)
-			xfree(obj);
+			free(obj);
 	}
-	xfree(filter);
+	free(filter);
 }
 
 static void cache_filter_add(struct nft_cache_filter *filter,
@@ -1279,7 +1279,7 @@ void cache_init(struct cache *cache)
 
 void cache_free(struct cache *cache)
 {
-	xfree(cache->ht);
+	free(cache->ht);
 }
 
 void cache_add(struct cache_item *item, struct cache *cache, uint32_t hash)
diff --git a/src/datatype.c b/src/datatype.c
index 4827c42855ec..147083ea8b33 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1267,7 +1267,7 @@ void datatype_free(const struct datatype *ptr)
 
 	free_const(dtype->name);
 	free_const(dtype->desc);
-	xfree(dtype);
+	free(dtype);
 }
 
 const struct datatype *concat_type_alloc(uint32_t type)
@@ -1514,7 +1514,7 @@ static void cgroupv2_type_print(const struct expr *expr,
 	else
 		nft_print(octx, "%" PRIu64, id);
 
-	xfree(cgroup_path);
+	free(cgroup_path);
 }
 
 static struct error_record *cgroupv2_type_parse(struct parse_ctx *ctx,
diff --git a/src/erec.c b/src/erec.c
index 8cadaa8069d1..195c0ad696c6 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -44,8 +44,8 @@ void erec_add_location(struct error_record *erec, const struct location *loc)
 
 void erec_destroy(struct error_record *erec)
 {
-	xfree(erec->msg);
-	xfree(erec);
+	free(erec->msg);
+	free(erec);
 }
 
 __attribute__((format(printf, 3, 0)))
@@ -204,7 +204,7 @@ void erec_print(struct output_ctx *octx, const struct error_record *erec,
 		}
 		pbuf[end] = '\0';
 		fprintf(f, "%s", pbuf);
-		xfree(pbuf);
+		free(pbuf);
 	}
 	fprintf(f, "\n");
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index 51e35ac5d922..aa0fb530649a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3241,7 +3241,7 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 	 */
 	list_add(&nstmt->list, &ctx->rule->stmts);
 out:
-	xfree(payload);
+	free(payload);
 	return ret;
 }
 
@@ -5135,7 +5135,7 @@ static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
 		ct->timeout[ts->timeout_index] = ts->timeout_value;
 		list_del(&ts->head);
 		free_const(ts->timeout_str);
-		xfree(ts);
+		free(ts);
 	}
 
 	return 0;
diff --git a/src/expression.c b/src/expression.c
index b7b8cbf8777f..53d142bfb03a 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -95,7 +95,7 @@ void expr_free(struct expr *expr)
 	 */
 	if (expr->etype != EXPR_INVALID)
 		expr_destroy(expr);
-	xfree(expr);
+	free(expr);
 }
 
 void expr_print(const struct expr *expr, struct output_ctx *octx)
diff --git a/src/json.c b/src/json.c
index 446575c2afc0..271f0c947314 100644
--- a/src/json.c
+++ b/src/json.c
@@ -84,7 +84,7 @@ static json_t *set_dtype_json(const struct expr *key)
 			json_array_append_new(root, jtok);
 		tok = strtok_r(NULL, " .", &tok_safe);
 	}
-	xfree(namedup);
+	free(namedup);
 	return root;
 }
 
diff --git a/src/libnftables.c b/src/libnftables.c
index 817949eeedec..dbd0d6100889 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -158,7 +158,7 @@ void nft_ctx_clear_vars(struct nft_ctx *ctx)
 		free_const(ctx->vars[i].value);
 	}
 	ctx->num_vars = 0;
-	xfree(ctx->vars);
+	free(ctx->vars);
 }
 
 EXPORT_SYMBOL(nft_ctx_add_include_path);
@@ -182,9 +182,9 @@ EXPORT_SYMBOL(nft_ctx_clear_include_paths);
 void nft_ctx_clear_include_paths(struct nft_ctx *ctx)
 {
 	while (ctx->num_include_paths)
-		xfree(ctx->include_paths[--ctx->num_include_paths]);
+		free(ctx->include_paths[--ctx->num_include_paths]);
 
-	xfree(ctx->include_paths);
+	free(ctx->include_paths);
 	ctx->include_paths = NULL;
 }
 
@@ -343,9 +343,9 @@ void nft_ctx_free(struct nft_ctx *ctx)
 	nft_ctx_clear_vars(ctx);
 	nft_ctx_clear_include_paths(ctx);
 	scope_free(ctx->top_scope);
-	xfree(ctx->state);
+	free(ctx->state);
 	nft_exit(ctx);
-	xfree(ctx);
+	free(ctx);
 }
 
 EXPORT_SYMBOL(nft_ctx_set_output);
@@ -712,7 +712,7 @@ err:
 			if (indesc->name)
 				free_const(indesc->name);
 
-			xfree(indesc);
+			free(indesc);
 		}
 	}
 	free_const(nft->vars_ctx.buf);
diff --git a/src/meta.c b/src/meta.c
index d8fc5f585e74..bee111fbd473 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -100,13 +100,13 @@ static struct error_record *tchandle_type_parse(struct parse_ctx *ctx,
 		handle = strtoull(sym->identifier, NULL, 0);
 	}
 out:
-	xfree(str);
+	free(str);
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
 				   BYTEORDER_HOST_ENDIAN,
 				   sizeof(handle) * BITS_PER_BYTE, &handle);
 	return NULL;
 err:
-	xfree(str);
+	free(str);
 	return error(&sym->location, "Could not parse %s", sym->dtype->desc);
 }
 
diff --git a/src/misspell.c b/src/misspell.c
index b48ab9cd3342..8cac39f1936b 100644
--- a/src/misspell.c
+++ b/src/misspell.c
@@ -73,7 +73,7 @@ static unsigned int string_distance(const char *a, const char *b)
 
 	ret = DISTANCE(len_a, len_b);
 
-	xfree(distance);
+	free(distance);
 
 	return ret;
 }
diff --git a/src/mnl.c b/src/mnl.c
index 5b11676c81ac..f5707df39ffe 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -243,7 +243,7 @@ static void mnl_err_list_node_add(struct list_head *err_list, int error,
 void mnl_err_list_free(struct mnl_err *err)
 {
 	list_del(&err->head);
-	xfree(err);
+	free(err);
 }
 
 static void mnl_set_sndbuffer(struct netlink_ctx *ctx)
@@ -2180,7 +2180,7 @@ static void basehook_free(struct basehook *b)
 	free_const(b->hookfn);
 	free_const(b->chain);
 	free_const(b->table);
-	xfree(b);
+	free(b);
 }
 
 static void basehook_list_add_tail(struct basehook *b, struct list_head *head)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 53a318aa2e62..d7ece045131a 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1744,9 +1744,9 @@ void netlink_linearize_fini(struct netlink_linearize_ctx *lctx)
 
 	for (i = 0; i < NFT_EXPR_LOC_HSIZE; i++) {
 		list_for_each_entry_safe(eloc, next, &lctx->expr_loc_htable[i], hlist)
-			xfree(eloc);
+			free(eloc);
 	}
-	xfree(lctx->expr_loc_htable);
+	free(lctx->expr_loc_htable);
 }
 
 void netlink_linearize_rule(struct netlink_ctx *ctx,
diff --git a/src/optimize.c b/src/optimize.c
index 2e1079116cd0..6b8ddbf3c6f6 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -1348,16 +1348,16 @@ static int chain_optimize(struct nft_ctx *nft, struct list_head *rules)
 	}
 	ret = 0;
 	for (i = 0; i < ctx->num_rules; i++)
-		xfree(ctx->stmt_matrix[i]);
+		free(ctx->stmt_matrix[i]);
 
-	xfree(ctx->stmt_matrix);
-	xfree(merge);
+	free(ctx->stmt_matrix);
+	free(merge);
 err:
 	for (i = 0; i < ctx->num_stmts; i++)
 		stmt_free(ctx->stmt[i]);
 
-	xfree(ctx->rule);
-	xfree(ctx);
+	free(ctx->rule);
+	free(ctx);
 
 	return ret;
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2bbd028c1477..6122e416a686 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -710,7 +710,7 @@ int nft_lex(void *, void *, void *);
 %destructor { free_const($$); }	extended_prio_name quota_unit	basehook_device_name
 
 %type <expr>			dev_spec
-%destructor { xfree($$); }	dev_spec
+%destructor { free($$); }	dev_spec
 
 %type <table>			table_block_alloc table_block
 %destructor { close_scope(state); table_free($$); }	table_block_alloc
@@ -737,7 +737,7 @@ int nft_lex(void *, void *, void *);
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
-%destructor { stmt_list_free($$); xfree($$); } stmt_list stateful_stmt_list set_elem_stmt_list
+%destructor { stmt_list_free($$); free($$); } stmt_list stateful_stmt_list set_elem_stmt_list
 %type <stmt>			stmt match_stmt verdict_stmt set_elem_stmt
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt set_elem_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt last_stmt
@@ -963,7 +963,7 @@ int nft_lex(void *, void *, void *);
 %type <val>			ct_l4protoname ct_obj_type ct_cmd_type
 
 %type <list>			timeout_states timeout_state
-%destructor { xfree($$); }	timeout_states timeout_state
+%destructor { free($$); }	timeout_states timeout_state
 
 %type <val>			xfrm_state_key	xfrm_state_proto_key xfrm_dir	xfrm_spnum
 %type <expr>			xfrm_expr
@@ -3019,7 +3019,7 @@ rule_alloc		:	stmt_list
 				list_for_each_entry(i, $1, list)
 					$$->num_stmts++;
 				list_splice_tail($1, &$$->stmts);
-				xfree($1);
+				free($1);
 			}
 			;
 
@@ -4532,7 +4532,7 @@ set_elem_expr_alloc	:	set_elem_key_expr	set_elem_stmt_list
 			{
 				$$ = set_elem_expr_alloc(&@1, $1);
 				list_splice_tail($2, &$$->stmt_list);
-				xfree($2);
+				free($2);
 			}
 			|	set_elem_key_expr
 			{
@@ -4844,7 +4844,7 @@ ct_timeout_config	:	PROTOCOL	ct_l4protoname	stmt_separator
 
 				ct = &$<obj>0->ct_timeout;
 				list_splice_tail($4, &ct->timeout_list);
-				xfree($4);
+				free($4);
 			}
 			|	L3PROTOCOL	family_spec_explicit	stmt_separator
 			{
diff --git a/src/rule.c b/src/rule.c
index 6e02cca06d42..e1a4d6b74f3b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -201,7 +201,7 @@ void set_free(struct set *set)
 		stmt_free(stmt);
 	expr_free(set->key);
 	expr_free(set->data);
-	xfree(set);
+	free(set);
 }
 
 struct set *set_lookup_fuzzy(const char *set_name,
@@ -481,7 +481,7 @@ void rule_free(struct rule *rule)
 	stmt_list_free(&rule->stmts);
 	handle_free(&rule->handle);
 	free_const(rule->comment);
-	xfree(rule);
+	free(rule);
 }
 
 void rule_print(const struct rule *rule, struct output_ctx *octx)
@@ -560,14 +560,14 @@ void scope_release(const struct scope *scope)
 		list_del(&sym->list);
 		free_const(sym->identifier);
 		expr_free(sym->expr);
-		xfree(sym);
+		free(sym);
 	}
 }
 
 void scope_free(struct scope *scope)
 {
 	scope_release(scope);
-	xfree(scope);
+	free(scope);
 }
 
 void symbol_bind(struct scope *scope, const char *identifier, struct expr *expr)
@@ -600,7 +600,7 @@ static void symbol_put(struct symbol *sym)
 	if (--sym->refcnt == 0) {
 		free_const(sym->identifier);
 		expr_free(sym->expr);
-		xfree(sym);
+		free(sym);
 	}
 }
 
@@ -735,11 +735,11 @@ void chain_free(struct chain *chain)
 	expr_free(chain->dev_expr);
 	for (i = 0; i < chain->dev_array_len; i++)
 		free_const(chain->dev_array[i]);
-	xfree(chain->dev_array);
+	free(chain->dev_array);
 	expr_free(chain->priority.expr);
 	expr_free(chain->policy);
 	free_const(chain->comment);
-	xfree(chain);
+	free(chain);
 }
 
 struct chain *chain_binding_lookup(const struct table *table,
@@ -1182,7 +1182,7 @@ void table_free(struct table *table)
 	cache_free(&table->set_cache);
 	cache_free(&table->obj_cache);
 	cache_free(&table->ft_cache);
-	xfree(table);
+	free(table);
 }
 
 struct table *table_get(struct table *table)
@@ -1331,7 +1331,7 @@ struct markup *markup_alloc(uint32_t format)
 
 void markup_free(struct markup *m)
 {
-	xfree(m);
+	free(m);
 }
 
 struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event)
@@ -1350,7 +1350,7 @@ struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event)
 void monitor_free(struct monitor *m)
 {
 	free_const(m->event);
-	xfree(m);
+	free(m);
 }
 
 void cmd_free(struct cmd *cmd)
@@ -1404,9 +1404,9 @@ void cmd_free(struct cmd *cmd)
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
 	}
-	xfree(cmd->attr);
+	free(cmd->attr);
 	free_const(cmd->arg);
-	xfree(cmd);
+	free(cmd);
 }
 
 #include <netlink.h>
@@ -1651,10 +1651,10 @@ void obj_free(struct obj *obj)
 		list_for_each_entry_safe(ts, next, &obj->ct_timeout.timeout_list, head) {
 			list_del(&ts->head);
 			free_const(ts->timeout_str);
-			xfree(ts);
+			free(ts);
 		}
 	}
-	xfree(obj);
+	free(obj);
 }
 
 struct obj *obj_lookup_fuzzy(const char *obj_name,
@@ -2064,9 +2064,9 @@ void flowtable_free(struct flowtable *flowtable)
 	if (flowtable->dev_array != NULL) {
 		for (i = 0; i < flowtable->dev_array_len; i++)
 			free_const(flowtable->dev_array[i]);
-		xfree(flowtable->dev_array);
+		free(flowtable->dev_array);
 	}
-	xfree(flowtable);
+	free(flowtable);
 }
 
 static void flowtable_print_declaration(const struct flowtable *flowtable,
diff --git a/src/scanner.l b/src/scanner.l
index c04a58dddc89..1bbb5e0a2075 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -1219,7 +1219,7 @@ void scanner_destroy(struct nft_ctx *nft)
 	struct parser_state *state = yyget_extra(nft->scanner);
 
 	input_descriptor_list_destroy(state);
-	xfree(state->startcond_active);
+	free(state->startcond_active);
 
 	yylex_destroy(nft->scanner);
 }
diff --git a/src/segtree.c b/src/segtree.c
index 0a12a0cd5151..1cd19b513cb4 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -633,6 +633,6 @@ out:
 	if (catchall)
 		compound_expr_add(set, catchall);
 
-	xfree(ranges);
-	xfree(elements);
+	free(ranges);
+	free(elements);
 }
diff --git a/src/statement.c b/src/statement.c
index 1ea24f01e376..5561ceec837f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -52,7 +52,7 @@ void stmt_free(struct stmt *stmt)
 		return;
 	if (stmt->ops->destroy)
 		stmt->ops->destroy(stmt);
-	xfree(stmt);
+	free(stmt);
 }
 
 void stmt_list_free(struct list_head *list)
diff --git a/src/utils.c b/src/utils.c
index caedebda183b..e5b3d5626b98 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -25,11 +25,6 @@ void __noreturn __memory_allocation_error(const char *filename, uint32_t line)
 	exit(NFT_EXIT_NOMEM);
 }
 
-void xfree(const void *ptr)
-{
-	free((void *)ptr);
-}
-
 void *xmalloc(size_t size)
 {
 	void *ptr;
diff --git a/src/xt.c b/src/xt.c
index 9114009e10dd..a56c44049043 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -79,7 +79,7 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 
 			rc = mt->xlate(xl, &params);
 		}
-		xfree(m);
+		free(m);
 		break;
 	case NFT_XT_WATCHER:
 	case NFT_XT_TARGET:
@@ -109,14 +109,14 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 
 			rc = tg->xlate(xl, &params);
 		}
-		xfree(t);
+		free(t);
 		break;
 	}
 
 	if (rc == 1)
 		nft_print(octx, "%s", xt_xlate_get(xl));
 	xt_xlate_free(xl);
-	xfree(entry);
+	free(entry);
 #endif
 	if (!rc)
 		nft_print(octx, "xt %s \"%s\"",
@@ -126,7 +126,7 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 void xt_stmt_destroy(struct stmt *stmt)
 {
 	free_const(stmt->xt.name);
-	xfree(stmt->xt.info);
+	free(stmt->xt.info);
 }
 
 #ifdef HAVE_LIBXTABLES
-- 
2.41.0

