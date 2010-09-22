From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 3/6] build: add debug configure flag
Date: Wed, 22 Sep 2010 02:47:19 +0200
Message-ID: <1285116442-32490-4-git-send-email-eric@inl.fr>
References: <1285116442-32490-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:50843 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab0IVBEz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 21:04:55 -0400
In-Reply-To: <1285116442-32490-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a debug option for configure which do some set
compile option useful for debugging.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 configure.ac    |   11 +++++++++--
 src/Makefile.am |    4 ++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index af14f36..0819a17 100644
--- a/configure.ac
+++ b/configure.ac
@@ -31,8 +31,6 @@ dnl Checks for library functions.
 AC_FUNC_VPRINTF
 AC_CHECK_FUNCS(socket strerror)
 
-CFLAGS="$CFLAGS -Wall -Wextra -Wno-unused-parameter"
-
 dnl Check for the right nfnetlink version
 LIBNFNETLINK_REQUIRED=0.0.39
 LIBNETFILTER_CONNTRACK_REQUIRED=0.0.95
@@ -55,6 +53,8 @@ if test "${build_nflog}" = "yes"; then
 fi
 
 
+AC_ARG_ENABLE(debug,   [AC_HELP_STRING(--enable-debug, Do build ulogd in debug mode)],build_debug=$enableval, build_debug="no")
+
 CT_CHECK_POSTGRES_DB()
 AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
 
@@ -73,6 +73,13 @@ AM_CONDITIONAL(HAVE_PCAP, test "x$PCAP_LIB" != "x")
 AM_CONDITIONAL(HAVE_NFCT, test "x$build_nfct" != "xno")
 AM_CONDITIONAL(HAVE_NFLOG, test "x$build_nflog" != "xno")
 
+AM_CONDITIONAL(HAVE_DEBUG, test "x$build_debug" != "xno")
+
+if test "${build_debug}" = "yes" ; then
+	CFLAGS="$CFLAGS -O0 -Wall -Wextra -Wno-unused-parameter"
+else
+	CFLAGS="$CFLAGS -Wall -Wextra -Wno-unused-parameter"
+fi
 
 dnl AC_SUBST(DATABASE_DIR)
 dnl AC_SUBST(DATABASE_LIB)
diff --git a/src/Makefile.am b/src/Makefile.am
index aa9a3fa..26e0e53 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,4 +6,8 @@ AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include \
 sbin_PROGRAMS = ulogd
 
 ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c
+if HAVE_DEBUG
+ulogd_LDFLAGS = -lpthread -export-dynamic
+else
 ulogd_LDFLAGS = -export-dynamic
+endif
-- 
1.6.1

