From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/22]: xt_mac/xt_CLASSIFY: use IPv6 hook names for IPv6
	registration
Date: Mon, 12 Feb 2007 11:36:46 +0100 (MET)
Message-ID: <20070212103646.661.42599.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_mac/xt_CLASSIFY: use IPv6 hook names for IPv6 registration

Use NF_IP6_ instead of NF_IP_. The values are identical, this is merely
cleanup.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0a03715d7befc80612212ee80723dcce8b75f3c1
tree 1ddf22e671682d94ad017f0a9f7f4a74566c60bd
parent 4b4109fff045b66b7bc0a696fc020f0cc22bad0e
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:07:51 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:07:51 +0100

 net/netfilter/xt_CLASSIFY.c |    8 +++++---
 net/netfilter/xt_mac.c      |    7 ++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 195e929..4007bbe 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -15,6 +15,8 @@ #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <net/checksum.h>
 
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CLASSIFY.h>
 
@@ -55,9 +57,9 @@ static struct xt_target xt_classify_targ
 		.target 	= target,
 		.targetsize	= sizeof(struct xt_classify_target_info),
 		.table		= "mangle",
-		.hooks		= (1 << NF_IP_LOCAL_OUT) |
-				  (1 << NF_IP_FORWARD) |
-			          (1 << NF_IP_POST_ROUTING),
+		.hooks		= (1 << NF_IP6_LOCAL_OUT) |
+				  (1 << NF_IP6_FORWARD) |
+			          (1 << NF_IP6_POST_ROUTING),
 		.me 		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 425fc21..d430d90 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -14,6 +14,7 @@ #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
 
 #include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/xt_mac.h>
 #include <linux/netfilter/x_tables.h>
 
@@ -59,9 +60,9 @@ static struct xt_match xt_mac_match[] = 
 		.family		= AF_INET6,
 		.match		= match,
 		.matchsize	= sizeof(struct xt_mac_info),
-		.hooks		= (1 << NF_IP_PRE_ROUTING) |
-				  (1 << NF_IP_LOCAL_IN) |
-				  (1 << NF_IP_FORWARD),
+		.hooks		= (1 << NF_IP6_PRE_ROUTING) |
+				  (1 << NF_IP6_LOCAL_IN) |
+				  (1 << NF_IP6_FORWARD),
 		.me		= THIS_MODULE,
 	},
 };
