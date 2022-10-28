Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8667ECAAA1
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Oct 2022 14:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiJ1OGJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 10:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiJ1OGF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 10:06:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 848D8205EF
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2022 07:06:04 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     kuba@kernel.org
Subject: [PATCH nf-next,v2] netfilter: nft_payload: use __be16 to store gre version
Date:   Fri, 28 Oct 2022 16:06:00 +0200
Message-Id: <20221028140600.4121-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
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
v2: fix typo in patch subject, s/__b16/__be16

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

