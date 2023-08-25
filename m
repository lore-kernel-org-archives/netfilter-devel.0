Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3829FC3DA66
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbjHYLkR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjHYLj5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:39:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B69F2107
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CJsKQY4nnW91Gtgtptlh9LkXmTGycNlqhqr3GaqeT6U=;
        b=QkfgQQEd7kSd4kXeBB0tfitjHd5YQMd5FRyjyWhU0sFmq6kbhQ4eEn3Ougwzgt4VmMvM9k
        wVfaXOn+K2QmTrWI6WLWH/0TkjuWGxfz/KXd9R0I5LUOfQueX2Ij/A/3rqVs96FaBuDWrz
        /BaMAt0lVkI7rY0AOX8TgvZjXJ6ZMoE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-M9aKvz-CPOqyUdKOTKHO5g-1; Fri, 25 Aug 2023 07:38:27 -0400
X-MC-Unique: M9aKvz-CPOqyUdKOTKHO5g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F6D5101A53C
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 11:38:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DD41112131B;
        Fri, 25 Aug 2023 11:38:25 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 6/6] configure: drop AM_PROG_CC_C_O autoconf check
Date:   Fri, 25 Aug 2023 13:36:34 +0200
Message-ID: <20230825113810.2620133-7-thaller@redhat.com>
In-Reply-To: <20230825113810.2620133-1-thaller@redhat.com>
References: <20230825113810.2620133-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
index baec66978847..0f763a793b84 100644
--- a/configure.ac
+++ b/configure.ac
@@ -47,7 +47,6 @@ fi
 
 AM_PROG_AR
 LT_INIT([disable-static])
-AM_PROG_CC_C_O
 AC_EXEEXT
 CHECK_GCC_FVISIBILITY
 
-- 
2.41.0

