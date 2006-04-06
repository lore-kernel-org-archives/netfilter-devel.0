From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/12]: H.323 helper: update Changelog
Date: Thu,  6 Apr 2006 12:05:04 +0200 (MEST)
Message-ID: <20060406100504.17409.80683.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
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

[NETFILTER]: H.323 helper: update Changelog

Signed-off-by: Jing Min Zhao <zhaojingmin@users.sourceforge.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4c164120eecc4d67e0eb6392bbb9f81351c18387
tree 9e710e2bce7e141f181daf1a61be3a989f57f653
parent 58e6febec3e259470b331d97cfe085242d2421c5
author Jing Min Zhao <zhaojingmin@users.sourceforge.net> Thu, 06 Apr 2006 11:43:21 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:43:21 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |   15 +++++++++++++++
 net/ipv4/netfilter/ip_nat_helper_h323.c       |    5 +++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index dccc6c3..5221685 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -40,6 +40,21 @@
  * 	  4. Sort ASN.1 data to avoid forwarding declarations (suggested by
  * 	     Patrick McHardy)
  * 	  5. Reset next TPKT data length in get_tpkt_data()
+ *
+ * 	2006-03-20 - version 0.5
+ * 	  1. Change gkrouted_only default to 1 (Patrick McHardy)
+ * 	  2. Remove #ifndef offsetof in ASN.1 parser (Patrick McHardy)
+ * 	  3. Initialize datalen to 0 in ras_help to silence an incorrect gcc
+ * 	     warning (Patrick McHardy)
+ *
+ * 	2006-03-22 - version 0.6
+ * 	  1. get_h225_addr incorrectly defined as 'static' (found by
+ * 	     Andrew Morton)
+ *
+ * 	2006-03-25 - version 0.7
+ * 	  1. Added new parameter 'default_rrq_ttl'.
+ * 	  2. Made get_h245_addr static (suggested by Adrian Bunk)
+ * 	  3. Changed to use EXPORT_SYMBOL_GPL (suggested by Adrian Bunk)
  */
 
 #include <linux/config.h>
diff --git a/net/ipv4/netfilter/ip_nat_helper_h323.c b/net/ipv4/netfilter/ip_nat_helper_h323.c
index 6f19c20..c96f15f 100644
--- a/net/ipv4/netfilter/ip_nat_helper_h323.c
+++ b/net/ipv4/netfilter/ip_nat_helper_h323.c
@@ -25,6 +25,11 @@
  * 	2006-03-15 - version 0.4
  * 	  1. Added support for T.120 channels
  * 	  2. Added parameter gkrouted_only (suggested by Patrick McHardy)
+ *
+ * 	2006-03-25 - version 0.7
+ * 	  1. Made get_h245_addr static (suggested by Adrian Bunk)
+ * 	  2. Move some extern function prototypes to ip_conntrack_h323.h
+ * 	     (suggested by Adrian Bunk)
  */
 
 #include <linux/module.h>
