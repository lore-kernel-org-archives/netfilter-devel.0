From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 8/10] add nf_conntrack support to state match
Date: Thu, 01 Sep 2005 18:14:56 +0900 (JST)
Message-ID: <200509010914.j819EvCx006467@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_18_14_56_2005_616)--"
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

----Next_Part(Thu_Sep__1_18_14_56_2005_616)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_18_14_56_2005_616)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="08-state.patch"

[NETFILTER] add nf_conntrack support to state match

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 8d35d09bcdd82a8defa817d866f4f6c5096605b8
tree 7bd253b7452ed82be2ede1927c9568a805d9e100
parent e3e0b34c418c128d99367766950e1fb5f771ea33
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:31:48 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:31:48 +0900

 net/ipv4/netfilter/Kconfig     |    3 ++-
 net/ipv4/netfilter/ipt_state.c |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -282,7 +282,8 @@ config IP_NF_MATCH_HELPER
 
 config IP_NF_MATCH_STATE
 	tristate "Connection state match support"
-	depends on IP_NF_CONNTRACK && IP_NF_IPTABLES
+	depends on IP_NF_IPTABLES
+	depends on IP_NF_CONNTRACK || NF_CONNTRACK_IPV4
 	help
 	  Connection state matching allows you to match packets based on their
 	  relationship to a tracked connection (ie. previous packets).  This
diff --git a/net/ipv4/netfilter/ipt_state.c b/net/ipv4/netfilter/ipt_state.c
--- a/net/ipv4/netfilter/ipt_state.c
+++ b/net/ipv4/netfilter/ipt_state.c
@@ -10,7 +10,7 @@
 
 #include <linux/module.h>
 #include <linux/skbuff.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack_compat.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_state.h>
 
@@ -30,9 +30,9 @@ match(const struct sk_buff *skb,
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
-	if (skb->nfct == &ip_conntrack_untracked.ct_general)
+	if (nf_ct_is_untracked(skb))
 		statebit = IPT_STATE_UNTRACKED;
-	else if (!ip_conntrack_get(skb, &ctinfo))
+	else if (!nf_ct_get_ctinfo(skb, &ctinfo))
 		statebit = IPT_STATE_INVALID;
 	else
 		statebit = IPT_STATE_BIT(ctinfo);

----Next_Part(Thu_Sep__1_18_14_56_2005_616)----
