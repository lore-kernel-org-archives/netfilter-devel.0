From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: use AC_CONFIG_AUX_DIR and stash away tools
Date: Sat, 17 Dec 2011 16:37:55 +0100
Message-ID: <1324136277-10721-3-git-send-email-jengelh@medozas.de>
References: <1324136277-10721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59800 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1LQPiC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:38:02 -0500
In-Reply-To: <1324136277-10721-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore   |    6 +-----
 configure.ac |    2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/.gitignore b/.gitignore
index 7de29d0..928e44b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -8,11 +8,7 @@ Makefile.in
 
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
-/ylwrap
diff --git a/configure.ac b/configure.ac
index 64d354f..3d536d5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,7 +1,7 @@
 AC_INIT(conntrack-tools, 1.0.0, pablo@netfilter.org)
+AC_CONFIG_AUX_DIR([build-aux])
 
 AC_CANONICAL_HOST
-
 AC_CONFIG_MACRO_DIR([m4])
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
 
-- 
1.7.3.4

