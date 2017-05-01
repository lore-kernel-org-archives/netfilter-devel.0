From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/53] net: netfilter: Use list_{next/prev}_entry instead of list_entry
Date: Mon,  1 May 2017 12:46:40 +0200
Message-ID: <1493635640-24325-14-git-send-email-pablo@netfilter.org>
References: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49704 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S378844AbdEAKrq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 06:47:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2325A1F4B96
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:47:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15EE0ADF8
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:47:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07F4CDA862
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:47:38 +0200 (CEST)
In-Reply-To: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: simran singhal <singhalsimran0@gmail.com>

This patch replace list_entry with list_prev_entry as it makes the
code more clear to read.

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7ba76da96cc2..22e191ad4468 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1905,7 +1905,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	if ((event != NFT_MSG_DELRULE) && (rule->list.prev != &chain->rules)) {
-		prule = list_entry(rule->list.prev, struct nft_rule, list);
+		prule = list_prev_entry(rule, list);
 		if (nla_put_be64(skb, NFTA_RULE_POSITION,
 				 cpu_to_be64(prule->handle),
 				 NFTA_RULE_PAD))
-- 
2.1.4

