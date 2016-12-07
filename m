From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/50] netfilter: nfnetlink_log: add "nf-logger-5-1" module alias name
Date: Wed,  7 Dec 2016 22:52:14 +0100
Message-ID: <1481147576-5690-9-git-send-email-pablo@netfilter.org>
References: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <zlpnobody@gmail.com>

So we can autoload nfnetlink_log.ko when the user adding nft log
group X rule in netdev family.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 763cb4d54e8d..200922bb2036 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1152,6 +1152,7 @@ MODULE_ALIAS_NF_LOGGER(AF_INET, 1);
 MODULE_ALIAS_NF_LOGGER(AF_INET6, 1);
 MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 1);
 MODULE_ALIAS_NF_LOGGER(3, 1); /* NFPROTO_ARP */
+MODULE_ALIAS_NF_LOGGER(5, 1); /* NFPROTO_NETDEV */
 
 module_init(nfnetlink_log_init);
 module_exit(nfnetlink_log_fini);
-- 
2.1.4
