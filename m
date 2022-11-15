Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF1FC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Nov 2022 09:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiKOJ7b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 04:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237725AbiKOJ71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 04:59:27 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CE61DF4E;
        Tue, 15 Nov 2022 01:59:26 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 2/6] netfilter: nft_inner: fix return value check in nft_inner_parse_l2l3()
Date:   Tue, 15 Nov 2022 10:59:18 +0100
Message-Id: <20221115095922.139954-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115095922.139954-1-pablo@netfilter.org>
References: <20221115095922.139954-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Peng Wu <wupeng58@huawei.com>

In nft_inner_parse_l2l3(), the return value of skb_header_pointer() is
'veth' instead of 'eth' when case 'htons(ETH_P_8021Q)' and fix it.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Peng Wu <wupeng58@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_inner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index eae7caeff316..809f0d0787ec 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -72,7 +72,7 @@ static int nft_inner_parse_l2l3(const struct nft_inner *priv,
 			break;
 		case htons(ETH_P_8021Q):
 			veth = skb_header_pointer(pkt->skb, off, sizeof(_veth), &_veth);
-			if (!eth)
+			if (!veth)
 				return -1;
 
 			outer_llproto = veth->h_vlan_encapsulated_proto;
-- 
2.30.2

