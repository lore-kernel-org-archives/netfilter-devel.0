From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 5/6] conntrack changes
Date: Mon, 31 Jul 2006 10:23:08 +0200
Message-ID: <200607311023.08126@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_s3bzEvxKLdLxS5C"
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

--Boundary-00=_s3bzEvxKLdLxS5C
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  Attached are the changes to the conntrack tool.

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_s3bzEvxKLdLxS5C
Content-Type: text/x-diff;
  charset="us-ascii";
  name="05-conntrack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="05-conntrack.patch"

Index: conntrack/configure.in
===================================================================
--- conntrack/configure.in	(revision 6652)
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
--- conntrack/src/Makefile.am	(revision 6652)
+++ conntrack/src/Makefile.am	(working copy)
@@ -1,7 +1,7 @@
 include $(top_srcdir)/Make_global.am
+LIBS = @CONNTRACK_LIBS@
 
 sbin_PROGRAMS = conntrack
 conntrack_SOURCES = conntrack.c
-
-conntrack_LDFLAGS = $(all_libraries) -rdynamic -lnetfilter_conntrack
+#conntrack_LDFLAGS = $(all_libraries) -rdynamic
  

--Boundary-00=_s3bzEvxKLdLxS5C--
