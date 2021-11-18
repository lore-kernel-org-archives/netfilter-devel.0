Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287B2C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 22:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DBBD61A62
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 22:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhKRWxG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhKRWxG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 17:53:06 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A94C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Nov 2021 14:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WNLQIjM3zr0nI6WLK0VIdM8Eg0+wTVc8SZVcMaDKBRA=; b=nWeuvIV46WdBhVhrd1qv0NGm1V
        lw4OypU6zHaZUeq1Wc7k+uv8BerAZFbCC9rx2NG75NNfxRts6gtrC0VYBotUVqLSgEchKUhs/PIOu
        82NOsWxdJz6+Y/I0ZuJm+YqLCIsvAaDTJuRc0y7841a0MFxL3vYYFkYI5Kdu0bVcy4oRihdjTCZPR
        7EauydvJUvdJC8wC8ZmkOWMmM40sUpzkBDC9odaBPigKGnZe2gssqRoS16sHtfWM//+xKbFtV1a+P
        JpR/iBiJ29jWhjEqZ4npZsDsJzVolOSARsRzUPiuWUP2kn6HmQJyd0ZGOXsGQA4qfNXr7fa2B2jvR
        0bIc419Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mnqEF-00GkNG-Do
        for netfilter-devel@vger.kernel.org; Thu, 18 Nov 2021 22:50:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH] build: fix `--disable-static`
Date:   Thu, 18 Nov 2021 22:49:55 +0000
Message-Id: <20211118224955.1444646-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `LT_INIT` argument should be `disable-static`.  Fix it.

Fixes: a04ddc0b83a6 ("build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with `LT_INIT`")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 762af47a4d84..c0da1b8830c2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -31,7 +31,7 @@ AS_IF([test "$enable_man_pages" = yes],
 
 AC_PROG_CC
 AM_PROG_CC_C_O
-LT_INIT([disable_static])
+LT_INIT([disable-static])
 AC_PROG_INSTALL
 AC_PROG_LN_S
 
-- 
2.33.0

