Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62055C3DA66
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjHYLjw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbjHYLjM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:39:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D44A1FF5
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ukKj6dgHsGJSMIWoyb2nglshvnMMcbFW6wNM7sqClAY=;
        b=MDRaStVhRZfmwafTzh2xMVHo02oOt1p8RW9uVnMXSeIFpWAzQtP/sXFlTO9sTz+wdaqNe+
        Ce2SYfyoyYv3Sxzqwrx9rvtomHmu1h6Utq85qjzX1jzMQPxLvG7O3Qe3+tlzVmbt/K2Ohm
        x81OLHU3rJ70fxsb4e7Ypl8glOiOBc8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-NLRNhP6AOOeLT6vLaAKYLQ-1; Fri, 25 Aug 2023 07:38:22 -0400
X-MC-Unique: NLRNhP6AOOeLT6vLaAKYLQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48EA3800270
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 11:38:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC5211121319;
        Fri, 25 Aug 2023 11:38:21 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 1/6] meta: define _GNU_SOURCE to get strptime() from <time.h>
Date:   Fri, 25 Aug 2023 13:36:29 +0200
Message-ID: <20230825113810.2620133-2-thaller@redhat.com>
In-Reply-To: <20230825113810.2620133-1-thaller@redhat.com>
References: <20230825113810.2620133-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To use `strptime()`, the documentation indicates

  #define _XOPEN_SOURCE
  #include <time.h>

However, previously this was done wrongly.

For example, when building with musl we got a warning:

      CC       meta.lo
    meta.c:40: warning: "_XOPEN_SOURCE" redefined
       40 | #define _XOPEN_SOURCE
          |
    In file included from /usr/include/errno.h:8,
                     from meta.c:13:
    /usr/include/features.h:16: note: this is the location of the previous definition
       16 | #define _XOPEN_SOURCE 700
          |

Defining "__USE_XOPEN" is wrong. This is a glibc internal define not for
the user.

Note that if we just set _XOPEN_SOURCE (or _XOPEN_SOURCE=700), we won't
get other things like "struct tm.tm_gmtoff".

Instead, we already define _GNU_SOURCE at other places. Do that here
too, it will give us strptime() and all is good.

Also, those directives should be defined as first thing (or via "-D"
command line). See [1].

This is also important, because to use "time_t" in a header, we would
need to include <time.h>. That only works, if we get the feature test
macros right. That is, define the _?_SOURCE macro as first thing.

[1] https://www.gnu.org/software/libc/manual/html_node/Feature-Test-Macros.html

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/meta.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index bf2201009a8c..8508b11e70ce 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -10,6 +10,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#define _GNU_SOURCE
+
 #include <errno.h>
 #include <limits.h>
 #include <stddef.h>
@@ -25,6 +27,7 @@
 #include <linux/netfilter.h>
 #include <linux/pkt_sched.h>
 #include <linux/if_packet.h>
+#include <time.h>
 
 #include <nftables.h>
 #include <expression.h>
@@ -37,10 +40,6 @@
 #include <iface.h>
 #include <json.h>
 
-#define _XOPEN_SOURCE
-#define __USE_XOPEN
-#include <time.h>
-
 static void tchandle_type_print(const struct expr *expr,
 				struct output_ctx *octx)
 {
-- 
2.41.0

