From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/6] build: use AC_CONFIG_AUX_DIR and stash away tools
Date: Sat, 17 Dec 2011 16:35:04 +0100
Message-ID: <1324136109-31504-3-git-send-email-jengelh@medozas.de>
References: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59369 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1LQPfQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:35:16 -0500
In-Reply-To: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore   |    6 +-----
 configure.ac |    1 +
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/.gitignore b/.gitignore
index 07b1ff5..a3168e4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,12 +18,8 @@ modules.order
 
 /aclocal.m4
 /autom4te.cache/
-/compile
+/build-aux/
 /config.*
 /configure
-/depcomp
-/install-sh
 /libtool
-/ltmain.sh
-/missing
 /stamp-h1
diff --git a/configure.ac b/configure.ac
index 692f740..e277d05 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,6 @@
 dnl Boilerplate
 AC_INIT([ipset], [6.10], [kadlec@blackhole.kfki.hu])
+AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADER([config.h])
-- 
1.7.3.4

