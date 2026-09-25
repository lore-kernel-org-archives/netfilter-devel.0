Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBE636E489;
	Fri, 25 Sep 2026 09:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327159; cv=none; b=B5XwUv5N+FCjVrT2pkJsftQlXMDldsaeHvILmSV1w80MWCBFlOs/3RwNtstuBjGrmBNxbS1H9mYrhA8zuMcuaZyopkvE2wK77frKgT7Li1/VWmAiwGO0K1CKUCPHAidRWv55TkYIRt2vJj76TOnCoR0VzumjLAqaYhU7ZXcoFh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327159; c=relaxed/simple;
	bh=7LV/aD5+mMsAecmyRezNCXaU/dWwdhQYkfV2dObExmQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ii3uqnhOWfBsA0yqKqWcyGoeHaAprVsL/9o1PoT1EQpRARxaID4kHEEfUf13kmHWAjUIGbXfH4A/60jP9GP2k0XZvmPTYNB62po2oCNE0kNAa9nv1/ZuKYK4SbtEOQF92IVD1vQ/azJQTXDfVemHoC1LTOecX7oMGAvKp3c2u0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJvcx/vd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJvcx/vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD8D1F000FF;
	Fri, 25 Sep 2026 09:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790327156;
	bh=IbK+Lo/xc961CZf/u+zK596Ys68UUBMJlOVSgE8Qj3o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=iJvcx/vd4cF6OYzQX4pHDBc9zRG7rO83nuTYtE3p6oIFyoGOodpHfL2fv4854l1tS
	 R59gaKS9BPtBDj2sqyWJKF1wsR0zkn4cU0yYJl/TGFF46V9bcW0EbdEnjoJactZqJt
	 KYd00NlrsEmqs1iz/dD8z1CngtN62HdWoI1j32OGzcw7geF/JL/KWoDpJgNo3e4q/y
	 sksMX3yJJkPYxLR5YVDdAi2qj90B67lAHA6iCmf9Za3S/n0bsuOd7OzJtcmiWx/dWn
	 ZPlAQZBhaLRa3+EGHqKHhbsIVwJq480nfNNwNQPgzW2e70658ZM9gkMTza4ubdK3LE
	 h94uvLkmej6FA==
Subject: Re: [PATCH net v6 1/2] net: validate virtio checksum start after
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
Date: Fri, 25 Sep 2026 09:05:54 +0000
Message-ID: <179032715478.2160803.9291442689443169324@kernel.org>
In-Reply-To: <20260922030310.8684-2-habte.yibelo@gmail.com>
References: <20260922030310.8684-2-habte.yibelo@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Undisclosed tightening of an existing uAPI in a stable-tagged
  patch.
- [Low] Commit message does not describe the actual defect and states no
  user-visible symptom for a Fixes:/Cc: stable patch.
- [Low] The new Ethernet/VLAN parser invoked from raw_verify_header()
  (arch/um/drivers/vector_transports.c) treats the skb's current length…
- [Low] Reported for completeness, but the claimed bypass does not reach
  the asserted malformed geometry.

--

net: validate virtio checksum start after network header

This passes a data-relative L3 offset and L3 protocol into
__virtio_net_hdr_to_skb() and virtio_net_hdr_tnl_to_skb(), adds an
Ethernet/VLAN parser (virtio_net_hdr_eth_get_l3_offset()) used by
AF_PACKET, tap/tun, virtio_net and the UML vector raw transport, and
tightens the CHECKSUM_PARTIAL minimum-header check accordingly.

Link: https://lore.kernel.org/netdev/20260920004733.6473-2-habte.yibelo@gmail.com/

A few questions below.

The changelog says:

> __virtio_net_hdr_to_skb() checks a minimum network-header length for
> CHECKSUM_PARTIAL packets. Its checksum start is relative to skb->data,
> but some callers have not established skb->network_header when they
> convert the virtio header.

[Severity: Low]
Is this the actual defect?  The pre-patch test in __virtio_net_hdr_to_skb()
is:

	if (skb_transport_offset(skb) < nh_min_len)
		return -EINVAL;

	nh_min_len = skb_transport_offset(skb);

which never reads skb->network_header, so an unestablished network header
does not affect it.

What the old test misses looks different: the minimum is measured from
skb->data, which for the Ethernet-framed callers (AF_PACKET, tap,
virtio_net, UML raw/tap) is the MAC header, so a csum_start of 20..33 passes
while leaving fewer than 20 bytes of L3 header.

Also, for AF_PACKET the caller does establish the network header before
conversion:

net/packet/af_packet.c:packet_parse_headers() {
	...
	if (likely(skb->dev->type == ARPHRD_ETHER) &&
	    eth_type_vlan(skb->protocol) &&
	    vlan_get_protocol_and_depth(skb, skb->protocol, &depth) != 0)
		skb_set_network_header(skb, depth);
}

