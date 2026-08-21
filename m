Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69666322A1F;
	Fri, 21 Aug 2026 13:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787319256; cv=none; b=esbRvJJMFuwUmdRW3mfkplUBBH0x8/5sqKEuivVkpB0XKH1gDoCXc4sYRmPEf3dFAINsbsoof9xgfoCEWTrAspfScosQEsHCMnTeT3sfoAwmTDufrcHEObNSXO154zxQCeYUBs1nV6iNohfRSdjRZe7dhfFvDGzN2NMU0lHHrpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787319256; c=relaxed/simple;
	bh=eJwkd6Wf/JlgnzBtFXQ9jU2Z76oo3Li1j9yTtVz69ss=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CyfaKD4hfQgIuvZaIJAlx2hlit1vrXKExd1t+ovQ93EF7y8ax4AV4iJMFFRjBKBEtkbITWNk24L3iYAvzg6U866oz6ICxV5vKri5HwWSy1+7OnEE2UyfMz1mY8WBZziYCTTKEY2B/oQqmhqEEpOV7SfkKbCs0RsppOj3dl9dHrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=wUrxfGQD; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="wUrxfGQD"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id BA6981A1761;
	Fri, 21 Aug 2026 13:34:12 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 8DD95604AA;
	Fri, 21 Aug 2026 13:34:12 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B4AE311C761FC;
	Fri, 21 Aug 2026 15:34:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1787319247; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=piDDRH0HRHEj8bTwRtfQXJHGVjbPNgdGz7J6LRzfb4Y=;
	b=wUrxfGQD1/35gRgpuFyt+59v+KqXPqDDuLbNESls96PEoqkBlQx/2KGZry8hhTmMHiejCk
	VBLUn8PKAaJoLYIcieOWgYPOn5Px4KIZ9vYss3F1aa6HayvDw7m9/KadpEfTXBBR4qiymN
	/r2Ue457oLA/0qD65sMISEBGorPevlKHJmTxEYeucmpTpyYAwJ7RDxOcC7e8fLCzyaixdm
	x7Us6p2qSvuxG9xh31pM8tz1YeiGiGehzPUXxRbraO+1EnSje9F2sgejz8g4ASLxEcW0uZ
	YOOqV9edQ1/1puwSpUPEm9KPbH1C9DbLc54kZPRi2K6H/XCC10mud3SlF9qeMw==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Fri, 21 Aug 2026 15:33:35 +0200
Subject: [PATCH v6.1.y 1/4] net: dst: add four helpers to annotate
 data-races around dst->dev
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-cve-2025-40074-6-1-v1-1-cad5cf499b76@bootlin.com>
References: <20260821-cve-2025-40074-6-1-v1-0-cad5cf499b76@bootlin.com>
In-Reply-To: <20260821-cve-2025-40074-6-1-v1-0-cad5cf499b76@bootlin.com>
To: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>, 
 Martin KaFai Lau <kafai@fb.com>, 
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, 
 David Ahern <dsahern@kernel.org>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, Miguel Gazquez <miguel.gazquez@bootlin.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787319234; l=4582;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=H7jKVfoP1pzgjHPWNvNmP1bd0X3iN9gcZ7Dv1H35JkY=;
 b=WAQs98iyWBJgMny/8jeK4xkQ2VmHDpLxsrIbneVrNijKHwKfmqJJeYqK7/9CJIiYaIRbQslpV
 GLnJ9Knen2MBTSA7g1HwdW1ZHRPFy/yoFfaA/CGTJyoHnjIZ7qtz8Tc
X-Developer-Key: i=miguel.gazquez@bootlin.com; a=ed25519;
 pk=k/2KI9jkmayaF0ghZ8QYUH9Wm/kFHDhl8QoZ0RHbr4w=
X-Last-TLS-Session-Version: TLSv1.3

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 88fe14253e181878c2ddb51a298ae8c468a63010 ]

dst->dev is read locklessly in many contexts,
and written in dst_dev_put().

