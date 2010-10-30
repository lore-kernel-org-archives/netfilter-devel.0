From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/11] Add .gitignore files
Date: Sun, 31 Oct 2010 00:09:59 +0200
Message-ID: <1288476600-29859-12-git-send-email-jengelh@medozas.de>
References: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49932 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab0J3WKP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:10:15 -0400
In-Reply-To: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore       |   20 ++++++++++++++++++++
 utils/.gitignore |    2 ++
 2 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 utils/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..c9550f5
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,20 @@
+.deps
+.libs
+Makefile
+Makefile.in
+*.o
+*.la
+*.lo
+
+/aclocal.m4
+/autom4te.cache
+/config.*
+/configure
+/depcomp
+/install-sh
+/libtool
+/ltmain.sh
+/missing
+
+/doxygen.cfg
+/*.pc
diff --git a/utils/.gitignore b/utils/.gitignore
new file mode 100644
index 0000000..64e4588
--- /dev/null
+++ b/utils/.gitignore
@@ -0,0 +1,2 @@
+/nfulnl_test
+/ulog_test
-- 
1.7.1

