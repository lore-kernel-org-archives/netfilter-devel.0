From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 4/10] add nf_conntrack support to CONNMARK
 target
Date: Thu, 01 Sep 2005 18:14:24 +0900 (JST)
Message-ID: <200509010914.j819EP42005678@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_18_14_24_2005_310)--"
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

----Next_Part(Thu_Sep__1_18_14_24_2005_310)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_18_14_24_2005_310)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="04-CONNMARK.patch"

[NETFILTER] add nf_conntrack support to CONNMARK target

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 0bf0296d190d233c34ea5f9f587f2907fbde2786
tree 54b5eda5e996a6144520cfb0de1014fc1f9a5d27
parent 2ca0aa6572fa17a994195213a2e8b23921fbf889
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:29:28 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:29:28 +0900

 net/ipv4/netfilter/Kconfig        |    3 ++-
 net/ipv4/netfilter/ipt_CONNMARK.c |   22 +++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -681,7 +681,8 @@ config IP_NF_TARGET_TTL
 
 config IP_NF_TARGET_CONNMARK
 	tristate  'CONNMARK target support'
-	depends on IP_NF_CONNTRACK_MARK && IP_NF_MANGLE
+	depends on IP_NF_MANGLE
+	depends on IP_NF_CONNTRACK_MARK || (NF_CONNTRACK_MARK && NF_CONNTRACK_IPV4)
 	help
 	  This option adds a `CONNMARK' target, which allows one to manipulate
 	  the connection mark value.  Similar to the MARK target, but
diff --git a/net/ipv4/netfilter/ipt_CONNMARK.c b/net/ipv4/netfilter/ipt_CONNMARK.c
--- a/net/ipv4/netfilter/ipt_CONNMARK.c
+++ b/net/ipv4/netfilter/ipt_CONNMARK.c
@@ -29,7 +29,7 @@ MODULE_LICENSE("GPL");
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CONNMARK.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack_compat.h>
 
 static unsigned int
 target(struct sk_buff **pskb,
@@ -43,24 +43,24 @@ target(struct sk_buff **pskb,
 	u_int32_t diff;
 	u_int32_t nfmark;
 	u_int32_t newmark;
+	u_int32_t ctinfo;
+	u_int32_t *ctmark = nf_ct_get_mark(*pskb, &ctinfo);
 
-	enum ip_conntrack_info ctinfo;
-	struct ip_conntrack *ct = ip_conntrack_get((*pskb), &ctinfo);
-	if (ct) {
+	if (ctmark) {
 	    switch(markinfo->mode) {
 	    case IPT_CONNMARK_SET:
-		newmark = (ct->mark & ~markinfo->mask) | markinfo->mark;
-		if (newmark != ct->mark)
-		    ct->mark = newmark;
+		newmark = (*ctmark & ~markinfo->mask) | markinfo->mark;
+		if (newmark != *ctmark)
+		    *ctmark = newmark;
 		break;
 	    case IPT_CONNMARK_SAVE:
-		newmark = (ct->mark & ~markinfo->mask) | ((*pskb)->nfmark & markinfo->mask);
-		if (ct->mark != newmark)
-		    ct->mark = newmark;
+		newmark = (*ctmark & ~markinfo->mask) | ((*pskb)->nfmark & markinfo->mask);
+		if (*ctmark != newmark)
+		    *ctmark = newmark;
 		break;
 	    case IPT_CONNMARK_RESTORE:
 		nfmark = (*pskb)->nfmark;
-		diff = (ct->mark ^ nfmark) & markinfo->mask;
+		diff = (*ctmark ^ nfmark) & markinfo->mask;
 		if (diff != 0)
 		    (*pskb)->nfmark = nfmark ^ diff;
 		break;

----Next_Part(Thu_Sep__1_18_14_24_2005_310)----
