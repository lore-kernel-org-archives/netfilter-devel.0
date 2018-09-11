From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/12] netfilter: conntrack: remove duplicated include from nf_conntrack_proto_udp.c
Date: Tue, 11 Sep 2018 02:20:33 +0200
Message-ID: <20180911002044.9100-2-pablo@netfilter.org>
References: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911002044.9100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yue Haibing <yuehaibing@huawei.com>

Remove duplicated include.

Fixes: c779e849608a ("netfilter: conntrack: remove get_timeout() indirection")
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_udp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 7a1b8988a931..9272a2c525a8 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -393,4 +393,3 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 =
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udplite6);
 #endif
-#include <net/netfilter/nf_conntrack_timeout.h>
-- 
2.11.0
