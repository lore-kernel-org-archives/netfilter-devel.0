Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794958159;
	b=JjGYIz7WvK2DhvIOBbiQDca568Wk7x+bBQBhgTc5KWNAifwlYPdXcxDNKR7g1p0zDIFB
	 r5XvajAQuAoDOX2xruSNz0uoBiDc24EOZFT60Ba57UnzcyYfmiI4/m42uVTVh/Pbsm8Qa
	 Vg7Pt6zoEY1vdk8lg3ft+rWzransphRiSkrFWuhXsw+Bld3NYIhJ4Hl8HS9YPlZHqPNBH
	 4CkQdVYTzQPCkWpsGKbzqMMNysOXhusEk0Iwdzr/3c27QFQbLAOUtPM28l0MDN3blyama
	 9wPcxEbbcvrJdYqB5werZfIhJSjjYGPijBhl+fncKYrsn0OjDDYDpORwv/IC/FygsJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794958159;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=xWojjaEYs7k9MdSr3s8VPLG+k+lN/V+J6jjJUIs/rZs=;
	b=11dsLpSBbNCc3tN+N3gbwh/X0lZ/hrDNWyElKSeTQUOfPk2URJhDbpm+MDPv1mdFgXiG
	 d9fi2ws8RAhfm6jKBQbqD2GjbOIGchS9Hm5tJFVUbJCJnLQw+j7gMEDN/aeri7z2DIXzL
	 Y0i49NpjQ6sj8wn61Uvr0SerOVCHGq01mVhZjLPGKb632H2TllMQ7Tn6fK6HPLdZTLu2o
	 HiBKgAKy7uB9FtF5MFq07h/bFnekoy78x7Xs8Q28Km4/JpktaIx+xkOLyyQdZKFtiSXn2
	 sDPXatU3j+vTb3ogqlCHF7dFPmSj4WZl6J/Zu34wtqf3HKWXUhP+wiFOXvutVAyx+iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RguWY5nw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D731E606A887;
	Tue, 17 Nov 2026 23:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RguWY5nw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398E11F000C4;
	Tue, 17 Nov 2026 23:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794958159;
	bh=xWojjaEYs7k9MdSr3s8VPLG+k+lN/V+J6jjJUIs/rZs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=RguWY5nwU6o6w/MIbfNUGWqe2DvbBb2k7NjIle6kG40haaaf6BwtzeXuQNTJ0W9Yw
	 ZVnwolLPXFeyrhdOcsjohRgC1ZuhW5Vyycxe6F9p6KXZ2ax/81gV6RRC2rhHqR3pZk
	 OrGJnK790dM0kuLQsmZwg8O8btHuf8KTzn77tzudwgrdgL3F9p89HJ2/hdW8er84b+
	 THH6gpS2yk/rIb/PTQj7r1zesHsM26dUlV49g3t8BZIOeiKNOYop0RxjLVyIomgwRd
	 eZM8PQJaWlTohyA3Z7AGjN+6jbHpdrDXzcRt2Cza2cwVP+PYL7C/zm2yWZSJGzO+6Z
	 kewmP2g4RjUJQ==
Subject: Re: [PATCH net-next 2/9] netfilter: flowtable: reject non-host IPv4
 packets before lookup
From: netdev-bot+sashiko@kernel.org
To: florian.fainelli@broadcom.com
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, horms@kernel.org,
 corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Date: Tue, 17 Nov 2026 23:29:17 +0000
Message-ID: <179495815781.3136.11457762484354834526@kernel.org>
In-Reply-To: <20261116222519.1416501-3-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-3-florian.fainelli@broadcom.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new early return in nf_flow_offload_ip_hook()
  (net/netfilter/nf_flow_table_ip.c:915) checks skb->pkt_type at netdev…
- [High] The fix only covers IPv4.
- [Low] The commit trailer reads 'Signed-off-by: FLorian Fainelli
  <florian.fainelli@broadcom.com>', but the author is 'Florian Fainelli'…

--

netfilter: flowtable: reject non-host IPv4 packets before lookup

