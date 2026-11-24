Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531170;
	b=Kou1VAQesjam+JMMtawnkXGhf+srvrwBPxAgXr5vseYB8jZKVJEQhSq9R5EOzko8xytQ
	 CwOILdAtUiEjF7WLirqKGTqLOgN9d4Ngf2IaRsd2FOeFIxF27lKYi2YZOVyhbFbfExo1o
	 yTGyKm6BdqaqtZilytCGnePaKmJqCRtjEqbr1exUHh905ax8+2QRSEZjzPuCReXYDchK8
	 4pguhL9nPXC0HbFpnIUjXzao3vYg97A+ifNz0sN1+7FSwpceARfxqeM/npSft5UKTnfqI
	 IPBYkgEK3lIDLNSsX4SVfDaIyo/1LwClWYH3E5BPOtb9WbZ5x6mFx4oG0KuV0Qq1bcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531170;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=r3/e24L9jPAl1cT9KbtoSEgJKpcQN+zLBokjU1C3Shc=;
	b=MGSkE6Hwf+vX/aLnrQuEReKdEBZimnrda+wAs4FU/uUROEb640Ycf65Qf/RnKZG4Nj1E
	 +oLpPkZcTDDRmquQW0fKkDte0RhtghKBr10es1eQX39UONtu+4NI+J72Nk1aEgdWexZkT
	 Gh4T/yvqeIrI003NP1AgTB/AsYLKEQHo96p8AK4Vv/zC0ymQoZxBffrwgO86naWGnV69T
	 miRmd9rwhulXUoEhI9E2neYG+qXEfuqufFYA2F8TF8zOiseRCm2zFy/lWlqvIJbIt5gt2
	 0xu3C0LhyC64bzX3Xpn3t1tkAohS5azhfLb/frxXMKow8FGfor/78BBmMxVyBMHTdUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cpvqusVR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277C606A31E;
	Tue, 24 Nov 2026 14:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cpvqusVR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449BF1F000CA;
	Tue, 24 Nov 2026 14:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531169;
	bh=r3/e24L9jPAl1cT9KbtoSEgJKpcQN+zLBokjU1C3Shc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=cpvqusVRdIG52RX6cHK3GY2WIr/I27IkarUW6d+2wzoGZBDk9cFOn1tvjcWyVxWN8
	 U/Bsi69YZ2Agor6YaFxBxBg2zmiavw+AFcPP2z/nYdbVPKP8pcMqUmp9uWpL5pxqY0
	 qvyGGSBcXwJIwpuPiNy6Caz8EksfWkjycWRLQi+LBdN7QxdCi34k8eNADuYtAt2Dwo
	 ixFDZDa6A8Sk9fhPIEJX6FyznIsuP9apQvLaenASOP7MHzr2rmjV7uyXGCiiTrE2it
	 TlGioU7YF9Np+UwsCSC3FEw8pHERKSSmr4fekoYeuv1Xmb5UzuMeARVhNqZLjWtTt/
	 2Xw74PCkibnjQ==
Subject: Re: [PATCH net-next 02/15] netfilter: conntrack: validate skb->_nfct
 and packet headers
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:28 +0000
Message-ID: <179553116881.3135.11367901451789500912@kernel.org>
In-Reply-To: <20261123135726.3940688-3-pablo@netfilter.org>
References: <20261123135726.3940688-3-pablo@netfilter.org>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 6 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] nf_ct_get_careful() accepts a packet whose tuple does not match
  tuple(ct, dir) only when (tmpl->status & IPS_NAT_MASK) is set and…
- [Medium] nf_conntrack_in() now runs get_l4proto() before the
  'previously seen' early return, so it strips a valid conntrack from…
- [Medium] The commit message uses act_ct + pedit/clsact as its example
  of a stale conntrack ('UDP packet with TCP nf_conn').
- [Medium] The new 'drop and re-lookup' behaviour conflicts with the raw-
  table template setters.
