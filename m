Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D300EE82CCD
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 20:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjI0UDA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 16:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjI0UC7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 16:02:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC78126
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695844928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s+TCLL8ggyPYHaTKeMaDPRoCRE64OltaaMKUScs1Seg=;
        b=boihEwf20jMKKnD1hlYLlfOZFyfAjJBL9/o1oSJeviuTi+I+DmKfRlMk4T0QqJc9hF3Dl3
        gP3/fIQImGIUODtiWx6POQ4cMQ0UmCYVyYdvUsIdCjSuJUVjf9myuMI1Vpq+V+wdUTQbOx
        b8jNLLrc/ZP+N1JQwUp5mAye2YM9Z3U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-zbq94umbN2WjCjzv4oisLg-1; Wed, 27 Sep 2023 16:01:56 -0400
X-MC-Unique: zbq94umbN2WjCjzv4oisLg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F1C9101AA42
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 20:01:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8312940C6EA8;
        Wed, 27 Sep 2023 20:01:55 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/5] datatype: make "flags" field of datatype struct simple booleans
Date:   Wed, 27 Sep 2023 21:57:24 +0200
Message-ID: <20230927200143.3798124-2-thaller@redhat.com>
In-Reply-To: <20230927200143.3798124-1-thaller@redhat.com>
References: <20230927200143.3798124-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Flags are not always bad. For example, as a function argument they allow
easier extension in the future. But with datatype's "flags" argument and
enum datatype_flags there are no advantages of this approach.

- replace DTYPE_F_PREFIX with a "bool f_prefix:1" field.

- replace DTYPE_F_ALLOC with a "bool f_alloc:1" field.

- the new boolean fields are made bitfields, although for the moment
  that does not reduce the size of the struct. If we add more flags,
  that will be different.