This commit makes nf_flow_offload_ip_hook() return early when pkt_type is
not PACKET_HOST. Those packets then go to the normal IPv4 stack before the
flowtable lookup. The goal is to apply the same PACKET_HOST check that the
classic IPv4 forwarding path uses.

> Fixes: 97add9f0d66d ("netfilter: flow table support for IPv4")
>
> Signed-off-by: FLorian Fainelli <florian.fainelli@broadcom.com>

[Severity: Low]
This isn't a bug, but the Signed-off-by name has a typo ("FLorian") and
does not match the author name ("Florian Fainelli"). There is also an
extra blank line between the Fixes: tag and the Signed-off-by: tag.

> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 19cafae748abe..98bade1b82994 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -911,6 +911,10 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>  	};
>  	int ret;
>  
> +	/* The ingress hook runs before IPv4 rejects non-host Ethernet frames. */
> +	if (unlikely(skb->pkt_type != PACKET_HOST))
> +		return NF_ACCEPT;

[Severity: High]
Could this turn off the software fast path for flows that pass through a
bridge or VLAN upper device?

This hook runs at netdev ingress on the lower device. At that point
pkt_type still holds what eth_type_trans() set by comparing h_dest with
the lower device's own MAC. In __netif_receive_skb_core(), nf_ingress()
runs before both places that reclassify the frame:

__netif_receive_skb_core()
    nf_ingress()          <- nf_flow_offload_ip_hook() runs here
    vlan_do_receive()
    rx_handler()          <- br_handle_frame()

net/8021q/vlan_core.c:vlan_do_receive() {
    ...
	if (unlikely(skb->pkt_type == PACKET_OTHERHOST)) {
		/* ... */
		if (ether_addr_equal_64bits(eth_hdr(skb)->h_dest, vlan_dev->dev_addr))
			skb->pkt_type = PACKET_HOST;
	}
    ...
}

net/bridge/br_input.c:br_handle_frame() {
    ...
	if (ether_addr_equal(p->br->dev->dev_addr, dest))
		skb->pkt_type = PACKET_HOST;
    ...
}

The flowtable supports DEV_PATH_BRIDGE and DEV_PATH_VLAN paths.
nft_dev_path_info() puts the upper device's dev_addr in h_source, but the
ingress ifindex is the lower port. Hosts therefore send routed traffic to
the bridge or VLAN MAC.

Two setups hit this:

  - A bridge port whose MAC differs from the bridge MAC. This is common in
    a multi-port bridge, because the bridge takes one port's MAC.
  - A VLAN device with its own MAC.

In both cases, every packet of an offloaded flow would be PACKET_OTHERHOST
at this hook. It would return NF_ACCEPT before nf_flow_offload_lookup().
The IPv4 stack later sees PACKET_HOST and forwards these packets.

Given that, does the patch keep "the IPv4 input path's forwarding
decision", as the commit message says? Would it work better to compare
h_dest with the address the flow expects (for example after the tuple
lookup) rather than test the lower device's raw pkt_type?

> +
>  	if (!nf_flow_skb_encap_protocol(&ctx, skb))
>  		return NF_ACCEPT;
>  

[Severity: High]
Is the same bypass still open for IPv6? In the same file,
nf_flow_offload_ipv6_hook() has no pkt_type check. It goes straight to the
lookup, forward and nf_flow_queue_xmit6() steps:

net/netfilter/nf_flow_table_ip.c:nf_flow_offload_ipv6_hook() {
    ...
	if (!nf_flow_skb_encap_protocol(&ctx, skb))
		return NF_ACCEPT;

	if (unlikely(ctx.ether_type != htons(ETH_P_IPV6)))
		return NF_ACCEPT;

	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
    ...
}

Classic IPv6 forwarding drops these frames:

net/ipv6/ip6_output.c:ip6_forward() {
    ...
	if (skb->pkt_type != PACKET_HOST)
		goto drop;
    ...
}

nf_flow_offload_inet_hook() sends ETH_P_IPV6 to the unpatched hook. With
this patch, an inet flowtable would reject non-host frames for IPv4. For
IPv6 it would still forward frames sent to an unrelated unicast,
broadcast or multicast MAC, as long as the 5-tuple matches an installed
flow.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116222519.1416501-1-florian.fainelli%40broadcom.com
