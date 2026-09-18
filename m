Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0923503BDB
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 15:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746024; cv=none; b=FbAtbYjFtwmyOkJhQ8w5eUE7rEOfM0+2ceCsLD3/kL4px1NRNhbwJx0iOXU0JNkUUOo3FYhaYfsaIr2Ajv4tYkNqZrQh8c/CvHVa2ruCeTDxssPC4Vpxxl94YDzCOeCzTqCE0D/oCI8jsAbVaI7UFGhNjGLCDMv9BEpJiNMGZvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746024; c=relaxed/simple;
	bh=DR1uBShS1gITmgVDkxfYQuF3F5F6x/Un7PDP5UutdeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LP+Gbx5SUtfaH0YerWKkZAX4IaI4mDuIZo5ovAu3IXn1MnieDst5l+a4RlXq7SKeB1tQZXbaKqot1uk8CNsdc2+xeghoMnDbhgQ5LmBi0dTz+UNFeQozlwSgDH5uEmPc1y6ihgivBJ+8tDM5rH6lXAmrrfnz4/b5UYQUySE8sw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DA6D76060B; Fri, 18 Sep 2026 17:40:11 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf 5/6] netfilter: nf_conntrack: harden helper invocation with tuple revalidation
Date: Fri, 18 Sep 2026 16:58:08 +0200
Message-ID: <20260918145809.12938-6-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918145809.12938-1-fw@strlen.de>
References: <20260918145809.12938-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 v3: also add nhoff in ipv6.  LLM reports this even though its unrelated
 and we never got bug reports about this. Also add nf_ct_invert_tuple
 return value check and refuse huge protoff sooner.

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
2.55.0

