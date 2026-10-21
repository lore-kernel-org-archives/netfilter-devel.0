Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792606843;
	b=OzNFkE5LeVNjbyyUcBZl5SfPG16dm7726xSZlYzPckEfZBmzzRRYVgBi0jtKJwwd/6qV
	 RJuBJr79L3P4fbtf3kIJbqNywBI+SOiZXDZnya8ljiuoa2VTiX9IGZlWRxVN1OP/+SA+7
	 tvofs3FXuhvMCkmSvyw/cUJSnaVCg8UUZ6cw6S6oJEFBNkC3FFTeLzhSZXc/aYG7ZMEOz
	 jSCE/o+C8MgVcKIsWzi2Z8+hoOlrpjuGqArHQ345hVeiwtcDl1hJgEhRwhuHis0eYCRyS
	 TMcU5sanTNfo/Sb5eyhHexc/bhhlisi9yBJ26g3eOrPRrGQscVRRjercq+wHJCaiF8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792606843;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3RB8pGqoFevwjpm7hqYDh3Z0YhJECl+wf0Lwr/YiYQk=;
	b=uxu/DcANUY3vEfccUk/tvOalgk7r2RzEwDSIWS/um4E8nQ3UnPErzZqA4QIGHfVISOcz
	 8Ki5sL1yG0znjcnaHnt+7akmLZK8dTwgS20KQo9LMW37bG70JaGrFEaEW8MF8ffLql6hx
	 /XSVRrY48qahM9uhjbJpd09OBUD0GmnEznhj1houR7E6SLB9Bd+UcEMHnABvtpjzSZxXr
	 GwjmGkU6nOj3VvV7cr06ejswANu+THj6lbhQeZwTUesffUaDIPsKFGu8P6E2198EFpoEz
	 x/rWUQ0hHzamndXLHj2yqWIg74wdLhAyP3rwEaEdR+pKv3IL9VGyKhAZh3XS+6vaImw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XorJYn+h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4051606A31B
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 18:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XorJYn+h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955211F000C3
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792606841;
	bh=3RB8pGqoFevwjpm7hqYDh3Z0YhJECl+wf0Lwr/YiYQk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XorJYn+hh8+QV5j9kCCSgIJ80rJZGdHc4PL2XqIIDp/VAJ5pSgngbEND2Elg2a2MK
	 +ZI27Xx62nRMhJ/KqbqvsnoNAjY+2Neg/8GumCtLZ8XAiYDCmDl6AYdpmecQXtT6st
	 0kRAwIBtir6Iz6uSatsX1p1inuOlWAELZcT//pjCMmJoCYPweyH5vqWyGZwLKWoMd9
	 qt5uSyRl2qmK7OudqFGY3WeSbMseSnzer7MPX9QqZJbF13ssu2Ma5e2s1Ed0EYkjSl
	 xz0EjZru7Hk1gliznBNz9U9fz03jD4Un1xHEIubRmbrIVwwt5swT5hP/Anji4bsld7
	 dw5EGSw9SO6mA==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-4a6f2825dd6so295362fac.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 11:20:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByOta6fixHEeXKD96Ws+vGzNC6klSS3nibcBdOqhPmxg7jlEM0z3IOjBy0zbFKsZgoRojoUzJowGOKIF4tLS7c=@vger.kernel.org
X-Gm-Message-State: AFq9FYIM2oQuH4KBVgo9DY/kgCysKW1sQNfpgxHxS2TOzyWEAY83IfPO
	k0L2VLBJupfiRACMOda+XvHqLsJESRWiUx9B4GANx8OGsY2DJHWQUiAmpnPFBGdWBYGebnJW6hr
	Onxq/OL/4Rj/aIFXNv+NIQJzdTOWB/8k=
X-Received: by 2002:a05:6870:7097:b0:4a6:f0b3:79b3 with SMTP id
 586e51a60fabf-4a7dbf3b81bmr1643703fac.8.1792606840868; Wed, 21 Oct 2026
 11:20:40 -0700 (PDT)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021180329.26358-1-nick.simo@gmail.com> <20261021180329.26358-4-nick.simo@gmail.com>
