Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69EEC4167D
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA5DA610FD
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhKFQU4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbhKFQUy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:20:54 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00077C061746
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+ApNzPpUYMtb5MT3GiTEJ7ggEHwonEePWX3DoGg8t1s=; b=prIQIhu0nFvtUcYD4FYn10RFBW
        4JVSaXoKdeWBmSTuXFkqrtwJqasKp3qQycXHPLoD5rrKV+wuabuWIv7Pl8K/qhPhUPB59g2Vk2aRw
        yvsKWqFQLGHpXowRuG+UIIbJI0uGujgv4TYeg0ne2Mzspjs6C+WvyAehjr0QahOW5TaCKB3eN/6gu
        Rp6Df5DjnslFTeN/GZ6u1UL2N8GICsMZzq4N9+mISmcA7NzJvJMS/nVduHqGNPkoMOkCBr6p0RyNg
        ck6SO7UPcVJvhbqL5Jmh/MSds5gSQ866iLX/Ohpy7ttRpee2nuNw1haAUn8dkGRLijaoMa2eMjkWV
        xfSjkRJA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOOR-004loO-46
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:18:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 09/12] build: move library dependencies from LDFLAGS to LIBADD
Date:   Sat,  6 Nov 2021 16:17:56 +0000
Message-Id: <20211106161759.128364-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106161759.128364-1-jeremy@azazel.net>
References: <20211106161759.128364-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Delete some commented out variables.

Move definitions of some variables related to conditionally built
libraries into the related conditionals.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/flow/Makefile.am   |  8 +++-----
 input/packet/Makefile.am | 19 ++++++++++---------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 2171a0cd80c8..a556b4e4cb90 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -2,10 +2,8 @@ include $(top_srcdir)/Make_global.am
 
 AM_CPPFLAGS += ${LIBNETFILTER_CONNTRACK_CFLAGS}
 
-pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
+pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
-ulogd_inpflow_NFCT_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
-
-#ulogd_inpflow_IPFIX_la_SOURCES = ulogd_inpflow_IPFIX.c
-#ulogd_inpflow_IPFIX_la_LDFLAGS = -avoid-version -module
+ulogd_inpflow_NFCT_la_LDFLAGS = -avoid-version -module
+ulogd_inpflow_NFCT_la_LIBADD  = $(LIBNETFILTER_CONNTRACK_LIBS)
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index daf374a65917..3aa01112084e 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -4,20 +4,21 @@ AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_inppkt_UNIXSOCK.la
 
+ulogd_inppkt_UNIXSOCK_la_SOURCES = ulogd_inppkt_UNIXSOCK.c
+ulogd_inppkt_UNIXSOCK_la_LDFLAGS = -avoid-version -module
+
 if BUILD_ULOG
 pkglib_LTLIBRARIES += ulogd_inppkt_ULOG.la
+
+ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
+ulogd_inppkt_ULOG_la_LDFLAGS = -avoid-version -module
+ulogd_inppkt_ULOG_la_LIBADD = ../../libipulog/libipulog.la
 endif
 
 if BUILD_NFLOG
 pkglib_LTLIBRARIES += ulogd_inppkt_NFLOG.la
-endif
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
-ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
-
-ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
-ulogd_inppkt_ULOG_la_LDFLAGS = -avoid-version -module
-ulogd_inppkt_ULOG_la_LIBADD = ../../libipulog/libipulog.la
-
-ulogd_inppkt_UNIXSOCK_la_SOURCES = ulogd_inppkt_UNIXSOCK.c
-ulogd_inppkt_UNIXSOCK_la_LDFLAGS = -avoid-version -module
+ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module
+ulogd_inppkt_NFLOG_la_LIBADD  = $(LIBNETFILTER_LOG_LIBS)
+endif
-- 
2.33.0

