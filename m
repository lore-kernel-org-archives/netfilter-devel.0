From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 3/6] libnetfilter_queue changes
Date: Mon, 31 Jul 2006 10:23:01 +0200
Message-ID: <200607311023.01882@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_l3bzEy7KDq0KNmK"
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

--Boundary-00=_l3bzEy7KDq0KNmK
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  Attached are the changes to libnetfilter_queue.

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_l3bzEy7KDq0KNmK
Content-Type: text/x-diff; charset="us-ascii";
	name="03-libnetfilter_queue.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="03-libnetfilter_queue.patch"

Index: libnetfilter_queue/configure.in
===================================================================
--- libnetfilter_queue/configure.in	(revision 6652)
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
--- libnetfilter_queue/src/Makefile.am	(revision 6652)
+++ libnetfilter_queue/src/Makefile.am	(working copy)
@@ -3,8 +3,8 @@
 LIBVERSION=2:0:1
 
 INCLUDES = $(all_includes) -I$(top_srcdir)/include -I${KERNELDIR}
-AM_CFLAGS=-fPIC -Wall
-LIBS=
+AM_CFLAGS = -fPIC -Wall
+LIBS = @LIBNFQUEUE_LIBS@
 
 lib_LTLIBRARIES = libnetfilter_queue.la libnetfilter_queue_libipq.la
 

--Boundary-00=_l3bzEy7KDq0KNmK--
