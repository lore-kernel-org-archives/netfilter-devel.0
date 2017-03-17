From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: cthelper: fix leak in nfnl_cthelper_del()
Date: Fri, 17 Mar 2017 13:41:09 +0100
Message-ID: <1489754469-11208-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34856 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdCQMmS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 08:42:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91545E3A24
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 13:41:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76F12DA87B
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 13:41:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75CACDA87A
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 13:41:16 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Release the helper object and the expect_policy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cthelper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 3166406d68d3..2defe730b1f4 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -609,6 +609,8 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 
 			found = true;
 			nf_conntrack_helper_unregister(cur);
+			kfree(cur->expect_policy);
+			kfree(cur);
 		}
 	}
 	/* Make sure we return success if we flush and there is no helpers */
-- 
2.1.4

