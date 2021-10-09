Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B86DC43219
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4151560F38
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbhJILo1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 07:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbhJILoZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 07:44:25 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BA6C061765
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 04:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GlWRpbY8uCjww+xjhOfk4/86XBfrkRvqD0DZ2q/yf5M=; b=sKG71GWAg9oTMyqptlBNKox1Ub
        Ift8mBs1F+9HrjWRUE5PQQZRI9QJev2d/l61pRNUNxVdOuHsSG5C0S4xP2elI/q0ob7fBoxmHI+Od
        qC/bdqfjdj+weJuHjBfqhKjKJU+IAtRnVP4sLASqwTnZ3KWYGL2F3WD0mk3MShH64YGvtY54ChMWp
        DYjOQyiY2CpYY72mUOCbaOgYIlYjcg7lxX5NpkR5X0RKS2IfuUEtawQZ8G13wuw24zygLtLfzc1Fd
        el2AH4AzxE1kyvZkRZp3yQCeE27WIukU7jz3ToieE6YrAqYuZDzoUzZIjvOSCuy7iUAor2E/ShY8i
        QpxQm38Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mZAkF-00BfRm-Hc
        for netfilter-devel@vger.kernel.org; Sat, 09 Oct 2021 12:42:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH 4/9] build: move dependency CFLAGS variables out of `AM_CPPFLAGS`
Date:   Sat,  9 Oct 2021 12:38:34 +0100
Message-Id: <20211009113839.2765382-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211009113839.2765382-1-jeremy@azazel.net>
References: <20211009113839.2765382-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`${LIBNFNETLINK_CFLAGS}` and `${LIBMNL_CFLAGS}` are not required for all
libraries and executables: include them only where necessary.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Make_global.am    |  2 +-
 src/Makefile.am   | 18 ++++++++++--------
 utils/Makefile.am | 11 ++++++-----
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 9bc8ea1d7f67..4d5bec913af2 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
-AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
+AM_CPPFLAGS = -I${top_srcdir}/include
 AM_CFLAGS = -Wall
diff --git a/src/Makefile.am b/src/Makefile.am
index 815d9d31cfc0..203ca0c3cdc6 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -25,16 +25,18 @@ include ${top_srcdir}/Make_global.am
 
 lib_LTLIBRARIES = libnetfilter_log.la
 
-libnetfilter_log_la_LDFLAGS = -Wc,-nostartfiles \
-			      -version-info $(LIBVERSION)
-libnetfilter_log_la_SOURCES = libnetfilter_log.c nlmsg.c
-libnetfilter_log_la_LIBADD  = ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
+libnetfilter_log_la_CPPFLAGS = ${AM_CPPFLAGS} ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
+libnetfilter_log_la_LDFLAGS  = -Wc,-nostartfiles \
+			       -version-info $(LIBVERSION)
+libnetfilter_log_la_SOURCES  = libnetfilter_log.c nlmsg.c
+libnetfilter_log_la_LIBADD   = ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
 
 if BUILD_IPULOG
 lib_LTLIBRARIES += libnetfilter_log_libipulog.la
 
-libnetfilter_log_libipulog_la_LDFLAGS = -Wc,-nostartfiles \
-					-version-info $(IPULOG_LIBVERSION)
-libnetfilter_log_libipulog_la_LIBADD  = libnetfilter_log.la ${LIBNFNETLINK_LIBS}
-libnetfilter_log_libipulog_la_SOURCES = libipulog_compat.c
+libnetfilter_log_libipulog_la_CPPFLAGS = ${AM_CPPFLAGS} ${LIBNFNETLINK_CFLAGS}
+libnetfilter_log_libipulog_la_LDFLAGS  = -Wc,-nostartfiles \
+					 -version-info $(IPULOG_LIBVERSION)
+libnetfilter_log_libipulog_la_LIBADD   = libnetfilter_log.la ${LIBNFNETLINK_LIBS}
+libnetfilter_log_libipulog_la_SOURCES  = libipulog_compat.c
 endif
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 39abb3e00af9..133b6ec550cf 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -6,12 +6,13 @@ nfulnl_test_SOURCES = nfulnl_test.c
 nfulnl_test_LDADD = ../src/libnetfilter_log.la
 nfulnl_test_LDFLAGS = -dynamic
 
-nf_log_SOURCES = nf-log.c
-nf_log_LDADD   = ../src/libnetfilter_log.la $(LIBMNL_LIBS)
-nf_log_LDFLAGS = -dynamic
+nf_log_SOURCES  = nf-log.c
+nf_log_LDADD    = ../src/libnetfilter_log.la $(LIBMNL_LIBS)
+nf_log_LDFLAGS  = -dynamic
+nf_log_CPPFLAGS = $(AM_CPPFLAGS) $(LIBMNL_CFLAGS)
 if BUILD_NFCT
-nf_log_LDADD += $(LIBNETFILTER_CONNTRACK_LIBS)
-nf_log_CPPFLAGS = ${AM_CPPFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS} -DBUILD_NFCT
+nf_log_LDADD    += $(LIBNETFILTER_CONNTRACK_LIBS)
+nf_log_CPPFLAGS += $(LIBNETFILTER_CONNTRACK_CFLAGS) -DBUILD_NFCT
 endif
 
 if BUILD_IPULOG
-- 
2.33.0

