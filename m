Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67354E82CCC
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 20:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjI0UCu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 16:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjI0UCu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 16:02:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF1B122
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695844927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PGujRVaYXUH8BO+fgPtArbje9h1B90yQx8nGGxueSdQ=;
        b=Xex6PFW0v5kl2i9OaEYEGqlXCl0I5tJEbf3TbVRsweAgK7RRtprIXzMvVyaW/JWPyuTfDq
        HX952++mJ0gCw8Kdoq62mDFeZiNuYaNwd/vU6JBrFtMeVWivNRL4swzVLC8NSW0pHcL3QV
        5jLHYVluGnznkXH6fTp2CX2CCwSCq5U=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-aLyWzfMuPaqTs2ZDxVesFg-1; Wed, 27 Sep 2023 16:01:58 -0400
X-MC-Unique: aLyWzfMuPaqTs2ZDxVesFg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A6EA29AA2F0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 20:01:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED8D740C6EA8;
        Wed, 27 Sep 2023 20:01:57 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 4/5] datatype: extend set_datatype_alloc() to change size
Date:   Wed, 27 Sep 2023 21:57:27 +0200
Message-ID: <20230927200143.3798124-5-thaller@redhat.com>
In-Reply-To: <20230927200143.3798124-1-thaller@redhat.com>
References: <20230927200143.3798124-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All remaining users of datatype_clone() only use this function to set
the byteorder and the size. Extend set_datatype_alloc() to not only
change the byteorder but also the size. With that, it can be used
instead of clone.

The benefit is that set_datatype_alloc() takes care to re-use the same
instance, if the values end up being the same.

Another benefit is to expose and make clear the oddity related to the
"for_any_integer" argument. The argument exists to preserve the previous
behavior.  However, it's not clear why some places would only want to
change the values for &integer_type and some check for orig_dtype->type
== TYPE_INTEGER. This is possibly a bug, especially because it means
once you clone an &integer_type, you cannot change it's byteorder/size
again.  So &integer_type is very special here, not only based on the
TYPE_INTEGER.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h |  5 ++++-
 src/datatype.c     | 21 ++++++++++++++++-----
 src/evaluate.c     | 26 ++++++++++++--------------
 src/netlink.c      |  4 ++--
 src/payload.c      |  7 +++----
 5 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 465ade290652..f01e15b6ff3e 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -301,7 +301,10 @@ concat_subtype_lookup(uint32_t type, unsigned int n)
 }
 
 extern const struct datatype *
-set_datatype_alloc(const struct datatype *orig_dtype, enum byteorder byteorder);
+set_datatype_alloc(const struct datatype *orig_dtype,
+		   bool for_any_integer,
+		   enum byteorder byteorder,
+		   unsigned int size);
 
 extern void time_print(uint64_t msec, struct output_ctx *octx);
 extern struct error_record *time_parse(const struct location *loc,
diff --git a/src/datatype.c b/src/datatype.c
index 6a35c6a76028..f9570603467a 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1313,21 +1313,32 @@ const struct datatype *concat_type_alloc(uint32_t type)
 }
 
 const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
