Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC50EE49A5
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238257AbjHYLct (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244535AbjHYLcl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:32:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59D426A1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMwS+1m5hJK7DoNd1ffupw5JCpMlHJOVR76zi7NX1wc=;
        b=Ew0VBBrdRnEodHk3HkFVNm/ZZq+q1Jxtij2odBp/LV/clH5W7H8mjlG6kUqJ+1adBJ37Yw
        0QPvJJLE1KQeLZK2mxz/W8UbgxTcyzJ4ZYu9lT4c4ZWq1P8vsaHc++dnGWsavQ22gbQVpi
        XFBYcgTD+Ew9u4WviSQiLvCPOYlyg7I=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-CV0isUg5P6eLDJNXzP9bVw-1; Fri, 25 Aug 2023 07:30:58 -0400
X-MC-Unique: CV0isUg5P6eLDJNXzP9bVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CD2A1C0725A
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 11:30:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94DC540C6F4C;
        Fri, 25 Aug 2023 11:30:57 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 6/6] build: drop recursive make for "doc/Makefile.am"
Date:   Fri, 25 Aug 2023 13:27:38 +0200
Message-ID: <20230825113042.2607496-7-thaller@redhat.com>
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
 Makefile.am     | 60 ++++++++++++++++++++++++++++++++++++++++++++-----
 configure.ac    |  1 -
 doc/Makefile.am | 30 -------------------------
 3 files changed, 55 insertions(+), 36 deletions(-)
 delete mode 100644 doc/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index 4af2d1f88b46..3f7a8ca9bc9f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,6 +31,8 @@ lib_LTLIBRARIES =
 noinst_LTLIBRARIES =
 sbin_PROGRAMS =
 check_PROGRAMS =
+dist_man_MANS =
+CLEANFILES =
 
 ###############################################################################
 
@@ -284,11 +286,6 @@ src_nft_LDADD = src/libnftables.la
 
 ###############################################################################
 
-SUBDIRS = doc
-
-###############################################################################
-
-
 check_PROGRAMS += examples/nft-buffer
 
 examples_nft_buffer_AM_CPPFLAGS = -I$(srcdir)/include
@@ -301,6 +298,59 @@ examples_nft_json_file_LDADD = src/libnftables.la
 
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
index b5cc2587253b..f1e38e9d697d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -115,7 +115,6 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
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

