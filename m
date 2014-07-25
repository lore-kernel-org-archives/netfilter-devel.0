From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 3/8] autotool conversion: use pkg-config to find 'libmnl', libnftnl' and 'ncurses'.
Date: Fri, 25 Jul 2014 23:52:54 +0159
Message-ID: <1406325204-23648-4-git-send-email-giorgio.nicole@arcor.de>
References: <20140725171646.GA5718@salvia>
 <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:56780 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933391AbaGYVyq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:54:46 -0400
Received: from mail-in-03-z2.arcor-online.net (mail-in-03-z2.arcor-online.net [151.189.8.15])
	by mx.arcor.de (Postfix) with ESMTP id 034D7E3B9C
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2014 23:54:45 +0200 (CEST)
In-Reply-To: <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use pkg-config to find the compile and link flags for 'libnftnl' and
'libmnl'.

Use the special macro AX_LIB_READLINE to check for libreadline and its
dependencies.

The macro is part of the 'autoconf-archive' project:

https://www.gnu.org/software/autoconf-archive/ax_lib_readline.html
---
 configure.ac          |  15 ++++---
 m4/ax_lib_readlibe.m4 | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 src/Makefile.am       |  44 +++++++++++++++++++++
 3 files changed, 158 insertions(+), 8 deletions(-)
 create mode 100644 m4/ax_lib_readlibe.m4
 create mode 100644 src/Makefile.am

diff --git a/configure.ac b/configure.ac
index 3a7647f..605d39d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -62,17 +62,16 @@ then
 fi
 
 # Checks for libraries.
-AC_CHECK_LIB([mnl], [mnl_socket_open], ,
-	     AC_MSG_ERROR([No suitable version of libmnl found]))
 
-AC_CHECK_LIB([nftnl], [nft_rule_alloc], ,
-	     AC_MSG_ERROR([No suitable version of libnftnl found]))
+dnl Check for package libnftnl
+PKG_CHECK_MODULES(LIBMNL, [libmnl], , AC_MSG_ERROR([No suitable version of libmnl found]))
 
-AC_CHECK_LIB([gmp], [__gmpz_init], ,
-	     AC_MSG_ERROR([No suitable version of libgmp found]))
+dnl Check for package libnftnl
+PKG_CHECK_MODULES(LIBNFTNL, [libnftnl], , AC_MSG_ERROR([No suitable version of libnftnl found]))
 
-AC_CHECK_LIB([readline], [readline], ,
-	     AC_MSG_ERROR([No suitable version of libreadline found]))
+AC_CHECK_LIB([gmp], [__gmpz_init], , AC_MSG_ERROR([No suitable version of libgmp found]))
+
+AX_LIB_READLINE
 
 # Checks for header files.
 AC_HEADER_STDC
