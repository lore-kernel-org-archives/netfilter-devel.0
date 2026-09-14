Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9B8490C04
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 16:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789405149; cv=none; b=M0WM92MPiY7xEGqyVsGhp7G3rhoZ/CpXU8SRmNp7W0lT+qh1Gcl2sYo/MMo/+BrWb/BiW5AKSkbkKpcsmEw38+9p5jZD6blpElodvqqrMy4xOfy4IWHKxH73AR0LmvCDVHB99VMkmQB/EKfU6tZFz20Zdl+Wf3pToCqEknuM11U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789405149; c=relaxed/simple;
	bh=x5vcxClQAEk8K9oiSFAUxxx5Bxaj2i1a5oLXU+v2idI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OYp65AgwyY4VyPTnqulKmL8CcE9lUnGTPjYagGFAxkP6yS+3UoGZonkiSVIxvG39USaW1fW4x1bo4jxujXXsxHoM7zvovH9raULGLEv5dkncoDSd97Wot2N7kCmG+Ru37wH6DnH7h+sc88aNJiw8TFm0/1DRkxHDfWkbijM9l4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A4CF26032B; Mon, 14 Sep 2026 18:59:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/6] netfilter: nf_conntrack: validate skb->_nfct and packet headers
Date: Mon, 14 Sep 2026 18:58:37 +0200
Message-ID: <20260914165842.4505-2-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
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

Note that the Fixes tag is bogus, back then this was perfectly fine.

namespaces and especially unprivileged user namespaces did not exist and
all crash-configs were in the "don't do that, then" department.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 75 +++++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d0d9e5ea84a0..57edb07e9b3b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2000,6 +2000,63 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,
 	return generic_packet(ct, skb, ctinfo);
 }
 
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
+	struct nf_conntrack_tuple tuple;
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
+	if (nf_ct_get_tuple(skb, skb_network_offset(skb),
+			    dataoff, state->pf, protonum, state->net,
+			    &tuple) &&
+	    nf_ct_tuple_equal(&tuple, nf_ct_tuple(tmpl, CTINFO2DIR(*ctinfo))))
+		return tmpl;
+
+error:
+	nf_reset_ct(skb);
+	return NULL;
+}
+
 unsigned int
 nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 {
@@ -2008,21 +2065,21 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 	u_int8_t protonum;
 	int dataoff, ret;
 
-	tmpl = nf_ct_get(skb, &ctinfo);
+	/* rcu_read_lock()ed by nf_hook_thresh */
+	dataoff = get_l4proto(skb, skb_network_offset(skb), state->pf, &protonum);
+	if (dataoff <= 0) {
+		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
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

