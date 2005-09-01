From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 5/10] add nf_conntrack support to NOTRACK target
Date: Thu, 01 Sep 2005 18:14:31 +0900 (JST)
Message-ID: <200509010914.j819EWVd005839@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_18_14_31_2005_819)--"
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

----Next_Part(Thu_Sep__1_18_14_31_2005_819)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_18_14_31_2005_819)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="05-NOTRACK.patch"

[NETFILTER] add nf_conntrack support to NOTRACK target

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 873123d0c0b5e410dcda66d477d4211e0c5c349c
tree d0da27495b066282eeeafdf3e4c77ffdc5f86aa3
parent 0bf0296d190d233c34ea5f9f587f2907fbde2786
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:30:24 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:30:24 +0900

 net/ipv4/netfilter/Kconfig       |    2 +-
 net/ipv4/netfilter/ipt_NOTRACK.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -717,7 +717,7 @@ config IP_NF_RAW
 config IP_NF_TARGET_NOTRACK
 	tristate  'NOTRACK target support'
 	depends on IP_NF_RAW
-	depends on IP_NF_CONNTRACK
+	depends on IP_NF_CONNTRACK || NF_CONNTRACK_IPV4
 	help
 	  The NOTRACK target allows a select rule to specify
 	  which packets *not* to enter the conntrack/NAT
diff --git a/net/ipv4/netfilter/ipt_NOTRACK.c b/net/ipv4/netfilter/ipt_NOTRACK.c
--- a/net/ipv4/netfilter/ipt_NOTRACK.c
+++ b/net/ipv4/netfilter/ipt_NOTRACK.c
@@ -5,7 +5,7 @@
 #include <linux/skbuff.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack_compat.h>
 
 static unsigned int
 target(struct sk_buff **pskb,
@@ -23,7 +23,7 @@ target(struct sk_buff **pskb,
 	   If there is a real ct entry correspondig to this packet, 
 	   it'll hang aroun till timing out. We don't deal with it
 	   for performance reasons. JK */
-	(*pskb)->nfct = &ip_conntrack_untracked.ct_general;
+	nf_ct_untrack(*pskb);
 	(*pskb)->nfctinfo = IP_CT_NEW;
 	nf_conntrack_get((*pskb)->nfct);
 

----Next_Part(Thu_Sep__1_18_14_31_2005_819)----
