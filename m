From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] build: use automake for building
Date: Mon,  3 Oct 2011 22:38:31 +0200
Message-ID: <1317674312-20531-2-git-send-email-jengelh@medozas.de>
References: <1317674312-20531-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: sam@synack.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58317 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195Ab1JCUig (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:38:36 -0400
In-Reply-To: <1317674312-20531-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore   |   15 +++++++++++++++
 Makefile     |   24 ------------------------
 Makefile.am  |    7 +++++++
 autogen.sh   |    3 +++
 configure.ac |   10 ++++++++++
 5 files changed, 35 insertions(+), 24 deletions(-)
 create mode 100644 .gitignore
 delete mode 100644 Makefile
 create mode 100644 Makefile.am
 create mode 100755 autogen.sh
 create mode 100644 configure.ac

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..b4cffa0
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,15 @@
+.deps
+Makefile
+Makefile.in
+*.o
+
+/aclocal.m4
+/autom4te.cache
+/config.*
+/configure
+/depcomp
+/install-sh
+/missing
+/stamp-h1
+
+/snet
diff --git a/Makefile b/Makefile
deleted file mode 100644
index 7da4961..0000000
--- a/Makefile
+++ /dev/null
@@ -1,24 +0,0 @@
-NAME	:= snet
-VERSION	:= 0.1
-SRC	:= $(wildcard *.c)
-
-CC	:= gcc
-RM	:= rm -f
-LN	:= ln
-
-includedir = ../libsnet/include/
-CFLAGS	 := -g -O2
-INCLUDES := -I./$(includedir)
-INCLIBS  := -L../libsnet/lib/
-LIBS     := $$(pkg-config --libs libnl-1) -lsnet
-
-all: $(NAME)
-
-$(NAME): snet.c
-	@echo " CC $@"; $(CC) $(CFLAGS) $(INCLUDES) $(INCLIBS) $(LIBS) -o $@ $<
-
-clean:
-	@echo " RM *~ *.o"; $(RM) *~ *.o
-
-distclean: clean
-	$(RM) $(NAME)
diff --git a/Makefile.am b/Makefile.am
new file mode 100644
index 0000000..937cf35
--- /dev/null
+++ b/Makefile.am
@@ -0,0 +1,7 @@
+# -*- Makefile -*-
+
+AM_CFLAGS = ${libsnet_CFLAGS}
+
+sbin_PROGRAMS = snet
+
+snet_LDADD = ${libsnet_LIBS}
diff --git a/autogen.sh b/autogen.sh
new file mode 100755
index 0000000..cb4930c
--- /dev/null
+++ b/autogen.sh
@@ -0,0 +1,3 @@
+#!/bin/sh -ex
+
+autoreconf -fi;
diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..354a015
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,10 @@
+AC_INIT([snet-tools], [0.1])
+AC_CONFIG_HEADER([config.h])
+AM_INIT_AUTOMAKE([-Wall foreign])
+AC_PROG_CC
+AC_PROG_INSTALL
+
+PKG_CHECK_MODULES([libsnet], [libsnet])
+
+AC_CONFIG_FILES([Makefile])
+AC_OUTPUT
-- 
1.7.3.4

