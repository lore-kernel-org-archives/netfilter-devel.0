Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAA91DED77;
	Sun,  9 Mar 2025 14:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741531634; cv=none; b=jK8gNdj0wIHvhj5eChK8l5gFruBjDoWSul/RZOzp/dD7UwVGLvj19bHsGNs1yGd8nw5sVwAI52DOZLULcpvyk5kY8KsbJ2uFBgWDAdY27Oe1QZJTWwwMmuxAml5FbiF9PYxjmoOARvgr9DGq5BebwlvIW/IC1Ngp2IOSSpA+qAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741531634; c=relaxed/simple;
	bh=UH8AuXRcns+Hb/zCkqUa17Lzxgyh0a3LIlYIOxVKbvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpPepKCbEWz60oApj/I8Z7IKc+3sJcvhIzgzmBAlcYb6owzHIFjPIQBkbMVKWUJ0Jjt2H1j0WYguWEpxkIpJStdWsMrm5urNrJsz5lZCGwKrQ3COHOij6/LL5WEY+vMexza6XoZVr/0HaBLfHTV8qzadGonptu4SOdTUMjbghz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=shj0L+rf; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=kr8Tss9D; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="shj0L+rf";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="kr8Tss9D"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1741531629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3yIocze9CLkCT8Lv56UF9k2zA0QQ9c/stSYrYUgDtmg=;
	b=shj0L+rf+mxZa0QLX7gYYWfHS1S1K+f+6pNqDmzk4Sn9UXHPa8rhQt+VF2cGyzLzj+4UOj
	bIxkDljRbM5CDXkZmIDoHxjh9CNUBtDbxcKqrU9NcTKVXX6gVXyKHYw7lm/Ua6sago9sHt
	cxqvxB26H6N36O1BuIKn7eNt7aCGmgd8DpZ486EOr5dT/+72J/Z8Q3gVFf2R/CNTaedndT
	5ipcdBw/E8ykIJngLMFH9zeyTJ4jKIGb1FaTGgNgPBK6dLllOnoqKd4bfdMrGbeo30D/8c
	bmjWhFggXamk9xJ57R7pNGA8q6uezzGPe+935Osb8SzfGTti1hz5F5BDeeyWDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1741531629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3yIocze9CLkCT8Lv56UF9k2zA0QQ9c/stSYrYUgDtmg=;
	b=kr8Tss9D0EHTqiI6Q9V85pzh93GJSqSfuy0+K7mgxeiI7ghVpOP04bx4jWyxr8v9XM9P7c
	rPmLfdhB2CAnc5Aw==
To: netdev@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH net-next 08/18] netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit.
Date: Sun,  9 Mar 2025 15:46:43 +0100
Message-ID: <20250309144653.825351-9-bigeasy@linutronix.de>
In-Reply-To: <20250309144653.825351-1-bigeasy@linutronix.de>
References: <20250309144653.825351-1-bigeasy@linutronix.de>
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

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
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
2.47.2

