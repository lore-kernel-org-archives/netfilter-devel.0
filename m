From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH/RFC] core/netfilter.c: possible use of freed skb
Date: Sun, 27 Jul 2003 16:55:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200307271655.15937.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David S.Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

In nf_reinject(), info->okfn(skb) is called when the verdict is NF_ACCEPT.
This okfn deals with the skb and is responsible for freeing the skb.
Unfortunately the current code in nf_reinject() still uses this possibly
freed skb.
The patch below fixes this without introducing any new code.
It should be ok to dev_put the devices earlier, thanks to the
preceding rcu_read_lock.
I also moved the dev_put's of info->{in,out}dev to keep the code together.

cheers,
Bart

--- linux-2.6.0-test1/net/core/netfilter.c.old	2003-07-27 16:22:50.000000000 +0200
+++ linux-2.6.0-test1/net/core/netfilter.c	2003-07-27 16:30:48.000000000 +0200
@@ -557,6 +557,18 @@ void nf_reinject(struct sk_buff *skb, st
 
 	rcu_read_lock();
 
+	/* Release those devices we held, or Alexey will kill me. */
+	if (info->indev) dev_put(info->indev);
+	if (info->outdev) dev_put(info->outdev);
+#if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
+	if (skb->nf_bridge) {
+		if (skb->nf_bridge->physindev)
+			dev_put(skb->nf_bridge->physindev);
+		if (skb->nf_bridge->physoutdev)
+			dev_put(skb->nf_bridge->physoutdev);
+	}
+#endif
+
 	/* Drop reference to owner of hook which queued us. */
 	module_put(info->elem->owner);
 
@@ -599,19 +611,6 @@ void nf_reinject(struct sk_buff *skb, st
 	}
 	rcu_read_unlock();
 
-	/* Release those devices we held, or Alexey will kill me. */
-	if (info->indev) dev_put(info->indev);
-	if (info->outdev) dev_put(info->outdev);
-#if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
-	if (skb->nf_bridge) {
-		if (skb->nf_bridge->physindev)
-			dev_put(skb->nf_bridge->physindev);
-		if (skb->nf_bridge->physoutdev)
-			dev_put(skb->nf_bridge->physoutdev);
-	}
-#endif
-
-
 	if (verdict == NF_DROP)
 		kfree_skb(skb);
 
