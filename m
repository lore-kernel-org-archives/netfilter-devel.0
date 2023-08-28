Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD96DC83F15
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 14:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjH1Or4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 10:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjH1Or3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 10:47:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8521B8
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 07:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693233989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g1a0qAVXzzOpOAh190r+iAm0feWg4ifaSlMiSPDYl1A=;
        b=gkNsjb230W43M8TCReyR5zBask6OK4JJBuWHFHjTTVyjtME4OBLV9yMxzq3dctPNWOVtxG
        pu8z+BNP9QqRD+gsZF44q0y4BY909jMcbQq+YXg4+fC7eUidrCX42ygJlwd1K7Ut4bxf3s
        LxEk5Samp8o/0TOKm6Iwe+UPouA59xI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-xjqjP2ZsOFW_IH7M7yXrVQ-1; Mon, 28 Aug 2023 10:46:27 -0400
X-MC-Unique: xjqjP2ZsOFW_IH7M7yXrVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A863802C1E
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 14:46:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F09F40D2839;
        Mon, 28 Aug 2023 14:46:26 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 7/8] utils: add _NFT_PRAGMA_WARNING_DISABLE()/_NFT_PRAGMA_WARNING_REENABLE helpers
Date:   Mon, 28 Aug 2023 16:43:57 +0200
Message-ID: <20230828144441.3303222-8-thaller@redhat.com>
In-Reply-To: <20230828144441.3303222-1-thaller@redhat.com>
References: <20230828144441.3303222-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Taken from libnl3 ([1]), which is LGPL-2.1-only licensed.

[1] https://github.com/thom311/libnl/blob/main/include/base/nl-base-utils.h#L44
---
 include/utils.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index 873147fb54ec..9475bbbee6a0 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -9,6 +9,47 @@
 #include <list.h>
 #include <gmputil.h>
 
+/*****************************************************************************/
+
+#define _NFT_STRINGIFY_ARG(contents) #contents
+#define _NFT_STRINGIFY(macro_or_string) _NFT_STRINGIFY_ARG(macro_or_string)
+
+/*****************************************************************************/
+
+#if defined(__GNUC__)
+#define _NFT_PRAGMA_WARNING_DO(warning) \
+	_NFT_STRINGIFY(GCC diagnostic ignored warning)
+#elif defined(__clang__)
+#define _NFT_PRAGMA_WARNING_DO(warning) \
+	_NFT_STRINGIFY(clang diagnostic ignored warning)
+#endif
+
+#if defined(__GNUC__) && \
+	(__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6))
+#define _NFT_PRAGMA_WARNING_DISABLE(warning)                 \
+	_Pragma("GCC diagnostic push")                       \
+		_Pragma(_NFT_PRAGMA_WARNING_DO("-Wpragmas")) \
+			_Pragma(_NFT_PRAGMA_WARNING_DO(warning))
+#elif defined(__clang__)
+#define _NFT_PRAGMA_WARNING_DISABLE(warning)                                \
+	_Pragma("clang diagnostic push")                                    \
+		_Pragma(_NFT_PRAGMA_WARNING_DO("-Wunknown-warning-option")) \
+			_Pragma(_NFT_PRAGMA_WARNING_DO(warning))
+#else
+#define _NFT_PRAGMA_WARNING_DISABLE(warning)
+#endif
+
+#if defined(__GNUC__) && \
+	(__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6))
+#define _NFT_PRAGMA_WARNING_REENABLE _Pragma("GCC diagnostic pop")
+#elif defined(__clang__)
+#define _NFT_PRAGMA_WARNING_REENABLE _Pragma("clang diagnostic pop")
+#else
+#define _NFT_PRAGMA_WARNING_REENABLE
+#endif
+
+/*****************************************************************************/
+
 #ifdef HAVE_VISIBILITY_HIDDEN
 #       define __visible        __attribute__((visibility("default")))
 #       define EXPORT_SYMBOL(x) typeof(x) (x) __visible;
-- 
2.41.0

