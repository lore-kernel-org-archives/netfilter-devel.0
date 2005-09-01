From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 9/10] add nf_conntrack support to helper match
Date: Thu, 01 Sep 2005 18:15:05 +0900 (JST)
Message-ID: <200509010915.j819F5Ib006672@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_18_15_05_2005_543)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Thu_Sep__1_18_15_05_2005_543)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_18_15_05_2005_543)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="09-helper.patch"

[NETFILTER] add nf_conntrack support to helper match

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 753286b105158ef80e495f76201201834e62d843
tree be1555daa0b35b9c25ff3203f2790b1faed32287
parent 8d35d09bcdd82a8defa817d866f4f6c5096605b8
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 04:01:11 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 04:01:11 +0900

 net/ipv4/netfilter/Kconfig      |    3 +-
 net/ipv4/netfilter/ipt_helper.c |   54 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -273,7 +273,8 @@ config IP_NF_MATCH_TCPMSS
 
 config IP_NF_MATCH_HELPER
 	tristate "Helper match support"
-	depends on IP_NF_CONNTRACK && IP_NF_IPTABLES
+	depends on IP_NF_IPTABLES
+	depends on IP_NF_CONNTRACK || NF_CONNTRACK_IPV4
 	help
 	  Helper matching allows you to match packets in dynamic connections
 	  tracked by a conntrack-helper, ie. ip_conntrack_ftp
diff --git a/net/ipv4/netfilter/ipt_helper.c b/net/ipv4/netfilter/ipt_helper.c
--- a/net/ipv4/netfilter/ipt_helper.c
+++ b/net/ipv4/netfilter/ipt_helper.c
@@ -13,9 +13,15 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#else
+#include <linux/netfilter/nf_conntrack.h>
+#include <linux/netfilter/nf_conntrack_core.h>
+#include <linux/netfilter/nf_conntrack_helper.h>
+#endif
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_helper.h>
 
@@ -29,6 +35,7 @@ MODULE_DESCRIPTION("iptables helper matc
 #define DEBUGP(format, args...)
 #endif
 
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -73,6 +80,53 @@ out_unlock:
 	return ret;
 }
 
+#else /* CONFIG_IP_NF_CONNTRACK */
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct ipt_helper_info *info = matchinfo;
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	int ret = info->invert;
+	
+	ct = nf_ct_get((struct sk_buff *)skb, &ctinfo);
+	if (!ct) {
+		DEBUGP("ipt_helper: Eek! invalid conntrack?\n");
+		return ret;
+	}
+
+	if (!ct->master) {
+		DEBUGP("ipt_helper: conntrack %p has no master\n", ct);
+		return ret;
+	}
+
+	read_lock_bh(&nf_conntrack_lock);
+	if (!ct->master->helper) {
+		DEBUGP("ipt_helper: master ct %p has no helper\n", 
+			exp->expectant);
+		goto out_unlock;
+	}
+
+	DEBUGP("master's name = %s , info->name = %s\n", 
+		ct->master->helper->name, info->name);
+
+	if (info->name[0] == '\0')
+		ret ^= 1;
+	else
+		ret ^= !strncmp(ct->master->helper->name, info->name, 
+		                strlen(ct->master->helper->name));
+out_unlock:
+	read_unlock_bh(&nf_conntrack_lock);
+	return ret;
+}
+#endif
+
 static int check(const char *tablename,
 		 const struct ipt_ip *ip,
 		 void *matchinfo,

----Next_Part(Thu_Sep__1_18_15_05_2005_543)----
