Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAF6C7EE2C
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjHYLcr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244486AbjHYLcg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:32:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7682E2695
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LcfWS3M/etWiiE8J+H32T0yDx5xEIp4R6hUqLAm3Z0k=;
        b=USWitvCH9joI17P9f0HB3LgTiHlnimwEX9RHkDLN7E0K2Dm8+REmRk8NSm/PlGmpvZ+dsY
        pA+UE7VTQFGqEf9XWPIlvaePzb6RhneWRJn9R7fkAqU+V/01S6kBS/QHheR5RL+4hyQpJL
        QxqA4HCM90ca9NH5QHLqKPalv47RlMg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-694-yPzM9j0CN6eqhX3V-_Gj7Q-1; Fri, 25 Aug 2023 07:30:55 -0400
X-MC-Unique: yPzM9j0CN6eqhX3V-_Gj7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D689A8015A8
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 11:30:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5483740D2839;
        Fri, 25 Aug 2023 11:30:54 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/6] build: drop recursive make for "py/Makefile.am"
Date:   Fri, 25 Aug 2023 13:27:34 +0200
Message-ID: <20230825113042.2607496-3-thaller@redhat.com>
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
 Makefile.am    | 19 +++++++++++++++----
 configure.ac   |  1 -
 py/Makefile.am |  1 -
 3 files changed, 15 insertions(+), 6 deletions(-)
 delete mode 100644 py/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index 2be6329275e0..feb21454b5eb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,5 +1,7 @@
 ACLOCAL_AMFLAGS = -I m4
 
+EXTRA_DIST =
+
 pkginclude_HEADERS = \
 	include/nftables/libnftables.h \
 	$(NULL)
@@ -72,11 +74,20 @@ noinst_HEADERS = \
 SUBDIRS =	src	\
 		files	\
 		doc	\
-		examples\
-		py
+		examples
+
+EXTRA_DIST += \
+	py/pyproject.toml \
+	py/setup.cfg \
+	py/setup.py \
+	py/src/__init__.py \
+	py/src/nftables.py \
+	py/src/schema.json \
+	$(NULL)
 
-EXTRA_DIST =	tests	\
-		files
+EXTRA_DIST += \
+	tests \
+	files
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnftables.pc
diff --git a/configure.ac b/configure.ac
index ca2eaca09869..06ac7da27ae3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -121,7 +121,6 @@ AC_CONFIG_FILES([					\
 		files/nftables/Makefile			\
 		files/osf/Makefile			\
 		doc/Makefile				\
-		py/Makefile				\
 		examples/Makefile			\
 		])
 AC_OUTPUT
diff --git a/py/Makefile.am b/py/Makefile.am
deleted file mode 100644
index 76aa082f8709..000000000000
--- a/py/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-EXTRA_DIST = pyproject.toml setup.cfg setup.py src
-- 
2.41.0

