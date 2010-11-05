From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] build: use AC_OUTPUT
Date: Fri,  5 Nov 2010 18:56:13 +0100
Message-ID: <1288979774-18386-3-git-send-email-jengelh@medozas.de>
References: <1288979774-18386-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55360 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0KER4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:56:22 -0400
In-Reply-To: <1288979774-18386-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index f73f323..3831697 100644
--- a/configure.ac
+++ b/configure.ac
@@ -23,4 +23,6 @@ dnl Dependencies
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 
 dnl Output the makefiles
-AC_OUTPUT(Makefile include/Makefile include/libnetfilter_queue/Makefile src/Makefile utils/Makefile libnetfilter_queue.pc doxygen.cfg)
+AC_CONFIG_FILES([Makefile include/Makefile include/libnetfilter_queue/Makefile
+	src/Makefile utils/Makefile libnetfilter_queue.pc doxygen.cfg])
+AC_OUTPUT
-- 
1.7.1

