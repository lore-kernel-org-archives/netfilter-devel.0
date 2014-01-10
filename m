From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: fix missing byteorder conversion in policy
Date: Fri, 10 Jan 2014 15:14:20 +0100
Message-ID: <1389363260-3680-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38362 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbaAJOO2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:14:28 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When fetching the policy attribute, the byteorder conversion was
missing, breaking the chain policy setting.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 36add31..117bbaa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -859,7 +859,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		    nla[NFTA_CHAIN_HOOK] == NULL)
 			return -EOPNOTSUPP;
 
-		policy = nla_get_be32(nla[NFTA_CHAIN_POLICY]);
+		policy = ntohl(nla_get_be32(nla[NFTA_CHAIN_POLICY]));
 		switch (policy) {
 		case NF_DROP:
 		case NF_ACCEPT:
-- 
1.7.10.4

