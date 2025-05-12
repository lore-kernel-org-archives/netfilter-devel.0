Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D9A265CA3
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2025 10:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747045734; cv=none; b=cyf72KRPzvzwMckRAPokBSKlX3WMW0CKNW7xPnXZ6/Z1usBtvJJLf9lZyd2WmZ/eEKs78SEhw+52Hq147vND9VbL9QC9ghauat/4mxOTmr5tF+h44RoWgQCHziVt9R5ZJ+F5LhrApzoJbmXVqO38r8DDbEC2PRwd8v05Q9tLxl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747045734; c=relaxed/simple;
	bh=gAhJX9eAemw9+PWS8n+n+qxiyOMGRf1Y501+OX8uDNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pehU4NfxHdpDMN9w2U0ackl7kwJ0kThlNbKNsaaedSzKX4P4WvWp3w6V/PoM70nPMbdN5AJDDA7EOKgqPvZuKAV9AzCy4dnMi9xlPXmTJy+KT1uLy63RD/0X4MNO52uDNSIT3ybK74INzz/Ptij6lD5NgiQAbiHkE5MZeMvciH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=GipB8GnG; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Dn+pJdzY; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GipB8GnG";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Dn+pJdzY"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1747045731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dgeuGMr/JXNZkp67Cj25IB+ttfZNxcT5LQr2SIje890=;
	b=GipB8GnGFaM2P2HeCLykaA8p61a4CbHb4K/c2ODpx7nP0vi9+UvNnYLpEgyngRiZJgVx4O
	S+snih/63sk4BsfEZk3jSS8h7HHptnCqhLACkbjFegF5uyW3Q5uQCLWJ15fnibciquMc/a
	CRtUfPQ9OjhyBS0yKmc2758HIEmu/+zm3LQKmG7iN2KuutxCts0Kagzsh9DfZCtyW66lkS
	8EMIIX4lbVF6K2SrCLDU+5ic9d7o+QXnfg53wD94C86Pt6ubaB5KLUW0u1xLabDiwDZ2qv
	n/qfQWHPAIM+6IRzACcCRWtk7IGFbMmYNPjNGskPL2WvY8ky0m3JRC/yYhhPNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1747045731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dgeuGMr/JXNZkp67Cj25IB+ttfZNxcT5LQr2SIje890=;
	b=Dn+pJdzYfrNSpwlPUxgcgOKbl2u+Ff7p1rljaYWRjtHsyPcUXxzBh+Y9FquUswzgrxhfIj
	8bE5z4I2Dk+yVnBA==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nf-next v1 3/3] netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit
Date: Mon, 12 May 2025 12:28:46 +0200
Message-ID: <20250512102846.234111-4-bigeasy@linutronix.de>
In-Reply-To: <20250512102846.234111-1-bigeasy@linutronix.de>
References: <20250512102846.234111-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

nf_dup_skb_recursion is a per-CPU variable and relies on disabled BH for its
locking. Without per-CPU locking in local_bh_disable() on PREEMPT_RT
this data structure requires explicit locking.

Move nf_dup_skb_recursion to struct netdev_xmit, provide wrappers.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/netdevice_xmit.h |  3 +++
 net/netfilter/nf_dup_netdev.c  | 22 ++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice_xmit.h b/include/linux/netdevice_xmit.h
index 38325e0702968..3bbbc1a9860a3 100644
--- a/include/linux/netdevice_xmit.h
+++ b/include/linux/netdevice_xmit.h
@@ -8,6 +8,9 @@ struct netdev_xmit {
 #ifdef CONFIG_NET_EGRESS
 	u8  skip_txqueue;
 #endif
+#if IS_ENABLED(CONFIG_NF_DUP_NETDEV)
+	u8 nf_dup_skb_recursion;
+#endif
 };
=20
 #endif
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index a8e2425e43b0d..fab8b9011098f 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -15,12 +15,26 @@
=20
 #define NF_RECURSION_LIMIT	2
=20
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
=20
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *de=
v,
 				enum nf_dev_hooks hook)
 {
-	if (__this_cpu_read(nf_dup_skb_recursion) > NF_RECURSION_LIMIT)
+	u8 *nf_dup_skb_recursion =3D nf_get_nf_dup_skb_recursion();
+
+	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT)
 		goto err;
=20
 	if (hook =3D=3D NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
@@ -32,9 +46,9 @@ static void nf_do_netdev_egress(struct sk_buff *skb, stru=
ct net_device *dev,
=20
 	skb->dev =3D dev;
 	skb_clear_tstamp(skb);
-	__this_cpu_inc(nf_dup_skb_recursion);
+	(*nf_dup_skb_recursion)++;
 	dev_queue_xmit(skb);
-	__this_cpu_dec(nf_dup_skb_recursion);
+	(*nf_dup_skb_recursion)--;
 	return;
 err:
 	kfree_skb(skb);
--=20
2.49.0

