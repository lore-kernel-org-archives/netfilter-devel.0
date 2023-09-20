Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307C1CE79DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbjITObM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbjITObL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:31:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCBDCF
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695220217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y1gRsK228tgS3sBexv+qhPmJ/WL14/7rPGNWbW2S1nI=;
        b=a9ZgAHBeMywis5k2exNyKNAFbqvIXXfWQUzXatcSpvgDoo1HWbKDK+MFZrRqE0vyry2tct
        FXsoX+ehxllSVta0/R5fK9QZPn2coEiGqYAoJg4uggQ1/srQUz3GF1IlkAX5/seHjOsh6i
        2rbK2c7JBHIN5t+OI5We6xWwvqDEwqY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-P_9vRtxBPqitR4RydHt7Mg-1; Wed, 20 Sep 2023 10:30:13 -0400
X-MC-Unique: P_9vRtxBPqitR4RydHt7Mg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C89C9101AA6F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 14:30:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 257F31006B72;
        Wed, 20 Sep 2023 14:30:12 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/9] datatype: drop flags field from datatype
Date:   Wed, 20 Sep 2023 16:26:04 +0200
Message-ID: <20230920142958.566615-4-thaller@redhat.com>
In-Reply-To: <20230920142958.566615-1-thaller@redhat.com>
References: <20230920142958.566615-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Flags are not always bad. For example, as a function argument they allow
easier extension in the future. But with datatype's "flags" argument and
enum datatype_flags there are no advantages of this approach.

- replace DTYPE_F_PREFIX with a "bool f_prefix" field. This could even
  be a bool:1 bitfield if we cared to represent the information with
  one bit only. For now it's not done because that would not help reducing
  the size of the struct, so a bitfield is less preferable.

- instead of DTYPE_F_ALLOC, use the refcnt of zero to represent static
  instances. Drop this redundant flag.

