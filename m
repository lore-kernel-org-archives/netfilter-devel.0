From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: prepare make tarball for git 1.6.0
Date: Sat, 16 Aug 2008 15:41:50 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808161541380.8848@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38040 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYHPTlw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:41:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 78be86ecde6cd80c18c1222bde3d8fcea364faac
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Aug 16 15:40:47 2008 -0400

build: prepare make tarball for git 1.6.0

Git 1.6.0 will not have the dashful forms anymore.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 066dc56..742e3de 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -101,7 +101,7 @@ pkgconfig_DATA = xtables.pc
 .PHONY: tarball
 tarball:
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
-	pushd ${top_srcdir} && git-archive --prefix=${PACKAGE_TARNAME}-${PACKAGE_VERSION}/ HEAD | tar -C /tmp -x && popd;
+	pushd ${top_srcdir} && git archive --prefix=${PACKAGE_TARNAME}-${PACKAGE_VERSION}/ HEAD | tar -C /tmp -x && popd;
 	pushd /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION} && ./autogen.sh && popd;
 	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};

