From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 kernel 1/29] bugfix: pkts/bytes need to be specified simultaneously
Date: Wed, 10 Jul 2013 19:24:59 +0100
Message-ID: <1373480727-11254-2-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:34255 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJSZi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:25:38 -0400
Received: by mail-la0-f41.google.com with SMTP id fn20so6074220lab.14
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:25:36 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* in nfnetlink_acct.c::nfnl_acct_new enforce a check ensuring that
packet and byte values are specified simultaneously - return -EINVAL if
that is not the case.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 net/netfilter/nfnetlink_acct.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index c7b6d46..526abd7 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -45,7 +45,9 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	struct nf_acct *nfacct, *matching = NULL;
 	char *acct_name;
 
-	if (!tb[NFACCT_NAME])
+	if (!tb[NFACCT_NAME] ||
+	    (tb[NFACCT_BYTES] && !tb[NFACCT_PKTS]) ||
+	    (!tb[NFACCT_BYTES] && tb[NFACCT_PKTS]))
 		return -EINVAL;
 
 	acct_name = nla_data(tb[NFACCT_NAME]);
-- 
1.8.3.1

