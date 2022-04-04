Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2134C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbiDDMGa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbiDDMG3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:06:29 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D763585D
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JRHloofUsrPew0PTtdCjvkAIdAZSH7j38Mtr8ccvStw=; b=j+xUzcRrJgICwvD7DoyOQdlEYp
        qsZr52rMPctFmmkw9DFe1IH8+PL3A9YR/7KwfW+YORZSoPeq45ZIFGyPmGv8nESqvLq5SxMMZFuSw
        QAoWQBpB3JMp4Qx7Q26s5uFd/ZOolxwnW+yztkB4EamhbMbug8iXDYYrX4tLYRYTlOpbFV2ca97ik
        vztkslawn5BLkBRi/IdenkwVWzvhvC0vgvdcTiwYCbcuwI6zYQMFH1fgkYBpzACDIma8wmS0AY5sB
        yzWC8i9cMv/ugmwpDKLuh31Q4QEojyMTUTNTmepklGRi+QExxEKzVZZ+EBgJpl44wn8ygPjMaMbBZ
        m2O7/oPA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLRe-007FLB-KU
        for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2022 13:04:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nf-next PATCH v2 2/5] netfilter: bitwise: replace hard-coded size with `sizeof` expression
Date:   Mon,  4 Apr 2022 13:04:14 +0100
Message-Id: <20220404120417.188410-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404120417.188410-1-jeremy@azazel.net>
References: <20220404120417.188410-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When calculating the length of an array, use the appropriate `sizeof`
expression for its type, rather than an integer literal.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_bitwise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index cdace40c6ba0..38dd4aa8cd63 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -31,7 +31,7 @@ static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
 {
 	unsigned int i;
 
-	for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++)
+	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++)
 		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
 }
 
-- 
2.35.1

