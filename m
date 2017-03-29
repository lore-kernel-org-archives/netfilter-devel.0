From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/8] netfilter: nfnl_cthelper: Fix memory leak
Date: Wed, 29 Mar 2017 14:14:05 +0200
Message-ID: <1490789650-7294-4-git-send-email-pablo@netfilter.org>
References: <1490789650-7294-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755910AbdC2MPA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 08:15:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3AEFEBAD5
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 14:14:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF95DDA863
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 14:14:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9915FDA3FD
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 14:14:54 +0200 (CEST)
In-Reply-To: <1490789650-7294-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jeffy Chen <jeffy.chen@rock-chips.com>

We have memory leaks of nf_conntrack_helper & expect_policy.

Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cthelper.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 90f291e27eb1..2b987d2a77bc 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -216,7 +216,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 
 	ret = nfnl_cthelper_parse_expect_policy(helper, tb[NFCTH_POLICY]);
 	if (ret < 0)
-		goto err;
+		goto err1;
 
 	strncpy(helper->name, nla_data(tb[NFCTH_NAME]), NF_CT_HELPER_NAME_LEN);
 	helper->data_len = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
@@ -247,10 +247,12 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 
 	ret = nf_conntrack_helper_register(helper);
 	if (ret < 0)
-		goto err;
+		goto err2;
 
 	return 0;
-err:
+err2:
+	kfree(helper->expect_policy);
+err1:
 	kfree(helper);
 	return ret;
 }
@@ -696,6 +698,8 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 
 			found = true;
 			nf_conntrack_helper_unregister(cur);
+			kfree(cur->expect_policy);
+			kfree(cur);
 		}
 	}
 	/* Make sure we return success if we flush and there is no helpers */
@@ -759,6 +763,8 @@ static void __exit nfnl_cthelper_exit(void)
 				continue;
 
 			nf_conntrack_helper_unregister(cur);
+			kfree(cur->expect_policy);
+			kfree(cur);
 		}
 	}
 }
-- 
2.1.4