- [Medium] The bridge-family conntrack entry point nf_ct_bridge_pre() has
  its own copy of the 'previously seen' check that this patch replaced…
- [Medium] netfilter: conntrack: nf_ct_check_icmp_inner() rejects pre-NAT
  ICMP errors
- [Medium] netfilter: conntrack: nf_ct_get_careful() drops ct on half-
  NATted VRF packets

--

netfilter: conntrack: validate skb->_nfct and packet headers

This patch makes nf_conntrack_in() check a conntrack that is already
attached to the skb (from loopback or act_ct) against the current L3/L4
headers, using the new nf_ct_get_careful().  If they don't match, the
stale reference is dropped and a fresh lookup is done.  The patch also
moves get_l4proto() ahead of the "previously seen" check.

> skbs coming from loopback already have skb->_nfct attached.
> act_ct may also attach a conntrack to the skb.
>
> Facilities like clsact or pedit can alter headers which may then result
> in e.g. UDP packet with TCP nf_conn.

[Severity: Medium]
Does the new revalidation cover act_ct's own path?  It only exists in
nf_conntrack_in()->nf_ct_get_careful().  tcf_ct_act() only calls
nf_conntrack_in() when the attached ct is not considered cached:

net/sched/act_ct.c:tcf_ct_act() {
    ...
	if (!cached) {
		...
		err = nf_conntrack_in(skb, &state);
    ...
}

tcf_ct_skb_nfct_cached() treats an attached ct as cached after checking
netns, zone, helper and the FORCE direction.  It never compares the ct
tuple with the current L3/L4 headers:

	ct = nf_ct_get(skb, &ctinfo);
	if (!ct)
		return false;
	if (!net_eq(net, read_pnet(&ct->ct_net)))
		goto drop_ct;
	if (nf_ct_zone(ct)->id != p->zone)
		goto drop_ct;

On the non-cached path, tcf_ct_act() replaces the existing ct with
p->tmpl first.  So nf_ct_get_careful() never sees an act_ct-attached ct
there.

Take a chain like 'ct zone X' -> pedit (protocol or port rewrite) ->
'ct zone X commit nat'.  Wouldn't the stale ct go straight to
tcf_ct_act_nat()/nf_ct_nat()?  That code picks the L4 manipulation by the
ct's protocol and applies it to the packet's current headers.  The stale
ct then gets its mark/labels set and is committed or offloaded.

__ovs_ct_lookup() in net/openvswitch/conntrack.c has the same pattern.  It
calls skb_nfct_cached() and then calls nf_conntrack_in() only when
!cached.

Later in the series, "netfilter: conntrack: harden helper invocation with
tuple revalidation" covers the helper call in this path.  The NAT and
commit use of the stale ct can still be reached.

> Revalidate that this skb matches the skb l3/l4 header.  If not, drop the
> stale reference and let nf_conntrack_in perform a re-lookup.

[Severity: Medium]
Does this hold for bridged traffic as well?  nf_ct_bridge_pre() in
net/bridge/netfilter/nf_conntrack_bridge.c has its own copy of the
"previously seen" check.  It returns before nf_conntrack_in() is called:

	ct = nf_ct_get(skb, &ctinfo);
	if ((ct && !nf_ct_is_template(ct)) ||
	    ctinfo == IP_CT_UNTRACKED)
		return NF_ACCEPT;

Take an skb that got its ct from act_ct on a bridge port's clsact ingress.
pedit or another clsact program then rewrites its headers, for example
TCP to UDP, or new ports.  nf_ct_get_careful() never runs for it.  The
stale ct then drives the nft bridge ct expressions (ct state/mark/labels)
and nf_ct_bridge_post()->nf_confirm().

Later in the series, "netfilter: conntrack: harden helper invocation with
tuple revalidation" covers the helper/seqadj path in nf_confirm().
nft_ct_get_safe() checks the protocol for ct timeout/helper objects.  The
bridge family still makes ct-based policy decisions on the stale ct.

> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 931b76aacd934..d2cd9b31507e6 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1998,6 +1998,99 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,

[ ... ]

> +static struct nf_conn *
> +nf_ct_get_careful(struct sk_buff *skb,
> +		  const struct nf_hook_state *state,
> +		  unsigned int dataoff, u8 protonum,
> +		  enum ip_conntrack_info *ctinfo)
> +{

[ ... ]

> +	dir = CTINFO2DIR(*ctinfo);
> +	if (nf_ct_tuple_equal(&tuple, nf_ct_tuple(tmpl, dir)))
> +		return tmpl;

[ ... ]

> +	if (!nf_ct_invert_tuple(&inverse, &tuple))
> +		goto error;
> +
> +	if ((tmpl->status & IPS_NAT_MASK) && nf_ct_tuple_equal(&inverse, nf_ct_tuple(tmpl, !dir)))
> +		return tmpl;

[Severity: Medium]
Does this accept packets on which only part of the NAT has been
applied so far?  At PRE_ROUTING, nf_nat_packet() only does the
NF_NAT_MANIP_DST step.  The NF_NAT_MANIP_SRC step waits for
POST_ROUTING or LOCAL_IN.  With both IPS_DST_NAT and IPS_SRC_NAT set,
the header between those two steps matches neither
nf_ct_tuple(tmpl, dir) nor the inverse of nf_ct_tuple(tmpl, !dir).

VRF runs PRE_ROUTING twice.  The first pass is on the enslaved device.
The second comes from vrf_ip_rcv()->vrf_rcv_nfhook() on the vrf
master, with the ct from the first pass still attached.  Take DNAT
D1->D2 plus SNAT S1->S2, as in a hairpin NAT setup:

  ct ORIGINAL S1->D1, REPLY D2->S2
  slave PRE_ROUTING
    nf_conntrack_in() attaches ct
    nf_nat_packet() DST manip, header now S1->D2
  vrf master PRE_ROUTING
    nf_ct_get_careful()
      S1->D2 vs ORIGINAL S1->D1        no match
      inverse D2->S1 vs REPLY D2->S2   no match
      nf_reset_ct()

Replies end up the same way.  D2->S2 becomes D2->S1 at the slave pass
and fails both comparisons on the master pass.

resolve_normal_ct() then looks up the half-translated tuple, finds
nothing, and allocates a new ct.  Wouldn't the SNAT step later be done
for that new ct, with its own binding if a nat rule matches at all?
The original ct would also stop being refreshed.  Every packet of such
a connection would hit this.  Before this patch the master pass took
the "previously seen" early return and kept the ct.

Should a tuple with only the DST manip applied also be accepted here?
Or should a ct attached by an earlier pass of the same hook be
trusted?

[Severity: High]
Can this reject conntracks that IPVS altered legitimately?
ip_vs_update_conntrack() changes the reply tuple through
nf_conntrack_alter_reply().  That only writes
tuplehash[IP_CT_DIR_REPLY] and sets neither IPS_SRC_NAT nor IPS_DST_NAT.

Take IPVS MASQ with net.ipv4.vs.conntrack=1 (IP_VS_CONN_F_NFCT), a local
client C and a local real server RS behind VIP:

LOCAL_OUT: conntrack creates ct with ORIGINAL C->VIP
ip_vs_nat_xmit()
  rewrites daddr to RS
  ip_vs_nat_send_or_cont()
    ip_vs_update_conntrack()
      nf_conntrack_alter_reply()      REPLY becomes RS->C
    returns NF_ACCEPT (local destination)
POSTROUTING: ct confirmed, packet re-enters via lo

PRE_ROUTING: nf_conntrack_in()->nf_ct_get_careful()
  tuple C->RS does not match ORIGINAL C->VIP
  not RELATED
  inverse RS->C matches REPLY, but IPS_NAT_MASK is clear
  goto error -> nf_reset_ct()

resolve_normal_ct() then finds no entry for C->RS and allocates a new ct.
Its REPLY RS->C clashes with the confirmed IPVS ct.  At LOCAL_IN,
__nf_conntrack_confirm()->nf_ct_resolve_clash() drops the packet:

	if (!l4proto->allow_clash)
		goto drop;

Replies hit the same problem in reverse.  VIP->C is rejected, and the new
ct clashes with the IPVS ct's ORIGINAL tuple.

Wouldn't every SYN and retransmission be dropped, so that TCP connections
from local clients to such a VIP fail?  Before this patch, the
"previously seen" early return kept the IPVS ct and the traffic was
delivered.

> +error:
> +	nf_reset_ct(skb);
> +	return NULL;
> +}

[Severity: Medium]
How does this error path interact with the raw table zone/helper/notrack
setters?  Several of them skip their work when the skb already carries a
ct, on the assumption that nf_conntrack_in() keeps it:

net/netfilter/xt_CT.c (xt_ct_target() and notrack_tg()):
	/* Previously seen (loopback)? Ignore. */
	if (skb->_nfct != 0)
		return XT_CONTINUE;

net/netfilter/nft_ct.c:nft_ct_set_zone_eval():
	ct = nf_ct_get(skb, &ctinfo);
	if (ct) /* already tracked */
		return;

nft_notrack_eval() also returns early when ct is set.

These rules run at raw priority, before conntrack.  For such an skb they
attach no zone, helper or timeout template and no UNTRACKED marker.  If
nf_ct_get_careful() then takes this error path, nf_conntrack_in() calls
resolve_normal_ct() with tmpl == NULL.

Wouldn't the re-lookup then use the default zone and none of the
configured template extensions?  Packets marked notrack would be tracked
anyway.  This could also merge flows that the admin keeps apart with
zones.

Later in the series, "netfilter: nft_ct: validate hook and priority for
ct zone set" restricts where ct zone set may be used.  It keeps the
"already tracked" early return, though.

>  unsigned int
>  nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
>  {
> @@ -2006,21 +2099,24 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
>  	u_int8_t protonum;
>  	int dataoff, ret;
>  
> -	tmpl = nf_ct_get(skb, &ctinfo);
> +	/* rcu_read_lock()ed by nf_hook_thresh */
> +	dataoff = get_l4proto(skb, skb_network_offset(skb), state->pf, &protonum);
> +	if (dataoff <= 0) {
> +		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
> +		tmpl = nf_ct_get(skb, &ctinfo);
> +		if (ctinfo != IP_CT_UNTRACKED)
> +			nf_reset_ct(skb);
> +		return NF_ACCEPT;
> +	}

[Severity: Medium]
get_l4proto() now runs before the "previously seen" check.  Does that
strip valid conntracks from non-first fragments?  ipv6_get_l4proto()
returns -1 when (frag_off & htons(~0x7)) != 0, and ipv4_get_l4proto()
returns -1 when frag_off & IP_OFFSET is set.  Those skbs now end up here,
where they get nf_reset_ct() and bump the invalid counter.

On loopback, fragments normally reach PRE_ROUTING with a ct already
attached:

LOCAL_OUT nf_conntrack_in() attaches ct
ip6_fragment()
  ip6_copy_metadata()
    nf_copy(to, from)          every fragment carries the ct
loopback_xmit()                ct is not scrubbed
PRE_ROUTING ipv6_defrag()
  non-template ct attached -> NF_ACCEPT, no reassembly
nf_conntrack_in()
  get_l4proto() returns -1 for non-first fragments
  nf_reset_ct(skb)

ipv4_conntrack_defrag() skips reassembly the same way when CONFIG_NF_NAT
is disabled.  IPv6 reassembly happens in the fragment protocol handler,
after NF_INET_LOCAL_IN.  So the non-first fragments cross LOCAL_IN with
no ct and are classified as ct state invalid.

Rules like 'ct state vmap { ..., invalid : drop }' would drop these
fragments.  The nftables wiki server example puts that rule before
'iifname lo accept'.  '-m conntrack --ctstate INVALID -j DROP' would do
the same.  Wouldn't reassembly then time out?  Any UDP datagram larger
than the lo MTU would hit this, as would sockets using IPV6_MTU or a
lowered lo MTU.

This reset also happens on every hook, including LOCAL_OUT.  The kdoc for
nf_ct_get_careful() says "skbs coming in via NF_INET_LOCAL_OUT are
trusted and never revalidated".  Neither the commit message nor the kdoc
mentions this behaviour change.

> +
> +	tmpl = nf_ct_get_careful(skb, state, dataoff, protonum, &ctinfo);
>  	if (tmpl || ctinfo == IP_CT_UNTRACKED) {
>  		/* Previously seen (loopback or untracked)?  Ignore. */
>  		if ((tmpl && !nf_ct_is_template(tmpl)) ||
>  		     ctinfo == IP_CT_UNTRACKED)
>  			return NF_ACCEPT;

[ ... ]

> @@ -1998,6 +1998,99 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,
>  	return generic_packet(ct, skb, ctinfo);
>  }
>  
> +static bool nf_ct_check_icmp_inner(const struct sk_buff *skb,
> +				   const struct nf_hook_state *state,
> +				   unsigned int dataoff,
> +				   struct nf_conn *ct,
> +				   enum ip_conntrack_dir dir)
> +{
> +	static const unsigned int icmp_hdrsz = 8;
> +	struct nf_conntrack_tuple tuple;
> +
> +	if (!nf_ct_get_tuplepr(skb, dataoff + icmp_hdrsz, state->pf,
> +			       state->net, &tuple))
> +		return false;
> +
> +	return nf_ct_tuple_equal(&tuple, nf_ct_tuple(ct, !dir));
> +}
> +
> +/**
> + * nf_ct_get_careful - Get connection tracking entry with protocol revalidation
> + *
> + * @skb: Socket buffer whose conntrack entry is to be retrieved
> + * @state: Netfilter hook state
> + * @dataoff: Offset to the layer-4 header within @skb
> + * @protonum: protocol number (e.g., IPPROTO_TCP)
> + * @ctinfo: Pointer to store ip_conntrack_info
> + *
> + * This function retrieves the connection tracking entry associated with @skb.
> + * Performs revalidation of packet header, unlike nf_ct_get().
> + *
> + * If earlier in-kernel mangling (e.g., via TC pedit or clsact) altered packet
> + * contents (e.g. changing TCP to UDP), this function will drop the conntrack
> + * reference and returns NULL.  skbs coming in via NF_INET_LOCAL_OUT are
> + * trusted and never revalidated.
> + *
> + * Returns:
> + *   %NULL - No valid conntrack entry exists or revalidation failed.
> + *   Pointer to &struct nf_conn associated with skb, may be a template.
> + */
> +static struct nf_conn *
> +nf_ct_get_careful(struct sk_buff *skb,
> +		  const struct nf_hook_state *state,
> +		  unsigned int dataoff, u8 protonum,
> +		  enum ip_conntrack_info *ctinfo)
> +{
> +	struct nf_conn *tmpl = nf_ct_get(skb, ctinfo);
> +	struct nf_conntrack_tuple inverse;
> +	struct nf_conntrack_tuple tuple;
> +	enum ip_conntrack_dir dir;
> +
> +	/* LOCAL_OUT is trusted: in case stack sends ICMP error, skb gets
> +	 * the conntrack assigned via nf_ct_attach().
> +	 *
> +	 * Such conntrack may not even be in hashtable yet, so
> +	 * nf_conntrack_handle_icmp() cannot find a connection matching
> +	 * the inner header.
> +	 */
> +	if (state->hook == NF_INET_LOCAL_OUT)
> +		return tmpl;
> +
> +	if (!tmpl || nf_ct_is_template(tmpl))
> +		return tmpl;
> +
> +	if (state->pf != nf_ct_l3num(tmpl))
> +		goto error;
> +
> +	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
> +			     dataoff, state->pf, protonum, state->net,
> +			     &tuple))
> +		goto error;
> +
> +	dir = CTINFO2DIR(*ctinfo);
> +	if (nf_ct_tuple_equal(&tuple, nf_ct_tuple(tmpl, dir)))
> +		return tmpl;
> +
> +	if (*ctinfo == IP_CT_RELATED || *ctinfo == IP_CT_RELATED_REPLY) {
> +		if (state->pf == NFPROTO_IPV4 && protonum == IPPROTO_ICMP &&
> +		    nf_ct_check_icmp_inner(skb, state, dataoff, tmpl, dir))
> +			return tmpl;
> +
> +		if (state->pf == NFPROTO_IPV6 && protonum == IPPROTO_ICMPV6 &&
> +		    nf_ct_check_icmp_inner(skb, state, dataoff, tmpl, dir))
> +			return tmpl;
> +	}
> +
> +	if (!nf_ct_invert_tuple(&inverse, &tuple))
> +		goto error;
> +
> +	if ((tmpl->status & IPS_NAT_MASK) && nf_ct_tuple_equal(&inverse, nf_ct_tuple(tmpl, !dir)))
> +		return tmpl;
> +error:
> +	nf_reset_ct(skb);
> +	return NULL;
> +}
> +
>  unsigned int
>  nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
>  {

[Severity: Medium]
Does nf_ct_check_icmp_inner() handle ICMP errors that are checked
before the NAT reply translation has rewritten the inner header?

nf_conntrack_inet_error() finds the related ct by inverting the inner
tuple.  Until nf_nat_icmp_reply_translation() or
nf_nat_icmpv6_reply_translation() has run, the inner tuple is
therefore the inverse of nf_ct_tuple(ct, dir).  That only equals
nf_ct_tuple(ct, !dir) when the connection has no NAT.

Take a DNAT connection from S1 to D1, rewritten to D2.  A router on
the way to D2 sends fragmentation needed back to S1:

  ct ORIGINAL S1->D1, REPLY D2->S1
  ICMP error: outer R->S1, inner S1->D2
  nf_conntrack_inet_error()
    invert(inner) D2->S1 matches REPLY -> IP_CT_RELATED_REPLY
  nf_conntrack_in() runs again on the same skb
    nf_ct_get_careful()
      outer tuple vs REPLY, no match
      nf_ct_check_icmp_inner(): S1->D2 vs ORIGINAL S1->D1, no match
      nf_ct_invert_tuple() fails for the error type
      nf_reset_ct()

For this ct the reply translation only happens at the SRC manip, in
POST_ROUTING or LOCAL_IN.  So the inner header is still untranslated
whenever the ct was attached earlier.  Two such cases are act_ct
without nat at tc ingress followed by PRE_ROUTING, and the second
PRE_ROUTING pass that vrf_ip_rcv() does on the vrf master.

After the reset, nf_conntrack_handle_icmp() runs with tmpl == NULL, so
the re-lookup happens in the default zone.  The first lookup may have
used a zone, from act_ct or from a raw rule on the enslaved device.
In that case the re-lookup misses and the error is left without a ct,
so nf_nat never translates it.  Wouldn't these errors then be dropped
as ct state invalid, or reach S1 with an inner header it doesn't
recognize?  For fragmentation needed that is a PMTU black hole for
NATed flows.

The fixed icmp_hdrsz of 8 also looks wrong for ICMPv6 NDISC_REDIRECT.
nf_conntrack_icmpv6_redirect() passes nf_conntrack_inet_error() an
offset past struct rd_msg and the redirected header option, so the
inner ipv6 header starts at dataoff + 48.  Here nf_ct_get_tuplepr()
would parse the target and destination addresses of struct rd_msg as
an ipv6 header.  Doesn't that make every RELATED ct on a redirect
fail this check?

Should the inner check also accept invert(inner) equal to
nf_ct_tuple(ct, dir) when IPS_NAT_MASK is set?  And could the inner
offset come from the same logic the icmp/icmpv6 error handlers use,
instead of a constant?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
