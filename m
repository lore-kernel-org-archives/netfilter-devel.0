From: mathieu.poirier@linaro.org
Subject: [PATCH] netfilter: nfnetlink_acct: Fixing memory leak
Date: Sun,  1 Jun 2014 19:42:58 -0600
Message-ID: <1401673378-20755-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, dan.carpenter@oracle.com,
	mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53311 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbaFBBna (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2014 21:43:30 -0400
Received: by mail-pd0-f171.google.com with SMTP id y13so2883298pdi.30
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Jun 2014 18:43:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Allocation of memory need only to happen once, that is
after the proper checks on the NFACCT_FLAGS have been
done.  Otherwise the code can return without freeing
already allocated memory.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 net/netfilter/nfnetlink_acct.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 70e86bb..54af985 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -83,7 +83,6 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 		return -EBUSY;
 	}
 
-	nfacct = kzalloc(sizeof(struct nf_acct), GFP_KERNEL);
 	if (tb[NFACCT_FLAGS]) {
 		flags = ntohl(nla_get_be32(tb[NFACCT_FLAGS]));
 		if (flags & ~NFACCT_F_QUOTA)
-- 
1.9.1

