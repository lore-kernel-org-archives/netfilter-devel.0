Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D12C7112F
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 14:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377036AbjHRO3K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 10:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377832AbjHRO2g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 10:28:36 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAEA2D4A
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 07:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Vgx6ph2Xa44kJZwAy2MYPPIabjTw6WkkKaipadsn3ws=; b=Zq03FoJVwEQGla33qpcVFh8Ksa
        SZZ9xdVE5Ub7ZcprpaANmZ1dEZCG/ZwcEqjV7jjXy2ZUYWbpBCD7vPvi30Z0Q9fE8SpPx9fciO+yV
        G1qe9g/Du4C/T/90/LSsDnv7+wvwAYUB3JyV4aRQdli/wR78hIL4eQg4JiMctWouUIbyh+TcogP5g
        ioxEG/Oi3Wb655Yi2MnvlSiCTLRKunFgTqju/gSQEBJmMJLypu5smvl5O55JQ2Y+vFGDPLgRPcJFJ
        /UOt0OUG1QUTTJbqQNmwoFEJulCinCQ8/lQoWTWCoJ0Ad0nOjjTIiCuHMoikOBgVSd8GRgB+7T9Iy
        IkQ20F1A==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qX0Sn-005zdT-1r
        for netfilter-devel@vger.kernel.org;
        Fri, 18 Aug 2023 15:28:33 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons] doc: fix version number in xtables-addons.8
Date:   Fri, 18 Aug 2023 15:28:28 +0100
Message-Id: <20230818142828.2807221-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In v3.21 a change was made to the man-page template to use `@PACKAGE_VERSION@`,
instead of manually updating the version number on every release.  However,
xtables-addons.8.in is not processed by configure, so the appropriate version is
never filled in.

Update Makefile.mans to handle it.

Fixes: b6611c54f2b5 ("Xtables-addons 3.21")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.mans.in | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Makefile.mans.in b/Makefile.mans.in
index 63424f7d558a..17f786d64869 100644
--- a/Makefile.mans.in
+++ b/Makefile.mans.in
@@ -31,7 +31,10 @@ man_run = \
 all: xtables-addons.8
 
 xtables-addons.8: ${srcdir}/xtables-addons.8.in matches.man targets.man
-	${AM_V_GEN}sed -e '/@MATCHES@/ r matches.man' -e '/@TARGET@/ r targets.man' $< >$@;
+	${AM_V_GEN}sed \
+		-e 's/@PACKAGE'_'VERSION@/@PACKAGE_VERSION@/' \
+		-e '/@MATCHES@/ r matches.man' \
+		-e '/@TARGET@/ r targets.man' $< >$@;
 
 matches.man: .manpages.lst ${wcman_matches}
 	$(call man_run,${wlist_matches})
-- 
2.40.1

