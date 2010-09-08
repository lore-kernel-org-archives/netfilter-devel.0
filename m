From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/7] Add .gitignore
Date: Thu,  9 Sep 2010 01:32:42 +0200
Message-ID: <1283988763-1577-8-git-send-email-jengelh@medozas.de>
References: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48419 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab0IHXcw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:32:52 -0400
In-Reply-To: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

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
-- 
1.7.1

