From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: use AC_CONFIG_AUX_DIR and stash away tools
Date: Sat, 17 Dec 2011 16:39:20 +0100
Message-ID: <1324136362-16840-3-git-send-email-jengelh@medozas.de>
References: <1324136362-16840-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59825 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab1LQPj0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:39:26 -0500
In-Reply-To: <1324136362-16840-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore   |    5 +----
 configure.ac |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/.gitignore b/.gitignore
index cf1c1da..f1348b4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -14,11 +14,8 @@ Makefile.in
 # build system
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
 /stamp-h1
diff --git a/configure.ac b/configure.ac
index e8f8427..5bb032e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 AC_PREREQ([2.50])
 AC_INIT([ulogd], [2.0.0beta4])
-
+AC_CONFIG_AUX_DIR([build-aux])
 AM_INIT_AUTOMAKE([-Wall foreign dist-bzip2 1.10b])
 AC_CONFIG_HEADER([config.h])
 AC_CONFIG_MACRO_DIR([m4])
-- 
1.7.3.4

