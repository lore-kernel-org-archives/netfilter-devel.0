Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E426DC3DA6F
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 11:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbjHXLQ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbjHXLQR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 07:16:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA4619B7
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 04:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692875715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e1GJw+Z0LNBBeYh8k7YLTGKXrfeJv5XcQd8j1CWgCU0=;
        b=B8egjBafQjzihOZMcML7wuak55Bg0e8C15bB+vQ7mhkSC26Yvvi7bvgWbt4d+qIbfXUnej
        9AQdFm7DUFuXXgZ7gO7xid+JJRcbEcRFPA28jcA056vI2yKNjKnrgt3hL7QgIUJcpSRjMe
        X5+/EcEdozSI6BFw0LkD+nVr3yDJh0Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-GiSYTU3fN7-nLS2CNgivcg-1; Thu, 24 Aug 2023 07:15:13 -0400
X-MC-Unique: GiSYTU3fN7-nLS2CNgivcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A02DC853068
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 11:15:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F8B2C1602B;
        Thu, 24 Aug 2023 11:15:13 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 6/6] configure: drop AM_PROG_CC_C_O autoconf check
Date:   Thu, 24 Aug 2023 13:13:34 +0200
Message-ID: <20230824111456.2005125-7-thaller@redhat.com>
In-Reply-To: <20230824111456.2005125-1-thaller@redhat.com>
References: <20230824111456.2005125-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This macro is obsolete since automake 1.14 (2013). It might have been
unnecessary even before, in practice only gcc/clang are supported
compilers.

[1] https://www.gnu.org/software/automake/manual/html_node/Public-Macros.html#index-AM_005fPROG_005fCC_005fC_005fO
[2] https://lists.gnu.org/archive/html/info-gnu/2013-06/msg00009.html

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 configure.ac | 1 -
 1 file changed, 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 9d859307adaa..7c714adccb58 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,7 +44,6 @@ fi
 
 AM_PROG_AR
 LT_INIT([disable-static])
-AM_PROG_CC_C_O
 
 AC_USE_SYSTEM_EXTENSIONS
 
-- 
2.41.0

