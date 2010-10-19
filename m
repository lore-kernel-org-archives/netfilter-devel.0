From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 8/8] Add .gitignore files
Date: Tue, 19 Oct 2010 18:12:21 +0200
Message-ID: <1287504742-12922-9-git-send-email-jengelh@medozas.de>
References: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53578 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab0JSQMf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:35 -0400
In-Reply-To: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore     |   20 ++++++++++++++++++++
 src/.gitignore |    1 +
 2 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 src/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..9f6660e
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,20 @@
+*~
+*.la
+*.lo
+*.o
+.deps
+.libs
+Makefile
+Makefile.in
+
+/aclocal.m4
+/autom4te.cache
+/compile
+/config.*
+/configure
+/depcomp
+/install-sh
+/libtool
+/ltmain.sh
+/missing
+/stamp-h1
diff --git a/src/.gitignore b/src/.gitignore
new file mode 100644
index 0000000..6166aba
--- /dev/null
+++ b/src/.gitignore
@@ -0,0 +1 @@
+/ipset
-- 
1.7.1

