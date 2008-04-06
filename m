From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 03/24] Makefile: add a "tarball" target
Date: Sun,  6 Apr 2008 17:27:00 +0200
Message-ID: <75545011b714aceca71a06d3f356b49201945b41.1207495183.git.jengelh@computergmbh.de>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56467 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYDFP1X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:27:23 -0400
In-Reply-To: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
References: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 Makefile.am |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index a0f33c6..112b552 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -93,3 +93,11 @@ ip6tables.8: ${srcdir}/ip6tables.8.in extensions/matches6.man extensions/targets
 
 extensions/%:
 	${MAKE} ${AM_MAKEFLAGS} -C $(@D) $(@F)
+
+.PHONY: tarball
+tarball:
+	rm -Rf /tmp/xtables-${PACKAGE_VERSION};
+	pushd ${top_srcdir} && git-archive --prefix=xtables-${PACKAGE_VERSION}/ HEAD | tar -C /tmp -x && popd;
+	pushd /tmp/xtables-${PACKAGE_VERSION} && ./autogen.sh && popd;
+	tar -C /tmp -cjf xtables-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root xtables-${PACKAGE_VERSION}/;
+	rm -Rf /tmp/xtables-${PACKAGE_VERSION};
-- 
1.5.5.rc3

