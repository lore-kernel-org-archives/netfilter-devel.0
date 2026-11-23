Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442257;
	b=rBk3Pk4+Q9B/z0dO+AQvjw6q2Ik8iiRxqnfw6AxIu1fWDznlzaX88yd0MDLH3Wg3wONk
	 LmTFkmr+81KHlwDoJRCv8GgUFBheKU7FSL95liR+v6McHsLEQjQK5jsDd6Ml6juluf0+o
	 NqgUEg4hI8PiXJhForjGmznOHIPrB6ecjHftRjo7OZDHXzIeIxMuBTH1J+CXusBnCJ/U2
	 o3WVzgJ6SJUStDAuueTYtYFO15X2zP3bnEXC0n16xt7gQzFV+/lurXrYnbM/IavS1OOAZ
	 GnMtuxBPZkzgSxAW0w2HpB14Ir4Annr2Lc32RCji7W20T5Y4wJ7MVqJm1ZUplciHSgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442257;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=YFJFjFirhx/34BcB7cCQsViWbtFZs/0Tgahs3R9V0sg=;
	b=W4EN5D+KmiCYxBBHcDBq2yQbzhpsLgfI5nqN70VO/kSe/4aPmYHSlMXOzdaeK7YIaISH
	 Dvjo+CourLIHMwuRDGwoJWN7YCl/IhNleyWY0Bg97znKzGyoz0jMyoEPPz5L9x+wI5Zeb
	 lF2SRgueURrDXz7O50YOxUbjaV5BwooHtOfC8zP8oaOxGLeAGAIFwOhA05Wk6Xt5lGXQX
	 meSsk2h7YA6Ng5nlXaqGgoe2KSfLOHD3BU1jhM1tzDI8BwOwiX2SknrQY5oNLlMDSf1Hf
	 ORwt+zx2mOUlItsOaXYyhmPnkFjBdN+3+whqp8oKmfqBq+rlfyi7kNAetJuG7jN/j6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=DDW8v9UO;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EF9606A68E;
	Mon, 23 Nov 2026 13:57:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50EF9606A68E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=DDW8v9UO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442255;
	bh=YFJFjFirhx/34BcB7cCQsViWbtFZs/0Tgahs3R9V0sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDW8v9UOJrWa9ugWjUPSJwb++Ij3YTCcLcHkBSakMyo2B2gNx874R5kon9SjNSRjj
	 Kii9qV2+ESwnQ2gboU99JYTT83cNp07Ahg2pqsXDTTl2pf49uh2hVfIPhjiWzZoIxc
	 EmTkVCRlFfJOMoJTf3R2OeNjb5gGlXwaalVAScuVQuC8E6bEjTslNPCSyUG7OF0oOQ
	 OCMtK1E8hTHTbd88WC6KV1G8lnCu/LtzI1h1AqJ4Lb35zwFMowWR+pEtYeiRk+FsQj
	 AqEA+OtTTD2guEawkPiYpKlDgV8XGm7JZQOX17RXV777lKu+0wkdXZsQGAQc0W3WPd
	 MT6YOuod1HDPA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D2929602ED;
	Mon, 23 Nov 2026 14:57:34 +0100 (CET)
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
Subject: [PATCH net-next 03/15] netfilter: conntrack: refactor helper call logic in nf_confirm()
Date: Mon, 23 Nov 2026 14:57:14 +0100
Message-ID: <20261123135726.3940688-4-pablo@netfilter.org>
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

The current implementation of nf_confirm() handles several distinct
tasks: retrieving the connection, calculating protocol offsets for
different network families, and executing the associated helpers or
sequence adjustments.

Move functionality to extra functions:

1. nf_confirm_get_protoff(): Isolates the logic for determining the
   protocol offset (protoff) for IPv4 and IPv6 packets.
2. nf_ct_call_helper(): Encapsulates the decision-making process of
   whether to call a connection tracking helper or perform sequence
   adjustment, utilizing nf_confirm_get_protoff() to find the correct
   offset.

NF_CT_STAT_INC_ATOMIC() is now incremented for any NF_DROP, earlier
this was elided in some cases, IMO that was a bug all along.

Followup patches will extend these new functions with stricter checks.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h |   2 +
 net/netfilter/nf_conntrack_proto.c          | 113 +++++++++++++++-----
 2 files changed, 87 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 335b8c43694f..4b5ee758cff3 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -124,6 +124,8 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 
 int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 		 enum ip_conntrack_info ctinfo, u16 proto);
+int nf_ct_call_helper(struct sk_buff *skb, struct nf_conn *ct,
+		      enum ip_conntrack_info ctinfo);
 int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
 		     u8 proto, bool nat, struct nf_conntrack_helper **hp);
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 7a40e4e0e33e..32f900c155de 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -131,36 +131,16 @@ static bool in_vrf_postrouting(const struct nf_hook_state *state)
 	return false;
 }
 
