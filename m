From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/22] netfilter: arp_tables: remove redundant check on ret being non-zero
Date: Mon, 20 Mar 2017 11:08:33 +0100
Message-ID: <1490004530-9128-6-git-send-email-pablo@netfilter.org>
References: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754029AbdCTKJj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 06:09:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 54992523DD
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:09:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44580DA877
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:09:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26CE9DA8EC
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:09:04 +0100 (CET)
In-Reply-To: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

ret is initialized to zero and if it is set to non-zero in the
xt_entry_foreach loop then we exit via the out_free label. Hence
the check for ret being non-zero is redundant and can be removed.

Detected by CoverityScan, CID#1357132 ("Logically Dead Code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 6241a81fd7f5..f17dab1dee6e 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -562,8 +562,6 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 		    XT_ERROR_TARGET) == 0)
 			++newinfo->stacksize;
 	}
-	if (ret != 0)
-		goto out_free;
 
 	ret = -EINVAL;
 	if (i != repl->num_entries)
-- 
2.1.4

