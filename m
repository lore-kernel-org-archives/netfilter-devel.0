Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C3FC4320E
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 121BF60200
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhH1Tlf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 15:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbhH1Tle (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 15:41:34 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6572C061796
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RgEmlKQwQFo0a5kmP9bcOkPnLTMEQT4g1i/qrmeYDfs=; b=gb5oZGXVoGqN/Cof5Iaoj3VZze
        HgVRtCKoPy00kP50yOwRrezTiNlLEvu2lS0kgXYcw333l2OtbhFOW5EyA7R+z08N8Z0nFT3POCOR6
        734IA7AncWjBN/CJ9GIMWq9bZQz9r0LwWgvpUDpvFHEJXKWHPtqiHWyaFeVcDVZXiq21WWbmMI4Ea
        11yw2hxmma/WCCdvMIF1Qgs7pSM9336iBgmByXNhSI/IK35esaXFtbAYVHdLuAb0LtHezwL2S6jD6
        3gMu8BqbyblizvvmWXFjni1qJnvq+FzDjFb1CPnUO5FDwHRUog8csgjr0Ufn0XTfIsAnu3KkYoCQ1
        2obW1B9A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mK4C1-00FeN7-Ia; Sat, 28 Aug 2021 20:40:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_log 2/6] build: remove references to non-existent man-pages.
Date:   Sat, 28 Aug 2021 20:38:20 +0100
Message-Id: <20210828193824.1288478-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210828193824.1288478-1-jeremy@azazel.net>
References: <20210828193824.1288478-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.am | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 9a1cbcb481f4..2a9cdd826dae 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,9 +2,7 @@ SUBDIRS	= include src utils
 
 ACLOCAL_AMFLAGS = -I m4
 
-EXTRA_DIST = $(man_MANS) Make_global.am
-
-man_MANS = #nfnetlink_log.3 nfnetlink_log.7
+EXTRA_DIST = Make_global.am
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnetfilter_log.pc
-- 
2.33.0

