From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 2/2] fix CLUSTERIP rule deletion in iptables
Date: Sun, 06 Mar 2005 23:41:56 +0100
Message-ID: <422B8734.9040404@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000204060108050103010306"
Cc: Harald Welte <laforge@netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000204060108050103010306
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This fixes rule deletion in CLUSTERIP in iptables.

--
Pablo

--------------000204060108050103010306
Content-Type: text/x-patch;
 name="fix-cluster-del.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-cluster-del.patch"

Index: include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_CLUSTERIP.h	(revision 0)
+++ include/linux/netfilter_ipv4/ipt_CLUSTERIP.h	(revision 0)
@@ -0,0 +1,37 @@
+#ifndef _IPT_CLUSTERIP_H_target
+#define _IPT_CLUSTERIP_H_target
+
+enum clusterip_hashmode {
+    CLUSTERIP_HASHMODE_SIP = 0,
+    CLUSTERIP_HASHMODE_SIP_SPT,
+    CLUSTERIP_HASHMODE_SIP_SPT_DPT,
+};
+
+#define CLUSTERIP_HASHMODE_MAX CLUSTERIP_HASHMODE_SIP_SPT_DPT
+
+#define CLUSTERIP_MAX_NODES 16
+
+#define CLUSTERIP_FLAG_NEW 0x00000001
+
+struct clusterip_config;
+
+struct ipt_clusterip_tgt_info {
+
+	u_int32_t flags;
+	
+	/* only relevant for new ones */
+	u_int8_t clustermac[6];
+	u_int16_t num_total_nodes;
+	u_int16_t num_local_nodes;
+	u_int16_t local_nodes[CLUSTERIP_MAX_NODES];
+	enum clusterip_hashmode hash_mode;
+	u_int32_t hash_initval;
+	
+#ifdef KERNEL_64_USERSPACE_32
+	u_int64_t config;
+#else
+	struct clusterip_config *config;
+#endif
+};
+
+#endif /*_IPT_CLUSTERIP_H_target*/
Index: extensions/libipt_CLUSTERIP.c
===================================================================
--- extensions/libipt_CLUSTERIP.c	(revision 3742)
+++ extensions/libipt_CLUSTERIP.c	(working copy)
@@ -7,6 +7,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
+#include <stddef.h>
 
 #if defined(__GLIBC__) && __GLIBC__ == 2
 #include <net/ethernet.h>
@@ -16,7 +17,7 @@
 
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
+#include "../include/linux/netfilter_ipv4/ipt_CLUSTERIP.h"
 
 static void
 help(void)
@@ -242,7 +243,7 @@
 	.name		= "CLUSTERIP",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_clusterip_tgt_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_clusterip_tgt_info)),
+	.userspacesize	= offsetof(struct ipt_clusterip_tgt_info, config),
  	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,

--------------000204060108050103010306--
