From: Felix Fietkau <nbd@nbd.name>
Subject: [RFC 1/9] netfilter: nf_flow_table: use IP_CT_DIR_* values for FLOW_OFFLOAD_DIR_*
Date: Sat, 17 Feb 2018 12:11:58 +0100
Message-ID: <20180217111206.37312-1-nbd@nbd.name>
Cc: pablo@netfilter.org, nbd@nbd.name
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54302 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751111AbeBQLMN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Feb 2018 06:12:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Simplifies further code cleanups

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/netfilter/nf_flow_table.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f44e93ff512a..9e7c222a38de 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -6,6 +6,7 @@
 #include <linux/netdevice.h>
 #include <linux/rhashtable.h>
 #include <linux/rcupdate.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <net/dst.h>
 
 struct nf_flowtable;
@@ -34,11 +35,10 @@ struct nf_flowtable {
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
2.14.2

