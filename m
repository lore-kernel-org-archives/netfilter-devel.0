Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15319C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 May 2022 11:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiEFLpC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 May 2022 07:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391450AbiEFLpA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 May 2022 07:45:00 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683DC62BC3
        for <netfilter-devel@vger.kernel.org>; Fri,  6 May 2022 04:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4HnvjDSczFSPuj0TGvEvB5X0Q+/SvWuok48vaf3QQmA=; b=XJG5uabKJ6Izhx2gZrIJgZnGjf
        Kl8PYaM1UhUQFK7IJFR+VtTToQxhiHcjEIV7+w+yNlmBGRPB5WygbsxrDOfmkFiZBFvEcgJvSf8+t
        m9QB79bD7juRwCf3wDjFSS5uC9mK++pMxOv3wsB69fuepe3sTdO/UbsqBSe41xDyHOs3FzKmFTqJE
        MPF0hTq/+/Gf1DOzbqZdy3oeCMCgMkAilB7D5vGclI668kzzTjuZJsdQq21hJLeV4+tcigAtvUlpK
        Bx1HUFFiAN+jgNZx3ZuPBhHgAHqhmHxeLhWaYoyqQGhBUpWASVYrrvCFUoDtph4Br0Y2j1sPW7Zrp
        4sJ1Rmmg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmwKf-0005pw-Hi; Fri, 06 May 2022 13:41:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/5] extensions: MARK: Drop extra newline at end of help
Date:   Fri,  6 May 2022 13:41:00 +0200
Message-Id: <20220506114104.7344-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506114104.7344-1-phil@nwl.cc>
References: <20220506114104.7344-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: f4b737fb0c52a ("libxt_MARK r2")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_MARK.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index b765af6c35304..1536563d0f4c7 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -77,8 +77,7 @@ static void mark_tg_help(void)
 "  --set-mark value[/mask]   Clear bits in mask and OR value into nfmark\n"
 "  --and-mark bits           Binary AND the nfmark with bits\n"
 "  --or-mark bits            Binary OR the nfmark with bits\n"
-"  --xor-mark bits           Binary XOR the nfmark with bits\n"
-"\n");
+"  --xor-mark bits           Binary XOR the nfmark with bits\n");
 }
 
 static void MARK_parse_v0(struct xt_option_call *cb)
-- 
2.34.1

