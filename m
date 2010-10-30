From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/7] build: remove unused $(all_libraries)
Date: Sun, 31 Oct 2010 00:49:39 +0200
Message-ID: <1288478982-6758-6-git-send-email-jengelh@medozas.de>
References: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44518 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab0J3Wtu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:49:50 -0400
In-Reply-To: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/Makefile.am |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 76f0e73..0e9af2e 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -8,7 +8,7 @@ sbin_PROGRAMS = conntrack conntrackd
 
 conntrack_SOURCES = conntrack.c
 conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_udplite.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la ../extensions/libct_proto_sctp.la ../extensions/libct_proto_dccp.la ../extensions/libct_proto_gre.la ../extensions/libct_proto_unknown.la
-conntrack_LDFLAGS = $(all_libraries) @LIBNETFILTER_CONNTRACK_LIBS@
+conntrack_LDFLAGS = @LIBNETFILTER_CONNTRACK_LIBS@
 
 conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c rbtree.c \
 		    local.c log.c mcast.c udp.c netlink.c vector.c \
@@ -28,6 +28,6 @@ conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c rbtree.c \
 # yacc and lex generate dirty code
 read_config_yy.o read_config_lex.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
 
-conntrackd_LDFLAGS = $(all_libraries) @LIBNETFILTER_CONNTRACK_LIBS@
+conntrackd_LDFLAGS = @LIBNETFILTER_CONNTRACK_LIBS@
 
 EXTRA_DIST = read_config_yy.h
-- 
1.7.1

