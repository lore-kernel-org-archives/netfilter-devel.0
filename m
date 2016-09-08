From: fgao@ikuai8.com
Subject: [PATCH nf-next] netfilter: xt_TEE: Add the missed return value check in tee_tg_check
Date: Thu,  8 Sep 2016 11:22:56 +0800
Message-ID: <1473304976-9899-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG19.QQ.COM ([183.60.61.236]:59127 "EHLO smtpbg320.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757505AbcIHDa7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 23:30:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The original codes didn't check the return value of function
register_netdevice_notifier.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/xt_TEE.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 6e57a39..0471db4 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -89,6 +89,8 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 
 	if (info->oif[0]) {
+		int ret;
+
 		if (info->oif[sizeof(info->oif)-1] != '\0')
 			return -EINVAL;
 
@@ -101,7 +103,11 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		priv->notifier.notifier_call = tee_netdev_event;
 		info->priv    = priv;
 
-		register_netdevice_notifier(&priv->notifier);
+		ret = register_netdevice_notifier(&priv->notifier);
+		if (ret) {
+			kfree(priv);
+			return ret;
+		}
 	} else
 		info->priv = NULL;
 
-- 
1.9.1


