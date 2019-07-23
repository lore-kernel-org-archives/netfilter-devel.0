Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14A1C7618B
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E6822353
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbfGWN2J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 09:28:09 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48456 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731095AbfGWN2J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 09:28:09 -0400
Received: from localhost ([::1]:33314 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hpupr-00088V-O7; Tue, 23 Jul 2019 15:28:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [PATCH v3 2/2] net: netfilter: nft_meta_bridge: Eliminate 'out' label
Date:   Tue, 23 Jul 2019 15:27:53 +0200
Message-Id: <20190723132753.13781-2-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190723132753.13781-1-phil@nwl.cc>
References: <20190723132753.13781-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The label is used just once and the code it points at is not reused, no
point in keeping it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/bridge/netfilter/nft_meta_bridge.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index a98dec2cf0cfd..1804e867f7151 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -57,13 +57,11 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		return;
 	}
 	default:
-		goto out;
+		return nft_meta_get_eval(expr, regs, pkt);
 	}
 
 	strncpy((char *)dest, br_dev ? br_dev->name : "", IFNAMSIZ);
 	return;
-out:
-	return nft_meta_get_eval(expr, regs, pkt);
 err:
 	regs->verdict.code = NFT_BREAK;
 }
-- 
2.22.0