-					  enum byteorder byteorder)
+					  bool for_any_integer,
+					  enum byteorder byteorder,
+					  unsigned int size)
 {
 	struct datatype *dtype;
 
-	/* Restrict dynamic datatype allocation to generic integer datatype. */
-	if (orig_dtype != &integer_type)
-		return datatype_get(orig_dtype);
+	if (for_any_integer) {
+		if (orig_dtype->type != TYPE_INTEGER) {
+			/* Restrict changing byteorder/size to any integer datatype. */
+			return datatype_get(orig_dtype);
+		}
+	} else {
+		if (orig_dtype != &integer_type) {
+			/* Restrict changing byteorder/size to the generic integer datatype. */
+			return datatype_get(orig_dtype);
+		}
+	}
 
-	if (orig_dtype->byteorder == byteorder) {
+	if (orig_dtype->byteorder == byteorder && orig_dtype->size == size) {
 		/* The (immutable) type instance is already as requested. */
 		return datatype_get(orig_dtype);
 	}
 
 	dtype = datatype_clone(orig_dtype);
 	dtype->byteorder = byteorder;
+	dtype->size = size;
 	return dtype;
 }
 
diff --git a/src/evaluate.c b/src/evaluate.c
index e84895bf1610..a118aa6a7209 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -89,7 +89,8 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	if (set_is_datamap(expr->set_flags)) {
 		const struct datatype *dtype;
 
-		dtype = set_datatype_alloc(key->dtype, key->byteorder);
+		dtype = set_datatype_alloc(key->dtype, false, key->byteorder,
+					   key->dtype->size);
 		__datatype_set(key, dtype);
 	}
 
@@ -1508,13 +1509,12 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 			return -1;
 		flags &= i->flags;
 
-		if (!key && i->dtype->type == TYPE_INTEGER) {
-			struct datatype *clone;
+		if (!key) {
+			const struct datatype *dtype;
 
-			clone = datatype_clone(i->dtype);
-			clone->size = i->len;
-			clone->byteorder = i->byteorder;
-			__datatype_set(i, clone);
+			dtype = set_datatype_alloc(i->dtype, true,
+						   i->byteorder, i->len);
+			__datatype_set(i, dtype);
 		}
 
 		if (dtype == NULL && i->dtype->size == 0)
@@ -1933,7 +1933,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		} else {
 			const struct datatype *dtype;
 
-			dtype = set_datatype_alloc(ectx.dtype, ectx.byteorder);
+			dtype = set_datatype_alloc(ectx.dtype, false, ectx.byteorder, ectx.dtype->size);
 			data = constant_expr_alloc(&netlink_location, dtype,
 						   dtype->byteorder, ectx.len, NULL);
 			datatype_free(dtype);
@@ -4553,13 +4553,11 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 			return expr_error(ctx->msgs, i,
 					  "specify either ip or ip6 for address matching");
 
-		if (i->etype == EXPR_PAYLOAD &&
-		    i->dtype->type == TYPE_INTEGER) {
-			struct datatype *dtype;
+		if (i->etype == EXPR_PAYLOAD) {
+			const struct datatype *dtype;
 
-			dtype = datatype_clone(i->dtype);
-			dtype->size = i->len;
-			dtype->byteorder = i->byteorder;
+			dtype = set_datatype_alloc(i->dtype, true,
+						   i->byteorder, i->len);
 			__datatype_set(i, dtype);
 		}
 
diff --git a/src/netlink.c b/src/netlink.c
index 120a8ba9ceb1..9fe870885e2e 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1034,7 +1034,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	if (datatype) {
 		uint32_t dlen;
 
-		dtype2 = set_datatype_alloc(datatype, databyteorder);
+		dtype2 = set_datatype_alloc(datatype, false, databyteorder, datatype->size);
 		klen = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN) * BITS_PER_BYTE;
 
 		dlen = data_interval ?  klen / 2 : klen;
@@ -1058,7 +1058,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 			set->data->flags |= EXPR_F_INTERVAL;
 	}
 
-	dtype = set_datatype_alloc(keytype, keybyteorder);
+	dtype = set_datatype_alloc(keytype, false, keybyteorder, keytype->size);
 	klen = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
 
 	if (set_udata_key_valid(typeof_expr_key, klen)) {
diff --git a/src/payload.c b/src/payload.c
index 89bb38eb0099..55e075dab033 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -243,15 +243,14 @@ static struct expr *payload_expr_parse_udata(const struct nftnl_udata *attr)
 		expr->len = len;
 
 	if (is_raw) {
-		struct datatype *dtype;
+		const struct datatype *dtype;
 
 		expr->payload.base = base;
 		expr->payload.offset = offset;
 		expr->payload.is_raw = true;
 		expr->len = len;
-		dtype = datatype_clone(&xinteger_type);
-		dtype->size = len;
-		dtype->byteorder = BYTEORDER_BIG_ENDIAN;
+		dtype = set_datatype_alloc(&xinteger_type, true,
+					   BYTEORDER_BIG_ENDIAN, len);
 		__datatype_set(expr, dtype);
 	}
 
-- 
2.41.0

