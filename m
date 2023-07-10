Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D01EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 08:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjGJIuc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 04:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjGJIuc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 04:50:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073ACC2
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 01:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688978985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oXIaX1O0IFKzqTncvzzGdCTCdOFoMs3wTIGXGAR88ro=;
        b=AfYMeMTEDH8NKdsYp3tF4qBZFwy/cKjKhs6gFhGk3ctfOY1NGr+HZtwCtRYULeAtyE/Bk2
        mz5DxQSgzwQphC7M+QhnhD77QYXi8AgHHreBVslv/CF7YW4VjZCuFILFxxZaEAYjNPgLqi
        aK2mYeU31DPhIylRW5RDSPLeAitQOT8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-jwdYrAUvMa-p89UbNv3JIQ-1; Mon, 10 Jul 2023 04:49:43 -0400
X-MC-Unique: jwdYrAUvMa-p89UbNv3JIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8B0E185A791
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 08:49:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F1D9111DCE1;
        Mon, 10 Jul 2023 08:49:43 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH 4/4] libnftables: drop check for nf_sock in nft_ctx_free()
Date:   Mon, 10 Jul 2023 10:45:19 +0200
Message-ID: <20230710084926.172198-5-thaller@redhat.com>
In-Reply-To: <20230710084926.172198-1-thaller@redhat.com>
References: <20230710084926.172198-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The "nft_ctx" API does not provide a way to change or reconnect the
netlink socket. And none of the users would rely on that.

Also note that nft_ctx_new() initializes nf_sock via
nft_mnl_socket_open(), which panics of the socket could not be
initialized.

This means, the check is unnecessary and needlessly confusing. Drop it.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/libnftables.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 79dfdfc7c6ec..6fc4f7db6760 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -337,8 +337,7 @@ const char *nft_ctx_get_error_buffer(struct nft_ctx *ctx)
 EXPORT_SYMBOL(nft_ctx_free);
 void nft_ctx_free(struct nft_ctx *ctx)
 {
-	if (ctx->nf_sock)
-		mnl_socket_close(ctx->nf_sock);
+	mnl_socket_close(ctx->nf_sock);
 
 	exit_cookie(&ctx->output.output_cookie);
 	exit_cookie(&ctx->output.error_cookie);
-- 
2.41.0

