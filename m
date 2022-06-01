Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66159C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jun 2022 13:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353171AbiFANT3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jun 2022 09:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353169AbiFANT2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jun 2022 09:19:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8558313D19
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2022 06:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8NZKeY9rTOW7qVDyhfkW3Y2/30aiCS1sY7JlvHMP66k=; b=m+VwyKqcKAi//P1ZgZwzWvIOxP
        yfK7dFwE+KCZTt0t4CNpVbvjiBlWYe3LN7j9s1zMX/K2sVT9lG6zIRQ7o9q7E2kXDmE1a6tmZYub4
        uUmTdPO990YqdQy6pbPmqdUhnsHwIPw7tnHHL5/rjed4s/sqchUtgFDzdB6XSXlOaNJ2m6eshPDOV
        vGC8M3DUaozWxYPPFj2PdPW/2HSEi+e5neOjWJm/D8OsqvtkZaRpGwd951AcId0OYWe31APHHmiFI
        5QfKZy+UTWnD29AZXXxcWs/YkakLgL6gdR28+/mC8QjO73JYKsYUY1rYZmMtwd7p1gx1Y3TkxEkaE
        LSF4y6xQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nwOFv-0004wd-CW; Wed, 01 Jun 2022 15:19:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf PATCH] netfilter: nft_nat: Fix inet l4-only NAT
Date:   Wed,  1 Jun 2022 15:19:14 +0200
Message-Id: <20220601131914.13322-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If nat expression does not specify an address, its family value is
NFPROTO_INET. Disable the check against the packet's family in that
case.

Fixes: a33f387ecd5aa ("netfilter: nft_nat: allow to specify layer 4 protocol NAT only")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nft_nat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 4394df4bc99b4..4ee690bdbf392 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -335,7 +335,7 @@ static void nft_nat_inet_eval(const struct nft_expr *expr,
 {
 	const struct nft_nat *priv = nft_expr_priv(expr);
 
-	if (priv->family == nft_pf(pkt))
+	if (priv->family == NFPROTO_INET || priv->family == nft_pf(pkt))
 		nft_nat_eval(expr, regs, pkt);
 }
 
-- 
2.34.1