In-Reply-To: <20261021180329.26358-4-nick.simo@gmail.com>
From: Eric Dumazet <edumazet@kernel.org>
Date: Wed, 21 Oct 2026 20:20:29 +0200
X-Gmail-Original-Message-ID: <CAL4Wiiq6Jy1XPtkrA-Ge2N+voJrE86DWPJp_jXwHJG3ZgMvPaQ@mail.gmail.com>
X-Gm-Features: AclHuK92ROo2GQDUw7T4ShtS9Gq30MtN5yysthtRvbBAH8cdJS4sBr7rxyIL9QU
Message-ID: <CAL4Wiiq6Jy1XPtkrA-Ge2N+voJrE86DWPJp_jXwHJG3ZgMvPaQ@mail.gmail.com>
Subject: Re: [PATCH net 3/3] ipv6: validate checksum_start before fragmenting
To: Nick Simpson <nick.simo@gmail.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, David Ahern <dsahern@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	"David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	"Michael S . Tsirkin" <mst@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	Jason Xing <kerneljasonxing@gmail.com>, Song Yoong Siang <yoong.siang.song@intel.com>, 
	Rusty Russell <rusty@rustcorp.com.au>, Max Krasnyansky <maxk@qualcomm.com>, 
	Sridhar Samudrala <sri@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org, linux-doc@vger.kernel.org, 
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mer. 21 oct. 2026 =C3=A0 20:05, Nick Simpson <nick.simo@gmail.com> a =C3=
=A9crit :
>
> ip6_fragment() and br_ip6_fragment() complete CHECKSUM_PARTIAL skbs with
> skb_checksum_help() without checking where csum_start points. After
> reassembly by nf_defrag_ipv6, the IPv6 header has moved forward by the
> 8 bytes of the fragment header while csum_start has not, so a
> CHECKSUM_PARTIAL skb from an untrusted source (tun/tap or packet sockets
> with a virtio_net_hdr, or AF_XDP TX metadata) can have csum_start inside
> the IPv6 header, and the checksum is then written into a header that the
> forward hook has already accepted. When csum_start lies before the
> network header, skb_checksum_help() warns.
>
> Add the IPv6 counterpart of ip_check_csum_start() from
> commit 6785011f8b16 ("ipv4: validate checksum_start before completing
> checksum") to the two IPv6 fragmentation paths: refuse to complete a
> checksum that starts inside the unfragmentable part of the packet (the
> IPv6 header and the extension headers before the fragment header) and
> drop the packet instead.
>
> For IPv4, ip_check_csum_start() is also called from nfnetlink_queue,
> xt_CHECKSUM and xfrm_output; their IPv6 counterparts are not changed
> here. A reassembled packet that is not fragmented again, such as an
> atomic fragment, and an unfragmented packet whose checksum is completed
> at egress are not covered either; those have to be handled where the
> CHECKSUM_PARTIAL skb is created, or by a check at reassembly time.

Then let's do that, instead of adding checks to every consumer.

A CHECKSUM_PARTIAL fragment is meaningless: the L4 checksum covers the
whole datagram, and our own stack completes it before fragmenting
(ip_do_fragment(), ip6_fragment()). Only untrusted injectors produce
them. Yet inet_frag_reasm_finish() keeps the reassembled skb
CHECKSUM_PARTIAL when all fragments are.

Downgrading CHECKSUM_PARTIAL to CHECKSUM_NONE in inet_frag_reasm_finish()
covers IPv4, IPv6, nf_defrag_ipv6 (and the bridge path) in one place;
the bogus L4 checksum is then verified and the packet dropped.

Also, reassembly does not move the L4 bytes, so a valid csum_start stays
valid; the "header moved without adjusting csum_start" framing is not
the bug.

Finally, this patch is described as defence in depth and not for
stable, but carries three Fixes: tags. Please drop it.

Nacked-by: Eric Dumazet <edumazet@kernel.org>

I am so tired of these LLM patches working around the issues instead
of fixing the root causes.
