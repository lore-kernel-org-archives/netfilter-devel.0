Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58886C3DA66
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbjHYLcs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244536AbjHYLcl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:32:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD47B2691
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+08040zio2UVmYGTK+oUNZqgTlqAwPJpzauMYWqWHIM=;
        b=Q4uDOyC7s8Oqs+IrURA+l6QJ5R3oBny9hLXmeBiXiumfy+mLZQUQrs9MA2Gwpguzl4EwsM
        w+wApbUD9NXJBJdwk7Xi8KsNIeUCuBIYSYDEN84zzQsLQE7g6T+VNllpgHNlZeE3p3OmeE
        kPIMNd/7I4KV6hTVpn38YIb4OhfE1a8=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-WnvJstpxOCWA8TZHYG7gnw-1; Fri, 25 Aug 2023 07:30:57 -0400
X-MC-Unique: WnvJstpxOCWA8TZHYG7gnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5771B1C07256
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 11:30:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB13940C6F4C;
        Fri, 25 Aug 2023 11:30:56 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 5/6] build: drop recursive make for "examples/Makefile.am"
Date:   Fri, 25 Aug 2023 13:27:37 +0200
Message-ID: <20230825113042.2607496-6-thaller@redhat.com>
In-Reply-To: <20230825113042.2607496-1-thaller@redhat.com>
References: <20230825113042.2607496-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am          | 19 ++++++++++++++++---
 configure.ac         |  1 -
 examples/Makefile.am |  6 ------
 3 files changed, 16 insertions(+), 10 deletions(-)
 delete mode 100644 examples/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index 2ad18f72dfd6..4af2d1f88b46 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -26,9 +26,11 @@ ACLOCAL_AMFLAGS = -I m4
 
 EXTRA_DIST =
 BUILT_SOURCES =
+LDADD =
 lib_LTLIBRARIES =
 noinst_LTLIBRARIES =
 sbin_PROGRAMS =
+check_PROGRAMS =
 
 ###############################################################################
 
@@ -282,9 +284,20 @@ src_nft_LDADD = src/libnftables.la
 
 ###############################################################################
 
-SUBDIRS = \
-		doc	\
-		examples
+SUBDIRS = doc
+
+###############################################################################
+
+
+check_PROGRAMS += examples/nft-buffer
+
+examples_nft_buffer_AM_CPPFLAGS = -I$(srcdir)/include
+examples_nft_buffer_LDADD = src/libnftables.la
+
+check_PROGRAMS += examples/nft-json-file
+
+examples_nft_json_file_AM_CPPFLAGS = -I$(srcdir)/include
+examples_nft_json_file_LDADD = src/libnftables.la
 
 ###############################################################################
 
diff --git a/configure.ac b/configure.ac
index 739434b7f474..b5cc2587253b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -116,7 +116,6 @@ AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
 		doc/Makefile				\
-		examples/Makefile			\
 		])
 AC_OUTPUT
 
diff --git a/examples/Makefile.am b/examples/Makefile.am
deleted file mode 100644
index 3b8b0b6708dc..000000000000
--- a/examples/Makefile.am
+++ /dev/null
@@ -1,6 +0,0 @@
-check_PROGRAMS	= nft-buffer		\
-		  nft-json-file
-
-AM_CPPFLAGS = -I$(top_srcdir)/include
-
-LDADD = $(top_builddir)/src/libnftables.la
-- 
2.41.0

