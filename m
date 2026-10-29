Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793232172;
	b=KistMQtb8V/OAH2VFUmy3LHstJRyn7DB0l++n5yqLVLGD60lb+i5Ol3qUCAlYEP7eqw1
	 3bXvEv8y6jTmXOhq+UPJbOexpqN5hV3oygGSi0Tz+3jXji/u9aRrnnDz3Z5zmXwijgXV3
	 YegCpaVdB8aBBMKr/vNTVQwhQ9ErdrUY5G+Y4wNLpa0F2kjUbhpvzqH1Rd0rzdGHQHwvi
	 iTJpndqdR4rpDDzHAz9MVeofMjoW94Wgh7QlQYuxuhLTcWipbjZm+dH9vOJhjJikvqb0y
	 gq6K9xrz67wFV9m73o7rYxF/7epaCzSP3O9j1NOnFHmsLt8jy4pdNuNx8lf3TIqQnpw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793232172;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=T8wn9WWatz7g9+GuvHTFCjTOz44xbxyaUbtEqnxzpVk=;
	b=RdyoRF5+j2oZSaRkRyD5Gb2j7HVGYMVzpS+Hvoil+prZ9pPYTYKn9U5G/QiZybY6SFJE
	 LojM7ORgFalg4XS6G2Iouaxy/daQBPzaETJP3x9KE7YI9gBhDb/m+TdHHHyQG+9/azRvQ
	 h/ntmCB7vraT1a7uayMEYZ+UriiGSqMhtaLpccM2VZL2EDcLCKsGAByY18J3GnoqMLzg6
	 zR96BTgz//USOxWluYOw/aXBgTr+NrwhxN61dYkfXO/M0OjtzmOYZOtlr9JSEgDlCnH9i
	 qLWOgI+SEvEyDqJfBbU3hmUAeun27Uxzuj9raL6OBXGBDVv6acEAYyUEZMgx7SkgfrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UjTIPOMc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FD1606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 00:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70FD1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UjTIPOMc
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6acb9c018ffso294659a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 17:02:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793232170; cv=none;
        d=google.com; s=arc-20260327;
        b=MwaxpH/mgGXqNgl/WalhpSNr4xwsaZRjS7Naj/rPksFX9/KPJ2AV91czywU7Qhj1D/
         0OLTw+kj2dI/sOCijyB2droR0UQpbrZCMrvDFILaHNpVpXVa/mDxQRyjj6VmKTEJL1G7
         Fa9mPK/Cnwe8O6XWZn7sBJLeCTMmTfAT+bCujU1ktenorU9jB0SJoafhI+KxvWHH2aJY
         NRhOkE1OE9kkhpo5w8U+o8e3McOeBMwLVh/5JkvC5rP2vH/YClaeeChuIl37DulLT6CF
         eldLwmL5f8cIsyQl2iJz4JB2lyOquQk3pvtl9t5GDafjpdCR3JnT8x4xl42oFZqFlzxh
         z1Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T8wn9WWatz7g9+GuvHTFCjTOz44xbxyaUbtEqnxzpVk=;
        fh=TauYXpNZGLlM8loaAK96NCMwVuJYxgJES6ZKtXY0esE=;
        b=FRnzYjcDjtpjgdfd9FY89b02mY4rQiPSkU3jES4xp26Pm5Ydur675DJJp560a3EvJp
         MBYh9HU9o14Pjrt4zUKtszo8KVlwdHE5xStVpMZD9tVHYXPSeO0QztR5Ji2UaWcIgRsX
         mENxD3QDIsVovQg6aqXh+VeDWCvXwUgS+i72JHwJO19PrYLJXj8pNiq7vq3RSiCwtuUU
         5XUHCV7TKo3B5ioFRYpkHNk/nPvCBCKuFzTTJzKsNYoLOoKdSqNY9pJvmAPUk7c1K/oH
         fq2clsAs1Wk5sV/b/PGNHUk69I/7XkvTEmrMKZHc4HqlrxVB5HvayBv8Q7TDfoXPjcmx
         T9ow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793232170; x=1793836970; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T8wn9WWatz7g9+GuvHTFCjTOz44xbxyaUbtEqnxzpVk=;
        b=UjTIPOMcXrBj4Xs0SHqz9OA6e0WdvznSz196gbPEQEtimQeV6Rmq3Jd+BO76QOe/36
         yOTd1A2Vu6DFO+eha3c94LUVpX/X3ctwn3Llp6cGm6O67AUFudMAGNs9dMbQJahWb10G
         2J1vVKESLY1UFkuxDHnfBy8T8PMnpV2qRI9da3beZzvx6qYYRlvsXiCuSEU3WG3g3fPA
         T3z/bPBr1nxE2EpDp2vyg9R7+bDfYAoaDeXDtrhUAaj6sYe5mEf5eyx7O8GtXPkTktro
         Tc+qhQJjMmO8DsP4uJDJsHdfIoPQi20y/PiWk50s/QLZlg4Q2j0wJZDnhNGUaHfjaZwz
         Ou5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793232170; x=1793836970;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T8wn9WWatz7g9+GuvHTFCjTOz44xbxyaUbtEqnxzpVk=;
        b=MTuvlbQfnKLIIFHL0czfVB9adBPGWD9FAEMytAnYKoZ7pU+XAYwcR6vcjh1WX+pc7I
         55SNy5k+hpGsSE0BSL4mws30HMja27pvXaauC+iyGueAKN0IOjwDpnmivrW71/5/pE+X
         2swJFYWdgSSIXA87NoY5EZkJiRckAeY+SI1KQuka83FLJPzyL6cle0uC81vp/RbQZVE8
         140SvhWs7exw1ypAzxUFoGzYhl+txP9IpKTASmKSlsbhhSfmKo0/lCIz0a2VxkvbtYDs
         9Yd5y+ihkOV2efnw9+XPsPWHKHQUp2+Zm/DNgbfHR+yE3n8JEZ4CylSquxlz06/aQTf5
         FJbw==
