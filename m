Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531172;
	b=WxWASI9b6r7So4/vN+hf9QIyveKqFOr3GB00hCLaXzzwLA6yIJl/VgimqFR4TpUyFUxt
	 OOO2Y6PbzNjsJWSmX1GT1t0yarHxfPkBNOT3aW2Xb+uz48EDPFc883hYNabqSwEtSlMe0
	 1+wtybcm7FJd7TPkXsIZokTU9MorVrIuXpf1s1cr4znKm6eSLVEseFpTLkq5ixxhQp5TY
	 ogVHqsydHL8qGw+dMC1+71SGJXA38fF9ENMfzboXq/Jx3JDOP1r8kzttkGdUIJZpTuyBx
	 +AAr/7OSaxMZL4akAWv0CbEs+vtxQVyp/Z5vx+Q/J3kG+Ziey3O0yTqpZbfbvDHOvNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531172;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=1Fm3iLTzPKB1097UfAG40VRAoYU6YuWlhW7f4tKhwcE=;
	b=PIjkYeYzNk5u1U4PFWei1FMeBjZvMuPn++GshKjJ7QEUfNYKdrrWJgPJcrqe1hSHolWa
	 PpxpxbuFBvPCAXTe+kX9mlDvjgUmyxpjIbWChskSpabbwEjUJsdcBf+GKoYroy1tvgMTC
	 6dyvA7cwAPSlw8aWXJjT9+sMAOxp9Lxs000mdJOYFumXAXkBvueKSZa7eAwRXbgBRZd9i
	 avQN8vlj2HPqNmcr7a/Awyxc2f3JNlFMKGqLa0ZA9p0G2c3RVUCVj1qvXn/KmsOTWxWS4
	 bYy3ohA6fUK30WKpFT0bJEnAVBjZaEekEFjl6AwRLbLV3tNRXB9bFB+NfbWscmyXYXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="O5w/YPLH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC56C606A335;
	Tue, 24 Nov 2026 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5w/YPLH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC681F000CA;
	Tue, 24 Nov 2026 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531171;
	bh=1Fm3iLTzPKB1097UfAG40VRAoYU6YuWlhW7f4tKhwcE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=O5w/YPLH5jeTeDCF330cgTourYPFekygkVQIRBT4tgRXcB7YUgJrbLxNxuwvkX8NX
	 Gu6pBHAOluuqAWUJ5FPMpK80LZjDac/u0MhIGVXBFji09YLAiI8Q4BFbqJJdQmEIFw
	 +ZSXUpGYEpnw35ZjjpK3ufRa3ek05nZyKXeKkjiUsyv5EvGn2BuFMjS3puWdvDEc6t
	 wliEtQoEpAwMy3x7q4gBofsGYCdcY9sZqxjM3ti8Y1frrYTlSFSruq9Y16GZ8OC2UF
	 ZtWWFd6QkAc0jE6JEmhvdd2fWymsgUDa2kSZIjMEYkSg3NX3+1KOlfa8tn6bywalI4
	 /kp84o+Gd0xWw==
Subject: Re: [PATCH net-next 03/15] netfilter: conntrack: refactor helper call
 logic in nf_confirm()
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:30 +0000
Message-ID: <179553117043.3135.12759318924641866063@kernel.org>
In-Reply-To: <20261123135726.3940688-4-pablo@netfilter.org>
References: <20261123135726.3940688-4-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch makes nf_ct_call_helper()/nf_confirm_get_protoff()
  the central place for helper and seqadj invocation and protoff…
- [Low] The new kernel-doc for nf_ct_call_helper() says it "calls the l4
  connection tracking helper (e.g. ftp, sip...) if one was assigned to…

--

netfilter: conntrack: refactor helper call logic in nf_confirm()

This splits nf_confirm() into two parts. nf_confirm_get_protoff() computes
the L4 offset for IPv4/IPv6, and nf_ct_call_helper() decides whether to
run the conntrack helper and/or TCP sequence adjustment. The drop counter
is now bumped in nf_confirm() for any NF_DROP verdict, and followup patches
are meant to add stricter checks to the new functions.

> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index 7a40e4e0e33e6..32f900c155de8 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c

[ ... ]

> @@ -169,16 +149,56 @@ unsigned int nf_confirm(void *priv,

[ ... ]

> +/**
> + * nf_ct_call_helper() - Invoke the connection tracking helper for a packet
> + * @skb:    The socket buffer containing the packet to be processed.
> + * @ct:     The connection tracking entry associated with this packet.
> + * @ctinfo: The current connection track information (state) of the packet.
> + *
> + * This function calls the l4 connection tracking helper (e.g. ftp, sip...) if
> + * one was assigned to the connection.

[Severity: Low]
This isn't a bug, but should this kernel-doc also mention sequence
adjustment? If there is no helper but IPS_SEQ_ADJUST_BIT is set,
nf_ct_call_helper() gets past this check:

	if (!help && !seqadj_needed)
		return NF_ACCEPT;

It can then mangle the packet or return NF_DROP by itself:

	if (seqadj_needed &&
	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
		return NF_DROP;

The new nf_confirm() kernel-doc also lists only helper invocation and
confirmation, and leaves out seqadj. This is still the case at the end of
the series, where nf_ct_helper() has been converted to call this function.

> + *
> + * Return: verdict (NF_ACCEPT, NF_DROP, ...)
> + */
> +int nf_ct_call_helper(struct sk_buff *skb, struct nf_conn *ct,
> +		      enum ip_conntrack_info ctinfo)
> +{

[ ... ]

> +	/* helper->help() do not expect ICMP packets */
> +	if (ctinfo == IP_CT_RELATED_REPLY)
> +		return NF_ACCEPT;
> +
> +	if (!nf_confirm_get_protoff(skb, net, ct, ctinfo, &protoff))
> +		return NF_ACCEPT;

[Severity: Medium]
nf_ct_call_helper() and nf_confirm_get_protoff() are now the central place
for helper/seqadj invocation. Should nf_confirm_cthelper() in
net/netfilter/nf_conntrack_core.c go through them as well?

It runs for every accepted nfqueue verdict:

nfqnl_reinject()
  ct_hook->update()
    nf_conntrack_update()
      nf_confirm_cthelper()
        nf_ct_seq_adjust()

It still open-codes the old protoff calculation:

net/netfilter/nf_conntrack_core.c:nf_confirm_cthelper() {
    ...
	case NFPROTO_IPV4:
		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
		break;
    ...
		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
					   &frag_off);
    ...
	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
	    !nf_is_loopback_packet(skb)) {
		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
    ...
}

This path has no IP_CT_RELATED_REPLY filter, no IPv4 fragment check, and
no L4 protocol, tuple or TCP doff check. The IPv6 case also lacks the
nhoff that the later hardening adds.

Two followups add those checks: "netfilter: conntrack: verify L4 protocol
before calling helper" and "netfilter: conntrack: harden helper invocation
with tuple revalidation". Both put them only inside
nf_confirm_get_protoff() and nf_ct_call_helper().

"netfilter: conntrack: replace open-coded helper invocation" converts
nf_ct_helper() in nf_conntrack_ovs.c. The nfqueue reinject copy is still
not converted at the end of the series.

Can nf_ct_seq_adjust() then rewrite tcph->seq, ack_seq, check and the SACK
blocks at a non-TCP offset? Take a conntrack that has a userspace cthelper
(NF_CT_HELPER_F_USERSPACE) and IPS_SEQ_ADJUST_BIT set. Two cases look
reachable:

  - an ICMP error (IP_CT_RELATED or IP_CT_RELATED_REPLY) related to the
    flow that matches a queue rule

  - a packet whose L3/L4 headers userspace rewrote through NFQA_PAYLOAD

The writes stay in bounds because nf_ct_seq_adjust() and
nf_ct_sack_adjust() call skb_ensure_writable(). The result would be a
corrupted packet, not corrupted memory.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
