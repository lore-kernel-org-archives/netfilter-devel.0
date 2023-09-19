Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A39CD5BAA
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 12:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjISMh2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 08:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjISMh1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 08:37:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EF2F9
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 05:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695126994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Nt2TkMGWgsvue9TIowbmEiv/9XCMVDMpxt1fYuNUt8=;
        b=T/6cRmYD85B18cHg77aM8mDRVOOvanpMm9oRSAVlyoaOVednv4S4Ad7zmScJ0vIpKRPgWh
        GKAloLYY9Olh4TenDiS9wUM0GKbB6XGSxTDx36J4q+4z9vGTHsO2lFQ6p6hLDlunqAzPgL
        wYzsnVhmNU/JdY4qFJT5ZQPfxSazmq8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-of5VaFWTNHGubNOvGzjrmg-1; Tue, 19 Sep 2023 08:36:33 -0400
X-MC-Unique: of5VaFWTNHGubNOvGzjrmg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F44F800969
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 12:36:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A24B2140E950;
        Tue, 19 Sep 2023 12:36:32 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] libnftables: move init-once guard inside xt_init()
Date:   Tue, 19 Sep 2023 14:36:17 +0200
Message-ID: <20230919123621.2770734-2-thaller@redhat.com>
In-Reply-To: <20230919123621.2770734-1-thaller@redhat.com>
References: <20230919123621.2770734-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A library should not restrict being used by multiple threads or make
assumptions about how it's being used. Hence a "init_once" pattern
without no locking is racy, a code smell and should be avoided.

Note that libxtables is full of global variables and when linking against
it, libnftables cannot be used from multiple threads either. That is not
easy to fix.

Move the ugliness of "init_once" away from nft_ctx_new(), so that the
problem is concentrated closer to libxtables.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/libnftables.c |  6 +-----
 src/xt.c          | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index c34ee43de1fa..ed6b7fb5554c 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -191,15 +191,11 @@ void nft_ctx_clear_include_paths(struct nft_ctx *ctx)
 EXPORT_SYMBOL(nft_ctx_new);
 struct nft_ctx *nft_ctx_new(uint32_t flags)
 {
-	static bool init_once;
 	struct nft_ctx *ctx;
 
-	if (!init_once) {
-		init_once = true;
 #ifdef HAVE_LIBXTABLES
-		xt_init();
+	xt_init();
 #endif
-	}
 
 	ctx = xzalloc(sizeof(struct nft_ctx));
 	nft_init(ctx);
diff --git a/src/xt.c b/src/xt.c
index d774e07395a6..bb87e86e02af 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -361,7 +361,18 @@ static struct xtables_globals xt_nft_globals = {
 
 void xt_init(void)
 {
-	/* Default to IPv4, but this changes in runtime */
-	xtables_init_all(&xt_nft_globals, NFPROTO_IPV4);
+	static bool init_once;
+
+	if (!init_once) {
+		/* libxtables is full of global variables and cannot be used
+		 * concurrently by multiple threads. Hence, it's fine that the
+		 * "init_once" guard is not thread-safe either.
+		 * Don't link against xtables if you want thread safety.
+		 */
+		init_once = true;
+
+		/* Default to IPv4, but this changes in runtime */
+		xtables_init_all(&xt_nft_globals, NFPROTO_IPV4);
+	}
 }
 #endif
-- 
2.41.0

