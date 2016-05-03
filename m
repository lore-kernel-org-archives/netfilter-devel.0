From: Phil Turnbull <phil.turnbull@oracle.com>
Subject: [PATCH nf] netfilter: nfnetlink_acct: validate NFACCT_QUOTA parameter
Date: Tue,  3 May 2016 16:39:19 -0400
Message-ID: <1462307959-3553-1-git-send-email-phil.turnbull@oracle.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	coreteam@netfilter.org, Phil Turnbull <phil.turnbull@oracle.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38058 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493AbcECUkN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 16:40:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a quota bit is set in NFACCT_FLAGS but the NFACCT_QUOTA parameter is
missing then a NULL pointer dereference is triggered. CAP_NET_ADMIN is
required to trigger the bug.

Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
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
2.8.0

