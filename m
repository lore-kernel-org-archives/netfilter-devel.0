From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: do not dump chain counters if not enabled
Date: Wed,  4 Oct 2017 17:22:13 +0200
Message-ID: <1507130533-24651-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34546 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752368AbdJDPWW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 11:22:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CAF6E31024C
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 17:22:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC563DA3F4
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 17:22:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B666ADA78E
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 17:22:16 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 81E3640584D0
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 17:22:16 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Chain counters are only enabled on demand since 9f08ea848117, skip them
when dumping them via netlink.

Fixes: 9f08ea848117 ("netfilter: nf_tables: keep chain counters away from hot path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 34adedcb239e..64e1ee091225 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1048,7 +1048,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		if (nla_put_string(skb, NFTA_CHAIN_TYPE, basechain->type->name))
 			goto nla_put_failure;
 
-		if (nft_dump_stats(skb, nft_base_chain(chain)->stats))
+		if (basechain->stats && nft_dump_stats(skb, basechain->stats))
 			goto nla_put_failure;
 	}
 
-- 
2.1.4

