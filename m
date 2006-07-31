From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 4/6] libnetfilter_cthelper changes
Date: Mon, 31 Jul 2006 10:23:04 +0200
Message-ID: <200607311023.04977@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_o3bzEGkP3jU165k"
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

--Boundary-00=_o3bzEGkP3jU165k
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  Attached are the changes to libnetfilter_cthelper.

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_o3bzEGkP3jU165k
Content-Type: text/x-diff; charset="us-ascii";
	name="04-libnetfilter_cthelper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="04-libnetfilter_cthelper.patch"

Index: libnetfilter_cthelper/include/Makefile.am
===================================================================
--- libnetfilter_cthelper/include/Makefile.am	(revision 6652)
+++ libnetfilter_cthelper/include/Makefile.am	(working copy)
@@ -1,4 +1,4 @@
 
 SUBDIRS = libnetfilter_cthelper
 
-nodist_HEADERS = linux_list.h
+# nodist_HEADERS = linux_list.h
Index: libnetfilter_cthelper/configure.in
===================================================================
--- libnetfilter_cthelper/configure.in	(revision 6652)
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
--- libnetfilter_cthelper/src/Makefile.am	(revision 6652)
+++ libnetfilter_cthelper/src/Makefile.am	(working copy)
@@ -3,8 +3,8 @@
 LIBVERSION=0:0:0
 
 INCLUDES = $(all_includes) -I$(top_srcdir)/include -I${KERNELDIR}
-AM_CFLAGS=-fPIC -Wall
-LIBS=
+AM_CFLAGS = -fPIC -Wall
+LIBS = @LIBNFCTHELPER_LIBS@
 
 lib_LTLIBRARIES = libnetfilter_cthelper.la
 

--Boundary-00=_o3bzEGkP3jU165k--
