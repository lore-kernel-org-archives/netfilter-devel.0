From: fgao@ikuai8.com
Subject: [PATCH nf-next 2/2] netfilter: nf_tables: Make sure the uniform style of condition blocks in nf_tables_newrule
Date: Thu, 29 Dec 2016 11:39:58 +0800
Message-ID: <1482982798-24914-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG132.QQ.COM ([113.108.23.42]:56884 "EHLO smtpbg132.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752155AbcL2Dr7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Dec 2016 22:47:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There is one different brace style of condtion blocks in
nf_tables_newrule. Now just make it uniform.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ecc516c..7ac2b2e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2261,12 +2261,12 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 			err = -ENOENT;
 			goto err2;
 		}
-	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
+	} else if (nlh->nlmsg_flags & NLM_F_APPEND) {
 		if (old_rule)
 			list_add_rcu(&rule->list, &old_rule->list);
 		else
 			list_add_tail_rcu(&rule->list, &chain->rules);
-	else {
+	} else {
 		if (old_rule)
 			list_add_tail_rcu(&rule->list, &old_rule->list);
 		else
-- 
1.9.1


