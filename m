Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6E6440A0A;
	Thu, 24 Sep 2026 08:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790240085; cv=none; b=Ql996eOF25Rvvko/6/jDSg8dDBTcTkMqIlSt02NtxOgjXfK3JnCJXx64wgtV0qmedjdSDC1zflwB8C2nVqMkXYF5EoUxjJoearhUfnSTpHqCDQbgReQNaQa8IQo8SNAn08X0r1zl4zNu+BA66Z83MB5+jr/CFwN0u2iS0WJhVF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790240085; c=relaxed/simple;
	bh=TV8Z7K1B430nmrx4RxP9GhNrhORYFJqb7ijzTdoyBzw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GQN4P1KRDp3ihrz+hU5ilwCnJVU1kNlFN7sTx5KfZ60lc8IDBI/QyFPNpA9oNwPwHtRC0VnhJfkHnP3Va3On1vQ2FiqNMxe0posKWKcSU5gEmR9R0773BCzhMOjiOqQml29nIBT+J8XGyLe3K5z6wus4YVm6EtMAQdXuiPlJy5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DIr8ujDr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DIr8ujDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311AD1F00893;
	Thu, 24 Sep 2026 08:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790240084;
	bh=4UCBH/32GF80p+YqMwpZQ9XIhB9sDp2LihECBye/aG4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DIr8ujDrKNW1g6JkqymaHjfghHmbJIXAVuOUuFvxERsDC2pMvT+BjXDhrg5+JVYRZ
	 f2wbrlDX+23iABnSh0R8Rbz75adMIHhcgW4yzRDY2gbTp009yTHeKNpRFgr082IuYx
	 WgqkgnbH2pmZxfixJ3gcetf5nLJyJFGopB+nCtmpEMce5WewsuVMwdE8E5WUh2cRg5
	 NlmVVqDQw/LWgpXUG3sZaxYcLAFC8UF2x3roWOPEL5PS1E/lT0ty2lmvgJlRIPO1eJ
	 4voPIz2qSWQCHlQM+82f7e4fCL3qWQTC5kEpcGEKPnsrp4pf5cq2qzAcIWritxfUhP
	 8YOPJJ5xJwFbA==
Subject:
 Re: [PATCH net v5 2/2] ip: reject partial checksums covering network headers
From: netdev-bot+sashiko@kernel.org
To: habte.yibelo@gmail.com
Cc: netdev@vger.kernel.org, richard@nod.at, anton.ivanov@cambridgegreys.com,
 johannes@sipsolutions.net, willemdebruijn.kernel@gmail.com,
 jasowangio@gmail.com, mst@redhat.com, eperezma@redhat.com,
 xuanzhuo@linux.alibaba.com, andrew+netdev@lunn.ch, pablo@netfilter.org,
 fw@strlen.de, phil@nwl.cc, razor@blackwall.org, idosch@nvidia.com,
 dsahern@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, linux-um@lists.infradead.org,
 virtualization@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Thu, 24 Sep 2026 08:54:42 +0000