- also reorder fields in "struct datatype" so that fields of similar
  alignment (and type) are beside each other. Specifically moving
  "refcnt" field beside other integer fields saves one pointer size on
  x86-64.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h        | 32 +++++++++++++++-----------------
 src/datatype.c            | 21 ++++++++++-----------
 src/meta.c                |  2 +-
 src/netlink_delinearize.c |  2 +-
 src/rt.c                  |  2 +-
 src/segtree.c             |  5 ++---
 6 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 09a7894567e4..b53a739e1e6c 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -120,26 +120,18 @@ enum byteorder {
 
 struct expr;
 
-/**
- * enum datatype_flags
- *
- * @DTYPE_F_ALLOC:		datatype is dynamically allocated
- * @DTYPE_F_PREFIX:		preferred representation for ranges is a prefix
- */
-enum datatype_flags {
-	DTYPE_F_ALLOC		= (1 << 0),
-	DTYPE_F_PREFIX		= (1 << 1),
-};
-
 struct parse_ctx;
 /**
  * struct datatype
  *
  * @type:	numeric identifier
- * @byteorder:	byteorder of type (non-basetypes only)
- * @flags:	flags
  * @size:	type size (fixed sized non-basetypes only)
  * @subtypes:	number of subtypes (concat type)
+ * @refcnt:	reference counter for dynamically allocated instances.
+ * @byteorder:	byteorder of type (non-basetypes only)
+ * @f_prefix:	preferred representation for ranges is a prefix
+ * @f_alloc:	whether the instance is dynamically allocated. If not, datatype_get() and
+ *		datatype_free() are NOPs.
  * @name:	type name
  * @desc:	type description
  * @basetype:	basetype for subtypes, determines type compatibility
@@ -147,14 +139,21 @@ struct parse_ctx;
  * @print:	function to print a constant of this type
  * @parse:	function to parse a symbol and return an expression
  * @sym_tbl:	symbol table for this type
- * @refcnt:	reference counter (only for DTYPE_F_ALLOC)
  */
 struct datatype {
 	uint32_t			type;
-	enum byteorder			byteorder;
-	unsigned int			flags;
 	unsigned int			size;
 	unsigned int			subtypes;
+
+	/* Refcount for dynamically allocated instances. For static instances
+	 * this is zero (get() and free() are NOPs).
+	 */
+	unsigned int			refcnt;
+
+	enum byteorder			byteorder;
+	bool				f_prefix:1;
+	bool				f_alloc:1;
+
 	const char			*name;
 	const char			*desc;
 	const struct datatype		*basetype;
@@ -169,7 +168,6 @@ struct datatype {
 	struct error_record		*(*err)(const struct expr *sym);
 	void				(*describe)(struct output_ctx *octx);
 	const struct symbol_table	*sym_tbl;
-	unsigned int			refcnt;
 };
 
 extern const struct datatype *datatype_lookup(enum datatypes type);
diff --git a/src/datatype.c b/src/datatype.c
index 6fe46e899c4b..464eb49171c6 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -642,7 +642,7 @@ const struct datatype ipaddr_type = {
 	.basetype	= &integer_type,
 	.print		= ipaddr_type_print,
 	.parse		= ipaddr_type_parse,
-	.flags		= DTYPE_F_PREFIX,
+	.f_prefix	= true,
 };
 
 static void ip6addr_type_print(const struct expr *expr, struct output_ctx *octx)
@@ -709,7 +709,7 @@ const struct datatype ip6addr_type = {
 	.basetype	= &integer_type,
 	.print		= ip6addr_type_print,
 	.parse		= ip6addr_type_parse,
-	.flags		= DTYPE_F_PREFIX,
+	.f_prefix	= true,
 };
 
 static void inet_protocol_type_print(const struct expr *expr,
@@ -945,7 +945,7 @@ const struct datatype mark_type = {
 	.print		= mark_type_print,
 	.json		= mark_type_json,
 	.parse		= mark_type_parse,
-	.flags		= DTYPE_F_PREFIX,
+	.f_prefix	= true,
 };
 
 static const struct symbol_table icmp_code_tbl = {
@@ -1204,7 +1204,7 @@ static struct datatype *datatype_alloc(void)
 	struct datatype *dtype;
 
 	dtype = xzalloc(sizeof(*dtype));
-	dtype->flags = DTYPE_F_ALLOC;
+	dtype->f_alloc = true;
 	dtype->refcnt = 1;
 
 	return dtype;
@@ -1216,10 +1216,10 @@ const struct datatype *datatype_get(const struct datatype *ptr)
 
 	if (!dtype)
 		return NULL;
-	if (!(dtype->flags & DTYPE_F_ALLOC))
-		return dtype;
 
-	dtype->refcnt++;
+	if (dtype->f_alloc)
+		dtype->refcnt++;
+
 	return dtype;
 }
 
@@ -1246,7 +1246,7 @@ struct datatype *datatype_clone(const struct datatype *orig_dtype)
 	*dtype = *orig_dtype;
 	dtype->name = xstrdup(orig_dtype->name);
 	dtype->desc = xstrdup(orig_dtype->desc);
-	dtype->flags = DTYPE_F_ALLOC | orig_dtype->flags;
+	dtype->f_alloc = true;
 	dtype->refcnt = 1;
 
 	return dtype;
@@ -1258,10 +1258,9 @@ void datatype_free(const struct datatype *ptr)
 
 	if (!dtype)
 		return;
-	if (!(dtype->flags & DTYPE_F_ALLOC))
-		return;
 
-	assert(dtype->refcnt != 0);
+	if (!dtype->f_alloc)
+		return;
 
 	if (--dtype->refcnt > 0)
 		return;
diff --git a/src/meta.c b/src/meta.c
index b578d5e24c06..536954a7f9eb 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -367,7 +367,7 @@ const struct datatype devgroup_type = {
 	.print		= devgroup_type_print,
 	.json		= devgroup_type_json,
 	.parse		= devgroup_type_parse,
-	.flags		= DTYPE_F_PREFIX,
+	.f_prefix	= true,
 };
 
 const struct datatype ifname_type = {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e21451044451..9dc1ffa533d4 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2567,7 +2567,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 		default:
 			break;
 		}
-	} else if (binop->left->dtype->flags & DTYPE_F_PREFIX &&
+	} else if (binop->left->dtype->f_prefix &&
 		   binop->op == OP_AND && expr->right->etype == EXPR_VALUE &&
 		   expr_mask_is_prefix(binop->right)) {
 		expr->left = expr_get(binop->left);
diff --git a/src/rt.c b/src/rt.c
index f5c80559ffee..63939c23604c 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -54,7 +54,7 @@ const struct datatype realm_type = {
 	.basetype	= &integer_type,
 	.print		= realm_type_print,
 	.parse		= realm_type_parse,
-	.flags		= DTYPE_F_PREFIX,
+	.f_prefix	= true,
 };
 
 const struct rt_template rt_templates[] = {
diff --git a/src/segtree.c b/src/segtree.c
index 28172b30c5b3..768d27b8188c 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -401,8 +401,7 @@ void concat_range_aggregate(struct expr *set)
 				goto next;
 			}
 
-			if (prefix_len < 0 ||
-			    !(r1->dtype->flags & DTYPE_F_PREFIX)) {
+			if (prefix_len < 0 || !r1->dtype->f_prefix) {
 				tmp = range_expr_alloc(&r1->location, r1,
 						       r2);
 
@@ -517,7 +516,7 @@ add_interval(struct expr *set, struct expr *low, struct expr *i)
 		expr = expr_get(low);
 	} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
 
-		if (i->dtype->flags & DTYPE_F_PREFIX)
+		if (i->dtype->f_prefix)
 			expr = interval_to_prefix(low, i, range);
 		else if (expr_basetype(i)->type == TYPE_STRING)
 			expr = interval_to_string(low, i, range);
-- 
2.41.0

