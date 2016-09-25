From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/53] netfilter: nf_conntrack: remove unused ctl_table_path member in nf_conntrack_l3proto
Date: Mon, 26 Sep 2016 01:06:22 +0200
Message-ID: <1474844823-2026-13-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54532 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941207AbcIYXHc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 19:07:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2FD0BC0B2A
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20AF2DA818
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FDD7DA7F7
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:29 +0200 (CEST)
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After commit adf0516845bc ("netfilter: remove ip_conntrack* sysctl
compat code"), ctl_table_path member in struct nf_conntrack_l3proto{}
is not used anymore, remove it.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l3proto.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index cdc920b4c4c2..8992e4229da9 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -63,10 +63,6 @@ struct nf_conntrack_l3proto {
 
 	size_t nla_size;
 
-#ifdef CONFIG_SYSCTL
-	const char		*ctl_table_path;
-#endif /* CONFIG_SYSCTL */
-
 	/* Init l3proto pernet data */
 	int (*init_net)(struct net *net);
 
-- 
2.1.4

