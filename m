From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [RFC][PATCH] use of pkg-config in libnetfilter_*, conntrack,
	and ulogd2
Date: Sun, 19 Mar 2006 23:24:48 +0100
Message-ID: <200603192324.50444@krak>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yodHEKQx+Usd58a"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>, Harald Welte <laforge@netfilter.org>
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

--Boundary-00=_yodHEKQx+Usd58a
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  This weekend I've spent a significant amount of time configuring and 
compiling the whole libnetfilter_* universe and the conntrack and ulogd2 
tools. My initial plan was to install everything under /opt/netfilter, 
however, the out-of-the-box configure.in files provided with these 
modules do not make this particularly easy.

  So after spending some time trying all kinds of mantras and magical 
runes to get autoconfuse do what I intended to do, I came to the 
conclusion that all this would be much simpler if we used the PKG_CHECK_* 
macros in configure.in. The necessary pkgconfig .pc files are generated 
and installed anyway, so why not?

  Of course this means that to compile these modules one will need 
pkg-config, but personally I don't consider this a problem. The 
additional benefit of this method would be that the only thing to take 
care of is that of setting a correct PKG_CONFIG_PATH, all the include 
paths and libraries are then found magically.

  Patches for libnetfilter_{conntrack,cthelper,log,queue}, conntrack and 
ulogd2 attached.

-- 
 KOVACS Krisztian

--Boundary-00=_yodHEKQx+Usd58a
Content-Type: text/x-diff; charset="us-ascii";
	name="libnetfilter_conntrack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libnetfilter_conntrack.patch"

Index: libnetfilter_conntrack/configure.in
===================================================================
--- libnetfilter_conntrack/configure.in	(revision 6554)
+++ libnetfilter_conntrack/configure.in	(working copy)
@@ -18,9 +18,12 @@
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
-AC_CHECK_LIB(nfnetlink, nfnl_subsys_open, AC_MSG_RESULT(found), AC_MSG_ERROR([libnfnetlink 0.0.16 or later needed]))
-AC_CHECK_HEADER([libnfnetlink/linux_nfnetlink.h], [AC_MSG_RESULT([found])], [AC_MSG_ERROR([libnfnetlink 0.0.16 or later needed])])
+dnl Dependencies
+LIBNFNETLINK_REQUIRED=0.0.16
 
+PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
+
 AC_CHECK_HEADERS(arpa/inet.h)
 dnl Check for inet_ntop
 AC_CHECK_FUNCS(inet_ntop)
@@ -61,7 +64,11 @@
 	CFLAGS="$CFLAGS -DLIBNETFILTER_CONNTRACK_DIR=$MODULE_DIR"
 fi
 
+CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
+LIBNFCONNTRACK_LIBS="$LIBNFNETLINK_LIBS"
 
+AC_SUBST(LIBNFCONNTRACK_LIBS)
+
 dnl Output the makefile
 AC_OUTPUT(Makefile src/Makefile include/Makefile utils/Makefile include/libnetfilter_conntrack/Makefile l3extensions/Makefile extensions/Makefile libnetfilter_conntrack.pc)
 
Index: libnetfilter_conntrack/src/Makefile.am
===================================================================
--- libnetfilter_conntrack/src/Makefile.am	(revision 6554)
+++ libnetfilter_conntrack/src/Makefile.am	(working copy)
@@ -4,8 +4,8 @@
 
 #EXTRA_DIST = $(man_MANS) acinclude.m4
 
-AM_CFLAGS=-fPIC -Wall
-LIBS=
+AM_CFLAGS = -fPIC -Wall
+LIBS = @LIBNFCONNTRACK_LIBS@
 
 lib_LTLIBRARIES = libnetfilter_conntrack.la 
 
Index: libnetfilter_conntrack/Makefile.am
===================================================================
--- libnetfilter_conntrack/Makefile.am	(revision 6554)
+++ libnetfilter_conntrack/Makefile.am	(working copy)
@@ -3,7 +3,6 @@
 AUTOMAKE_OPTIONS = foreign dist-bzip2 1.6
 
 SUBDIRS	= include src l3extensions extensions utils