-unsigned int nf_confirm(void *priv,
-			struct sk_buff *skb,
-			const struct nf_hook_state *state)
+static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
+				   struct nf_conn *ct,
+				   enum ip_conntrack_info ctinfo,
+				   unsigned int *protoffp)
 {
-	int (*helper_cb)(struct sk_buff *skb, unsigned int protoff,
-			 struct nf_conn *ct,
-			 enum ip_conntrack_info conntrackinfo);
-	const struct nf_conn_help *help;
-	enum ip_conntrack_info ctinfo;
 	unsigned int protoff;
-	struct nf_conn *ct;
-	bool seqadj_needed;
 	__be16 frag_off;
 	int start;
 	u8 pnum;
 
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || in_vrf_postrouting(state))
-		return NF_ACCEPT;
-
-	help = nfct_help(ct);
-
-	seqadj_needed = test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) && !nf_is_loopback_packet(skb);
-	if (!help && !seqadj_needed)
-		return nf_conntrack_confirm(skb);
-
-	/* helper->help() do not expect ICMP packets */
-	if (ctinfo == IP_CT_RELATED_REPLY)
-		return nf_conntrack_confirm(skb);
-
 	switch (nf_ct_l3num(ct)) {
 	case NFPROTO_IPV4:
 		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
@@ -169,16 +149,56 @@ unsigned int nf_confirm(void *priv,
 		pnum = ipv6_hdr(skb)->nexthdr;
 		start = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum, &frag_off);
 		if (start < 0 || (frag_off & htons(~0x7)) != 0)
-			return nf_conntrack_confirm(skb);
+			return false;
 
 		protoff = start;
 		break;
 	default:
-		return nf_conntrack_confirm(skb);
+		DEBUG_NET_WARN_ONCE(1, "helper invoked on non-IP family!");
+		return false;
 	}
 
+	*protoffp = protoff;
+	return true;
+}
+
+/**
+ * nf_ct_call_helper() - Invoke the connection tracking helper for a packet
+ * @skb:    The socket buffer containing the packet to be processed.
+ * @ct:     The connection tracking entry associated with this packet.
+ * @ctinfo: The current connection track information (state) of the packet.
+ *
+ * This function calls the l4 connection tracking helper (e.g. ftp, sip...) if
+ * one was assigned to the connection.
+ *
+ * Return: verdict (NF_ACCEPT, NF_DROP, ...)
+ */
+int nf_ct_call_helper(struct sk_buff *skb, struct nf_conn *ct,
+		      enum ip_conntrack_info ctinfo)
+{
+	struct net *net = nf_ct_net(ct);
+	const struct nf_conn_help *help;
+	bool seqadj_needed;
+	unsigned int protoff;
+
+	help = nfct_help(ct);
+
+	seqadj_needed = test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) && !nf_is_loopback_packet(skb);
+	if (!help && !seqadj_needed)
+		return NF_ACCEPT;
+
+	/* helper->help() do not expect ICMP packets */
+	if (ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
+
+	if (!nf_confirm_get_protoff(skb, net, ct, ctinfo, &protoff))
+		return NF_ACCEPT;
+
 	if (help) {
 		const struct nf_conntrack_helper *helper;
+		int (*helper_cb)(struct sk_buff *skb, unsigned int protoff,
+				 struct nf_conn *ct,
+				 enum ip_conntrack_info conntrackinfo);
 		int ret;
 
 		/* rcu_read_lock()ed by nf_hook */
@@ -195,9 +215,46 @@ unsigned int nf_confirm(void *priv,
 	}
 
 	if (seqadj_needed &&
-	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
-		NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
 		return NF_DROP;
+
+	return NF_ACCEPT;
+}
+
+/**
+ * nf_confirm - Confirm (commit) a connection tracking entry
+ * @priv: Private data from the netfilter hook registration (unused)
+ * @skb: Packet
+ * @state: Netfilter hook state containing context (netns, hooknum, in/out devices)
+ *
+ * This function is invoked as the final step of the connection tracking
+ * processing pipeline. It performs two main operations:
+ *
+ * 1. Invokes the associated conntrack helper (if registered) to allow
+ *    layer 7 specific parsing and NAT mangling.
+ *
+ * 2. Commits a new conntrack entry to the conntrack hash table, making it
+ *    globally visible and enabling future packet lookups for stateful tracking.
+ *
+ * Returns: A netfilter verdict, e.g. NF_ACCEPT or NF_DROP.
+ */
+unsigned int nf_confirm(void *priv,
+			struct sk_buff *skb,
+			const struct nf_hook_state *state)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	int ret;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || in_vrf_postrouting(state))
+		return NF_ACCEPT;
+
+	ret = nf_ct_call_helper(skb, ct, ctinfo);
+	if (unlikely(ret != NF_ACCEPT)) {
+		if (ret == NF_DROP)
+			NF_CT_STAT_INC_ATOMIC(state->net, drop);
+		return ret;
 	}
 
 	/* We've seen it coming out the other side: confirm it */
-- 
2.47.3

