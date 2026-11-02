Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581027;
	b=Yhihq3bwOvyb8SYZBYvAXs9TBOl/C5UehWJigmlfkMUT9O7GnJGMOL9+8+14d7UXkiJX
	 eTA1+8fSxGVZydxs3HvVC4U8HZuL9nQ85Xcx+t0kTzIEQBPUKPKBGteTyG6Oj0BKqIiwJ
	 NTZFc8680SJQlg0q+S5EMh78xKFgER+ckme1EvZ/KcIfaKvQhIrXh8L/PmfcOmWCZMI+7
	 9S9heXYP4JpQYc9XcmemCwAtEJmANpgYGhbSQ/oxxim66WPFUZQ9h6jHvM/neOjDFmZHM
	 omZpYo0faQbaReFB5cU18X4oWTfRm6yiqOQzkNlWazazJLqkONt+/3KbQyZEP0a5+rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581027;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=svm7yixRXtyszjfWrFTUagcpLvrETnPBpTtC9/J/nhY=;
	b=J9DTcZL9HioWcCEa+yQwtaPKJ0nMGF3qF1mpBX15B2aliHoWH9hNO2f0xKGPN9UOJUqI
	 SA0GEugJ1xerq1GhgvHi8/a6hhaLBUOc7z0JXpBYVYAzyrEIQhJ/SU92E3KJG0NLnenbl
	 q9wAsedGLW3DF6d5TIgtkV8rCg5CCJvW8/MgRt6/I96Hq0/pTTOBx69UyvOfh12RxzKIs
	 e9DFKGZvO7hn6ASq0iSWxL1Za2OrWt08N1xWV7w5bAW/xElvbMt6nON7PrUsXzAYaDNCH
	 An1iwaeXL4qHuu77HZxprUOWMTREr7vyswCB+InNlhfbMgawLpl6vZbfH7c9IVnP5Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=jSs5+7p7;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FBF606A329;
	Mon,  2 Nov 2026 00:57:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1FBF606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=jSs5+7p7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793581024;
	bh=svm7yixRXtyszjfWrFTUagcpLvrETnPBpTtC9/J/nhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSs5+7p7YyCbrMbzCeYiezNJP+5LpeLFGuwBg3HH3uTYgWqO6DbnySUMhzpXHWkuV
	 T6PBjl/hPaiWX4bICacQM66PosT/E27FQ0AeSC8xkjyRZ6dsKpkh1OdkisL8XV4rIo
	 IvlkQIJoUUbi/+GvwdjH6dugQ5coD3nCYn6fvAUnWTSlYNSwMfrHZbuxcyet4RfBr0
	 6GtKkC39cMpcTzC/gHE/OJkWehxs5mfx+w+PqlRlfjDBVQGFnixZEHStQAZQ1TVUpD
	 L+uPC0qDGBy+PmOd7HElM/8mpe06KXoDbZOn5JXGJ1EONJQMOo6ABKt9U6Y3Y26nXG
	 ddAxcl85IQw/g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 92F2460074;
	Mon,  2 Nov 2026 01:57:03 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 01/15] netfilter: nft_reject: prevent unbounded recursion in output hooks
Date: Mon,  2 Nov 2026 01:56:40 +0100
Message-ID: <20261102005654.532438-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102005654.532438-1-pablo@netfilter.org>
References: <20261102005654.532438-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

nftables payload-mangling rules can rewrite packet contents (such as TCP
flags) before they are evaluated by reject targets. This defeats the
content-based loop guards, allowing unbounded hook recursion that leads
to kernel stack exhaustion and panics.

Fix this by extracting the per-CPU xmit recursion limit previously used
by the netdev duplication/forwarding paths into a shared header, and
apply it to the inet and inet6 reject transmit functions. It disables BH
while transmitting the skb to address a possible migration to different
CPU leading to imbalanced decrementation of the recursion counters.

Note that the dev_queue_xmit() path used when CONFIG_BRIDGE_NETFILTER is
enabled does not require this recursion guard. In that scenario, the
generated reset packet is transmitted directly at Layer 2. Because the
packet egresses from a different hook, it cannot synchronously loop. In
addition nf_send_unreach() and nf_send_unreach6() are safe as the ICMP
transmit functions are protected against recursion by the
icmp_xmit_lock() and icmpv6_xmit_lock() guards.

Reported-by: Yu Junzhe <junzheyu1@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/20260921061320.543-1-junzheyu1@gmail.com/
Fixes: bee11dc78fc8 ("netfilter: nft_reject: support for IPv6 and TCP reset")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice_xmit.h        |  4 +--
 include/net/netfilter/nf_dup_netdev.h | 35 ----------------------
 include/net/netfilter/nf_recursion.h  | 42 +++++++++++++++++++++++++++
 net/ipv4/netfilter/nf_reject_ipv4.c   | 12 ++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c   | 13 +++++++++
 net/netfilter/nf_dup_netdev.c         |  1 +
 net/netfilter/nft_fwd_netdev.c        |  1 +
 7 files changed, 71 insertions(+), 37 deletions(-)
 create mode 100644 include/net/netfilter/nf_recursion.h