-LINKOPTS = -lnfnetlink
 
 man_MANS = #nfnetlink_conntrack.3 nfnetlink_conntrack.7
 

--Boundary-00=_yodHEKQx+Usd58a
Content-Type: text/x-diff; charset="us-ascii"; name="libnetfilter_queue.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libnetfilter_queue.patch"

Index: libnetfilter_queue/configure.in
===================================================================
--- libnetfilter_queue/configure.in	(revision 6554)
+++ libnetfilter_queue/configure.in	(working copy)
@@ -17,8 +17,16 @@
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
-AC_CHECK_LIB(nfnetlink, nfnl_subsys_open, AC_MSG_RESULT(found), AC_MSG_ERROR([libnfnetlink 0.0.16 or later needed]))
-AC_CHECK_HEADER([libnfnetlink/linux_nfnetlink.h], [AC_MSG_RESULT([found])], [AC_MSG_ERROR([libnfnetlink 0.0.16 or later needed])])
+dnl Dependencies
+LIBNFNETLINK_REQUIRED=0.0.16
+ 
+PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
+ 
+CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
+LIBNFQUEUE_LIBS="$LIBNFNETLINK_LIBS"
+ 
+AC_SUBST(LIBNFQUEUE_LIBS)
 
 dnl Output the makefiles
 AC_OUTPUT(Makefile include/Makefile include/libnetfilter_queue/Makefile src/Makefile utils/Makefile libnetfilter_queue.pc)
Index: libnetfilter_queue/src/Makefile.am
===================================================================
--- libnetfilter_queue/src/Makefile.am	(revision 6554)
+++ libnetfilter_queue/src/Makefile.am	(working copy)
@@ -3,8 +3,8 @@
 LIBVERSION=2:0:1
 
 INCLUDES = $(all_includes) -I$(top_srcdir)/include -I${KERNELDIR}
-AM_CFLAGS=-fPIC -Wall
-LIBS=
+AM_CFLAGS = -fPIC -Wall
+LIBS = @LIBNFQUEUE_LIBS@
 
 lib_LTLIBRARIES = libnetfilter_queue.la libnetfilter_queue_libipq.la
 

--Boundary-00=_yodHEKQx+Usd58a
Content-Type: text/x-diff;
  charset="us-ascii";
  name="conntrack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="conntrack.patch"

Index: conntrack/configure.in
===================================================================
--- conntrack/configure.in	(revision 6554)
+++ conntrack/configure.in	(working copy)
@@ -3,7 +3,6 @@
 AC_CANONICAL_SYSTEM
 
 AM_INIT_AUTOMAKE(conntrack, 1.00beta2)
-#AM_CONFIG_HEADER(config.h)
 
 AC_PROG_CC
 AM_PROG_LIBTOOL
@@ -15,14 +14,14 @@
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
-# Checks for libraries.
-# FIXME: Replace `main' with a function in `-lc':
-dnl AC_CHECK_LIB([c], [main])
-# FIXME: Replace `main' with a function in `-ldl':
+dnl Dependencies
+LIBNFCONNTRACK_REQUIRED=0.0.31
+ 
+AC_CHECK_LIB(dl, dlopen)
 
-AC_CHECK_LIB([dl], [dlopen])
-AC_CHECK_LIB([netfilter_conntrack], [nfct_dump_conntrack_table] ,,,[-lnetfilter_conntrack])
-
+PKG_CHECK_MODULES(LIBNFCONNTRACK, libnetfilter_conntrack >= $LIBNFCONNTRACK_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNFCONNTRACK_REQUIRED))
+ 
 AC_CHECK_HEADERS(arpa/inet.h)
 dnl check for inet_pton
 AC_CHECK_FUNCS(inet_pton)
@@ -56,19 +55,6 @@
   ], AC_MSG_RESULT(no), AC_MSG_RESULT(no))
 fi
 
