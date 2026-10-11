Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E989405C3F;
	Sun, 11 Oct 2026 22:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756025; cv=none; b=E9yYnMT/oPh1W9TCkippx3voq2L1OYvvEp8qtghZ8lP/sIp2TQWHltl0PhJqmdvoYykrFuGTxmIxymcuAnD39bRZQ63YPNrTUVlGYNHeeiqvsniceX1maj/yKmfslRXQC8wUk9Bn1I8sycGCDLR6NmMLJCLIRCGYnDrcbBrqNoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756025; c=relaxed/simple;
	bh=wpqZcOSN8P8I2cTi+q6eqkJZ1tsuGgLLwIVjn6bBLdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+5SScj7IrnxbLClON8kDexoxWPx4oS7Z+xIU+NNYTVkh7r6LrBefFaYE5zPMDzkJrCMIBFeOFeGioDpTLlXdAEW87nYtXg+A2zniQnIAQUDEiNDJcr/bUpRTFhDdX0XKSBwq9bbUA5ZDuk0nBY4QF4aCbu5/5YDSr8rLq0FQgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vAUT8ksc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vAUT8ksc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756022;
	bh=1jRl6mH7+GAgMEP9S5ESOvvjemmgsmKemDkh+g7Y2fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAUT8kscN/aIB56mGyjcuvGk9WPC7UMAQ+SjTL2ikzOvFThJRfLo061W1HwXQcA+/
	 N+pb6//vGH4GohOwpFGhn/DDAznZ6XhgJ1hutEd+7lHDdpmELdH7RZCcuHIsqQzuMV
	 6ZSvaveKUV24/MhEfiHelw0f7Sbb9DwGoe9vRY7aI5cpf9I1mV40TlPGZq5bBJV8Rp
	 eGtZwzG0DHXk1bnPums8Q0ABtk88yA17hOk9ICsO3vba+aV7aVljNiGHBQmKS2ikFC
	 77bFpGtruZ2SqjqYWkU5IVfgicYcMSFNT12Ibb6ZWV9oAtdrNF2GTjK1JwpBlDa0N6
	 aS8LeYd6R3oQA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8843160085;
	Mon, 12 Oct 2026 00:00:21 +0200 (CEST)
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
Subject: [PATCH net-next 13/15] netfilter: add nf_sk_to_full_sk helper and use it
Date: Sun, 11 Oct 2026 23:59:51 +0200
Message-ID: <20261011215953.1334630-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261011215953.1334630-1-pablo@netfilter.org>
References: <20261011215953.1334630-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Some callers of these helpers pass skb->sk as sk_partial argument, but
for LOCAL_OUT path an IP tunnel transmits while preserving the original
skb owner, so a non-INET socket (e.g. PF_PACKET) can reach these.

Like previous patch, add a helper to also check for this case.
Related to LLM finding in the earlier patch when querying the agent about
other possible scenarios.

Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_socket.h | 15 +++++++++++++++
 net/ipv4/netfilter.c              |  3 ++-
 net/ipv6/netfilter.c              |  3 ++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_socket.h b/include/net/netfilter/nf_socket.h
index 39047c73b642..f7da3dc150a9 100644
--- a/include/net/netfilter/nf_socket.h
+++ b/include/net/netfilter/nf_socket.h
@@ -3,6 +3,7 @@
 #define _NF_SOCK_H_
 
 #include <net/sock.h>
+#include <net/inet_sock.h>
 
 struct sock *nf_sk_lookup_slow_v4(struct net *net, const struct sk_buff *skb,
 				  const struct net_device *indev);
@@ -30,4 +31,18 @@ static inline struct sock *nf_skb_sk(const struct sk_buff *skb, const struct net
 
 	return NULL;
 }
+
+/**
+ * nf_sk_to_full_sk - Careful access to a full socket
+ * @sk: pointer to a socket
+ *
+ * %sk_to_full_sk for use when sk might not be an inet socket.
+ */
+static inline struct sock *nf_sk_to_full_sk(struct sock *sk)
+{
+	if (sk && sk_is_inet(sk))
+		return sk_to_full_sk(sk);
+
+	return NULL;
+}
 #endif
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index ce9e1bfa4259..76e1eb40b8ce 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -17,6 +17,7 @@
 #include <net/xfrm.h>
 #include <net/ip.h>
 #include <net/netfilter/nf_queue.h>
+#include <net/netfilter/nf_socket.h>
 
 /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
 int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, unsigned int addr_type)
@@ -30,7 +31,7 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 	struct flow_keys flkeys;
 	unsigned int hh_len;
 
-	sk = sk_to_full_sk(sk);
+	sk = nf_sk_to_full_sk(sk);
 	flags = sk ? inet_sk_flowi_flags(sk) : 0;
 
 	if (addr_type == RTN_UNSPEC)
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index a7025ec87035..70e47ccdf9ae 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -17,14 +17,15 @@
 #include <net/ip6_route.h>
 #include <net/xfrm.h>
 #include <net/netfilter/nf_queue.h>
+#include <net/netfilter/nf_socket.h>
 #include <net/netfilter/nf_conntrack_bridge.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include "../bridge/br_private.h"
 
 int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff *skb)
 {
+	struct sock *sk = nf_sk_to_full_sk(sk_partial);
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
-	struct sock *sk = sk_to_full_sk(sk_partial);
 	struct net_device *dev = skb_dst_dev(skb);
 	struct flow_keys flkeys;
 	unsigned int hh_len;
-- 
2.47.3

