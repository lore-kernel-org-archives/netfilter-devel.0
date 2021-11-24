Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94743C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242026AbhKXR2H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240995AbhKXR2G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:06 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D57C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:56 -0800 (PST)
Received: from localhost ([::1]:44934 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw0t-0001CN-09; Wed, 24 Nov 2021 18:24:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 10/15] Make string-based data types Big Endian
Date:   Wed, 24 Nov 2021 18:22:46 +0100
Message-Id: <20211124172251.11539-11-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Byte-ordering in strings is fixed despite machine's Endianness, so
declaring them Big Endian is more appropriate than Host Endian.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/ct.c                  |  2 +-
 src/datatype.c            | 12 ++++++------
 src/evaluate.c            | 14 +++++++-------
 src/expression.c          |  2 +-
 src/fib.c                 |  2 +-
 src/json.c                |  2 +-
 src/meta.c                | 16 ++++++++--------
 src/mnl.c                 |  4 ++--
 src/netlink.c             | 10 +++++-----
 src/netlink_delinearize.c | 14 +++++++-------
 src/osf.c                 |  2 +-
 src/parser_bison.y        | 16 ++++++++--------
 12 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index 6049157198ad9..11ee270b21862 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -259,7 +259,7 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 					      BYTEORDER_HOST_ENDIAN,
 					      4 * BITS_PER_BYTE),
 	[NFT_CT_HELPER]		= CT_TEMPLATE("helper",	    &string_type,
-					      BYTEORDER_HOST_ENDIAN,
+					      BYTEORDER_BIG_ENDIAN,
 					      NF_CT_HELPER_NAME_LEN * BITS_PER_BYTE),
 	[NFT_CT_L3PROTOCOL]	= CT_TEMPLATE("l3proto",    &nfproto_type,
 					      BYTEORDER_HOST_ENDIAN,
diff --git a/src/datatype.c b/src/datatype.c
index b2e667cef2c62..e72e5a5a797cd 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -259,7 +259,7 @@ void expr_chain_export(const struct expr *e, char *chain_name)
 		BUG("verdict expression length %u is too large (%u bits max)",
 		    e->len, NFT_CHAIN_MAXNAMELEN * BITS_PER_BYTE);
 
-	mpz_export_data(chain_name, e->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(chain_name, e->value, BYTEORDER_BIG_ENDIAN, len);
 }
 
 static void verdict_jump_chain_print(const char *what, const struct expr *e,
@@ -326,7 +326,7 @@ static struct error_record *verdict_type_parse(struct parse_ctx *ctx,
 					       struct expr **res)
 {
 	*res = constant_expr_alloc(&sym->location, &string_type,
-				   BYTEORDER_HOST_ENDIAN,
+				   BYTEORDER_BIG_ENDIAN,
 				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
 				   sym->identifier);
 	return NULL;
@@ -431,7 +431,7 @@ static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	char data[len+1];
 
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 	data[len] = '\0';
 	nft_print(octx, "\"%s\"", data);
 }
@@ -441,7 +441,7 @@ static struct error_record *string_type_parse(struct parse_ctx *ctx,
 	      				      struct expr **res)
 {
 	*res = constant_expr_alloc(&sym->location, &string_type,
-				   BYTEORDER_HOST_ENDIAN,
+				   BYTEORDER_BIG_ENDIAN,
 				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
 				   sym->identifier);
 	return NULL;
@@ -451,7 +451,7 @@ const struct datatype string_type = {
 	.type		= TYPE_STRING,
 	.name		= "string",
 	.desc		= "string",
-	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.print		= string_type_print,
 	.json		= string_type_json,
 	.parse		= string_type_parse,
@@ -1309,7 +1309,7 @@ static struct error_record *priority_type_parse(struct parse_ctx *ctx,
 	} else {
 		erec_destroy(erec);
 		*res = constant_expr_alloc(&sym->location, &string_type,
-					   BYTEORDER_HOST_ENDIAN,
+					   BYTEORDER_BIG_ENDIAN,
 					   strlen(sym->identifier) * BITS_PER_BYTE,
 					   sym->identifier);
 	}
diff --git a/src/evaluate.c b/src/evaluate.c
index 49fb8f84fe76b..fbf3aa8d19139 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -293,7 +293,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 	}
 
 	memset(data + len, 0, data_len - len);
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 
 	if (strlen(data) == 0)
 		return expr_error(ctx->msgs, expr,
@@ -305,7 +305,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 		 * expression length to avoid problems on big endian.
 		 */
 		value = constant_expr_alloc(&expr->location, ctx->ectx.dtype,
-					    BYTEORDER_HOST_ENDIAN,
+					    BYTEORDER_BIG_ENDIAN,
 					    expr->len, data);
 		expr_free(expr);
 		*exprp = value;
@@ -323,21 +323,21 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 		xstrunescape(data, unescaped_str);
 
 		value = constant_expr_alloc(&expr->location, ctx->ectx.dtype,
-					    BYTEORDER_HOST_ENDIAN,
+					    BYTEORDER_BIG_ENDIAN,
 					    expr->len, unescaped_str);
 		expr_free(expr);
 		*exprp = value;
 		return 0;
 	}
 	value = constant_expr_alloc(&expr->location, ctx->ectx.dtype,
-				    BYTEORDER_HOST_ENDIAN,
+				    BYTEORDER_BIG_ENDIAN,
 				    datalen * BITS_PER_BYTE, data);
 
 	prefix = prefix_expr_alloc(&expr->location, value,
 				   datalen * BITS_PER_BYTE);
 	datatype_set(prefix, ctx->ectx.dtype);
 	prefix->flags |= EXPR_F_CONSTANT;
-	prefix->byteorder = BYTEORDER_HOST_ENDIAN;
+	prefix->byteorder = BYTEORDER_BIG_ENDIAN;
 
 	expr_free(expr);
 	*exprp = prefix;
@@ -3582,7 +3582,7 @@ static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_error(ctx, stmt, "log prefix is too long");
 
 	expr = constant_expr_alloc(&stmt->log.prefix->location, &string_type,
-				   BYTEORDER_HOST_ENDIAN,
+				   BYTEORDER_BIG_ENDIAN,
 				   strlen(prefix) * BITS_PER_BYTE, prefix);
 	expr_free(stmt->log.prefix);
 	stmt->log.prefix = expr;
@@ -4045,7 +4045,7 @@ static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
 	if (prio->expr->dtype->type == TYPE_INTEGER)
 		return true;
 
-	mpz_export_data(prio_str, prio->expr->value, BYTEORDER_HOST_ENDIAN,
+	mpz_export_data(prio_str, prio->expr->value, BYTEORDER_BIG_ENDIAN,
 			NFT_NAME_MAXLEN);
 	loc = prio->expr->location;
 
diff --git a/src/expression.c b/src/expression.c
index 4c0874fe99500..24f908cd8136d 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -186,7 +186,7 @@ void expr_to_string(const struct expr *expr, char *string)
 
 	assert(expr->dtype == &string_type);
 
-	mpz_export_data(string, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(string, expr->value, BYTEORDER_BIG_ENDIAN, len);
 }
 
 void expr_set_type(struct expr *expr, const struct datatype *dtype,
diff --git a/src/fib.c b/src/fib.c
index c6ad0f9c5d15d..e06e8c69ce050 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -192,7 +192,7 @@ struct expr *fib_expr_alloc(const struct location *loc,
 		type = &boolean_type;
 
 	expr = expr_alloc(loc, EXPR_FIB, type,
-			  BYTEORDER_HOST_ENDIAN, len);
+			  type->byteorder, len);
 
 	expr->fib.result = result;
 	expr->fib.flags	= flags;
diff --git a/src/json.c b/src/json.c
index 63b325afc8d1c..f03b635ea9235 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1020,7 +1020,7 @@ json_t *string_type_json(const struct expr *expr, struct output_ctx *octx)
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	char data[len+1];
 
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 	data[len] = '\0';
 
 	return json_string(data);
diff --git a/src/meta.c b/src/meta.c
index 23b1fd2759483..97e79b9e6d9ab 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -378,7 +378,7 @@ const struct datatype ifname_type = {
 	.type		= TYPE_IFNAME,
 	.name		= "ifname",
 	.desc		= "network interface name",
-	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= IFNAMSIZ * BITS_PER_BYTE,
 	.basetype	= &string_type,
 };
@@ -623,14 +623,14 @@ const struct meta_template meta_templates[] = {
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_IIFTYPE]	= META_TEMPLATE("iiftype",   &arphrd_type,
 						2 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIF]		= META_TEMPLATE("oif",	     &ifindex_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_OIFTYPE]	= META_TEMPLATE("oiftype",   &arphrd_type,
 						2 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_SKUID]	= META_TEMPLATE("skuid",     &uid_type,
@@ -643,10 +643,10 @@ const struct meta_template meta_templates[] = {
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_BRI_IIFNAME]	= META_TEMPLATE("ibrname",  &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("obrname",  &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_PKTTYPE]	= META_TEMPLATE("pkttype",   &pkttype_type,
 						BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
@@ -669,10 +669,10 @@ const struct meta_template meta_templates[] = {
 						BITS_PER_BYTE, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_IIFKIND]	= META_TEMPLATE("iifkind",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_OIFKIND]	= META_TEMPLATE("oifkind",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_BRI_IIFPVID]	= META_TEMPLATE("ibrpvid",   &integer_type,
 						2 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
@@ -695,7 +695,7 @@ const struct meta_template meta_templates[] = {
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_SDIFNAME]	= META_TEMPLATE("sdifname", &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
diff --git a/src/mnl.c b/src/mnl.c
index 4a10647f9f179..a3ee32680a77a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -722,7 +722,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 				ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
 				memset(ifname, 0, sizeof(ifname));
 				mpz_export_data(ifname, expr->value,
-						BYTEORDER_HOST_ENDIAN,
+						BYTEORDER_BIG_ENDIAN,
 						ifname_len);
 				dev_array[i++] = xstrdup(ifname);
 				if (i == dev_array_len) {
@@ -1820,7 +1820,7 @@ static const char **nft_flowtable_dev_array(struct cmd *cmd)
 	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list) {
 		ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
 		memset(ifname, 0, sizeof(ifname));
-		mpz_export_data(ifname, expr->value, BYTEORDER_HOST_ENDIAN,
+		mpz_export_data(ifname, expr->value, BYTEORDER_BIG_ENDIAN,
 				ifname_len);
 		dev_array[i++] = xstrdup(ifname);
 	}
diff --git a/src/netlink.c b/src/netlink.c
index ab90d0c05acaf..d1531070dcc93 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -345,7 +345,7 @@ static void netlink_gen_chain(const struct expr *expr,
 	memset(chain, 0, sizeof(chain));
 
 	mpz_export_data(chain, expr->chain->value,
-			BYTEORDER_HOST_ENDIAN, len);
+			BYTEORDER_BIG_ENDIAN, len);
 	snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
 }
 
@@ -438,7 +438,7 @@ static struct expr *netlink_alloc_verdict(const struct location *loc,
 	case NFT_JUMP:
 	case NFT_GOTO:
 		chain = constant_expr_alloc(loc, &string_type,
-					    BYTEORDER_HOST_ENDIAN,
+					    BYTEORDER_BIG_ENDIAN,
 					    strlen(nld->chain) * BITS_PER_BYTE,
 					    nld->chain);
 		break;
@@ -895,6 +895,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		objtype = nftnl_set_get_u32(nls, NFTNL_SET_OBJ_TYPE);
 		assert(!datatype);
 		datatype = &string_type;
+		databyteorder = BYTEORDER_BIG_ENDIAN;
 	}
 
 	set = set_alloc(&netlink_location);
@@ -1328,8 +1329,7 @@ key_end:
 
 		data = netlink_alloc_value(&netlink_location, &nld);
 		data->dtype = &string_type;
-		data->byteorder = BYTEORDER_HOST_ENDIAN;
-		mpz_switch_byteorder(data->value, data->len / BITS_PER_BYTE);
+		data->byteorder = BYTEORDER_BIG_ENDIAN;
 		expr = mapping_expr_alloc(&netlink_location, expr, data);
 	}
 out:
@@ -1771,7 +1771,7 @@ static void trace_print_verdict(const struct nftnl_trace *nlt,
 		chain = xstrdup(nftnl_trace_get_str(nlt, NFTNL_TRACE_JUMP_TARGET));
 		chain_expr = constant_expr_alloc(&netlink_location,
 						 &string_type,
-						 BYTEORDER_HOST_ENDIAN,
+						 BYTEORDER_BIG_ENDIAN,
 						 strlen(chain) * BITS_PER_BYTE,
 						 chain);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index db58e8c386c00..872c36f186c0f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -979,7 +979,7 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOG_PREFIX)) {
 		stmt->log.prefix = constant_expr_alloc(&internal_location,
 						       &string_type,
-						       BYTEORDER_HOST_ENDIAN,
+						       BYTEORDER_BIG_ENDIAN,
 						       (strlen(prefix) + 1) * BITS_PER_BYTE,
 						       prefix);
 		stmt->log.flags |= STMT_LOG_PREFIX;
@@ -1703,7 +1703,7 @@ static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
 					   &nld.len);
 		expr = netlink_alloc_value(&netlink_location, &nld);
 		datatype_set(expr, &string_type);
-		expr->byteorder = BYTEORDER_HOST_ENDIAN;
+		expr->byteorder = BYTEORDER_BIG_ENDIAN;
 	} else if (nftnl_expr_is_set(nle, NFTNL_EXPR_OBJREF_SET_SREG)) {
 		struct expr *left, *right;
 		enum nft_registers sreg;
@@ -1732,7 +1732,7 @@ static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
 
 		right = set_ref_expr_alloc(loc, set);
 		expr = map_expr_alloc(loc, left, right);
-		expr_set_type(expr, &string_type, BYTEORDER_HOST_ENDIAN);
+		expr_set_type(expr, &string_type, BYTEORDER_BIG_ENDIAN);
 		type = set->objtype;
 	} else {
 		netlink_error(ctx, loc, "unknown objref expression type %u",
@@ -2413,12 +2413,12 @@ static struct expr *string_wildcard_expr_alloc(struct location *loc,
 	char data[len + 2];
 	int pos;
 
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 	pos = div_round_up(expr_mask_to_prefix(mask), BITS_PER_BYTE);
 	data[pos] = '*';
 	data[pos + 1] = '\0';
 
-	return constant_expr_alloc(loc, expr->dtype, BYTEORDER_HOST_ENDIAN,
+	return constant_expr_alloc(loc, expr->dtype, BYTEORDER_BIG_ENDIAN,
 				   expr->len + BITS_PER_BYTE, data);
 }
 
@@ -2431,7 +2431,7 @@ static bool __expr_postprocess_string(struct expr **exprp)
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	char data[len + 1];
 
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 
 	if (data[len - 1] != '\0')
 		return false;
@@ -2442,7 +2442,7 @@ static bool __expr_postprocess_string(struct expr **exprp)
 		data[len]	= '*';
 		data[len + 1]	= '\0';
 		expr = constant_expr_alloc(&expr->location, expr->dtype,
-					   BYTEORDER_HOST_ENDIAN,
+					   BYTEORDER_BIG_ENDIAN,
 					   (len + 2) * BITS_PER_BYTE, data);
 		expr_free(*exprp);
 		*exprp = expr;
diff --git a/src/osf.c b/src/osf.c
index cb58315d714d1..863646109927b 100644
--- a/src/osf.c
+++ b/src/osf.c
@@ -67,7 +67,7 @@ struct expr *osf_expr_alloc(const struct location *loc, const uint8_t ttl,
 	struct expr *expr;
 
 	expr = expr_alloc(loc, EXPR_OSF, type,
-			  BYTEORDER_HOST_ENDIAN, len);
+			  BYTEORDER_BIG_ENDIAN, len);
 	expr->osf.ttl = ttl;
 	expr->osf.flags = flags;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 81d75ecb2fe8a..87294b9a56026 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2143,7 +2143,7 @@ flowtable_list_expr	:	flowtable_expr_member
 flowtable_expr_member	:	STRING
 			{
 				$$ = constant_expr_alloc(&@$, &string_type,
-							 BYTEORDER_HOST_ENDIAN,
+							 BYTEORDER_BIG_ENDIAN,
 							 strlen($1) * BITS_PER_BYTE, $1);
 				xfree($1);
 			}
@@ -2406,7 +2406,7 @@ extended_prio_spec	:	int_num
 				struct prio_spec spec = {0};
 
 				spec.expr = constant_expr_alloc(&@$, &string_type,
-								BYTEORDER_HOST_ENDIAN,
+								BYTEORDER_BIG_ENDIAN,
 								strlen($1) * BITS_PER_BYTE,
 								$1);
 				xfree($1);
@@ -2419,7 +2419,7 @@ extended_prio_spec	:	int_num
 				char str[NFT_NAME_MAXLEN];
 				snprintf(str, sizeof(str), "%s + %" PRIu64, $1, $3);
 				spec.expr = constant_expr_alloc(&@$, &string_type,
-								BYTEORDER_HOST_ENDIAN,
+								BYTEORDER_BIG_ENDIAN,
 								strlen(str) * BITS_PER_BYTE,
 								str);
 				xfree($1);
@@ -2432,7 +2432,7 @@ extended_prio_spec	:	int_num
 
 				snprintf(str, sizeof(str), "%s - %" PRIu64, $1, $3);
 				spec.expr = constant_expr_alloc(&@$, &string_type,
-								BYTEORDER_HOST_ENDIAN,
+								BYTEORDER_BIG_ENDIAN,
 								strlen(str) * BITS_PER_BYTE,
 								str);
 				xfree($1);
@@ -2449,7 +2449,7 @@ dev_spec		:	DEVICE	string
 				struct expr *expr;
 
 				expr = constant_expr_alloc(&@$, &string_type,
-							   BYTEORDER_HOST_ENDIAN,
+							   BYTEORDER_BIG_ENDIAN,
 							   strlen($2) * BITS_PER_BYTE, $2);
 				xfree($2);
 				$$ = compound_expr_alloc(&@$, EXPR_LIST);
@@ -2944,7 +2944,7 @@ log_arg			:	PREFIX			string
 				/* No variables in log prefix, skip. */
 				if (!strchr($2, '$')) {
 					expr = constant_expr_alloc(&@$, &string_type,
-								   BYTEORDER_HOST_ENDIAN,
+								   BYTEORDER_BIG_ENDIAN,
 								   (strlen($2) + 1) * BITS_PER_BYTE, $2);
 					xfree($2);
 					$<stmt>0->log.prefix = expr;
@@ -2981,7 +2981,7 @@ log_arg			:	PREFIX			string
 
 						*end = '\0';
 						item = constant_expr_alloc(&@$, &string_type,
-									   BYTEORDER_HOST_ENDIAN,
+									   BYTEORDER_BIG_ENDIAN,
 									   (strlen(start) + 1) * BITS_PER_BYTE,
 									   start);
 						compound_expr_add(expr, item);
@@ -4861,7 +4861,7 @@ chain_expr		:	variable_expr
 			|	identifier
 			{
 				$$ = constant_expr_alloc(&@$, &string_type,
-							 BYTEORDER_HOST_ENDIAN,
+							 BYTEORDER_BIG_ENDIAN,
 							 strlen($1) * BITS_PER_BYTE,
 							 $1);
 				xfree($1);
-- 
2.33.0

