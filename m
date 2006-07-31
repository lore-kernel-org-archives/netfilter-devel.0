From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 1/6] libnetfilter_conntrack modifications
Date: Mon, 31 Jul 2006 10:22:52 +0200
Message-ID: <200607311022.52312@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_c3bzEXg14hYFs/O"
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

--Boundary-00=_c3bzEXg14hYFs/O
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  Attached are the changes to libnetfilter_conntrack.

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_c3bzEXg14hYFs/O
Content-Type: text/x-diff; charset="us-ascii";
	name="01-libnetfilter_conntrack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="01-libnetfilter_conntrack.patch"

Index: libnetfilter_conntrack/configure.in
===================================================================
--- libnetfilter_conntrack/configure.in	(revision 6652)
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
--- libnetfilter_conntrack/src/Makefile.am	(revision 6652)
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
--- libnetfilter_conntrack/Makefile.am	(revision 6652)
+++ libnetfilter_conntrack/Makefile.am	(working copy)
@@ -3,7 +3,6 @@
 AUTOMAKE_OPTIONS = foreign dist-bzip2 1.6
 
 SUBDIRS	= include src l3extensions extensions utils
-LINKOPTS = -lnfnetlink
 
 man_MANS = #nfnetlink_conntrack.3 nfnetlink_conntrack.7
 

--Boundary-00=_c3bzEXg14hYFs/O--
