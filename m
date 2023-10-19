Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00794CDB483
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 13:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345752AbjJSNDH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 09:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbjJSNCz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 09:02:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C341B6E97
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 06:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697720487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wpmpm7HKa4ik8ND4nvCx0VVM55KQvQRfNpOpMoIb3Rc=;
        b=UUHoTTUct9QrwKswqOyzQQAoVOHUdppQeB782jgVeJPMYC85u8h9AGzh6m7cblhxxcx+hv
        ZPAOuU6F68GX2wZ5gtxqSbErkmgiacfq7ymVSUuU7NxHVCK/vk6zU+hTUeFNXkFbuYWFY9
        n0EHnaRkG6tRxAc8LOMCIxrCCU5UeaE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-dSiQoEr-O5SkfQ4pBGjuVw-1; Thu, 19 Oct 2023 09:01:10 -0400
X-MC-Unique: dSiQoEr-O5SkfQ4pBGjuVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8754788B7B0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 13:01:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 09E9A10828;
        Thu, 19 Oct 2023 13:01:09 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 3/7] build: no recursive make for "py/Makefile.am"
Date:   Thu, 19 Oct 2023 15:00:02 +0200
Message-ID: <20231019130057.2719096-4-thaller@redhat.com>
In-Reply-To: <20231019130057.2719096-1-thaller@redhat.com>
References: <20231019130057.2719096-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge the Makefile.am under "py/" into the toplevel Makefile.am. This is
a step in the effort of dropping recursive make.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am    | 20 ++++++++++++++++----
 configure.ac   |  1 -
 py/Makefile.am |  1 -
 3 files changed, 16 insertions(+), 6 deletions(-)
 delete mode 100644 py/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index bfc64ebbed71..8b8de7bd141a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,5 +1,7 @@
 ACLOCAL_AMFLAGS = -I m4
 
+EXTRA_DIST =
+
 pkginclude_HEADERS = \
 	include/nftables/libnftables.h \
 	$(NULL)
@@ -73,11 +75,21 @@ noinst_HEADERS = \
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
+	files \
+	tests \
+	$(NULL)
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnftables.pc
diff --git a/configure.ac b/configure.ac
index 67ca50fddf67..389efbe9f730 100644
--- a/configure.ac
+++ b/configure.ac
@@ -123,7 +123,6 @@ AC_CONFIG_FILES([					\
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

