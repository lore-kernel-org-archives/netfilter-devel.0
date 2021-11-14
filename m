Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D9EC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD0260234
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhKNOE6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbhKNOE0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:04:26 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B0AC061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2BcfBtMqBIE1iOXoL475HL8Ops6pZ2KT+Qb2/Z3xa1Y=; b=mzY/vWEpOLAgup/gQJeDa/tpSN
        Lw+dwksalbto6aKV9NgQPFI96Hemi8YbfxIQv2VZFvAD+/kA3nwVGhLIt7ic3pAjnDOg6nALFg0Kp
        1/Kqp+Ebr4kwW9bTKXYZQ6kAN6x6sgbniFWYejVtru5CImMKwOUUK9jgvypGp/9kOlz17iU0olZu2
        hpF55a7+vt1KMKSltK9NK9usp7DHPnKZnzBgNKfMblA5vFaiuoFGOK4Q36o0HXkI1MieggV83f3nL
        BGUz87xWNFfmXrb3f5wqTSGX9oMAlcAaM8ZoHgqlSGJ49KyVkCW5u4JRTcFQApy/zrlaMNbZBjw7D
        Wn0gpRuQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4G-00Cdsh-4s
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 09/16] build: group `*_la_*` variables with their libraries
Date:   Sun, 14 Nov 2021 14:00:51 +0000
Message-Id: <20211114140058.752394-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114140058.752394-1-jeremy@azazel.net>
References: <20211114140058.752394-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move the `_SOURCES`, `_LIBADD` and `_LDFLAGS` variables for each
input-packet library alongside the matching `.la` definition.  In
particular, move the `NFLOG` and `ULOG` variables inside the
conditionals controlling whether the libraries get built.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/packet/Makefile.am | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index daf374a65917..5c95e0576e00 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -4,20 +4,20 @@ AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS}
 
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
 ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
-
-ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
-ulogd_inppkt_ULOG_la_LDFLAGS = -avoid-version -module
-ulogd_inppkt_ULOG_la_LIBADD = ../../libipulog/libipulog.la
-
-ulogd_inppkt_UNIXSOCK_la_SOURCES = ulogd_inppkt_UNIXSOCK.c
-ulogd_inppkt_UNIXSOCK_la_LDFLAGS = -avoid-version -module
+endif
-- 
2.33.0