-# Checks for header files.
-dnl AC_HEADER_STDC
-dnl AC_CHECK_HEADERS([netinet/in.h stdlib.h])
-
-# Checks for typedefs, structures, and compiler characteristics.
-dnl AC_C_CONST
-dnl AC_C_INLINE
-
-# Checks for library functions.
-dnl AC_FUNC_MALLOC
-dnl AC_FUNC_VPRINTF
-dnl AC_CHECK_FUNCS([memset])
-
 dnl--------------------------------
 
 if test ! -z "$libdir"; then
@@ -78,10 +64,9 @@
 
 dnl--------------------------------
 
-dnl AC_CONFIG_FILES([Makefile
-dnl                  debug/Makefile
-dnl                  debug/src/Makefile
-dnl                  extensions/Makefile
-dnl                  src/Makefile])
+CFLAGS="$CFLAGS $LIBNFCONNTRACK_CFLAGS"
+CONNTRACK_LIBS="$LIBNFCONNTRACK_LIBS"
 
+AC_SUBST(CONNTRACK_LIBS)
+
 AC_OUTPUT(Makefile src/Makefile extensions/Makefile include/Makefile)
Index: conntrack/src/Makefile.am
===================================================================
--- conntrack/src/Makefile.am	(revision 6554)
+++ conntrack/src/Makefile.am	(working copy)
@@ -1,7 +1,7 @@
 include $(top_srcdir)/Make_global.am
+LIBS = @CONNTRACK_LIBS@
 
 sbin_PROGRAMS = conntrack
 conntrack_SOURCES = conntrack.c
-
-conntrack_LDFLAGS = $(all_libraries) -rdynamic -lnetfilter_conntrack
+#conntrack_LDFLAGS = $(all_libraries) -rdynamic
  
Index: conntrack/autogen.sh
===================================================================
--- conntrack/autogen.sh	(revision 6554)
+++ conntrack/autogen.sh	(working copy)
@@ -13,6 +13,6 @@
 
 run aclocal
 run libtoolize -f
-run autoheader
+#run autoheader
 run automake -a
 run autoconf

--Boundary-00=_yodHEKQx+Usd58a
Content-Type: text/x-diff;
  charset="us-ascii";
  name="ulogd2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ulogd2.patch"

Index: ulogd2/configure.in
===================================================================
--- ulogd2/configure.in	(revision 6554)
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
--- ulogd2/input/flow/Makefile.am	(revision 6554)
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
--- ulogd2/input/packet/Makefile.am	(revision 6554)
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

--Boundary-00=_yodHEKQx+Usd58a
Content-Type: text/x-diff; charset="us-ascii";
	name="libnetfilter_cthelper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libnetfilter_cthelper.patch"

Index: libnetfilter_cthelper/include/Makefile.am
===================================================================
--- libnetfilter_cthelper/include/Makefile.am	(revision 6554)
+++ libnetfilter_cthelper/include/Makefile.am	(working copy)
@@ -1,4 +1,4 @@
 
 SUBDIRS = libnetfilter_cthelper
 
-nodist_HEADERS = linux_list.h
+# nodist_HEADERS = linux_list.h
Index: libnetfilter_cthelper/configure.in
===================================================================
--- libnetfilter_cthelper/configure.in	(revision 6554)
+++ libnetfilter_cthelper/configure.in	(working copy)
@@ -18,15 +18,23 @@
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
-AC_CHECK_LIB(nfnetlink, nfnl_subsys_open, AC_MSG_RESULT(found), AC_MSG_ERROR([libnfnetlink 0.0.16 or later needed]))
-AC_CHECK_HEADER([libnfnetlink/linux_nfnetlink.h], [AC_MSG_RESULT([found])], [AC_MSG_ERROR([libnfnetlink 0.0.16 or later needed])])
+dnl Dependencies
+LIBNFNETLINK_REQUIRED=0.0.16
+LIBNFCONNTRACK_REQUIRED=0.0.31
+LIBNFQUEUE_REQUIRED=0.0.12
+ 
+PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
+PKG_CHECK_MODULES(LIBNFCONNTRACK, libnetfilter_conntrack >= $LIBNFCONNTRACK_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNFCONNTRACK_REQUIRED))
+PKG_CHECK_MODULES(LIBNFQUEUE, libnetfilter_queue >= $LIBNFQUEUE_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnetfilter_queue >= $LIBNFQUEUE_REQUIRED))
 
