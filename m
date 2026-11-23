Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442098;
	b=Xmi1lwQtnvk0lY1EZ6lVL7fFWaUC7Gro8IthwRZwqzIJRCgHxmb+Eg0aREPWrc0eZB60
	 3QcaVTAGi/JT+faGW7ONPSoUKyj+6ZxHUao89QZrtQ0jY1jhj4ao9bowVDtIx3t+Rd2jQ
	 1HdCuigKO17tPm1tywQk5bxB8RttS6ib2U3ERW1EEghH4E43ean69RKw94Nh6b0MUI7hd
	 MWTJeX0CpdYUjCupmc1XVm6A7YU6nRghwhVrZo8NKsmnvbgTeISU1zxSTLjLXf1tPOKk6
	 PVc7t8yrHcpzSqdG9z+4xkO8Qb6MgTr9lvkIK9lD/SyriQvoHKLi7p/r11e3T7Z7j/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442098;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=tUs92/3C6a+B3SOLHJJUXzN+3Ap9uUF5Js/S3EGH8Vk=;
	b=PtfVOgEqINrB+0yogYeoduEqO0HV4P98t/MEqyCgS8GpBIhh16bcca6s4Rxn+kWcTqu4
	 cL1yP+mxFOqCK2JO5KLutClyBKD3EL+CvDbnhKPwcni3v6RnFh8ia2VR6k/rm8MqMCQKz
	 czLQNIlxz24DRGmktopd5UvJYXMXUxLiHQjtkBVfHcaouLFaiIpHY/3AzniRsUQG7WMiu
	 VewxjQwI/ZppzGc+y7ZTg+oBhLMTRyETaZSzOEB/ianOMx8X7Nogodq92+G4QKOCBQV2i
	 zQxi3J1CF2M5JJ5TyvQQU5eiX9icpq1WlbmZ7Ng92DopU85LhAbag43W7Ceu6ZQjR6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=D9FIHCeB;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC52606A33C;
	Mon, 23 Nov 2026 13:54:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BC52606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=D9FIHCeB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442090;
	bh=tUs92/3C6a+B3SOLHJJUXzN+3Ap9uUF5Js/S3EGH8Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9FIHCeBhCs3GwN4Te10a1bCLeVEAItqjX6thZFFlCmYavEXfCuUWUEaSlBxVaKk1
	 PuWrqrlOuCa3beR70lRtd6UXe5AZj4E7iJfqzGTT26r5303NcVDWFDLV+UGbO4GPqw
	 nooVAkh1OVpK2NmtbVcoHTTpUDcnNgXK/iTin4tg/c5PbIVnYho858A37nKnRPiaqM
	 WUe7TkEZFU+0eNG5S0ThBolm9UJtD0sSQk9nJO7agKa2VKZl8kMReQdfJw5pgATH3I
	 wfNM03OQDKeF9KiDa/D3Aa9cUh4XVhLbfqfe8yVkL59SZjC7hBBHKSSbkojbzkxP65
	 AUF+5le2LRYfQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2B305602BB;
	Mon, 23 Nov 2026 14:54:50 +0100 (CET)
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
Subject: [PATCH net-next 02/15] netfilter: conntrack: validate skb->_nfct and packet headers
Date: Mon, 23 Nov 2026 14:54:29 +0100
Message-ID: <20261123135442.3940372-3-pablo@netfilter.org>
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 114 +++++++++++++++++++++++++++---
 1 file changed, 105 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 931b76aacd93..d2cd9b31507e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1998,6 +1998,99 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,
 	return generic_packet(ct, skb, ctinfo);
 }
 
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
+			     dataoff, state->pf, protonum, state->net,
+			     &tuple))
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
@@ -2006,21 +2099,24 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
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
2.47.3

