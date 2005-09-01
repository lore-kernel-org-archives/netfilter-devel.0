From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 7/10] add nf_conntrack support to connmark match
Date: Thu, 01 Sep 2005 18:14:48 +0900 (JST)
Message-ID: <200509010914.j819En6G006020@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_18_14_48_2005_009)--"
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

----Next_Part(Thu_Sep__1_18_14_48_2005_009)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_18_14_48_2005_009)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="07-connmark.patch"

[NETFILTER] add nf_conntrack support to connmark match

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit e3e0b34c418c128d99367766950e1fb5f771ea33
tree 5a4548cc415d256dac5fb7b7b2128c0d190a4410
parent 3476e266ba733aa5214ac79977fc64596c80f4c6
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:31:18 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:31:18 +0900

 net/ipv4/netfilter/Kconfig        |    3 ++-
 net/ipv4/netfilter/ipt_connmark.c |   10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -378,7 +378,8 @@ config IP_NF_MATCH_COMMENT
 
 config IP_NF_MATCH_CONNMARK
 	tristate  'Connection mark match support'
-	depends on IP_NF_CONNTRACK_MARK && IP_NF_IPTABLES
+	depends on IP_NF_IPTABLES
+	depends on IP_NF_CONNTRACK_MARK || (NF_CONNTRACK_MARK && NF_CONNTRACK_IPV4)
 	help
 	  This option adds a `connmark' match, which allows you to match the
 	  connection mark value previously set for the session by `CONNMARK'. 
diff --git a/net/ipv4/netfilter/ipt_connmark.c b/net/ipv4/netfilter/ipt_connmark.c
--- a/net/ipv4/netfilter/ipt_connmark.c
+++ b/net/ipv4/netfilter/ipt_connmark.c
@@ -28,7 +28,7 @@ MODULE_LICENSE("GPL");
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_connmark.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack_compat.h>
 
 static int
 match(const struct sk_buff *skb,
@@ -39,12 +39,12 @@ match(const struct sk_buff *skb,
       int *hotdrop)
 {
 	const struct ipt_connmark_info *info = matchinfo;
-	enum ip_conntrack_info ctinfo;
-	struct ip_conntrack *ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
-	if (!ct)
+	u_int32_t ctinfo;
+	const u_int32_t *ctmark = nf_ct_get_mark(skb, &ctinfo);
+	if (!ctmark)
 		return 0;
 
-	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
+	return (((*ctmark) & info->mask) == info->mark) ^ info->invert;
 }
 
 static int

----Next_Part(Thu_Sep__1_18_14_48_2005_009)----
