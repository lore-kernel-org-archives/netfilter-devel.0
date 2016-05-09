From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] netfilter: nfnetlink_acct: validate NFACCT_QUOTA parameter
Date: Mon,  9 May 2016 21:52:03 +0200
Message-ID: <1462823523-6682-4-git-send-email-pablo@netfilter.org>
References: <1462823523-6682-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53594 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbcEITwQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2016 15:52:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3FCFDEAA60
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 21:52:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2D58D134711
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 21:52:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C8D15FAB4E
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 21:52:10 +0200 (CEST)
In-Reply-To: <1462823523-6682-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Turnbull <phil.turnbull@oracle.com>

If a quota bit is set in NFACCT_FLAGS but the NFACCT_QUOTA parameter is
missing then a NULL pointer dereference is triggered. CAP_NET_ADMIN is
required to trigger the bug.

Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_acct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 4c2b4c0..dbd0803 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -96,6 +96,8 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
 			return -EINVAL;
 		if (flags & NFACCT_F_OVERQUOTA)
 			return -EINVAL;
+		if ((flags & NFACCT_F_QUOTA) && !tb[NFACCT_QUOTA])
+			return -EINVAL;
 
 		size += sizeof(u64);
 	}
-- 
2.1.4

