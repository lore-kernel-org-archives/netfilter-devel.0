Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792667284;
	b=thg7WbOY2Ao7mQOPO2L6HJdHO/6kjQ5fjY3YBWdCbwWwW5FMItquwqxrlu230hbzXzHz
	 zNjLxAxGmuFyX3EsQARldhCm0TBi1LDEB9w/LWyF98pr68Q9KqrbanQ6hZCQFrlMypBGj
	 1U+PTNbvhR7NB+T0wzRhKbd8gitc/cLHtX54dBilnN5kjWmkTI7joNdCNFoeMprslwLOL
	 IZZKtXeYGX3yJ35XFISYWko4ZEWnXSex/CjTnDhwy7MZUSQjQpWyz/5VKqUUt1Z3u0B+z
	 CnPp6LmyrPiSX8deIndhicoLU7A9t9X/gYdTOPbPfbbMyv7IMN/TBCFFQXlE4wbKVEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792667284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SGSGPrrEYHzHUgMaE62dGChTi8vgWBrTHVngMP7kcO4=;
	b=4JRY2tmEX83ZfIgnPukrkydbUEAl970JdmbBZIttdyAjZaebrfGGga0qHaU5fGFeYxxC
	 SAA68+kITMaIDXcWJ8cd9Dju1jgRkj26EGQW3EOTqiDnE9gKURw803vqmXJ1+X1WKLMwe
	 UeBeHCgiAyuOunr9YQww3buyCBMG9VjaDLTuk0dk3tiUwDhhq79dtKUHTZs5Fx0SXOgL9
	 SV5TUxkAUjX50uZVVLIpO4GcdKdOov33t5ofsMXlH/eUCCdZyihkJuNyrZ1A7FE9uhY9y
	 6xb3Hu9pewFhc4U84X8SJfyYgu8EwljsaRMs3J1P4c+f9/qzeAg7ReTS+Zuak/cbV/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gX1jymZF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626E7606A31B;
	Thu, 22 Oct 2026 11:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gX1jymZF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B861F000C1;
	Thu, 22 Oct 2026 11:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792667283;
	bh=SGSGPrrEYHzHUgMaE62dGChTi8vgWBrTHVngMP7kcO4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gX1jymZFcnI/cXxMQAVSDiiRxm9So0+tb6J2IA5JlRJJuRFB/TBIYhkuDS3/z4IVj
	 A1/5ytOcxpkeeijKfe0eL3SqaBrS5BpzIJ4ULEQV7wzll8W68I3/YEmnvxGlpLKYOz
	 nWwcdaJX6vC9QAbaG7KEu1dCvPkNHW7o8Adla7yH/IavsxeGhpGGcxL43wY6ntr3yt
	 0UwXdXDS5UOoeg6CqM2QiO4JDJbYP/dx3FQBcCyvQkx1hdZRfFJ83Yh58M+abYTQwv
	 b1Nxo4Ns+VTjZxwX04Z5l61TJJ4xEoJSYdm45zwws7UWFSg023sQma2xmesKq17YLq
	 ULbaJft8ccxoQ==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Nick Simpson <nick.simo@gmail.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>, Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>, David Ahern <dsahern@kernel.org>, Ido
 Schimmel <idosch@nvidia.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian
 Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard
 Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Willem de Bruijn
 <willemb@google.com>, Jason Xing <kerneljasonxing@gmail.com>, Song Yoong
 Siang <yoong.siang.song@intel.com>, Rusty Russell <rusty@rustcorp.com.au>,
 Max Krasnyansky <maxk@qualcomm.com>, Sridhar Samudrala <sri@us.ibm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
 linux-doc@vger.kernel.org, bpf@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] xsk: validate checksum offload requests in copy
 mode
In-Reply-To: <20261021180329.26358-2-nick.simo@gmail.com>
References: <20261021180329.26358-1-nick.simo@gmail.com>
 <20261021180329.26358-2-nick.simo@gmail.com>
Date: Thu, 22 Oct 2026 13:07:59 +0200
Message-ID: <87a4o66lio.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Nick Simpson <nick.simo@gmail.com> writes:

