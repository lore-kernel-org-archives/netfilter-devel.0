Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442099;
	b=q5Xi3BmqcqHPLxNjnt66EHFI51Al1xlMRBOGBvrtE7t+aYd1mUkcgJ42u/FHh/SVTJAY
	 I29bnKt6pmTe1fk52YIX0FydPy/EgZwg5Uo3wYLpRjuSrhG/yiV3vlq6AWwG0k4I/Aiub
	 GBiUAipZ2otEsrAQSQg36Td7F4LBbxsZbyofFfZv2Ait0J4drtSiRZgMF+ho4bYqheVdS
	 NvUJcWcDJSeqWyZNNBQfhkVOxuOLuIFOPSsMrfQwDVcA/0Mqmlvd7dnikWWcM+T0LEtie
	 keEHYjDvykEVBUcmnrgO2yquV+rELUQM7m76qogqG2JyUPAaNFEMPFUQr+vMIXIbL/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442099;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=AA4fx4lDCt5leFEiOrXr/Cid5thLv1iEHkPCdAP/j/U=;
	b=wFJCOgqEGYGfy0rRsfMYYYxxYKIUEOjBeeKCuhPmmExNcDodiSvJkSSOFUDYarqjcjm3
	 lW97aDpXB+mT+UmJ5rs1yY3N5KuFN2F+maXrgH1LtzoP0PujWSNEpsgKMhnrVedL0cQO6
	 AwmzjIphTSm3gnSTzl0RLH12VhdWjYFWBdKSi0IUgidq2vr9yIaLgsKD3CR6E2P5D3C+t
	 ecAxg0O3tJ84YMF3nek73ZhLmPQucHEJ2WZPCkARA2Ef7LGBk/eZKVsRdBVHQgMVXSn1m
	 Pom4Jp/Siy28MjVdrtGaxnG1wn8v3JOGj/SZx+Gbs4flIA6h0q1ZCf7XzuZy1eiVbGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZIJIur1T;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF415606A32A;
	Mon, 23 Nov 2026 13:54:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF415606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZIJIur1T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442097;
	bh=AA4fx4lDCt5leFEiOrXr/Cid5thLv1iEHkPCdAP/j/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIJIur1TsdyFAo119L7yHVwDWVwgEZ9MFFxoKlOioAxGXGJyNnHKuSfrW1/oNgUVs
	 hm4pvsQkHmS/h7YjdiweInM5V2hBDxtu+0QMfbDslYMiP1V80ObR8pmW84LdiY0GoS
	 Q+L4kCmz8djZCAMISvKK202tVQhhwiWBVfNeIKS13CeAH64LV7lgdUTn76p2PXpw8j
	 BgFwmhAZf95jUTSC2mFmfwYGL+RAgs5QNr8PB1X8TB7m8sHNKKuv+wp0sRxtjO5zlT
	 O1b+REtODPY9fqr9EIbKjXcLbXKGRet08NTSYm7jGxNM5ae9oB3Qr3Z2QMCpVYX8gc
	 ETh2rT1KdKMAA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A1AFD6008E;
	Mon, 23 Nov 2026 14:54:56 +0100 (CET)
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
Subject: [PATCH net-next 06/15] netfilter: conntrack: harden helper invocation with tuple revalidation
Date: Mon, 23 Nov 2026 14:54:33 +0100
Message-ID: <20261123135442.3940372-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135442.3940372-1-pablo@netfilter.org>
References: <20261123135442.3940372-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

Complete hardening of the connection tracking helper invocation sequence
initiated in the previous refactoring commits.

1. Tuple Verification: Extracts the *current* tuple from the packet and
   verify it matches the connection tracking entry's tuple.
   This prevents helpers from being invoked on packets that may have been
   modified after the initial connection lookup, e.g. via act_ct ->
   pedit.  This also prevents the helper from operating on ICMP(v6) PMTU
   errors.

2. TCP Header Sanity: For TCP traffic, the patch introduces a check to
   ensure a full and sane TCP header is present.

Also adds missing 'nhoff' to ipv6_skip_exthdr(), this would be required
for conntrack over bridges.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto.c | 43 ++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 18125aa29e0d..43bf3a71dbbf 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -136,6 +136,9 @@ static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
 				   enum ip_conntrack_info ctinfo,
 				   unsigned int *protoffp, u8 *pnum)
 {
+	unsigned int nhoff = skb_network_offset(skb);
+	struct nf_conntrack_tuple tuple, invert;
+	enum ip_conntrack_dir dir;
 	unsigned int protoff;
 	__be16 frag_off;
 	int start;
@@ -144,12 +147,13 @@ static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
 	case NFPROTO_IPV4:
 		if (ip_is_fragment(ip_hdr(skb)))
 			return false;
-		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
+		protoff = nhoff + ip_hdrlen(skb);
 		*pnum = ip_hdr(skb)->protocol;
 		break;
 	case NFPROTO_IPV6:
 		*pnum = ipv6_hdr(skb)->nexthdr;
-		start = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), pnum, &frag_off);
+		start = ipv6_skip_exthdr(skb, nhoff + sizeof(struct ipv6hdr),
+					 pnum, &frag_off);
 		if (start < 0 || frag_off)
 			return false;
 
@@ -160,6 +164,41 @@ static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
 		return false;
 	}
 
+	if (protoff > skb->len)
+		return false;
+
+	if (!nf_ct_get_tuplepr(skb, nhoff, nf_ct_l3num(ct), net, &tuple))
+		return false;
+
+	dir = CTINFO2DIR(ctinfo);
+	if (!nf_ct_invert_tuple(&invert, &tuple))
+		return false;
+
+	/* This is called after L3/L4 headers have been mangled by NAT:
+	 * Packet in original direction has been subject to SNAT, i.e.
+	 * inverted reply dir.
+	 * Packet in reply direction has been subject to DNAT, i.e.
+	 * inverted original direction.
+	 */
+	if (!nf_ct_tuple_equal(&invert, nf_ct_tuple(ct, !dir)))
+		return false;
+
+	/* Validate that a full, sane TCP header (including options) is
+	 * present at protoff before helpers/seqadj are allowed to touch it.
+	 */
+	if (tuple.dst.protonum == IPPROTO_TCP) {
+		unsigned int tcplen = skb->len - protoff;
+		const struct tcphdr *th;
+		struct tcphdr _tcph;
+
+		th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
+		if (!th)
+			return false;
+
+		if (th->doff * 4 < sizeof(*th) || tcplen < th->doff * 4)
+			return false;
+	}
+
 	*protoffp = protoff;
 	return true;
 }
-- 
2.47.3

