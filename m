From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH] conntrack-tools compilation problem
Date: Sun, 5 Aug 2007 17:30:15 +0200
Message-ID: <20070805153015.GA27598@sch.bme.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Cc: Netfilter Development Mailing List <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

I've just tried to build conntrack-tools and all the required netfilter
libraries from scratch. The libs were built and installed without
problems, but then conntrack-tools failed to compile with a missing
include problem.

Looks like conntrack-tools' autoconf/automake templates do not properly
use pkg-config information. configure.in detects the presence of
libnfnetlink and libnetfilter_conntrack using pkg-config, but then fails
to add the necessary flags to the compile and linker flags. For me, this
is a problem because all those libraries live under /opt/netfilter, and
thus compilation fails because of missing headers.

The attached patch fixes this problem for me, although I'm quite sure that
it does not break compilation for someone else. (Should not, but I'm not
much of an autoconf expert...)

--
KOVACS Krisztian

--2fHTh5uZTiUOsy+g
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="conntrack-tools-autoconf-dependencies.patch"

Index: conntrack-tools/configure.in
===================================================================
--- conntrack-tools/configure.in	(revision 6998)
+++ conntrack-tools/configure.in	(working copy)
@@ -104,4 +104,8 @@
 dnl                  extensions/Makefile
 dnl                  src/Makefile])
 
+CFLAGS="$CFLAGS $LIBNETFILTER_CONNTRACK_CFLAGS"
+
+AC_SUBST(LIBNETFILTER_CONNTRACK_LIBS)
+
 AC_OUTPUT(Makefile src/Makefile include/Makefile extensions/Makefile)
Index: conntrack-tools/src/Makefile.am
===================================================================
--- conntrack-tools/src/Makefile.am	(revision 6998)
+++ conntrack-tools/src/Makefile.am	(working copy)
@@ -8,6 +8,7 @@
 
 conntrack_SOURCES = conntrack.c
 conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_icmp.la
+conntrack_LDFLAGS = $(all_libraries) @LIBNETFILTER_CONNTRACK_LIBS@
 
 conntrackd_SOURCES = alarm.c main.c run.c hash.c buffer.c \
 		    local.c log.c mcast.c netlink.c \
@@ -22,6 +23,6 @@
 		    build.c parse.c \
 		    read_config_yy.y read_config_lex.l
 
-conntrackd_LDFLAGS = $(all_libraries) -lnfnetlink -lnetfilter_conntrack
+conntrackd_LDFLAGS = $(all_libraries) @LIBNETFILTER_CONNTRACK_LIBS@
 
 EXTRA_DIST = read_config_yy.h
Index: conntrack-tools/Makefile.am
===================================================================
--- conntrack-tools/Makefile.am	(revision 6998)
+++ conntrack-tools/Makefile.am	(working copy)
@@ -9,7 +9,7 @@
 
 SUBDIRS   = extensions src
 DIST_SUBDIRS = include src extensions
-LINKOPTS  = -lnfnetlink -lnetfilter_conntrack -lpthread
+LIBS = @LIBNETFILTER_CONNTRACK_LIBS@
 AM_CFLAGS = -g
 
 $(OBJECTS): libtool

--2fHTh5uZTiUOsy+g--