diff --git a/m4/ax_lib_readlibe.m4 b/m4/ax_lib_readlibe.m4
new file mode 100644
index 0000000..056f25c
--- /dev/null
+++ b/m4/ax_lib_readlibe.m4
@@ -0,0 +1,107 @@
+# ===========================================================================
+#      http://www.gnu.org/software/autoconf-archive/ax_lib_readline.html
+# ===========================================================================
+#
+# SYNOPSIS
+#
+#   AX_LIB_READLINE
+#
+# DESCRIPTION
+#
+#   Searches for a readline compatible library. If found, defines
+#   `HAVE_LIBREADLINE'. If the found library has the `add_history' function,
+#   sets also `HAVE_READLINE_HISTORY'. Also checks for the locations of the
+#   necessary include files and sets `HAVE_READLINE_H' or
+#   `HAVE_READLINE_READLINE_H' and `HAVE_READLINE_HISTORY_H' or
+#   'HAVE_HISTORY_H' if the corresponding include files exists.
+#
+#   The libraries that may be readline compatible are `libedit',
+#   `libeditline' and `libreadline'. Sometimes we need to link a termcap
+#   library for readline to work, this macro tests these cases too by trying
+#   to link with `libtermcap', `libcurses' or `libncurses' before giving up.
+#
+#   Here is an example of how to use the information provided by this macro
+#   to perform the necessary includes or declarations in a C file:
+#
+#     #ifdef HAVE_LIBREADLINE
+#     #  if defined(HAVE_READLINE_READLINE_H)
+#     #    include <readline/readline.h>
+#     #  elif defined(HAVE_READLINE_H)
+#     #    include <readline.h>
+#     #  else /* !defined(HAVE_READLINE_H) */
+#     extern char *readline ();
+#     #  endif /* !defined(HAVE_READLINE_H) */
+#     char *cmdline = NULL;
+#     #else /* !defined(HAVE_READLINE_READLINE_H) */
+#       /* no readline */
+#     #endif /* HAVE_LIBREADLINE */
+#
+#     #ifdef HAVE_READLINE_HISTORY
+#     #  if defined(HAVE_READLINE_HISTORY_H)
+#     #    include <readline/history.h>
+#     #  elif defined(HAVE_HISTORY_H)
+#     #    include <history.h>
+#     #  else /* !defined(HAVE_HISTORY_H) */
+#     extern void add_history ();
+#     extern int write_history ();
+#     extern int read_history ();
+#     #  endif /* defined(HAVE_READLINE_HISTORY_H) */
+#       /* no history */
+#     #endif /* HAVE_READLINE_HISTORY */
+#
+# LICENSE
+#
+#   Copyright (c) 2008 Ville Laurikari <vl@iki.fi>
+#
+#   Copying and distribution of this file, with or without modification, are
+#   permitted in any medium without royalty provided the copyright notice
+#   and this notice are preserved. This file is offered as-is, without any
+#   warranty.
+
+#serial 6
+
+AU_ALIAS([VL_LIB_READLINE], [AX_LIB_READLINE])
+AC_DEFUN([AX_LIB_READLINE], [
+  AC_CACHE_CHECK([for a readline compatible library],
+                 ax_cv_lib_readline, [
+    ORIG_LIBS="$LIBS"
+    for readline_lib in readline edit editline; do
+      for termcap_lib in "" termcap curses ncurses; do
+        if test -z "$termcap_lib"; then
+          TRY_LIB="-l$readline_lib"
+        else
+          TRY_LIB="-l$readline_lib -l$termcap_lib"
+        fi
+        LIBS="$ORIG_LIBS $TRY_LIB"
+        AC_TRY_LINK_FUNC(readline, ax_cv_lib_readline="$TRY_LIB")
+        if test -n "$ax_cv_lib_readline"; then
+          break
+        fi
+      done
+      if test -n "$ax_cv_lib_readline"; then
+        break
+      fi
+    done
+    if test -z "$ax_cv_lib_readline"; then
+      ax_cv_lib_readline="no"
+    fi
+    LIBS="$ORIG_LIBS"
+  ])
+
+  if test "$ax_cv_lib_readline" != "no"; then
+    LIBS="$LIBS $ax_cv_lib_readline"
+    AC_DEFINE(HAVE_LIBREADLINE, 1,
+              [Define if you have a readline compatible library])
+    AC_CHECK_HEADERS(readline.h readline/readline.h)
+    AC_CACHE_CHECK([whether readline supports history],
+                   ax_cv_lib_readline_history, [
+      ax_cv_lib_readline_history="no"
+      AC_TRY_LINK_FUNC(add_history, ax_cv_lib_readline_history="yes")
+    ])
+    if test "$ax_cv_lib_readline_history" = "yes"; then
+      AC_DEFINE(HAVE_READLINE_HISTORY, 1,
+                [Define if your readline library has \`add_history'])
+      AC_CHECK_HEADERS(history.h readline/history.h)
+    fi
+  fi
+])dnl
diff --git a/src/Makefile.am b/src/Makefile.am
new file mode 100644
index 0000000..5f19732
--- /dev/null
+++ b/src/Makefile.am
@@ -0,0 +1,44 @@
+sbin_PROGRAMS = nft
+
+nft_CFLAGS =	-fno-strict-aliasing							\
+		-Wall									\
+		-Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations		\
+		-Wdeclaration-after-statement -Wsign-compare -Winit-self		\
+		-Wformat-nonliteral -Wformat-security -Wmissing-format-attribute	\
+		-Wcast-align -Wundef -Wbad-function-cast				\
+		-Waggregate-return -Wunused -Wwrite-strings
+
+nft_CPPFLAGS = -I${srcdir}/../include ${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}
+
+nft_LDADD = ${LIBMNL_LIBS} ${LIBNFTNL_LIBS}
+
+AM_YFLAGS = -d
+BUILT_SOURCES =	scanner.c scanner.h yacc_parser.c yacc_parser.h
+
+scanner.h: scanner.c
+
+nft_SOURCES = 	main.c				\
+		cli.c				\
+		rule.c				\
+		statement.c			\
+		datatype.c			\
+		expression.c			\
+		evaluate.c			\
+		proto.c				\
+		payload.c			\
+		exthdr.c			\
+		meta.c				\
+		ct.c				\
+		netlink.c			\
+		netlink_linearize.c		\
+		netlink_delinearize.c		\
+		segtree.c			\
+		rbtree.c			\
+		gmputil.c			\
+		utils.c				\
+		erec.c				\
+		mnl.c				\
+		scanner.l			\
+		yacc_parser.y
+
+CLEANFILES = *~ scanner.c scanner.h yacc_parser.c yacc_parser.h
-- 
2.0.3

