Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEDAC88CB9
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 11:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbjHXLQc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbjHXLQR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 07:16:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F2E19B6
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 04:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692875711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gz8gec0+Vz68yH9QxLwu2GnjD3KxHsB+UvM8T/57tp8=;
        b=GQLo7QL7cFHkLG5cTYHpHViRhDPdYUAftWps/FZnPHta+HIdVgnRsZpIgW86dwgdLackWu
        r39Jc2mXcKMM/lhX7RI4Wr48ApydGyHz8K0xR7LAtlojsh0vUgPgqthwS/hKqDWdJQwrKU
        zl9wH8JZYy8od0xU7wMeWwGVl1SYVMc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-aOnggQTDMiCCriWzf3mIyA-1; Thu, 24 Aug 2023 07:15:09 -0400
X-MC-Unique: aOnggQTDMiCCriWzf3mIyA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CF958D40A0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 11:15:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0206C1602B;
        Thu, 24 Aug 2023 11:15:08 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/6] meta: define _GNU_SOURCE to get strptime() from <time.h>
Date:   Thu, 24 Aug 2023 13:13:29 +0200
Message-ID: <20230824111456.2005125-2-thaller@redhat.com>
In-Reply-To: <20230824111456.2005125-1-thaller@redhat.com>
References: <20230824111456.2005125-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
macros right. That is, define th _?_SOURCE macro as first thing.

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

