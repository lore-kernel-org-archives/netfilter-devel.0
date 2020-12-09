Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49755C1B0D9
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1761423B99
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgLIRu3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgLIRuX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 12:50:23 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02275C061794
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 09:49:43 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kn3av-0004Qs-KA; Wed, 09 Dec 2020 18:49:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 03/10] src: add auto-dependencies for ipv4 icmp
Date:   Wed,  9 Dec 2020 18:49:17 +0100
Message-Id: <20201209174924.27720-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209174924.27720-1-fw@strlen.de>
References: <20201209174924.27720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The ICMP header has field values that are only exist
for certain types.

Mark the icmp proto 'type' field as a nextheader field
and add a new th description to store the icmp type
dependency.  This can later be re-used for other protocol
dependend definitions such as mptcp options -- which are all share the
same tcp option number and have a special 4 bit marker inside the
mptcp option space that tells how the remaining option looks like.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h |   3 ++
 include/proto.h   |  16 +++++-
 src/evaluate.c    |  20 ++++++-
 src/payload.c     | 129 +++++++++++++++++++++++++++++++++++++++++++++-
 src/proto.c       |  25 ++++++---
 5 files changed, 182 insertions(+), 11 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index a914d23930e9..7bbb19b936a9 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -15,6 +15,9 @@ struct eval_ctx;
 struct stmt;
 extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  struct stmt **res);
+extern int payload_gen_icmp_dependency(struct eval_ctx *ctx,
+				       const struct expr *expr,
+				       struct stmt **res);
 extern int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				 const struct proto_desc *dependency,
 				 enum proto_bases pb, struct stmt **res);
