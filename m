From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/51] netfilter: nf_flow_table: use IP_CT_DIR_* values for FLOW_OFFLOAD_DIR_*
Date: Mon,  7 May 2018 00:46:25 +0200
Message-ID: <20180506224709.29100-8-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Simplifies further code cleanups

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 833752dd0c58..09ba67598991 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -6,6 +6,7 @@
 #include <linux/netdevice.h>
 #include <linux/rhashtable.h>
 #include <linux/rcupdate.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <net/dst.h>
 
 struct nf_flowtable;
@@ -27,11 +28,10 @@ struct nf_flowtable {
 };
 
 enum flow_offload_tuple_dir {
-	FLOW_OFFLOAD_DIR_ORIGINAL,
-	FLOW_OFFLOAD_DIR_REPLY,
-	__FLOW_OFFLOAD_DIR_MAX		= FLOW_OFFLOAD_DIR_REPLY,
+	FLOW_OFFLOAD_DIR_ORIGINAL = IP_CT_DIR_ORIGINAL,
+	FLOW_OFFLOAD_DIR_REPLY = IP_CT_DIR_REPLY,
+	FLOW_OFFLOAD_DIR_MAX = IP_CT_DIR_MAX
 };
-#define FLOW_OFFLOAD_DIR_MAX	(__FLOW_OFFLOAD_DIR_MAX + 1)
 
 struct flow_offload_tuple {
 	union {
-- 
2.11.0
