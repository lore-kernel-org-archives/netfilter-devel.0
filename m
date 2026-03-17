Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54993ACEEA;
	Tue, 17 Mar 2026 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773746982; cv=none; b=JFLXRHuIdCWz8FKyptEHSICNKKscb/ZY47Rcak8HOimqcY12KnNX1LT6OYkgVSrueCRyAFSfS0Co+Pcp3KblKO1XkdcZeZ1MlfJfsWT2h8hkkwC4xrvJaBcKfxsXucw9Bc7FoYEBoaVQpC9AXxJWryO5m6s99pwLF+OoID5Ri7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773746982; c=relaxed/simple;
	bh=0SGcV8SC+4qn+iSwAGxQDgGiE+ojOcGlCFdSKmesOYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auN1Q+CwJTF6mGaMiydC7OIkosXspOfENmA14RV2P5jpQLtgLqQoGPudQh0L+YuNbL/yRFsoJlK2sAgP2FpNAOUBgYHo96zAMPknzmWEYcyTPyVyF9M0FhsyIaAoKSZXoaj/t7PWlduuGhtpZCP8b/Ewe98xCzTYWzo67YrGKz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=buN0RIio; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="buN0RIio"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6C38260265;
	Tue, 17 Mar 2026 12:29:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773746978;
	bh=yvf/FxAVaCRLMsbCkzkFJsz6K3N7GmkSLdH112AP9fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buN0RIio2079uc8tUN83CAxvRJp6WvspddG6l4CSWQy+AgzhQRzCYUhheFxKF8zEW
	 O/WDregSsxgYdh9r0CwAsN4cNtUbmu2YGOFRfAJ2go7Nz++on6cZTvdGKM3dWiIWUZ
	 bDhD3MRq/Ll8nqSQdw1mOjaKgFvKW/dA/LDI+Bv+YZwQrwXiTmKRzapwRtxEaMQxo5
	 O+XnvekxV/Chf9VKCQ2My9CdrKyGYCYn+XUoDazKe7AXWZHlX3SJwZ6pluUKeqTPBX
	 VvMSOWsEfDk7xOxMH2DoQVpIgcdvXrIoGoQill05+wz7UR8IKCOkjnyjJvV3nDokCQ
	 wMZ69uaeQ9dzA==
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
Subject: [PATCH net-next,RFC 6/8] net: add dev_dst_drop() helper function
Date: Tue, 17 Mar 2026 12:29:15 +0100
Message-ID: <20260317112917.4170466-7-pablo@netfilter.org>
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

Prepare to reuse this function from listified tx path.

No functional changes are intended, this is a preparation patch.

Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/core/dev.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 476ee88440a6..5c339416ae5d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4719,6 +4719,17 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
 	return netdev_get_tx_queue(dev, queue_index);
 }
 
+/* If device/qdisc don't need skb->dst, release it right now while
+ * its hot in this cpu cache.
+ */
+static inline void dev_dst_drop(const struct net_device *dev, struct sk_buff *skb)
+{
+	if (dev->priv_flags & IFF_XMIT_DST_RELEASE)
+		skb_dst_drop(skb);
+	else
+		skb_dst_force(skb);
+}
+
 /**
  * __dev_queue_xmit() - transmit a buffer
  * @skb:	buffer to transmit
@@ -4784,13 +4795,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 			txq = netdev_tx_queue_mapping(dev, skb);
 	}
 #endif
-	/* If device/qdisc don't need skb->dst, release it right now while
-	 * its hot in this cpu cache.
-	 */
-	if (dev->priv_flags & IFF_XMIT_DST_RELEASE)
-		skb_dst_drop(skb);
-	else
-		skb_dst_force(skb);
+	dev_dst_drop(dev, skb);
 
 	if (!txq)
 		txq = netdev_core_pick_tx(dev, skb, sb_dev);
-- 
2.47.3

