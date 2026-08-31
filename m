Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627E847A0D7;
	Mon, 31 Aug 2026 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788192404; cv=none; b=o66iuOCJsVu7i2O0jjri+LA0jVQPVV6UQoXuYvYjNtdKRRN+yVNOOrOaedL+laDWYc5c06ydh0Q1uePkNUur5CJmgOC6YD8fVV0aOANKrnhC5r3iB42a+ybZEGSIQGt0vRb5Muf2I/oS1q3FHJL0fHWnHWrlDRgo9l+hsMlxnaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788192404; c=relaxed/simple;
	bh=yWDdDrKDq21kLtNlvG89pQvPgzrE7uMbjWOKWVhjQuY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MjqAg//1iU/o9NGNvXUksthF+7vZoDPPZQ54UcXWwOooURK7G9H0mnozqibWg7VWtzNMtvKmwhtSS7WcSgUfS6QH1sDSw0s4ixnCjyggNkQWt8bI8VNPoaRqz9PskD3Eo+5gxljp18cAepeSBR3puLo+EZMywYQXTTladfbj2io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=FN88P4Hd; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="FN88P4Hd"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id E2A6D1A190B;
	Mon, 31 Aug 2026 16:06:40 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B5D9C60231;
	Mon, 31 Aug 2026 16:06:40 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5524A11C78AC8;
	Mon, 31 Aug 2026 18:06:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788192399; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=GQrHdPAdNDpoOwtEj8ExxEJvXwjQocxbzuHQC12oy+0=;
	b=FN88P4HdSJsBT0VEH3XAc5fpnbfQUUTPOTl+1ni6HrEq57e9M6MTPlBFMSempfQMehC6V8
	yNYCPOLqjPdydS6vBG8hK6BGU/yORqpH0iVvD6llf/974iLbRZ4h/JGvaGBq4l57bJIOkd
	qjL3yxil6XmBxZxMykXlEMv6aBL+QueHdI7zwUh90aDEA0e9aHsP0/WRcdoA/Dci1CIoma
	WRQFM5xrRpzdoTn/6vEO5onY2E90IS+BS+p5aP5Iq9QuU0DXWqYJpM7dyjRye0c7NJ5/j+
	+oHqhFWcPWXswznXGpYM6D7ZETj2fKzXH+CBL3jKkAulHxh0cb9ED2eQCKYYVQ==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Mon, 31 Aug 2026 18:06:22 +0200
Subject: [PATCH 6.6.y 3/4] net: dst: introduce dst->dev_rcu
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-cve-2025-40074-6-6-v1-3-027e51b162a3@bootlin.com>
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
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788192387; l=3480;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=8k+v7v7++iJ5ldUykF05sg7PAEHbGXVludxh/gM9SS0=;
 b=ObHRv1mUyl8J8MD8WzJvYSyZTuejqi86NKS0kgyadSPbt3jVM6ZH+VVs7XY4BOyoM1P0olAeh
 00iQqBPhj2fCcLhY2mS3WhrH1AfFWlzAfDTk58wBIJR4q3WbqKs3A1A
X-Developer-Key: i=miguel.gazquez@bootlin.com; a=ed25519;
 pk=k/2KI9jkmayaF0ghZ8QYUH9Wm/kFHDhl8QoZ0RHbr4w=
X-Last-TLS-Session-Version: TLSv1.3

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit caedcc5b6df1b2e2b5f39079e3369c1d4d5c5f50 ]

Followup of commit 88fe14253e18 ("net: dst: add four helpers
to annotate data-races around dst->dev").

We want to gradually add explicit RCU protection to dst->dev,
including lockdep support.

Add an union to alias dst->dev_rcu and dst->dev.

Add dst_dev_net_rcu() helper.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
---
 include/net/dst.h | 16 +++++++++++-----
 net/core/dst.c    |  2 +-
 net/ipv4/route.c  |  4 ++--
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 1983945dfcdf..4b54b2f6730e 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -24,7 +24,10 @@
 struct sk_buff;
 
 struct dst_entry {
-	struct net_device       *dev;
+	union {
+		struct net_device       *dev;
+		struct net_device __rcu *dev_rcu;
+	};
 	struct  dst_ops	        *ops;
 	unsigned long		_metrics;
 	unsigned long           expires;
@@ -576,9 +579,12 @@ static inline struct net_device *dst_dev(const struct dst_entry *dst)
 
 static inline struct net_device *dst_dev_rcu(const struct dst_entry *dst)
 {
-	/* In the future, use rcu_dereference(dst->dev) */
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return READ_ONCE(dst->dev);
+	return rcu_dereference(dst->dev_rcu);
+}
+
+static inline struct net *dst_dev_net_rcu(const struct dst_entry *dst)
+{
+	return dev_net_rcu(dst_dev_rcu(dst));
 }
 
 static inline struct net_device *skb_dst_dev(const struct sk_buff *skb)
@@ -598,7 +604,7 @@ static inline struct net *skb_dst_dev_net(const struct sk_buff *skb)
 
 static inline struct net *skb_dst_dev_net_rcu(const struct sk_buff *skb)
 {
-	return dev_net_rcu(skb_dst_dev(skb));
+	return dev_net_rcu(skb_dst_dev_rcu(skb));
 }
 
 struct dst_entry *dst_blackhole_check(struct dst_entry *dst, u32 cookie);
diff --git a/net/core/dst.c b/net/core/dst.c
index f65e6be7e257..46cafba29991 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -153,7 +153,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev);
 	WRITE_ONCE(dst->input, dst_discard);
 	WRITE_ONCE(dst->output, dst_discard_out);
-	WRITE_ONCE(dst->dev, blackhole_netdev);
+	rcu_assign_pointer(dst->dev_rcu, blackhole_netdev);
 	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
 			   GFP_ATOMIC);
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 5010a9a75418..ce3397583b8f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1069,7 +1069,7 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 		return;
 
 	rcu_read_lock();
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	if (mtu < net->ipv4.ip_rt_min_pmtu) {
 		lock = true;
 		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
@@ -1367,7 +1367,7 @@ static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 	struct net *net;
 
 	rcu_read_lock();
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
 				   net->ipv4.ip_rt_min_advmss);
 	rcu_read_unlock();

-- 
2.55.0

