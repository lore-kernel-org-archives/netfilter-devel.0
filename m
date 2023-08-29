Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FA9C83F19
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 18:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbjH2S4r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238579AbjH2S4T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 14:56:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E05B1BE
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 11:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693335328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=loGpn0aDpNBztsmVYIhDAIpKhTkZnl4hTRw0BCFPrxc=;
        b=hcis9GjU47XxnJ9xPPdXRdmYeQxxwh8p5HtPXf7IIAR/aY0jqSwsolczZPDgvtDl8JV3B+
        nkEEg/DruCIji7NN/risiZ4OaEHBPYVxumZi9H6D9sb6G3g1UViHQxb6FBo3mhX/sCisur
        Bg5ZdY6oa3MEVgebbIpa4xjC3VhY4iw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-Pl32bXwUPTezdufBczFn7Q-1; Tue, 29 Aug 2023 14:55:27 -0400
X-MC-Unique: Pl32bXwUPTezdufBczFn7Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94744856F67
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 18:55:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15518402D90;
        Tue, 29 Aug 2023 18:55:25 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/5] utils: call abort() after BUG() macro
Date:   Tue, 29 Aug 2023 20:54:08 +0200
Message-ID: <20230829185509.374614-3-thaller@redhat.com>
In-Reply-To: <20230829185509.374614-1-thaller@redhat.com>
References: <20230829185509.374614-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise, we get spurious warnings. The compiler should be aware that there is
no return from BUG(). Call abort() there, which is marked as __attribute__
((__noreturn__)).

    In file included from ./include/nftables.h:6,
                     from ./include/rule.h:4,
                     from src/payload.c:26:
    src/payload.c: In function 'icmp_dep_to_type':
    ./include/utils.h:39:34: error: this statement may fall through [-Werror=implicit-fallthrough=]
       39 | #define BUG(fmt, arg...)        ({ fprintf(stderr, "BUG: " fmt, ##arg); assert(0); })
          |                                 ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    src/payload.c:791:17: note: in expansion of macro 'BUG'
      791 |                 BUG("Invalid map for simple dependency");
          |                 ^~~
    src/payload.c:792:9: note: here
      792 |         case PROTO_ICMP_ECHO: return ICMP_ECHO;
          |         ^~~~

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/utils.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index efc8dec013a1..5b8b181c1e99 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -3,6 +3,7 @@
 
 #include <asm/byteorder.h>
 #include <stdarg.h>
+#include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <assert.h>
@@ -36,7 +37,7 @@
 #define __must_check		__attribute__((warn_unused_result))
 #define __noreturn		__attribute__((__noreturn__))
 
-#define BUG(fmt, arg...)	({ fprintf(stderr, "BUG: " fmt, ##arg); assert(0); })
+#define BUG(fmt, arg...)	({ fprintf(stderr, "BUG: " fmt, ##arg); assert(0); abort(); })
 
 #define BUILD_BUG_ON(condition)	((void)sizeof(char[1 - 2*!!(condition)]))
 #define BUILD_BUG_ON_ZERO(e)	(sizeof(char[1 - 2 * !!(e)]) - 1)
-- 
2.41.0

