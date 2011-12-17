From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/6] build: make distcheck work and use POSIX mode for tarball generation
Date: Sat, 17 Dec 2011 16:35:08 +0100
Message-ID: <1324136109-31504-7-git-send-email-jengelh@medozas.de>
References: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59374 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1LQPfU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:35:20 -0500
In-Reply-To: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 Makefile.am                  |    2 ++
 configure.ac                 |    2 +-
 include/libipset/Makefile.am |    2 ++
 src/Makefile.am              |    2 +-
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 513d641..c40f88e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -75,3 +75,5 @@ tidy: distclean modules_clean
 	find . -name '*~' -delete
 
 .PHONY: modules modules_instal modules_clean update_includes tests
+
+DISTCHECK_CONFIGURE_FLAGS = --with-kmod=no
diff --git a/configure.ac b/configure.ac
index acae162..56a2dff 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@ AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADER([config.h])
-AM_INIT_AUTOMAKE([foreign subdir-objects])
+AM_INIT_AUTOMAKE([foreign subdir-objects tar-pax])
 
 dnl Shortcut: Linux supported alone
 case "$host" in
diff --git a/include/libipset/Makefile.am b/include/libipset/Makefile.am
index d15fedd..2bb353b 100644
--- a/include/libipset/Makefile.am
+++ b/include/libipset/Makefile.am
@@ -16,3 +16,5 @@ pkginclude_HEADERS = \
 	types.h \
 	ui.h \
 	utils.h
+
+EXTRA_DIST = debug.h icmp.h icmpv6.h
diff --git a/src/Makefile.am b/src/Makefile.am
index 8ba441d..5296047 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -17,7 +17,7 @@ ipset_SOURCES	= ipset.c \
 ipset_LDADD	= ../lib/libipset.la
 AM_LDFLAGS	= -static
 
-man_MANS = ipset.8
+dist_man_MANS = ipset.8
 
 #%.o: %.c
 #	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} ${CFLAGS} -o $@ -c $<
-- 
1.7.3.4

