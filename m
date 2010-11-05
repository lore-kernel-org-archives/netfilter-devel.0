From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] build: use AC_OUTPUT
Date: Fri,  5 Nov 2010 18:55:20 +0100
Message-ID: <1288979721-18198-3-git-send-email-jengelh@medozas.de>
References: <1288979721-18198-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55338 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab0KERzZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:55:25 -0400
In-Reply-To: <1288979721-18198-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index abd3a17..4a86fae 100644
--- a/configure.ac
+++ b/configure.ac
@@ -24,5 +24,7 @@ dnl Dependencies
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 
 dnl Output the makefile
-AC_OUTPUT(Makefile src/Makefile include/Makefile include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc doxygen.cfg)
-
+AC_CONFIG_FILES([Makefile src/Makefile include/Makefile
+	include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc
+	doxygen.cfg])
+AC_OUTPUT
-- 
1.7.1

