From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/4] build: use AC_CONFIG_AUX_DIR and stash away tools
Date: Sat, 17 Dec 2011 16:37:08 +0100
Message-ID: <1324136231-25643-3-git-send-email-jengelh@medozas.de>
References: <1324136231-25643-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59768 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab1LQPhP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:37:15 -0500
In-Reply-To: <1324136231-25643-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore   |    6 +-----
 configure.ac |    1 +
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/.gitignore b/.gitignore
index 44f7088..9a7d86c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -9,14 +9,10 @@ Makefile.in
 
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
 
 /doxygen.cfg
diff --git a/configure.ac b/configure.ac
index a9fde6c..130ca75 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,7 @@
 dnl Process this file with autoconf to create configure.
 
 AC_INIT([libmnl], [1.0.1])
+AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADERS([config.h])
-- 
1.7.3.4

