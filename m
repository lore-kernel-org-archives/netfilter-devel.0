From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/7] build: no need for error message in PKG_CHECK_MODULES
Date: Sun, 31 Oct 2010 00:49:40 +0200
Message-ID: <1288478982-6758-7-git-send-email-jengelh@medozas.de>
References: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44519 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab0J3Wtv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:49:51 -0400
In-Reply-To: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

PKG_CHECK_MODULES already produces its own (and more verbose)
messsage when a module cannot be found.

Mucking around with CFLAGS and LIBS is also not needed since
pkgconfig takes care of providing variables, so let's use them in
Makefile.am.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am  |    3 ++-
 configure.ac    |   25 ++-----------------------
 src/Makefile.am |    5 ++---
 3 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 4e9794e..e8f603a 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -2,4 +2,5 @@ AM_CPPFLAGS = -I$(top_srcdir)/include
 
 AM_CFLAGS = -std=gnu99 -W -Wall \
 	-Wmissing-prototypes -Wwrite-strings -Wcast-qual -Wfloat-equal -Wshadow -Wpointer-arith -Wbad-function-cast -Wsign-compare -Waggregate-return -Wmissing-declarations -Wredundant-decls -Wnested-externs -Winline -Wstrict-prototypes -Wundef \
-	-Wno-unused-parameter
+	-Wno-unused-parameter ${LIBNFNETLINK_CFLAGS} \
+	${LIBNETFILTER_CONNTRACK_CFLAGS}
diff --git a/configure.ac b/configure.ac
index e068798..37fbeee 100644
--- a/configure.ac
+++ b/configure.ac
@@ -18,22 +18,8 @@ case "$host" in
 esac
 
 dnl Dependencies
-LIBNFNETLINK_REQUIRED=1.0.0
-LIBNETFILTER_CONNTRACK_REQUIRED=0.0.102
-
-AC_CHECK_PROG(HAVE_PKG_CONFIG, pkg-config, yes)
-if test "x$HAVE_PKG_CONFIG" = "x"
-then
-	echo "*** Error: No suitable pkg-config found. ***"
-	echo "    Please install the 'pkg-config' package."
-	exit 1
-fi
-
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
-        AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
-
-PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED,,
-        AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED))
+PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.0])
+PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 0.0.102])
 
 AC_CHECK_PROGS(XYACC,$YACC bison yacc,none)
 if test "$XYACC" = "none"
@@ -72,9 +58,6 @@ AC_CHECK_HEADERS([linux/capability.h],, [AC_MSG_ERROR([Cannot find linux/capabib
 dnl AC_CHECK_LIB([c], [main])
 # FIXME: Replace `main' with a function in `-ldl':
 
-AC_CHECK_LIB([nfnetlink], [nfnl_query] ,,,[-lnfnetlink])
-AC_CHECK_LIB([netfilter_conntrack], [nfct_query] ,,,[-lnetfilter_conntrack])
-
 AC_CHECK_HEADERS(arpa/inet.h)
 dnl check for inet_pton
 AC_CHECK_FUNCS(inet_pton)
@@ -127,9 +110,5 @@ dnl                  debug/src/Makefile
 dnl                  extensions/Makefile
 dnl                  src/Makefile])
 
-CFLAGS="$CFLAGS $LIBNETFILTER_CONNTRACK_CFLAGS"
-
-AC_SUBST(LIBNETFILTER_CONNTRACK_LIBS)
-
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile extensions/Makefile])
 AC_OUTPUT
diff --git a/src/Makefile.am b/src/Makefile.am
index 0e9af2e..a85a56f 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -7,8 +7,7 @@ CLEANFILES = read_config_yy.c read_config_lex.c
 sbin_PROGRAMS = conntrack conntrackd
 
 conntrack_SOURCES = conntrack.c
-conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_udplite.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la ../extensions/libct_proto_sctp.la ../extensions/libct_proto_dccp.la ../extensions/libct_proto_gre.la ../extensions/libct_proto_unknown.la
-conntrack_LDFLAGS = @LIBNETFILTER_CONNTRACK_LIBS@
+conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_udplite.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la ../extensions/libct_proto_sctp.la ../extensions/libct_proto_dccp.la ../extensions/libct_proto_gre.la ../extensions/libct_proto_unknown.la ${LIBNETFILTER_CONNTRACK_LIBS}
 
 conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c rbtree.c \
 		    local.c log.c mcast.c udp.c netlink.c vector.c \
@@ -28,6 +27,6 @@ conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c rbtree.c \
 # yacc and lex generate dirty code
 read_config_yy.o read_config_lex.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
 
-conntrackd_LDFLAGS = @LIBNETFILTER_CONNTRACK_LIBS@
+conntrackd_LDADD = ${LIBNETFILTER_CONNTRACK_LIBS}
 
 EXTRA_DIST = read_config_yy.h
-- 
1.7.1

