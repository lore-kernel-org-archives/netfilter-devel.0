Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531175;
	b=vQEsIIQynAqdfck0dlgbPt2MdI7LTWCWS6yZbEJe+WAZfr0UNO1jiqTpFwfv1aIvchMz
	 3FNJsuyxJ5bZRtwQl6Y2yFUveHz/TVw+H9sKmV+MZ38aBh+TPQGyFSuxAs5a/wTbDxcp2
	 J6egvM+NgXxvreq2NsHwkf97S0paoOLmuq9/r4O5zJkOqXj8I67rbnxplqQAFYO49gt56
	 8G677JsktLeTTOB9eyGb8kEBPBLvlb5UUDcvciod6CbQGglsqrwdsFK9cn0jjiJoEGfXO
	 qdxyPbT13H5ZOVbpSvec/fyht6/aySzcG/G1H+1sl1eAnMyEgrpxOUS/ZiCJtD44TCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531175;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TXNbTZIFkURe4DDU63HqIMXwC3wYeijQ0bXyCiJSP3g=;
	b=gC2a9IySgihd6HYftdH5onrufhXFBg7GDKk3o+PbhsVCWIga1eojN5odIUad/amOWyZx
	 9yP5BCPmnxwAhGKAgTCwZl20XqVFn4Gt4McWAXYmNbTCvP1WTY4QWG3rBSgWR6L3vePfH
	 fappUHGMWKEBqxFmSEWuiVhc6QIRG86VN8Ect61qRX1oYupzUu87y7QoSqkZi4SkFU8oc
	 K4HtCWH5RhXya9i8Ci81dVL0T+DkyeehNE589esRlArdK+i/+edmVzKKUtQh3fJxisCEM
	 KA6X4vsjKgcrFGYZQM+Gpfeyy6dDmPkElUu61IkOZ0KcY/k18KQSYN+jTCUYwVOwL8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hc794+bL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5151F606A326;
	Tue, 24 Nov 2026 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hc794+bL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168FC1F000D0;
	Tue, 24 Nov 2026 14:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531174;
	bh=TXNbTZIFkURe4DDU63HqIMXwC3wYeijQ0bXyCiJSP3g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Hc794+bLZOgu+BAxlGtyBHVphgzUijDgUWfkPcw7XXH0E4Xq1X82tUgPb2+Bcs454
	 Dm95h5Z2R3y56qYId0qguFpxjGeKd25ydmXyrsMkI6D+JsLsbFvif09ihyZAhvJgog
	 s4XElXLPoSkjjrDs3irMx6OU2z0bfY06Bz2+PNSu1sSzf7ltwpjbGGy3RydRK/SBMF
	 HnNnT5hqsTM7NmP3OCp6IasLxe00Lpj9+0hid1GB4PRpkxeTr5nxkRRKd/rmIIkPVz
	 qWvEZ3S2oHuZK+UET7mzUK3LIvoOmOCYBzIuirOT6zHJveZep2vROTid+5oAQ8jdj3
	 IeQMxaiMyU0nQ==
Subject: Re: [PATCH net-next 05/15] netfilter: conntrack: replace open-coded
 helper invocation
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:33 +0000
Message-ID: <179553117362.3135.14148690589375438131@kernel.org>
In-Reply-To: <20261123135726.3940688-6-pablo@netfilter.org>
References: <20261123135726.3940688-6-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] This patch changes the OVS/tc helper path in nf_ct_helper()
  (net/netfilter/nf_conntrack_ovs.c:30) so that it calls…
- [Medium] netfilter: conntrack: nf_ct_helper() does not verify
  nf_ct_l3num(ct) == proto
- [Low] The comment `/* rcu_read_lock()ed by nf_hook */` at
  net/netfilter/nf_conntrack_proto.c:211 in nf_ct_call_helper() is now…

--

netfilter: conntrack: replace open-coded helper invocation

The commit replaces the open-coded helper invocation in nf_ct_helper(),
which the OVS datapath and tc act_ct use. It now calls
nf_ct_call_helper(), which nf_confirm() also uses. The commit message
says there are no functional changes, apart from extra checks that make
sure the helper can process the packet.

> diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
> index fe525b324af41..2a80eaf05186b 100644
> --- a/net/netfilter/nf_conntrack_ovs.c
> +++ b/net/netfilter/nf_conntrack_ovs.c

[ ... ]

> @@ -35,50 +27,7 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
>  	    helper->nfproto != proto)
>  		return NF_ACCEPT;
>  

[ ... ]

> -	default:
> -		WARN_ONCE(1, "helper invoked on non-IP family!");
> -		return NF_DROP;
> -	}
> -
> -	if (helper->l4proto != proto)
> -		return NF_ACCEPT;
> -
> -	helper_cb = rcu_dereference(helper->help);
> -	if (!helper_cb)
> -		return NF_ACCEPT;
> -
> -	err = helper_cb(skb, protoff, ct, ctinfo);
> -	if (err != NF_ACCEPT)
> -		return err;
> -
> -	/* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
> -	 * FTP with NAT) adusting the TCP payload size when mangling IP
> -	 * addresses and/or port numbers in the text-based control connection.
> -	 */
> -	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
> -	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
> -		return NF_DROP;
> -	return NF_ACCEPT;
> +	return nf_ct_call_helper(skb, ct, ctinfo);

[Severity: Medium]
Can nf_ct_helper() now pick the helper by one family and parse the
packet by another?

