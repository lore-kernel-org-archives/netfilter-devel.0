From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 04/24] Makefile: add a "tarball" target
Date: Tue, 4 Mar 2008 16:53:36 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041653160.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53731 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbYCDPxh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:53:37 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 64b1ca517e1773cc0f42a6cd0a1a5f0a4be267c7
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Mar 3 13:04:07 2008 +0100

    Makefile: add a "tarball" target
---
 Makefile.am |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index a0f33c6..5240635 100644
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
+	tar -C /tmp -cjf xtables-${PACKAGE_VERSION}.tar.bz2 xtables-${PACKAGE_VERSION}/;
+	rm -Rf /tmp/xtables-${PACKAGE_VERSION};