diff --git a/include/proto.h b/include/proto.h
index 667650d67c97..f383291b5a79 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -25,6 +25,13 @@ enum proto_bases {
 extern const char *proto_base_names[];
 extern const char *proto_base_tokens[];
 
+enum icmp_hdr_field_type {
+	PROTO_ICMP_ANY = 0,
+	PROTO_ICMP_ECHO,	/* echo and reply */
+	PROTO_ICMP_MTU,		/* destination unreachable */
+	PROTO_ICMP_ADDRESS,	/* redirect */
+};
+
 /**
  * struct proto_hdr_template - protocol header field description
  *
@@ -33,6 +40,7 @@ extern const char *proto_base_tokens[];
  * @offset:	offset of the header field from base
  * @len:	length of header field
  * @meta_key:	special case: meta expression key
+ * @icmp_dep:  special case: icmp header dependency
  */
 struct proto_hdr_template {
 	const char			*token;
@@ -41,6 +49,7 @@ struct proto_hdr_template {
 	uint16_t			len;
 	enum byteorder			byteorder:8;
 	enum nft_meta_keys		meta_key:8;
+	enum icmp_hdr_field_type	icmp_dep:8;
 };
 
 #define PROTO_HDR_TEMPLATE(__token, __dtype,  __byteorder, __offset, __len)\
@@ -170,7 +179,12 @@ extern const struct proto_desc *proto_dev_desc(uint16_t type);
  */
 struct proto_ctx {
 	unsigned int			debug_mask;
-	unsigned int			family;
+	uint8_t				family;
+	union {
+		struct {
+			uint8_t			type;
+		} icmp;
+	} th_dep;
 	struct {
 		struct location			location;
 		const struct proto_desc		*desc;
diff --git a/src/evaluate.c b/src/evaluate.c
index 76b25b408d55..3eb8e1bfc2c5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -706,7 +706,8 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 			return -1;
 
 		rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
-		return 0;
+		desc = ctx->pctx.protocol[base].desc;
+		goto check_icmp;
 	}
 
 	if (payload->payload.base == desc->base &&
@@ -724,7 +725,24 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 	 * if needed.
 	 */
 	if (desc == payload->payload.desc) {
+		const struct proto_hdr_template *tmpl;
+
 		payload->payload.offset += ctx->pctx.protocol[base].offset;
+check_icmp:
+		if (desc != &proto_icmp)
+			return 0;
+
+		tmpl = expr->payload.tmpl;
+
+		if (!tmpl || !tmpl->icmp_dep)
+			return 0;
+
+		if (payload_gen_icmp_dependency(ctx, expr, &nstmt) < 0)
+			return -1;
+
+		if (nstmt)
+			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+
 		return 0;
 	}
 	/* If we already have context and this payload is on the same
diff --git a/src/payload.c b/src/payload.c
index e51c5797c589..54b08f051dc0 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -19,6 +19,7 @@
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
 #include <linux/if_ether.h>
+#include <netinet/ip_icmp.h>
 
 #include <rule.h>
 #include <expression.h>
@@ -95,8 +96,16 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 	base = ctx->protocol[left->payload.base].desc;
 	desc = proto_find_upper(base, proto);
 
-	if (!desc)
+	if (!desc) {
+		if (base == &proto_icmp) {
+			/* proto 0 is ECHOREPLY, just pretend its ECHO.
+			 * Not doing this would need an additional marker
+			 * bit to tell when icmp.type was set.
+			 */
+			ctx->th_dep.icmp.type = proto ? proto : ICMP_ECHO;
+		}
 		return;
+	}
 
 	assert(desc->base <= PROTO_BASE_MAX);
 	if (desc->base == base->base) {
@@ -662,6 +671,19 @@ void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 	}
 }
 
+static uint8_t icmp_dep_to_type(enum icmp_hdr_field_type t)
+{
+	switch (t) {
+	case PROTO_ICMP_ANY:
+		BUG("Invalid map for simple dependency");
+	case PROTO_ICMP_ECHO: return ICMP_ECHO;
+	case PROTO_ICMP_MTU: return ICMP_DEST_UNREACH;
+	case PROTO_ICMP_ADDRESS: return ICMP_REDIRECT;
+	}
+
+	BUG("Missing icmp type mapping");
+}
+
 /**
  * payload_expr_complete - fill in type information of a raw payload expr
  *
@@ -913,3 +935,108 @@ struct expr *payload_expr_join(const struct expr *e1, const struct expr *e2)
 	expr->len	     = e1->len + e2->len;
 	return expr;
 }
+
+static struct stmt *
+__payload_gen_icmp_simple_dependency(struct eval_ctx *ctx, const struct expr *expr,
+				     const struct datatype *icmp_type,
+				     const struct proto_desc *desc,
+				     uint8_t type)
+{
+	struct expr *left, *right, *dep;
+
+	left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
+	right = constant_expr_alloc(&expr->location, icmp_type,
+				    BYTEORDER_BIG_ENDIAN, BITS_PER_BYTE,
+				    constant_data_ptr(type, BITS_PER_BYTE));
+
+	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
+	return expr_stmt_alloc(&dep->location, dep);
+}
+
+static struct stmt *
+__payload_gen_icmp_echo_dependency(struct eval_ctx *ctx, const struct expr *expr,
+				   uint8_t echo, uint8_t reply,
+				   const struct datatype *icmp_type,
+				   const struct proto_desc *desc)
+{
+	struct expr *left, *right, *dep, *set;
+
+	left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
+
+	set = set_expr_alloc(&expr->location, NULL);
+
+	right = constant_expr_alloc(&expr->location, icmp_type,
+				    BYTEORDER_BIG_ENDIAN, BITS_PER_BYTE,
+				    constant_data_ptr(echo, BITS_PER_BYTE));
+	right = set_elem_expr_alloc(&expr->location, right);
+	compound_expr_add(set, right);
+
+	right = constant_expr_alloc(&expr->location, icmp_type,
+				    BYTEORDER_BIG_ENDIAN, BITS_PER_BYTE,
+				    constant_data_ptr(reply, BITS_PER_BYTE));
+	right = set_elem_expr_alloc(&expr->location, right);
+	compound_expr_add(set, right);
+
+	dep = relational_expr_alloc(&expr->location, OP_IMPLICIT, left, set);
+	return expr_stmt_alloc(&dep->location, dep);
+}
+
+int payload_gen_icmp_dependency(struct eval_ctx *ctx, const struct expr *expr,
+				struct stmt **res)
+{
+	const struct proto_hdr_template *tmpl;
+	const struct proto_desc *desc;
+	struct stmt *stmt = NULL;
+	uint8_t type;
+
+	assert(expr->etype == EXPR_PAYLOAD);
+
+	tmpl = expr->payload.tmpl;
+	desc = expr->payload.desc;
+
+	switch (tmpl->icmp_dep) {
+	case PROTO_ICMP_ANY:
+		BUG("No dependency needed");
+		break;
+	case PROTO_ICMP_ECHO:
+		/* do not test ICMP_ECHOREPLY here: its 0 */
+		if (ctx->pctx.th_dep.icmp.type == ICMP_ECHO)
+			goto done;
+
+		type = ICMP_ECHO;
+		if (ctx->pctx.th_dep.icmp.type)
+			goto bad_proto;
+
+		stmt = __payload_gen_icmp_echo_dependency(ctx, expr,
+							  ICMP_ECHO, ICMP_ECHOREPLY,
+							  &icmp_type_type,
+							  desc);
+		break;
+	case PROTO_ICMP_MTU:
+	case PROTO_ICMP_ADDRESS:
+		type = icmp_dep_to_type(tmpl->icmp_dep);
+		if (ctx->pctx.th_dep.icmp.type == type)
+			goto done;
+		if (ctx->pctx.th_dep.icmp.type)
+			goto bad_proto;
+		stmt = __payload_gen_icmp_simple_dependency(ctx, expr,
+							    &icmp_type_type,
+							    desc, type);
+		break;
+	default:
+		BUG("Unhandled icmp dependency code");
+	}
+
+	ctx->pctx.th_dep.icmp.type = type;
+
+	if (stmt_evaluate(ctx, stmt) < 0)
+		return expr_error(ctx->msgs, expr,
+				  "icmp dependency statement is invalid");
+done:
+	*res = stmt;
+	return 0;
+
+bad_proto:
+	return expr_error(ctx->msgs, expr, "incompatible icmp match: rule has %d, need %u",
+			  ctx->pctx.th_dep.icmp.type, type);
+}
diff --git a/src/proto.c b/src/proto.c
index c42e8f517bae..d3371ac65975 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -396,25 +396,34 @@ const struct datatype icmp_type_type = {
 	.sym_tbl	= &icmp_type_tbl,
 };
 
