Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442256;
	b=mtZ+zIO4+wyH05nW29L8LhEULWxNFc3gDtrfWvaL2Bref7mC3fbsPzoNUGUJmBVmYN3l
	 haN77t/oLqEesvb/qWGiwzjlM0SIi3z8FjRUevyVLZKNrVq0n0Zo/KpXK6TocJyxSF8oc
	 sJ08SaBTnOwQIQKSZJi9ciOvl32P6XZd/ROvBWiz4s3nafNGlkNc2cdFZ/4KsRHkQjsN/
	 luBEdC2CcEMjKvzpPEtQXHirrMZ6IsEdbRiDh5U3um+2uPenHU+aPqFDrZpdxD0pNF8FJ
	 rizKWi15scG7pa7mPSE4yeA8kBy0TGmWjjHWy1KGAsAEtmQ6gN0p1iQ0JbCm1xBb3Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=tUs92/3C6a+B3SOLHJJUXzN+3Ap9uUF5Js/S3EGH8Vk=;
	b=nHBw9wHTNd5HZ1SlOL2y3xufONgMS4d8y16fWR7CUzSbn2FSK93saIbuU7cRle65GELB
	 eNOlUWJW0GY4UuKfjGCeGszFnKhNpaqfubeJ1CvJCbjWxnnCxlPybFHEzQjPT0Llwc6FW
	 Qm9aQkrwXvVODNXTLfyPIDloXevdNkCRQcEfQlL8S9rrsbDXW5KuJv9JSDP4YcuVnuRaL
	 Nz77YpaS6d2I0tnljia7mYC7tDESbBi6SRwn4XZWGd6CqGWObmocTz5mctHa0XcnJEhte
	 Yuq+8tgeK/aCdFRn8JTY52KrmvV71HDzBR8s4NQhcV87Wa7cGwqlfDIYOknJ3loiSTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Qj1OaEdi;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879DF606A68B;
	Mon, 23 Nov 2026 13:57:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 879DF606A68B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Qj1OaEdi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442253;
	bh=tUs92/3C6a+B3SOLHJJUXzN+3Ap9uUF5Js/S3EGH8Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qj1OaEdidWupDDyx4i4R56Wm1expQGzt1LKH8/e6MhHoQ2kjrYNai7MeZzISLzu1e
	 gxX9UyJ8L+hWXroh4vr5C8Jxll8tkw5MYRWisAm0hSQQ0z0m8P/sdp7ZAWSDWgMzti
	 VPVK58wo50ZMAMYlbd9pyJ1kPGCGI4KoiWhPP2/JR9mEXv3CAct54rNU8mbOUhOESE
	 cUa0OmXNp6GQwmXHFlagel5lrdUJ3hBr1PaQUMP4Nn/ahaxYLjnEw0pQ53zJ2/N7Zf
	 ZXzQfNqvd6qkJsoZYRKotRSeuArWuxQqmTs8I+ziMI8/AxfyVB781ycToGq/YWvXvf
	 SKL97TWCflg7A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4E8BF602EC;
	Mon, 23 Nov 2026 14:57:33 +0100 (CET)
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
Date: Mon, 23 Nov 2026 14:57:13 +0100
Message-ID: <20261123135726.3940688-3-pablo@netfilter.org>
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

