Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D96EE80A9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 07:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjI0HAs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 03:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjI0HAp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 03:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52067F4
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 23:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695797996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=v6dnMZjO1ENV3UksDNNMjfIaZ15e0O/oF1yHtMci+yg=;
        b=FbrnI90bkp/00MEE1sSP322xQ6FDOB1g7EwujiLklVJ0iwJ8V3zrOvpm53BIK3N5cSnQW/
        T/rxx7oAJk4dauVVy20x906SnT7tloXjGurP+1/qV7dUYG8CjvYyh6u27cpqcQsekYzTSK
        RMBWtkyolT5k+eO3hncSkEULIRGa+QI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-tzY_8N9oNrO_mzPhF4Qjxg-1; Wed, 27 Sep 2023 02:59:53 -0400
X-MC-Unique: tzY_8N9oNrO_mzPhF4Qjxg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FBFE1C00BA8
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 06:59:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CF4B2026D4B;
        Wed, 27 Sep 2023 06:59:51 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft] mergesort: avoid cloning value in expr_msort_cmp()
Date:   Wed, 27 Sep 2023 08:59:34 +0200
Message-ID: <20230927065941.1386475-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If we have a plain EXPR_VALUE value, there is no need to copy
it via mpz_set().

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/mergesort.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/src/mergesort.c b/src/mergesort.c
index 5965236af6b7..af7f163b2779 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -12,8 +12,6 @@
 #include <gmputil.h>
 #include <list.h>
 
-static void expr_msort_value(const struct expr *expr, mpz_t value);
-
 static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
 {
 	unsigned int len = 0, ilen;
@@ -29,20 +27,20 @@ static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
 	mpz_import_data(value, data, BYTEORDER_HOST_ENDIAN, len);
 }
 
-static void expr_msort_value(const struct expr *expr, mpz_t value)
+static mpz_srcptr expr_msort_value(const struct expr *expr, mpz_t value)
 {
+recursive_again:
 	switch (expr->etype) {
 	case EXPR_SET_ELEM:
-		expr_msort_value(expr->key, value);
-		break;
+		expr = expr->key;
+		goto recursive_again;
 	case EXPR_BINOP:
 	case EXPR_MAPPING:
 	case EXPR_RANGE:
-		expr_msort_value(expr->left, value);
-		break;
+		expr = expr->left;
+		goto recursive_again;
 	case EXPR_VALUE:
-		mpz_set(value, expr->value);
-		break;
+		return expr->value;
 	case EXPR_CONCAT:
 		concat_expr_msort_value(expr, value);
 		break;
@@ -53,20 +51,24 @@ static void expr_msort_value(const struct expr *expr, mpz_t value)
 	default:
 		BUG("Unknown expression %s\n", expr_name(expr));
 	}
+	return value;
 }
 
 static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
 {
-	mpz_t value1, value2;
+	mpz_srcptr value1;
+	mpz_srcptr value2;
+	mpz_t value1_tmp;
+	mpz_t value2_tmp;
 	int ret;
 
-	mpz_init(value1);
-	mpz_init(value2);
-	expr_msort_value(e1, value1);
-	expr_msort_value(e2, value2);
+	mpz_init(value1_tmp);
+	mpz_init(value2_tmp);
+	value1 = expr_msort_value(e1, value1_tmp);
+	value2 = expr_msort_value(e2, value2_tmp);
 	ret = mpz_cmp(value1, value2);
-	mpz_clear(value1);
-	mpz_clear(value2);
+	mpz_clear(value1_tmp);
+	mpz_clear(value2_tmp);
 
 	return ret;
 }
-- 
2.41.0

