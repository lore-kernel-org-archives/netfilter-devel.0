From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/10] Update .gitignore
Date: Sun, 31 Oct 2010 00:11:15 +0200
Message-ID: <1288476676-32749-11-git-send-email-jengelh@medozas.de>
References: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49990 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab0J3WL3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:11:29 -0400
In-Reply-To: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore       |   33 ++++++++++++++++++---------------
 utils/.gitignore |    1 +
 2 files changed, 19 insertions(+), 15 deletions(-)
 create mode 100644 utils/.gitignore

diff --git a/.gitignore b/.gitignore
index 99e943d..dbd9ac7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,17 +1,20 @@
-doxygen.cfg
-doxygen
+.deps
+.libs
+Makefile
+Makefile.in
+*.o
+*.la
+*.lo
 
-config.guess
-config.log
-config.sub
-config.status
-configure
-autom4te.cache
-libtool
-ltmain.sh
-missing
-install-sh
-depcomp
-aclocal.m4
+/aclocal.m4
+/autom4te.cache
+/config.*
+/configure
+/depcomp
+/install-sh
+/libtool
+/ltmain.sh
+/missing
 
-libnetfilter_queue.pc
+/doxygen.cfg
+/libnetfilter_queue.pc
diff --git a/utils/.gitignore b/utils/.gitignore
new file mode 100644
index 0000000..10fe6e9
--- /dev/null
+++ b/utils/.gitignore
@@ -0,0 +1 @@
+/nfqnl_test
-- 
1.7.1

