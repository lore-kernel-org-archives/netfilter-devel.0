Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5B8EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 08:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjGJIu0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 04:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjGJIuZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 04:50:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C26C9
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 01:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688978982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OK0uAo7umktdZG9O79OgHnOcfRwsE+t/lZ9yR//6fVA=;
        b=AgT71w+c2a85DnckONsGCS6vGLxo2QXGp2nQJkqxPv/nuKNrIMaVLZXN0SRsWZAt5tnQbs
        +fT1yBH82HWDD0QVU3SWVwDQvA/BvFAm0r1g1hluZ+BcGhDR0/KjVgX1IegCbUVvn9uwBg
        CaivO6qbfZ9TzDKFTrIgdpiuHrmlDRg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-zGrQzYQhO9ent6TZ8i61bg-1; Mon, 10 Jul 2023 04:49:41 -0400
X-MC-Unique: zGrQzYQhO9ent6TZ8i61bg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5658800B35
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 08:49:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AFDF111DCE1;
        Mon, 10 Jul 2023 08:49:40 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH 1/4] libnftables: always initialize netlink socket in nft_ctx_new()
Date:   Mon, 10 Jul 2023 10:45:16 +0200
Message-ID: <20230710084926.172198-2-thaller@redhat.com>
In-Reply-To: <20230710084926.172198-1-thaller@redhat.com>
References: <20230710084926.172198-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_ctx_new() has a flags argument, but currently no flags are
supported. The documentation suggests to pass 0 (NFT_CTX_DEFAULT).

Initializing the netlink socket happens by default already, we should do
it for all flags. Also because  nft_ctx_netlink_init() is not public
API so it's not clear how the user gets a functioning context instance
otherwise.

If we ever want to not initialize the netlink socket for a context
instance, then there should be a dedicated flag for doing that (and
additional API for making that mode of operation usable).

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/libnftables.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index de16d203a017..57e0fc77f989 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -219,8 +219,7 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	ctx->output.error_fp = stderr;
 	init_list_head(&ctx->vars_ctx.indesc_list);
 
-	if (flags == NFT_CTX_DEFAULT)
-		nft_ctx_netlink_init(ctx);
+	nft_ctx_netlink_init(ctx);
 
 	return ctx;
 }
-- 
2.41.0

