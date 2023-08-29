Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3285C71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjH2NAL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 09:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbjH2M76 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 08:59:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06BC1BD
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 05:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693313907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pZdzI8OrS2Hjao1GfLBIVYRYk8Mi/f6x/grUOT1rTSY=;
        b=UJAvMTSN6d2mYREHSvfjNMYoMYNVSHVYvzavJ/pVxXn/hMZcLqOQwIkU44wri6hBkp1mmf
        QCvrCM/JALnPrqCnp1zEy7Z+TQxhiGU9tH9WGdK2u82+JKqZwN4I3y8jsDxWCLzJPBaUvh
        +tHAxAWKyOOiaXRAgS5efFNzMARnHqI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-49QE5EjKPPq3W1B2Tqz1wA-1; Tue, 29 Aug 2023 08:58:26 -0400
X-MC-Unique: 49QE5EjKPPq3W1B2Tqz1wA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7A03858EED
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 12:58:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 195FD40C2063;
        Tue, 29 Aug 2023 12:58:24 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 7/8] src: suppress "-Wunused-but-set-variable" warning with "parser_bison.c"
Date:   Tue, 29 Aug 2023 14:53:36 +0200
Message-ID: <20230829125809.232318-8-thaller@redhat.com>
In-Reply-To: <20230829125809.232318-1-thaller@redhat.com>
References: <20230829125809.232318-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Clang warns:

    parser_bison.c:7606:9: error: variable 'nft_nerrs' set but not used [-Werror,-Wunused-but-set-variable]
        int yynerrs = 0;
            ^
    parser_bison.c:72:25: note: expanded from macro 'yynerrs'
    #define yynerrs         nft_nerrs
                            ^

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/Makefile.am b/src/Makefile.am
index ad22a918c120..63a4ef43dae3 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -88,6 +88,7 @@ libparser_la_CFLAGS = ${AM_CFLAGS} \
 		      -Wno-missing-prototypes \
 		      -Wno-missing-declarations \
 		      -Wno-implicit-function-declaration \
+		      -Wno-unused-but-set-variable \
 		      -Wno-nested-externs \
 		      -Wno-undef \
 		      -Wno-redundant-decls
-- 
2.41.0

