Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7875513573
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 13:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650600; cv=none; b=kR38PskdKubp/K3vA52cW8WfkNU9/wl7nrzv/qtn2ibnjiL6jJZvQHv7H88iuV/cXebgvPuU5kqzlmkos7dzbaTjJSpfBLYb/Cxubr8r/ihulfpAOLWtXSMMm3jmJbhgWWuFDYCPADPbEIpYEbOOeAVc3KXuQSlhdJZCwATqQa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650600; c=relaxed/simple;
	bh=qAovel8i5+AhwdLvO5TWTg1dd1QDXPfj6Bv57IjN8nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp7uWzVA8Woe/dKRfhPxFca7aoZgfw/37WziLoGnzKjB+0rkTDdCO3+7YkOPAARwLeQgwo0RybdAcr4GTB9FTto8gaHrb9UYSH77Urnn3/TKYJnsQeVi0Dj+TGh7fB146R7Ls/JnNJh92MSelSpSUodyeMjoXYv25zpIxEyB9kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 154DF60301; Thu, 17 Sep 2026 15:09:51 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 5/6] netfilter: nf_conntrack: harden helper invocation with tuple revalidation
Date: Thu, 17 Sep 2026 15:09:21 +0200
Message-ID: <20260917130922.17699-6-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917130922.17699-1-fw@strlen.de>
References: <20260917130922.17699-1-fw@strlen.de>
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

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto.c | 34 ++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 18125aa29e0d..b4e812268fe6 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -136,6 +136,8 @@ static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
 				   enum ip_conntrack_info ctinfo,
 				   unsigned int *protoffp, u8 *pnum)
 {
+	struct nf_conntrack_tuple tuple, invert;
+	enum ip_conntrack_dir dir;
 	unsigned int protoff;
 	__be16 frag_off;
 	int start;
@@ -160,6 +162,38 @@ static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
 		return false;
 	}
 
+	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), nf_ct_l3num(ct),
+			       net, &tuple))
+		return false;
+
+	dir = CTINFO2DIR(ctinfo);
+	nf_ct_invert_tuple(&invert, &tuple);
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

