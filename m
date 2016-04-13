From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] netfilter: arp_tables: register table in initns
Date: Thu, 14 Apr 2016 00:54:52 +0200
Message-ID: <1460588094-3933-2-git-send-email-pablo@netfilter.org>
References: <1460588094-3933-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1460588094-3933-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

arptables is broken since we didn't register the table anymore --
even 'arptables -L' fails.

Fixes: b9e69e127397187b ("netfilter: xtables: don't hook tables by default")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arptable_filter.c | 6 ++++++
 1 file changed, 6 insertions(+)

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
2.1.4
