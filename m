Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D14C4167D
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 15:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjKEPLA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 10:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjKEPK7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 10:10:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8388AE0
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 07:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699197011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r3l4cEuqonwaqle7GSVCXUcT0l7OaIqlkKBKMwFJ3yM=;
        b=D/nZ4/9aG587+DoHGuTRw+7B7S7o32RBe5vCfwu/dpiA7hGLnagAKTAp2bkv9Q+t7P7ce1
        9MPS0nF/NgiqBWRziN5lgq0r8ASu76TeMbu62xhdhWXORfudWVoVYi1/pRXgch+8fjSWtN
        m7NbPeRL2fIq6fVQzmkzjA7lcuAJX+g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-uSnDo0_yPTi6Kv6OVtIOKA-1; Sun, 05 Nov 2023 10:10:10 -0500
X-MC-Unique: uSnDo0_yPTi6Kv6OVtIOKA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2C6B85A58B
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 15:10:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50768492BFA;
        Sun,  5 Nov 2023 15:10:09 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 4/5] build: cleanup if-blocks for conditional compilation in "Makefile.am"
Date:   Sun,  5 Nov 2023 16:08:40 +0100
Message-ID: <20231105150955.349966-5-thaller@redhat.com>
In-Reply-To: <20231105150955.349966-1-thaller@redhat.com>
References: <20231105150955.349966-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`configure` sets those $(*_LIBS) variables to something empty, when the
dependency is not available. It's cumbersome and unnecessary to
explicitly check.

Also, the order in which libraries are specified on the command line
matters. Commonly we want our own libraries first ("src/libminigmp.la"
should come pretty early). That is cumbersome to get right otherwise.

Thus, remove those conditional checks and just refer to those $(*_LIBS)
variables unconditionally. Rely on them being empty, when the dependency
is disabled.

Also, as "src/xt.c" is always built, just directly add it to the list of
source files.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 48d138636d2f..396bf3fa2c22 100644
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

