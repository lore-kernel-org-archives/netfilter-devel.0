Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602023AD503;
	Tue, 17 Mar 2026 11:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773746982; cv=none; b=o5T0Bwe8zbYR7QdIJQxw9UfRN9MR1IIJ2elNwypkDGKaA5y/OmOYFt7sSWceCJ7YgI3AlUFZuMcVl519g+p948tSizZoVnBGQrm2Ld/ZgnTbY7AAmwYw8PX2UHjYaztr1bV6fT1gmTi35puqRnW+ik7gxsVPUFNpRGmB2H9Tq+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773746982; c=relaxed/simple;
	bh=2N+LxRirWPjWkmhl172q75wJtGmVGrZYSSsYFA7aNGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYSQU5M+zfk7ptldUUz89DyNnnHcR0P+bpdCUKIjbbybUDcp3rGPtx8TV0EkctWhwXIkkV5xB/zgpxIN+LBP5qsd05i7eRh6V7wovMXJNoGmxMtTvpcYY/dmNCWARlc7gfMbnyU8qQrM9wnzfD8i3HBAiTwBi1JftqM4F8+Wt+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CmSOscvw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CmSOscvw"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9920E60269;
	Tue, 17 Mar 2026 12:29:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773746979;
	bh=AhdNruwD2TeIvDY05m5DAMdYftgpTLu7ihJKqlxkumI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmSOscvwC15FAZkWRU7L9slaTwMrZRMEy+nwxhSSs1I2bdswbTWtKYJWLIEdB033y
	 TDGeuQr0XWLEX1CsPmxz3KwMOG9c2Gvv6IQjf9YOcEA7x/9n0itXD4+VHg1gYsTdmX
	 wB6J6KE+QU/0ZFy7cwJ7efdFC+ADeN9eIgDZ7OpVGzwKA8iBMvKGKW/N4fm3KFtqyY
	 gs/G4jJlZDXWFRdGN59Pl3CwCiwsCia1pSUSPBUa0TTMV/h8M2EvmufA0+XdnhSV6Y
	 kbbslSLCG3YIRayaQKWe0SjjIjT+HGLixniYAYT1ImFFsFU1MePv/hVsl8iPVym6dJ
	 ZTDbusHMxzHuw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org,
	steffen.klassert@secunet.com,
	antony.antony@secunet.com
Subject: [PATCH net-next,RFC 7/8] net: add dev_noqueue_xmit_list() helper function
Date: Tue, 17 Mar 2026 12:29:16 +0100
Message-ID: <20260317112917.4170466-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317112917.4170466-1-pablo@netfilter.org>
References: <20260317112917.4170466-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This new helper function wraps the device has no queue case.  This function can
be reused from listified skb in the tx path since the device has no queue path
already supports for skb list.

***This replaces validate_xmit_skb() by validate_xmit_skb_list()*** in this
new helper function.

An alternative to this patch to reuse a smaller fraction of code can be to wrap
this common code instead in a function:

+                       HARD_TX_LOCK(dev, txq, cpu);
+
+                       if (!netif_xmit_stopped(txq)) {
+                               dev_xmit_recursion_inc();
+                               skb = dev_hard_start_xmit(skb, dev, txq, &rc);
+                               dev_xmit_recursion_dec();
+                               if (dev_xmit_complete(rc)) {
+                                       HARD_TX_UNLOCK(dev, txq);
+                                       goto out;
+                               }
+                       }
+                       HARD_TX_UNLOCK(dev, txq);

Note: This comment was in the original patch from Steffen:

       /* FIXME: For each skb!!! */
       dev_core_stats_tx_dropped_inc(dev);
       kfree_skb_list(skb);

This currently reports only one packet drop through stats.

Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/core/dev.c | 121 +++++++++++++++++++++++++++----------------------
 1 file changed, 67 insertions(+), 54 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5c339416ae5d..8f5bef5a715c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4730,6 +4730,68 @@ static inline void dev_dst_drop(const struct net_device *dev, struct sk_buff *sk
 		skb_dst_force(skb);
 }
 
