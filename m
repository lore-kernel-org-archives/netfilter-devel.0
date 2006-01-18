From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: [PATCH] ULOG] Use better value for 'nlbufsiz'
Date: Wed, 18 Jan 2006 16:34:52 +0100
Message-ID: <11375984923951-git-send-email-heitzenberger@astaro.com>
References: <11375984922851-git-send-email-heitzenberger@astaro.com>
Reply-To: Holger Eitzenberger <heitzenberger@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <11375984922851-git-send-email-heitzenberger@astaro.com>
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

Performance tests showed that ULOG may fail on heavy loaded systems
because of failed order-N allocations (N >= 1).

The default value of 4096 is not optimal in the sense that it actually
allocates _two_ contigous physical pages.  Reasoning: ULOG uses
alloc_skb(), which adds another ~300 bytes for skb_shared_info.

This patch sets the default value to 3700 and adds some documentation
at the top.

Signed-off-by: Holger Eitzenberger <heitzenberger@astaro.com>

---

 net/ipv4/netfilter/ipt_ULOG.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

4109f782faca0719825e39633d71b5e8b5dc74df
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 641dbc4..7a6adaf 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -35,6 +35,11 @@
  * each nlgroup you are using, so the total kernel memory usage increases
  * by that factor.
  *
+ * Actually you should use nlbufsiz a bit smaller than PAGE_SIZE, since
+ * nlbufsiz is used with alloc_skb, which adds another
+ * sizeof(struct skb_shared_info).  This is ~300 bytes on i386, so use a
+ * value of ~3700 instead.
+ *
  * flushtimeout:
  *   Specify, after how many hundredths of a second the queue should be
  *   flushed even if it is not full yet.
@@ -76,7 +81,7 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NE
 
 #define PRINTR(format, args...) do { if (net_ratelimit()) printk(format , ## args); } while (0)
 
-static unsigned int nlbufsiz = 4096;
+static unsigned int nlbufsiz = 3700;
 module_param(nlbufsiz, uint, 0400);
 MODULE_PARM_DESC(nlbufsiz, "netlink buffer size");
 
-- 
1.0.GIT
