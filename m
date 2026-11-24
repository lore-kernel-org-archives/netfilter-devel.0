Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531177;
	b=Fqt8/xFL8DSaKLIXbbhBjavGgHKjOH9IZ2phitDW3KJ/KKHjv27nmP3liUawLv95Xs5S
	 Z5l8/rakxy8iahpEMRWNW6079zWxsWTKacg05A9r8QYqkBGh8iXz83pIvhGdol6pVqifp
	 9SZOT4jiJvgWkVF9+aebU69DMzVOYalF9NfaKe9XPYSZbsK98lZ6zKivl7DLkZqOqDH1o
	 wjdW+i94w9+CVHPFQHuikZYqL5psxMzHPzvN8Ffg8+dAofuptNuLTYkzz5A3KxWkWhclx
	 8fx1wZsHk8XAnJSCQwan1OwVapHLojh97zlhemhLT/RaDwXMemMski65jyzqX7Is8DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531177;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=VlECLQyycXDLKhXmEjfVRoGtIagJQTFXqDYssZCUVjo=;
	b=AIb5gz+BlANnP6CZa7n9f/e2yZDDAuUYKCc3tkfIBIM97zG2XF6i68HCKlk4SGJq8Gvs
	 ujtJwGe0ixo+GfCf3eT3pk/m11V8UkPwS4MV4L4wYSJiXJpxBsKLOUFAEoZbH/piRtT/G
	 x9o7ibiWXjCIhNjEoweg7mJtA9Yeg7Z68iXLt4OXI2ic3LrKSVfMuV62/b6xmgP4Bjj3X
	 jUuJu2Moz+6z+jJgstMGVF3PBiJ/szqYjaySxfH2fHMVVszGnyi8i65Jiy18W5mhAGfma
	 vgtzJvBnikscxyYTyIkkW2qz+LtZsR+wVb3zuYLpcShVeVVbf1L5LJRohGdqlGlNAOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IleNeSVx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA4D606A339;
	Tue, 24 Nov 2026 14:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IleNeSVx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EC91F000C4;
	Tue, 24 Nov 2026 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531176;
	bh=VlECLQyycXDLKhXmEjfVRoGtIagJQTFXqDYssZCUVjo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IleNeSVxBgUsHifP3WvtxicmHrm2dpvlaXnii5sBrRv/8+rIs1PrJdxwajHwljcD/
	 c8qSpsFfYO3zrR0SwIMe5SdTK6i3y2tWYX/NRe911nxgJbALv38XSziBIZnpzshE4Y
	 z4/BPcHj2SvLD5cIRCtlR3pJUxahoiwn2oUHZUQ3rr12MUdYqcaO6mW711gztDc3s0
	 tpBOssYjzbxJCfwzHmrGGtGay//bcK2Q5tfpWj7a68CXUyGX3GrRz16IR0TyCk+tJX
	 C6YKgJATGxlQCiYAuJ9k1Re0C8jvNjjVSXoxEQrK6EPULiiuXKPHiOR5dFjIoA6Y//
	 D3lLdgcvBiqMw==
Subject: Re: [PATCH net-next 06/15] netfilter: conntrack: harden helper
 invocation with tuple revalidation
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:35 +0000
Message-ID: <179553117549.3135.4393332546290332600@kernel.org>
In-Reply-To: <20261123135726.3940688-7-pablo@netfilter.org>
References: <20261123135726.3940688-7-pablo@netfilter.org>
X-sashiko-severity: Critical
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

Critical: 1 · High: 2 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] netfilter: conntrack: H.245 l4proto mismatch bypasses TCP
  check in helper call
- [High] The new tuple check in nf_confirm_get_protoff()
  (net/netfilter/nf_conntrack_proto.c) only passes packets whose headers…
- [High] netfilter: conntrack: missing UDP header size check in
  nf_confirm_get_protoff()

--

netfilter: conntrack: harden helper invocation with tuple revalidation

This commit makes nf_confirm_get_protoff() pull the current tuple from
the packet and check it against the conntrack entry. Packets that were
modified after the conntrack lookup (for example by act_ct -> pedit) no
longer reach helpers. It also adds a TCP header sanity check and passes
nhoff to ipv6_skip_exthdr().

> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index 18125aa29e0d0..43bf3a71dbbfc 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c

[ ... ]

