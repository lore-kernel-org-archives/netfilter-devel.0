From: fgao@ikuai8.com
Subject: [PATCH nf-next 1/2] netfilter: nf_tables: Check chain's use count before alloc new handle in nf_tables_newrule
Date: Thu, 29 Dec 2016 11:39:28 +0800
Message-ID: <1482982768-24791-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg278.qq.com ([113.108.11.203]:39833 "EHLO smtpbg278.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752137AbcL2DkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Dec 2016 22:40:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Although current nf_tables_alloc_handle doesn't allocate any actual
resource, but it should check invalid condition before allocation in
logic.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a019a87..ecc516c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2175,10 +2175,10 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	} else {
 		if (!create || nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EINVAL;
-		handle = nf_tables_alloc_handle(table);
-
 		if (chain->use == UINT_MAX)
 			return -EOVERFLOW;
+
+		handle = nf_tables_alloc_handle(table);
 	}
 
 	if (nla[NFTA_RULE_POSITION]) {
-- 
1.9.1


