Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D202D3B8D7E;
	Wed,  9 Sep 2026 19:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788981706; cv=none; b=r4QNCWEQyMfY+FmVJLjxXYbz/Ia57NtfOsjWpr4wOs0xWe4AU8X3yNKUtGPEgl2Zii1c1miqsrxiIZj9xgifXqDZqV+/b5puuOmPa3I5ih5lO8j8SM9XbylmnEekw0+ZAckcws0+nrq6dzoj9EWglKgW63VNBULznstn6YY4HYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788981706; c=relaxed/simple;
	bh=wItJgys1WkoCBv9Nv/62nASo8IwyR5mnOPwWb60Kmu8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QhUVYRGMrWPYOsArYSclrcmfWa9DVY7s8yE76si7h9XRxT2OhwvdyIWKqyM/HnydmImYNViMopCGHWfk3Qf6ICKP01NFPhsdVSAuycrf2TQEBUWe9sMEmBHu1nUwNcaFUORDif+2v6BJz5qXWoSkgAza1poFHNIWDgDs9kbXN1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lftNlYty; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lftNlYty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8D91F000FF;
	Wed,  9 Sep 2026 19:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788981704;
	bh=0dPH5qYcxrlDKWgIHKe2IFZsZPUZ6aoHJ9KkYKMgFZs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lftNlYtymdMvrlagU6hpqyz3324ojlhSea3M0Mz0xtSTRTcCSFURnTR32azbMBJC1
	 vCHlGhobdbO43RIa0nTG2e3FPvtepQLPBlOK7vHocL1MTFTPX5DbiZl4+6fQWZg3Z3
	 9qzORfGCY9TzGJ5F1Dwrl4Vcmr+dEsq/X+8YLdB6A5HLzndchLnhePYjkqRmzOTExL
	 jRZW3+Z3z1+LC0o92xQNLcm5j5WDfC17kJH49CI88itKJ6g3pOfehUL/+F6DF9gpaX
	 GjBR2ksEJHUjM6r7ZBHD3GvFQfpeAEoiquCL3uuI+uwhhumHcvNLQYu4pOa5ZV3jRd
	 sB1+XuL+v+qUg==
Subject:
 Re: [PATCH nf] netfilter: flowtable: advertise the vlan match in used_keys
From: netdev-bot+sashiko@kernel.org
To: julius@bairaktaris.de
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc, coreteam@netfilter.org, netdev@vger.kernel.org, kuba@kernel.org
Date: Wed, 09 Sep 2026 19:21:43 +0000
Message-ID: <178898170386.219967.2768890098511373106@kernel.org>
In-Reply-To: <20260906141947.480524-1-julius@bairaktaris.de>
References: <20260906141947.480524-1-julius@bairaktaris.de>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 2 · Low: 0

- [Medium] Commit message justification names a driver that cannot
  consume the newly advertised key.
- [Medium] The `else` branch of the second encapsulation block now
  declares an outer VLAN match that describes the wrong tag when the…

--

netfilter: flowtable: advertise the vlan match in used_keys

nf_flow_rule_match() fills the vlan and cvlan dissector keys and sets their
offsets, but never sets the matching bits in match->dissector.used_keys.
This patch ORs BIT_ULL(FLOW_DISSECTOR_KEY_VLAN) and
BIT_ULL(FLOW_DISSECTOR_KEY_CVLAN) into used_keys where the keys are filled.

> netfilter: flowtable: advertise the vlan match in used_keys
>
> mtk_ppe_offload.c reads the ingress vlan through flow_rule_match_key()
> and so never gets it, and a driver that checks used_keys against the
> keys it supports installs an entry that ignores the tag.

[Severity: Medium]
Is the mtk part of this justification accurate?  In
mtk_flow_offload_replace() the FLOW_DISSECTOR_KEY_VLAN read sits inside the
addr_type == 0 arm:

