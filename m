Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E367CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 13:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345812AbjJSNDJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 09:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbjJSNC5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 09:02:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3F047AF
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 06:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697720482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=woYz2kCCb8ZRZf9svrjdls5JXPoOC5AyXDhf1jmRb+o=;
        b=ajGK5RFt8hpjV1qqEKzrJCGtJ8EIKKRI2VxSwtuTI+bUvxD5cRH/k8jiKdTek66OvSvDlC
        MJJGoKfAn/q6/l/7bicBvq2gLdbKD0Eh1w8iywJi/VkIURp+A6y54irqjq+7AwxbuwqN3y
        9H4hYEpjCyYopIFicy8hrUPMzj9Yq5s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-VOrbjg-oNJ2lcRwblnY06g-1; Thu, 19 Oct 2023 09:01:14 -0400
X-MC-Unique: VOrbjg-oNJ2lcRwblnY06g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA94610201E0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 13:01:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C9DE10828;
        Thu, 19 Oct 2023 13:01:13 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 7/7] build: no recursive make for "doc/Makefile.am"
Date:   Thu, 19 Oct 2023 15:00:06 +0200
Message-ID: <20231019130057.2719096-8-thaller@redhat.com>
In-Reply-To: <20231019130057.2719096-1-thaller@redhat.com>
References: <20231019130057.2719096-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge the Makefile.am under "doc/" into the toplevel Makefile.am. This
is a step in the effort of dropping recursive make.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am     | 60 ++++++++++++++++++++++++++++++++++++++++++++-----
 configure.ac    |  1 -
 doc/Makefile.am | 30 -------------------------
 3 files changed, 55 insertions(+), 36 deletions(-)
 delete mode 100644 doc/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index af82f021203a..0ed831a19e95 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,6 +31,8 @@ lib_LTLIBRARIES =
 noinst_LTLIBRARIES =
 sbin_PROGRAMS =
 check_PROGRAMS =
+dist_man_MANS =
+CLEANFILES =
 
 ###############################################################################
 
@@ -290,11 +292,6 @@ src_nft_LDADD = src/libnftables.la
 
 ###############################################################################
 
-SUBDIRS = doc
-
-###############################################################################
-
-
 check_PROGRAMS += examples/nft-buffer
 
 examples_nft_buffer_AM_CPPFLAGS = -I$(srcdir)/include
@@ -307,6 +304,59 @@ examples_nft_json_file_LDADD = src/libnftables.la
 
 ###############################################################################
 
+if BUILD_MAN
+
+dist_man_MANS += \
+	doc/nft.8 \
+	doc/libnftables-json.5 \
+	doc/libnftables.3 \
+	$(NULL)
+
+A2X_OPTS_MANPAGE = \
+	-L \
+	--doctype manpage \
+	--format manpage \
+	-D "${builddir}/doc" \
+	$(NULL)
+
+ASCIIDOC_MAIN = doc/nft.txt
+
+ASCIIDOC_INCLUDES = \
+	doc/data-types.txt \
+	doc/payload-expression.txt \
+	doc/primary-expression.txt \
+	doc/stateful-objects.txt \
+	doc/statements.txt \
+	$(NULL)
+
+ASCIIDOCS = \
+	$(ASCIIDOC_MAIN) \
+	$(ASCIIDOC_INCLUDES) \
+	$(NULL)
+
+EXTRA_DIST += \
+	$(ASCIIDOCS) \
+	doc/libnftables-json.adoc \
+	doc/libnftables.adoc \
+	$(NULL)
+
+CLEANFILES += doc/*~
+
+doc/nft.8: $(ASCIIDOCS)
+	$(AM_V_GEN)$(A2X) $(A2X_OPTS_MANPAGE) $<
+
+.adoc.3:
+	$(AM_V_GEN)$(A2X) $(A2X_OPTS_MANPAGE) $<
+
+.adoc.5:
+	$(AM_V_GEN)$(A2X) $(A2X_OPTS_MANPAGE) $<
+
+MAINTAINERCLEANFILES = ${dist_man_MANS}
+
+endif
+
+###############################################################################
+
 dist_pkgdata_DATA = \
 	files/nftables/all-in-one.nft \
 	files/nftables/arp-filter.nft \
diff --git a/configure.ac b/configure.ac
index c5e4113898a0..724a4ae726c1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -117,7 +117,6 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
-		doc/Makefile				\
 		])
 AC_OUTPUT
 
diff --git a/doc/Makefile.am b/doc/Makefile.am
deleted file mode 100644
index b43cb08d2d14..000000000000
--- a/doc/Makefile.am
+++ /dev/null
@@ -1,30 +0,0 @@
-if BUILD_MAN
-dist_man_MANS = nft.8 libnftables-json.5 libnftables.3
-
-A2X_OPTS_MANPAGE = -L --doctype manpage --format manpage -D ${builddir}
-
-ASCIIDOC_MAIN = nft.txt
-ASCIIDOC_INCLUDES = \
-       data-types.txt \
-       payload-expression.txt \
-       primary-expression.txt \
-       stateful-objects.txt \
-       statements.txt
-ASCIIDOCS = ${ASCIIDOC_MAIN} ${ASCIIDOC_INCLUDES}
-
-EXTRA_DIST = ${ASCIIDOCS} libnftables-json.adoc libnftables.adoc
-
-CLEANFILES = \
-	*~
-
-nft.8: ${ASCIIDOCS}
-	${AM_V_GEN}${A2X} ${A2X_OPTS_MANPAGE} $<
-
-.adoc.3:
-	${AM_V_GEN}${A2X} ${A2X_OPTS_MANPAGE} $<
-
-.adoc.5:
-	${AM_V_GEN}${A2X} ${A2X_OPTS_MANPAGE} $<
-
-MAINTAINERCLEANFILES = ${dist_man_MANS}
-endif
-- 
2.41.0

