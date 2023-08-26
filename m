Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D32C83F01
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Aug 2023 16:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjHZQcx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Aug 2023 12:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjHZQcr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Aug 2023 12:32:47 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC881172D
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Aug 2023 09:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T0kKHMIWhzE/ppvYpDTI/bJ/sc7WJm2xQIpkTbtUYcg=; b=WpWWPeqAM24tTPShvgJlH4BNrj
        vSPWFPXPK+CjsABF/Wn+kqMjek5xoKnNGwnfJYo6TS9KK9oiPpy1cM8S9Umtqwb/HvcO/Qmg3fNAq
        DR9Tzk1VdhwmDFD+2WOKLxBODKpIooV3DUodpX2du4lkKeQYT8sewWUVR4aX2egQmyAHPXrllms4t
        5N02ZVOx4x5oT5WpHcJNiSrRyrNbpXacyNgxk2Y5l7rrTyaH1+bdgjNNHM9/aSCiL6OX9yxXA/ha6
        QDN3TTtg9fRMok4xnjN2F71EF8EuHk2rWclqdG8g6cmtV9EcrnywptDil4dMIX0IO0EKGVKS4wb8/
        ROASRFyw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qZwDJ-00DpTC-0q
        for netfilter-devel@vger.kernel.org;
        Sat, 26 Aug 2023 17:32:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH conntrack-tools 2/4] build: stop suppressing warnings for generated sources
Date:   Sat, 26 Aug 2023 17:32:24 +0100
Message-Id: <20230826163226.1104220-3-jeremy@azazel.net>
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

Contrary to the comment that yacc and lex generate dirty code, none of
the warnings being suppressed are in the generated code.  Stop suppressing
them in order to fix the code.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/Makefile.am | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 4ea573abc12d..352aa37c9fa4 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -103,9 +103,6 @@ if HAVE_SYSTEMD
 conntrackd_SOURCES += systemd.c
 endif
 
-# yacc and lex generate dirty code
-read_config_yy.o read_config_lex.o: AM_CFLAGS += -Wno-incompatible-pointer-types -Wno-discarded-qualifiers
-
 conntrackd_LDADD = ${LIBMNL_LIBS} ${LIBNETFILTER_CONNTRACK_LIBS} \
 		   ${libdl_LIBS} ${LIBNFNETLINK_LIBS}
 
-- 
2.40.1

