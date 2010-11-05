From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: use AC_OUTPUT
Date: Fri,  5 Nov 2010 18:37:30 +0100
Message-ID: <1288978652-15892-3-git-send-email-jengelh@medozas.de>
References: <1288978652-15892-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42074 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab0KERhh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:37:37 -0400
In-Reply-To: <1288978652-15892-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 18e546f..d0145bd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -63,5 +63,8 @@ if test ! -z "$libdir"; then
 fi
 
 dnl Output the makefile
-AC_OUTPUT(Makefile src/Makefile include/Makefile utils/Makefile qa/Makefile include/libnetfilter_conntrack/Makefile include/internal/Makefile src/conntrack/Makefile src/expect/Makefile libnetfilter_conntrack.pc doxygen.cfg)
-
+AC_CONFIG_FILES([Makefile src/Makefile include/Makefile utils/Makefile
+	qa/Makefile include/libnetfilter_conntrack/Makefile
+	include/internal/Makefile src/conntrack/Makefile src/expect/Makefile
+	libnetfilter_conntrack.pc doxygen.cfg])
+AC_OUTPUT
-- 
1.7.1

