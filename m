From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] resync ipt_cluster structure
Date: Thu, 05 May 2005 18:20:31 +0200
Message-ID: <427A47CF.8080904@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030202030609080909030909"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------030202030609080909030909
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

Currently ipt_clusterip_tgt_info structure is out of sync with regards 
to iptables snapshot in SVN. This happened because the patch to fix 
deletion was applied to iptables but not the kernel part, so it got lost 
somehow.

The patch attached fixes it, please apply.

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--
Pablo

--------------030202030609080909030909
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h  (mode:100644 sha1:baa83e757156c66d9e34015f554512eadb84f1f1)
+++ uncommitted/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h  (mode:100644)
@@ -18,7 +18,6 @@
 struct ipt_clusterip_tgt_info {
 
 	u_int32_t flags;
-	struct clusterip_config *config;
 	
 	/* only relevant for new ones */
 	u_int8_t clustermac[6];
@@ -27,6 +26,8 @@
 	u_int16_t local_nodes[CLUSTERIP_MAX_NODES];
 	enum clusterip_hashmode hash_mode;
 	u_int32_t hash_initval;
+
+	struct clusterip_config *config;
 };
 
 #endif /*_IPT_CLUSTERIP_H_target*/

--------------030202030609080909030909--
