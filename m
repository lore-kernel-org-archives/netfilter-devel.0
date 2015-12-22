From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: nft_ct: include direction when dumping NFT_CT_L3PROTOCOL key
Date: Tue, 22 Dec 2015 18:53:17 +0100
Message-ID: <1450806797-21788-3-git-send-email-pablo@netfilter.org>
References: <1450806797-21788-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44726 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbbLVRxi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 12:53:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8CC3F23CF72
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:53:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7EDA4DA7FF
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:53:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 96D67DA85D
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:53:35 +0100 (CET)
In-Reply-To: <1450806797-21788-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

one nft userspace test case fails with

'ct l3proto original ipv4' mismatches 'ct l3proto ipv4'

... because NFTA_CT_DIRECTION attr is missing.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 8cbca34..9399215 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -366,6 +366,7 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 
 	switch (priv->key) {
+	case NFT_CT_L3PROTOCOL:
 	case NFT_CT_PROTOCOL:
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
-- 
2.1.4

