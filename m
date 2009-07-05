From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] Move to automake-based build
Date: Sun,  5 Jul 2009 18:08:45 +0200
Message-ID: <1246810126-23428-2-git-send-email-jengelh@medozas.de>
References: <1246810126-23428-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48990 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbZGEQIq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:08:46 -0400
In-Reply-To: <1246810126-23428-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Issues solved:
* PACKAGE_VERSION was abused for SOVERSION
* unneeded DEP stage
* did not support out-of-tree builds
* no way to turn off silent mode
* overriding CFLAGS at make time was not supported
* no static libs were provided

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore          |   35 ++-
 Makefile            |   63 ----
 Makefile.am         |   11 +
 Makefile.opts.in    |   40 ---
 Makefile.rules      |   37 ---
 aclocal.m4          |  831 ---------------------------------------------------
 autogen.sh          |    4 +
 configure.in        |   30 +-
 doc/Makefile        |   35 ---
 doc/Makefile.am     |    9 +
 include/Makefile    |   42 ---
 include/Makefile.am |   67 ++++
 install-sh          |  294 ------------------
 lib/Makefile        |  103 -------
 lib/Makefile.am     |   40 +++
 lib/defs.h.in       |   25 --
 libnl-2.0.pc.in     |    4 +-
 m4/.gitignore       |    2 +
 src/Makefile        |   62 ----
 src/Makefile.am     |   86 ++++++
 20 files changed, 261 insertions(+), 1559 deletions(-)
 delete mode 100644 Makefile
 create mode 100644 Makefile.am
 delete mode 100644 Makefile.opts.in
 delete mode 100644 Makefile.rules
 delete mode 100644 aclocal.m4
 create mode 100755 autogen.sh
 delete mode 100644 doc/Makefile
 create mode 100644 doc/Makefile.am
 delete mode 100644 include/Makefile
 create mode 100644 include/Makefile.am
 delete mode 100755 install-sh
 delete mode 100644 lib/Makefile
 create mode 100644 lib/Makefile.am
 delete mode 100644 lib/defs.h.in
 create mode 100644 m4/.gitignore
 delete mode 100644 src/Makefile
 create mode 100644 src/Makefile.am

diff --git a/.gitignore b/.gitignore
index 7bd1c0d..e3a31d4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,10 +1,27 @@
-*.[od]
-Makefile.opts
-config.log
-config.status
-autom4te.cache
-libnl-1.pc
-configure
-doc/Doxyfile
-lib/defs.h
+.deps
+.libs
+.dirstamp
+*.in
+*.la
+*.lo
+*.o
+Makefile
+/lib/stamp-h1
+
+/libnl-1.pc
+/doc/Doxyfile
+/lib/defs.h
 cscope.*
