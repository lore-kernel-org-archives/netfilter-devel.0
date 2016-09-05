From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/29] netfilter: nf_tables: Use nla_put_be32() to dump immediate parameters
Date: Mon,  5 Sep 2016 12:58:35 +0200
Message-ID: <1473073124-5015-21-git-send-email-pablo@netfilter.org>
References: <1473073124-5015-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35308 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933550AbcIEK7O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 06:59:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 449EC2EFECF
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 12:59:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FB8B114D6B
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 12:59:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 171661150AF
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 12:59:11 +0200 (CEST)
In-Reply-To: <1473073124-5015-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_dump_register() should only be used with registers, not with
immediates.

Fixes: cb1b69b0b15b ("netfilter: nf_tables: add hash expression")
Fixes: 91dbc6be0a62("netfilter: nf_tables: add number generator expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_hash.c   | 6 +++---
 net/netfilter/nft_numgen.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index e090aee..764251d 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -88,11 +88,11 @@ static int nft_hash_dump(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nft_dump_register(skb, NFTA_HASH_DREG, priv->dreg))
 		goto nla_put_failure;
-	if (nft_dump_register(skb, NFTA_HASH_LEN, priv->len))
+	if (nla_put_be32(skb, NFTA_HASH_LEN, htonl(priv->len)))
 		goto nla_put_failure;
-	if (nft_dump_register(skb, NFTA_HASH_MODULUS, priv->modulus))
+	if (nla_put_be32(skb, NFTA_HASH_MODULUS, htonl(priv->modulus)))
 		goto nla_put_failure;
-	if (nft_dump_register(skb, NFTA_HASH_SEED, priv->seed))
+	if (nla_put_be32(skb, NFTA_HASH_SEED, htonl(priv->seed)))
 		goto nla_put_failure;
 
 	return 0;
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 176e26d..294745e 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -68,9 +68,9 @@ static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
 {
 	if (nft_dump_register(skb, NFTA_NG_DREG, dreg))
 		goto nla_put_failure;
-	if (nft_dump_register(skb, NFTA_NG_UNTIL, until))
+	if (nla_put_be32(skb, NFTA_NG_UNTIL, htonl(until)))
 		goto nla_put_failure;
-	if (nft_dump_register(skb, NFTA_NG_TYPE, type))
+	if (nla_put_be32(skb, NFTA_NG_TYPE, htonl(type)))
 		goto nla_put_failure;
 
 	return 0;
-- 
2.1.4

