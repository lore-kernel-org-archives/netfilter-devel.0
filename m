From: gfree.wind@foxmail.com
Subject: [PATCH nf 1/1] netfilter: CLUSTERIP: Fix one wrong refcnt usage
Date: Thu,  6 Apr 2017 09:45:22 +0800
Message-ID: <1491443122-107940-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgsg2.qq.com ([54.254.200.128]:48266 "EHLO smtpbgsg2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756315AbdDFBpb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Apr 2017 21:45:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Current codes invoke wrongly nf_ct_netns_get in the destroy routine,
it should use nf_ct_netns_put, not nf_ct_netns_get.
It could cause some modules could not be unloaded.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 52f2645..9b88413 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -461,7 +461,7 @@ static void clusterip_tg_destroy(const struct xt_tgdtor_param *par)
 
 	clusterip_config_put(cipinfo->config);
 
-	nf_ct_netns_get(par->net, par->family);
+	nf_ct_netns_put(par->net, par->family);
 }
 
 #ifdef CONFIG_COMPAT
-- 
1.9.1




