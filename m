From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 9/9] Add .gitignore files
Date: Sun, 31 Oct 2010 00:07:33 +0200
Message-ID: <1288476454-18451-10-git-send-email-jengelh@medozas.de>
References: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46316 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab0J3WHq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:07:46 -0400
In-Reply-To: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore       |   19 +++++++++++++++++++
 m4/.gitignore    |    2 ++
 utils/.gitignore |    1 +
 3 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 m4/.gitignore
 create mode 100644 utils/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..6f5ca1f
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,19 @@
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
+/*.pc
diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..64d9bbc
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1,2 @@
+/libtool.m4
+/lt*.m4
diff --git a/utils/.gitignore b/utils/.gitignore
new file mode 100644
index 0000000..ddd4de3
--- /dev/null
+++ b/utils/.gitignore
@@ -0,0 +1 @@
+/iftest
-- 
1.7.1

