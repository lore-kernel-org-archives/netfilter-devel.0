Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55A7CDB483
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 13:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbjJSNDK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 09:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235456AbjJSNC6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 09:02:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040DE6A45
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 06:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697720483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVG8ciedwP/ZYgu2AO3RcbwEEBcp2HEQVS+7k0qPYDs=;
        b=CexOfsFRsqwytwPuZYktZHat3wTEZlc4GgibYdJ93h8scbQIO0tC7BjnyzLtfdyRKOc0LL
        7sBLbpy4YF2FbdNWRyNEudDj9x/1zfHBCOCVJrIb1GrxBghbiXkQ3wj/S29JveC2Gxz26e
        T7oV13rQs3if512Hlf137uqMc2BPvAg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-TO04UvOnMWCY3YK86GlP8A-1; Thu, 19 Oct 2023 09:01:13 -0400
X-MC-Unique: TO04UvOnMWCY3YK86GlP8A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E64703C17089
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 13:01:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 683E8503C;
        Thu, 19 Oct 2023 13:01:12 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 6/7] build: no recursive make for "examples/Makefile.am"
Date:   Thu, 19 Oct 2023 15:00:05 +0200
Message-ID: <20231019130057.2719096-7-thaller@redhat.com>
In-Reply-To: <20231019130057.2719096-1-thaller@redhat.com>
References: <20231019130057.2719096-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge the Makefile.am under "examples/" into the toplevel Makefile.am.
This is a step in the effort of dropping recursive make.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am          | 19 ++++++++++++++++---
 configure.ac         |  1 -
 examples/Makefile.am |  6 ------
 3 files changed, 16 insertions(+), 10 deletions(-)
 delete mode 100644 examples/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index b89d60e32d8c..af82f021203a 100644
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
 
@@ -288,9 +290,20 @@ src_nft_LDADD = src/libnftables.la
 
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
index 79024e49ab28..c5e4113898a0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -118,7 +118,6 @@ AC_CONFIG_FILES([					\
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

