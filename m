From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 1/2] add nf_conntrack support to CLUSTERIP
 target
Date: Fri, 07 Oct 2005 03:12:46 +0900 (JST)
Message-ID: <200510061812.j96IClBc017642@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Oct__7_03_12_46_2005_804)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
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

----Next_Part(Fri_Oct__7_03_12_46_2005_804)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Harald,

fixing CLUSTERIP seems to be finished, so I send this patch.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Fri_Oct__7_03_12_46_2005_804)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-CLUSTERIP.patch"

[NETFILTER] add nf_conntrack support to CLUSTERIP target

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit d90304323a89c317ad5b7bd2d30b159cd4212406
tree 88b39fceaf466cd23c4e1896715d0f58424b7278
parent 9d054986e98daee568661fbd265294659f62a4cb
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 05 Oct 2005 23:08:34 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 05 Oct 2005 23:08:34 +0900

 net/ipv4/netfilter/Kconfig         |    3 ++-
 net/ipv4/netfilter/ipt_CLUSTERIP.c |   12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -763,7 +763,8 @@ config IP_NF_TARGET_CONNMARK
 
 config IP_NF_TARGET_CLUSTERIP
 	tristate "CLUSTERIP target support (EXPERIMENTAL)"
-	depends on IP_NF_CONNTRACK_MARK && IP_NF_IPTABLES && EXPERIMENTAL
+	depends on IP_NF_IPTABLES && EXPERIMENTAL
+	depends on IP_NF_CONNTRACK_MARK || (NF_CONNTRACK_MARK && NF_CONNTRACK_IPV4)
 	help
 	  The CLUSTERIP target allows you to build load-balancing clusters of
 	  network servers without having a dedicated load-balancing
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -29,7 +29,7 @@
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack_compat.h>
 
 #define CLUSTERIP_VERSION "0.8"
 
@@ -316,14 +316,14 @@ target(struct sk_buff **pskb,
 {
 	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 	enum ip_conntrack_info ctinfo;
-	struct ip_conntrack *ct = ip_conntrack_get((*pskb), &ctinfo);
-	u_int32_t hash;
+	u_int32_t *mark, hash;
 
 	/* don't need to clusterip_config_get() here, since refcount
 	 * is only decremented by destroy() - and ip_tables guarantees
 	 * that the ->target() function isn't called after ->destroy() */
 
-	if (!ct) {
+	mark = nf_ct_get_mark((*pskb), &ctinfo);
+	if (mark == NULL) {
 		printk(KERN_ERR "CLUSTERIP: no conntrack!\n");
 			/* FIXME: need to drop invalid ones, since replies
 			 * to outgoing connections of other nodes will be 
@@ -346,7 +346,7 @@ target(struct sk_buff **pskb,
 
 	switch (ctinfo) {
 		case IP_CT_NEW:
-			ct->mark = hash;
+			*mark = hash;
 			break;
 		case IP_CT_RELATED:
 		case IP_CT_RELATED+IP_CT_IS_REPLY:
@@ -363,7 +363,7 @@ target(struct sk_buff **pskb,
 #ifdef DEBUG_CLUSTERP
 	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 #endif
-	DEBUGP("hash=%u ct_hash=%u ", hash, ct->mark);
+	DEBUGP("hash=%u ct_hash=%u ", hash, *mark);
 	if (!clusterip_responsible(cipinfo->config, hash)) {
 		DEBUGP("not responsible\n");
 		return NF_DROP;

----Next_Part(Fri_Oct__7_03_12_46_2005_804)----
