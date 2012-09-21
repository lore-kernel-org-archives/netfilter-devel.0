From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH] mk: fix librairies dependencies
Date: Fri, 21 Sep 2012 15:55:39 +0200
Message-ID: <1348235739-29392-1-git-send-email-nicolas.dichtel@6wind.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:54651 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2IUOCm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:02:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Several includes are missing when netfilter libs are not in the
standard path.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
Patch is against conntrack-tools.git

 Make_global.am  | 4 +++-
 src/Makefile.am | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 7b5342d..23c7dd0 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -4,4 +4,6 @@ AM_CFLAGS = -std=gnu99 -W -Wall \
 	-Wmissing-prototypes -Wwrite-strings -Wcast-qual -Wfloat-equal -Wshadow -Wpointer-arith -Wbad-function-cast -Wsign-compare -Waggregate-return -Wmissing-declarations -Wredundant-decls -Wnested-externs -Winline -Wstrict-prototypes -Wundef \
 	-Wno-unused-parameter ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS} \
 	${LIBNETFILTER_CONNTRACK_CFLAGS} \
-	${LIBNETFILTER_CTTIMEOUT_CFLAGS}
+	${LIBNETFILTER_CTTIMEOUT_CFLAGS} \
+	${LIBNETFILTER_QUEUE_CFLAGS} \
+	${LIBNETFILTER_CTHELPER_CFLAGS}
diff --git a/src/Makefile.am b/src/Makefile.am
index d8074d2..ec03e46 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -9,7 +9,7 @@ CLEANFILES = read_config_yy.c read_config_lex.c
 sbin_PROGRAMS = conntrack conntrackd nfct
 
 conntrack_SOURCES = conntrack.c
-conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_udplite.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la ../extensions/libct_proto_sctp.la ../extensions/libct_proto_dccp.la ../extensions/libct_proto_gre.la ../extensions/libct_proto_unknown.la ${LIBNETFILTER_CONNTRACK_LIBS} ${LIBMNL_LIBS}
+conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_udplite.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la ../extensions/libct_proto_sctp.la ../extensions/libct_proto_dccp.la ../extensions/libct_proto_gre.la ../extensions/libct_proto_unknown.la ${LIBNETFILTER_CONNTRACK_LIBS} ${LIBMNL_LIBS} ${LIBNFNETLINK_LIBS}
 
 nfct_SOURCES = nfct.c			\
 	       helpers.c			\
@@ -46,7 +46,7 @@ read_config_yy.o read_config_lex.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-mi
 
 conntrackd_LDADD = ${LIBMNL_LIBS} ${LIBNETFILTER_CONNTRACK_LIBS} \
 		   ${LIBNETFILTER_QUEUE_LIBS} ${LIBNETFILTER_CTHELPER_LIBS} \
-		   ${libdl_LIBS}
+		   ${libdl_LIBS} ${LIBNFNETLINK_LIBS}
 
 conntrackd_LDFLAGS = -export-dynamic
 
-- 
1.7.12

