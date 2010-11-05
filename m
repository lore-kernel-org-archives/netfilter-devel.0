From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] build: use AC_OUTPUT
Date: Fri,  5 Nov 2010 18:34:13 +0100
Message-ID: <1288978456-15380-2-git-send-email-jengelh@medozas.de>
References: <1288978456-15380-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58452 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab0KEReS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:34:18 -0400
In-Reply-To: <1288978456-15380-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 91fd6d7..a7682ea 100644
--- a/configure.ac
+++ b/configure.ac
@@ -22,4 +22,6 @@ dnl--------------------------------
 
 
 dnl Output the makefile
-AC_OUTPUT(Makefile src/Makefile include/Makefile include/libnfnetlink/Makefile utils/Makefile libnfnetlink.pc)
+AC_CONFIG_FILES([Makefile src/Makefile include/Makefile
+	include/libnfnetlink/Makefile utils/Makefile libnfnetlink.pc])
+AC_OUTPUT
-- 
1.7.1

