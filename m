Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FC9CE79D2
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 13:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbjITNRH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbjITNRE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 09:17:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7465AB
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 06:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695215768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ov0N/QTE3y0/FaPvGUIAAYHO9k6cJiegp5gdms/iK7Q=;
        b=dxN3p9jQVQ3A1nbgpb62/J15sS3AFnluOHKCcExs/nX1KQmGbdnn0dIA5YiZV7Yc5oMn2a
        0TnI0wcWgBaykZkbUbS9r7iMXqZeNUV9jLfWg0CaelzhgXVbAr/s0P075kG6x+Hus4O9Bs
        WLUYYxgk1AYkA7AvjBkX46MSO411wgc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-3xgug713N9ao9XjOCecjtw-1; Wed, 20 Sep 2023 09:16:07 -0400
X-MC-Unique: 3xgug713N9ao9XjOCecjtw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7191185A797
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:16:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 55F62C15BB8;
        Wed, 20 Sep 2023 13:16:06 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/4] gmputil: add nft_gmp_free() to free strings from mpz_get_str()
Date:   Wed, 20 Sep 2023 15:13:39 +0200
Message-ID: <20230920131554.204899-3-thaller@redhat.com>
In-Reply-To: <20230920131554.204899-1-thaller@redhat.com>
References: <20230920131554.204899-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

mpz_get_str() (with NULL as first argument) will allocate a buffer using
the allocator functions (mp_set_memory_functions()). We should free
those buffers with the corresponding free function.

Add nft_gmp_free() for that and use it.

The name nft_gmp_free() is chosen because "mini-gmp.c" already has an
internal define called gmp_free(). There wouldn't be a direct conflict,
but using the same name is confusing. And maybe our own defines should
have a clear nft prefix.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/gmputil.h |  2 ++
 src/evaluate.c    |  6 +++---
 src/gmputil.c     | 21 ++++++++++++++++++++-
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/gmputil.h b/include/gmputil.h
index c524aced16ac..d1f4dcd2f1c3 100644
--- a/include/gmputil.h
+++ b/include/gmputil.h
@@ -77,4 +77,6 @@ extern void __mpz_switch_byteorder(mpz_t rop, unsigned int len);
 	__mpz_switch_byteorder(rop, len);			\
 }
 
+void nft_gmp_free(void *ptr);
+
 #endif /* NFTABLES_GMPUTIL_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 03586922848a..e5c7e03a927f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -401,7 +401,7 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 		expr_error(ctx->msgs, expr,
 			   "Value %s exceeds valid range 0-%u",
 			   valstr, ctx->ectx.maxval);
-		free(valstr);
+		nft_gmp_free(valstr);
 		return -1;
 	}
 
@@ -417,8 +417,8 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 		expr_error(ctx->msgs, expr,
 			   "Value %s exceeds valid range 0-%s",
 			   valstr, rangestr);
-		free(valstr);
-		free(rangestr);
+		nft_gmp_free(valstr);
+		nft_gmp_free(rangestr);
 		mpz_clear(mask);
 		return -1;
 	}
diff --git a/src/gmputil.c b/src/gmputil.c
index bf472c65de48..550c141294a3 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -185,7 +185,7 @@ int mpz_vfprintf(FILE *fp, const char *f, va_list args)
 
 			str = mpz_get_str(NULL, base, *value);
 			ok = str && fwrite(str, 1, len, fp) == len;
-			free(str);
+			nft_gmp_free(str);
 
 			if (!ok)
 				return -1;
@@ -197,3 +197,22 @@ int mpz_vfprintf(FILE *fp, const char *f, va_list args)
 	return n;
 }
 #endif
+
+void nft_gmp_free(void *ptr)
+{
+	void (*free_fcn)(void *, size_t);
+
+	/* When we get allocated memory from gmp, it was allocated via the
+	 * allocator() from mp_set_memory_functions(). We should pair the free
+	 * with the corresponding free function, which we get via
+	 * mp_get_memory_functions().
+	 *
+	 * It's not clear what the correct blk_size is. The default allocator
+	 * function of gmp just wraps free() and ignores the extra argument.
+	 * Assume 0 is fine.
+	 */
+
+	mp_get_memory_functions(NULL, NULL, &free_fcn);
+
+	(*free_fcn)(ptr, 0);
+}
-- 
2.41.0

