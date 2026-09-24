Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42BD3264DD;
	Thu, 24 Sep 2026 08:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790240084; cv=none; b=KzaIQtQV3rUahnk8KyRyLN2C7HvMAJvwE+/u9BnkpmsC7Ro12jT7D32VZinWH5XH5CsPt+vh9aar7OB5XRlJABS4tNidpw4Ihu0xvtSYckm5Jz25YCXwUCprWyWDk7OCWURV2zObxaVe5QIgLN7oV0frhl0iR5GimAaYvfOQrOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790240084; c=relaxed/simple;
	bh=6D3CTgHdu5481mnLKV1gPqeZJ095pUnPyFYt/9xV+nk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c36Jzx9u4iMMxwjb/ZDcC0WNR9JggsqN2H/5y411kGc9hjvck03jCQ2fLwCmuvh6IRdgbJ5OcJYvEm95FrfNaINlONiSubUDn7htu+UcdghwdskzjphFNhSktQPy4/DvrtimmqsYSMfciReAjWbkp1XzgkiqtYoA2KKNPwhDwtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxRwVj38; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxRwVj38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233091F000FF;
	Thu, 24 Sep 2026 08:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790240082;
	bh=yrKvdoHKHUrs0CoJeIfRXejqns+60AzL+8SidZjSbMU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IxRwVj38L74+kDKcCYCdkYQF8nKO0ZnsIc9/rmmL6kfkopkLeddsUKVEaHtlWWFIj
	 N6rsBFO8xnYezDnBeF1xdwyoHS7z+60zWeHGNcSCdH/pXC5YXN+8BalUu1Qnri+x+c
	 3Bk5zVomRExPIcYxQ+7TLMOBBMOLmLzAJ66rZX8qsZ4b2Kt9ET3tKvSzY9vqW7i21a
	 zKJcEzUQSCcAeRAo53rGp21/SmzSZNuDOIMl9hpZQhjnOP3u4Ixg/85QrqxEw3M+kJ
	 /qCm0oDbtkpx3GL5WovjU8Okb5UDrdkcKE54LyeC3Zo1E4gfY52uLpfXFsQNt7I7d+
	 D8Ce8oxiJt8hw==
Subject: Re: [PATCH net v5 1/2] net: validate virtio checksum start after
 network header
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
Date: Thu, 24 Sep 2026 08:54:40 +0000
Message-ID: <179024008066.2160803.8682461497509944706@kernel.org>
In-Reply-To: <20260921025341.44846-2-habte.yibelo@gmail.com>
References: <20260921025341.44846-2-habte.yibelo@gmail.com>
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
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The two AF_PACKET call sites pass skb_network_offset(skb) as the
  new `network_offset` argument, while every other converted caller…
- [Medium] In arch/um/drivers/vector_transports.c:raw_verify_header(),
  the newly added virtio_net_hdr_get_l3_offset() parse and the now-…

--

net: validate virtio checksum start after network header

This adds an explicit data-relative L3 offset argument to
virtio_net_hdr_to_skb() and virtio_net_hdr_tnl_to_skb() so that a
CHECKSUM_PARTIAL start landing inside the network header is rejected.  A new
helper virtio_net_hdr_get_l3_offset() parses Ethernet and nested VLAN headers
with skb_header_pointer(), and all in-tree callers are converted.

Link: https://lore.kernel.org/netdev/20260920004733.6473-2-habte.yibelo@gmail.com/

