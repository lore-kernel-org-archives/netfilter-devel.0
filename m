From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1] Makefile.am: use PACKAGE_TARNAME
Date: Thu, 17 Apr 2008 10:57:01 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804171035200.6550@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36821 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYDQI5D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:57:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


commit 124afbbc3c90ac7895ab75684e581e2cbd6d887b
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Apr 17 10:32:13 2008 +0200

    Makefile.am: use PACKAGE_TARNAME
---
 Makefile.am |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index dc45b66..49edbf8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -97,8 +97,8 @@ extensions/%:
 
 .PHONY: tarball
 tarball:
-	rm -Rf /tmp/xtables-${PACKAGE_VERSION};
-	pushd ${top_srcdir} && git-archive --prefix=xtables-${PACKAGE_VERSION}/ HEAD | tar -C /tmp -x && popd;
-	pushd /tmp/xtables-${PACKAGE_VERSION} && ./autogen.sh && popd;
-	tar -C /tmp -cjf xtables-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root xtables-${PACKAGE_VERSION}/;
-	rm -Rf /tmp/xtables-${PACKAGE_VERSION};
+	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
+	pushd ${top_srcdir} && git-archive --prefix=${PACKAGE_TARNAME}-${PACKAGE_VERSION}/ HEAD | tar -C /tmp -x && popd;
+	pushd /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION} && ./autogen.sh && popd;
+	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
+	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