Fixing all the races is going to need many changes.

We probably will have to add full RCU protection.

Add three helpers to ease this painful process.

static inline struct net_device *dst_dev(const struct dst_entry *dst)
{
       return READ_ONCE(dst->dev);
}

static inline struct net_device *skb_dst_dev(const struct sk_buff *skb)
{
       return dst_dev(skb_dst(skb));
}

static inline struct net *skb_dst_dev_net(const struct sk_buff *skb)
{
       return dev_net(skb_dst_dev(skb));
}

static inline struct net *skb_dst_dev_net_rcu(const struct sk_buff *skb)
{
       return dev_net_rcu(skb_dst_dev(skb));
}

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250630121934.3399505-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ minor modifications to fix conflict ]
Signed-off-by: Miguel Gazquez <miguel.gazquez@bootlin.com>
---
 include/net/dst.h | 20 ++++++++++++++++++++
 net/core/dst.c    |  4 ++--
 net/core/sock.c   |  6 +++---
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 20a76e532afb..7c0cf856154d 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -555,6 +555,11 @@ static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
 		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
 }
 
+static inline struct net_device *dst_dev(const struct dst_entry *dst)
+{
+	return READ_ONCE(dst->dev);
+}
+
 static inline struct net_device *dst_dev_rcu(const struct dst_entry *dst)
 {
 	/* In the future, use rcu_dereference(dst->dev) */
@@ -562,11 +567,26 @@ static inline struct net_device *dst_dev_rcu(const struct dst_entry *dst)
 	return READ_ONCE(dst->dev);
 }
 
+static inline struct net_device *skb_dst_dev(const struct sk_buff *skb)
+{
+	return dst_dev(skb_dst(skb));
+}
+
 static inline struct net_device *skb_dst_dev_rcu(const struct sk_buff *skb)
 {
 	return dst_dev_rcu(skb_dst(skb));
 }
 
+static inline struct net *skb_dst_dev_net(const struct sk_buff *skb)
+{
+	return dev_net(skb_dst_dev(skb));
+}
+
+static inline struct net *skb_dst_dev_net_rcu(const struct sk_buff *skb)
+{
+	return dev_net_rcu(skb_dst_dev(skb));
+}
+
 struct dst_entry *dst_blackhole_check(struct dst_entry *dst, u32 cookie);
 void dst_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
 			       struct sk_buff *skb, u32 mtu, bool confirm_neigh);
diff --git a/net/core/dst.c b/net/core/dst.c
index 8db87258d145..24a1cc3d2a08 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -151,7 +151,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev, true);
 	dst->input = dst_discard;
 	dst->output = dst_discard_out;
-	dst->dev = blackhole_netdev;
+	WRITE_ONCE(dst->dev, blackhole_netdev);
 	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
 			   GFP_ATOMIC);
 }
@@ -272,7 +272,7 @@ unsigned int dst_blackhole_mtu(const struct dst_entry *dst)
 {
 	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
 
-	return mtu ? : dst->dev->mtu;
+	return mtu ? : dst_dev(dst)->mtu;
 }
 EXPORT_SYMBOL_GPL(dst_blackhole_mtu);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 2a701e0b052b..64f9d77bfaec 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2397,7 +2397,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 {
 	u32 max_segs = 1;
 
-	sk->sk_route_caps = dst->dev->features;
+	sk->sk_route_caps = dst_dev(dst)->features;
 	if (sk_is_tcp(sk))
 		sk->sk_route_caps |= NETIF_F_GSO;
 	if (sk->sk_route_caps & NETIF_F_GSO)
@@ -2410,11 +2410,11 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 		} else {
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
-			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
+			sk->sk_gso_max_size = READ_ONCE(dst_dev(dst)->gso_max_size);
 			sk_trim_gso_size(sk);
 			sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
-			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
+			max_segs = max_t(u32, READ_ONCE(dst_dev(dst)->gso_max_segs), 1);
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;

-- 
2.55.0