+
+/aclocal.m4
+/autom4te.cache
+/compile
+/config.*
+/configure
+/depcomp
+/libtool
+/ltmain.sh
+/install-sh
+/missing
+
+/*.pc
diff --git a/Makefile b/Makefile
deleted file mode 100644
index 0e68a5b..0000000
--- a/Makefile
+++ /dev/null
@@ -1,63 +0,0 @@
-#
-# Makefile
-#
-# 	This library is free software; you can redistribute it and/or
-#	modify it under the terms of the GNU Lesser General Public
-#	License as published by the Free Software Foundation version 2.1
-#	of the License.
-#
-# Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
-#
-
-ifeq ($(shell [ ! -r Makefile.opts ] && echo 1),)
-    include Makefile.opts
-endif
-
-SUBDIRS := lib include doc src
-.PHONY: all clean distclean install gendoc $(SUBDIRS)
-
-all: Makefile.opts
-	@for dir in $(SUBDIRS); do \
-		echo "Entering $$dir" && $(MAKE) -C $$dir || exit $$?; \
-	done
-
-clean: Makefile.opts
-	@for dir in $(SUBDIRS); do \
-		echo "Entering $$dir" && $(MAKE) -C $$dir clean || exit $$?; \
-	done
-
-distclean: clean
-	@$(RM) -rf Makefile.opts autom4te.cache config.log config.status cscope.*
-	@for dir in $(SUBDIRS); do \
-		echo "Entering $$dir" && $(MAKE) -C $$dir distclean || exit $$?; \
-	done
-
-install: Makefile.opts
-	@for dir in $(SUBDIRS); do \
-		echo "Entering $$dir" && cd $$dir && $(MAKE) install && cd ..; \
-	done
-	mkdir -p $(DESTDIR)$(libdir)/pkgconfig/
-	install -m 0644 libnl-2.0.pc $(DESTDIR)$(libdir)/pkgconfig/
-
-gendoc:
-	$(MAKE) -C doc gendoc
-
-show: Makefile.opts
-	@echo "CC:          $(CC)"
-	@echo "RM:          $(RM)"
-	@echo "CFLAGS:      $(CFLAGS)"
-	@echo "DEPFLAGS:    $(DEPFLAGS)"
-	@echo "LDFLAGS:     $(LDFLAGS)"
-	@echo "DESTDIR:     $(DESTDIR)"
-	@echo "prefix:      $(prefix)"
-	@echo "libdir:      $(libdir)"
-	@echo "includedir:  $(includedir)"
-
-cscope:
-	cscope -b -q -R -Iinclude -slib -ssrc
-
-
-$(SUBDIRS):
-	cd $@ && $(MAKE)
-
--include Makefile.rules
diff --git a/Makefile.am b/Makefile.am
new file mode 100644
index 0000000..01f9879
--- /dev/null
+++ b/Makefile.am
@@ -0,0 +1,11 @@
+# -*- Makefile -*-
+
+ACLOCAL_AMFLAGS = -I m4
+
+SUBDIRS = include lib src doc
+
+pkgconfig_DATA = libnl-2.0.pc
+
+.PHONY: cscope
+cscope:
+	cscope -b -q -R -Iinclude -slib -ssrc;
diff --git a/Makefile.opts.in b/Makefile.opts.in
deleted file mode 100644
index b68e12f..0000000
--- a/Makefile.opts.in
+++ /dev/null
@@ -1,40 +0,0 @@
-#
-# Makefile.opts.in
-#
-# 	This library is free software; you can redistribute it and/or
-#	modify it under the terms of the GNU Lesser General Public
-#	License as published by the Free Software Foundation version 2.1
-#	of the License.
-#
-# Copyright (c) 2003-2008 Thomas Graf <tgraf@suug.ch>
-#
-
-CC               := @CC@
-CFLAGS           := @CFLAGS@
-LDFLAGS          := @LDFLAGS@
-CPPFLAGS         := @CPPFLAGS@
-PACKAGE_NAME     := @PACKAGE_NAME@
-PACKAGE_VERSION  := @PACKAGE_VERSION@
-
-LIBNL_LIB        := @LIBNL_LIB@ -lc -L.
-
-prefix           := @prefix@
-exec_prefix      := @exec_prefix@
-libdir           := @libdir@
-includedir       := @includedir@
-mandir           := @mandir@
-sysconfdir       := @sysconfdir@
-datarootdir      := @datarootdir@
-
-AR               := ar
-RM               := rm
-LN               := ln
-
-DEPFLAGS         += -M -I../include/ -I. $(CPPFLAGS)
-CFLAGS           += -g -I./include -I../include -I. $(CPPFLAGS) -D_GNU_SOURCE
-MAKEFLAGS        += --no-print-directory
-
-ifeq ($(CC),gcc)
-CFLAGS           += -Wall -ggdb
-endif
-
diff --git a/Makefile.rules b/Makefile.rules
deleted file mode 100644
index ba5472f..0000000
--- a/Makefile.rules
+++ /dev/null
@@ -1,37 +0,0 @@
-#
-# Makefile.rules
-#
-# 	This library is free software; you can redistribute it and/or
-#	modify it under the terms of the GNU Lesser General Public
-#	License as published by the Free Software Foundation version 2.1
-#	of the License.
-#
-# Copyright (c) 2003-2008 Thomas Graf <tgraf@suug.ch>
-#
-
-.SUFFIXES:
-.SUFFIXES: .d .c
-
-%.o: %.c
-	@echo "  CC $<"; \
-	$(CC) $(CFLAGS) -c -o $@ $<
-
-%.d: %.c
-	@echo "  DEP $<"; \
-	$(CC) $(DEPFLAGS) $< > $@.tmp; \
-	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.tmp > $@; \
-	rm -f $@.tmp
-
-Makefile.opts:
-	@echo "***"
-	@echo "*** No configuration found, please run ./configure"
-	@echo "***"
-	@exit 1
-
-ifneq ($(MAKECMDGOALS),clean)
-ifneq ($(MAKECMDGOALS),distclean)
-ifneq ($(DEPS),)
--include $(DEPS)
-endif
-endif
-endif
diff --git a/aclocal.m4 b/aclocal.m4
deleted file mode 100644
index 177c013..0000000
--- a/aclocal.m4
+++ /dev/null
@@ -1,831 +0,0 @@
-dnl aclocal.m4 generated automatically by aclocal 1.4-p6
-
-dnl Copyright (C) 1994, 1995-8, 1999, 2001 Free Software Foundation, Inc.
-dnl This file is free software; the Free Software Foundation
-dnl gives unlimited permission to copy and/or distribute it,
-dnl with or without modifications, as long as this notice is preserved.
-
-dnl This program is distributed in the hope that it will be useful,
-dnl but WITHOUT ANY WARRANTY, to the extent permitted by law; without
-dnl even the implied warranty of MERCHANTABILITY or FITNESS FOR A
-dnl PARTICULAR PURPOSE.
-
-# lib-prefix.m4 serial 4 (gettext-0.14.2)
-dnl Copyright (C) 2001-2005 Free Software Foundation, Inc.
-dnl This file is free software; the Free Software Foundation
-dnl gives unlimited permission to copy and/or distribute it,
-dnl with or without modifications, as long as this notice is preserved.
-
-dnl From Bruno Haible.
-
-dnl AC_LIB_ARG_WITH is synonymous to AC_ARG_WITH in autoconf-2.13, and
-dnl similar to AC_ARG_WITH in autoconf 2.52...2.57 except that is doesn't
-dnl require excessive bracketing.
-ifdef([AC_HELP_STRING],
-[AC_DEFUN([AC_LIB_ARG_WITH], [AC_ARG_WITH([$1],[[$2]],[$3],[$4])])],
-[AC_DEFUN([AC_][LIB_ARG_WITH], [AC_ARG_WITH([$1],[$2],[$3],[$4])])])
-
-dnl AC_LIB_PREFIX adds to the CPPFLAGS and LDFLAGS the flags that are needed
-dnl to access previously installed libraries. The basic assumption is that
-dnl a user will want packages to use other packages he previously installed
-dnl with the same --prefix option.
-dnl This macro is not needed if only AC_LIB_LINKFLAGS is used to locate
-dnl libraries, but is otherwise very convenient.
-AC_DEFUN([AC_LIB_PREFIX],
-[
-  AC_BEFORE([$0], [AC_LIB_LINKFLAGS])
-  AC_REQUIRE([AC_PROG_CC])
-  AC_REQUIRE([AC_CANONICAL_HOST])
-  AC_REQUIRE([AC_LIB_PREPARE_PREFIX])
-  dnl By default, look in $includedir and $libdir.
-  use_additional=yes
-  AC_LIB_WITH_FINAL_PREFIX([
-    eval additional_includedir=\"$includedir\"
-    eval additional_libdir=\"$libdir\"
-  ])
-  AC_LIB_ARG_WITH([lib-prefix],
-[  --with-lib-prefix[=DIR] search for libraries in DIR/include and DIR/lib
-  --without-lib-prefix    don't search for libraries in includedir and libdir],
-[
-    if test "X$withval" = "Xno"; then
-      use_additional=no
-    else
-      if test "X$withval" = "X"; then
-        AC_LIB_WITH_FINAL_PREFIX([
-          eval additional_includedir=\"$includedir\"
-          eval additional_libdir=\"$libdir\"
-        ])
-      else
-        additional_includedir="$withval/include"
-        additional_libdir="$withval/lib"
-      fi
-    fi
-])
-  if test $use_additional = yes; then
-    dnl Potentially add $additional_includedir to $CPPFLAGS.
-    dnl But don't add it
-    dnl   1. if it's the standard /usr/include,
-    dnl   2. if it's already present in $CPPFLAGS,
-    dnl   3. if it's /usr/local/include and we are using GCC on Linux,
-    dnl   4. if it doesn't exist as a directory.
-    if test "X$additional_includedir" != "X/usr/include"; then
-      haveit=
-      for x in $CPPFLAGS; do
-        AC_LIB_WITH_FINAL_PREFIX([eval x=\"$x\"])
-        if test "X$x" = "X-I$additional_includedir"; then
-          haveit=yes
-          break
-        fi
-      done
-      if test -z "$haveit"; then
-        if test "X$additional_includedir" = "X/usr/local/include"; then
-          if test -n "$GCC"; then
-            case $host_os in
-              linux* | gnu* | k*bsd*-gnu) haveit=yes;;
-            esac
-          fi
-        fi
-        if test -z "$haveit"; then
-          if test -d "$additional_includedir"; then
-            dnl Really add $additional_includedir to $CPPFLAGS.
-            CPPFLAGS="${CPPFLAGS}${CPPFLAGS:+ }-I$additional_includedir"
-          fi
-        fi
-      fi
-    fi
-    dnl Potentially add $additional_libdir to $LDFLAGS.
-    dnl But don't add it
-    dnl   1. if it's the standard /usr/lib,
-    dnl   2. if it's already present in $LDFLAGS,
-    dnl   3. if it's /usr/local/lib and we are using GCC on Linux,
-    dnl   4. if it doesn't exist as a directory.
-    if test "X$additional_libdir" != "X/usr/lib"; then
-      haveit=
-      for x in $LDFLAGS; do
-        AC_LIB_WITH_FINAL_PREFIX([eval x=\"$x\"])
-        if test "X$x" = "X-L$additional_libdir"; then
-          haveit=yes
-          break
-        fi
-      done
-      if test -z "$haveit"; then
-        if test "X$additional_libdir" = "X/usr/local/lib"; then
-          if test -n "$GCC"; then
-            case $host_os in
-              linux*) haveit=yes;;
-            esac
-          fi
-        fi
-        if test -z "$haveit"; then
-          if test -d "$additional_libdir"; then
-            dnl Really add $additional_libdir to $LDFLAGS.
-            LDFLAGS="${LDFLAGS}${LDFLAGS:+ }-L$additional_libdir"
-          fi
-        fi
-      fi
-    fi
-  fi
-])
-
-dnl AC_LIB_PREPARE_PREFIX creates variables acl_final_prefix,
-dnl acl_final_exec_prefix, containing the values to which $prefix and
-dnl $exec_prefix will expand at the end of the configure script.
-AC_DEFUN([AC_LIB_PREPARE_PREFIX],
-[
-  dnl Unfortunately, prefix and exec_prefix get only finally determined
-  dnl at the end of configure.
-  if test "X$prefix" = "XNONE"; then
-    acl_final_prefix="$ac_default_prefix"
-  else
-    acl_final_prefix="$prefix"
-  fi
-  if test "X$exec_prefix" = "XNONE"; then
-    acl_final_exec_prefix='${prefix}'
-  else
-    acl_final_exec_prefix="$exec_prefix"
-  fi
-  acl_save_prefix="$prefix"
-  prefix="$acl_final_prefix"
-  eval acl_final_exec_prefix=\"$acl_final_exec_prefix\"
-  prefix="$acl_save_prefix"
-])
-
-dnl AC_LIB_WITH_FINAL_PREFIX([statement]) evaluates statement, with the
-dnl variables prefix and exec_prefix bound to the values they will have
-dnl at the end of the configure script.
-AC_DEFUN([AC_LIB_WITH_FINAL_PREFIX],
-[
-  acl_save_prefix="$prefix"
-  prefix="$acl_final_prefix"
-  acl_save_exec_prefix="$exec_prefix"
-  exec_prefix="$acl_final_exec_prefix"
-  $1
-  exec_prefix="$acl_save_exec_prefix"
-  prefix="$acl_save_prefix"
-])
-
-# lib-link.m4 serial 6 (gettext-0.14.3)
-dnl Copyright (C) 2001-2005 Free Software Foundation, Inc.
-dnl This file is free software; the Free Software Foundation
-dnl gives unlimited permission to copy and/or distribute it,
-dnl with or without modifications, as long as this notice is preserved.
-
-dnl From Bruno Haible.
-
-AC_PREREQ(2.50)
-
-dnl AC_LIB_LINKFLAGS(name [, dependencies]) searches for libname and
-dnl the libraries corresponding to explicit and implicit dependencies.
-dnl Sets and AC_SUBSTs the LIB${NAME} and LTLIB${NAME} variables and
-dnl augments the CPPFLAGS variable.
-AC_DEFUN([AC_LIB_LINKFLAGS],
-[
-  AC_REQUIRE([AC_LIB_PREPARE_PREFIX])
-  AC_REQUIRE([AC_LIB_RPATH])
-  define([Name],[translit([$1],[./-], [___])])
-  define([NAME],[translit([$1],[abcdefghijklmnopqrstuvwxyz./-],
-                               [ABCDEFGHIJKLMNOPQRSTUVWXYZ___])])
-  AC_CACHE_CHECK([how to link with lib[]$1], [ac_cv_lib[]Name[]_libs], [
-    AC_LIB_LINKFLAGS_BODY([$1], [$2])
-    ac_cv_lib[]Name[]_libs="$LIB[]NAME"
-    ac_cv_lib[]Name[]_ltlibs="$LTLIB[]NAME"
-    ac_cv_lib[]Name[]_cppflags="$INC[]NAME"
-  ])
-  LIB[]NAME="$ac_cv_lib[]Name[]_libs"
-  LTLIB[]NAME="$ac_cv_lib[]Name[]_ltlibs"
-  INC[]NAME="$ac_cv_lib[]Name[]_cppflags"
-  AC_LIB_APPENDTOVAR([CPPFLAGS], [$INC]NAME)
-  AC_SUBST([LIB]NAME)
-  AC_SUBST([LTLIB]NAME)
-  dnl Also set HAVE_LIB[]NAME so that AC_LIB_HAVE_LINKFLAGS can reuse the
-  dnl results of this search when this library appears as a dependency.
-  HAVE_LIB[]NAME=yes
-  undefine([Name])
-  undefine([NAME])
-])
-
-dnl AC_LIB_HAVE_LINKFLAGS(name, dependencies, includes, testcode)
-dnl searches for libname and the libraries corresponding to explicit and
-dnl implicit dependencies, together with the specified include files and
-dnl the ability to compile and link the specified testcode. If found, it
-dnl sets and AC_SUBSTs HAVE_LIB${NAME}=yes and the LIB${NAME} and
-dnl LTLIB${NAME} variables and augments the CPPFLAGS variable, and
-dnl #defines HAVE_LIB${NAME} to 1. Otherwise, it sets and AC_SUBSTs
-dnl HAVE_LIB${NAME}=no and LIB${NAME} and LTLIB${NAME} to empty.
-AC_DEFUN([AC_LIB_HAVE_LINKFLAGS],
-[
-  AC_REQUIRE([AC_LIB_PREPARE_PREFIX])
-  AC_REQUIRE([AC_LIB_RPATH])
-  define([Name],[translit([$1],[./-], [___])])
-  define([NAME],[translit([$1],[abcdefghijklmnopqrstuvwxyz./-],
-                               [ABCDEFGHIJKLMNOPQRSTUVWXYZ___])])
-
-  dnl Search for lib[]Name and define LIB[]NAME, LTLIB[]NAME and INC[]NAME
-  dnl accordingly.
-  AC_LIB_LINKFLAGS_BODY([$1], [$2])
-
-  dnl Add $INC[]NAME to CPPFLAGS before performing the following checks,
-  dnl because if the user has installed lib[]Name and not disabled its use
-  dnl via --without-lib[]Name-prefix, he wants to use it.
-  ac_save_CPPFLAGS="$CPPFLAGS"
-  AC_LIB_APPENDTOVAR([CPPFLAGS], [$INC]NAME)
-
-  AC_CACHE_CHECK([for lib[]$1], [ac_cv_lib[]Name], [
-    ac_save_LIBS="$LIBS"
-    LIBS="$LIBS $LIB[]NAME"
-    AC_TRY_LINK([$3], [$4], [ac_cv_lib[]Name=yes], [ac_cv_lib[]Name=no])
-    LIBS="$ac_save_LIBS"
-  ])
-  if test "$ac_cv_lib[]Name" = yes; then
-    HAVE_LIB[]NAME=yes
-    AC_DEFINE([HAVE_LIB]NAME, 1, [Define if you have the $1 library.])
-    AC_MSG_CHECKING([how to link with lib[]$1])
-    AC_MSG_RESULT([$LIB[]NAME])
-  else
-    HAVE_LIB[]NAME=no
-    dnl If $LIB[]NAME didn't lead to a usable library, we don't need
-    dnl $INC[]NAME either.
-    CPPFLAGS="$ac_save_CPPFLAGS"
-    LIB[]NAME=
-    LTLIB[]NAME=
-  fi
-  AC_SUBST([HAVE_LIB]NAME)
-  AC_SUBST([LIB]NAME)
-  AC_SUBST([LTLIB]NAME)
-  undefine([Name])
-  undefine([NAME])
-])
-
-dnl Determine the platform dependent parameters needed to use rpath:
-dnl libext, shlibext, hardcode_libdir_flag_spec, hardcode_libdir_separator,
-dnl hardcode_direct, hardcode_minus_L.
-AC_DEFUN([AC_LIB_RPATH],
-[
-  dnl Tell automake >= 1.10 to complain if config.rpath is missing.
-  m4_ifdef([AC_REQUIRE_AUX_FILE], [AC_REQUIRE_AUX_FILE([config.rpath])])
-  AC_REQUIRE([AC_PROG_CC])                dnl we use $CC, $GCC, $LDFLAGS
-  AC_REQUIRE([AC_LIB_PROG_LD])            dnl we use $LD, $with_gnu_ld
-  AC_REQUIRE([AC_CANONICAL_HOST])         dnl we use $host
-  AC_REQUIRE([AC_CONFIG_AUX_DIR_DEFAULT]) dnl we use $ac_aux_dir
-  AC_CACHE_CHECK([for shared library run path origin], acl_cv_rpath, [
-    CC="$CC" GCC="$GCC" LDFLAGS="$LDFLAGS" LD="$LD" with_gnu_ld="$with_gnu_ld" \
-    ${CONFIG_SHELL-/bin/sh} "$ac_aux_dir/config.rpath" "$host" > conftest.sh
-    . ./conftest.sh
-    rm -f ./conftest.sh
-    acl_cv_rpath=done
-  ])
-  wl="$acl_cv_wl"
-  libext="$acl_cv_libext"
-  shlibext="$acl_cv_shlibext"
-  hardcode_libdir_flag_spec="$acl_cv_hardcode_libdir_flag_spec"
-  hardcode_libdir_separator="$acl_cv_hardcode_libdir_separator"
-  hardcode_direct="$acl_cv_hardcode_direct"
-  hardcode_minus_L="$acl_cv_hardcode_minus_L"
-  dnl Determine whether the user wants rpath handling at all.
-  AC_ARG_ENABLE(rpath,
-    [  --disable-rpath         do not hardcode runtime library paths],
-    :, enable_rpath=yes)
-])
-
-dnl AC_LIB_LINKFLAGS_BODY(name [, dependencies]) searches for libname and
-dnl the libraries corresponding to explicit and implicit dependencies.
-dnl Sets the LIB${NAME}, LTLIB${NAME} and INC${NAME} variables.
-AC_DEFUN([AC_LIB_LINKFLAGS_BODY],
-[
-  define([NAME],[translit([$1],[abcdefghijklmnopqrstuvwxyz./-],
-                               [ABCDEFGHIJKLMNOPQRSTUVWXYZ___])])
-  dnl By default, look in $includedir and $libdir.
-  use_additional=yes
-  AC_LIB_WITH_FINAL_PREFIX([
-    eval additional_includedir=\"$includedir\"
-    eval additional_libdir=\"$libdir\"
-  ])
-  AC_LIB_ARG_WITH([lib$1-prefix],
-[  --with-lib$1-prefix[=DIR]  search for lib$1 in DIR/include and DIR/lib
-  --without-lib$1-prefix     don't search for lib$1 in includedir and libdir],
-[
-    if test "X$withval" = "Xno"; then
-      use_additional=no
-    else
-      if test "X$withval" = "X"; then
-        AC_LIB_WITH_FINAL_PREFIX([
-          eval additional_includedir=\"$includedir\"
-          eval additional_libdir=\"$libdir\"
-        ])
-      else
-        additional_includedir="$withval/include"
-        additional_libdir="$withval/lib"
-      fi
-    fi
-])
-  dnl Search the library and its dependencies in $additional_libdir and
-  dnl $LDFLAGS. Using breadth-first-seach.
-  LIB[]NAME=
-  LTLIB[]NAME=
-  INC[]NAME=
-  rpathdirs=
-  ltrpathdirs=
-  names_already_handled=
-  names_next_round='$1 $2'
-  while test -n "$names_next_round"; do
-    names_this_round="$names_next_round"
-    names_next_round=
-    for name in $names_this_round; do
-      already_handled=
-      for n in $names_already_handled; do
-        if test "$n" = "$name"; then
-          already_handled=yes
-          break
-        fi
-      done
-      if test -z "$already_handled"; then
-        names_already_handled="$names_already_handled $name"
-        dnl See if it was already located by an earlier AC_LIB_LINKFLAGS
-        dnl or AC_LIB_HAVE_LINKFLAGS call.
-        uppername=`echo "$name" | sed -e 'y|abcdefghijklmnopqrstuvwxyz./-|ABCDEFGHIJKLMNOPQRSTUVWXYZ___|'`
-        eval value=\"\$HAVE_LIB$uppername\"
-        if test -n "$value"; then
-          if test "$value" = yes; then
-            eval value=\"\$LIB$uppername\"
-            test -z "$value" || LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }$value"
-            eval value=\"\$LTLIB$uppername\"
-            test -z "$value" || LTLIB[]NAME="${LTLIB[]NAME}${LTLIB[]NAME:+ }$value"
-          else
-            dnl An earlier call to AC_LIB_HAVE_LINKFLAGS has determined
-            dnl that this library doesn't exist. So just drop it.
-            :
-          fi
-        else
-          dnl Search the library lib$name in $additional_libdir and $LDFLAGS
-          dnl and the already constructed $LIBNAME/$LTLIBNAME.
-          found_dir=
-          found_la=
-          found_so=
-          found_a=
-          if test $use_additional = yes; then
-            if test -n "$shlibext" && test -f "$additional_libdir/lib$name.$shlibext"; then
-              found_dir="$additional_libdir"
-              found_so="$additional_libdir/lib$name.$shlibext"
-              if test -f "$additional_libdir/lib$name.la"; then
-                found_la="$additional_libdir/lib$name.la"
-              fi
-            else
-              if test -f "$additional_libdir/lib$name.$libext"; then
-                found_dir="$additional_libdir"
-                found_a="$additional_libdir/lib$name.$libext"
-                if test -f "$additional_libdir/lib$name.la"; then
-                  found_la="$additional_libdir/lib$name.la"
-                fi
-              fi
-            fi
-          fi
-          if test "X$found_dir" = "X"; then
-            for x in $LDFLAGS $LTLIB[]NAME; do
-              AC_LIB_WITH_FINAL_PREFIX([eval x=\"$x\"])
-              case "$x" in
-                -L*)
-                  dir=`echo "X$x" | sed -e 's/^X-L//'`
-                  if test -n "$shlibext" && test -f "$dir/lib$name.$shlibext"; then
-                    found_dir="$dir"
-                    found_so="$dir/lib$name.$shlibext"
-                    if test -f "$dir/lib$name.la"; then
-                      found_la="$dir/lib$name.la"
-                    fi
-                  else
-                    if test -f "$dir/lib$name.$libext"; then
-                      found_dir="$dir"
-                      found_a="$dir/lib$name.$libext"
-                      if test -f "$dir/lib$name.la"; then
-                        found_la="$dir/lib$name.la"
-                      fi
-                    fi
-                  fi
-                  ;;
-              esac
-              if test "X$found_dir" != "X"; then
-                break
-              fi
-            done
-          fi
-          if test "X$found_dir" != "X"; then
-            dnl Found the library.
-            LTLIB[]NAME="${LTLIB[]NAME}${LTLIB[]NAME:+ }-L$found_dir -l$name"
-            if test "X$found_so" != "X"; then
-              dnl Linking with a shared library. We attempt to hardcode its
-              dnl directory into the executable's runpath, unless it's the
-              dnl standard /usr/lib.
-              if test "$enable_rpath" = no || test "X$found_dir" = "X/usr/lib"; then
-                dnl No hardcoding is needed.
-                LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }$found_so"
-              else
-                dnl Use an explicit option to hardcode DIR into the resulting
-                dnl binary.
-                dnl Potentially add DIR to ltrpathdirs.
-                dnl The ltrpathdirs will be appended to $LTLIBNAME at the end.
-                haveit=
-                for x in $ltrpathdirs; do
-                  if test "X$x" = "X$found_dir"; then
-                    haveit=yes
-                    break
-                  fi
-                done
-                if test -z "$haveit"; then
-                  ltrpathdirs="$ltrpathdirs $found_dir"
-                fi
-                dnl The hardcoding into $LIBNAME is system dependent.
-                if test "$hardcode_direct" = yes; then
-                  dnl Using DIR/libNAME.so during linking hardcodes DIR into the
-                  dnl resulting binary.
-                  LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }$found_so"
-                else
-                  if test -n "$hardcode_libdir_flag_spec" && test "$hardcode_minus_L" = no; then
-                    dnl Use an explicit option to hardcode DIR into the resulting
-                    dnl binary.
-                    LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }$found_so"
-                    dnl Potentially add DIR to rpathdirs.
-                    dnl The rpathdirs will be appended to $LIBNAME at the end.
-                    haveit=
-                    for x in $rpathdirs; do
-                      if test "X$x" = "X$found_dir"; then
-                        haveit=yes
-                        break
-                      fi
-                    done
-                    if test -z "$haveit"; then
-                      rpathdirs="$rpathdirs $found_dir"
-                    fi
-                  else
-                    dnl Rely on "-L$found_dir".
-                    dnl But don't add it if it's already contained in the LDFLAGS
-                    dnl or the already constructed $LIBNAME
-                    haveit=
-                    for x in $LDFLAGS $LIB[]NAME; do
-                      AC_LIB_WITH_FINAL_PREFIX([eval x=\"$x\"])
-                      if test "X$x" = "X-L$found_dir"; then
-                        haveit=yes
-                        break
-                      fi
-                    done
-                    if test -z "$haveit"; then
-                      LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }-L$found_dir"
-                    fi
-                    if test "$hardcode_minus_L" != no; then
-                      dnl FIXME: Not sure whether we should use
-                      dnl "-L$found_dir -l$name" or "-L$found_dir $found_so"
-                      dnl here.
-                      LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }$found_so"
-                    else
-                      dnl We cannot use $hardcode_runpath_var and LD_RUN_PATH
-                      dnl here, because this doesn't fit in flags passed to the
-                      dnl compiler. So give up. No hardcoding. This affects only
-                      dnl very old systems.
-                      dnl FIXME: Not sure whether we should use
-                      dnl "-L$found_dir -l$name" or "-L$found_dir $found_so"
-                      dnl here.
-                      LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }-l$name"
-                    fi
-                  fi
-                fi
-              fi
-            else
-              if test "X$found_a" != "X"; then
-                dnl Linking with a static library.
-                LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }$found_a"
-              else
-                dnl We shouldn't come here, but anyway it's good to have a
-                dnl fallback.
-                LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }-L$found_dir -l$name"
-              fi
-            fi
-            dnl Assume the include files are nearby.
-            additional_includedir=
-            case "$found_dir" in
-              */lib | */lib/)
-                basedir=`echo "X$found_dir" | sed -e 's,^X,,' -e 's,/lib/*$,,'`
-                additional_includedir="$basedir/include"
-                ;;
-            esac
-            if test "X$additional_includedir" != "X"; then
-              dnl Potentially add $additional_includedir to $INCNAME.
-              dnl But don't add it
-              dnl   1. if it's the standard /usr/include,
-              dnl   2. if it's /usr/local/include and we are using GCC on Linux,
-              dnl   3. if it's already present in $CPPFLAGS or the already
-              dnl      constructed $INCNAME,
-              dnl   4. if it doesn't exist as a directory.
-              if test "X$additional_includedir" != "X/usr/include"; then
-                haveit=
-                if test "X$additional_includedir" = "X/usr/local/include"; then
-                  if test -n "$GCC"; then
-                    case $host_os in
-                      linux* | gnu* | k*bsd*-gnu) haveit=yes;;
-                    esac
-                  fi
-                fi
-                if test -z "$haveit"; then
-                  for x in $CPPFLAGS $INC[]NAME; do
-                    AC_LIB_WITH_FINAL_PREFIX([eval x=\"$x\"])
-                    if test "X$x" = "X-I$additional_includedir"; then
-                      haveit=yes
-                      break
-                    fi
-                  done
-                  if test -z "$haveit"; then
-                    if test -d "$additional_includedir"; then
-                      dnl Really add $additional_includedir to $INCNAME.
-                      INC[]NAME="${INC[]NAME}${INC[]NAME:+ }-I$additional_includedir"
-                    fi
-                  fi
-                fi
-              fi
-            fi
-            dnl Look for dependencies.
-            if test -n "$found_la"; then
-              dnl Read the .la file. It defines the variables
-              dnl dlname, library_names, old_library, dependency_libs, current,
-              dnl age, revision, installed, dlopen, dlpreopen, libdir.
-              save_libdir="$libdir"
-              case "$found_la" in
-                */* | *\\*) . "$found_la" ;;
-                *) . "./$found_la" ;;
-              esac
-              libdir="$save_libdir"
-              dnl We use only dependency_libs.
-              for dep in $dependency_libs; do
-                case "$dep" in
-                  -L*)
-                    additional_libdir=`echo "X$dep" | sed -e 's/^X-L//'`
-                    dnl Potentially add $additional_libdir to $LIBNAME and $LTLIBNAME.
-                    dnl But don't add it
-                    dnl   1. if it's the standard /usr/lib,
-                    dnl   2. if it's /usr/local/lib and we are using GCC on Linux,
-                    dnl   3. if it's already present in $LDFLAGS or the already
-                    dnl      constructed $LIBNAME,
-                    dnl   4. if it doesn't exist as a directory.
-                    if test "X$additional_libdir" != "X/usr/lib"; then
-                      haveit=
-                      if test "X$additional_libdir" = "X/usr/local/lib"; then
-                        if test -n "$GCC"; then
-                          case $host_os in
-                            linux* | gnu* | k*bsd*-gnu) haveit=yes;;
-                          esac
-                        fi
-                      fi
-                      if test -z "$haveit"; then
-                        haveit=
-                        for x in $LDFLAGS $LIB[]NAME; do
-                          AC_LIB_WITH_FINAL_PREFIX([eval x=\"$x\"])
-                          if test "X$x" = "X-L$additional_libdir"; then
-                            haveit=yes
-                            break
-                          fi
-                        done
-                        if test -z "$haveit"; then
-                          if test -d "$additional_libdir"; then
-                            dnl Really add $additional_libdir to $LIBNAME.
-                            LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }-L$additional_libdir"
-                          fi
-                        fi
-                        haveit=
-                        for x in $LDFLAGS $LTLIB[]NAME; do
-                          AC_LIB_WITH_FINAL_PREFIX([eval x=\"$x\"])
-                          if test "X$x" = "X-L$additional_libdir"; then
-                            haveit=yes
-                            break
-                          fi
-                        done
-                        if test -z "$haveit"; then
-                          if test -d "$additional_libdir"; then
-                            dnl Really add $additional_libdir to $LTLIBNAME.
-                            LTLIB[]NAME="${LTLIB[]NAME}${LTLIB[]NAME:+ }-L$additional_libdir"
-                          fi
-                        fi
-                      fi
-                    fi
-                    ;;
-                  -R*)
-                    dir=`echo "X$dep" | sed -e 's/^X-R//'`
-                    if test "$enable_rpath" != no; then
-                      dnl Potentially add DIR to rpathdirs.
-                      dnl The rpathdirs will be appended to $LIBNAME at the end.
-                      haveit=
-                      for x in $rpathdirs; do
-                        if test "X$x" = "X$dir"; then
-                          haveit=yes
-                          break
-                        fi
-                      done
-                      if test -z "$haveit"; then
-                        rpathdirs="$rpathdirs $dir"
-                      fi
-                      dnl Potentially add DIR to ltrpathdirs.
-                      dnl The ltrpathdirs will be appended to $LTLIBNAME at the end.
-                      haveit=
-                      for x in $ltrpathdirs; do
-                        if test "X$x" = "X$dir"; then
-                          haveit=yes
-                          break
-                        fi
-                      done
-                      if test -z "$haveit"; then
-                        ltrpathdirs="$ltrpathdirs $dir"
-                      fi
-                    fi
-                    ;;
-                  -l*)
-                    dnl Handle this in the next round.
-                    names_next_round="$names_next_round "`echo "X$dep" | sed -e 's/^X-l//'`
-                    ;;
-                  *.la)
-                    dnl Handle this in the next round. Throw away the .la's
-                    dnl directory; it is already contained in a preceding -L
-                    dnl option.
-                    names_next_round="$names_next_round "`echo "X$dep" | sed -e 's,^X.*/,,' -e 's,^lib,,' -e 's,\.la$,,'`
-                    ;;
-                  *)
-                    dnl Most likely an immediate library name.
-                    LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }$dep"
-                    LTLIB[]NAME="${LTLIB[]NAME}${LTLIB[]NAME:+ }$dep"
-                    ;;
-                esac
-              done
-            fi
-          else
-            dnl Didn't find the library; assume it is in the system directories
-            dnl known to the linker and runtime loader. (All the system
-            dnl directories known to the linker should also be known to the
-            dnl runtime loader, otherwise the system is severely misconfigured.)
-            LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }-l$name"
-            LTLIB[]NAME="${LTLIB[]NAME}${LTLIB[]NAME:+ }-l$name"
-          fi
-        fi
-      fi
-    done
-  done
-  if test "X$rpathdirs" != "X"; then
-    if test -n "$hardcode_libdir_separator"; then
-      dnl Weird platform: only the last -rpath option counts, the user must
-      dnl pass all path elements in one option. We can arrange that for a
-      dnl single library, but not when more than one $LIBNAMEs are used.
-      alldirs=
-      for found_dir in $rpathdirs; do
-        alldirs="${alldirs}${alldirs:+$hardcode_libdir_separator}$found_dir"
-      done
-      dnl Note: hardcode_libdir_flag_spec uses $libdir and $wl.
-      acl_save_libdir="$libdir"
-      libdir="$alldirs"
-      eval flag=\"$hardcode_libdir_flag_spec\"
-      libdir="$acl_save_libdir"
-      LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }$flag"
-    else
-      dnl The -rpath options are cumulative.
-      for found_dir in $rpathdirs; do
-        acl_save_libdir="$libdir"
-        libdir="$found_dir"
-        eval flag=\"$hardcode_libdir_flag_spec\"
-        libdir="$acl_save_libdir"
-        LIB[]NAME="${LIB[]NAME}${LIB[]NAME:+ }$flag"
-      done
-    fi
-  fi
-  if test "X$ltrpathdirs" != "X"; then
-    dnl When using libtool, the option that works for both libraries and
-    dnl executables is -R. The -R options are cumulative.
-    for found_dir in $ltrpathdirs; do
-      LTLIB[]NAME="${LTLIB[]NAME}${LTLIB[]NAME:+ }-R$found_dir"
-    done
-  fi
-])
-
-dnl AC_LIB_APPENDTOVAR(VAR, CONTENTS) appends the elements of CONTENTS to VAR,
-dnl unless already present in VAR.
-dnl Works only for CPPFLAGS, not for LIB* variables because that sometimes
-dnl contains two or three consecutive elements that belong together.
-AC_DEFUN([AC_LIB_APPENDTOVAR],
-[
-  for element in [$2]; do
-    haveit=
-    for x in $[$1]; do
-      AC_LIB_WITH_FINAL_PREFIX([eval x=\"$x\"])
-      if test "X$x" = "X$element"; then
-        haveit=yes
-        break
-      fi
-    done
-    if test -z "$haveit"; then
-      [$1]="${[$1]}${[$1]:+ }$element"
-    fi
-  done
-])
-
-# lib-ld.m4 serial 3 (gettext-0.13)
-dnl Copyright (C) 1996-2003 Free Software Foundation, Inc.
-dnl This file is free software; the Free Software Foundation
-dnl gives unlimited permission to copy and/or distribute it,
-dnl with or without modifications, as long as this notice is preserved.
-
-dnl Subroutines of libtool.m4,
-dnl with replacements s/AC_/AC_LIB/ and s/lt_cv/acl_cv/ to avoid collision
-dnl with libtool.m4.
-
-dnl From libtool-1.4. Sets the variable with_gnu_ld to yes or no.
-AC_DEFUN([AC_LIB_PROG_LD_GNU],
-[AC_CACHE_CHECK([if the linker ($LD) is GNU ld], acl_cv_prog_gnu_ld,
-[# I'd rather use --version here, but apparently some GNU ld's only accept -v.
-case `$LD -v 2>&1 </dev/null` in
-*GNU* | *'with BFD'*)
-  acl_cv_prog_gnu_ld=yes ;;
-*)
-  acl_cv_prog_gnu_ld=no ;;
-esac])
-with_gnu_ld=$acl_cv_prog_gnu_ld
-])
-
-dnl From libtool-1.4. Sets the variable LD.
-AC_DEFUN([AC_LIB_PROG_LD],
-[AC_ARG_WITH(gnu-ld,
-[  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]],
-test "$withval" = no || with_gnu_ld=yes, with_gnu_ld=no)
-AC_REQUIRE([AC_PROG_CC])dnl
-AC_REQUIRE([AC_CANONICAL_HOST])dnl
-# Prepare PATH_SEPARATOR.
-# The user is always right.
-if test "${PATH_SEPARATOR+set}" != set; then
-  echo "#! /bin/sh" >conf$$.sh
-  echo  "exit 0"   >>conf$$.sh
-  chmod +x conf$$.sh
-  if (PATH="/nonexistent;."; conf$$.sh) >/dev/null 2>&1; then
-    PATH_SEPARATOR=';'
-  else
-    PATH_SEPARATOR=:
-  fi
-  rm -f conf$$.sh
-fi
-ac_prog=ld
-if test "$GCC" = yes; then
-  # Check if gcc -print-prog-name=ld gives a path.
-  AC_MSG_CHECKING([for ld used by GCC])
-  case $host in
-  *-*-mingw*)
-    # gcc leaves a trailing carriage return which upsets mingw
-    ac_prog=`($CC -print-prog-name=ld) 2>&5 | tr -d '\015'` ;;
-  *)
-    ac_prog=`($CC -print-prog-name=ld) 2>&5` ;;
-  esac
-  case $ac_prog in
-    # Accept absolute paths.
-    [[\\/]* | [A-Za-z]:[\\/]*)]
-      [re_direlt='/[^/][^/]*/\.\./']
-      # Canonicalize the path of ld
-      ac_prog=`echo $ac_prog| sed 's%\\\\%/%g'`
-      while echo $ac_prog | grep "$re_direlt" > /dev/null 2>&1; do
-	ac_prog=`echo $ac_prog| sed "s%$re_direlt%/%"`
-      done
-      test -z "$LD" && LD="$ac_prog"
-      ;;
-  "")
-    # If it fails, then pretend we aren't using GCC.
-    ac_prog=ld
-    ;;
-  *)
-    # If it is relative, then search for the first ld in PATH.
-    with_gnu_ld=unknown
-    ;;
-  esac
-elif test "$with_gnu_ld" = yes; then
-  AC_MSG_CHECKING([for GNU ld])
-else
-  AC_MSG_CHECKING([for non-GNU ld])
-fi
-AC_CACHE_VAL(acl_cv_path_LD,
-[if test -z "$LD"; then
-  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}${PATH_SEPARATOR-:}"
-  for ac_dir in $PATH; do
-    test -z "$ac_dir" && ac_dir=.
-    if test -f "$ac_dir/$ac_prog" || test -f "$ac_dir/$ac_prog$ac_exeext"; then
-      acl_cv_path_LD="$ac_dir/$ac_prog"
-      # Check to see if the program is GNU ld.  I'd rather use --version,
-      # but apparently some GNU ld's only accept -v.
-      # Break only if it was the GNU/non-GNU ld that we prefer.
-      case `"$acl_cv_path_LD" -v 2>&1 < /dev/null` in
-      *GNU* | *'with BFD'*)
-	test "$with_gnu_ld" != no && break ;;
-      *)
-	test "$with_gnu_ld" != yes && break ;;
-      esac
-    fi
-  done
-  IFS="$ac_save_ifs"
-else
-  acl_cv_path_LD="$LD" # Let the user override the test with a path.
-fi])
-LD="$acl_cv_path_LD"
-if test -n "$LD"; then
-  AC_MSG_RESULT($LD)
-else
-  AC_MSG_RESULT(no)
-fi
-test -z "$LD" && AC_MSG_ERROR([no acceptable ld found in \$PATH])
-AC_LIB_PROG_LD_GNU
-])
-
diff --git a/autogen.sh b/autogen.sh
new file mode 100755
index 0000000..a569614
--- /dev/null
+++ b/autogen.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+
+autoreconf -fi;
+rm -Rf autom4te.cache;
diff --git a/configure.in b/configure.in
index aa4dd98..b00a759 100644
--- a/configure.in
+++ b/configure.in
@@ -10,28 +10,26 @@
 #
 
 AC_INIT(libnl, 2.0, tgraf@suug.ch)