-AC_CHECK_LIB(netfilter_conntrack, nfct_open_nfnl, AC_MSG_RESULT(found), AC_MSG_ERROR([libnetfilter_conntrack 0.0.31 or later needed]))
-AC_CHECK_HEADER([libnetfilter_conntrack/libnetfilter_conntrack.h], [AC_MSG_RESULT([found])], [AC_MSG_ERROR([libnetfilter_conntrack 0.0.31 or later needed])])
+CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS $LIBNFCONNTRACK_CFLAGS $LIBNFQUEUE_CFLAGS"
+LIBNFCTHELPER_LIBS="$LIBNFNETLINK_LIBS $LIBNFCONNTRACK_LIBS $LIBNFQUEUE_LIBS"
 
-AC_CHECK_LIB(netfilter_queue, nfq_open_nfnl, AC_MSG_RESULT(found), AC_MSG_ERROR([libnetfilter_queue 0.0.12 or later needed]))
-AC_CHECK_HEADER([libnetfilter_queue/libnetfilter_queue.h], [AC_MSG_RESULT([found])], [AC_MSG_ERROR([libnetfilter_queue 0.0.12 or later needed])])
+dnl Output the makefile
+AC_SUBST(LIBNFCTHELPER_LIBS)
 
-dnl Output the makefile
 AC_OUTPUT(Makefile src/Makefile include/Makefile utils/Makefile include/libnetfilter_cthelper/Makefile libnetfilter_cthelper.pc)
 
Index: libnetfilter_cthelper/src/Makefile.am
===================================================================
--- libnetfilter_cthelper/src/Makefile.am	(revision 6554)
+++ libnetfilter_cthelper/src/Makefile.am	(working copy)
@@ -3,8 +3,8 @@
 LIBVERSION=0:0:0
 
 INCLUDES = $(all_includes) -I$(top_srcdir)/include -I${KERNELDIR}
-AM_CFLAGS=-fPIC -Wall
-LIBS=
+AM_CFLAGS = -fPIC -Wall
+LIBS = @LIBNFCTHELPER_LIBS@
 
 lib_LTLIBRARIES = libnetfilter_cthelper.la
 

--Boundary-00=_yodHEKQx+Usd58a
Content-Type: text/x-diff; charset="us-ascii"; name="libnetfilter_log.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libnetfilter_log.patch"

Index: libnetfilter_log/configure.in
===================================================================
--- libnetfilter_log/configure.in	(revision 6554)
+++ libnetfilter_log/configure.in	(working copy)
@@ -18,9 +18,17 @@
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
-AC_CHECK_LIB(nfnetlink, nfnl_subsys_open, AC_MSG_RESULT(found), AC_MSG_ERROR([libnfnetlink 0.0.16 or later needed]))
-AC_CHECK_HEADER([libnfnetlink/linux_nfnetlink.h], [AC_MSG_RESULT([found])], [AC_MSG_ERROR([libnfnetlink 0.0.16 or later needed])])
+dnl Dependencies
+LIBNFNETLINK_REQUIRED=0.0.16
+ 
+PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
 
+CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
+LIBNFLOG_LIBS="$LIBNFNETLINK_LIBS"
+ 
+AC_SUBST(LIBNFLOG_LIBS)
+
 dnl Output the makefile
 AC_OUTPUT(Makefile src/Makefile include/Makefile include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc)
 
Index: libnetfilter_log/src/Makefile.am
===================================================================
--- libnetfilter_log/src/Makefile.am	(revision 6554)
+++ libnetfilter_log/src/Makefile.am	(working copy)
@@ -3,8 +3,8 @@
 LIBVERSION=2:0:1
 
 INCLUDES = $(all_includes) -I$(top_srcdir)/include
-AM_CFLAGS=-fPIC -Wall
-LIBS=
+AM_CFLAGS = -fPIC -Wall
+LIBS = @LIBNFLOG_LIBS@
 
 lib_LTLIBRARIES = libnetfilter_log.la libnetfilter_log_libipulog.la
 

--Boundary-00=_yodHEKQx+Usd58a--
