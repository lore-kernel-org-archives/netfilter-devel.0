Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96930C43217
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7135360E9B
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhJILoa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 07:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbhJILoZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 07:44:25 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F708C061766
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 04:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QtrW9GT5JKTS9Xop5fNUrS/ZD1S3CMr6AyRWRAxMEDg=; b=TuUVKUoIGP0KXdWixCI9ttWW73
        3I23V7BMkcwJZBlBfuD8vx1nyMdPT9NpKoczFRd6O8dzNpA/8nezn3+AHHfWwHPf2BGp/eoMPb+/P
        lcRCzIM1X+bDZaYxAapK2mSOUANcTvmTu9aqsE+QtzLwMraj8DS/3Q7VRBPtIvZ8Cgjfi4tPUGFL8
        AFgSXHXjhW9FEn7ZuuwaprGCbYH62U5uQRnOX9gzep4Gy9k7jE75+EG/iYQaBkqctW8BDsO236+bT
        OwMKKR8EUa6bueiuAQKsJebhFV8PC/FGv2Dfs05w4ozqYT0Fh+WH+kiNMSn00OX5HLvYI38cM1GuO
        cxc5DbHw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mZAkF-00BfRm-KD
        for netfilter-devel@vger.kernel.org; Sat, 09 Oct 2021 12:42:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH 5/9] build: remove superfluous .la when linking ulog_test
Date:   Sat,  9 Oct 2021 12:38:35 +0100
Message-Id: <20211009113839.2765382-6-jeremy@azazel.net>
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

Explicit linkage to libnetfilter_log is not required.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 utils/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/Makefile.am b/utils/Makefile.am
index 133b6ec550cf..7b9d479382ea 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -19,6 +19,6 @@ if BUILD_IPULOG
 check_PROGRAMS += ulog_test
 
 ulog_test_SOURCES = ulog_test.c
-ulog_test_LDADD = ../src/libnetfilter_log_libipulog.la ../src/libnetfilter_log.la
+ulog_test_LDADD   = ../src/libnetfilter_log_libipulog.la
 ulog_test_LDFLAGS = -dynamic
 endif
-- 
2.33.0

