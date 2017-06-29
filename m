From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/29] netfilter: dup: resolve warnings about missing prototypes
Date: Fri, 30 Jun 2017 00:53:01 +0200
Message-ID: <1498776807-11124-4-git-send-email-pablo@netfilter.org>
References: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: stephen hemminger <stephen@networkplumber.org>

Missing include file causes:

net/netfilter/nf_dup_netdev.c:26:6: warning: no previous prototype for ‘nf_fwd_netdev_egress’ [-Wmissing-prototypes]
net/netfilter/nf_dup_netdev.c:40:6: warning: no previous prototype for ‘nf_dup_netdev_egress’ [-Wmissing-prototypes]

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_dup_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index c9d7f95768ab..f4a566e67213 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,6 +13,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_dup_netdev.h>
 
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
 {
-- 
2.1.4