Could the changelog describe the data-relative minimum instead of the
network header, and also state the user-visible symptom?  With two Fixes:
tags and Cc: stable, and Reported-by: naming the author, there is no
reproducer or symptom given.  The referenced commit 49d14b54a527 documented
its own symptom (the "offset (-6) >= skb_headlen() (14)" warning from
skb_checksum_help() via ip_do_fragment()); is the same warning, a
mis-placed checksum, or something else being fixed here?

> diff --git a/arch/um/drivers/vector_transports.c b/arch/um/drivers/vector_transports.c
> index ddd127ee96785..5a9d8f49a64ba 100644
> --- a/arch/um/drivers/vector_transports.c
> +++ b/arch/um/drivers/vector_transports.c
> @@ -197,6 +197,8 @@ static int raw_verify_header(
>  	uint8_t *header, struct sk_buff *skb, struct vector_private *vp)
>  {
>  	struct virtio_net_hdr *vheader = (struct virtio_net_hdr *) header;
> +	__be16 network_protocol;
> +	int network_offset;
>  
>  	if ((vheader->gso_type != VIRTIO_NET_HDR_GSO_NONE) &&
>  		(vp->req_size != 65536)) {
> @@ -209,8 +211,14 @@ static int raw_verify_header(
>  	if ((vheader->flags & VIRTIO_NET_HDR_F_DATA_VALID) > 0)
>  		return 1;
>  
> -	virtio_net_hdr_to_skb(skb, vheader, virtio_legacy_is_little_endian());
> -	return 0;
> +	network_offset = virtio_net_hdr_eth_get_l3_offset(skb, vheader,
> +							  &network_protocol);
> +	if (network_offset < 0)
> +		return network_offset;

[Severity: Low]
Does this parse bytes that have not been received yet?  Both UML receive
callers run verify_header() before the skb is trimmed to the recvmsg
result, and prep_skb() has already set the length to the full buffer
capacity:

arch/um/drivers/vector_kern.c:prep_skb() {
	...
	skb_put(result, vp->max_packet);
	result->data_len = len - vp->max_packet;
	result->len += len - vp->max_packet;
	...
}

arch/um/drivers/vector_kern.c:vector_legacy_rx() {
	...
	header_check = vp->verify_header(vp->header_rxbuffer, skb, vp);
	...
	pskb_trim(skb, pkt_len - vp->rx_header_size);
	...
}

vector_mmsg_rx() has the same ordering.

virtio_net_hdr_eth_get_l3_offset() bounds its reads with
skb_header_pointer(), i.e. against skb_headlen(), so for a NEEDS_CSUM frame
that was truncated inside its Ethernet or nested VLAN headers the parser
reads stale bytes of the freshly allocated head rather than reporting a
short header.  The resulting network_offset/network_protocol, and now the
return value of raw_verify_header(), then come from uninitialized buffer
contents.

Would it make sense for the callers to establish the received length before
calling verify_header()?

> +
> +	return virtio_net_hdr_to_skb(skb, vheader,
> +				     virtio_legacy_is_little_endian(),
> +				     network_offset, network_protocol);
>  }
>  
>  static bool get_uint_param(

[ ... ]

> diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
> index f4c652b1fa44d..e004213fad22c 100644
> --- a/drivers/net/tun_vnet.h
> +++ b/drivers/net/tun_vnet.h
> @@ -177,10 +177,49 @@ static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
>  	return __tun_vnet_hdr_put(sz, 0, iter, hdr);
>  }
>  
> +static inline int
> +tun_vnet_hdr_get_l3_offset(unsigned int flags, const struct sk_buff *skb,
> +			   const struct virtio_net_hdr *hdr,
> +			   __be16 *network_protocol)
> +{
> +	if ((flags & TUN_TYPE_MASK) != IFF_TAP) {
> +		u8 version, first_byte;
> +		const u8 *first;
> +
> +		*network_protocol = 0;
> +		if (!(hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
> +			return 0;
> +
> +		first = skb_header_pointer(skb, 0, sizeof(first_byte),
> +					   &first_byte);
> +		if (!first)
> +			return -EINVAL;
> +
> +		version = *first >> 4;
> +		if (version == 4)
> +			*network_protocol = htons(ETH_P_IP);
> +		else if (version == 6)
> +			*network_protocol = htons(ETH_P_IPV6);
> +		return 0;
> +	}

[Severity: Low]
For IFF_TUN this derives network_protocol from the payload version nibble,
while skb->protocol is set later from the user-supplied tun_pi.proto:

drivers/net/tun.c:tun_get_user() {
	...
	case IFF_TUN:
		if (tun->flags & IFF_NO_PI) {
			...
			ip_version = skb->data[0] >> 4;
			...
		}
		skb_reset_mac_header(skb);
		skb->protocol = pi.proto;
	...
}

The nibble/pi.proto consistency check only runs under IFF_NO_PI, so a
writer can declare pi.proto = ETH_P_IPV6 with a first nibble of 4, keeping
nh_min_len at sizeof(struct iphdr) while the stack labels the skb IPv6.

That particular combination looks harmless in practice, since
ip6_rcv_core() drops it before any header parsing:

net/ipv6/ip6_input.c:ip6_rcv_core() {
	...
	if (hdr->version != 6) {
		SKB_DR_SET(reason, UNHANDLED_PROTO);
		goto err;
	}
	...
}

and a genuine IPv6 payload always yields nibble 6 and thus the intended
40-byte minimum.  Still, is keying the length bound off the payload nibble
while the rest of the stack acts on pi.proto intentional here?

> +
> +	return virtio_net_hdr_eth_get_l3_offset(skb, hdr,
> +					      network_protocol);
> +}
> +

[ ... ]

> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e34c52d059d39..8e93dad287911 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2515,9 +2517,13 @@ static void virtnet_receive_done(struct virtnet_info *vi, struct receive_queue *
>  		goto frame_err;
>  	}
>  
> -	if (virtio_net_hdr_tnl_to_skb(skb, &hdr->tnl_hdr, vi->rx_tnl,
> +	network_offset = virtio_net_hdr_eth_get_l3_offset(skb, &hdr->hdr,
> +							  &network_protocol);
> +	if (network_offset < 0 ||
> +	    virtio_net_hdr_tnl_to_skb(skb, &hdr->tnl_hdr, vi->rx_tnl,
>  				      vi->rx_tnl_csum,
> -				      virtio_is_little_endian(vi->vdev))) {
> +				      virtio_is_little_endian(vi->vdev),
> +				      network_offset, network_protocol)) {
>  		net_warn_ratelimited("%s: bad gso: type: %x, size: %u, flags %x tunnel %d tnl csum %d\n",
>  				     dev->name, hdr->hdr.gso_type,
>  				     hdr->hdr.gso_size, hdr->hdr.flags,
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index c381b916c1b54..b89d821a0dd2d 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -48,16 +48,61 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,

[ ... ]

>  static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
>  					  const struct virtio_net_hdr *hdr,
> -					  bool little_endian, u8 hdr_gso_type)
> +					  bool little_endian, u8 hdr_gso_type,
> +					  int network_offset,
> +					  __be16 network_protocol)
>  {
> -	unsigned int nh_min_len = sizeof(struct iphdr);
> +	int nh_min_len = sizeof(struct iphdr);
>  	unsigned int gso_type = 0;
>  	unsigned int thlen = 0;
>  	unsigned int p_off = 0;
>  	unsigned int ip_proto;
>  
> +	if (network_protocol == htons(ETH_P_IPV6))
> +		nh_min_len = sizeof(struct ipv6hdr);
> +

[ ... ]

> @@ -98,16 +143,20 @@ static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
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

[Severity: Medium]
Does this change the accepted csum_start range for existing users, and
should the changelog say so?

The floor moves from 20 (relative to skb->data) to parsed_L3_offset + 20 or
40: 34 for a plain Ethernet frame, 54 for Ethernet plus IPv6, and more with
VLAN or QinQ.

Three concrete behaviour changes:

- AF_PACKET sendmsg() and tpacket_snd() now return -EINVAL for virtio
  headers with csum_start in 20..33 that were accepted before.

- The new

	if (network_protocol == htons(ETH_P_IPV6))
		nh_min_len = sizeof(struct ipv6hdr);

  applies the 40-byte minimum to any frame whose parsed ethertype is
  ETH_P_IPV6, whereas previously only VIRTIO_NET_HDR_GSO_TCPV6 did that.

- On the receive side, virtnet_receive_done() now takes the frame_err path
  (DEV_STATS_INC(rx_frame_errors) plus dev_kfree_skb) for host descriptors
  that were accepted before.

There is also the non-IP case: when the parsed ethertype is neither
ETH_P_IPV4 nor ETH_P_IPV6, nh_min_len stays sizeof(struct iphdr), so a
non-IP Ethernet frame whose checksum field sits close to the L2 header is
rejected even though it has no 20-byte L3 header at all.  Is that
intended?

Given the Cc: stable, would it be worth stating the new accept/reject
boundary in the changelog and adding a selftest that pins it?

> -		nh_min_len = skb_transport_offset(skb);
> +		nh_min_len = transport_offset;
>  		p_off = nh_min_len + thlen;
>  		if (!pskb_may_pull(skb, p_off))
>  			return -EINVAL;

[ ... ]

> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 50cae32ae2692..0b37d5474f868 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -3103,7 +3123,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  	packet_parse_headers(skb, sock);
>  
>  	if (vnet_hdr_sz) {
> -		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
> +		err = packet_vnet_hdr_to_skb(skb, &vnet_hdr);
>  		if (err)
>  			goto out_free;
>  		len += vnet_hdr_sz;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922030310.8684-1-habte.yibelo%40gmail.com
