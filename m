Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64457C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 11:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44C30207ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 11:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgFILHm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jun 2020 07:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgFILHl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jun 2020 07:07:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503B2C05BD1E
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2020 04:07:40 -0700 (PDT)
Received: from localhost ([::1]:52708 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1jic6S-0000Og-V5; Tue, 09 Jun 2020 13:07:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [iptables PATCH] build: Fix for failing 'make uninstall'
Date:   Tue,  9 Jun 2020 13:07:28 +0200
Message-Id: <20200609110728.12682-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support for uninstalling is severely broken:

- extensions/GNUmakefile.in defines an 'install' target but lacks a
  respective 'uninstall' one, causing 'make uninstall' abort with an
  error message.

- iptables/Makefile.am defines an 'install-exec-hook' to create the
  binary symlinks which are left in place after 'make uninstall'.

Fix these problems by defining respective targets containing code copied
from automake-generated uninstall targets.

While being at it, add a few more uninstall-hooks removing custom
directories created by 'make install' if they are empty afterwards.

Reported-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/GNUmakefile.in | 15 ++++++++++++++-
 include/Makefile.am       |  5 +++++
 iptables/Makefile.am      | 23 +++++++++++++++++++++++
 utils/Makefile.am         |  5 +++++
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 0842a55354e4b..956ccb38b2ab9 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -79,7 +79,7 @@ targets_install :=
 
 .SECONDARY:
 
-.PHONY: all install clean distclean FORCE
+.PHONY: all install uninstall clean distclean FORCE
 
 all: ${targets}
 
@@ -92,6 +92,19 @@ install: ${targets_install} ${symlinks_install}
 		cp -P ${symlinks_install} "${DESTDIR}${xtlibdir}/"; \
 	fi;
 
+uninstall:
+	dir=${DESTDIR}${xtlibdir}; { \
+		test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; \
+	} || { \
+		test -z "${targets_install}" || ( \
+			cd "$$dir" && rm -f ${targets_install} \
+		); \
+		test -z "${symlinks_install}" || ( \
+			cd "$$dir" && rm -f ${symlinks_install} \
+		); \
+		rmdir -p --ignore-fail-on-non-empty "$$dir"; \
+	}
+
 clean:
 	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initextb.c initexta.c;
 	rm -f .*.d .*.dd;
diff --git a/include/Makefile.am b/include/Makefile.am
index e69512092253a..ea34c2fef0d98 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -10,3 +10,8 @@ endif
 nobase_include_HEADERS += \
 	libiptc/ipt_kernel_headers.h libiptc/libiptc.h \
 	libiptc/libip6tc.h libiptc/libxtc.h libiptc/xtcshared.h
+
+uninstall-hook:
+	dir=${includedir}/libiptc; { \
+		test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; \
+	} || rmdir -p --ignore-fail-on-non-empty "$$dir"
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 2024dbf5cb88c..bab094b7c6aa9 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -111,3 +111,26 @@ install-exec-hook:
 	for i in ${v6_sbin_links}; do ${LN_S} -f xtables-legacy-multi "${DESTDIR}${sbindir}/$$i"; done;
 	for i in ${x_sbin_links}; do ${LN_S} -f xtables-nft-multi "${DESTDIR}${sbindir}/$$i"; done;
 	${LN_S} -f iptables-apply "${DESTDIR}${sbindir}/ip6tables-apply"
+
+uninstall-hook:
+	dir=${DESTDIR}${bindir}; { \
+		test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; \
+	} || { \
+		test -z "${vx_bin_links}" || ( \
+			cd "$$dir" && rm -f ${vx_bin_links} \
+		) \
+	}
+	dir=${DESTDIR}${sbindir}; { \
+		test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; \
+	} || { \
+		test -z "${v4_sbin_links}" || ( \
+			cd "$$dir" && rm -f ${v4_sbin_links} \
+		); \
+		test -z "${v6_sbin_links}" || ( \
+			cd "$$dir" && rm -f ${v6_sbin_links} \
+		); \
+		test -z "${x_sbin_links}" || ( \
+			cd "$$dir" && rm -f ${x_sbin_links} \
+		); \
+		( cd "$$dir" && rm -f ip6tables-apply ); \
+	}
diff --git a/utils/Makefile.am b/utils/Makefile.am
index d09a69749b85f..42bd973730194 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -14,6 +14,11 @@ sbin_PROGRAMS += nfnl_osf
 pkgdata_DATA += pf.os
 
 nfnl_osf_LDADD = ${libnfnetlink_LIBS}
+
+uninstall-hook:
+	dir=${DESTDIR}${pkgdatadir}; { \
+		test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; \
+	} || rmdir -p --ignore-fail-on-non-empty "$$dir"
 endif
 
 if ENABLE_BPFC
-- 
2.27.0

