From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] build: provide buildsys with automake and pkgconfig
Date: Mon,  3 Oct 2011 22:10:07 +0200
Message-ID: <1317672610-29855-2-git-send-email-jengelh@medozas.de>
References: <1317672610-29855-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: sam@synack.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48172 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab1JCUKn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:10:43 -0400
In-Reply-To: <1317672610-29855-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 .gitignore    |   19 +++++++++++++++++++
 Makefile      |   38 --------------------------------------
 Makefile.am   |   19 +++++++++++++++++++
 autogen.sh    |    4 ++++
 configure.ac  |   17 +++++++++++++++++
 libsnet.pc.in |   10 ++++++++++
 m4/.gitignore |    2 ++
 7 files changed, 71 insertions(+), 38 deletions(-)
 create mode 100644 .gitignore
 delete mode 100644 Makefile
 create mode 100644 Makefile.am
 create mode 100755 autogen.sh
 create mode 100644 configure.ac
 create mode 100644 libsnet.pc.in
 create mode 100644 m4/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..4c556c2
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,19 @@
+.deps
+.libs
+Makefile
+Makefile.in
+*.la
+*.lo
+*.o
+*.pc
+
+/aclocal.m4
+/autom4te.cache
+/config.*
+/configure
+/depcomp
+/install-sh
+/libtool
+/ltmain.sh
+/missing
+/stamp-h1
diff --git a/Makefile b/Makefile
deleted file mode 100644
index c7dc237..0000000
--- a/Makefile
+++ /dev/null
@@ -1,38 +0,0 @@
-NAME	:= snetd
-VERSION	:= 0.1
-SRC	:= $(wildcard *.c)
-
-CC	:= gcc
-RM	:= rm -f
-LN	:= ln
-
-libdir = lib/
-includedir = include/
-bindir = bin/
-
-CFLAGS  := -g -O2
-INCLUDES := -I./$(includedir) $$(pkg-config --cflags sqlite3)
-LIBS     := $$(pkg-config --libs libnl-1 sqlite3) -lpthread
-OBJS     := $(SRC:.c=.o)
-
-all:	$(NAME)
-
-.c.o:
-	@echo " CC $@"; $(CC) $(INCLUDES) $(CFLAGS) -c $<
-
-$(NAME): $(OBJS)
-	@echo " CC $@"; $(CC) $(CFLAGS) $(LIBS) -o $@ $(OBJS)
-	@echo " LD lib$(NAME).so.$(VERSION)"; $(CC) -shared -Wl,-soname,lib$(NAME).so.1 -o lib$(NAME).so.$(VERSION) snet.o snet_lib.o utils.o
-	mv $(NAME) $(bindir)
-	mv lib$(NAME).so.$(VERSION) $(libdir)
-	@echo " LN lib$(NAME).so.$(VERSION) lib$(NAME).so.1"; rm -f $(libdir)lib$(NAME).so.1 ; $(LN) -s lib$(NAME).so.$(VERSION) $(libdir)/lib$(NAME).so.1
-	@echo " LN lib$(NAME).so.1 lib$(NAME).so"; rm -f $(libdir)/lib$(NAME).so ; $(LN) -s lib$(NAME).so.1 $(libdir)/lib$(NAME).so
-
-clean:
-	@echo " RM *~ *.o"; $(RM) *~ *.o
-
-distclean: clean
-	@echo " RM $(NAME)"; $(RM) $(bindir)$(NAME)
-	@echo " RM lib$(NAME).so.$(VERSION)"; $(RM) $(libdir)lib$(NAME).so.$(VERSION)
-	@echo " RM lib$(NAME).so.1"; $(RM) $(libdir)lib$(NAME).so.1
-	@echo " RM lib$(NAME).so"; $(RM) $(libdir)lib$(NAME).so
diff --git a/Makefile.am b/Makefile.am
new file mode 100644
index 0000000..143390a
--- /dev/null
+++ b/Makefile.am
@@ -0,0 +1,19 @@
+# -*- Makefile -*-
+
+# toplevel-specific
+ACLOCAL_AMFLAGS = -I m4
+
+# build pieces.
+AM_CPPFLAGS = -I${top_srcdir}/include
+AM_CFLAGS   = ${libnl_CFLAGS}
+
+lib_LTLIBRARIES = libsnet.la
+
+libsnet_la_SOURCES = snet.c snet_lib.c utils.c
+libsnet_la_LIBADD  = ${libnl_LIBS}
+
+include_HEADERS = include/snet.h include/snet_lib.h include/utils.h
+
+pkgconfig_DATA = libsnet.pc
+
+libsnet.pc: ${top_builddir}/config.status
diff --git a/autogen.sh b/autogen.sh
new file mode 100755
index 0000000..a52be65
--- /dev/null
+++ b/autogen.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -ex
+
+mkdir -p m4;
+autoreconf -fi;
diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..2ecef24
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,17 @@
+AC_INIT([libsnet], [0.1])
+AC_CONFIG_HEADERS([config.h])
+AC_CONFIG_MACRO_DIR([m4])
+AM_INIT_AUTOMAKE([-Wall foreign 1.10])
+AC_PROG_CC
+AC_DISABLE_STATIC
+LT_INIT
+
+PKG_CHECK_MODULES([libnl], [libnl-1])
+
+AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
+	[Path to the pkgconfig directory [[LIBDIR/pkgconfig]]]),
+	[pkgconfigdir="$withval"], [pkgconfigdir='${libdir}/pkgconfig'])
+AC_SUBST([pkgconfigdir])
+
+AC_CONFIG_FILES([Makefile libsnet.pc])
+AC_OUTPUT
diff --git a/libsnet.pc.in b/libsnet.pc.in
new file mode 100644
index 0000000..4ded898
--- /dev/null
+++ b/libsnet.pc.in
@@ -0,0 +1,10 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name:		libsnet
+Version:	@PACKAGE_VERSION@
+Description:	TBD
+Cflags:		-I${includedir}
+Libs:		-L${libdir} -lsnet
diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..64d9bbc
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1,2 @@
+/libtool.m4
+/lt*.m4
-- 
1.7.3.4

