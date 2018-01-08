From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/52] netfilter: ipset: use nfnl_mutex_is_locked
Date: Mon,  8 Jan 2018 21:19:15 +0100
Message-ID: <20180108202000.12989-8-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42502 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753901AbeAHUUR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 15:20:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B0E7E7B84
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 21:20:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0181202A8
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2018 21:20:15 +0100 (CET)
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Check that we really hold nfnl mutex here instead of relying on correct
usage alone.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index d5a43cad90f0..1f3c03b3bebf 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -57,7 +57,7 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
 
 /* When the nfnl mutex is held: */
 #define ip_set_dereference(p)		\
-	rcu_dereference_protected(p, 1)
+	rcu_dereference_protected(p, lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
 #define ip_set(inst, id)		\
 	ip_set_dereference((inst)->ip_set_list)[id]
 
-- 
2.11.0

