From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/6] build: process include/libipset/
Date: Sat, 17 Dec 2011 16:35:05 +0100
Message-ID: <1324136109-31504-4-git-send-email-jengelh@medozas.de>
References: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59370 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1LQPfS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:35:18 -0500
In-Reply-To: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We need to visit that directory, otherwise `make install` is
incomplete and `make distcheck` fails.
---
 Makefile.am                  |    2 +-
 configure.ac                 |    2 +-
 include/Makefile.am          |    1 -
 include/libipset/Makefile.am |    3 +--
 4 files changed, 3 insertions(+), 5 deletions(-)
 delete mode 100644 include/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index 09ba4d9..513d641 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -20,7 +20,7 @@ else
 V=0
 endif
 
-SUBDIRS		= lib src
+SUBDIRS		= include/libipset lib src
 
 modules_sparse:
 if WITH_KMOD
diff --git a/configure.ac b/configure.ac
index e277d05..acae162 100644
--- a/configure.ac
+++ b/configure.ac
@@ -161,5 +161,5 @@ fi
 dnl Checks for library functions.
 
 dnl Generate output
-AC_CONFIG_FILES([Makefile lib/Makefile src/Makefile])
+AC_CONFIG_FILES([Makefile include/libipset/Makefile lib/Makefile src/Makefile])
 AC_OUTPUT
diff --git a/include/Makefile.am b/include/Makefile.am
deleted file mode 100644
index 2c4eb5c..0000000
--- a/include/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-SUBDIRS = libipset
diff --git a/include/libipset/Makefile.am b/include/libipset/Makefile.am
index b17293c..3c21d0f 100644
--- a/include/libipset/Makefile.am
+++ b/include/libipset/Makefile.am
@@ -6,11 +6,10 @@ pkginclude_HEADERS = \
 	linux_ip_set_hash.h \
 	mnl.h \
 	nf_inet_addr.h \
-	nlattr.h \
 	parse.h \
 	pfxlen.h \
 	print.h \
-	session.h
+	session.h \
 	transport.h \
 	types.h \
 	ui.h \
-- 
1.7.3.4

