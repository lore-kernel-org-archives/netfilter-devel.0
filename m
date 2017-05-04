From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH] netfilter: nf_tables: Return info of added rules back to user space
Date: Thu,  4 May 2017 14:34:17 +0200
Message-ID: <20170504123417.22088-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:56099 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750936AbdEDMea (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 08:34:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows user space to reliably match kernel generated handles with
added rules for reference.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1c6482d2c4dcf..71bce5d024409 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2142,6 +2142,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	struct nft_userdata *udata;
 	struct nft_trans *trans = NULL;
 	struct nft_expr *expr;
+	struct sk_buff *skb2;
 	struct nft_ctx ctx;
 	struct nlattr *tmp;
 	unsigned int size, i, n, ulen = 0, usize = 0;
@@ -2281,8 +2282,24 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		goto err3;
 	}
 	chain->use++;
-	return 0;
 
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb2) {
+		err = -ENOMEM;
+		goto err4;
+	}
+	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
+				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
+				       nfmsg->nfgen_family, table, chain, rule);
+	if (err < 0)
+		goto err5;
+
+	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+
+err5:
+	kfree_skb(skb2);
+err4:
+	chain->use--;
 err3:
 	list_del_rcu(&rule->list);
 err2:
-- 
2.11.0

