From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/15] netfilter: nf_conntrack: Increase __IPS_MAX_BIT with new bit IPS_OFFLOAD_BIT
Date: Mon, 11 Jun 2018 11:22:31 +0200
Message-ID: <20180611092233.3219-14-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <gfree.wind@vip.163.com>

The __IPS_MAX_BIT is used in __ctnetlink_change_status as the max bit
value. When add new bit IPS_OFFLOAD_BIT whose value is 14, we should
increase the __IPS_MAX_BIT too, from 14 to 15.

There is no any bug in current codes, although it lost one loop in
__ctnetlink_change_status. Because the new bit IPS_OFFLOAD_BIT belongs
the IPS_UNCHANGEABLE_MASK.

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index c712eb6879f1..336014bf8868 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -112,7 +112,7 @@ enum ip_conntrack_status {
 				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING |
 				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_OFFLOAD),
 
-	__IPS_MAX_BIT = 14,
+	__IPS_MAX_BIT = 15,
 };
 
 /* Connection tracking event types */
-- 
2.11.0