- move the integer field "refcnt" in struct datatype beside other fields
  of similar size/alignment. This makes the size of the struct by one
  pointer size smaller (on x86-64).

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h        | 24 +++++++++---------------
 src/datatype.c            | 20 ++++++++------------
 src/meta.c                |  2 +-
 src/netlink_delinearize.c |  2 +-
 src/rt.c                  |  2 +-
 src/segtree.c             |  5 ++---
 6 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 52a2e943b252..5b85adc15857 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -120,24 +120,13 @@ enum byteorder {
 
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
  * @byteorder:	byteorder of type (non-basetypes only)
- * @flags:	flags
+ * @f_prefix:	preferred representation for ranges is a prefix
  * @size:	type size (fixed sized non-basetypes only)
  * @subtypes:	number of subtypes (concat type)
  * @name:	type name
@@ -147,14 +136,20 @@ struct parse_ctx;
  * @print:	function to print a constant of this type
  * @parse:	function to parse a symbol and return an expression
  * @sym_tbl:	symbol table for this type
- * @refcnt:	reference counter (only for DTYPE_F_ALLOC)
+ * @refcnt:	reference counter for dynamically allocated instances.
  */
 struct datatype {
 	uint32_t			type;
 	enum byteorder			byteorder;
-	unsigned int			flags;
+	bool				f_prefix;
 	unsigned int			size;
 	unsigned int			subtypes;
+
+	/* Refcount for dynamically allocated instances. For static instances
+	 * this is zero (get() and free() are NOPs).
+	 */
+	unsigned int			refcnt;
+
 	const char			*name;
 	const char			*desc;
 	const struct datatype		*basetype;
@@ -169,7 +164,6 @@ struct datatype {
 	struct error_record		*(*err)(const struct expr *sym);
 	void				(*describe)(struct output_ctx *octx);
 	const struct symbol_table	*sym_tbl;
-	unsigned int			refcnt;
 };
 
 extern const struct datatype *datatype_lookup(enum datatypes type);
diff --git a/src/datatype.c b/src/datatype.c
index 70c84846f70e..c5d88d9a90b6 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -641,7 +641,7 @@ const struct datatype ipaddr_type = {
 	.basetype	= &integer_type,
 	.print		= ipaddr_type_print,
 	.parse		= ipaddr_type_parse,
-	.flags		= DTYPE_F_PREFIX,
+	.f_prefix	= true,
 };
 
 static void ip6addr_type_print(const struct expr *expr, struct output_ctx *octx)
@@ -708,7 +708,7 @@ const struct datatype ip6addr_type = {
 	.basetype	= &integer_type,
 	.print		= ip6addr_type_print,
 	.parse		= ip6addr_type_parse,
-	.flags		= DTYPE_F_PREFIX,
+	.f_prefix	= true,
 };
 
 static void inet_protocol_type_print(const struct expr *expr,
@@ -944,7 +944,7 @@ const struct datatype mark_type = {
 	.print		= mark_type_print,
 	.json		= mark_type_json,
 	.parse		= mark_type_parse,
-	.flags		= DTYPE_F_PREFIX,
+	.f_prefix	= true,
 };
 
 static const struct symbol_table icmp_code_tbl = {
@@ -1203,9 +1203,7 @@ static struct datatype *datatype_alloc(void)
 	struct datatype *dtype;
 
 	dtype = xzalloc(sizeof(*dtype));
-	dtype->flags = DTYPE_F_ALLOC;
 	dtype->refcnt = 1;
-
 	return dtype;
 }
 
@@ -1215,10 +1213,10 @@ struct datatype *datatype_get(const struct datatype *ptr)
 
 	if (!dtype)
 		return NULL;
-	if (!(dtype->flags & DTYPE_F_ALLOC))
-		return dtype;
 
-	dtype->refcnt++;
+	if (dtype->refcnt > 0)
+		dtype->refcnt++;
+
 	return dtype;
 }
 
@@ -1245,7 +1243,6 @@ struct datatype *datatype_clone(const struct datatype *orig_dtype)
 	*dtype = *orig_dtype;
 	dtype->name = xstrdup(orig_dtype->name);
 	dtype->desc = xstrdup(orig_dtype->desc);
-	dtype->flags = DTYPE_F_ALLOC | orig_dtype->flags;
 	dtype->refcnt = 1;
 
 	return dtype;
@@ -1257,10 +1254,9 @@ void datatype_free(const struct datatype *ptr)
 
 	if (!dtype)
 		return;
-	if (!(dtype->flags & DTYPE_F_ALLOC))
-		return;
 
-	assert(dtype->refcnt != 0);
+	if (dtype->refcnt == 0)
+		return;
 
 	if (--dtype->refcnt > 0)
 		return;
diff --git a/src/meta.c b/src/meta.c
index 181e111cbbdc..7bf749b34fb4 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -368,7 +368,7 @@ const struct datatype devgroup_type = {
 	.print		= devgroup_type_print,
 	.json		= devgroup_type_json,
 	.parse		= devgroup_type_parse,
-	.flags		= DTYPE_F_PREFIX,
+	.f_prefix	= true,
 };
 
 const struct datatype ifname_type = {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 41cb37a3ccb3..f3939be2d063 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2568,7 +2568,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 		default:
 			break;
 		}
-	} else if (binop->left->dtype->flags & DTYPE_F_PREFIX &&
+	} else if (binop->left->dtype->f_prefix &&
 		   binop->op == OP_AND && expr->right->etype == EXPR_VALUE &&
 		   expr_mask_is_prefix(binop->right)) {
 		expr->left = expr_get(binop->left);
diff --git a/src/rt.c b/src/rt.c
index 9ddcb210eaad..ccea0aa9bc44 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -55,7 +55,7 @@ const struct datatype realm_type = {
 	.basetype	= &integer_type,
 	.print		= realm_type_print,
 	.parse		= realm_type_parse,
-	.flags		= DTYPE_F_PREFIX,
+	.f_prefix	= true,
 };
 
 const struct rt_template rt_templates[] = {
diff --git a/src/segtree.c b/src/segtree.c
index 0a12a0cd5151..637457b087b9 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -402,8 +402,7 @@ void concat_range_aggregate(struct expr *set)
 				goto next;
 			}
 
-			if (prefix_len < 0 ||
-			    !(r1->dtype->flags & DTYPE_F_PREFIX)) {
+			if (prefix_len < 0 || !r1->dtype->f_prefix) {
 				tmp = range_expr_alloc(&r1->location, r1,
 						       r2);
 
@@ -518,7 +517,7 @@ add_interval(struct expr *set, struct expr *low, struct expr *i)
 		expr = expr_get(low);
 	} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
 
-		if (i->dtype->flags & DTYPE_F_PREFIX)
+		if (i->dtype->f_prefix)
 			expr = interval_to_prefix(low, i, range);
 		else if (expr_basetype(i)->type == TYPE_STRING)
 			expr = interval_to_string(low, i, range);
-- 
2.41.0