> @@ -160,6 +164,41 @@ static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
>  		return false;
>  	}
>  
> +	if (protoff > skb->len)
> +		return false;
> +
> +	if (!nf_ct_get_tuplepr(skb, nhoff, nf_ct_l3num(ct), net, &tuple))
> +		return false;
> +
> +	dir = CTINFO2DIR(ctinfo);
> +	if (!nf_ct_invert_tuple(&invert, &tuple))
> +		return false;
> +
> +	/* This is called after L3/L4 headers have been mangled by NAT:
> +	 * Packet in original direction has been subject to SNAT, i.e.
> +	 * inverted reply dir.
> +	 * Packet in reply direction has been subject to DNAT, i.e.
> +	 * inverted original direction.
> +	 */
> +	if (!nf_ct_tuple_equal(&invert, nf_ct_tuple(ct, !dir)))
> +		return false;

[Severity: High]
On the nf_confirm() hook path NAT has always run before this check. Is
that also true when we get here through nf_ct_helper() from openvswitch
or act_ct?

Both callers only NAT the packet when the ct action has the nat flag,
but they call the helper for any confirmed, non-cached packet. In
net/openvswitch/conntrack.c:__ovs_ct_lookup():

		 * this by delaying both NAT and helper calls for unconfirmed
		 * connections until the committing CT action.  For later
		 * packets NAT and Helper may be called in either order.
    ...
		if (info->nat && !(key->ct_state & OVS_CS_F_NAT_MASK) &&
		    (nf_ct_is_confirmed(ct) || info->commit)) {
			int err = ovs_ct_nat(net, key, info, skb, ct, ctinfo);
    ...
		if (nf_ct_is_confirmed(ct) && !cached) {
			int err = nf_ct_helper(skb, ct, ctinfo, info->family);

net/sched/act_ct.c behaves the same way. tcf_ct_act_nat() returns early:

	if (!(ct_action & TCA_CT_ACT_NAT))
		return NF_ACCEPT;

and tcf_ct_act() still calls the helper:

	if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {
		err = nf_ct_helper(skb, ct, ctinfo, family);

Take a confirmed connection with SNAT/DNAT bindings and a helper such as
FTP, possibly with IPS_SEQ_ADJUST set. Suppose it is first looked up by a
ct action without nat, such as OVS ct(table=N) before a later
ct(commit,nat), or tc ct zone X before ct commit nat.

The packet is still untranslated, so its tuple matches
ct->tuplehash[dir]. Inverting it does not give ct->tuplehash[!dir],
because NAT changed that tuple. nf_ct_tuple_equal() then fails here, and
nf_ct_call_helper() returns early:

	if (!nf_confirm_get_protoff(skb, net, ct, ctinfo, &protoff, &pnum))
		return NF_ACCEPT;

That skips both helper_cb() and nf_ct_seq_adjust().

The later ct(nat) action in the same zone treats the skb as cached:
skb_nfct_cached() and tcf_ct_skb_nfct_cached() return true when zone and
helper match. Neither caller calls nf_ct_helper() again for that packet.

So the packet never gets helper processing or sequence adjustment. FTP
PORT/PASV commands on the established control connection would create no
expectations. Once seqadj offsets exist, seq/ack numbers would stop being
corrected. Before this patch the helper and seqadj ran on these packets.

The earlier patch in this series, "netfilter: conntrack: validate
skb->_nfct and packet headers", accepts both forms in
nf_ct_get_careful(): tuple equal to tuplehash[dir], or inverted tuple
equal to tuplehash[!dir] with IPS_NAT_MASK set.

Could this check accept either form as well? Packets changed by pedit
would still be rejected.

> +
> +	/* Validate that a full, sane TCP header (including options) is
> +	 * present at protoff before helpers/seqadj are allowed to touch it.
> +	 */

[ ... ]

> @@ -160,6 +164,41 @@ static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
>  		return false;
>  	}
>  
> +	if (protoff > skb->len)
> +		return false;
> +
> +	if (!nf_ct_get_tuplepr(skb, nhoff, nf_ct_l3num(ct), net, &tuple))
> +		return false;
> +
> +	dir = CTINFO2DIR(ctinfo);
> +	if (!nf_ct_invert_tuple(&invert, &tuple))
> +		return false;
> +
> +	/* This is called after L3/L4 headers have been mangled by NAT:
> +	 * Packet in original direction has been subject to SNAT, i.e.
> +	 * inverted reply dir.
> +	 * Packet in reply direction has been subject to DNAT, i.e.
> +	 * inverted original direction.
> +	 */
> +	if (!nf_ct_tuple_equal(&invert, nf_ct_tuple(ct, !dir)))
> +		return false;
> +
> +	/* Validate that a full, sane TCP header (including options) is
> +	 * present at protoff before helpers/seqadj are allowed to touch it.
> +	 */
> +	if (tuple.dst.protonum == IPPROTO_TCP) {
> +		unsigned int tcplen = skb->len - protoff;
> +		const struct tcphdr *th;
> +		struct tcphdr _tcph;
> +
> +		th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
> +		if (!th)
> +			return false;
> +
> +		if (th->doff * 4 < sizeof(*th) || tcplen < th->doff * 4)
> +			return false;
> +	}
> +
>  	*protoffp = protoff;
>  	return true;
>  }

[Severity: High]
TCP gets a full header check here, but for UDP the only length
validation left is what nf_ct_get_tuplepr() does. That ends up in
nf_ct_get_tuple_ports(), which only pulls the 4 bytes holding the
ports, not sizeof(struct udphdr).

The commit message names act_ct -> pedit as the case being hardened
against. Suppose pedit increases iph->ihl on a UDP packet after act_ct
has attached the conntrack. protoff moves forward, and as long as the
4 bytes at the new protoff carry the original ports, the tuple still
matches. With only 6 bytes left we return true for a truncated UDP
header. nf_ct_get_careful() from earlier in the series does the same
4 byte tuple lookup and returns before udp_error() would run, so
nothing else catches it.

UDP helpers assume the caller already guaranteed a full UDP header.
help() in nf_nat_snmp_basic_main.c only checks that
udp_get_len_short(udph) equals skb->len - (iph->ihl << 2). With
udph->len set to 6 and 6 bytes remaining, that passes, and
snmp_translate() then computes:

	u16 datalen = udp_get_len_short(udph) - sizeof(struct udphdr);

which wraps to 65534. asn1_ber_decoder() is handed that length. It
reads up to 64K past skb->tail, and through the mangling callbacks it
also writes there.

Could this add a sizeof(struct udphdr) check for IPPROTO_UDP next to
the TCP one? Should it also reject a uh->len smaller than the header,
or is that left to the individual helpers?

[Severity: Critical]
The TCP header check here is keyed on tuple.dst.protonum, so it
follows the protocol of the packet rather than what the attached
helper is going to parse. Does that hold for nf_conntrack_helper_h245?

h323_helper_init() registers the H.245 helper with IPPROTO_UDP, but
h245_help() treats the payload as TCP. get_tpkt_data() reads a struct
tcphdr at protoff and computes tcpdataoff = protoff + th->doff * 4
without checking that doff is at least 5.

Because the helper's l4proto is UDP, it can be attached to a NATted UDP
conntrack entry, e.g. with a ct helper object or the CT target, which
only needs CAP_NET_ADMIN in a user namespace. For such a flow the doff
validation below is skipped because tuple.dst.protonum is IPPROTO_UDP.
The helper->l4proto != pnum test in nf_ct_call_helper() also passes,
so h245_help() runs on a UDP packet.

th->doff then comes from byte 4 of the UDP payload. With doff == 0,
tcpdataoff equals protoff and the TPKT header is taken from the UDP
ports. If the decoder finds an H245_TransportAddress, set_addr() sees a
UDP packet and calls nf_nat_mangle_udp_packet() with an addroff that
was computed relative to protoff. mangle_contents() then adds
protoff + sizeof(struct udphdr) to it, so the match ends 8 bytes past
skb->tail. The memmove() length underflows and the copy writes beyond
the packet data into skb_shared_info.

The mismatch also breaks the legitimate case. expect_h245() creates TCP
expectations bound to nf_conntrack_helper_h245. For real H.245 traffic
pnum is IPPROTO_TCP while helper->l4proto is IPPROTO_UDP, so
nf_ct_call_helper() returns NF_ACCEPT without calling h245_help().
H.245 address translation would silently stop working.

Should nf_conntrack_helper_h245 be switched to IPPROTO_TCP as part of
this series, now that nf_ct_call_helper() compares helper->l4proto
against pnum? Or should the header validation here be driven by the
helper's l4proto instead of the packet's protocol? Either way,
get_tpkt_data() probably wants its own doff sanity check.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
