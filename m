From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/6] build: use AC_CONFIG_AUX_DIR and stash away tools
Date: Fri, 30 Dec 2011 02:34:57 +0100
Message-ID: <1325208902-2014-3-git-send-email-jengelh@medozas.de>
References: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40846 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1L3BfJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:35:09 -0500
In-Reply-To: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore   |   12 ++----------
 configure.ac |    1 +
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/.gitignore b/.gitignore
index deed221..8e082d2 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,16 +23,8 @@ Makefile.in
 
 /aclocal.m4
 /autom4te.cache/
-/compile
-/config.guess
-/config.h*
-/config.log
-/config.status
-/config.sub
+/build-aux/
+/config.*
 /configure
-/depcomp
-/install-sh
 /libtool
-/ltmain.sh
-/missing
 /stamp-h1
diff --git a/configure.ac b/configure.ac
index 298d551..5679098 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,6 +5,7 @@ AC_INIT([iptables], [1.4.12.1])
 libxtables_vcurrent=7
 libxtables_vage=0
 
+AC_CONFIG_AUX_DIR([build-aux])
 AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 AC_PROG_INSTALL
-- 
1.7.3.4