The check left in nf_ct_helper() compares helper->nfproto against the
proto passed in by the caller. nf_ct_call_helper() then calls
nf_confirm_get_protoff(), and that function switches on
nf_ct_l3num(ct) instead:

	switch (nf_ct_l3num(ct)) {
	case NFPROTO_IPV4:
		...
		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
		*pnum = ip_hdr(skb)->protocol;
		break;
	case NFPROTO_IPV6:
		*pnum = ipv6_hdr(skb)->nexthdr;
		...

The removed code also switched on proto when it parsed the headers. So
the helper family check and the protoff and l4proto lookup always used
the same family.

Nothing in nf_ct_helper() checks that nf_ct_l3num(ct) == proto, and
the callers do not seem to guarantee it. In tcf_ct_act(),
tcf_ct_skb_nfct_cached() treats an existing skb->_nfct as cached when
only the net and the zone match:

	if (!net_eq(net, read_pnet(&ct->ct_net)))
		goto drop_ct;
	if (nf_ct_zone(ct)->id != p->zone)
		goto drop_ct;

For an unconfirmed ct with commit set, tcf_ct_act() then calls
nf_ct_helper(skb, ct, ctinfo, family) and skips nf_conntrack_in().
skb_nfct_cached() in net/openvswitch/conntrack.c looks similar.

Consider a tc chain with these steps, all in the same zone:

1. A ct action without commit tracks an IPv6 packet.
2. skbedit, pedit or bpf changes skb->protocol to ETH_P_IP.
3. A ct action with commit and an IPv4-only helper runs.

nf_ct_helper() accepts the helper, because helper->nfproto is
NFPROTO_IPV4. nf_confirm_get_protoff() parses the packet as IPv6. An
IPv4 helper such as snmp_trap_helper() finds the UDP header from
ip_hdr(skb)->ihl, not from protoff, so it would run on an IPv6 header.
The reverse case is also possible: act_ct trimmed and classified the
packet as IPv6, but nf_confirm_get_protoff() parses it as IPv4.

Setting this up needs CAP_NET_ADMIN. Still, it changes which bytes the
helper is pointed at, and the commit message only says it adds checks.
The old code also ran the helper against a ct of the other family in
this case, but its header parsing at least matched the family that was
used to pick the helper.

The later patch "harden helper invocation with tuple revalidation"
adds nf_ct_get_tuplepr() to nf_confirm_get_protoff(). It also keys off
nf_ct_l3num(ct), so it does not seem to close this gap.

Should nf_ct_helper() return early when nf_ct_l3num(ct) != proto? Or
should the helper->nfproto check compare against nf_ct_l3num(ct)?
Another option is for the cached checks in act_ct and OVS to reject a
ct whose l3num does not match the current family.

[Severity: Medium]
Does this change when sequence adjustment runs for tc act_ct on
loopback?

In net/netfilter/nf_conntrack_proto.c, nf_ct_call_helper() does this:

	seqadj_needed = test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) && !nf_is_loopback_packet(skb);
	...
	if (seqadj_needed &&
	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
		return NF_DROP;

The removed code called nf_ct_seq_adjust() whenever IPS_SEQ_ADJUST_BIT
was set after a successful helper call. It never checked the device.

nf_is_loopback_packet() is:

	return skb->dev && skb->skb_iif && skb->dev->flags & IFF_LOOPBACK;

When tcf_ct_act() runs from a tc ingress filter on lo, this is always
true. __netif_receive_skb_core() sets skb->skb_iif before
sch_handle_ingress() runs:

	skb->skb_iif = skb->dev->ifindex;

Consider a pure act_ct setup on lo ingress with commit, nat and a helper
that rewrites the payload, such as ftp. act_ct registers no netfilter
hooks, so nf_confirm() never adjusts these packets. Before this patch,
nf_ct_helper() was the only place that did.

After nf_nat_mangle_tcp_packet() changes the payload length and sets
IPS_SEQ_ADJUST_BIT, will seq/ack go uncorrected on later packets? That
would leave the TCP control connection out of sync.

OVS does not seem able to reach this, because ovs_netdev_link() rejects
IFF_LOOPBACK vports. In a mixed setup where netfilter conntrack already
adjusted the packet in POSTROUTING, skipping the adjustment on lo
ingress does avoid adjusting twice.

The commit message says:

    No functional changes intended, except the additional checks to
    ensure the helper can process the given packet.

The loopback exemption does not seem to fit that description.

Two smaller behaviour changes also seem to be undisclosed. First, a
NULL helper->help, which happens briefly while a helper is being
unregistered, used to return NF_ACCEPT without any seq adjustment. It
now falls through to nf_ct_seq_adjust().

Second, a non-IP family used to hit WARN_ONCE() and return NF_DROP. It
now returns NF_ACCEPT after DEBUG_NET_WARN_ONCE(). That path is
probably unreachable, because the switch is now on nf_ct_l3num(ct).

Should nf_ct_helper() keep the unconditional seq adjustment for the
act_ct path? Or should the commit message describe these changes? The
behaviour looks the same at the end of the series.

[Severity: Low]
This isn't a bug, but the comment in nf_ct_call_helper() looks stale
now that nf_ct_helper() calls it:

		/* rcu_read_lock()ed by nf_hook */
		helper = rcu_dereference(help->helper);

Before this patch, nf_confirm() was the only caller, and it runs inside
nf_hook_slow(). Through nf_ct_helper(), this code is now also reached
from the OVS datapath in net/openvswitch/conntrack.c and from
tcf_ct_act() in net/sched/act_ct.c.

Those paths get their RCU read-side section from somewhere else: the
netdev rx handler, ovs_packet_cmd_execute(), or tc classify. The
rcu_dereference() calls are still protected in practice, so only the
comment is wrong.

Could the comment be updated to cover the new callers? It is unchanged
at the end of the series.

>  }
>  EXPORT_SYMBOL_GPL(nf_ct_helper);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
