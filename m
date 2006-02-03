From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/14]: ULOG/nfnetlink_log: Use better default value for
	'nlbufsiz'
Date: Fri,  3 Feb 2006 14:44:04 +0100 (MET)
Message-ID: <20060203134404.2141.13996.sendpatchset@localhost.localdomain>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ULOG/nfnetlink_log: Use better default value for 'nlbufsiz'

Performance tests showed that ULOG may fail on heavy loaded systems
because of failed order-N allocations (N >= 1).

The default value of 4096 is not optimal in the sense that it actually
allocates _two_ contigous physical pages.  Reasoning: ULOG uses
alloc_skb(), which adds another ~300 bytes for skb_shared_info.

This patch sets the default value to NLMSG_GOODSIZE and adds some
documentation at the top.

Signed-off-by: Holger Eitzenberger <heitzenberger@astaro.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5974aa1e67cc9139557471d57aa6b54c7fb6aed5
tree 4f3f1e9d8d38ab0f88549bdfd44cd51f72eb8104
parent edf3735e79f637f92f34d0848bfb6c0ea45a9349
author Holger Eitzenberger <heitzenberger@astaro.com> Fri, 03 Feb 2006 12:36:48 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:36:48 +0100

 net/bridge/netfilter/ebt_ulog.c |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c   |    6 +++++-
 net/netfilter/nfnetlink_log.c   |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index ce617b3..dbbf9f6 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -46,7 +46,7 @@
 #define PRINTR(format, args...) do { if (net_ratelimit()) \
                                 printk(format , ## args); } while (0)
 
-static unsigned int nlbufsiz = 4096;
+static unsigned int nlbufsiz = NLMSG_GOODSIZE;
 module_param(nlbufsiz, uint, 0600);
 MODULE_PARM_DESC(nlbufsiz, "netlink buffer size (number of bytes) "
                            "(defaults to 4096)");
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 641dbc4..2fe6413 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -35,6 +35,10 @@
  * each nlgroup you are using, so the total kernel memory usage increases
  * by that factor.
  *
+ * Actually you should use nlbufsiz a bit smaller than PAGE_SIZE, since
+ * nlbufsiz is used with alloc_skb, which adds another
+ * sizeof(struct skb_shared_info).  Use NLMSG_GOODSIZE instead.
+ *
  * flushtimeout:
  *   Specify, after how many hundredths of a second the queue should be
  *   flushed even if it is not full yet.
@@ -76,7 +80,7 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NE
 
 #define PRINTR(format, args...) do { if (net_ratelimit()) printk(format , ## args); } while (0)
 
-static unsigned int nlbufsiz = 4096;
+static unsigned int nlbufsiz = NLMSG_GOODSIZE;
 module_param(nlbufsiz, uint, 0400);
 MODULE_PARM_DESC(nlbufsiz, "netlink buffer size");
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index e10512e..50787af 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -37,7 +37,7 @@
 #include "../bridge/br_private.h"
 #endif
 
-#define NFULNL_NLBUFSIZ_DEFAULT	4096
+#define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
 
