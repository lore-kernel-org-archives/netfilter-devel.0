Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F4CC07E9D
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Sep 2022 22:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiI0WPb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Sep 2022 18:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiI0WPa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Sep 2022 18:15:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E13B12647C
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Sep 2022 15:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Gt3QJxIDm5a4QQGeMcsvX6tEaMvyGoa/X6Llv6Z+n+o=; b=OzCppkRcf3BgiYKgz1yxm2igrz
        LQXMulohIKYm93qJmTLSTCh4AjBIqPo7jt9KHU+zs5MlnDy7WDPmJ2/Z5grtVlBJMYStAWerWBN6K
        vN69w3Mx7HV+rtyvzkdJ/i541G4L2Zy6oYp68FkT4prduTAoA1OolP9vWtaW/zqOZKFfWeH2J8FSk
        43HNr0wE3k1z5+8owdoYQZPJ+3iYWLxtq9DxD4my9Su9C+jVSSqAB1BBtBKllebj0xl+SUlUZOhm6
        m7FN3+snaG0tWnMGBjDUcawST3jS4VHydP5b/NZ52DwUwnC9o8H8jl12CNwSA8X/uBZZkGOOTS3Yb
        qVWtDJzg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1odIrO-000056-By
        for netfilter-devel@vger.kernel.org; Wed, 28 Sep 2022 00:15:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/5] ebtables: Drop unused OPT_* defines
Date:   Wed, 28 Sep 2022 00:15:08 +0200
Message-Id: <20220927221512.7400-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927221512.7400-1-phil@nwl.cc>
References: <20220927221512.7400-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Obviously copied from legacy ebtables, not needed by ebtables-nft.
OPT_CNT_* ones seem not even used in legacy anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index b986fd9e84799..3887ea1a39f27 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -168,10 +168,7 @@ int ebt_get_current_chain(const char *chain)
 #define OPT_ZERO	0x100
 #define OPT_LOGICALIN	0x200
 #define OPT_LOGICALOUT	0x400
-#define OPT_KERNELDATA	0x800 /* This value is also defined in ebtablesd.c */
 #define OPT_COUNT	0x1000 /* This value is also defined in libebtc.c */
-#define OPT_CNT_INCR	0x2000 /* This value is also defined in libebtc.c */
-#define OPT_CNT_DECR	0x4000 /* This value is also defined in libebtc.c */
 
 /* Default command line options. Do not mess around with the already
  * assigned numbers unless you know what you are doing */
-- 
2.34.1

