Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41323D300F
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2026 12:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856414; cv=none; b=tMEIU3OcneQnFXvrWtP0SBUXsfHYYjj2IvSVbp7Wnj7NAUf3oB9O3IjPKra743P7lcaGuwnU01ja30IgwwYGtL9LEBZFki/I2yK8r8e9oF51vPUvNqBwQ21Hf0gA3EAm1wJLrh3Nh8ucp+zPXgK+o96cfkz+KWHdt1xpnVkn08U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856414; c=relaxed/simple;
	bh=2YBRdRdHEtq+228X0+UyJ2SrefFkt5hvJVNcshk6Bkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oc+RhRLZ6RFUpQegroDLYaK3MbX7DZnAZP+kJB14wseWAB8QbYhB4W+XAMsUhWGgnw77FhYU+SwnAmtearom8s0kP6ASbANRcWO0r407IeUn2MppMECYEeI58SwMLaVg+kLPL1oK+1DOI+BIocug2LJmMGwHVYrcAoGf1U36970=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3D364609A0; Thu, 01 Oct 2026 14:06:40 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: add nf_sk_to_full_sk helper and use it
Date: Thu,  1 Oct 2026 14:06:21 +0200
Message-ID: <20261001120625.29659-3-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001120625.29659-1-fw@strlen.de>
References: <20261001120625.29659-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some callers of these helpers pass skb->sk as sk_partial argument, but
for LOCAL_OUT path an IP tunnel transmits while preserving the original
skb owner, so a non-INET socket (e.g. PF_PACKET) can reach these.

Like previous patch, add a helper to also check for this case.
Related to LLM finding in the earlier patch when querying the agent about
other possible scenarios.

Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.55.0