diff --git a/include/linux/netdevice_xmit.h b/include/linux/netdevice_xmit.h
index cc232508e695..286ae5a6101e 100644
--- a/include/linux/netdevice_xmit.h
+++ b/include/linux/netdevice_xmit.h
@@ -18,8 +18,8 @@ struct netdev_xmit {
 	u8			sched_mirred_nest;
 	struct net_device	*sched_mirred_dev[MIRRED_NEST_LIMIT];
 #endif
-#if IS_ENABLED(CONFIG_NF_DUP_NETDEV)
-	u8 nf_dup_skb_recursion;
+#if IS_ENABLED(CONFIG_NETFILTER)
+	u8 nf_xmit_skb_recursion;
 #endif
 };
 
diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index f6b05bd80c3f..a39411264614 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -9,41 +9,6 @@
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
-#define NF_RECURSION_LIMIT	2
-
-#ifndef CONFIG_PREEMPT_RT
-static inline bool nf_dev_xmit_recursion(void)
-{
-	return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
-			NF_RECURSION_LIMIT);
-}
-
-static inline void nf_dev_xmit_recursion_inc(void)
-{
-	__this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
-}
-
-static inline void nf_dev_xmit_recursion_dec(void)
-{
-	__this_cpu_dec(softnet_data.xmit.nf_dup_skb_recursion);
-}
-#else
-static inline bool nf_dev_xmit_recursion(void)
-{
-	return unlikely(current->net_xmit.nf_dup_skb_recursion > NF_RECURSION_LIMIT);
-}
-
-static inline void nf_dev_xmit_recursion_inc(void)
-{
-	current->net_xmit.nf_dup_skb_recursion++;
-}
-
-static inline void nf_dev_xmit_recursion_dec(void)
-{
-	current->net_xmit.nf_dup_skb_recursion--;
-}
-#endif
-
 struct nft_offload_ctx;
 struct nft_flow_rule;
 
diff --git a/include/net/netfilter/nf_recursion.h b/include/net/netfilter/nf_recursion.h
new file mode 100644
index 000000000000..1ac65f7793f1
--- /dev/null
+++ b/include/net/netfilter/nf_recursion.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_RECURSION_H_
+#define _NF_RECURSION_H_
+
+#include <linux/netdevice.h>
+
+#define NF_RECURSION_LIMIT	2
+
+#ifndef CONFIG_PREEMPT_RT
+static inline bool nf_dev_xmit_recursion(void)
+{
+	return unlikely(__this_cpu_read(softnet_data.xmit.nf_xmit_skb_recursion) >
+			NF_RECURSION_LIMIT);
+}
+
+static inline void nf_dev_xmit_recursion_inc(void)
+{
+	__this_cpu_inc(softnet_data.xmit.nf_xmit_skb_recursion);
+}
+
+static inline void nf_dev_xmit_recursion_dec(void)
+{
+	__this_cpu_dec(softnet_data.xmit.nf_xmit_skb_recursion);
+}
+#else
+static inline bool nf_dev_xmit_recursion(void)
+{
+	return unlikely(current->net_xmit.nf_xmit_skb_recursion > NF_RECURSION_LIMIT);
+}
+
+static inline void nf_dev_xmit_recursion_inc(void)
+{
+	current->net_xmit.nf_xmit_skb_recursion++;
+}
+
+static inline void nf_dev_xmit_recursion_dec(void)
+{
+	current->net_xmit.nf_xmit_skb_recursion--;
+}
+#endif
+
+#endif /* _NF_RECURSION_H_ */
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 7cb33af671e2..4082fa184af8 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -10,6 +10,7 @@
 #include <net/dst.h>
 #include <net/dst_metadata.h>
 #include <net/netfilter/ipv4/nf_reject.h>
+#include <net/netfilter/nf_recursion.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_bridge.h>
 
@@ -336,7 +337,18 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		dev_queue_xmit(nskb);
 	} else
 #endif
+	{
+		local_bh_disable();
+		if (nf_dev_xmit_recursion()) {
+			local_bh_enable();
+			goto free_nskb;
+		}
+
+		nf_dev_xmit_recursion_inc();
 		ip_local_out(net, nskb->sk, nskb);
+		nf_dev_xmit_recursion_dec();
+		local_bh_enable();
+	}
 
 	return;
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5e08d8529cc8..7c9464184517 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -10,6 +10,7 @@
 #include <net/ip6_checksum.h>
 #include <net/dst_metadata.h>
 #include <net/netfilter/ipv6/nf_reject.h>
+#include <net/netfilter/nf_recursion.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
 
@@ -409,7 +410,19 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		dev_queue_xmit(nskb);
 	} else
 #endif
+	{
+		local_bh_disable();
+		if (nf_dev_xmit_recursion()) {
+			local_bh_enable();
+			kfree_skb(nskb);
+			return;
+		}
+
+		nf_dev_xmit_recursion_inc();
 		ip6_local_out(net, sk, nskb);
+		nf_dev_xmit_recursion_dec();
+		local_bh_enable();
+	}
 }
 EXPORT_SYMBOL_GPL(nf_send_reset6);
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index c6bd5c29bed6..918716629c15 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -12,6 +12,7 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
+#include <net/netfilter/nf_recursion.h>
 
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index a48c2f765bba..7447da931a95 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -14,6 +14,7 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
+#include <net/netfilter/nf_recursion.h>
 #include <net/neighbour.h>
 #include <net/ip.h>
 
-- 
2.47.3

