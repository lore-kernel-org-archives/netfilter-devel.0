Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF6BEEB562
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 17:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbjIHRgK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 13:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjIHRgK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 13:36:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4BC1FC9
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 10:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694194518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TNASUlVLJ+qy7b5OSaLH0NMvSrhoxHIkUH7nTFyJVGI=;
        b=X3tXVXVekc35Y32iyr3VFHcynQGU8JNi8iumu8m/f0UqvVIY3wnWXLS3mATNfYA8K+NTrX
        EugJgFfZpMGQrT14cpzYF61V6XlBjIjhA6y5n6SEGMcwmnswa9emkQDd0db2ziElFkTbgH
        7Dq5z4BlN4YMFE41qNj187Zk7rsTdgE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-KAipgeL8MbKsPBV8KvGlnQ-1; Fri, 08 Sep 2023 13:35:17 -0400
X-MC-Unique: KAipgeL8MbKsPBV8KvGlnQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AE711C08977
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 17:35:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 780A6400F5F;
        Fri,  8 Sep 2023 17:35:16 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] datatype: rename "dtype_clone()" to datatype_clone()
Date:   Fri,  8 Sep 2023 19:34:47 +0200
Message-ID: <20230908173505.1182605-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The struct is called "datatype" and related functions have the fitting
"datatype_" prefix. Rename.

Also rename the internal "dtype_alloc()" to "datatype_alloc()".

This is a follow up to commit 01a13882bb59 ('src: add reference counter
for dynamic datatypes'), which started adding "datatype_*()" functions.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h | 2 +-
 src/datatype.c     | 8 ++++----
 src/evaluate.c     | 4 ++--
 src/payload.c      | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 9ce7359cd340..6146eda1d2ec 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -177,7 +177,7 @@ extern const struct datatype *datatype_lookup_byname(const char *name);
 extern struct datatype *datatype_get(const struct datatype *dtype);
 extern void datatype_set(struct expr *expr, const struct datatype *dtype);
 extern void datatype_free(const struct datatype *dtype);
-struct datatype *dtype_clone(const struct datatype *orig_dtype);
+struct datatype *datatype_clone(const struct datatype *orig_dtype);
 
 struct parse_ctx {
 	struct symbol_tables	*tbl;
diff --git a/src/datatype.c b/src/datatype.c
index eff9fa53e354..678a16b1f3af 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1198,7 +1198,7 @@ static struct error_record *concat_type_parse(struct parse_ctx *ctx,
 		     sym->dtype->desc);
 }
 
-static struct datatype *dtype_alloc(void)
+static struct datatype *datatype_alloc(void)
 {
 	struct datatype *dtype;
 
@@ -1229,7 +1229,7 @@ void datatype_set(struct expr *expr, const struct datatype *dtype)
 	expr->dtype = datatype_get(dtype);
 }
 
-struct datatype *dtype_clone(const struct datatype *orig_dtype)
+struct datatype *datatype_clone(const struct datatype *orig_dtype)
 {
 	struct datatype *dtype;
 
@@ -1285,7 +1285,7 @@ const struct datatype *concat_type_alloc(uint32_t type)
 	}
 	strncat(desc, ")", sizeof(desc) - strlen(desc) - 1);
 
-	dtype		= dtype_alloc();
+	dtype		= datatype_alloc();
 	dtype->type	= type;
 	dtype->size	= size;
 	dtype->subtypes = subtypes;
@@ -1305,7 +1305,7 @@ const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
 	if (orig_dtype != &integer_type)
 		return orig_dtype;
 
-	dtype = dtype_clone(orig_dtype);
+	dtype = datatype_clone(orig_dtype);
 	dtype->byteorder = byteorder;
 
 	return dtype;
diff --git a/src/evaluate.c b/src/evaluate.c
index 8d53994a8f18..b0c6919f600a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1518,7 +1518,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		if (!key && i->dtype->type == TYPE_INTEGER) {
 			struct datatype *clone;
 
-			clone = dtype_clone(i->dtype);
+			clone = datatype_clone(i->dtype);
 			clone->size = i->len;
 			clone->byteorder = i->byteorder;
 			clone->refcnt = 1;
@@ -4546,7 +4546,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		    i->dtype->type == TYPE_INTEGER) {
 			struct datatype *dtype;
 
-			dtype = dtype_clone(i->dtype);
+			dtype = datatype_clone(i->dtype);
 			dtype->size = i->len;
 			dtype->byteorder = i->byteorder;
 			dtype->refcnt = 1;
diff --git a/src/payload.c b/src/payload.c
index c8faea99eb07..dcd87485c068 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -250,7 +250,7 @@ static struct expr *payload_expr_parse_udata(const struct nftnl_udata *attr)
 		expr->payload.offset = offset;
 		expr->payload.is_raw = true;
 		expr->len = len;
-		dtype = dtype_clone(&xinteger_type);
+		dtype = datatype_clone(&xinteger_type);
 		dtype->size = len;
 		dtype->byteorder = BYTEORDER_BIG_ENDIAN;
 		dtype->refcnt = 1;
-- 
2.41.0

