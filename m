From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: fix dependency tracking for xtables.h.in
Date: Tue, 12 Aug 2008 19:26:26 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808121925530.10358@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38058 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYHLX02 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:26:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit fe109d4aad6408c6ee608a86207f804570ceaacd
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Aug 12 19:24:34 2008 -0400

build: fix dependency tracking for xtables.h.in

For files to be correctly regenerated after the .in file has been
touched, an explicit extra dependency is needed in the Makefile.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 48e012e..0355e2e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -105,3 +105,5 @@ tarball:
 	pushd /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION} && ./autogen.sh && popd;
 	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
+
+config.status: include/xtables.h.in