-AC_CONFIG_HEADER(lib/defs.h)
-
-save_CFLAGS="${CFLAGS}"
-save_LDFLAGS="${LDFLAGS}"
-save_CPPFLAGS="${CPPFLAGS}"
+AC_CONFIG_HEADERS([lib/defs.h])
+AC_CONFIG_MACRO_DIR([m4])
+AM_INIT_AUTOMAKE([-Wall foreign subdir-objects])
 
 AC_PROG_CC
+AM_PROG_CC_C_O
 AC_PROG_INSTALL
+AM_PROG_LIBTOOL
 
 AC_C_CONST
 AC_C_INLINE
 
-AC_CHECK_LIB(m, pow,
-[
-  LIBM="-lm"
-],[
-    echo
-    echo "*** Error: libm required ***"
-    echo
-])
+AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
+	[Path to the pkgconfig directory [[LIBDIR/pkgconfig]]]),
+	[pkgconfigdir="$withval"], [pkgconfigdir='${libdir}/pkgconfig'])
+AC_SUBST([pkgconfigdir])
 
-LIBNL_LIB="$LIBM"
-AC_SUBST(LIBNL_LIB)
+AC_CHECK_LIB([m], [pow], [], AC_MSG_ERROR([libm is required]))
 
-AC_OUTPUT([Makefile.opts libnl-2.0.pc doc/Doxyfile include/netlink/version.h])
+AC_CONFIG_FILES([Makefile doc/Doxyfile doc/Makefile lib/Makefile
+	include/Makefile src/Makefile libnl-2.0.pc \
+	include/netlink/version.h])
+AC_OUTPUT
diff --git a/doc/Makefile b/doc/Makefile
deleted file mode 100644
index 9c34e0f..0000000
--- a/doc/Makefile
+++ /dev/null
@@ -1,35 +0,0 @@
-#
-# doc/Makefile
-#
-# 	This library is free software; you can redistribute it and/or
-#	modify it under the terms of the GNU Lesser General Public
-#	License as published by the Free Software Foundation version 2.1
-#	of the License.
-#
-# Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
-#
-
-ifeq ($(shell [ ! -r ../Makefile.opts ] && echo 1),)
-    include ../Makefile.opts
-endif
-
-export
-
-.PHONY: all gendoc clean distclean install
-
-all:
-	@true
-
-gendoc:
-	doxygen Doxyfile
-
-clean:
-	@true
-
-distclean:
-	$(RM) -f html/*
-
-install:
-	@true
-
-$(DEPS): ../Makefile.opts
diff --git a/doc/Makefile.am b/doc/Makefile.am
new file mode 100644
index 0000000..040ff87
--- /dev/null
+++ b/doc/Makefile.am
@@ -0,0 +1,9 @@
+# -*- Makefile -*-
+
+.PHONY: gendoc
+
+gendoc:
+	doxygen Doxyfile;
+
+distclean-local:
+	rm -f html/*;
diff --git a/include/Makefile b/include/Makefile
deleted file mode 100644
index 5d7f4fc..0000000
--- a/include/Makefile
+++ /dev/null
@@ -1,42 +0,0 @@
-#
-# include/Makefile
-#
-# 	This library is free software; you can redistribute it and/or
-#	modify it under the terms of the GNU Lesser General Public
-#	License as published by the Free Software Foundation version 2.1
-#	of the License.
-#
-# Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
-#
-
-ifeq ($(shell [ ! -r ../Makefile.opts ] && echo 1),)
-	include ../Makefile.opts
-endif
-
-.PHONY: all clean install 
-
-all:
-	@true
-
-clean:
-	@true
-
-distclean:
-	@true
-
-install:
-	mkdir -p $(DESTDIR)$(includedir)/netlink/route/sch/
-	mkdir -p $(DESTDIR)$(includedir)/netlink/route/cls/
-	mkdir -p $(DESTDIR)$(includedir)/netlink/route/link/
-	mkdir -p $(DESTDIR)$(includedir)/netlink/genl/
-	mkdir -p $(DESTDIR)$(includedir)/netlink/fib_lookup/
-	mkdir -p $(DESTDIR)$(includedir)/netlink/netfilter
-	install -m 0644 netlink/*.h $(DESTDIR)$(includedir)/netlink/
-	install -m 0644 netlink/route/*.h $(DESTDIR)$(includedir)/netlink/route/
-	install -m 0644 netlink/route/sch/*.h $(DESTDIR)$(includedir)/netlink/route/sch/
-	install -m 0644 netlink/route/cls/*.h $(DESTDIR)$(includedir)/netlink/route/cls/
-	install -m 0644 netlink/route/link/*.h $(DESTDIR)$(includedir)/netlink/route/link/
-	install -m 0644 netlink/genl/*.h $(DESTDIR)$(includedir)/netlink/genl/
-	install -m 0644 netlink/fib_lookup/*.h $(DESTDIR)$(includedir)/netlink/fib_lookup/
-	install -m 0644 netlink/netfilter/*.h $(DESTDIR)$(includedir)/netlink/netfilter/
-
diff --git a/include/Makefile.am b/include/Makefile.am
new file mode 100644
index 0000000..cac5c24
--- /dev/null
+++ b/include/Makefile.am
@@ -0,0 +1,67 @@
+# -*- Makefile -*-
+
+nobase_include_HEADERS = \
+	netlink/fib_lookup/lookup.h \
+	netlink/fib_lookup/request.h \
+	netlink/genl/ctrl.h \
+	netlink/genl/family.h \
+	netlink/genl/genl.h \
+	netlink/genl/mngt.h \
+	netlink/netfilter/ct.h \
+	netlink/netfilter/log.h \
+	netlink/netfilter/log_msg.h \
+	netlink/netfilter/netfilter.h \
+	netlink/netfilter/nfnl.h \
+	netlink/netfilter/queue.h \
+	netlink/netfilter/queue_msg.h \
+	netlink/addr.h \
+	netlink/attr.h \
+	netlink/cache-api.h \
+	netlink/cache.h \
+	netlink/data.h \
+	netlink/errno.h \
+	netlink/handlers.h \
+	netlink/list.h \
+	netlink/msg.h \
+	netlink/netlink-compat.h \
+	netlink/netlink-kernel.h \
+	netlink/netlink.h \
+	netlink/object-api.h \
+	netlink/object.h \
+	netlink/route/cls/fw.h \
+	netlink/route/cls/police.h \
+	netlink/route/cls/u32.h \
+	netlink/route/link/info-api.h \
+	netlink/route/link/vlan.h \
+	netlink/route/sch/cbq.h \
+	netlink/route/sch/dsmark.h \
+	netlink/route/sch/fifo.h \
+	netlink/route/sch/htb.h \
+	netlink/route/sch/netem.h \
+	netlink/route/sch/prio.h \
+	netlink/route/sch/red.h \
+	netlink/route/sch/sfq.h \
+	netlink/route/sch/tbf.h \
+	netlink/route/addr.h \
+	netlink/route/class-modules.h \
+	netlink/route/class.h \
+	netlink/route/classifier-modules.h \
+	netlink/route/classifier.h \
+	netlink/route/link.h \
+	netlink/route/neighbour.h \
+	netlink/route/neightbl.h \
+	netlink/route/nexthop.h \
+	netlink/route/qdisc-modules.h \
+	netlink/route/qdisc.h \
+	netlink/route/route.h \
+	netlink/route/rtnl.h \
+	netlink/route/rule.h \
+	netlink/route/tc.h \
+	netlink/socket.h \
+	netlink/types.h \
+	netlink/utils.h \
+	netlink/version.h \
+	netlink-generic.h \
+	netlink-local.h \
+	netlink-tc.h \
+	netlink-types.h
diff --git a/install-sh b/install-sh
deleted file mode 100755
index 6ce63b9..0000000
--- a/install-sh
+++ /dev/null
@@ -1,294 +0,0 @@
-#!/bin/sh
-#
-# install - install a program, script, or datafile
-#
-# This originates from X11R5 (mit/util/scripts/install.sh), which was
-# later released in X11R6 (xc/config/util/install.sh) with the
-# following copyright and license.
-#
-# Copyright (C) 1994 X Consortium
-#
-# Permission is hereby granted, free of charge, to any person obtaining a copy
-# of this software and associated documentation files (the "Software"), to
-# deal in the Software without restriction, including without limitation the
-# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-# sell copies of the Software, and to permit persons to whom the Software is
-# furnished to do so, subject to the following conditions:
-#
-# The above copyright notice and this permission notice shall be included in
-# all copies or substantial portions of the Software.
-#
-# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
-# X CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
-# AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNEC-
-# TION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-#
-# Except as contained in this notice, the name of the X Consortium shall not
-# be used in advertising or otherwise to promote the sale, use or other deal-
-# ings in this Software without prior written authorization from the X Consor-
-# tium.
-#
-#
-# FSF changes to this file are in the public domain.
-#
-# Calling this script install-sh is preferred over install.sh, to prevent
-# `make' implicit rules from creating a file called install from it
-# when there is no Makefile.
-#
-# This script is compatible with the BSD install script, but was written
-# from scratch.  It can only install one file at a time, a restriction
-# shared with many OS's install programs.
-
-
-# set DOITPROG to echo to test this script
-
-# Don't use :- since 4.3BSD and earlier shells don't like it.
-doit="${DOITPROG-}"
-
-
-# put in absolute paths if you don't have them in your path; or use env. vars.
-
-mvprog="${MVPROG-mv}"
-cpprog="${CPPROG-cp}"
-chmodprog="${CHMODPROG-chmod}"
-chownprog="${CHOWNPROG-chown}"
-chgrpprog="${CHGRPPROG-chgrp}"
-stripprog="${STRIPPROG-strip}"
-rmprog="${RMPROG-rm}"
-mkdirprog="${MKDIRPROG-mkdir}"
-
-transformbasename=""
-transform_arg=""
-instcmd="$mvprog"
-chmodcmd="$chmodprog 0755"
-chowncmd=""
-chgrpcmd=""
-stripcmd=""
-rmcmd="$rmprog -f"
-mvcmd="$mvprog"
-src=""
-dst=""
-dir_arg=""
-
-while [ x"$1" != x ]; do
-    case $1 in
-	-c) instcmd=$cpprog
-	    shift
-	    continue;;
-
-	-d) dir_arg=true
-	    shift
-	    continue;;
-
-	-m) chmodcmd="$chmodprog $2"
-	    shift
-	    shift
-	    continue;;
-
-	-o) chowncmd="$chownprog $2"
-	    shift
-	    shift
-	    continue;;
-
-	-g) chgrpcmd="$chgrpprog $2"
-	    shift
-	    shift
-	    continue;;
-
-	-s) stripcmd=$stripprog
-	    shift
-	    continue;;
-
-	-t=*) transformarg=`echo $1 | sed 's/-t=//'`
-	    shift
-	    continue;;
-
-	-b=*) transformbasename=`echo $1 | sed 's/-b=//'`
-	    shift
-	    continue;;
-
-	*)  if [ x"$src" = x ]
-	    then
-		src=$1
-	    else
-		# this colon is to work around a 386BSD /bin/sh bug
-		:
-		dst=$1
-	    fi
-	    shift
-	    continue;;
-    esac
-done
-
-if [ x"$src" = x ]
-then
-	echo "$0: no input file specified" >&2
-	exit 1
-else
-	:
-fi
-
-if [ x"$dir_arg" != x ]; then
-	dst=$src
-	src=""
-
-	if [ -d "$dst" ]; then
-		instcmd=:
-		chmodcmd=""
-	else
-		instcmd=$mkdirprog
-	fi
-else
-
-# Waiting for this to be detected by the "$instcmd $src $dsttmp" command
-# might cause directories to be created, which would be especially bad
-# if $src (and thus $dsttmp) contains '*'.
-
-	if [ -f "$src" ] || [ -d "$src" ]
-	then
-		:
-	else
-		echo "$0: $src does not exist" >&2
-		exit 1
-	fi
-
-	if [ x"$dst" = x ]
-	then
-		echo "$0: no destination specified" >&2
-		exit 1
-	else
-		:
-	fi
-
-# If destination is a directory, append the input filename; if your system
-# does not like double slashes in filenames, you may need to add some logic
-
-	if [ -d "$dst" ]
-	then
-		dst=$dst/`basename "$src"`
-	else
-		:
-	fi
-fi
-
-## this sed command emulates the dirname command
-dstdir=`echo "$dst" | sed -e 's,[^/]*$,,;s,/$,,;s,^$,.,'`
-
-# Make sure that the destination directory exists.
-#  this part is taken from Noah Friedman's mkinstalldirs script
-
-# Skip lots of stat calls in the usual case.
-if [ ! -d "$dstdir" ]; then
-defaultIFS='
-	'
-IFS="${IFS-$defaultIFS}"
-
-oIFS=$IFS
-# Some sh's can't handle IFS=/ for some reason.
-IFS='%'
-set - `echo "$dstdir" | sed -e 's@/@%@g' -e 's@^%@/@'`
-IFS=$oIFS
-
-pathcomp=''
-
-while [ $# -ne 0 ] ; do
-	pathcomp=$pathcomp$1
-	shift
-
-	if [ ! -d "$pathcomp" ] ;
-        then
-		$mkdirprog "$pathcomp"
-	else
-		:
-	fi
-
-	pathcomp=$pathcomp/
-done
-fi
-
-if [ x"$dir_arg" != x ]
-then
-	$doit $instcmd "$dst" &&
-
-	if [ x"$chowncmd" != x ]; then $doit $chowncmd "$dst"; else : ; fi &&
-	if [ x"$chgrpcmd" != x ]; then $doit $chgrpcmd "$dst"; else : ; fi &&
-	if [ x"$stripcmd" != x ]; then $doit $stripcmd "$dst"; else : ; fi &&
-	if [ x"$chmodcmd" != x ]; then $doit $chmodcmd "$dst"; else : ; fi
-else
-
-# If we're going to rename the final executable, determine the name now.
-
-	if [ x"$transformarg" = x ]
-	then
-		dstfile=`basename "$dst"`
-	else
-		dstfile=`basename "$dst" $transformbasename |
-			sed $transformarg`$transformbasename
-	fi
-
-# don't allow the sed command to completely eliminate the filename
-
-	if [ x"$dstfile" = x ]
-	then
-		dstfile=`basename "$dst"`
-	else
-		:
-	fi
-
-# Make a couple of temp file names in the proper directory.
-
-	dsttmp=$dstdir/_inst.$$_
-	rmtmp=$dstdir/_rm.$$_
-
-# Trap to clean up temp files at exit.
-
-	trap 'status=$?; rm -f "$dsttmp" "$rmtmp" && exit $status' 0
-	trap '(exit $?); exit' 1 2 13 15
-
-# Move or copy the file name to the temp name
-
-	$doit $instcmd "$src" "$dsttmp" &&
-
-# and set any options; do chmod last to preserve setuid bits
-
-# If any of these fail, we abort the whole thing.  If we want to
-# ignore errors from any of these, just make sure not to ignore
-# errors from the above "$doit $instcmd $src $dsttmp" command.
-
-	if [ x"$chowncmd" != x ]; then $doit $chowncmd "$dsttmp"; else :;fi &&
-	if [ x"$chgrpcmd" != x ]; then $doit $chgrpcmd "$dsttmp"; else :;fi &&
-	if [ x"$stripcmd" != x ]; then $doit $stripcmd "$dsttmp"; else :;fi &&
-	if [ x"$chmodcmd" != x ]; then $doit $chmodcmd "$dsttmp"; else :;fi &&
-
-# Now remove or move aside any old file at destination location.  We try this
-# two ways since rm can't unlink itself on some systems and the destination
-# file might be busy for other reasons.  In this case, the final cleanup
-# might fail but the new file should still install successfully.
-
-{
-	if [ -f "$dstdir/$dstfile" ]
-	then
-		$doit $rmcmd -f "$dstdir/$dstfile" 2>/dev/null ||
-		$doit $mvcmd -f "$dstdir/$dstfile" "$rmtmp" 2>/dev/null ||
-		{
-		  echo "$0: cannot unlink or rename $dstdir/$dstfile" >&2
-		  (exit 1); exit
-		}
-	else
-		:
-	fi
-} &&
-
-# Now rename the file to the real destination.
-
-	$doit $mvcmd "$dsttmp" "$dstdir/$dstfile"
-
-fi &&
-
-# The final little trick to "correctly" pass the exit status to the exit trap.
-
-{
-	(exit 0); exit
-}
diff --git a/lib/Makefile b/lib/Makefile
deleted file mode 100644
index 80dd1ca..0000000
--- a/lib/Makefile
+++ /dev/null
@@ -1,103 +0,0 @@
-#
-# lib/Makefile
-#
-# 	This library is free software; you can redistribute it and/or
-#	modify it under the terms of the GNU Lesser General Public
-#	License as published by the Free Software Foundation version 2.1
-#	of the License.
-#
-# Copyright (c) 2003-2008 Thomas Graf <tgraf@suug.ch>
-#
-
-ifeq ($(shell [ ! -r ../Makefile.opts ] && echo 1),)
-    include ../Makefile.opts
-endif
-
-CORE_C    := $(wildcard *.c)
-CORE_OBJ  := $(CORE_C:%.c=%.o)
-
-ROUTE_C   := $(wildcard route/*.c)
-ROUTE_C   += $(wildcard route/cls/*.c)
-ROUTE_C   += $(wildcard route/sch/*.c)
-ROUTE_C   += $(wildcard route/link/*.c)
-ROUTE_C   += $(wildcard fib_lookup/*.c)
-ROUTE_OBJ := $(ROUTE_C:%.c=%.o)
-
-GENL_C    := $(wildcard genl/*.c)
-GENL_OBJ  := $(GENL_C:%.c=%.o)
-
-NF_C    := $(wildcard netfilter/*.c)
-NF_OBJ    := $(NF_C:%.c=%.o)
-
-ALL_C     := $(CORE_C) $(ROUTE_C) $(GENL_C) $(NF_C)
-ALL_OBJ   := $(ALL_C:%.c=%.o)
-DEPS      := $(ALL_C:%.c=%.d)
-
-CFLAGS    += -fPIC
-
-CORE_LIB  := $(PACKAGE_NAME).so
-ROUTE_LIB := $(PACKAGE_NAME)-route.so
-GENL_LIB  := $(PACKAGE_NAME)-genl.so
-NF_LIB    := $(PACKAGE_NAME)-nf.so
-LIBS      := $(CORE_LIB) $(ROUTE_LIB) $(GENL_LIB) $(NF_LIB)
-LIBS_V    := $(LIBS:%.so=%.so.$(PACKAGE_VERSION))
-
-export
-
-.PHONY: all clean install $(LIBS)
-
-all:
-	@echo "  MAKE $(LIBS)"; \
-	$(MAKE) $(LIBS)
-
-$(CORE_LIB).$(PACKAGE_VERSION): $(CORE_OBJ)
-	@echo "  LD $@"; \
-	$(CC) -shared -Wl,-soname=$@ -o $@ $^ $(LIBNL_LIB)
-
-$(CORE_LIB): $(CORE_LIB).$(PACKAGE_VERSION)
-	@echo "  LN $@ -> $<"; \
-	$(RM) -f $@; $(LN) $< -s $@
-
-$(ROUTE_LIB).$(PACKAGE_VERSION): $(ROUTE_OBJ) $(CORE_LIB)
-	@echo "  LD $@"; \
-	$(CC) -shared -Wl,-soname=$@ -o $@ $^ $(LIBNL_LIB) -lnl
-
-$(ROUTE_LIB): $(ROUTE_LIB).$(PACKAGE_VERSION)
-	@echo "  LN $@ -> $<"; \
-	$(RM) -f $@; $(LN) $< -s $@
-
-$(GENL_LIB).$(PACKAGE_VERSION): $(GENL_OBJ) $(CORE_LIB)
-	@echo "  LD $@"; \
-	$(CC) -shared -Wl,-soname=$@ -o $@ $^ $(LIBNL_LIB) -lnl
-
-$(GENL_LIB): $(GENL_LIB).$(PACKAGE_VERSION)
-	@echo "  LN $@ -> $<"; \
-	$(RM) -f $@; $(LN) $< -s $@
-
-$(NF_LIB).$(PACKAGE_VERSION): $(NF_OBJ) $(CORE_LIB) $(ROUTE_LIB)
-	@echo "  LD $@"; \
-	$(CC) -shared -Wl,-soname=$@ -o $@ $^ $(LIBNL_LIB) -lnl -lnl-route
-
-$(NF_LIB): $(NF_LIB).$(PACKAGE_VERSION)
-	@echo "  LN $@ -> $<"; \
-	$(RM) -f $@; $(LN) $< -s $@
-
-clean:
-	@echo "  CLEAN lib"; \
-	$(RM) -f $(ALL_OBJ) $(LIBS) $(DEPS) *.so.*
-
-distclean:
-	@echo "  DISTCLEAN lib"; \
-	$(RM) -f $(DEPS)
-
-install:
-	mkdir -p $(DESTDIR)$(libdir)/
-	install -m 0644 $(LIBS_V) $(DESTDIR)$(libdir)
-	$(LN) -sf $(CORE_LIB:%.so=%.so.$(PACKAGE_VERSION)) $(DESTDIR)$(libdir)/$(CORE_LIB)
-	$(LN) -sf $(ROUTE_LIB:%.so=%.so.$(PACKAGE_VERSION)) $(DESTDIR)$(libdir)/$(ROUTE_LIB)
-	$(LN) -sf $(GENL_LIB:%.so=%.so.$(PACKAGE_VERSION)) $(DESTDIR)$(libdir)/$(GENL_LIB)
-	$(LN) -sf $(NF_LIB:%.so=%.so.$(PACKAGE_VERSION)) $(DESTDIR)$(libdir)/$(NF_LIB)
-
-$(DEPS): ../Makefile.opts
-
-include ../Makefile.rules
diff --git a/lib/Makefile.am b/lib/Makefile.am
new file mode 100644
index 0000000..118a077
--- /dev/null
+++ b/lib/Makefile.am
@@ -0,0 +1,40 @@
+# -*- Makefile -*-
+
+AM_CFLAGS = -Wall -I${top_srcdir}/include
+
+lib_LTLIBRARIES = \
+	libnl.la libnl-genl.la libnl-nf.la libnl-route.la
+
+libnl_la_LDFLAGS = -version-info 2:0:0
+libnl_la_SOURCES = \
+	addr.c attr.c cache.c cache_mngr.c cache_mngt.c data.c doc.c \
+	error.c handlers.c msg.c nl.c object.c socket.c utils.c
+
+libnl_genl_la_LDFLAGS = -version-info 2:0:0
+libnl_genl_la_SOURCES = \
+	genl/ctrl.c genl/family.c genl/genl.c genl/mngt.c
+
+libnl_nf_la_LDFLAGS = -version-info 2:0:0
+libnl_nf_la_SOURCES = \
+	netfilter/ct.c netfilter/ct_obj.c netfilter/log.c \
+	netfilter/log_msg.c netfilter/log_msg_obj.c netfilter/log_obj.c \
+	netfilter/netfilter.c netfilter/nfnl.c netfilter/queue.c \
+	netfilter/queue_msg.c netfilter/queue_msg_obj.c netfilter/queue_obj.c
+
+libnl_route_la_LDFLAGS = -version-info 2:0:0
+libnl_route_la_SOURCES = \
+	route/addr.c route/class.c route/class_api.c route/class_obj.c \
+	route/classifier.c route/cls_api.c route/cls_obj.c route/link.c \
+	route/neigh.c route/neightbl.c route/nexthop.c route/qdisc.c \
+	route/qdisc_api.c route/qdisc_obj.c route/route.c route/route_obj.c \
+	route/route_utils.c route/rtnl.c route/rule.c route/tc.c \
+	\
+	route/cls/fw.c route/cls/police.c route/cls/u32.c \
+	\
+	route/link/api.c route/link/vlan.c \
+	\
+	route/sch/blackhole.c route/sch/cbq.c route/sch/dsmark.c \
+	route/sch/fifo.c route/sch/htb.c route/sch/netem.c route/sch/prio.c \
+	route/sch/red.c route/sch/sfq.c route/sch/tbf.c \
+	\
+	fib_lookup/lookup.c fib_lookup/request.c
diff --git a/lib/defs.h.in b/lib/defs.h.in
deleted file mode 100644
index e5cf72b..0000000
--- a/lib/defs.h.in
+++ /dev/null
@@ -1,25 +0,0 @@
-/* lib/defs.h.in.  Generated from configure.in by autoheader.  */
-
-/* Define to the address where bug reports for this package should be sent. */
-#undef PACKAGE_BUGREPORT
-
-/* Define to the full name of this package. */
-#undef PACKAGE_NAME
-
-/* Define to the full name and version of this package. */
-#undef PACKAGE_STRING
-
-/* Define to the one symbol short name of this package. */
-#undef PACKAGE_TARNAME
-
-/* Define to the version of this package. */
-#undef PACKAGE_VERSION
-
-/* Define to empty if `const' does not conform to ANSI C. */
-#undef const
-
-/* Define to `__inline__' or `__inline' if that's what the C compiler
-   calls it, or to nothing if 'inline' is not supported under any name.  */
-#ifndef __cplusplus
-#undef inline
-#endif
diff --git a/libnl-2.0.pc.in b/libnl-2.0.pc.in
index 6ad102d..e44f0fb 100644
--- a/libnl-2.0.pc.in
+++ b/libnl-2.0.pc.in
@@ -1,7 +1,7 @@
 prefix=@prefix@
