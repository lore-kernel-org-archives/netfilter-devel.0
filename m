Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397DCC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2646060F70
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhJILoa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 07:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbhJILo0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 07:44:26 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F33C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 04:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mpgTInp0RTyDZ+zdoHPCstp63IsqhLUGT79LRzQMuJU=; b=dRV1euU8JIMIZkRf7OJFP3EHV2
        sGJt4vzPfTHpDQ7l5bHSdevuY3NSiVBu+URWfQ4eyUNF5WtwVPsk9rkyCYuTlZ7n2E+qWhGnhg79Z
        0Wu72dzSWVrDh6YQ3VcbSispK3iawCOuKbdfS6P2+2LByxtOVX3hFU9Mng9Oowe76G6cXRL8AEcAZ
        a5r5fnAwUTR4mzszt/dDvLxITO5sxqXrijSpX7C7efMkN/olXUDZPEGjkl/LIkaqI0zk1DGDHVsnz
        RR3fUG3egqW0LGFw26CfCIja3XxVWL4EmhV3hVIideTQIB5kc8DVRfGBcLIFo867fabCX4B0Ehja+
        AS933GIQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mZAkF-00BfRm-My
        for netfilter-devel@vger.kernel.org; Sat, 09 Oct 2021 12:42:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH 6/9] build: remove `-dynamic` when linking check progs
Date:   Sat,  9 Oct 2021 12:38:36 +0100
Message-Id: <20211009113839.2765382-7-jeremy@azazel.net>
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

The `-dynamic` flag is only meaningful for Darwin.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 utils/Makefile.am | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/utils/Makefile.am b/utils/Makefile.am
index 7b9d479382ea..94afb26180ed 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -4,11 +4,9 @@ check_PROGRAMS = nfulnl_test nf-log
 
 nfulnl_test_SOURCES = nfulnl_test.c
 nfulnl_test_LDADD = ../src/libnetfilter_log.la
-nfulnl_test_LDFLAGS = -dynamic
 
 nf_log_SOURCES  = nf-log.c
 nf_log_LDADD    = ../src/libnetfilter_log.la $(LIBMNL_LIBS)
-nf_log_LDFLAGS  = -dynamic
 nf_log_CPPFLAGS = $(AM_CPPFLAGS) $(LIBMNL_CFLAGS)
 if BUILD_NFCT
 nf_log_LDADD    += $(LIBNETFILTER_CONNTRACK_LIBS)
@@ -20,5 +18,4 @@ check_PROGRAMS += ulog_test
 
 ulog_test_SOURCES = ulog_test.c
 ulog_test_LDADD   = ../src/libnetfilter_log_libipulog.la
-ulog_test_LDFLAGS = -dynamic
 endif
-- 
2.33.0

