From: pablo@netfilter.org
Subject: [nftables 4/9] netfilter: nf_tables: fix error path in newchain
Date: Thu, 31 Jan 2013 01:04:00 +0100
Message-ID: <1359590645-4703-4-git-send-email-pablo@netfilter.org>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:45204 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab3AaAE0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:04:26 -0500
In-Reply-To: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Make sure the chain is not in the table list until the hook
registration returns success.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7f08381..031aad9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -868,8 +868,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	chain->net = net;
 	nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
 
-	list_add_tail(&chain->list, &table->chains);
-
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    chain->flags & NFT_BASE_CHAIN) {
 		err = nf_register_hook(&nft_base_chain(chain)->ops);
@@ -878,6 +876,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			return err;
 		}
 	}
+	list_add_tail(&chain->list, &table->chains);
 notify:
 	nf_tables_chain_notify(skb, nlh, table, chain, NFT_MSG_NEWCHAIN,
 			       family);
-- 
1.7.10.4

