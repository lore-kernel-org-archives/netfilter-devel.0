Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89381C43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Nov 2022 10:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbiKNKlR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 05:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235955AbiKNKlO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 05:41:14 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C52E01DDCE;
        Mon, 14 Nov 2022 02:41:12 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 1/6] netfilter: nft_payload: use __be16 to store gre version
Date:   Mon, 14 Nov 2022 11:41:01 +0100
Message-Id: <20221114104106.8719-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221114104106.8719-1-pablo@netfilter.org>
References: <20221114104106.8719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

GRE_VERSION and GRE_VERSION0 are expressed in network byte order,
use __be16. Uncovered by sparse:

net/netfilter/nft_payload.c:112:25: warning: incorrect type in assignment (different base types)
net/netfilter/nft_payload.c:112:25:    expected unsigned int [usertype] version
net/netfilter/nft_payload.c:112:25:    got restricted __be16
net/netfilter/nft_payload.c:114:22: warning: restricted __be16 degrades to integer

Fixes: c247897d7c19 ("netfilter: nft_payload: access GRE payload via inner offset")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 9d2ac764a14c..53e64d8aa01f 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -102,8 +102,9 @@ static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
 		}
 		break;
 	case IPPROTO_GRE: {
-		u32 offset = sizeof(struct gre_base_hdr), version;
+		u32 offset = sizeof(struct gre_base_hdr);
 		struct gre_base_hdr *gre, _gre;
+		__be16 version;
 
 		gre = skb_header_pointer(pkt->skb, thoff, sizeof(_gre), &_gre);
 		if (!gre)
-- 
2.30.2

