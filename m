Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442263;
	b=f4Xd3vthQbPwwEiRuwdm8WJ+VkI3B57B/25f4SIxfg01TyJpeiO4rVynwIJXWuhVGxJW
	 rVTmiecVkK6dn2Ee12JmJBG7kjQg8VMv3kAsvcKe2QI3ne1uAz14bFodxtUBDh5ZhiC1v
	 hbOxnxROwvQ8oX2iiM3GN3yug7nubCTSjYYhsx8fiLRDmB58HhjkGCtj9jsh8KnN0axu4
	 Jwp4Z3TfVn4KD98BJgLUu67g0yrX+KhXeIUnS+0a6PevR6X3ky16Y6SSRUfMYjEYz/zgR
	 3VNKto4xbqnJsD2UHmDE/Bmwg+FIYxIKor1YKcEnvX6qJA/WJWCdeIdW5fUfezEwnqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442263;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=AA4fx4lDCt5leFEiOrXr/Cid5thLv1iEHkPCdAP/j/U=;
	b=2GXJ68RUYl/A/LdTL4/ZAxncNT90z01SwgExI00HW3pDeumthveO7Y1ZgfWcyytpzKxr
	 ZjkQ68eZhZglwHsL24YZZc4ULYxNlE/SdC09/Vabco8vSLkB9PRrdOKMwAvC7sl9YW9cb
	 6LyGvYXung8LVywK4xM1sKzlmdVnKdAgTBNWVq0sSsS9NBxjInlZgX0Jlk7FMjzu5+rlK
	 yoYRx+geENi/9vygHyRzeCcWMmkTZgA27JXEtjWbVOYrw85THF1c6tbe8m9LDaD0waPnZ
	 AW8Zq5DvKRq5iOnW6R22kGhsqSE0fhIRPk0SIQm5SJ6f/AUxLjFbUYIS0ny5ucZRaLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TgyunjCn;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C40C606A68D;
	Mon, 23 Nov 2026 13:57:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C40C606A68D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TgyunjCn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442260;
	bh=AA4fx4lDCt5leFEiOrXr/Cid5thLv1iEHkPCdAP/j/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgyunjCn3NLHsKX29HuuiiFb5j3JwsxeLSuUq82u/iqqU0kqLOeRboku1A1zFbRh5
	 rwZ7Re86fdmcwHfCwmkdQxVqwCPolPKd8MpwalKv8ukCprAGtibN3vU1zJJimUmC6h
	 YCwhca/kZjucKmJyOHLl66OIAwHg3JDA1RQtla+5tccsgGEP6nmjdW90CI6il7ldfp
	 CF1UfXY2b5gy9EXtzTGBaokcEBPPF2ITUN9ulZEMn+mK4UYVeLys72GMCS9xx5b2f2
	 YM7p7yE4GJwgNQ8/qfW7SDmQtH9iL5Mq4DU6v07jzHWf+k+IW3qEoFevJJbw9hfUGM
	 R6cOYo+uySZpw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BE796602F1;
	Mon, 23 Nov 2026 14:57:39 +0100 (CET)
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
Date: Mon, 23 Nov 2026 14:57:17 +0100
Message-ID: <20261123135726.3940688-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135726.3940688-1-pablo@netfilter.org>
References: <20261123135726.3940688-1-pablo@netfilter.org>
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

