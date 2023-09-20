Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0273FCE79CE
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 13:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbjITNeh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbjITNeg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 09:34:36 -0400
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51BA9E;
        Wed, 20 Sep 2023 06:34:28 -0700 (PDT)
From:   Sam James <sam@gentoo.org>
To:     netfilter@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Sam James <sam@gentoo.org>
Subject: [PATCH] build: Fix double-prefix w/ pkgconfig
Date:   Wed, 20 Sep 2023 14:34:17 +0100
Message-ID: <20230920133418.1893675-1-sam@gentoo.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

First, apologies - 326932be0c4f47756f9809cad5a103ac310f700d clearly introduced
a double prefix and I can't tell you what my thought process was 9 months ago
but it was obviously wrong (my guess is I rebased some old patch and didn't
think properly, no idea).

Anyway, let's just drop the extraneous pkgconfigdir definition and use the
proper one from pkg.m4 via PKG_INSTALLDIR.

Fixes: 326932be0c4f47756f9809cad5a103ac310f700d
Signed-off-by: Sam James <sam@gentoo.org>
---
 configure.ac    | 1 +
 lib/Makefile.am | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index cad93af..6c26645 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,6 +14,7 @@ LT_CONFIG_LTDL_DIR([libltdl])
 LTDL_INIT([nonrecursive])
 
 PKG_PROG_PKG_CONFIG
+PKG_INSTALLDIR
 
 dnl Shortcut: Linux supported alone
 case "$host" in
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 50d937d..a9edf95 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -46,7 +46,6 @@ EXTRA_libipset_la_SOURCES = \
 
 EXTRA_DIST = $(IPSET_SETTYPE_LIST) libipset.map
 
-pkgconfigdir = $(prefix)/$(libdir)/pkgconfig
 pkgconfig_DATA = libipset.pc
 
 dist_man_MANS = libipset.3
-- 
2.42.0

