From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] build: trigger reconfigure when extensions/GNUmakefile.in changes
Date: Tue, 17 Feb 2009 15:08:31 +0100
Message-ID: <1234879712-24566-2-git-send-email-jengelh@medozas.de>
References: <1234879712-24566-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41273 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZBQOIe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:08:34 -0500
In-Reply-To: <1234879712-24566-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 41dc280..b8859ac 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -108,7 +108,8 @@ tarball:
 	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
-config.status: include/xtables.h.in include/iptables/internal.h.in
+config.status: extensions/GNUmakefile.in \
+	include/xtables.h.in include/iptables/internal.h.in
 
 # ldconfig may fail when we are not root (as is the case in build systems)
 # so add appropriate protection that it does not let `make` fail.
-- 
1.6.1.3

