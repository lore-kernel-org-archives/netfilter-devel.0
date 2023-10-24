Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41CCC07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 10:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbjJXKBa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbjJXKB2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 06:01:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318F8133
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 03:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698141645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d58w+hutKHidShpPGigKAzq9yyumXoCk2L6mBT1F4DQ=;
        b=Gwd1gwW1Gs/pmM7iWKsNIrVWZkuMgijQh9eL+4vnJ4j7Ab+/Q51hhwVPZFP29kY2PmX9Z/
        0D17tMqbcCHiOOfQOjwuKtLrIbLabqDLs46qAtEJFndTmb58oWYxpw91s/oxXWcdsPmZ1e
        ICmhMd80cYFMEi2Ta/+3MP4s+3GWCqY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-c9kxlzC1OvWLVcYrGABnIg-1; Tue,
 24 Oct 2023 06:00:42 -0400
X-MC-Unique: c9kxlzC1OvWLVcYrGABnIg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5FF529AA3A5
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 10:00:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.225])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3261E1121318;
        Tue, 24 Oct 2023 10:00:42 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 2/4] gmputil: add nft_gmp_free() to free strings from mpz_get_str()
Date:   Tue, 24 Oct 2023 11:57:08 +0200
Message-ID: <20231024095820.1068949-3-thaller@redhat.com>
In-Reply-To: <20231024095820.1068949-1-thaller@redhat.com>
References: <20231024095820.1068949-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
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
index 2196e92813d0..9d5f0e4d94ad 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -400,7 +400,7 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 		expr_error(ctx->msgs, expr,
 			   "Value %s exceeds valid range 0-%u",
 			   valstr, ctx->ectx.maxval);
-		free(valstr);
+		nft_gmp_free(valstr);
 		return -1;
 	}
 
@@ -416,8 +416,8 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
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
index cb26b55810c2..b4529259b031 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -184,7 +184,7 @@ int mpz_vfprintf(FILE *fp, const char *f, va_list args)
 
 			str = mpz_get_str(NULL, base, *value);
 			ok = str && fwrite(str, 1, len, fp) == len;
-			free(str);
+			nft_gmp_free(str);
 
 			if (!ok)
 				return -1;
@@ -196,3 +196,22 @@ int mpz_vfprintf(FILE *fp, const char *f, va_list args)
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