> diff --git a/arch/um/drivers/vector_transports.c b/arch/um/drivers/vector_transports.c
> index ddd127ee9678..79bc05fc6f73 100644
> --- a/arch/um/drivers/vector_transports.c
> +++ b/arch/um/drivers/vector_transports.c
> @@ -197,6 +197,7 @@ static int raw_verify_header(
>  	uint8_t *header, struct sk_buff *skb, struct vector_private *vp)
>  {
>  	struct virtio_net_hdr *vheader = (struct virtio_net_hdr *) header;
> +	int network_offset;
>  
>  	if ((vheader->gso_type != VIRTIO_NET_HDR_GSO_NONE) &&
>  		(vp->req_size != 65536)) {
> @@ -209,8 +210,13 @@ static int raw_verify_header(
>  	if ((vheader->flags & VIRTIO_NET_HDR_F_DATA_VALID) > 0)
>  		return 1;
>  
> -	virtio_net_hdr_to_skb(skb, vheader, virtio_legacy_is_little_endian());
> -	return 0;
> +	network_offset = virtio_net_hdr_get_l3_offset(skb, vheader);
> +	if (network_offset < 0)
> +		return network_offset;
> +
> +	return virtio_net_hdr_to_skb(skb, vheader,
> +				     virtio_legacy_is_little_endian(),
> +				     network_offset);
>  }

[Severity: Medium]
Is the skb passed to raw_verify_header() already trimmed to the received
frame length at this point?

prep_skb() in arch/um/drivers/vector_kern.c sets the length from the
receive buffer capacity, before the recvmsg/recvmmsg:

	skb_put(result, vp->max_packet);
	result->data_len = len - vp->max_packet;
	result->len += len - vp->max_packet;

and both receive loops call the verify callback before the trim:

vector_legacy_rx():
			header_check = vp->verify_header(
				vp->header_rxbuffer, skb, vp);
			if (header_check < 0) { ... return 0; }
		}
		pskb_trim(skb, pkt_len - vp->rx_header_size);

vector_mmsg_rx() has the same ordering.  The only guarantee before the
callback is pkt_len > vp->header_size, i.e. one payload byte.

So can the Ethernet and VLAN bytes that virtio_net_hdr_get_l3_offset()
reads at offsets 0..13 and beyond be bytes recvmsg never wrote, i.e. the
uninitialised remainder of the allocation, making network_offset and the
accept/reject decision depend on stale buffer contents whenever the
received frame is shorter than the parsed span?

Along the same lines, the length checks inside __virtio_net_hdr_to_skb()
see skb->len as capacity (up to vp->req_size, 65536 with GSO) rather than
the received length, for instance:

			if (skb->len - p_off > gso_size * UDP_MAX_SEGMENTS)
				return -EINVAL;

Since raw_verify_header() now returns the converter's error instead of
discarding it, does this turn the length mismatch into frames dropped with
rx_encaps_errors, where previously the return value was ignored?  Would it
be better to move the pskb_trim() ahead of the verify_header() call?

> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index c381b916c1b5..a4c005796acb 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h

[ ... ]

> @@ -98,16 +136,20 @@ static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
>  		u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
>  		u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
>  		u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
> +		int transport_offset;
>  
>  		if (!pskb_may_pull(skb, needed))
>  			return -EINVAL;
>  
>  		if (!skb_partial_csum_set(skb, start, off))
>  			return -EINVAL;
> -		if (skb_transport_offset(skb) < nh_min_len)
> +
> +		transport_offset = skb_transport_offset(skb);
> +		if (transport_offset < nh_min_len || network_offset < 0 ||
> +		    network_offset > transport_offset - nh_min_len)
>  			return -EINVAL;

[ ... ]

> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 50cae32ae269..04c80e23d7e2 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2901,7 +2901,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  		}
>  
>  		if (has_vnet_hdr) {
> -			if (virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le())) {
> +			if (virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le(),
> +						  skb_network_offset(skb))) {
>  				tp_len = -EINVAL;
>  				goto tpacket_error;
>  			}
> @@ -3103,7 +3104,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  	packet_parse_headers(skb, sock);
>  
>  	if (vnet_hdr_sz) {
> -		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
> +		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le(),
> +					    skb_network_offset(skb));
>  		if (err)
>  			goto out_free;
>  		len += vnet_hdr_sz;

[Severity: High]
Is skb_network_offset(skb) a strong enough origin here?  Every other
converted caller derives the offset from the frame bytes via
virtio_net_hdr_get_l3_offset(), while these two use the network header
AF_PACKET established itself.

In packet_parse_headers() the VLAN adjustment is gated on the
socket-supplied protocol:

	if (likely(skb->dev->type == ARPHRD_ETHER) &&
	    eth_type_vlan(skb->protocol) &&
	    vlan_get_protocol_and_depth(skb, skb->protocol, &depth) != 0)
		skb_set_network_header(skb, depth);

For SOCK_RAW with an explicit sll_protocol, skb->protocol is the value the
sender passed, not the frame's EtherType (dev_parse_header_protocol() runs
only when skb->protocol is 0 or ETH_P_ALL).

So for a sender that binds with sll_protocol = htons(ETH_P_IP) but writes
an 802.1Q-tagged frame, network_offset stays 14 while the real IPv4 header
starts at 18.  With csum_start = 34 and nh_min_len = 20, the new test
becomes:

	transport_offset = 34;
	34 < 20                      -> false
	14 > 34 - 20                 -> 14 > 14 -> false

and the header is accepted, after skb_partial_csum_set() has already set
ip_summed = CHECKSUM_PARTIAL and transport_header = 34, which is 16 bytes
inside the IPv4 header spanning 18..37.  Is that not exactly the case the
commit message says is now rejected?

Two related cases in the same path:

packet_parse_headers() silently ignores a failed
vlan_get_protocol_and_depth() (more nested tags than that parser accepts),
leaving network_offset at 14 for a deeper real L3 header.

In packet_snd(), the SOCK_RAW short-packet branch resets the network header
while skb->data still points at the link header:

	} else if (reserve) {
		skb_reserve(skb, -reserve);
		if (len < reserve + sizeof(struct ipv6hdr) &&
		    dev->min_header_len != hard_header_len)
			skb_reset_network_header(skb);
	}

which yields network_offset == 0, and the new bound then reduces to the
pre-patch csum_start >= 20 check.  Would using
virtio_net_hdr_get_l3_offset() at both AF_PACKET call sites, as the TAP and
virtio-net paths do, keep the origin consistent?

Note the follow-up commit in this area, "ip: reject partial checksums
covering network headers", only touches ip_do_fragment(), ip6_fragment(),
nf_br_ip_fragment() and br_ip6_fragment(), so it does not close this
AF_PACKET path later in the series.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921025341.44846-1-habte.yibelo%40gmail.com
