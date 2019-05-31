Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B11EC04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 06:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E307255FA
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 06:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEaGtr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 02:49:47 -0400
Received: from a3.inai.de ([88.198.85.195]:58896 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfEaGtr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 02:49:47 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id 19B753B73763; Fri, 31 May 2019 08:49:46 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id 289C43BB6970;
        Fri, 31 May 2019 08:49:38 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH] build: avoid unnecessary rebuild of iptables when rerunning configure
Date:   Fri, 31 May 2019 08:49:38 +0200
Message-Id: <20190531064938.11923-1-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Running configure always touches xtables/xtables-version.h, which
causes parts to rebuild even when the configuration has not changed.
(`./configure; make; ./configure; make;`).

This can be avoided if the AC_CONFIG_FILES mechanism is replaced by
one that does a compare and leaves an existing xtables-version.h
unmodified if the sed result stays the same when it re-runs.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 Makefile.am  | 8 ++++++--
 configure.ac | 1 -
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 799bf8b8..2e29bb5d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -29,5 +29,9 @@ tarball:
 	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
-config.status: extensions/GNUmakefile.in \
-	include/xtables-version.h.in
+config.status: extensions/GNUmakefile.in
+
+include/xtables-version.h: include/xtables-version.h.in
+	${AM_V_GEN} sed -e 's|@@libxtables_vmajor@@|${libxtables_vmajor}|g' <$< >include/.xtables-version.tmp; \
+	cmp include/xtables-version.h include/.xtables-version.tmp || \
+		mv include/.xtables-version.tmp include/xtables-version.h
diff --git a/configure.ac b/configure.ac
index c922f7a0..2767c911 100644
--- a/configure.ac
+++ b/configure.ac
@@ -245,7 +245,6 @@ AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	libiptc/Makefile libiptc/libiptc.pc
 	libiptc/libip4tc.pc libiptc/libip6tc.pc
 	libxtables/Makefile utils/Makefile
-	include/xtables-version.h
 	iptables/xtables-monitor.8
 	utils/nfnl_osf.8
 	utils/nfbpf_compile.8])
-- 
2.21.0

