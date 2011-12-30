From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/6] Update .gitignore
Date: Fri, 30 Dec 2011 02:34:58 +0100
Message-ID: <1325208902-2014-4-git-send-email-jengelh@medozas.de>
References: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40847 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab1L3BfK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:35:10 -0500
In-Reply-To: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Split off extensions/.gitignore.
---
 .gitignore            |    9 ---------
 extensions/.gitignore |    9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)
 create mode 100644 extensions/.gitignore

diff --git a/.gitignore b/.gitignore
index 8e082d2..b7c3dfb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,9 +1,6 @@
-.*.d
-.*.dd
 *.a
 *.la
 *.lo
-*.oo
 *.so
 *.o
 .deps/
@@ -12,12 +9,6 @@
 Makefile
 Makefile.in
 
-/extensions/GNUmakefile
-/extensions/initext.c
-/extensions/initext?.c
-/extensions/matches?.man
-/extensions/targets?.man
-
 /include/xtables.h
 /include/iptables/internal.h
 
diff --git a/extensions/.gitignore b/extensions/.gitignore
new file mode 100644
index 0000000..2e74faf
--- /dev/null
+++ b/extensions/.gitignore
@@ -0,0 +1,9 @@
+.*.d
+.*.dd
+*.oo
+
+/GNUmakefile
+/initext.c
+/initext?.c
+/matches?.man
+/targets?.man
-- 
1.7.3.4

