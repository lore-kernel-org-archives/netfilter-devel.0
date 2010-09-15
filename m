From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/4] libiptc: build with -Wl,--no-as-needed
Date: Wed, 15 Sep 2010 20:53:46 +0200
Message-ID: <1284576828-32412-4-git-send-email-jengelh@medozas.de>
References: <1284576828-32412-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46826 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab0IOSx5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:53:57 -0400
In-Reply-To: <1284576828-32412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since libiptc does not reference any symbols in libip(4|6)tc, the linker
may ignore the dependencies. Use --no-as-needed to explicitly force a
DT_NEEDED entry.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=674
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am                 |    4 +-
 configure.ac                |    5 +++
 m4/ax_check_linker_flags.m4 |   78 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 2 deletions(-)
 create mode 100644 m4/ax_check_linker_flags.m4

diff --git a/Makefile.am b/Makefile.am
index 2a63cc7..7f0eb2f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -20,11 +20,11 @@ lib_LTLIBRARIES =
 lib_LTLIBRARIES           += libiptc/libip4tc.la libiptc/libip6tc.la libiptc/libiptc.la
 libiptc_libiptc_la_SOURCES  =
 libiptc_libiptc_la_LIBADD   = libiptc/libip4tc.la libiptc/libip6tc.la
-libiptc_libiptc_la_LDFLAGS  = -version-info 0:0:0
+libiptc_libiptc_la_LDFLAGS  = -version-info 0:0:0 ${libiptc_LDFLAGS2}
 libiptc_libip4tc_la_SOURCES = libiptc/libip4tc.c
 libiptc_libip4tc_la_LDFLAGS = -version-info 0:0:0
 libiptc_libip6tc_la_SOURCES = libiptc/libip6tc.c
-libiptc_libip6tc_la_LDFLAGS = -version-info 0:0:0
+libiptc_libip6tc_la_LDFLAGS = -version-info 0:0:0 ${libiptc_LDFLAGS2}
 
 lib_LTLIBRARIES      += libxtables.la
 libxtables_la_SOURCES = xtables.c
diff --git a/configure.ac b/configure.ac
index 3b26f54..6010afd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -52,6 +52,11 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 	[Path to the pkgconfig directory [[LIBDIR/pkgconfig]]]),
 	[pkgconfigdir="$withval"], [pkgconfigdir='${libdir}/pkgconfig'])
 
+libiptc_LDFLAGS2="";
+AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
+	[libiptc_LDFLAGS2="-Wl,--no-as-needed"])
+AC_SUBST([libiptc_LDFLAGS2])
+
 blacklist_modules="";
 
 AC_CHECK_HEADER([linux/dccp.h])
diff --git a/m4/ax_check_linker_flags.m4 b/m4/ax_check_linker_flags.m4
new file mode 100644
index 0000000..ba7bf3c
--- /dev/null
+++ b/m4/ax_check_linker_flags.m4
@@ -0,0 +1,78 @@
+#http://git.savannah.gnu.org/gitweb/?p=autoconf-archive.git;a=blob_plain;f=m4/ax_check_linker_flags.m4
+# ===========================================================================
+#   http://www.gnu.org/software/autoconf-archive/ax_check_linker_flags.html
+# ===========================================================================
+#
+# SYNOPSIS
+#
+#   AX_CHECK_LINKER_FLAGS(FLAGS, [ACTION-SUCCESS], [ACTION-FAILURE])
+#
+# DESCRIPTION
+#
+#   Check whether the given linker FLAGS work with the current language's
+#   linker, or whether they give an error.
+#
+#   ACTION-SUCCESS/ACTION-FAILURE are shell commands to execute on
+#   success/failure.
+#
+#   NOTE: Based on AX_CHECK_COMPILER_FLAGS.
+#
+# LICENSE
+#
+#   Copyright (c) 2009 Mike Frysinger <vapier@gentoo.org>
+#   Copyright (c) 2009 Steven G. Johnson <stevenj@alum.mit.edu>
+#   Copyright (c) 2009 Matteo Frigo
+#
+#   This program is free software: you can redistribute it and/or modify it
+#   under the terms of the GNU General Public License as published by the
+#   Free Software Foundation, either version 3 of the License, or (at your
+#   option) any later version.
+#
+#   This program is distributed in the hope that it will be useful, but
+#   WITHOUT ANY WARRANTY; without even the implied warranty of
+#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
+#   Public License for more details.
+#
+#   You should have received a copy of the GNU General Public License along
+#   with this program. If not, see <http://www.gnu.org/licenses/>.
+#
+#   As a special exception, the respective Autoconf Macro's copyright owner
+#   gives unlimited permission to copy, distribute and modify the configure
+#   scripts that are the output of Autoconf when processing the Macro. You
+#   need not follow the terms of the GNU General Public License when using
+#   or distributing such scripts, even though portions of the text of the
+#   Macro appear in them. The GNU General Public License (GPL) does govern
+#   all other use of the material that constitutes the Autoconf Macro.
+#
+#   This special exception to the GPL applies to versions of the Autoconf
+#   Macro released by the Autoconf Archive. When you make and distribute a
+#   modified version of the Autoconf Macro, you may extend this special
+#   exception to the GPL to apply to your modified version as well.
+
+#serial 6
+
+AC_DEFUN([AX_CHECK_LINKER_FLAGS],
+[AC_MSG_CHECKING([whether the linker accepts $1])
+dnl Some hackery here since AC_CACHE_VAL can't handle a non-literal varname:
+AS_LITERAL_IF([$1],
+  [AC_CACHE_VAL(AS_TR_SH(ax_cv_linker_flags_[$1]), [
+      ax_save_FLAGS=$LDFLAGS
+      LDFLAGS="$1"
+      AC_LINK_IFELSE([AC_LANG_PROGRAM()],
+        AS_TR_SH(ax_cv_linker_flags_[$1])=yes,
+        AS_TR_SH(ax_cv_linker_flags_[$1])=no)
+      LDFLAGS=$ax_save_FLAGS])],
+  [ax_save_FLAGS=$LDFLAGS
+   LDFLAGS="$1"
+   AC_LINK_IFELSE([AC_LANG_PROGRAM()],
+     eval AS_TR_SH(ax_cv_linker_flags_[$1])=yes,
+     eval AS_TR_SH(ax_cv_linker_flags_[$1])=no)
+   LDFLAGS=$ax_save_FLAGS])
+eval ax_check_linker_flags=$AS_TR_SH(ax_cv_linker_flags_[$1])
+AC_MSG_RESULT($ax_check_linker_flags)
+if test "x$ax_check_linker_flags" = xyes; then
+	m4_default([$2], :)
+else
+	m4_default([$3], :)
+fi
+])dnl AX_CHECK_LINKER_FLAGS
-- 
1.7.1

