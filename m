From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] libnetfilter_conntrack: link extensions against libnfnetlink
Date: Wed, 17 May 2006 17:24:08 +1000
Message-ID: <446ACF98.1090509@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

The ulogd NFCT plugin fails to load libnetfilter_conntrack extensions
unless they are linked against libnfnetlink.  This problem may be
specific to uClibc.

Also, a couple of questions about these makefiles:

Is there any reason to have a separate LIBADD for each extension?

Why is LIBS set in these files?  This is normally a user defined variable,
with the default value being determined by configure.  And since we do
a AC_CHECK_LIB for nfnetlink, the default LIBS already contains -lnfnetlink.

Index: libnetfilter_conntrack/extensions/Makefile.am
===================================================================
--- libnetfilter_conntrack/extensions/Makefile.am	(revision 6601)
+++ libnetfilter_conntrack/extensions/Makefile.am	(working copy)
@@ -10,16 +10,16 @@

 nfct_proto_tcp_la_SOURCES = libnetfilter_conntrack_tcp.c
 nfct_proto_tcp_la_LDFLAGS = -module -avoid-version -release $(VERSION)
-nfct_proto_tcp_la_LIBADD = ../src/libnetfilter_conntrack.la
+nfct_proto_tcp_la_LIBADD = ../src/libnetfilter_conntrack.la -lnfnetlink

 nfct_proto_udp_la_SOURCES = libnetfilter_conntrack_udp.c
 nfct_proto_udp_la_LDFLAGS = -module -avoid-version -release $(VERSION)
-nfct_proto_udp_la_LIBADD = ../src/libnetfilter_conntrack.la
+nfct_proto_udp_la_LIBADD = ../src/libnetfilter_conntrack.la -lnfnetlink

 nfct_proto_icmp_la_SOURCES = libnetfilter_conntrack_icmp.c
 nfct_proto_icmp_la_LDFLAGS = -module -avoid-version -release $(VERSION)
-nfct_proto_icmp_la_LIBADD = ../src/libnetfilter_conntrack.la
+nfct_proto_icmp_la_LIBADD = ../src/libnetfilter_conntrack.la -lnfnetlink

 nfct_proto_sctp_la_SOURCES = libnetfilter_conntrack_sctp.c
 nfct_proto_sctp_la_LDFLAGS = -module -avoid-version -release $(VERSION)
-nfct_proto_sctp_la_LIBADD = ../src/libnetfilter_conntrack.la
+nfct_proto_sctp_la_LIBADD = ../src/libnetfilter_conntrack.la -lnfnetlink
Index: libnetfilter_conntrack/l3extensions/Makefile.am
===================================================================
--- libnetfilter_conntrack/l3extensions/Makefile.am	(revision 6601)
+++ libnetfilter_conntrack/l3extensions/Makefile.am	(working copy)
@@ -9,8 +9,8 @@

 nfct_l3proto_ipv4_la_SOURCES = libnetfilter_conntrack_ipv4.c
 nfct_l3proto_ipv4_la_LDFLAGS = -module -avoid-version -release $(VERSION)
-nfct_l3proto_ipv4_la_LIBADD = ../src/libnetfilter_conntrack.la
+nfct_l3proto_ipv4_la_LIBADD = ../src/libnetfilter_conntrack.la -lnfnetlink

 nfct_l3proto_ipv6_la_SOURCES = libnetfilter_conntrack_ipv6.c
 nfct_l3proto_ipv6_la_LDFLAGS = -module -avoid-version -release $(VERSION)
-nfct_l3proto_ipv6_la_LIBADD = ../src/libnetfilter_conntrack.la
+nfct_l3proto_ipv6_la_LIBADD = ../src/libnetfilter_conntrack.la -lnfnetlink