Message-ID: <179024008278.2160803.5921856763560195179@kernel.org>
In-Reply-To: <20260921025341.44846-3-habte.yibelo@gmail.com>
References: <20260921025341.44846-3-habte.yibelo@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Incomplete fix: the checksum-start validation is added only at
  the four fragmentation entry points (ip_do_fragment(),…

--

ip: reject partial checksums covering network headers

This adds a check that the CHECKSUM_PARTIAL start offset lies at or after
the parsed network header before calling skb_checksum_help() in the four
fragmentation entry points ip_do_fragment(), nf_br_ip_fragment(),
ip6_fragment() and br_ip6_fragment().  For IPv4 the IHL is read and
validated first and iph is reacquired after the checksum is completed.

Link: https://lore.kernel.org/netdev/20260920004733.6473-3-habte.yibelo@gmail.com/

> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index a24cc8ee11d3..fa6a74d205e2 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -770,16 +770,28 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
>  	struct ip_frag_state state;
>  	int err = 0;
>  
> -	/* for offloaded checksums cleanup checksum before fragmentation */
> -	if (skb->ip_summed == CHECKSUM_PARTIAL &&
> -	    (err = skb_checksum_help(skb)))
> -		goto fail;
> -
>  	/*
>  	 *	Point into the IP datagram header.
>  	 */
>  
>  	iph = ip_hdr(skb);
> +	hlen = iph->ihl * 4;
> +	if (unlikely(hlen < sizeof(*iph) || hlen > skb_headlen(skb))) {
> +		err = -EINVAL;
> +		goto fail;
> +	}
> +
> +	/* Complete offloaded checksums only after the validated IP header. */
> +	if (skb->ip_summed == CHECKSUM_PARTIAL) {
> +		if (unlikely(skb_checksum_start_offset(skb) < (int)hlen)) {
> +			err = -EINVAL;
> +			goto fail;
> +		}
> +		err = skb_checksum_help(skb);
> +		if (err)
> +			goto fail;
> +		iph = ip_hdr(skb);
> +	}

[Severity: High]
The guard is added at the four fragmentation entry points, but the
offending csum_start stays on the skb.  Is the bug class named in the
subject still reachable for packets that are not fragmented?

The generic transmit path completes the same checksum without any
comparable check:

net/core/dev.c:validate_xmit_skb() {
	...
		if (skb_csum_hwoffload_help(skb, features))
			goto out_kfree_skb;
	...
}

net/core/dev.c:skb_csum_hwoffload_help() {
	...
sw_checksum:
	return skb_checksum_help(skb);
}

and so does xfrm_output():

net/xfrm/xfrm_output.c:xfrm_output() {
	...
	if (skb->ip_summed == CHECKSUM_PARTIAL) {
		err = skb_checksum_help(skb);
	...
}

For the IPv6 case described in the changelog, a tun/tap or virtio client
can supply csum_start=34 and csum_offset=6 on a non-GSO frame.  In
__virtio_net_hdr_to_skb() nh_min_len is sizeof(struct iphdr) for non-GSO
frames, so the ingress check passes with network_offset==ETH_HLEN and
transport_offset==34:

include/linux/virtio_net.h:__virtio_net_hdr_to_skb() {
	...
		transport_offset = skb_transport_offset(skb);
		if (transport_offset < nh_min_len || network_offset < 0 ||
		    network_offset > transport_offset - nh_min_len)
			return -EINVAL;
	...
}

After eth_type_trans() pulls ETH_HLEN, skb_checksum_start_offset(skb) is
20, which is inside the 40 byte IPv6 header.  If the frame fits the MTU it
never reaches ip6_fragment(), and skb_csum_hwoffload_help() takes the
sw_checksum path on a device without NETIF_F_HW_CSUM because
skb_network_header_len(skb) is 20 rather than sizeof(struct ipv6hdr).  Can
the fold then land at offset 26, inside ipv6_hdr()->daddr, after routing
and netfilter have already validated the original destination?  The IPv4
equivalent is a start offset of 20 with ihl*4 up to 60, overwriting option
bytes of the transmitted packet.

The same applies to the WARN_ONCE motivation in the changelog:

    A negative checksum-start offset is rejected
    by skb_checksum_help(), but only after a WARN_ONCE which can panic a
    panic_on_warn system.

In skb_checksum_help() the signed offset is compared with the unsigned
skb_headlen(), so a negative value promotes and takes the
DO_ONCE_LITE(skb_dump) plus WARN_ONCE() branch:

net/core/dev.c:skb_checksum_help() {
	...
	offset = skb_checksum_start_offset(skb);
	ret = -EINVAL;
	if (unlikely(offset >= skb_headlen(skb))) {
		DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
		WARN_ONCE(true, "offset (%d) >= skb_headlen() (%u)\n",
	...
}

Any skb that could carry such an offset into ip_do_fragment() also reaches
skb_csum_hwoffload_help() unchanged when the packet fits the MTU, so is the
panic_on_warn case still open there?

Would it be preferable to validate where csum_start is established or
invalidated, that is in skb_partial_csum_set() and
__virtio_net_hdr_to_skb() relative to the eth_type_trans() pull, or inside
skb_checksum_help() itself, rather than open coding the same test in four
consumers?

Since the patch carries its own Fixes: tags and Cc: stable and will be
backported on its own, could the changelog state whether an ingress side
companion fix exists, or that the remaining skb_checksum_help() callers are
knowingly left unguarded?  As written, the subject "reject partial
checksums covering network headers" reads as a general property while only
the fragmentation paths are covered.

The memory safety part specific to fragmentation, iph->ihl being mutated
after routing and then used by the fragmentation loops, does look closed by
this change.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921025341.44846-1-habte.yibelo%40gmail.com
