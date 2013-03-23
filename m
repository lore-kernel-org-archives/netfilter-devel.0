From: pablo@netfilter.org
Subject: [PATCH] netfilter: nfnetlink_acct: return -EINVAL if object name is empty
Date: Sat, 23 Mar 2013 17:01:38 +0100
Message-ID: <1364054498-7234-1-git-send-email-pablo@netfilter.org>
Cc: michael.zintakis@googlemail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57252 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab3CWQBx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 12:01:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

If user-space tries to create accounting object with an empty
name, then return -EINVAL.

Reported-by: Michael Zintakis <michael.zintakis@googlemail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_acct.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 589d686..dc3fd5d 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -49,6 +49,8 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 		return -EINVAL;
 
 	acct_name = nla_data(tb[NFACCT_NAME]);
+	if (strlen(acct_name) == 0)
+		return -EINVAL;
 
 	list_for_each_entry(nfacct, &nfnl_acct_list, head) {
 		if (strncmp(nfacct->name, acct_name, NFACCT_NAME_MAX) != 0)
-- 
1.7.10.4

