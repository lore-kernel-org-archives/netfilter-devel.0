Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA61CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 13:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbjJSNDG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 09:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbjJSNCz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 09:02:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8274EED
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 06:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697720473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uv9yeMyN0M+R6ZQ96W2JhwShhrevNm7NogGyyAZuH6g=;
        b=i988rn38q9d+vkVJapNXwR22vUwWTnplYNXhxJXjCP0dWzc4XMK3A7pt7VCjYjpsws4RZw
        +54lsFuGC7BQfzscA8c5vdP1BU0vACRmwjWm8fuIfqVJdAbCcj01EWNkUAx7r9nKvfrqMT
        2xenCx8Y/Avqfc5kGe1Cc7WWjZc1fBs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-ly_uAyOAMYO2Yf1VmGEl7g-1; Thu, 19 Oct 2023 09:01:11 -0400
X-MC-Unique: ly_uAyOAMYO2Yf1VmGEl7g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A4FC3C17097
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 13:01:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1F91503B;
        Thu, 19 Oct 2023 13:01:10 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 4/7] build: no recursive make for "files/**/Makefile.am"
Date:   Thu, 19 Oct 2023 15:00:03 +0200
Message-ID: <20231019130057.2719096-5-thaller@redhat.com>
In-Reply-To: <20231019130057.2719096-1-thaller@redhat.com>
References: <20231019130057.2719096-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge the Makefile.am under "files/" into the toplevel Makefile.am. This
is a step in the effort of dropping recursive make.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am                | 43 +++++++++++++++++++++++++++++++++++++-
 configure.ac               |  4 ----
 files/Makefile.am          |  3 ---
 files/examples/Makefile.am |  5 -----
 files/nftables/Makefile.am | 14 -------------
 files/osf/Makefile.am      |  2 --
 6 files changed, 42 insertions(+), 29 deletions(-)
 delete mode 100644 files/Makefile.am
 delete mode 100644 files/examples/Makefile.am
 delete mode 100644 files/nftables/Makefile.am
 delete mode 100644 files/osf/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index 8b8de7bd141a..83f25dd8574b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,6 +2,8 @@ ACLOCAL_AMFLAGS = -I m4
 
 EXTRA_DIST =
 
+###############################################################################
+
 pkginclude_HEADERS = \
 	include/nftables/libnftables.h \
 	$(NULL)
@@ -72,11 +74,48 @@ noinst_HEADERS = \
 	\
 	$(NULL)
 
+###############################################################################
+
 SUBDIRS =	src	\
-		files	\
 		doc	\
 		examples
 
+###############################################################################
+
+dist_pkgdata_DATA = \
+	files/nftables/all-in-one.nft \
+	files/nftables/arp-filter.nft \
+	files/nftables/bridge-filter.nft \
+	files/nftables/inet-filter.nft \
+	files/nftables/inet-nat.nft \
+	files/nftables/ipv4-filter.nft \
+	files/nftables/ipv4-mangle.nft \
+	files/nftables/ipv4-nat.nft \
+	files/nftables/ipv4-raw.nft \
+	files/nftables/ipv6-filter.nft \
+	files/nftables/ipv6-mangle.nft \
+	files/nftables/ipv6-nat.nft \
+	files/nftables/ipv6-raw.nft \
+	files/nftables/netdev-ingress.nft \
+	$(NULL)
+
+pkgdocdir = ${docdir}/examples
+
+dist_pkgdoc_SCRIPTS = \
+	files/examples/ct_helpers.nft \
+	files/examples/load_balancing.nft \
+	files/examples/secmark.nft \
+	files/examples/sets_and_maps.nft \
+	$(NULL)
+
+pkgsysconfdir = ${sysconfdir}/nftables/osf
+
+dist_pkgsysconf_DATA = \
+	files/osf/pf.os \
+	$(NULL)
+
+###############################################################################
+
 EXTRA_DIST += \
 	py/pyproject.toml \
 	py/setup.cfg \
@@ -86,6 +125,8 @@ EXTRA_DIST += \
 	py/src/schema.json \
 	$(NULL)
 
+###############################################################################
+
 EXTRA_DIST += \
 	files \
 	tests \
diff --git a/configure.ac b/configure.ac
index 389efbe9f730..23581f91341d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -118,10 +118,6 @@ AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
 		src/Makefile				\
-		files/Makefile				\
-		files/examples/Makefile			\
-		files/nftables/Makefile			\
-		files/osf/Makefile			\
 		doc/Makefile				\
 		examples/Makefile			\
 		])
diff --git a/files/Makefile.am b/files/Makefile.am
deleted file mode 100644
index 7deec1512977..000000000000
--- a/files/Makefile.am
+++ /dev/null
@@ -1,3 +0,0 @@
-SUBDIRS =	nftables \
-		examples \
-		osf
diff --git a/files/examples/Makefile.am b/files/examples/Makefile.am
deleted file mode 100644
index b29e9f614203..000000000000
--- a/files/examples/Makefile.am
+++ /dev/null
@@ -1,5 +0,0 @@
-pkgdocdir = ${docdir}/examples
-dist_pkgdoc_SCRIPTS = ct_helpers.nft \
-		load_balancing.nft \
-		secmark.nft \
-		sets_and_maps.nft
diff --git a/files/nftables/Makefile.am b/files/nftables/Makefile.am
deleted file mode 100644
index ee88dd896743..000000000000
--- a/files/nftables/Makefile.am
+++ /dev/null
@@ -1,14 +0,0 @@
-dist_pkgdata_DATA =	all-in-one.nft		\
-			arp-filter.nft		\
-			bridge-filter.nft	\
-			inet-filter.nft		\
-			inet-nat.nft		\
-			ipv4-filter.nft		\
-			ipv4-mangle.nft		\
-			ipv4-nat.nft		\
-			ipv4-raw.nft		\
-			ipv6-filter.nft		\
-			ipv6-mangle.nft		\
-			ipv6-nat.nft		\
-			ipv6-raw.nft		\
-			netdev-ingress.nft
diff --git a/files/osf/Makefile.am b/files/osf/Makefile.am
deleted file mode 100644
index d80196dd7388..000000000000
--- a/files/osf/Makefile.am
+++ /dev/null
@@ -1,2 +0,0 @@
-pkgsysconfdir = ${sysconfdir}/nftables/osf
-dist_pkgsysconf_DATA = pf.os
-- 
2.41.0

