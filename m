Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CF1C4167B
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 18:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbjKHSZc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Nov 2023 13:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjKHSZb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2023 13:25:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E9D1FF9
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2023 10:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699467884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2JZ210fJ0tEw07Bwiu3CLdHawHE7XOl6rV1PTHNZVcc=;
        b=Ln2JeYQ5N9mz2UfKprtnVXq87n4rpHTmE2wXcOCBVQB1FILV2yc1dO7isJ+1FM2D5DpVGg
        JdslJeObUb+bQOU1HNi1JmkPWwt5Ux1NLO+YdOEQ8M1jf4wtYhEnau8FigGoClwPEO3Zog
        T0pupxoiZsPkjVYpRza3EplCfvU2D/Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-H9G1MyfHMmGJM2lJbj63Lg-1; Wed, 08 Nov 2023 13:24:42 -0500
X-MC-Unique: H9G1MyfHMmGJM2lJbj63Lg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B6CF857C20
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2023 18:24:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C6D71C060AE;
        Wed,  8 Nov 2023 18:24:41 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] utils: add memory_allocation_check() helper
Date:   Wed,  8 Nov 2023 19:24:24 +0100
Message-ID: <20231108182431.4005745-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libnftables kills the process on out of memory (xmalloc()), so
when we use libraries that propagate ENOMEM to libnftables, we
also abort the process.

For example:

     nlr = nftnl_rule_alloc();
     if (!nlr)
          memory_allocation_error();

Add memory_allocation_check() macro which can simplify this common
check to:

     nlr = memory_allocation_check(nftnl_rule_alloc());

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/utils.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index 36a28f893667..fcd7c598fe9f 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -142,6 +142,16 @@ extern void __memory_allocation_error(const char *filename, uint32_t line) __nor
 #define memory_allocation_error()		\
 	__memory_allocation_error(__FILE__, __LINE__);
 
+#define memory_allocation_check(cmd)               \
+	({                                         \
+		typeof((cmd)) _v = (cmd);          \
+		const void *const _v2 = _v;        \
+                                                   \
+		if (!_v2)                          \
+			memory_allocation_error(); \
+		_v;                                \
+	})
+
 extern void xfree(const void *ptr);
 extern void *xmalloc(size_t size);
 extern void *xmalloc_array(size_t nmemb, size_t size);
-- 
2.41.0