X-Forwarded-Encrypted: i=1; AKwUvBzCTdnqybHvT2sSp0hmJSwNEreZ5JTkVCaiimOmCZ9pKSurpIj6i7FoWANYHX9GQxjgogIBns6JWFltS8nm1ag=@vger.kernel.org
X-Gm-Message-State: AFq9FYJH3uO1iX39PI+pKOml2zZV0o/Nd4tlQdzdfPW5znYoqRaBK5Jh
	dB2HXlJNwlZKvoP+uTPRBpnFweHTZHRyJYI///vfUPBIXIRHUjm70s+q0QfmbmYAF50vnsjNvu8
	nldyjTVWPH1LABxj5GZu8Vozzca8mNMcUnCCt6nw9
X-Gm-Gg: AYBFou0PLbqhbQ9RawzHGpzWYStdEpNYQsYc1HnqGd8odli3bJ9KihklpAre4XlvpaY
	cW092mLGa3x77zg78+xj1o84uvAmHiLPU8cukAbo8QLWhtpor0IFo04fImXaD/VwnMMucy+GEGs
	CaFmHxe+qxzY/s3mt28MfHZaZGNVimAI89WsDVvUfTwo+3w3uQ7m5chZIXjRnh0tdxXNauGTOqL
	9bm7CGCf1LcfuYakVBaO1bpGVlnM/E31DDlypyYITtT57XNw+img9li3KKiaT5C0YaV2HEuVIsB
	+DcboDAZQxJrN8Tp9BhGuBUSdxMXoFoxZ8rLwQA+sf6GTO4LBt/CvZN+DCBdQB1Z4Kw0Pwpf2cK
	idw26cJfW960F9B29ZfEtu/UUEQ/vrTA+DfXQgBX1t8US1QnUlb/xulqtnpgJT0sYIOEkuR/Bun
	ene72AF1zVvxnyia3hnT3vlqGKzoZkfCI693j9z2nMicNmn65GYtKSGAA/nJAkqq67Skk9mAqrm
	UOMJc12Ng==
