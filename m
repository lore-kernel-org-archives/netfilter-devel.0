From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/32] netfilter: core: make local function __nf_unregister_net_hook static
Date: Fri, 19 Jan 2018 20:10:19 +0100
Message-ID: <20180119191041.25804-11-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45194 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756227AbeASTLC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:11:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 722AF2EFEB9
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55167DA381
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:00 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

net/netfilter/core.c:380:6: warning:
 symbol '__nf_unregister_net_hook' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 997dd387d259..3f8e2d06b9cc 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -377,8 +377,8 @@ static void nf_remove_net_hook(struct nf_hook_entries *old,
 	}
 }
 
-void __nf_unregister_net_hook(struct net *net, int pf,
-			      const struct nf_hook_ops *reg)
+static void __nf_unregister_net_hook(struct net *net, int pf,
+				     const struct nf_hook_ops *reg)
 {
 	struct nf_hook_entries __rcu **pp;
 	struct nf_hook_entries *p;
-- 
2.11.0

