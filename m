From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: use AC_CONFIG_AUX_DIR and stash away tools
Date: Sat, 17 Dec 2011 16:35:42 +0100
Message-ID: <1324136144-12845-3-git-send-email-jengelh@medozas.de>
References: <1324136144-12845-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59404 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1LQPft (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:35:49 -0500
In-Reply-To: <1324136144-12845-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore   |    5 +----
 configure.ac |    1 +
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/.gitignore b/.gitignore
index e683edb..f4938e9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -8,13 +8,10 @@ Makefile.in
 
 /aclocal.m4
 /autom4te.cache/
+/build-aux/
 /config.*
 /configure
-/depcomp
-/install-sh
 /libtool
-/ltmain.sh
-/missing
 
 /doxygen.cfg
 /*.pc
diff --git a/configure.ac b/configure.ac
index eab4a7d..ca133df 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,7 @@
 dnl Process this file with autoconf to create configure.
 
 AC_INIT([libnetfilter_conntrack], [0.9.1])
+AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 
-- 
1.7.3.4

