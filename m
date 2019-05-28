Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CC5C04E84
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 09:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23858208CB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 09:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfE1JEE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 05:04:04 -0400
Received: from a3.inai.de ([88.198.85.195]:37804 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfE1JEE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 05:04:04 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id 0E48B3BB8A9D; Tue, 28 May 2019 11:04:02 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id A030C3BB6EEF;
        Tue, 28 May 2019 11:03:54 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH] build: remove -Wl,--no-as-needed and libiptc.so
Date:   Tue, 28 May 2019 11:03:54 +0200
Message-Id: <20190528090354.10663-1-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Despite the presence of --no-as-needed, the libiptc.so library as
produced inside the openSUSE Build Service has no links to
libip4tc.so or libip6tc.so. I have not looked into why --no-as-needed
is ignored in this instance, but likewise, the situation must have
been like that ever since openSUSE made as-needed a distro-wide
default (gcc 4.8 timeframe or so).

Since I am not aware of any problem reports within SUSE/openSUSE
about this whole situation, it seems safe to assume no one in the
larger scope is still using a bare "-liptc" on the linker command
line and that all parties have moved on to using pkg-config.

Therefore, libiptc.la/so is hereby removed, as are all parts
related to the -Wl,--no-as-needed flag.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac        | 5 -----
 libiptc/Makefile.am | 4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index b94512d7..0a2802ff 100644
--- a/configure.ac
+++ b/configure.ac
@@ -73,11 +73,6 @@ AC_ARG_WITH([xt-lock-name], AS_HELP_STRING([--with-xt-lock-name=PATH],
 	[xt_lock_name="$withval"],
 	[xt_lock_name="/run/xtables.lock"])
 
-libiptc_LDFLAGS2="";
-AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
-	[libiptc_LDFLAGS2="-Wl,--no-as-needed"])
-AC_SUBST([libiptc_LDFLAGS2])
-
 AC_MSG_CHECKING([whether $LD knows -Wl,--no-undefined])
 saved_LDFLAGS="$LDFLAGS";
 LDFLAGS="-Wl,--no-undefined";
diff --git a/libiptc/Makefile.am b/libiptc/Makefile.am
index 638295db..b4a22001 100644
--- a/libiptc/Makefile.am
+++ b/libiptc/Makefile.am
@@ -8,8 +8,8 @@ pkgconfig_DATA      = libiptc.pc libip4tc.pc libip6tc.pc
 lib_LTLIBRARIES     = libip4tc.la libip6tc.la libiptc.la
 libiptc_la_SOURCES  =
 libiptc_la_LIBADD   = libip4tc.la libip6tc.la
-libiptc_la_LDFLAGS  = -version-info 0:0:0 ${libiptc_LDFLAGS2}
+libiptc_la_LDFLAGS  = -version-info 0:0:0
 libip4tc_la_SOURCES = libip4tc.c
 libip4tc_la_LDFLAGS = -version-info 2:0:0
 libip6tc_la_SOURCES = libip6tc.c
-libip6tc_la_LDFLAGS = -version-info 2:0:0 ${libiptc_LDFLAGS2}
+libip6tc_la_LDFLAGS = -version-info 2:0:0
-- 
2.21.0

