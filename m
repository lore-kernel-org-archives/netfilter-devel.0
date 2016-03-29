From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: arp_tables: register table in initns
Date: Tue, 29 Mar 2016 11:05:16 +0200
Message-ID: <1459242316-8100-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42233 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbcC2JFC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2016 05:05:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

arptables is broken since we didn't register the table anymore --
even 'arptables -L' fails.

Fixes: b9e69e127397187b ("netfilter: xtables: don't hook tables by default")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Broken commit is in v4.6-rc1, 4.5 isn't affected.

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index dd8c80d..8f8713b 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -81,6 +81,12 @@ static int __init arptable_filter_init(void)
 		return ret;
 	}
 
+	ret = arptable_filter_table_init(&init_net);
+	if (ret) {
+		unregister_pernet_subsys(&arptable_filter_net_ops);
+		kfree(arpfilter_ops);
+	}
+
 	return ret;
 }
 
-- 
2.4.10