> In copy mode, XDP_TXMD_FLAGS_CHECKSUM turns the csum_start and
> csum_offset from the TX metadata into a CHECKSUM_PARTIAL skb.
> xsk_skb_metadata() only checks that the checksum fits in the frame, so
> csum_start can point into the Ethernet or IP header.
>
> On a veth, the skb reaches the peer namespace still CHECKSUM_PARTIAL.
> When that namespace forwards IPv6 with nf_defrag_ipv6 loaded,
> nf_ct_frag6_reasm() moves the IPv6 header forward by the 8 bytes of the
> fragment header without adjusting csum_start, the forward hook accepts
> the reassembled packet, and ip6_fragment() then completes the checksum
> with skb_checksum_help(), writing two bytes into the accepted header.
> With csum_start =3D 22 and csum_offset =3D 22 on a fragmented IPv6/UDP
> datagram from fd00:1::100, the write lands on source address bytes
> 14-15: an nftables forward rule matching "ip6 saddr fd00:1::100"
> accepted the packet and the fragments sent out carried saddr
> fd00:1::e87. For an unfragmented packet the same write happens at
> egress when the output device does not offload the checksum; with
> csum_start =3D 14 and csum_offset =3D 22 the packet left as fd00:1::ebf. A
> csum_start that ends up before the network header (14 to 21 on the
> fragmented path) makes skb_checksum_help() warn instead:
>
>   offset (-2) >=3D skb_headlen() (640)
>   WARNING: net/core/dev.c:3647 at skb_checksum_help+0x4c8/0x850
>   Call trace:
>    skb_checksum_help
>    ip6_fragment
>    ip6_finish_output
>    ip6_output
>    ip6_forward
>    ipv6_rcv
>    ...
>    __dev_direct_xmit
>    __xsk_generic_xmit
>    xsk_sendmsg
>
> socket(AF_XDP) only requires CAP_NET_RAW in the user namespace that owns
> the network namespace, so the sender can be a container that owns one
> end of the veth. With panic_on_warn, the warning panics the forwarding
> host.
>
> The interface is documented for L4 checksums. Leave CHECKSUM_PARTIAL in
> place only when the request designates the TCP or UDP checksum field of
> an unfragmented IPv4 or IPv6 packet, not IP-in-IP or GRE encapsulated,
> on an Ethernet device, and complete any other request in software, as
> XDP_UMEM_TX_SW_CSUM would, before the frame is handed to the device.
> The frame is dissected from its Ethernet type, as skb->protocol is not
> set for xsk skbs. The pending "net: resolve uncommon partial checksums
> at ingress" applies the same rule to virtio_net_hdr sources.
>
> A request on a frame that is itself an IP fragment is therefore
> completed over that fragment alone, which is also all a device could
> compute, so the reassembled datagram does not carry a valid transport
> checksum. Before, if every fragment carried such a request, the
> reassembled datagram stayed CHECKSUM_PARTIAL and was completed on
> refragmentation; now conntrack marks it invalid.
>
> Skbs without a linear part (IFF_TX_SKB_NO_LINEAR, i.e. virtio_net) are
> left unchanged: their data stays in the umem, where user space can
> still modify it after any check, and they go to the device rather than
> to the local stack.
>
> The problem was found with LLM-assisted code review.

AI;DR. Ask you agent to be terse, please. Also, please do a proper write
down of how to test/reproduce. The slop in the cover is no fun to read.
:-(

> @@ -1277,6 +1330,11 @@ static int __xsk_generic_xmit(struct sock *sk)
>  			continue;
>  		}
>=20=20
> +		if (unlikely(xsk_skb_resolve_csum(skb))) {
> +			xsk_drop_skb(skb);
> +			continue;
> +		}
> +

Yes, we need to validate the csum offsets, similar to the virtio-net
work MST is doing. Look what MST is doing in [1]. When that lands, move
the helpers to ip.h as the TODO says, and use for XSK.

I *think* the IFF_TX_SKB_NO_LINEAR csum_partial scenario is OK, since
we'll end up at a virtio device, but TBH I'm a bit skeptic about the
whole reference to UMEM via an skb case...


Bj=C3=B6rn

[1] 5de86f1afe1165a1a13ac4ef0615b19f4a10cb7a.1792565282.git.mst@redhat.com