X-Received: by 2002:a05:6402:8da:b0:6b3:cfa0:77cb with SMTP id
 4fb4d7f45d1cf-6b4b0bc4ad3mr507302a12.10.1793232169284; Wed, 28 Oct 2026
 17:02:49 -0700 (PDT)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028191103.623156-1-ihuguet@riseup.net> <20261028191103.623156-3-ihuguet@riseup.net>
In-Reply-To: <20261028191103.623156-3-ihuguet@riseup.net>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 28 Oct 2026 17:02:34 -0700
X-Gm-Features: AclHuK9Ieq337H2jQzTcmHx2GLrqys7hyNpbxnW79QTlBSjvfsWybnnRBb5nrRY
Message-ID: <CAAVpQUC7hezdMEQkzAX4oqFdO_uzBmtRwn85_5_iWf4ExPqpTA@mail.gmail.com>
Subject: Re: [PATCH net v3 2/3] net/ipv6: don't route packets with unknown
 source address
To: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@riseup.net>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eduard Zingerman <eddyz87@gmail.com>, Eric Dumazet <edumazet@kernel.org>, Florian Westphal <fw@strlen.de>, 
	Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Neal Cardwell <ncardwell@google.com>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, bpf@vger.kernel.org, 
	Breno Leitao <leitao@debian.org>, coreteam@netfilter.org, 
	Emil Tsalapatis <emil@etsalapatis.com>, Fernando Fernandez Mancera <fmancera@suse.de>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Jeff Layton <jlayton@kernel.org>, 
	Jiri Olsa <jolsa@kernel.org>, Joe Damato <joe@dama.to>, 
	John Fastabend <john.fastabend@gmail.com>, Junseo Lim <zirajs7@gmail.com>, 
	Kees Cook <kees@kernel.org>, Leon Hwang <leon.hwang@linux.dev>, 
	Li RongQing <lirongqing@baidu.com>, linux-kselftest@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@linux.dev>, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>, 
	Qi Tang <tpluszz77@gmail.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Simon Horman <horms@kernel.org>, Song Liu <song@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Willem de Bruijn <willemb@google.com>, Xuanqiang Luo <luoxuanqiang@kylinos.cn>, 
	Yonghong Song <yonghong.song@linux.dev>, =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>, 
	Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 12:12=E2=80=AFPM =C3=8D=C3=B1igo Huguet <ihuguet@ri=
seup.net> wrote:
>
> Don't allow routing packets with a source address that is not configured
> in the host. Allow it only in certain cases like when using a
> transparent socket, by setting the ANYSRC flag in flowi_flags.

This changes longstanding user-visible behaviour,
so the series should target net-next.



