Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A80C71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbjH2M7k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 08:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjH2M7J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 08:59:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7141BB
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 05:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693313905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r4FqclF+2Zr14MxWUD9X3Au9d5XTp0rWqlb5MlKDTjs=;
        b=YeMgvRERiGp9dxdfS/lJaGNbRC0Gu/VcwySCJY7A1meFw8QmGOkCuNnII50GCyhgh6tAcd
        R5SeCPwJZy/DlBMN4R2XijiomP4JrgMU6LSdCmQS3dq+YI728UCLoVvyyh0UaHvQe9TAj3
        nDqrGKNHiicjShVOEEFQqQy08ZT3XLs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-687-shmBNTvKNaqMbH787EzbFQ-1; Tue, 29 Aug 2023 08:58:24 -0400
X-MC-Unique: shmBNTvKNaqMbH787EzbFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 161D8185A791
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 12:58:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 893CF40C2063;
        Tue, 29 Aug 2023 12:58:23 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 5/8] src: rework SNPRINTF_BUFFER_SIZE() and handle truncation
Date:   Tue, 29 Aug 2023 14:53:34 +0200
Message-ID: <20230829125809.232318-6-thaller@redhat.com>
In-Reply-To: <20230829125809.232318-1-thaller@redhat.com>
References: <20230829125809.232318-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before, the macro asserts against truncation. This is despite the
callers still checked for truncation and tried to handle it. Probably
for good reason. With stmt_evaluate_log_prefix() it's not clear that the
code ensures that truncation cannot happen, so we must not assert
against it, but handle it.

Also,

- wrap the macro in "do { ... } while(0)" to make it more
  function-like.

- evaluate macro arguments exactly once, to make it more function-like.

- take pointers to the arguments that are being modified.

- use assert() instead of abort().

- use size_t type for arguments related to the buffer size.

- drop "size". It was mostly redundant to "offset". We can know
  everything we want based on "len" and "offset" alone.

- "offset" previously was incremented before checking for truncation.
  So it would point somewhere past the buffer. This behavior does not
  seem useful. Instead, on truncation "len" will be zero (as before) and
  "offset" will point one past the buffer (one past the terminating
  NUL).

Thereby, also fix a warning from clang:

    evaluate.c:4134:9: error: variable 'size' set but not used [-Werror,-Wunused-but-set-variable]
            size_t size = 0;
                   ^

    meta.c:1006:9: error: variable 'size' set but not used [-Werror,-Wunused-but-set-variable]
            size_t size;
                   ^

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/utils.h | 35 ++++++++++++++++++++++++++---------
 src/evaluate.c  |  8 +++++---
 src/meta.c      | 11 ++++++-----
 3 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index cee1e5c1e8ae..efc8dec013a1 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -72,15 +72,32 @@
 #define max(_x, _y) ({				\
 	_x > _y ? _x : _y; })
 
-#define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
-	if (ret < 0)					\
-		abort();				\
-	offset += ret;					\
-	assert(ret < len);				\
-	if (ret > len)					\
-		ret = len;				\
-	size += ret;					\
-	len -= ret;
+#define SNPRINTF_BUFFER_SIZE(ret, len, offset)			\
+	({ \
+		const int _ret = (ret);				\
+		size_t *const _len = (len);			\
+		size_t *const _offset = (offset);		\
+		bool _not_truncated = true;			\
+		size_t _ret2;					\
+								\
+		assert(_ret >= 0);				\
+								\
+		if ((size_t) _ret >= *_len) {			\
+			/* Truncated.
+			 *
+			 * We will leave "len" at zero and increment
+			 * "offset" to point one byte after the buffer
+			 * (after the terminating NUL byte). */	\
+			_ret2 = *_len;				\
+			_not_truncated = false;			\
+		} else						\
+			_ret2 = (size_t) _ret;			\
+								\
+		*_offset += _ret2;				\
+		*_len -= _ret2;					\
+								\
+		_not_truncated;					\
+	})
 
 #define MSEC_PER_SEC	1000L
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 77e3838e2692..71e94a51cc2f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4129,14 +4129,16 @@ static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	char prefix[NF_LOG_PREFIXLEN] = {}, tmp[NF_LOG_PREFIXLEN] = {};
-	int len = sizeof(prefix), offset = 0, ret;
+	size_t len = sizeof(prefix);
+	size_t offset = 0;
 	struct expr *expr;
-	size_t size = 0;
 
 	if (stmt->log.prefix->etype != EXPR_LIST)
 		return 0;
 
 	list_for_each_entry(expr, &stmt->log.prefix->expressions, list) {
+		int ret;
+
 		switch (expr->etype) {
 		case EXPR_VALUE:
 			expr_to_string(expr, tmp);
@@ -4150,7 +4152,7 @@ static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
 			BUG("unknown expression type %s\n", expr_name(expr));
 			break;
 		}
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, &len, &offset);
 	}
 
 	if (len == 0)
diff --git a/src/meta.c b/src/meta.c
index 4f383269d032..ea00f2396b99 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -999,11 +999,11 @@ struct error_record *meta_key_parse(const struct location *loc,
                                     const char *str,
                                     unsigned int *value)
 {
-	int ret, len, offset = 0;
 	const char *sep = "";
+	size_t offset = 0;
 	unsigned int i;
 	char buf[1024];
-	size_t size;
+	size_t len;
 
 	for (i = 0; i < array_size(meta_templates); i++) {
 		if (!meta_templates[i].token || strcmp(meta_templates[i].token, str))
@@ -1026,9 +1026,10 @@ struct error_record *meta_key_parse(const struct location *loc,
 	}
 
 	len = (int)sizeof(buf);
-	size = sizeof(buf);
 
 	for (i = 0; i < array_size(meta_templates); i++) {
+		int ret;
+
 		if (!meta_templates[i].token)
 			continue;
 
@@ -1036,8 +1037,8 @@ struct error_record *meta_key_parse(const struct location *loc,
 			sep = ", ";
 
 		ret = snprintf(buf+offset, len, "%s%s", sep, meta_templates[i].token);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		assert(offset < (int)sizeof(buf));
+		SNPRINTF_BUFFER_SIZE(ret, &len, &offset);
+		assert(len > 0);
 	}
 
 	return error(loc, "syntax error, unexpected %s, known keys are %s", str, buf);
-- 
2.41.0

