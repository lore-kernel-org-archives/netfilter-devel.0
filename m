Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D09C4167D
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 11:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjKCLM5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 07:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjKCLM4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 07:12:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE8FD45
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 04:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699009878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y5xzeJhwOzNKjeNrUnon6so8UZY4mXOb669i/F3TTVg=;
        b=MAYq4ZY8XWDM9NuQEYcGbrCFpJdUHYTJNHPLUb/1UCG7iXkixOOrcUCqAh79APxCddcmsi
        51MQzq4oQGkjH6225YjOYvdIeDLke7cW/FshuMFzDlsWYm3pXCgWojZzXeYU5o/IvGRZjN
        UmRjoOSLj+pykZzGQ6KhZR8x4PDT2oQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-Xc27GE_wMR6aTViEo3RcQQ-1; Fri, 03 Nov 2023 07:11:17 -0400
X-MC-Unique: Xc27GE_wMR6aTViEo3RcQQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BBD8811E7B
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 11:11:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BFD111C060BA;
        Fri,  3 Nov 2023 11:11:16 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 5/6] build: cleanup if blocks for conditional compilation
Date:   Fri,  3 Nov 2023 12:05:47 +0100
Message-ID: <20231103111102.2801624-6-thaller@redhat.com>
In-Reply-To: <20231103111102.2801624-1-thaller@redhat.com>
References: <20231103111102.2801624-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`configure` sets those $(*_LIBS) variables to something empty, if the
dependency is not available. It's cumbersome and unnecessary to
explicitly checking.

Also, the order in which libraries are specified on the command line
matters. Commonly we want our own libraries first (src/libminigmp.la
should come pretty early). That is cumbersome to get right otherwise.

Also, as "xt.c" is always built, just directly add it to the list of
source files.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 94c40fc3c6a2..f06fab8e3b9f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -195,6 +195,12 @@ src_libminigmp_la_CFLAGS = \
 	-Wno-sign-compare \
 	$(NULL)
 
+LIBMINIGMP_LIBS = src/libminigmp.la
+
+else
+
+LIBMINIGMP_LIBS =
+
 endif
 
 ###############################################################################
@@ -247,10 +253,9 @@ src_libnftables_la_SOURCES = \
 	src/tcpopt.c \
 	src/utils.c \
 	src/xfrm.c \
+	src/xt.c \
 	$(NULL)
 
-src_libnftables_la_SOURCES += src/xt.c
-
 if BUILD_JSON
 src_libnftables_la_SOURCES += \
 	src/json.c \
@@ -264,23 +269,14 @@ src_libnftables_la_LDFLAGS = \
 	$(NULL)
 
 src_libnftables_la_LIBADD = \
+	src/libparser.la \
+	$(LIBMINIGMP_LIBS) \
 	$(LIBMNL_LIBS) \
 	$(LIBNFTNL_LIBS) \
-	src/libparser.la \
+	$(XTABLES_LIBS) \
+	$(JANSSON_LIBS) \
 	$(NULL)
 
-if BUILD_MINIGMP
-src_libnftables_la_LIBADD += src/libminigmp.la
-endif
-
-if BUILD_XTABLES
-src_libnftables_la_LIBADD += $(XTABLES_LIBS)
-endif
-
-if BUILD_JSON
-src_libnftables_la_LIBADD += $(JANSSON_LIBS)
-endif
-
 ###############################################################################
 
 sbin_PROGRAMS += src/nft
-- 
2.41.0