+/* The device has no queue. Common case for software devices:
+ * loopback, all the sorts of tunnels...
+ *
+ * Really, it is unlikely that netif_tx_lock protection is necessary
+ * here.  (f.e. loopback and IP tunnels are clean ignoring statistics
+ * counters.)
+ * However, it is possible, that they rely on protection
+ * made by us here.
+ *
+ * Check this and shot the lock. It is not prone from deadlocks.
+ * Either shot noqueue qdisc, it is even simpler 8)
+ */
+static inline int dev_noqueue_xmit_list(struct sk_buff *skb,
+					struct net_device *dev,
+					struct netdev_queue *txq)
+{
+	bool again = false;
+	int rc = -ENOMEM;
+
+	if (dev->flags & IFF_UP) {
+		int cpu = smp_processor_id(); /* ok because BHs are off */
+
+		/* Other cpus might concurrently change txq->xmit_lock_owner
+		 * to -1 or to their cpu id, but not to our id.
+		 */
+		if (READ_ONCE(txq->xmit_lock_owner) != cpu) {
+			if (dev_xmit_recursion())
+				goto recursion_alert;
+
+			skb = validate_xmit_skb_list(skb, dev, &again);
+			if (!skb)
+				goto out;
+
+			HARD_TX_LOCK(dev, txq, cpu);
+
+			if (!netif_xmit_stopped(txq)) {
+				dev_xmit_recursion_inc();
+				skb = dev_hard_start_xmit(skb, dev, txq, &rc);
+				dev_xmit_recursion_dec();
+				if (dev_xmit_complete(rc)) {
+					HARD_TX_UNLOCK(dev, txq);
+					goto out;
+				}
+			}
+			HARD_TX_UNLOCK(dev, txq);
+			net_crit_ratelimited("Virtual device %s asks to queue packet!\n",
+					     dev->name);
+		} else {
+			/* Recursion is detected! It is possible,
+			 * unfortunately
+			 */
+recursion_alert:
+			net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
+					     dev->name);
+		}
+	}
+
+	rc = -ENETDOWN;
+out:
+	return rc;
+}
+
 /**
  * __dev_queue_xmit() - transmit a buffer
  * @skb:	buffer to transmit
@@ -4757,7 +4819,6 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	struct netdev_queue *txq = NULL;
 	struct Qdisc *q;
 	int rc = -ENOMEM;
-	bool again = false;
 
 	skb_reset_mac_header(skb);
 	skb_assert_len(skb);
@@ -4808,61 +4869,13 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 		goto out;
 	}
 
-	/* The device has no queue. Common case for software devices:
-	 * loopback, all the sorts of tunnels...
-
-	 * Really, it is unlikely that netif_tx_lock protection is necessary
-	 * here.  (f.e. loopback and IP tunnels are clean ignoring statistics
-	 * counters.)
-	 * However, it is possible, that they rely on protection
-	 * made by us here.
-
-	 * Check this and shot the lock. It is not prone from deadlocks.
-	 *Either shot noqueue qdisc, it is even simpler 8)
-	 */
-	if (dev->flags & IFF_UP) {
-		int cpu = smp_processor_id(); /* ok because BHs are off */
-
-		/* Other cpus might concurrently change txq->xmit_lock_owner
-		 * to -1 or to their cpu id, but not to our id.
-		 */
-		if (READ_ONCE(txq->xmit_lock_owner) != cpu) {
-			if (dev_xmit_recursion())
-				goto recursion_alert;
-
-			skb = validate_xmit_skb(skb, dev, &again);
-			if (!skb)
-				goto out;
-
-			HARD_TX_LOCK(dev, txq, cpu);
-
-			if (!netif_xmit_stopped(txq)) {
-				dev_xmit_recursion_inc();
-				skb = dev_hard_start_xmit(skb, dev, txq, &rc);
-				dev_xmit_recursion_dec();
-				if (dev_xmit_complete(rc)) {
-					HARD_TX_UNLOCK(dev, txq);
-					goto out;
-				}
-			}
-			HARD_TX_UNLOCK(dev, txq);
-			net_crit_ratelimited("Virtual device %s asks to queue packet!\n",
-					     dev->name);
-		} else {
-			/* Recursion is detected! It is possible,
-			 * unfortunately
-			 */
-recursion_alert:
-			net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
-					     dev->name);
-		}
-	}
-
-	rc = -ENETDOWN;
+	rc = dev_noqueue_xmit_list(skb, dev, txq);
 	rcu_read_unlock_bh();
 
-	dev_core_stats_tx_dropped_inc(dev);
-	kfree_skb_list(skb);
+	if (rc < 0) {
+		dev_core_stats_tx_dropped_inc(dev);
+		kfree_skb_list(skb);
+	}
 	return rc;
 out:
 	rcu_read_unlock_bh();
-- 
2.47.3

