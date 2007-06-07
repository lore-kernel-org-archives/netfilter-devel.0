From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 0/3] Misc cleanups
Date: Thu, 7 Jun 2007 10:26:14 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706071025210.1547@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706042108010.20829@yvahk01.tjqt.qr>
	<4666DCA6.8020400@trash.net>
	<Pine.LNX.4.61.0706070856250.1547@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706070856250.1547@yvahk01.tjqt.qr>
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


On Jun 7 2007 08:56, Jan Engelhardt wrote:
>>
>>Thanks Jan. I'll let them sit on netfilter-devel for a few more
>>days and will apply them on Sunday or Monday.
>>
>>BTW, if you would like to do more cleanups, getting rid of the
>>ugly DEBUGP macros and using pr_debug instead would be nice :)
>>But please don't just do global search and replace, I would like
>>to preserve alignment of multiline statements and 80 character
>>line length.
>
>Right, I'll see to that today.

Does this look ok? (In terms of style)
If so, I'll continue with the rest.

---
 net/netfilter/xt_helper.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

Index: linux-2.6.22-rc4/net/netfilter/xt_helper.c
===================================================================
--- linux-2.6.22-rc4.orig/net/netfilter/xt_helper.c
+++ linux-2.6.22-rc4/net/netfilter/xt_helper.c
@@ -7,6 +7,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
@@ -22,12 +23,6 @@ MODULE_DESCRIPTION("iptables helper matc
 MODULE_ALIAS("ipt_helper");
 MODULE_ALIAS("ip6t_helper");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -46,25 +41,25 @@ match(const struct sk_buff *skb,
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct) {
-		DEBUGP("xt_helper: Eek! invalid conntrack?\n");
+		pr_debug("xt_helper: Eek! invalid conntrack?\n");
 		return ret;
 	}
 
 	if (!ct->master) {
-		DEBUGP("xt_helper: conntrack %p has no master\n", ct);
+		pr_debug("xt_helper: conntrack %p has no master\n", ct);
 		return ret;
 	}
 
 	read_lock_bh(&nf_conntrack_lock);
 	master_help = nfct_help(ct->master);
 	if (!master_help || !master_help->helper) {
-		DEBUGP("xt_helper: master ct %p has no helper\n",
-			exp->expectant);
+		pr_debug("xt_helper: master ct %p has no helper\n",
+		         exp->expectant);
 		goto out_unlock;
 	}
 
-	DEBUGP("master's name = %s , info->name = %s\n",
-		ct->master->helper->name, info->name);
+	pr_debug("master's name = %s , info->name = %s\n",
+	         ct->master->helper->name, info->name);
 
 	if (info->name[0] == '\0')
 		ret = !ret;



	Jan
-- 
