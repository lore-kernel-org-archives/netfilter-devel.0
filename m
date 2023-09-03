Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AAEC71153
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Sep 2023 17:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjICRMQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Sep 2023 13:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234783AbjICRMQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2023 13:12:16 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA54DE6
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Sep 2023 10:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qv8YFmFu05edmRRi/nf3Pu/fMZfqHlxRdpqXECTU174=; b=JTMes/GdmPZXhIsAkqK7SYMxJn
        2P/x1SMacxT61x5w5rojb4HAyyrLe/NzCHtOvQjAF9oCVm+ctKg0YuJxQSBFNeHhEOBDGkE5/jHpj
        y4W2AawPWHaWtwqZCse9duyk/TNiFn3LdTh0r0lB47H3jNJjvaRnrjIRK8jvhoriw0El4FJmVj6wy
        NMgdIHTi8V2XybAZpeGlr707iMfzOwb5O2Vg00p91HlNaeLKTIbR/Gdzlk2W8AtPOz6IjhlOJggDz
        v62HgyPJcT2aECU7oWmcmEGQqBv77kMtEwrppJmxAZ5+naYw81AE2gsXdPD4n8pRHSSWCOTNOh1FC
        HzTWFNKg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qcqc3-0048iL-12
        for netfilter-devel@vger.kernel.org;
        Sun, 03 Sep 2023 18:10:15 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_conntrack 1/2] Ignore `configure~`
Date:   Sun,  3 Sep 2023 18:10:08 +0100
Message-Id: <20230903171009.2002392-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
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
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index d919db16bd13..d1226dbe89f5 100644
--- a/.gitignore
+++ b/.gitignore
@@ -11,6 +11,7 @@ Makefile.in
 /build-aux/
 /config.*
 /configure
+/configure~
 /libtool
 /stamp-h1
 
-- 
2.40.1

