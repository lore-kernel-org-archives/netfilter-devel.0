Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BDBC04A6A
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Aug 2023 10:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjHFKW7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Aug 2023 06:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjHFKWz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Aug 2023 06:22:55 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDBB1BD0
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Aug 2023 03:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d8Owcfou1GHhx88xHCnzs40F2Dd8y1Zm0PzXsNpAvbI=; b=Fwthu70PfDih+21BQpxjEMcXt5
        kcPVW+l9Upgj6tou6gZmSfVIBBqqQMOtbSNVLvyLcepct0M2XK92bMu883f3oqJl8pR7ziQGYG9Fq
        7dg5v/kpeyVOiSx5xe/xywlin62lbFultYrzwNIwAtolBZuRHg+jqHOlTd5kV2P/l63Yo25oPiYX0
        WysbJSuFGEucrF28oRPxecbDvs65Dl6i6mpkpGVkYY8wNfLcInDuqHiDR2LPuzzBv82Bul90yZv7T
        9zoLD7MEdpxWtItZyEs/K8Sw79vIYY5cv3e4Z9MZOqZN6xzK82uAfxr09iQ6o5HAjvFYxDQ66C/0q
        o9BJNTZQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qSauR-005mug-1W
        for netfilter-devel@vger.kernel.org;
        Sun, 06 Aug 2023 11:22:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 2/2] doc: move man-pages to `MAINTAINERCLEANFILES`
Date:   Sun,  6 Aug 2023 11:22:48 +0100
Message-Id: <20230806102248.3517776-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230806102248.3517776-1-jeremy@azazel.net>
References: <20230806102248.3517776-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since the man-pages are built and included in the distribution
tar-balls, the appropriate clean target is `maintainer-clean`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/Makefile.am b/doc/Makefile.am
index 5a64e39b48cf..b43cb08d2d14 100644
--- a/doc/Makefile.am
+++ b/doc/Makefile.am
@@ -26,5 +26,5 @@ nft.8: ${ASCIIDOCS}
 .adoc.5:
 	${AM_V_GEN}${A2X} ${A2X_OPTS_MANPAGE} $<
 
-CLEANFILES += ${dist_man_MANS}
+MAINTAINERCLEANFILES = ${dist_man_MANS}
 endif
-- 
2.40.1

