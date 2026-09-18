Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3315038EA
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746001; cv=none; b=lGwaJ19bbIsGkUtK5KZV3HzplBKq84KrYgsxmIKmGhbTHh7UlNGakBKMNv9djKAuALpqqdDdG1LMHQ1YxmiBSwTZoq94RXAquZ/Npq9eHkRZcTeowtLLGjTIvmYKnv+OsWgS5kn83GJGDfBdP0oOqMaFfFYbjgnZeubP2Fp4qNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746001; c=relaxed/simple;
	bh=OGsw4kGfU1sUog7gRsOP6nsdiM8rHM26YBN6fw1ZbeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uT2HeU87+ditiX+6ZXoAOLpJ0RnZaQK9ZK+kaJCuBRgkKbYtls8ZeaMLhBr11ONiYBKyxHIOqO5lLlOnkQeHVGHrHR5c9zsXZXHAj5nwkm9Cq6pgtvJSzYgMB+NzJ9pzOFWiGj5xzaoIT99AlvX6XzxTPDWSP2FIpNR8HCc3RDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C4B376055C; Fri, 18 Sep 2026 17:39:54 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf 1/6] netfilter: nf_conntrack: validate skb->_nfct and packet headers
Date: Fri, 18 Sep 2026 16:58:04 +0200
Message-ID: <20260918145809.12938-2-fw@strlen.de>
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

skbs coming from loopback already have skb->_nfct attached.
act_ct may also attach a conntrack to the skb.

Facilities like clsact or pedit can alter headers which may then result
in e.g. UDP packet with TCP nf_conn.

Revalidate that this skb matches the skb l3/l4 header.  If not, drop the
stale reference and let nf_conntrack_in perform a re-lookup.

For conntrack helpers, more checks may be required, e.g. tcph->doff
revalidation.  This is handled in a followup patch.

Note that the Fixes tag is bogus, back then this was perfectly fine:
namespaces, esp. unprivileged user namespaces, did not exist and all
crash-configs were in the "don't do that, then" department.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: don't reset ct on UNTRACKED skbs.
 remove nhoff in nf_ct_check_icmp_inner(), double-increment
 (matters for bridge case).

 net/netfilter/nf_conntrack_core.c | 115 +++++++++++++++++++++++++++---
 1 file changed, 106 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d0d9e5ea84a0..cd543c7b66a3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2000,6 +2000,100 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,
 	return generic_packet(ct, skb, ctinfo);
 }
 
