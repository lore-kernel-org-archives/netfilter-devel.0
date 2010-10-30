From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/9] build: use AC_CONFIG_MACRO_DIR as directed
Date: Sun, 31 Oct 2010 00:07:29 +0200
Message-ID: <1288476454-18451-6-git-send-email-jengelh@medozas.de>
References: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46298 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab0J3WHm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:07:42 -0400
In-Reply-To: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libtoolize: Consider adding "AC_CONFIG_MACRO_DIR([m4])" to configure.ac and
libtoolize: rerunning libtoolize, to keep the correct libtool macros in-tree.
libtoolize: Consider adding "-I m4" to ACLOCAL_AMFLAGS in Makefile.am.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am  |    2 ++
 configure.ac |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 4c4400a..95d1df8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,5 +1,7 @@
 include $(top_srcdir)/Make_global.am
 
+ACLOCAL_AMFLAGS = -I m4
+
 EXTRA_DIST = $(man_MANS)
 
 SUBDIRS = src include utils
diff --git a/configure.ac b/configure.ac
index cc86fe7..b05c7f3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to create configure.
 
 AC_INIT(libnfnetlink, 1.0.0)
-
+AC_CONFIG_MACRO_DIR([m4])
 AC_CANONICAL_SYSTEM
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
-- 
1.7.1

