From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/32] netfilter: nf_tables: fix a typo in nf_tables_getflowtable()
Date: Fri, 19 Jan 2018 20:10:18 +0100
Message-ID: <20180119191041.25804-10-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45186 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756226AbeASTLC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:11:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6EB7D2EFEAC
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53469DA859
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:00 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix a typo, we should check 'flowtable' instead of 'table'.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0b814cbcd45e..b541e5094dce 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5225,7 +5225,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 
 	flowtable = nf_tables_flowtable_lookup(table, nla[NFTA_FLOWTABLE_NAME],
 					       genmask);
-	if (IS_ERR(table))
+	if (IS_ERR(flowtable))
 		return PTR_ERR(flowtable);
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
-- 
2.11.0