drivers/net/ethernet/mediatek/mtk_ppe_offload.c:mtk_flow_offload_replace() {
	switch (addr_type) {
	case 0:
		offload_type = MTK_PPE_PKT_TYPE_BRIDGE;
		...
		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
			...
			data.vlan_in = match.key->vlan_id;
		...
	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
	...
}

But nf_flow_rule_match() always sets key->control.addr_type to
FLOW_DISSECTOR_KEY_IPV4_ADDRS or FLOW_DISSECTOR_KEY_IPV6_ADDRS and returns
-EOPNOTSUPP for anything else, so flowtable rules always take the IPv4/IPv6
arms, which do not look at the vlan key at all.  mtk also never reads
FLOW_DISSECTOR_KEY_CVLAN and has no used_keys whitelist, so its behaviour
looks unchanged by this patch, before and after.

The driver whose behaviour does change appears to be mlx5e, through
mlx5e_rep_setup_ft_cb() -> mlx5e_rep_setup_tc_cls_flower() ->
__parse_cls_flower().  The other TC_SETUP_FT consumers (airoha_ppe.c,
mtk_wed.c, mt76, netdevsim) contain no FLOW_DISSECTOR_KEY_VLAN read either,
and nfp does not implement TC_SETUP_FT at all.

Could the changelog name the driver that actually consumes the new bits,
and drop or reword the mtk claim?

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 801a3dd9ceea3..9ef89127bf252 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -126,6 +126,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>  		nf_flow_rule_vlan_match(&key->vlan, &mask->vlan,
>  					tuple->encap[0].id,
>  					tuple->encap[0].proto);
> +		match->dissector.used_keys |= BIT_ULL(FLOW_DISSECTOR_KEY_VLAN);
>  		vlan_encap = true;
>  	}
>  
> @@ -137,12 +138,16 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>  			nf_flow_rule_vlan_match(&key->cvlan, &mask->cvlan,
>  						tuple->encap[1].id,
>  						tuple->encap[1].proto);
> +			match->dissector.used_keys |=
> +				BIT_ULL(FLOW_DISSECTOR_KEY_CVLAN);
>  		} else {
>  			NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_VLAN,
>  					  vlan);
>  			nf_flow_rule_vlan_match(&key->vlan, &mask->vlan,
>  						tuple->encap[1].id,
>  						tuple->encap[1].proto);
> +			match->dissector.used_keys |=
> +				BIT_ULL(FLOW_DISSECTOR_KEY_VLAN);

[Severity: Medium]
Can this else branch now advertise a vlan key that describes the wrong tag?

The branch is taken whenever vlan_encap is false, which includes the case
where encap[0] is simply not 802.1Q, because the first block tests:

net/netfilter/nf_flow_table_offload.c:nf_flow_rule_match() {
	if (tuple->encap_num > 0 && !(tuple->in_vlan_ingress & BIT(0)) &&
	    tuple->encap[0].proto == htons(ETH_P_8021Q)) {
	...
}

encap[0] is the outermost tag on the wire, since flow_offload_fill_route()
reverses the path-walk order:

net/netfilter/nf_flow_table_core.c:flow_offload_fill_route() {
	for (i = route->tuple[dir].in.num_encaps - 1; i >= 0; i--) {
		flow_tuple->encap[j].id = route->tuple[dir].in.encap[i].id;
		flow_tuple->encap[j].proto = route->tuple[dir].in.encap[i].proto;
	...
}

and encap[].proto is copied verbatim from the configured VLAN protocol,
which can be ETH_P_8021AD:

net/8021q/vlan_dev.c:vlan_dev_fill_forward_path() {
	path->encap.proto = vlan->vlan_proto;
	...
}

net/bridge/br_vlan.c:br_vlan_fill_forward_path_pvid() {
	path->bridge.vlan_proto = br->vlan_proto;
	...
}

So with an 802.1ad outer tag and an 802.1Q tag beneath it, the first block
is skipped, vlan_encap stays false, and the else branch stores the inner
tag (encap[1].id, tpid 0x8100) into key->vlan, the outer vlan slot.  Before
this patch that key was inert; with the bit set it becomes an authoritative
match, while the action side pops only the 802.1Q tag:

net/netfilter/nf_flow_table_offload.c:nf_flow_rule_route_common() {
		if (tuple->encap[i].proto == htons(ETH_P_8021Q)) {
			entry = flow_action_entry_next(flow_rule);
			if (!entry)
				return -1;
			entry->id = FLOW_ACTION_VLAN_POP;
	...
}

Would it be better to gate the else branch on tuple->in_vlan_ingress &
BIT(0), or to return -EOPNOTSUPP when the outer encapsulation is not
802.1Q, so the declared match and the emitted actions agree on which tag is
outermost?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260906141947.480524-1-julius%40bairaktaris.de
