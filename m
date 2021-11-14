Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0D5C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 461F660EE2
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhKNPzo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 10:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbhKNPzk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 10:55:40 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DBCC061202
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 07:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2BcfBtMqBIE1iOXoL475HL8Ops6pZ2KT+Qb2/Z3xa1Y=; b=iVGvHv1V5g7QCPBP/qfEM1icba
        nhVlrAYQY66KTXj17ocAcOqgwzbQcVRP19Y0X2QTfO4jITg+bParQbmk/MzTpjp75uInyLtGtE5lr
        4b1lQtHaktwR+03ptRn1Zpns1LQ1VKtL0CX1o+aaSpOmgx+yd9AjglRBYZ1nq/iYJEuASaOneyiBB
        sYbRUREP2cogBSAOzfLSC4Lugcd8y1jIvqQXrle5SBIc0GeWrTyNhYyKTaasWw3Cb8LUmORvkeYg4
        dcvE/1SwTenKWB9+moG8eXcMXsTVhOdQpD+WrgzFzGIcNKA18q+K2x13W46qCBbpE5rWCJc7dfGki
        cgMyo+Ow==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmHo9-00CfJ1-AS
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 15:52:41 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 09/15] build: group `*_la_*` variables with their libraries
Date:   Sun, 14 Nov 2021 15:52:25 +0000
Message-Id: <20211114155231.793594-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114155231.793594-1-jeremy@azazel.net>
References: <20211114155231.793594-1-jeremy@azazel.net>
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

