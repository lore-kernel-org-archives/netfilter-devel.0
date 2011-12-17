From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: use AC_CONFIG_AUX_DIR and stash away tools
Date: Sat, 17 Dec 2011 16:36:33 +0100
Message-ID: <1324136195-7784-3-git-send-email-jengelh@medozas.de>
References: <1324136195-7784-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59451 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab1LQPgj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:36:39 -0500
In-Reply-To: <1324136195-7784-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore   |    6 +-----
 configure.ac |    1 +
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/.gitignore b/.gitignore
index 68bfe37..a0fc139 100644
--- a/.gitignore
+++ b/.gitignore
@@ -8,14 +8,10 @@ Makefile.in
 
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
 
 /doxygen.cfg
 /libnetfilter_queue.pc
diff --git a/configure.ac b/configure.ac
index 19d12e9..afb458e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,7 @@
 dnl Process this file with autoconf to create configure.
 
 AC_INIT([libnetfilter_queue], [1.0.0])
+AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 
-- 
1.7.3.4

