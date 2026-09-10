Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35E1390CAD;
	Thu, 10 Sep 2026 06:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789021332; cv=none; b=oaZwrGRDDAQRQrr5C8Fnhc4sflQeLn1hFeqVu54RDndw21wT4DumlBcjiSyBJaiHKFy+8PvhmMcPdP3//ceDjytI6bYc9xNajKXUPLn/DfBinLemHjdtb2byLxezdb0xA2i3Nnbi4KIXTJvHI+DfoGLHp0EbSxi+9Wy84ysRoB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789021332; c=relaxed/simple;
	bh=+sCGB9d6snie3VEyhdf94Cpul9XhKj5D0+FyUQQywTM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HFo1Rq5cOqDpbsKQ7XCuk0Wt0hvBv5/vVxZWPU+iOfNQ/s2zdAK2/yqzwG0A0Pe5gH3hpmp6k1QQZSOrwtZQNxV1mbyzw0t4x6wF/+0n7waBad6f7bd8Th/VTiISGWkWJGiZX52hmjLlkniOgiquNu1ntWGD9YIJfB1vz5PJWNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcnfsuLp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcnfsuLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2C71F000FF;
	Thu, 10 Sep 2026 06:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789021331;
	bh=r6kCMOHqePJ3Y+HCRWQ/eD8UeXAc0wuWIBstpcAROoE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DcnfsuLpjA2xoAN1CjZLQhORfSupSmH+BkzwHmnuWql6YUEZOeGdCvhMC9njD5aYs
	 FeuunqNhV7+DXV4vr2DGgWpA40zwxaBp5AVTQueUVFUOuOveXhl9UtaQQIdVzW33fk
	 Rprw6Igc6TMdsw83wqEwlUT/ca4rlv6/E0K9IxFNk+jx3IYT+MOBV5dOlnaJMZWYMt
	 BX9fAQaHvmTuofHXdj5blTUO91xrqwHStpf561JYmrEbqVwhiYilN4CANAC/JqUuGj
	 /9a/qAYalYaefim+NqL/NOHetuqmAKluhTPFIzPgQdZp3j2aqfa0cgIb0tNy1dMZJW
	 A5OM76N5bFsJw==
Subject:
 Re: [PATCH nf] netfilter: flowtable: advertise the vlan match in used_keys
From: netdev-bot+sashiko@kernel.org
To: julius@bairaktaris.de
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc, coreteam@netfilter.org, netdev@vger.kernel.org, kuba@kernel.org
Date: Thu, 10 Sep 2026 06:22:10 +0000
Message-ID: <178902133043.219967.1427187014791649902@kernel.org>
In-Reply-To: <20260906142018.480577-1-julius@bairaktaris.de>
References: <20260906142018.480577-1-julius@bairaktaris.de>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 1 · Low: 0

- [High] The commit message's only concrete impact claim is false, and
  the bug class it claims to close stays reachable for the driver it…
- [Medium] In the second encap block of nf_flow_rule_match()
  (net/netfilter/nf_flow_table_offload.c:133-152), the `else` branch now…

--

netfilter: flowtable: advertise the vlan match in used_keys

nf_flow_rule_match() fills the vlan and cvlan dissector keys and sets
their offsets, but never sets the matching bits in
match->dissector.used_keys.  This patch sets those bits where the keys
are filled, so that flow_rule_match_key() based drivers can see the
match.

Setting the bits for keys that are actually filled looks right to me.
A couple of questions about the changelog and about the second
encapsulation branch.

The changelog says:

  mtk_ppe_offload.c reads the ingress vlan through flow_rule_match_key()
  and so never gets it, and a driver that checks used_keys against the
  keys it supports installs an entry that ignores the tag.

[Severity: High]
Does the mediatek part of that hold after this change?

mtk_flow_offload_replace() reads FLOW_DISSECTOR_KEY_VLAN only inside
case 0: of its addr_type switch:

	switch (addr_type) {
	case 0:
		offload_type = MTK_PPE_PKT_TYPE_BRIDGE;
		...
		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
			struct flow_match_vlan match;

			flow_rule_match_vlan(rule, &match);
			...
			data.vlan_in = match.key->vlan_id;
		}
		break;
	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
		offload_type = MTK_PPE_PKT_TYPE_IPV4_HNAPT;
		break;

nf_flow_rule_match() always assigns a non-zero addr_type, and bails out
otherwise:

	switch (tuple->l3proto) {
	case AF_INET:
		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
		...
	case AF_INET6:
		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
		...
	default:
		return -EOPNOTSUPP;
	}

so can a flowtable rule ever reach that case 0: read?  And the value it
would store only reaches the hardware for bridge entries:

	if (offload_type == MTK_PPE_PKT_TYPE_BRIDGE)
		foe.bridge.vlan = data.vlan_in;

The driver has no FLOW_DISSECTOR_KEY_CVLAN handling and no used_keys
whitelist, and its FLOW_ACTION_VLAN_POP case is an empty break, so it
neither consumes nor refuses the newly advertised keys and still installs
an HNAPT/IPv6 route entry that does not describe the ingress tag.

Could the mtk_ppe_offload.c sentence be dropped or reworded?  The driver
that does gate on used_keys and reads the vlan/cvlan keys is mlx5e in
__parse_cls_flower(), which the changelog does not name.

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
Can this else branch publish the inner tag as the outer vlan match?

The branch is reached both when the outer tag was already stripped before
the hook (in_vlan_ingress & BIT(0)), where treating encap[1] as the outer
tag is right, and when encap[0] is still present in the frame but is not
ETH_P_8021Q, because of the test in the first block:

	if (tuple->encap_num > 0 && !(tuple->in_vlan_ingress & BIT(0)) &&
	    tuple->encap[0].proto == htons(ETH_P_8021Q)) {

With a stacked 802.1ad plus 802.1Q configuration:

	ip link add link eth0 name eth0.100 type vlan proto 802.1ad id 100
	ip link add link eth0.100 name eth0.100.200 type vlan proto 802.1Q id 200

vlan_dev_fill_forward_path() copies the protocol verbatim:

	path->encap.id = vlan->vlan_id;
	path->encap.proto = vlan->vlan_proto;

and flow_offload_fill_dir() reverses the path order, so encap[0] is the
outermost tag:

	for (i = route->tuple[dir].in.num_encaps - 1; i >= 0; i--) {
		flow_tuple->encap[j].id = route->tuple[dir].in.encap[i].id;
		flow_tuple->encap[j].proto = route->tuple[dir].in.encap[i].proto;

That gives encap[0].proto == ETH_P_8021AD (vid 100) and encap[1].proto ==
ETH_P_8021Q (vid 200).  The first block is skipped, vlan_encap stays
false, and this else branch fills key->vlan with tpid 0x8100 / vid 200
and now declares it in used_keys, so a driver reads an outer vlan match
of 0x8100/200 for a frame whose outermost tag is 0x88a8/100.

nf_flow_rule_route_common() emits a pop only for ETH_P_8021Q encaps:

	if (tuple->encap[i].proto == htons(ETH_P_8021Q)) {
		entry = flow_action_entry_next(flow_rule);
		...
		entry->id = FLOW_ACTION_VLAN_POP;

so the 802.1ad tag is neither matched nor popped.  Before this patch the
mismatched value could not be read by any driver; should this branch be
restricted to the in_vlan_ingress case, or should a non-8021Q encap[0]
make the rule unoffloadable?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260906142018.480577-1-julius%40bairaktaris.de