+
+static bool nf_ct_check_icmp_inner(const struct sk_buff *skb,
+				   const struct nf_hook_state *state,
+				   unsigned int dataoff,
+				   struct nf_conn *ct,
+				   enum ip_conntrack_dir dir)
+{
+	static const unsigned int icmp_hdrsz = 8;
+	struct nf_conntrack_tuple tuple;
+
+	if (!nf_ct_get_tuplepr(skb, dataoff + icmp_hdrsz, state->pf,
+			       state->net, &tuple))
+		return false;
+
+	return nf_ct_tuple_equal(&tuple, nf_ct_tuple(ct, !dir));
+}
+
+/**
+ * nf_ct_get_careful - Get connection tracking entry with protocol revalidation
+ *
+ * @skb: Socket buffer whose conntrack entry is to be retrieved
+ * @state: Netfilter hook state
+ * @dataoff: Offset to the layer-4 header within @skb
+ * @protonum: protocol number (e.g., IPPROTO_TCP)
+ * @ctinfo: Pointer to store ip_conntrack_info
+ *
+ * This function retrieves the connection tracking entry associated with @skb.
+ * Performs revalidation of packet header, unlike nf_ct_get().
+ *
+ * If earlier in-kernel mangling (e.g., via TC pedit or clsact) altered packet
+ * contents (e.g. changing TCP to UDP), this function will drop the conntrack
+ * reference and returns NULL.  skbs coming in via NF_INET_LOCAL_OUT are
+ * trusted and never revalidated.
+ *
+ * Returns:
+ *   %NULL - No valid conntrack entry exists or revalidation failed.
+ *   Pointer to &struct nf_conn associated with skb, may be a template.
+ */
+static struct nf_conn *
+nf_ct_get_careful(struct sk_buff *skb,
+		  const struct nf_hook_state *state,
+		  unsigned int dataoff, u8 protonum,
+		  enum ip_conntrack_info *ctinfo)
+{
+	struct nf_conn *tmpl = nf_ct_get(skb, ctinfo);
+	struct nf_conntrack_tuple inverse;
+	struct nf_conntrack_tuple tuple;
+	enum ip_conntrack_dir dir;
+
+	/* LOCAL_OUT is trusted: in case stack sends ICMP error, skb gets
+	 * the conntrack assigned via nf_ct_attach().
+	 *
+	 * Such conntrack may not even be in hashtable yet, so
+	 * nf_conntrack_handle_icmp() cannot find a connection matching
+	 * the inner header.
+	 */
+	if (state->hook == NF_INET_LOCAL_OUT)
+		return tmpl;
+
+	if (!tmpl || nf_ct_is_template(tmpl))
+		return tmpl;
+
+	if (state->pf != nf_ct_l3num(tmpl))
+		goto error;
+
+	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
+			    dataoff, state->pf, protonum, state->net,
+			    &tuple))
+		goto error;
+
+	dir = CTINFO2DIR(*ctinfo);
+	if (nf_ct_tuple_equal(&tuple, nf_ct_tuple(tmpl, dir)))
+		return tmpl;
+
+	if (*ctinfo == IP_CT_RELATED || *ctinfo == IP_CT_RELATED_REPLY) {
+		if (state->pf == NFPROTO_IPV4 && protonum == IPPROTO_ICMP &&
+		    nf_ct_check_icmp_inner(skb, state, dataoff, tmpl, dir))
+			return tmpl;
+
+		if (state->pf == NFPROTO_IPV6 && protonum == IPPROTO_ICMPV6 &&
+		    nf_ct_check_icmp_inner(skb, state, dataoff, tmpl, dir))
+			return tmpl;
+	}
+
+	if (!nf_ct_invert_tuple(&inverse, &tuple))
+		goto error;
+
+	if ((tmpl->status & IPS_NAT_MASK) && nf_ct_tuple_equal(&inverse, nf_ct_tuple(tmpl, !dir)))
+		return tmpl;
+error:
+	nf_reset_ct(skb);
+	return NULL;
+}
+
 unsigned int
 nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 {
@@ -2008,21 +2102,24 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 	u_int8_t protonum;
 	int dataoff, ret;
 
-	tmpl = nf_ct_get(skb, &ctinfo);
+	/* rcu_read_lock()ed by nf_hook_thresh */
+	dataoff = get_l4proto(skb, skb_network_offset(skb), state->pf, &protonum);
+	if (dataoff <= 0) {
+		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
+		tmpl = nf_ct_get(skb, &ctinfo);
+		if (ctinfo != IP_CT_UNTRACKED)
+			nf_reset_ct(skb);
+		return NF_ACCEPT;
+	}
+
+	tmpl = nf_ct_get_careful(skb, state, dataoff, protonum, &ctinfo);
 	if (tmpl || ctinfo == IP_CT_UNTRACKED) {
 		/* Previously seen (loopback or untracked)?  Ignore. */
 		if ((tmpl && !nf_ct_is_template(tmpl)) ||
 		     ctinfo == IP_CT_UNTRACKED)
 			return NF_ACCEPT;
-		skb->_nfct = 0;
-	}
 
-	/* rcu_read_lock()ed by nf_hook_thresh */
-	dataoff = get_l4proto(skb, skb_network_offset(skb), state->pf, &protonum);
-	if (dataoff <= 0) {
-		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
-		ret = NF_ACCEPT;
-		goto out;
+		skb->_nfct = 0;
 	}
 
 	if (protonum == IPPROTO_ICMP || protonum == IPPROTO_ICMPV6) {
-- 
2.55.0

