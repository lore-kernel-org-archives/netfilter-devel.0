From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 1/2] Modify CLUSTERIP layout
Date: Sun, 06 Mar 2005 23:41:44 +0100
Message-ID: <422B8728.2030703@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040006060702040201020202"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------040006060702040201020202
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This modifies the ipt_clusterip_tgt_info layout in order to fix rule 
deletion, it's the easier way to fix this problem. Since CLUSTERIP is 
marked as experimental and after some discussing we decided to forget 
about backward compatibility this time.

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--
Pablo

--------------040006060702040201020202
Content-Type: text/x-patch;
 name="fix-layout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-layout.patch"

===== include/linux/netfilter_ipv4/ipt_CLUSTERIP.h 1.1 vs edited =====
--- 1.1/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h	2004-10-22 07:34:30 +02:00
+++ edited/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h	2005-03-06 15:48:09 +01:00
@@ -18,7 +18,6 @@
 struct ipt_clusterip_tgt_info {
 
 	u_int32_t flags;
-	struct clusterip_config *config;
 	
 	/* only relevant for new ones */
 	u_int8_t clustermac[6];
@@ -27,6 +26,7 @@
 	u_int16_t local_nodes[CLUSTERIP_MAX_NODES];
 	enum clusterip_hashmode hash_mode;
 	u_int32_t hash_initval;
+	struct clusterip_config *config;
 };
 
 #endif /*_IPT_CLUSTERIP_H_target*/

--------------040006060702040201020202--
