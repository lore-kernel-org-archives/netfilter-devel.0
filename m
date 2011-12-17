From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: use AC_CONFIG_AUX_DIR and stash away tools
Date: Sat, 17 Dec 2011 04:04:44 +0100
Message-ID: <1324091086-6074-3-git-send-email-jengelh@medozas.de>
References: <1324091086-6074-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51278 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab1LQDEw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Dec 2011 22:04:52 -0500
In-Reply-To: <1324091086-6074-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore   |    6 +-----
 configure.ac |    1 +
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/.gitignore b/.gitignore
index b899b3b..6bf816e 100644
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
 /stamp-h1
 
 /*.pc
diff --git a/configure.ac b/configure.ac
index 25a5b41..a3a6543 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,7 @@
 dnl Process this file with autoconf to create configure.
 
 AC_INIT(libnfnetlink, 1.0.0)
+AC_CONFIG_AUX_DIR([build-aux])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CANONICAL_HOST
 
-- 
1.7.3.4

