Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE082046BA;
	Sun, 23 Mar 2025 10:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742724582; cv=none; b=hkcu+GixcryrC15ZRRTL9omGt/k6pnnqlqHWvKmKg3MCW5tCb7dv4RBEf1XcyqB69Z8sERlTTYom4upHATCeIIqTMVeRlNlD2/T7qb0UG+5/MbJeiNNMQsb+Q4wG7/OkaTm4KKWmA02oLhgy2QG9FHrRMfFW29m43GNoufVk1j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742724582; c=relaxed/simple;
	bh=skjBFm4VsHvUy4ROh29RH8vR06Jp+tpdNcfEaHTYunQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hKVmdbuX/bY8wVrg2pstcbwoMdqv3JQBiUuskusaQc9h6vHSNvL8IDMtAZdsKRqqY11+2UAF1IaJtAzp1gs3sIeRiD2d6HO5aSz+KaDikgzYzlX5GJBBTX5lxihtIIZovHYDQBfhELd1FVP89l63AmKwB1iSoC9dG9QJ/O7WQ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eizaFSTr; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fa8piBQm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eizaFSTr";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fa8piBQm"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DEAA060368; Sun, 23 Mar 2025 11:09:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724578;
	bh=omr6ZM2zjx54mM6ySJGjmMyiPaprG3/GDWWt7yMXFEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eizaFSTrMTst3QIZQ7+97eoYLewW9Cm0ZZ8AE2i9rsX18IAYP0Wd2ecrAjhrXbOoK
	 h5Tx2OW+62Y2llDEsr9fSYu39ldx/ujU282l/YPGkiC2/LcvI9AQr2N6V6Rr4G3mEZ
	 uq1AMV2bENuiSbUunk6VAfo626Jup/OmXo9u6/pIZQN2GpuJxUdFmVfnldAhMOe0CY
	 8fB6cL/6mo/stG9Z6qsvlglRQXyy1PsnNGRtz6FP/tJSQ9+USmhMbmLF1zDwY1858y
	 pBhzkkazsoomTUDvWx5ZHbePFiEgzQ1vM7pW4TgdCGNSRUBOG3KLflgmOJcGwWns8C
	 li004t0NIn89w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D87CC60390;
	Sun, 23 Mar 2025 11:09:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724571;
	bh=omr6ZM2zjx54mM6ySJGjmMyiPaprG3/GDWWt7yMXFEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fa8piBQm7Q7G/Hq73YDFSpatestCnYZYGEcOxRCxxzYe9NgjnqxGW0CFwTfbYtknh
	 JIi/qhSyfo18PukOVZNNpy0ihk6c2znZd51YZbpqaGzdXtFCsQeOlWdcN89vdq37lc
	 b7cQuAv+dnJkVRPz8plbHRMuKWRs0JZo0r4R4QEdVtsoy5i1em9/GMvwh0AXUu1V4O
	 PJNmVNnP0AhMr7mDVs4Hzey663nGk6LYNkn5b2vPONIfw79giagMeXO/7Z/vmwi+Db
	 N+Z4KO62eee/5r1UmtRN+Ge9k1QBiAIxX5eGk7Dh2p21ZAqiPNwond7PlGRZrYmBiU
	 VR5SGZjALPkbg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 6/7] netfilter: socket: Lookup orig tuple for IPv6 SNAT
Date: Sun, 23 Mar 2025 11:09:21 +0100
Message-Id: <20250323100922.59983-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250323100922.59983-1-pablo@netfilter.org>
References: <20250323100922.59983-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Maxim Mikityanskiy <maxtram95@gmail.com>

nf_sk_lookup_slow_v4 does the conntrack lookup for IPv4 packets to
restore the original 5-tuple in case of SNAT, to be able to find the
right socket (if any). Then socket_match() can correctly check whether
the socket was transparent.

However, the IPv6 counterpart (nf_sk_lookup_slow_v6) lacks this
conntrack lookup, making xt_socket fail to match on the socket when the
packet was SNATed. Add the same logic to nf_sk_lookup_slow_v6.

IPv6 SNAT is used in Kubernetes clusters for pod-to-world packets, as
pods' addresses are in the fd00::/8 ULA subnet and need to be replaced
with the node's external address. Cilium leverages Envoy to enforce L7
policies, and Envoy uses transparent sockets. Cilium inserts an iptables
prerouting rule that matches on `-m socket --transparent` and redirects
the packets to localhost, but it fails to match SNATed IPv6 packets due
to that missing conntrack lookup.

Closes: https://github.com/cilium/cilium/issues/37932
Fixes: eb31628e37a0 ("netfilter: nf_tables: Add support for IPv6 NAT")
Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_socket_ipv6.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index a7690ec62325..9ea5ef56cb27 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -103,6 +103,10 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 	struct sk_buff *data_skb = NULL;
 	int doff = 0;
 	int thoff = 0, tproto;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn const *ct;
+#endif
 
 	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
 	if (tproto < 0) {
@@ -136,6 +140,25 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 		return NULL;
 	}
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	/* Do the lookup with the original socket address in
+	 * case this is a reply packet of an established
+	 * SNAT-ted connection.
+	 */
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct &&
+	    ((tproto != IPPROTO_ICMPV6 &&
+	      ctinfo == IP_CT_ESTABLISHED_REPLY) ||
+	     (tproto == IPPROTO_ICMPV6 &&
+	      ctinfo == IP_CT_RELATED_REPLY)) &&
+	    (ct->status & IPS_SRC_NAT_DONE)) {
+		daddr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.in6;
+		dport = (tproto == IPPROTO_TCP) ?
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port :
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
+	}
+#endif
+
 	return nf_socket_get_sock_v6(net, data_skb, doff, tproto, saddr, daddr,
 				     sport, dport, indev);
 }
-- 
2.30.2