-#define ICMPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct icmphdr, __member)
+#define ICMPHDR_FIELD(__token, __member, __dep)					\
+	{									\
+		.token		= (__token),					\
+		.dtype		= &integer_type,				\
+		.byteorder	= BYTEORDER_BIG_ENDIAN,				\
+		.offset		= offsetof(struct icmphdr, __member) * 8,	\
+		.len		= field_sizeof(struct icmphdr, __member) * 8,	\
+		.icmp_dep	= (__dep),					\
+	}
+
 #define ICMPHDR_TYPE(__name, __type, __member) \
-	HDR_TYPE(__name, __type, struct icmphdr, __member)
+	HDR_TYPE(__name,  __type, struct icmphdr, __member)
 
 const struct proto_desc proto_icmp = {
 	.name		= "icmp",
 	.id		= PROTO_DESC_ICMP,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	= ICMPHDR_TYPE,
 	.checksum_key	= ICMPHDR_CHECKSUM,
 	.checksum_type  = NFT_PAYLOAD_CSUM_INET,
 	.templates	= {
 		[ICMPHDR_TYPE]		= ICMPHDR_TYPE("type", &icmp_type_type, type),
 		[ICMPHDR_CODE]		= ICMPHDR_TYPE("code", &icmp_code_type, code),
-		[ICMPHDR_CHECKSUM]	= ICMPHDR_FIELD("checksum", checksum),
-		[ICMPHDR_ID]		= ICMPHDR_FIELD("id", un.echo.id),
-		[ICMPHDR_SEQ]		= ICMPHDR_FIELD("sequence", un.echo.sequence),
-		[ICMPHDR_GATEWAY]	= ICMPHDR_FIELD("gateway", un.gateway),
-		[ICMPHDR_MTU]		= ICMPHDR_FIELD("mtu", un.frag.mtu),
+		[ICMPHDR_CHECKSUM]	= ICMPHDR_FIELD("checksum", checksum, PROTO_ICMP_ANY),
+		[ICMPHDR_ID]		= ICMPHDR_FIELD("id", un.echo.id, PROTO_ICMP_ECHO),
+		[ICMPHDR_SEQ]		= ICMPHDR_FIELD("sequence", un.echo.sequence, PROTO_ICMP_ECHO),
+		[ICMPHDR_GATEWAY]	= ICMPHDR_FIELD("gateway", un.gateway, PROTO_ICMP_ADDRESS),
+		[ICMPHDR_MTU]		= ICMPHDR_FIELD("mtu", un.frag.mtu, PROTO_ICMP_MTU),
 	},
 };
 
-- 
2.26.2

