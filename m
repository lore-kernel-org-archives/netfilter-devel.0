From: fgao@ikuai8.com
Subject: [PATCH nf-next] netfilter: xt_nfacct: Use not operation instead of condition check
Date: Mon, 26 Sep 2016 22:13:04 +0800
Message-ID: <1474899184-30187-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg340.qq.com ([14.17.44.35]:37113 "EHLO smtpbg340.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965676AbcIZOON (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Sep 2016 10:14:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Use not operation instead of condition check to simplify the codes.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/xt_nfacct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index cf32759..7abb5b5 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -28,7 +28,7 @@ static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	overquota = nfnl_acct_overquota(par->net, skb, info->nfacct);
 
-	return overquota == NFACCT_UNDERQUOTA ? false : true;
+	return !(overquota == NFACCT_UNDERQUOTA);
 }
 
 static int
-- 
1.9.1


