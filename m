Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80927CD5BA7
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 12:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjISMh1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 08:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjISMh1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 08:37:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E937BF4
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 05:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695126994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RkiiNNKaONBImU4sijC6PhrVvonVE1JO652cYgG5pog=;
        b=AfnQQZ6wfu4k5KlQJw7pf7Wzo3qMou8f9vmi16nbmDMAd1uUs1zh9GKQ6jPMpBg3aC/PQn
        IzuHm6kKJEtpPDaIAxqOrw27JsMlNfYG8NsV0yVIlXTIQPOWQe+CVUANLWTQmHHO47aX2l
        GrGSjd8+ko3cXGP0SgE3FNZuwJ0gfrk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-KKcjtNy_PfGUetEjWXmFbQ-1; Tue, 19 Sep 2023 08:36:32 -0400
X-MC-Unique: KKcjtNy_PfGUetEjWXmFbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67BA98039D1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 12:36:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB0E2140E950;
        Tue, 19 Sep 2023 12:36:31 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] libnftables: drop gmp_init() and mp_set_memory_functions()
Date:   Tue, 19 Sep 2023 14:36:16 +0200
Message-ID: <20230919123621.2770734-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Setting global handles for libgmp via mp_set_memory_functions() is very
ugly. When we don't use mini-gmp, then potentially there are other users
of the library in the same process, and every process fighting about the
allocation functions is not gonna work.

It also means, we must not reset the allocation functions after somebody
already allocated GMP data with them. Which we cannot ensure, as we
don't know what other parts of the process are doing.

It's also unnecessary. The default allocation functions for gmp and
mini-gmp already abort the process on allocation failure ([1], [2]),
just like our xmalloc().

Just don't do this.

[1] https://gmplib.org/repo/gmp/file/8225bdfc499f/memory.c#l37
[2] https://git.netfilter.org/nftables/tree/src/mini-gmp.c?id=6d19a902c1d77cb51b940b1ce65f31b1cad38b74#n286

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/nftables.h |  1 -
 src/gmputil.c      | 10 ----------
 src/libnftables.c  |  1 -
 3 files changed, 12 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index b9b2b01c2689..4b7c335928da 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -224,7 +224,6 @@ struct input_descriptor {
 
 void ct_label_table_init(struct nft_ctx *ctx);
 void mark_table_init(struct nft_ctx *ctx);
-void gmp_init(void);
 void realm_table_rt_init(struct nft_ctx *ctx);
 void devgroup_table_init(struct nft_ctx *ctx);
 void xt_init(void);
diff --git a/src/gmputil.c b/src/gmputil.c
index 7f65630db59c..bf472c65de48 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -197,13 +197,3 @@ int mpz_vfprintf(FILE *fp, const char *f, va_list args)
 	return n;
 }
 #endif
-
-static void *gmp_xrealloc(void *ptr, size_t old_size, size_t new_size)
-{
-	return xrealloc(ptr, new_size);
-}
-
-void gmp_init(void)
-{
-	mp_set_memory_functions(xmalloc, gmp_xrealloc, NULL);
-}
diff --git a/src/libnftables.c b/src/libnftables.c
index c5f5729409d1..c34ee43de1fa 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -196,7 +196,6 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 
 	if (!init_once) {
 		init_once = true;
-		gmp_init();
 #ifdef HAVE_LIBXTABLES
 		xt_init();
 #endif
-- 
2.41.0

