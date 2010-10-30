From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/7] build: remove statements without effect
Date: Sun, 31 Oct 2010 00:49:38 +0200
Message-ID: <1288478982-6758-5-git-send-email-jengelh@medozas.de>
References: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44517 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab0J3Wtt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:49:49 -0400
In-Reply-To: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am  |    4 ----
 configure.ac |    4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 23f646c..afb4595 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -9,9 +9,5 @@ SUBDIRS   = extensions src
 DIST_SUBDIRS = include src extensions
 LIBS = @LIBNETFILTER_CONNTRACK_LIBS@
 
-$(OBJECTS): libtool
-libtool: $(LIBTOOL_DEPS)
-	$(SHELL) ./config.status --recheck
-
 dist-hook:
 	rm -rf `find $(distdir)/doc -name .svn`
diff --git a/configure.ac b/configure.ac
index f840a00..e068798 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,6 @@
 AC_INIT(conntrack-tools, 0.9.15, pablo@netfilter.org)
 
-AC_CANONICAL_SYSTEM
+AC_CANONICAL_HOST
 
 AC_CONFIG_MACRO_DIR([m4])
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
@@ -12,7 +12,7 @@ AC_PROG_LN_S
 AM_PROG_LEX
 AC_PROG_YACC
 
-case $target in
+case "$host" in
 *-*-linux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
-- 
1.7.1

