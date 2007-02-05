From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng] ipt_TARPIT for Linux 2.6.20
Date: Mon, 5 Feb 2007 10:20:59 +0100
Message-ID: <20070205092059.GA12674@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Patch for the function ip_direct_send() to compile on Linux 2.6.20.

Signed-off-by: Max Kellermann <max@duempel.org>

Index: patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c
===================================================================
--- patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	(revision 6747)
+++ patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	(working copy)
@@ -60,16 +60,11 @@
 static int ip_direct_send(struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb->dst;
-	struct hh_cache *hh = dst->hh;
 
-	if (hh) {
-		read_lock_bh(&hh->hh_lock);
-		memcpy(skb->data - 16, hh->hh_data, 16);
-		read_unlock_bh(&hh->hh_lock);
-		skb_push(skb, hh->hh_len);
-		return hh->hh_output(skb);
-	} else if (dst->neighbour)
-		return dst->neighbour->output(skb);
+        if (dst->hh)
+                return neigh_hh_output(dst->hh, skb);
+        else if (dst->neighbour)
+                return dst->neighbour->output(skb);
 
 	if (net_ratelimit())
 		printk(KERN_DEBUG "TARPIT ip_direct_send: no header cache and no neighbor!\n");
