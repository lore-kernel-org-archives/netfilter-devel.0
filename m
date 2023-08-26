Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B18DC83F1A
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Aug 2023 16:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjHZQcx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Aug 2023 12:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjHZQcs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Aug 2023 12:32:48 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58C310FF
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Aug 2023 09:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sjZJ8aO/tpxB+Hs+fQMulyJy68WuXmfNT4KMYAxtRUw=; b=fzRQx924KgK54cR4uGM/nEj+zf
        nwSM7B/2xBpBlgj8If4oqf0c15fL07ZzPDL/gQsxlzug5SqtVCkGqneFAPUhx1ilRzjZvNuooYVZ7
        lYBbnh+lmSOAFmf9oEIX0UwvfA70fN/fiR6tcEhuZEFb76Y4n8YrhuQLszqevVqTCXItRdr+oSBmc
        mFV8zBbCo32nZpGAOhAVncTtmKK+GoZfAyQVXMvTJm5b+hCOV4EnrCqP/QGGsTGtNVnRiKMxSKOVx
        wtRM/V8KEyZ5FREnxmhGEkDZZY3ckO5l+fWMtzW358JNu1OCl36nYe5NxLTjGnzO9PNmlB+Wa+IcX
        emJLaB8g==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qZwDJ-00DpTC-0g
        for netfilter-devel@vger.kernel.org;
        Sat, 26 Aug 2023 17:32:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH conntrack-tools 1/4] build: reformat and sort `conntrack_LDADD` and `conntrackd_SOURCES`
Date:   Sat, 26 Aug 2023 17:32:23 +0100
Message-Id: <20230826163226.1104220-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230826163226.1104220-1-jeremy@azazel.net>
References: <20230826163226.1104220-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/Makefile.am | 77 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 17 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 2986ab3b4d4f..4ea573abc12d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -11,7 +11,18 @@ BUILT_SOURCES = read_config_yy.h
 sbin_PROGRAMS = conntrack conntrackd nfct
 
 conntrack_SOURCES = conntrack.c
-conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_udplite.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la ../extensions/libct_proto_sctp.la ../extensions/libct_proto_dccp.la ../extensions/libct_proto_gre.la ../extensions/libct_proto_unknown.la ${LIBNETFILTER_CONNTRACK_LIBS} ${LIBMNL_LIBS} ${LIBNFNETLINK_LIBS}
+conntrack_LDADD   = ../extensions/libct_proto_dccp.la    \
+                    ../extensions/libct_proto_gre.la     \
+                    ../extensions/libct_proto_icmp.la    \
+                    ../extensions/libct_proto_icmpv6.la  \
+                    ../extensions/libct_proto_sctp.la    \
+                    ../extensions/libct_proto_tcp.la     \
+                    ../extensions/libct_proto_udp.la     \
+                    ../extensions/libct_proto_udplite.la \
+                    ../extensions/libct_proto_unknown.la \
+                    ${LIBMNL_LIBS}                       \
+                    ${LIBNETFILTER_CONNTRACK_LIBS}       \
+                    ${LIBNFNETLINK_LIBS}
 
 nfct_SOURCES = nfct.c
 
@@ -35,22 +46,54 @@ if HAVE_CTHELPER
 nfct_LDADD += ${LIBNETFILTER_CTHELPER_LIBS}
 endif
 
-conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c queue_tx.c rbtree.c \
-		    local.c log.c mcast.c udp.c netlink.c vector.c \
-		    filter.c fds.c event.c process.c origin.c date.c \
-		    cache.c cache-ct.c cache-exp.c \
-		    cache_timer.c \
-		    ctnl.c \
-		    sync-mode.c sync-alarm.c sync-ftfw.c sync-notrack.c \
-		    traffic_stats.c stats-mode.c \
-		    network.c cidr.c \
-		    build.c parse.c \
-		    channel.c multichannel.c channel_mcast.c channel_udp.c \
-		    tcp.c channel_tcp.c \
-		    external_cache.c external_inject.c \
-		    internal_cache.c internal_bypass.c \
-		    read_config_yy.y read_config_lex.l \
-		    stack.c resync.c
+conntrackd_SOURCES = alarm.c            \
+                     build.c            \
+                     cache.c            \
+                     cache-ct.c         \
+                     cache-exp.c        \
+                     cache_timer.c      \
+                     channel.c          \
+                     channel_mcast.c    \
+                     channel_tcp.c      \
+                     channel_udp.c      \
+                     cidr.c             \
+                     ctnl.c             \
+                     date.c             \
+                     event.c            \
+                     external_cache.c   \
+                     external_inject.c  \
+                     fds.c              \
+                     filter.c           \
+                     hash.c             \
+                     internal_bypass.c  \
+                     internal_cache.c   \
+                     local.c            \
+                     log.c              \
+                     main.c             \
+                     mcast.c            \
+                     multichannel.c     \
+                     netlink.c          \
+                     network.c          \
+                     origin.c           \
+                     parse.c            \
+                     process.c          \
+                     queue.c            \
+                     queue_tx.c         \
+                     rbtree.c           \
+                     read_config_lex.l  \
+                     read_config_yy.y   \
+                     resync.c           \
+                     run.c              \
+                     stack.c            \
+                     stats-mode.c       \
+                     sync-alarm.c       \
+                     sync-ftfw.c        \
+                     sync-mode.c        \
+                     sync-notrack.c     \
+                     tcp.c              \
+                     traffic_stats.c    \
+                     udp.c              \
+                     vector.c
 
 if HAVE_CTHELPER
 conntrackd_SOURCES += cthelper.c helpers.c utils.c expect.c
-- 
2.40.1

