Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD1229B8C5;
	Thu, 22 May 2025 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932797; cv=none; b=r70crw80opuk8WrA3WOts9Fd2VATIXW6LjrXge2tCQD7VZKnixG3CvRJGe1qI41z1Jo76KElDA/4WDmyxsw27j8zT92b6mirhENuigoSX0X4Ky6oc3udfYTGiVnjqGSw19wkQTd9Z1KgINdVRLK407JHY28BpgtsU1enksw9abQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932797; c=relaxed/simple;
	bh=Ma2619K6JlGt617K8eDhrURbu18LN3hIGjrMFA1r2co=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hbIu2jgWwvWVEV5WnoEjdOoCREe//1o05jQh82SENDoslf50GyfWGWfNJfW4EC3JiCQyg0bKcbkvOrxKVnwbAiOT9IGfSWUUxR3tG6VbztRyaeBwDzde0jlewt8A4AoZOv9KHhpL+pTboM/YDz1FiZKb16zrtqVBP8U1GjwZmgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bHh80OE7; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d9IALNnp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bHh80OE7";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d9IALNnp"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4D9A4606A4; Thu, 22 May 2025 18:53:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932794;
	bh=s3IRiWwEpkmC0HelhLsEJvCeRxFecKfpzzHFGbjUW9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHh80OE7FqwHpTEW51kzrghsqpv7bfAtMVwpn2/cvsf7RcrZ6VTNH2QGvcj9yZr7Y
	 UHOy1gKx9rHx4orn9U7wEjmYjGpBGE7F8OUya/ThZ3PocA8un4qQeMJl8exTogh5Ee
	 CGCKtsOS3r2ROMitFTs2aXQhR7pf8rwRvF41agUZYptZ5zbhqe+Nm41b9tcW11HQ5/
	 jF/kdFKwBc4R+pvbfziZgBjjSuZ1G51JY34eZk6bNp+2jBAyx4upiHHpa5YK2d+TxL
	 qkHQ7Adcti/L08K8B8Inv8tMPuCin+g6iQteBK2BWWUXxz4Ow+lqs7YWaL82sfBeOF
	 kEkbZ9EXN/zpA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 01A746073C;
	Thu, 22 May 2025 18:52:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932774;
	bh=s3IRiWwEpkmC0HelhLsEJvCeRxFecKfpzzHFGbjUW9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9IALNnpgiMk3A+w18b38nHqttT+gG1ph/fxenhtvyvjzdlEOWZ8FgnvI2iyV4mP9
	 F0YhY90VSu6W9cUe0mF0tklhhCeG03Zg/c4HYRQ9ORt42fCvSYVKhn55IzCTLq3POd
	 AjWu344O3emd7FOzZL/KnRfjqeloSt2NPzwBFZljF9xfOUcl8DKAtLsPkPjzlgVI0H
	 CqOfbbpfW6oKAsVblYnd2ve0Zrm9utTBS3Vd3c6i/Gm0LpFe5XD6O7YRctkWO0lO4u
	 /i1utSwyhEBWI/deWy5QUPXVGwtj35SX7tG592ebsNEDsYJox97ByEBb5z4Np3Wx/H
	 VLR0/ZBIU1kFg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 11/26] netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit
Date: Thu, 22 May 2025 18:52:23 +0200
Message-Id: <20250522165238.378456-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

nf_dup_skb_recursion is a per-CPU variable and relies on disabled BH for its
locking. Without per-CPU locking in local_bh_disable() on PREEMPT_RT
this data structure requires explicit locking.

Move nf_dup_skb_recursion to struct netdev_xmit, provide wrappers.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice_xmit.h |  3 +++
 net/netfilter/nf_dup_netdev.c  | 22 ++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice_xmit.h b/include/linux/netdevice_xmit.h
index 848735b3a7c0..813a19122ebb 100644
--- a/include/linux/netdevice_xmit.h
+++ b/include/linux/netdevice_xmit.h
@@ -11,6 +11,9 @@ struct netdev_xmit {
 #if IS_ENABLED(CONFIG_NET_ACT_MIRRED)
 	u8 sched_mirred_nest;
 #endif
+#if IS_ENABLED(CONFIG_NF_DUP_NETDEV)
+	u8 nf_dup_skb_recursion;
+#endif
 };
 
 #endif
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index a8e2425e43b0..fab8b9011098 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -15,12 +15,26 @@
 
 #define NF_RECURSION_LIMIT	2
 
-static DEFINE_PER_CPU(u8, nf_dup_skb_recursion);
+#ifndef CONFIG_PREEMPT_RT
+static u8 *nf_get_nf_dup_skb_recursion(void)
+{
+	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
+}
+#else
+
+static u8 *nf_get_nf_dup_skb_recursion(void)
+{
+	return &current->net_xmit.nf_dup_skb_recursion;
+}
+
+#endif
 
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
-	if (__this_cpu_read(nf_dup_skb_recursion) > NF_RECURSION_LIMIT)
+	u8 *nf_dup_skb_recursion = nf_get_nf_dup_skb_recursion();
+
+	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT)
 		goto err;
 
 	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
@@ -32,9 +46,9 @@ static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-	__this_cpu_inc(nf_dup_skb_recursion);
+	(*nf_dup_skb_recursion)++;
 	dev_queue_xmit(skb);
-	__this_cpu_dec(nf_dup_skb_recursion);
+	(*nf_dup_skb_recursion)--;
 	return;
 err:
 	kfree_skb(skb);
-- 
2.30.2