-exec_prefix=@prefix@
+exec_prefix=@exec_prefix@
 libdir=@libdir@
-includedir=@prefix@/include
+includedir=@includedir@
 
 Name: libnl
 Description: Convenience library for netlink sockets
diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..8d0c756
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1,2 @@
+/lt*.m4
+/libtool.m4
diff --git a/src/Makefile b/src/Makefile
deleted file mode 100644
index 6a7bfd2..0000000
--- a/src/Makefile
+++ /dev/null
@@ -1,62 +0,0 @@
-#
-# src/Makefile
-#
-# 	This library is free software; you can redistribute it and/or
-#	modify it under the terms of the GNU Lesser General Public
-#	License as published by the Free Software Foundation version 2.1
-#	of the License.
-#
-# Copyright (c) 2003-2008 Thomas Graf <tgraf@suug.ch>
-#
-
-ifeq ($(shell [ ! -r ../Makefile.opts ] && echo 1),)
-    include ../Makefile.opts
-endif
-
-LDFLAGS	+= -L../lib -lnl
-CIN 	:= $(wildcard nl-*.c) $(wildcard genl-*.c) $(wildcard nf-*.c)
-TOOLS	:= $(CIN:%.c=%)
-
-all: $(TOOLS)
-
-$(TOOLS): utils.o
-nl-route-add nl-route-delete nl-route-list: route-utils.o rtnl-utils.o
-nl-route-get: rtnl-utils.o
-nl-addr-add nl-addr-delete nl-addr-list: addr-utils.o rtnl-utils.o
-nl-link-list nl-link-set nl-link-stats: link-utils.o rtnl-utils.o
-nl-link-ifindex2name nl-link-name2ifindex: rtnl-utils.o
-nl-neigh-add nl-neigh-delete nl-neigh-list: neigh-utils.o rtnl-utils.o
-nl-qdisc-delete nl-qdisc-list: qdisc-utils.o rtnl-utils.o
-nl-rule-list: rule-utils.o rtnl-utils.o
-nl-neightbl-list: rtnl-utils.o
-nl-monitor: rtnl-utils.o
-nl-tctree-list: rtnl-utils.o
-
-genl-ctrl-list: ctrl-utils.o
-
-nf-ct-list: ct-utils.o
-nf-log: log-utils.o rtnl-utils.o
-nf-queue: queue-utils.o rtnl-utils.o
-
-nl-%: nl-%.o
-	@echo "  LD $@"; \
-	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) -lnl-route
-
-genl-%: genl-%.o
-	@echo "  LD $@"; \
-	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) -lnl-genl
-
-nf-%: nf-%.o
-	@echo "  LD $@"; \
-	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) -lnl-nf -lnl-route
-
-clean:
-	@echo "  CLEAN src"; \
-	rm -f $(TOOLS) *.o
-
-distclean: clean
-
-install:
-	@true
-
-include ../Makefile.rules
diff --git a/src/Makefile.am b/src/Makefile.am
new file mode 100644
index 0000000..9f52cd6
--- /dev/null
+++ b/src/Makefile.am
@@ -0,0 +1,86 @@
+# -*- Makefile -*-
+
+AM_CFLAGS  = -Wall -I${top_srcdir}/include
+AM_LDFLAGS = -L${top_builddir}/lib
+
+noinst_PROGRAMS = \
+	genl-ctrl-list \
+	nf-ct-list nf-log nf-queue \
+	nl-addr-add nl-addr-delete nl-addr-list \
+	nl-link-list nl-link-set nl-link-stats \
+	nl-link-ifindex2name nl-link-name2ifindex \
+	nl-neigh-add nl-neigh-delete nl-neigh-list \
+	nl-qdisc-delete nl-qdisc-list \
+	nl-rule-list \
+	nl-neightbl-list \
+	nl-monitor \
+	nl-tctree-list \
+	nl-route-add nl-route-delete nl-route-get nl-route-list
+
+rtnl_utils_c = rtnl-utils.c utils.c
+
+genl_ctrl_list_SOURCES = genl-ctrl-list.c ctrl-utils.c utils.c
+genl_ctrl_list_LDADD = -lnl -lnl-genl
+
+nf_ct_list_SOURCES = nf-ct-list.c ct-utils.c utils.c
+nf_ct_list_LDADD = -lnl -lnl-nf -lnl-route
+nf_log_SOURCES = nf-log.c log-utils.c ${rtnl_utils_c}
+nf_log_LDADD = -lnl -lnl-nf -lnl-route
+nf_queue_SOURCES = nf-queue.c queue-utils.c ${rtnl_utils_c}
+nf_queue_LDADD = -lnl -lnl-nf -lnl-route
+
+addr_c = addr-utils.c ${rtnl_utils_c}
+nl_addr_add_SOURCES = nl-addr-add.c ${addr_c}
+nl_addr_add_LDADD = -lnl -lnl-route
+nl_addr_delete_SOURCES = nl-addr-delete.c ${addr_c}
+nl_addr_delete_LDADD = -lnl -lnl-route
+nl_addr_list_SOURCES = nl-addr-list.c ${addr_c}
+nl_addr_list_LDADD = -lnl -lnl-route
+
+link_c = link-utils.c ${rtnl_utils_c}
+nl_link_list_SOURCES = nl-link-list.c ${link_c}
+nl_link_list_LDADD = -lnl -lnl-route
+nl_link_set_SOURCES = nl-link-set.c ${link_c}
+nl_link_set_LDADD = -lnl -lnl-route
+nl_link_stats_SOURCES = nl-link-stats.c ${link_c}
+nl_link_stats_LDADD = -lnl -lnl-route
+nl_link_ifindex2name_SOURCES = nl-link-ifindex2name.c ${rtnl_utils_c}
+nl_link_ifindex2name_LDADD = -lnl -lnl-route
+nl_link_name2ifindex_SOURCES = nl-link-name2ifindex.c ${rtnl_utils_c}
+nl_link_name2ifindex_LDADD = -lnl -lnl-route
+
+nl_monitor_SOURCES = nl-monitor.c ${rtnl_utils_c}
+nl_monitor_LDADD = -lnl -lnl-route
+
+neigh_c = neigh-utils.c ${rtnl_utils_c}
+nl_neigh_add_SOURCES = nl-neigh-add.c ${neigh_c}
+nl_neigh_add_LDADD = -lnl -lnl-route
+nl_neigh_delete_SOURCES = nl-neigh-delete.c ${neigh_c}
+nl_neigh_delete_LDADD = -lnl -lnl-route
+nl_neigh_list_SOURCES = nl-neigh-list.c ${neigh_c}
+nl_neigh_list_LDADD = -lnl -lnl-route
+
+nl_neightbl_list_SOURCES = nl-neightbl-list.c ${rtnl_utils_c}
+nl_neightbl_list_LDADD = -lnl -lnl-route
+
+qdisc_c = qdisc-utils.c ${rtnl_utils_c}
+nl_qdisc_delete_SOURCES = nl-qdisc-delete.c ${qdisc_c}
+nl_qdisc_delete_LDADD = -lnl -lnl-route
+nl_qdisc_list_SOURCES = nl-qdisc-list.c ${qdisc_c}
+nl_qdisc_list_LDADD = -lnl -lnl-route
+
+route_c = route-utils.c ${rtnl_utils_c}
+nl_route_add_SOURCES = nl-route-add.c ${route_c}
+nl_route_add_LDADD = -lnl -lnl-route
+nl_route_delete_SOURCES = nl-route-delete.c ${route_c}
+nl_route_delete_LDADD = -lnl -lnl-route
+nl_route_get_SOURCES = nl-route-get.c ${route_c}
+nl_route_get_LDADD = -lnl -lnl-route
+nl_route_list_SOURCES = nl-route-list.c ${route_c}
+nl_route_list_LDADD = -lnl -lnl-route
+
+nl_rule_list_SOURCES = nl-rule-list.c rule-utils.c ${rtnl_utils_c}
+nl_rule_list_LDADD = -lnl -lnl-route
+
+nl_tctree_list_SOURCES = nl-tctree-list.c ${rtnl_utils_c}
+nl_tctree_list_LDADD = -lnl -lnl-route
-- 
1.6.3.3

