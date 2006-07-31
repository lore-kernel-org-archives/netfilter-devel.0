From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 2/6] libnetfilter_log changes
Date: Mon, 31 Jul 2006 10:22:57 +0200
Message-ID: <200607311022.57641@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_h3bzE/h1azaQfOi"
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

--Boundary-00=_h3bzE/h1azaQfOi
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  Attached are the changes to libnetfilter_log.

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_h3bzE/h1azaQfOi
Content-Type: text/x-diff; charset="us-ascii"; name="02-libnetfilter_log.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="02-libnetfilter_log.patch"

Index: libnetfilter_log/configure.in
===================================================================
--- libnetfilter_log/configure.in	(revision 6652)
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
--- libnetfilter_log/src/Makefile.am	(revision 6652)
+++ libnetfilter_log/src/Makefile.am	(working copy)
@@ -3,8 +3,8 @@
 LIBVERSION=2:0:1
 
 INCLUDES = $(all_includes) -I$(top_srcdir)/include
-AM_CFLAGS=-fPIC -Wall
-LIBS=
+AM_CFLAGS = -fPIC -Wall
+LIBS = @LIBNFLOG_LIBS@
 
 lib_LTLIBRARIES = libnetfilter_log.la libnetfilter_log_libipulog.la
 

--Boundary-00=_h3bzE/h1azaQfOi--
