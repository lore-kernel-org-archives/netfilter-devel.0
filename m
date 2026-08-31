Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16A440DB37
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 16:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788192400; cv=none; b=KX8nnolqZ4L48gSGF2DPBHFhgxb5qzwfBKJHbNw6Jv2uLfN6Vanw/4kw4NM6SFsksGATXaxo9VURr/dVc0FycMuz2JZ5ZcSfwpogzsDE6DOiwtI0HHPZSJYFkQN11+LxKcquIdSTHUif+niIuEYLWKqnzIUaYxGDxwI30szveA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788192400; c=relaxed/simple;
	bh=GYDmoSQopi8JIbV5HKMnY3p2XfPPSGecnpYA5BQJ3QY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Iclw9DPW4j8IR8K93I5ChPL7xm+S3xMFxV/ThnV9oNd9roFNHkeLFI0owBR2k/cxgjUMCkf0lWox8mLyCFoQ7C6QxJeFCHlYqeflQWUoqCwnxolz/j/fUPC3aT183Gmw3SiG53fwKxKYXzUtTLLBFrGq+5VX1rF9Sr2E9Ivt7Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=Y65tNXqd; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="Y65tNXqd"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 6AA7F1A1907;
	Mon, 31 Aug 2026 16:06:37 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3ED4F60231;
	Mon, 31 Aug 2026 16:06:37 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A701811C791C9;
	Mon, 31 Aug 2026 18:06:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788192396; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=1b9ggnS+m9DvxvjCyGwQo1Po6c1ljpGIbGBtA5dENFE=;
	b=Y65tNXqdSjiqIvjCM9PSzRcTLVqVmEJYv1UMzeLJ0CG6/o1WzW39OOYS4G4BQwVbEGKGEV
	Xqe/9BNERUA2i+WCDCnFcjy9jfRVf5NKJb9v1Ar86YgFyOpXvNBWO6H1xfWCvKvaCRl9GO
	HmpnBL9obWC4uhqTj1Gq5Rcpm7Aj8NWJx98msapDZzS87XBlW/p25mGH9Qzeky8rXIKLLL
	IphBhSofxMb+pLBTCneZC6aY3fG55UV6u8Dml1OOlvIUREkDdVHvPpUzt68ZOt+wHkrDXA
	d8x/lsQKbi15n9/f8MXskF2X9fiWuQ0JAxCPQK0FD8qC9ZExtCfefQrnFBLcSw==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Mon, 31 Aug 2026 18:06:20 +0200
Subject: [PATCH 6.6.y 1/4] net: dst: add four helpers to annotate
 data-races around dst->dev
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-cve-2025-40074-6-6-v1-1-027e51b162a3@bootlin.com>
References: <20260831-cve-2025-40074-6-6-v1-0-027e51b162a3@bootlin.com>
In-Reply-To: <20260831-cve-2025-40074-6-6-v1-0-027e51b162a3@bootlin.com>
To: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Martin KaFai Lau <kafai@fb.com>, 
 Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, 
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788192387; l=4931;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=dVsZJnIS1AfxVNrteL10XJDu1yEepAsiZ9WjggoUgfg=;
 b=JVVQZYdWwY25eL9D+KKtayQaaDYBJGBeb8Nq9ivTZZWwggGkBNDuEdcloPeGBwyrtV8eMSvGE
 b62Ac00B5kpDZhxQFsotPTY+oR3O7eoS8ESbv8gYJfun4zdlaoBpuXE
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
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
---
 include/net/dst.h | 20 ++++++++++++++++++++
 net/core/dst.c    |  4 ++--
 net/core/sock.c   |  8 ++++----
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 55d1be268d24..1983945dfcdf 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -569,6 +569,11 @@ static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
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
@@ -576,11 +581,26 @@ static inline struct net_device *dst_dev_rcu(const struct dst_entry *dst)
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
index 5ed8cb10748f..f65e6be7e257 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -153,7 +153,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev);
 	WRITE_ONCE(dst->input, dst_discard);
 	WRITE_ONCE(dst->output, dst_discard_out);
-	dst->dev = blackhole_netdev;
+	WRITE_ONCE(dst->dev, blackhole_netdev);
 	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
 			   GFP_ATOMIC);
 }
@@ -266,7 +266,7 @@ unsigned int dst_blackhole_mtu(const struct dst_entry *dst)
 {
 	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
 
-	return mtu ? : dst->dev->mtu;
+	return mtu ? : dst_dev(dst)->mtu;
 }
 EXPORT_SYMBOL_GPL(dst_blackhole_mtu);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 846e95805c19..2f82dc45f93e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2454,8 +2454,8 @@ static u32 sk_dst_gso_max_size(struct sock *sk, struct dst_entry *dst)
 		   !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr));
 #endif
 	/* pairs with the WRITE_ONCE() in netif_set_gso(_ipv4)_max_size() */
-	max_size = is_ipv6 ? READ_ONCE(dst->dev->gso_max_size) :
-			READ_ONCE(dst->dev->gso_ipv4_max_size);
+	max_size = is_ipv6 ? READ_ONCE(dst_dev(dst)->gso_max_size) :
+			READ_ONCE(dst_dev(dst)->gso_ipv4_max_size);
 	if (max_size > GSO_LEGACY_MAX_SIZE && !sk_is_tcp(sk))
 		max_size = GSO_LEGACY_MAX_SIZE;
 
@@ -2466,7 +2466,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 {
 	u32 max_segs = 1;
 
-	sk->sk_route_caps = dst->dev->features;
+	sk->sk_route_caps = dst_dev(dst)->features;
 	if (sk_is_tcp(sk))
 		sk->sk_route_caps |= NETIF_F_GSO;
 	if (sk->sk_route_caps & NETIF_F_GSO)
@@ -2480,7 +2480,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			sk->sk_gso_max_size = sk_dst_gso_max_size(sk, dst);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
-			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
+			max_segs = max_t(u32, READ_ONCE(dst_dev(dst)->gso_max_segs), 1);
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;

-- 
2.55.0

