Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E33C71153
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 14:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjH1OsD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 10:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjH1Ori (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 10:47:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4B71BD
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 07:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693233989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xUv3KVyLC5NXVhKP2vrfX0Hv/4XlZL+W+sMQCD8xOJE=;
        b=YF4XwKlsHeRAuZHKkxDs51DZk2K0go9cJd+PuU3DUGEpWONWYiOJzczIQ6PP7a6SS+iXw5
        zUCQ7I00V8kKbw24u7kFVlyey4CtFvEHOeFl+wYV87Ab0gTRoQtlhxAcohaBfWM9LhMngP
        VxzYv1eC4i2B/hB4dVS9nAMQfKu+Ew0=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-v5246Me8OIK7IEeJYlCuQg-1; Mon, 28 Aug 2023 10:46:28 -0400
X-MC-Unique: v5246Me8OIK7IEeJYlCuQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8D263C10149
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 14:46:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46EB040D2839;
        Mon, 28 Aug 2023 14:46:27 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 8/8] datatype: suppress "-Wformat-nonliteral" warning in integer_type_print()
Date:   Mon, 28 Aug 2023 16:43:58 +0200
Message-ID: <20230828144441.3303222-9-thaller@redhat.com>
In-Reply-To: <20230828144441.3303222-1-thaller@redhat.com>
References: <20230828144441.3303222-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

    datatype.c:455:22: error: format string is not a string literal [-Werror,-Wformat-nonliteral]
            nft_gmp_print(octx, fmt, expr->value);
                                ^~~

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/datatype.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/datatype.c b/src/datatype.c
index 4d0e44eeb500..12fe7141709d 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -452,7 +452,9 @@ static void integer_type_print(const struct expr *expr, struct output_ctx *octx)
 		}
 	} while ((dtype = dtype->basetype));
 
+	_NFT_PRAGMA_WARNING_DISABLE("-Wformat-nonliteral")
 	nft_gmp_print(octx, fmt, expr->value);
+	_NFT_PRAGMA_WARNING_REENABLE
 }
 
 static struct error_record *integer_type_parse(struct parse_ctx *ctx,
-- 
2.41.0