>
> Until now, it was possible to send such a packet if a route can be found
> in the routing table for it. For example:
> 1. Configure two addresses 1:2::3:4/64 and 1:2::3:5/64
> 2. Establish a TCP connection to 1:2::3:4
> 3. Remove the address from the interface, but keep the other.
> 4. Packets are still sent out by the TCP connection because of
>    the automatic route created for the 2nd address. No incoming
>    packets are accepted, though.
>
> This patch prevents the outgoing packets to be sent in normal
> circumnstances.
>
> This aligns the behaviour with the IPv4 stack. To determine the places
> where the ANYSRC needs to be set, I set the flag in the same places as
> the IPv4 stack does.
>
> Apart from consolidating the behaviour of both stacks, there is a more
> important reason why this is needed. RFC 4862 states that "an invalid
> address MUST NOT be used as the source address of outbound packets".
> Therefore, sending packets with a source address considered "invalid",
> like an expired address, is disallowed.
>
> This issue was reported by a user to whom IPv6 packets were leaked after
> removing the IPv6 address for the interface. The same happens if the
> address has its valid_lft expired.
>
> There is a valid use case that would break with this change: loopback
> subnets (aka AnyIP). They work in the following way: the administrator
> adds a route like `local 2001:db8:cafe::/64 dev lo`, so that the host
> will accept connections to all the addresses of that subnet. However,
> there is no address assigned to any interface, only a route, so that
> outgoing packets would be dropped because the source address doesn't
> belong to any interface in the host.
>
> In IPv4, loopback subnets work because __ip_dev_find fallbacks to a
> FIB lookup. For IPv6 it is unclear if such a change would be desired
> by all the current callers of ipv6_dev_find, ipv6_chk_addr and
> ipv6_chk_addr_and_flags, likely not. Because of that, add the FIB lookup
> fallback into ip6_output, where the check of the source address has been
> added.
>
> Signed-off-by: =C3=8D=C3=B1igo Huguet <ihuguet@riseup.net>
>
> ---
>  drivers/net/vrf.c                |  1 +
>  net/core/filter.c                |  1 +
>  net/core/lwt_bpf.c               |  1 +
>  net/ipv6/af_inet6.c              |  1 +
>  net/ipv6/datagram.c              |  1 +
>  net/ipv6/icmp.c                  |  5 +++++
>  net/ipv6/inet6_connection_sock.c |  2 ++
>  net/ipv6/ip6_output.c            | 38 ++++++++++++++++++++++++++++++++
>  net/ipv6/ip6_udp_tunnel.c        |  1 +
>  net/ipv6/netfilter.c             | 11 +++++++--
>  net/ipv6/ping.c                  |  1 +
>  net/ipv6/raw.c                   |  1 +
>  net/ipv6/syncookies.c            |  1 +
>  net/ipv6/tcp_ipv6.c              |  7 +++++-
>  net/ipv6/udp.c                   |  1 +
>  net/l2tp/l2tp_ip6.c              |  2 ++
>  16 files changed, 72 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index 79d433f49f80..4222e598290c 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -432,6 +432,7 @@ static netdev_tx_t vrf_process_v6_outbound(struct sk_=
buff *skb,
>         fl6.flowlabel =3D ip6_flowinfo(iph);
>         fl6.flowi6_mark =3D skb->mark;
>         fl6.flowi6_proto =3D iph->nexthdr;
> +       fl6.flowi6_flags =3D FLOWI_FLAG_ANYSRC;
>
>         dst =3D ip6_dst_lookup_flow(net, NULL, &fl6, NULL);
>         if (IS_ERR(dst) || dst =3D=3D dst_null)
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 70dc621672f2..65ff54f6a29d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5077,6 +5077,7 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *=
, skb,
>                        sizeof(from->local_ipv6));
>                 info->key.label =3D cpu_to_be32(from->tunnel_label) &
>                                   IPV6_FLOWLABEL_MASK;
> +               info->key.flow_flags =3D FLOWI_FLAG_ANYSRC;
>         } else {
>                 info->key.u.ipv4.dst =3D cpu_to_be32(from->remote_ipv4);
>                 info->key.u.ipv4.src =3D cpu_to_be32(from->local_ipv4);
> diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
> index da49364ec63d..e8b954282689 100644
> --- a/net/core/lwt_bpf.c
> +++ b/net/core/lwt_bpf.c
> @@ -233,6 +233,7 @@ static int bpf_lwt_xmit_reroute(struct sk_buff *skb)
>                 fl6.flowi6_mark =3D skb->mark;
>                 fl6.flowi6_uid =3D sock_net_uid(net, sk);
>                 fl6.flowlabel =3D ip6_flowinfo(iph6);
> +               fl6.flowi6_flags =3D FLOWI_FLAG_ANYSRC;
>                 fl6.flowi6_proto =3D iph6->nexthdr;
>                 fl6.daddr =3D iph6->daddr;
>                 fl6.saddr =3D iph6->saddr;
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index a9b8b4b42a1a..8e3c6e095419 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -816,6 +816,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
>         fl6->fl6_dport =3D inet->inet_dport;
>         fl6->fl6_sport =3D inet->inet_sport;
>         fl6->flowi6_uid =3D sk_uid(sk);
> +       fl6->flowi6_flags =3D inet_sk_flowi_flags(sk);
>         security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
>
>         ip6_ecmp_set_mp_hash(sock_net(sk), fl6, sk->sk_txhash);
> diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> index 7b71a932544d..f09bbffec0e7 100644
> --- a/net/ipv6/datagram.c
> +++ b/net/ipv6/datagram.c
> @@ -52,6 +52,7 @@ static void ip6_datagram_flow_key_init(struct flowi6 *f=
l6,
>         fl6->flowi6_mark =3D sk->sk_mark;
>         fl6->fl6_dport =3D inet->inet_dport;
>         fl6->fl6_sport =3D inet->inet_sport;
> +       fl6->flowi6_flags =3D inet_sk_flowi_flags(sk);
>         fl6->flowlabel =3D ip6_make_flowinfo(np->tclass, np->flow_label);
>         fl6->flowi6_uid =3D sk_uid(sk);
>
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index a95b0351824f..b4b54297c923 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -393,6 +393,11 @@ static struct dst_entry *icmpv6_route_lookup(struct =
net *net,
>         if (err)
>                 goto relookup_failed;
>
> +       /* New src is the original dst. It may not be a local address, li=
ke with
> +        * encapsulated traffic.
> +        */
> +       fl2.flowi6_flags |=3D FLOWI_FLAG_ANYSRC;
> +
>         err =3D ip6_dst_lookup(net, sk, &dst2, &fl2);
>         if (err)
>                 goto relookup_failed;
> diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection=
_sock.c
> index 3e4ce8cb478e..f295f3efe243 100644
> --- a/net/ipv6/inet6_connection_sock.c
> +++ b/net/ipv6/inet6_connection_sock.c
> @@ -45,6 +45,7 @@ struct dst_entry *inet6_csk_route_req(const struct sock=
 *sk,
>         fl6->flowi6_mark =3D ireq->ir_mark;
>         fl6->fl6_dport =3D ireq->ir_rmt_port;
>         fl6->fl6_sport =3D htons(ireq->ir_num);
> +       fl6->flowi6_flags =3D inet_sk_flowi_flags(sk);
>         fl6->flowi6_uid =3D sk_uid(sk);
>         security_req_classify_flow(req, flowi6_to_flowi_common(fl6));
>
> @@ -71,6 +72,7 @@ struct dst_entry *inet6_csk_route_socket(struct sock *s=
k,
>         fl6->daddr =3D sk->sk_v6_daddr;
>         fl6->saddr =3D np->saddr;
>         fl6->flowlabel =3D np->flow_label;
> +       fl6->flowi6_flags =3D inet_sk_flowi_flags(sk);
>         IP6_ECN_flow_xmit(sk, fl6->flowlabel);
>
>         if (sk->sk_protocol =3D=3D IPPROTO_TCP)
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 25fe0ba98b1a..8715cf43f00a 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -1134,6 +1134,33 @@ static struct dst_entry *ip6_sk_dst_check(struct s=
ock *sk,
>         return dst;
>  }
>
> +/* Check if the address belongs to the host */
> +static bool ip6_is_local_saddr(struct net *net, struct in6_addr *saddr)
> +{
> +       struct fib6_result fib_result;
> +       struct flowi6 fl6;
> +       bool result;
> +
> +       if (ipv6_chk_addr_namespace(net, saddr) ||
> +           ipv6_chk_acast_addr_src(net, NULL, saddr))
> +               return true;
> +
> +       /* Fallback to FIB local routes so that loopback subnets work. */
> +       memset(&fl6, 0, sizeof(fl6));
> +       fl6.daddr =3D *saddr;
> +       result =3D false;
> +
> +       rcu_read_lock();
> +       if (fib6_lookup(net, 0, &fl6, &fib_result, 0) =3D=3D 0 &&
> +           fib_result.fib6_type =3D=3D RTN_LOCAL &&
> +           fib_result.nh->nh_common.nhc_dev) {
> +               result =3D true;
> +       }
> +       rcu_read_unlock();
> +
> +       return result;
> +}
> +
>  static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
>                                struct dst_entry **dst, struct flowi6 *fl6=
)
>  {
> @@ -1191,6 +1218,17 @@ static int ip6_dst_lookup_tail(struct net *net, co=
nst struct sock *sk,
>         if (err)
>                 goto out_err_release;
>
> +       /* From RFC 4862, "an invalid address MUST NOT be used as the sou=
rce
> +        * address of outbound packets". Exceptions to this must set the =
ANYSRC
> +        * flag (i.e. transparent sockets).
> +        */
> +       if (!ipv6_addr_any(&fl6->saddr) &&
> +           !(fl6->flowi6_flags & FLOWI_FLAG_ANYSRC) &&
> +           !ip6_is_local_saddr(net, &fl6->saddr)) {
> +               err =3D -ENETUNREACH;
> +               goto out_err_release;
> +       }
> +
>  #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
>         /*
>          * Here if the dst entry we've looked up
> diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
> index 32525a051a6f..1727c36ff6a4 100644
> --- a/net/ipv6/ip6_udp_tunnel.c
> +++ b/net/ipv6/ip6_udp_tunnel.c
> @@ -161,6 +161,7 @@ struct dst_entry *udp_tunnel6_dst_lookup(struct sk_bu=
ff *skb,
>         fl6.fl6_sport =3D sport;
>         fl6.fl6_dport =3D dport;
>         fl6.flowlabel =3D ip6_make_flowinfo(dsfield, key->label);
> +       fl6.flowi6_flags =3D key->flow_flags;
>
>         dst =3D ip6_dst_lookup_flow(net, sk, &fl6, NULL);
>         if (IS_ERR(dst)) {
> diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
> index a7025ec87035..716fc6e246de 100644
> --- a/net/ipv6/netfilter.c
> +++ b/net/ipv6/netfilter.c
> @@ -29,8 +29,9 @@ int ip6_route_me_harder(struct net *net, struct sock *s=
k_partial, struct sk_buff
>         struct flow_keys flkeys;
>         unsigned int hh_len;
>         struct dst_entry *dst;
> -       int strict =3D (ipv6_addr_type(&iph->daddr) &
> -                     (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL));
> +       int saddr_type =3D ipv6_addr_type(&iph->saddr);
> +       int daddr_type =3D ipv6_addr_type(&iph->daddr);
> +       int strict =3D daddr_type & (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINK=
LOCAL);
>         struct flowi6 fl6 =3D {
>                 .flowi6_l3mdev =3D l3mdev_master_ifindex(dev),
>                 .flowi6_mark =3D skb->mark,
> @@ -41,6 +42,12 @@ int ip6_route_me_harder(struct net *net, struct sock *=
sk_partial, struct sk_buff
>         };
>         int err;
>
> +       fl6.flowi6_flags =3D sk ? inet_sk_flowi_flags(sk) : 0;
> +       if (saddr_type & (IPV6_ADDR_UNICAST | IPV6_ADDR_LINKLOCAL))
> +               fl6.flowi6_flags |=3D FLOWI_FLAG_ANYSRC;
> +       else
> +               fl6.saddr =3D in6addr_any;
> +
>         if (sk && sk->sk_bound_dev_if)
>                 fl6.flowi6_oif =3D sk->sk_bound_dev_if;
>         else if (strict)
> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
> index 6e90d0bf9f3d..d0964396c2c5 100644
> --- a/net/ipv6/ping.c
> +++ b/net/ipv6/ping.c
> @@ -140,6 +140,7 @@ static int ping_v6_sendmsg(struct sock *sk, struct ms=
ghdr *msg, size_t len)
>         fl6.flowi6_proto =3D IPPROTO_ICMPV6;
>         fl6.saddr =3D np->saddr;
>         fl6.daddr =3D *daddr;
> +       fl6.flowi6_flags =3D inet_sk_flowi_flags(sk);
>         fl6.flowi6_mark =3D ipc6.sockc.mark;
>         fl6.flowi6_uid =3D sk_uid(sk);
>         fl6.fl6_icmp_type =3D user_icmph.icmp6_type;
> diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
> index b965258cf9e5..ef5ddbe7ac10 100644
> --- a/net/ipv6/raw.c
> +++ b/net/ipv6/raw.c
> @@ -887,6 +887,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msgh=
dr *msg, size_t len)
>                 fl6.flowi6_oif =3D READ_ONCE(np->ucast_oif);
>         security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
>
> +       fl6.flowi6_flags =3D inet_sk_flowi_flags(sk);
>         if (hdrincl)
>                 fl6.flowi6_flags |=3D FLOWI_FLAG_KNOWN_NH;
>
> diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
> index b581cb1ee2e8..3d665e93fcac 100644
> --- a/net/ipv6/syncookies.c
> +++ b/net/ipv6/syncookies.c
> @@ -242,6 +242,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct =
sk_buff *skb)
>                 fl6.flowi6_mark =3D ireq->ir_mark;
>                 fl6.fl6_dport =3D ireq->ir_rmt_port;
>                 fl6.fl6_sport =3D inet_sk(sk)->inet_sport;
> +               fl6.flowi6_flags =3D inet_sk_flowi_flags(sk);
>                 fl6.flowi6_uid =3D sk_uid(sk);
>                 security_req_classify_flow(req, flowi6_to_flowi_common(&f=
l6));
>
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index e006a30360ea..5248cbd4b595 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -271,8 +271,9 @@ static int tcp_v6_connect(struct sock *sk, struct soc=
kaddr_unsized *uaddr,
>         fl6->flowi6_mark =3D sk->sk_mark;
>         fl6->fl6_dport =3D usin->sin6_port;
>         fl6->fl6_sport =3D inet->inet_sport;
> +       fl6->flowi6_flags =3D inet_sk_flowi_flags(sk);
>         if (IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) && !fl6->fl6_sport)
> -               fl6->flowi6_flags =3D FLOWI_FLAG_ANY_SPORT;
> +               fl6->flowi6_flags |=3D FLOWI_FLAG_ANY_SPORT;
>         fl6->flowi6_uid =3D sk_uid(sk);
>
>         opt =3D rcu_dereference_protected(np->opt, lockdep_sock_is_held(s=
k));
> @@ -982,6 +983,10 @@ static void tcp_v6_send_response(const struct sock *=
sk, struct sk_buff *skb, u32
>         fl6.fl6_dport =3D t1->dest;
>         fl6.fl6_sport =3D t1->source;
>         fl6.flowi6_uid =3D sock_net_uid(net, sk && sk_fullsock(sk) ? sk :=
 NULL);
> +       if (sk && sk_fullsock(sk))
> +               fl6.flowi6_flags =3D inet_sk_flowi_flags(sk);
> +       else if (sk && inet_sk_transparent(sk))
> +               fl6.flowi6_flags =3D FLOWI_FLAG_ANYSRC;
>         security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
>
>         /* Pass a socket to ip6_dst_lookup either it is for RST
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 59f9872c3552..7492d155726a 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1650,6 +1650,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *m=
sg, size_t len)
>         if (ipv6_addr_any(&fl6->saddr) && !ipv6_addr_any(&np->saddr))
>                 fl6->saddr =3D np->saddr;
>         fl6->fl6_sport =3D inet->inet_sport;
> +       fl6->flowi6_flags =3D inet_sk_flowi_flags(sk);
>
>         if (cgroup_bpf_enabled(CGROUP_UDP6_SENDMSG) && !connected) {
>                 err =3D BPF_CGROUP_RUN_PROG_UDP6_SENDMSG_LOCK(sk,
> diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
> index bdaae1b64d25..22ae5bc2669a 100644
> --- a/net/l2tp/l2tp_ip6.c
> +++ b/net/l2tp/l2tp_ip6.c
> @@ -633,6 +633,8 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct m=
sghdr *msg, size_t len)
>         else if (!fl6.flowi6_oif)
>                 fl6.flowi6_oif =3D READ_ONCE(np->ucast_oif);
>
> +       fl6.flowi6_flags =3D inet_sk_flowi_flags(sk);
> +
>         security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
>
>         fl6.flowlabel =3D ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
> --
> 2.54.0
>
