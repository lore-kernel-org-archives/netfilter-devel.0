From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 6/6] ulogd2 changes
Date: Mon, 31 Jul 2006 10:23:11 +0200
Message-ID: <200607311023.11145@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_v3bzEbsrD8ooxLb"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_v3bzEbsrD8ooxLb
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  Attached are the changes to ulogd2.

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_v3bzEbsrD8ooxLb
Content-Type: text/x-diff;
  charset="us-ascii";
  name="06-ulogd2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="06-ulogd2.patch"

Index: ulogd2/configure.in
===================================================================
--- ulogd2/configure.in	(revision 6652)
+++ ulogd2/configure.in	(working copy)
@@ -2,7 +2,7 @@
 AC_INIT
 
 AM_INIT_AUTOMAKE(ulogd, 2.0.0beta2)
-AM_CONFIG_HEADER(config.h)
+# AM_CONFIG_HEADER(config.h)
 
 dnl Checks for programs.
 AC_PROG_MAKE_SET
@@ -28,13 +28,14 @@
 AC_FUNC_VPRINTF
 AC_CHECK_FUNCS(socket strerror)
 
-AC_CHECK_HEADER([libnetfilter_log/linux_nfnetlink_log.h], [AC_MSG_RESULT([found])],
-		[AC_MSG_ERROR([libnetfilter_log Version 0.0.11 or later needed])])
+LIBNFCONNTRACK_REQUIRED=0.0.31
+LIBNFLOG_REQUIRED=0.0.11
+ 
+PKG_CHECK_MODULES(LIBNFCONNTRACK, libnetfilter_conntrack >= $LIBNFCONNTRACK_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNFCONNTRACK_REQUIRED))
+PKG_CHECK_MODULES(LIBNFLOG, libnetfilter_log >= $LIBNFLOG_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnetfilter_log >= $LIBNFLOG_REQUIRED))
 
-AC_CHECK_HEADER([libnetfilter_conntrack/libnetfilter_conntrack.h], [AC_MSG_RESULT([found])],
-		[AC_MSG_ERROR([libnetfilter_conntrack Version 0.0.11 or later needed])])
-
-
 CT_CHECK_POSTGRES_DB()
 AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
 
@@ -61,6 +62,11 @@
 dnl AM_CONDITIONAL(HAVE_MYSQL, test x$mysqldir != x)
 dnl AM_CONDITIONAL(HAVE_PGSQL, test x$pgsqldir != x)
 
+CFLAGS="$CFLAGS $LIBNFCONNTRACK_CFLAGS $LIBNFLOG_CFLAGS"
+
+AC_SUBST(LIBNFCONNTRACK_LIBS)
+AC_SUBST(LIBNFLOG_LIBS)
+
 AC_OUTPUT(doc/Makefile \
 	  include/Makefile include/ulogd/Makefile include/libipulog/Makefile \
 	  libipulog/Makefile \
Index: ulogd2/input/flow/Makefile.am
===================================================================
--- ulogd2/input/flow/Makefile.am	(revision 6652)
+++ ulogd2/input/flow/Makefile.am	(working copy)
@@ -1,11 +1,12 @@
 
 INCLUDES = $(all_includes) -I$(top_srcdir)/include
-AM_CFLAGS=-fPIC -Wall
+AM_CFLAGS = -fPIC -Wall
+LIBS = @LIBNFCONNTRACK_LIBS@
 
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
-ulogd_inpflow_NFCT_la_LDFLAGS = -module -lnetfilter_conntrack
+ulogd_inpflow_NFCT_la_LDFLAGS = -module
 
 #ulogd_inpflow_IPFIX_la_SOURCES = ulogd_inpflow_IPFIX.c
 #ulogd_inpflow_IPFIX_la_LDFLAGS = -module
Index: ulogd2/input/packet/Makefile.am
===================================================================
--- ulogd2/input/packet/Makefile.am	(revision 6652)
+++ ulogd2/input/packet/Makefile.am	(working copy)
@@ -1,12 +1,12 @@
 
 INCLUDES = $(all_includes) -I$(top_srcdir)/include
-AM_CFLAGS=-fPIC -Wall
-LIBS=
+AM_CFLAGS = -fPIC -Wall
+LIBS = @LIBNFLOG_LIBS@
 
 pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
-ulogd_inppkt_NFLOG_la_LDFLAGS = -module -lnetfilter_log
+ulogd_inppkt_NFLOG_la_LDFLAGS = -module
 
 ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
 ulogd_inppkt_ULOG_la_LDFLAGS = -module

--Boundary-00=_v3bzEbsrD8ooxLb--
