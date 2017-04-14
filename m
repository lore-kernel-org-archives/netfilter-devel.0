From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 9/9] netfilter: ipt_CLUSTERIP: Fix wrong conntrack netns refcnt usage
Date: Fri, 14 Apr 2017 02:26:51 +0200
Message-ID: <1492129611-29336-10-git-send-email-pablo@netfilter.org>
References: <1492129611-29336-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754319AbdDNA1O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 20:27:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 57605E043A
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 02:27:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49204DA80B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 02:27:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C23ADA80B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 02:27:08 +0200 (CEST)
In-Reply-To: <1492129611-29336-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Current codes invoke wrongly nf_ct_netns_get in the destroy routine,
it should use nf_ct_netns_put, not nf_ct_netns_get.
It could cause some modules could not be unloaded.

Fixes: ecb2421b5ddf ("netfilter: add and use nf_ct_netns_get/put")
Signed-off-by: Gao Feng <fgao@ikuai8.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 52f26459efc3..9b8841316e7b 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -461,7 +461,7 @@ static void clusterip_tg_destroy(const struct xt_tgdtor_param *par)
 
 	clusterip_config_put(cipinfo->config);
 
-	nf_ct_netns_get(par->net, par->family);
+	nf_ct_netns_put(par->net, par->family);
 }
 
 #ifdef CONFIG_COMPAT
-- 
2.1.4

