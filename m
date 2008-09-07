From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: run ldconfig on `make install`
Date: Sun, 7 Sep 2008 12:26:55 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809071226380.13874@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50211 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYIGQ05 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2008 12:26:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f7cc979c57c1a10033eef94369480cf973b806cd
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Sep 7 12:25:46 2008 -0400

build: run ldconfig on `make install`

Reporeted-by: Brent Clark <brentgclarklist@gmail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 742e3de..5465db6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -107,3 +107,8 @@ tarball:
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
 config.status: include/xtables.h.in
+
+# ldconfig may fail when we are not root (as is the case in build systems)
+# so add appropriate protection that it does not let `make` fail.
+install-exec-hook:
+	-/sbin/ldconfig || :;


