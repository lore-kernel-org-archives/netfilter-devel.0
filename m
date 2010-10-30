From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/7] Add .gitignore files
Date: Sun, 31 Oct 2010 00:49:41 +0200
Message-ID: <1288478982-6758-8-git-send-email-jengelh@medozas.de>
References: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44524 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab0J3Wtw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:49:52 -0400
In-Reply-To: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore     |   18 ++++++++++++++++++
 src/.gitignore |    6 ++++++
 2 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 src/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..444c4b3
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,18 @@
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
+/ylwrap
diff --git a/src/.gitignore b/src/.gitignore
new file mode 100644
index 0000000..6e6763d
--- /dev/null
+++ b/src/.gitignore
@@ -0,0 +1,6 @@
+/conntrack
+/conntrackd
+
+/read_config_lex.c
+/read_config_yy.c
+/read_config_yy.h
-- 
1.7.1

