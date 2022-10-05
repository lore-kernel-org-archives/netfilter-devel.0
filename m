Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE68C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 16:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiJEQn2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 12:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJEQn1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 12:43:27 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51A957899
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 09:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=A5s7EVf9Wbed6Umv3BWEaJ4T0zfs3Wvg35PI8k4K6V8=; b=FcImKjXkCyauSBB1OoX0F82Zj1
        tfH9DNveCvM8ObwB1qORBGBygPL7wjPl0W1j1PGM8a5TIeBiGQP4ZOIIfx46D3GsiNZrHzaP9EK5X
        ctF2IhzrfExag3WqRDMOoEQ56FUO5HVjGpNhNEI/GE1zZWkxxalpOACVsGeOMq8GowvfMGB6G92u+
        4rWuZABn46/7rSvYqbOKT8c3eMFSKUtgfi34LTCDHRlkf+gVKO95Ah16s3SY1XwvZg9nsOerqBqHe
        lA7OdO/SXr48JduaqZVICEQy5z/13STj6xVLeYh7LT/l7VcX96Vt47rtmLtv+U9/EsqOgnEFH+VX9
        HbnQ/Dag==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1og7UT-0005yM-3A
        for netfilter-devel@vger.kernel.org; Wed, 05 Oct 2022 18:43:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: IDLETIMER.t: Fix syntax, support for restore input
Date:   Wed,  5 Oct 2022 18:43:16 +0200
Message-Id: <20221005164316.11412-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Expected output was wrong in the last OK test, probably defeating rule
search check. Also use a different label, otherwise the kernel will
reject the second idletimer with same label but different type if both
rules are added at once.

Fixes: 85b9ec8615428 ("extensions: IDLETIMER: Add alarm timer option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_IDLETIMER.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_IDLETIMER.t b/extensions/libxt_IDLETIMER.t
index e8f306d2462c7..3345d5bef9e38 100644
--- a/extensions/libxt_IDLETIMER.t
+++ b/extensions/libxt_IDLETIMER.t
@@ -2,4 +2,4 @@
 -j IDLETIMER --timeout;;FAIL
 -j IDLETIMER --timeout 42;;FAIL
 -j IDLETIMER --timeout 42 --label foo;=;OK
--j IDLETIMER --timeout 42 --label foo --alarm;;OK
+-j IDLETIMER --timeout 42 --label bar --alarm;=;OK
-- 
2.34.1

