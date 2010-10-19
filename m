From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/8] build: resolve autoreconf/libtoolize suggestions
Date: Tue, 19 Oct 2010 18:12:15 +0200
Message-ID: <1287504742-12922-3-git-send-email-jengelh@medozas.de>
References: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53567 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab0JSQM3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:29 -0400
In-Reply-To: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libtoolize: Consider adding "AC_CONFIG_MACRO_DIR([m4])" to configure.ac and
libtoolize: rerunning libtoolize, to keep the correct libtool macros in-tree.
libtoolize: Consider adding "-I m4" to ACLOCAL_AMFLAGS in Makefile.am.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am   |    2 ++
 configure.ac  |    1 +
 m4/.gitignore |    2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)
 create mode 100644 m4/.gitignore

diff --git a/Makefile.am b/Makefile.am
index 7225f86..acd3d14 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,5 +1,7 @@
 ## Process this file with automake to produce Makefile.in
 
+ACLOCAL_AMFLAGS = -I m4
+
 include $(top_srcdir)/Make_global.am
 
 if ! WITH_KBUILDDIR
diff --git a/configure.ac b/configure.ac
index 7622ac4..34f0889 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,7 @@
 dnl Boilerplate
 AC_INIT([ipset], [5.0], [kadlec@blackhole.kfki.hu])
 AC_CANONICAL_SYSTEM
+AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADER([config.h])
 AM_INIT_AUTOMAKE([-Wall -Werror foreign])
 
diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..64d9bbc
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1,2 @@
+/libtool.m4
+/lt*.m4
-- 
1.7.1

