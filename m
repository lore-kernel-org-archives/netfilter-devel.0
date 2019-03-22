Return-Path: <SRS0=IzLZ=RZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02489C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Mar 2019 18:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D36032175B
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Mar 2019 18:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfCVSbP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 14:31:15 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42900 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbfCVSbP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 14:31:15 -0400
Received: from localhost ([::1]:55990 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h7Owi-0002jN-Cr; Fri, 22 Mar 2019 19:31:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Wenle Chen <solachenclever@hotmail.com>
Subject: [iptables PATCH] extensions: Install symlinks as such
Date:   Fri, 22 Mar 2019 19:31:06 +0100
Message-Id: <20190322183106.14668-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fake shared objects which are actually symlinks to others are installed
using 'install' tool which follows them and therefore installs a copy of
the file they point at. Fix this by introducing special handling for
them in install target.

Reported-by: Wenle Chen <solachenclever@hotmail.com>
Fixes: 269655d54e22f ("build: remove symlink-only extensions from static object list")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/GNUmakefile.in | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index c0d73cd28c038..0842a55354e4b 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -55,11 +55,12 @@ pfb_objs      := $(patsubst %,libebt_%.o,${pfb_build_mod})
 pfa_objs      := $(patsubst %,libarpt_%.o,${pfa_build_mod})
 pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
 pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
-pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_symlinks})
+pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod})
 pfb_solibs    := $(patsubst %,libebt_%.so,${pfb_build_mod})
 pfa_solibs    := $(patsubst %,libarpt_%.so,${pfa_build_mod})
 pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
 pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
+pfx_symlink_files := $(patsubst %,libxt_%.so,${pfx_symlinks})
 
 
 #
@@ -72,8 +73,9 @@ targets_install :=
 @ENABLE_STATIC_TRUE@ libext_arpt_objs := ${pfa_objs}
 @ENABLE_STATIC_TRUE@ libext4_objs := ${pf4_objs}
 @ENABLE_STATIC_TRUE@ libext6_objs := ${pf6_objs}
-@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs} ${pfa_solibs}
+@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs} ${pfa_solibs} ${pfx_symlink_files}
 @ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs} ${pfa_solibs}
+@ENABLE_STATIC_FALSE@ symlinks_install := ${pfx_symlink_files}
 
 .SECONDARY:
 
@@ -81,9 +83,14 @@ targets_install :=
 
 all: ${targets}
 
-install: ${targets_install}
+install: ${targets_install} ${symlinks_install}
 	@mkdir -p "${DESTDIR}${xtlibdir}";
-	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
+	if test -n "${targets_install}"; then \
+		install -pm0755 ${targets_install} "${DESTDIR}${xtlibdir}/"; \
+	fi;
+	if test -n "${symlinks_install}"; then \
+		cp -P ${symlinks_install} "${DESTDIR}${xtlibdir}/"; \
+	fi;
 
 clean:
 	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initextb.c initexta.c;
-- 
2.21.0

