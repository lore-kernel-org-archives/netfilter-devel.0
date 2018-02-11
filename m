From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: nfnetlink_acct: remove useless parameter
Date: Sun, 11 Feb 2018 19:17:20 +0900
Message-ID: <20180211101720.20348-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:40300 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752288AbeBKKR2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Feb 2018 05:17:28 -0500
Received: by mail-pg0-f66.google.com with SMTP id g2so5776686pgn.7
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Feb 2018 02:17:28 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parameter skb in nfnl_acct_overquota is not used anywhere.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/linux/netfilter/nfnetlink_acct.h | 3 +--
 net/netfilter/nfnetlink_acct.c           | 3 +--
 net/netfilter/xt_nfacct.c                | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index b4d7411..beee8bf 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -16,6 +16,5 @@ struct nf_acct;
 struct nf_acct *nfnl_acct_find_get(struct net *net, const char *filter_name);
 void nfnl_acct_put(struct nf_acct *acct);
 void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
-int nfnl_acct_overquota(struct net *net, const struct sk_buff *skb,
-			struct nf_acct *nfacct);
+int nfnl_acct_overquota(struct net *net, struct nf_acct *nfacct);
 #endif /* _NFNL_ACCT_H */
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 88d427f..b9505bc 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -467,8 +467,7 @@ static void nfnl_overquota_report(struct net *net, struct nf_acct *nfacct)
 			  GFP_ATOMIC);
 }
 
-int nfnl_acct_overquota(struct net *net, const struct sk_buff *skb,
-			struct nf_acct *nfacct)
+int nfnl_acct_overquota(struct net *net, struct nf_acct *nfacct)
 {
 	u64 now;
 	u64 *quota;
diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index cc0518f..9c2719c 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -26,7 +26,7 @@ static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	nfnl_acct_update(skb, info->nfacct);
 
-	overquota = nfnl_acct_overquota(xt_net(par), skb, info->nfacct);
+	overquota = nfnl_acct_overquota(xt_net(par), info->nfacct);
 
 	return overquota == NFACCT_UNDERQUOTA ? false : true;
 }
-- 
2.9.3

