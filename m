From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_nat: handle NF_DROP from nfnetlink_parse_nat_setup()
Date: Fri,  9 Sep 2016 15:38:12 +0200
Message-ID: <1473428292-24728-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59360 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750888AbcIINiT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 09:38:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 236F02273DA
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:38:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 138C11150C8
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:38:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB42D114D74
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:38:14 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_nat_setup_info() returns NF_* verdicts, so convert them to error
codes that is what ctnelink expects. This has passed overlook without
having any impact since this nf_nat_setup_info() has always returned
NF_ACCEPT so far. Since 870190a9ec90 ("netfilter: nat: convert nat bysrc
hash to rhashtable"), this is problem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index f8b916a..6998a0d 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -808,7 +808,7 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (err < 0)
 		return err;
 
-	return nf_nat_setup_info(ct, &range, manip);
+	return nf_nat_setup_info(ct, &range, manip) == NF_DROP ? -ENOMEM : 0;
 }
 #else
 static int
-- 
2.1.4

