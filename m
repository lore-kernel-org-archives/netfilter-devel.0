Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209283E0090
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2026 07:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788680855; cv=pass; b=B3QWYREmCpQ1qoBbogowPev3IURQxQjndPUk0EC6++y0OeNNTCyiaQyRJplL2AGKQJFF+bO+MLJWUY0493+NLGNcYc80FdPnfAB1jHGzYOwe3vYpmf33T/RKvEABUQxbYht9nli0iaJRKR0/zMMqZNOqVxiOi/2Qf4wm3REgIJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788680855; c=relaxed/simple;
	bh=QmosLt4Exr3yd3+DbuV4sKo0M0/L5NTz2CezfpDi4X4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s15We+X0gPcncpLVwdPx8LbHrwZrkXROl76yTgig6gyljbG/QkcuiQjLPRJAzDE26tTpfVKFVzUm2Rla8V/UmNpwFxKwr906vSov8epjSl78L39A/YCInz8D6Zv1rZf5JZGOMA6vCdVRjxJWzfQN1UoQluesNnd8SuLl2D+9W+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q7a8/nrW; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q7a8/nrW"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso315832666b.0
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2026 00:47:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788680851; cv=none;
        d=google.com; s=arc-20260327;
        b=O/n1LvyzocHbEX9Aj6Z1tR1J5U7yhb3+DAJj/KEffoq2RGLded/iK+jbaHvLgpXi34
         BZ3nW2OHXcsn79/0r8r0qpDObCWbJ/ehg4Ic+IlKCKlOSDYD9tbaS1NC/PjugNp9IDr3
         fc/HB39M78nvP0u/K89V7TwfE3KJgOyjH87C6tM6S+Eou0lyM38hdguWiClC4lLpyosL
         hCoDtup0YhjMIO5v7Kwg9gis1uHMhc1c9SoWkVu4jtxWpqQkZUH7arBCAPLcCsvkE946
         9Ph7Kc8uIJJMox7nqhPECQ7jfjCLdFMaGvy24uWKU+0atRPo38Y6RCHwQu0pmwbk5AIr
         c+zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6JYM+LSAut5hPxwG+oopMKaaGaGA8Dp7pKYI7iVo/2Q=;
        fh=RSGqKzgSxmX0BdWH8/N2YbjoQfU5t+vQhj3xwuE1xAM=;
        b=HF1UQNFF6vpMahiGu3oUnO0Q1aUSg6VEmhqKJHwQ20DIbMj9V/z31B9ka4ONb1ACoq
         9hbSK4LC8W+hkSHJ2yy2JrXntIux6mubUQ4zUFxLJshQ5IGgCH1wTijNlD5LAaxhu+jm
         SA4nIwYcqQtHRNaJ1U0kt4TXYB+ygb/dRXKS6WH5aTEkPD3eack/xrEAtzRylFd49u0z
         8EXhK5PqIKDUTaJepSh/0AE1pQDMu4AmMlVQGkT8JfCAkb5WhHSjGmmvSq9zbWXxlwIc
         I9CotdLkZvrlN0y7Ly9kCmeJv8Tn8HatIuzjNVNbFAv/DcN73asKKkK4Bj31tiuMQvkE
         8q3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788680851; x=1789285651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6JYM+LSAut5hPxwG+oopMKaaGaGA8Dp7pKYI7iVo/2Q=;
        b=q7a8/nrW36aexVJmCqPdyS/bSc1UHO/soq5bIxxh+GY5BC+ZaJInexvOEnLY1FtMfn
         54wlteELOVhjGTkvuqxVhOz9306jHFQSxrhH09hIBLbUHKmxdJVGYxcTaZ1hFRX7cVz5
         +GCVb9YaZWO0O28nXCe9NA3NCXw0U6XGnmPpuz37LpmW5eshW6dfKBEq2BSLKRKUdiI+
         1iYBZ3NuCazcg2BmBlCAvbMX6c880EFWjsG9+fiqFZSIOppr2JtSTAhTuYnHuB0CVnB7
         zsQutyx0ED4MrSAee9JA3IoCDhyfpS3lHDawqQ8lcC3p0xDMeSbTYHMQbdq3aIIzbLyU
         9LWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788680851; x=1789285651;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6JYM+LSAut5hPxwG+oopMKaaGaGA8Dp7pKYI7iVo/2Q=;
        b=oqSbaVE1v0uXzKy8HB7wi0Xu5iXPvnM2nSjgwFi85M3MtTyks3SODG2JietHv8tNWL
         IN5nrXZrjMaG6UZUKQxKAeQIx9R+VHnt3bdm0eGWu2u/8baxI8ZfrgW/6gXIXh9nBbSc
         24k5RE6iMS3r3EonX36yl+T4LlUvOJ9M2F8/D2K7F4J5WC9d+Ph2I3aMNpsiJJAsLb2J
         iloD1r34qQKQ38ev0txKSFeyyFRcZd27LCkhbR420uJXKE/c/qk3WzSH49AamuTGT+R3
         8PjYEulUFeu8tda9Cj88wfkYQGNNaihXuK10YOGNKr6qAgy0fqNPlVI7QXbvQxuEQxJI
         hIwg==
X-Forwarded-Encrypted: i=1; AKwUvByDLaPbt35kf1UKk1c1zqwmU9JdmHd7XLCnl6MQDAC5l9R9mpGNUoFaIDTAu/3DJEhqQoBIhK1B+z/nhVWlpNo=@vger.kernel.org
X-Gm-Message-State: AFuF++nWcy92Glgzxz2MyKXjlWYSiX4rNOAcfzJ42pr+FpEwjTpPSHDK
	wc+TKcebx8hDL8d6jR2D4TFT+CxowXhwcM/JhcsI9n7MciJ81eNU7zyR+f2IkJC2z6GamCAbMTp
	8gpXSpwJh3WB3wS477r7vBBga9CX/Mbs=
X-Gm-Gg: AYBFou1HEZc+x0ILEKjqMkRXWSJyiu56+t6mrtIOa485BcELr/Y6Creh1dxYPmYPonz
	fjL7sVICbP1VDgFvtis3c0gDWM3VGkFabrthD30/H1PWMdn3gWx/ZjHhmHmlh/iV4ybuuCREeYc
	0qTpYBmPwMbLOvIFFdNk5PtihT2ow0SYXnrv8oiB0OcIlplEkGDv0lEBTvZPLwTHFbKHsvJ+lPS
	o6dpiIZ9FXjHAR6mMzIkSUliJCACAGX30+usF1gADo2moK+yy4ug2iHyk4HgUfGG6yvxILfaNz8
	YEnzkyNU4iLwatswUuPQHcCxb4bnri+00LuEW7GnAA1NO3wfEd+cTGkIy0LreFK91MUev0dJp3/
	Jzw==
X-Received: by 2002:a17:907:3d44:b0:c27:420b:7c90 with SMTP id
 a640c23a62f3a-c27420ba0camr143467366b.48.1788680851220; Sun, 06 Sep 2026
 00:47:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260906034939.3746540-1-bestswngs@gmail.com> <apzpbMAdqSa_SkEx@strlen.de>
In-Reply-To: <apzpbMAdqSa_SkEx@strlen.de>
From: Weiming Shi <bestswngs@gmail.com>
Date: Sun, 6 Sep 2026 15:46:54 +0800
X-Gm-Features: AcwNN1UgO9RFEYZ29bttWZXxvvnUa5xtH-e-azRguJk4JvDmub9GiasshRFPr7o
Message-ID: <CANgPUi13MqJ41Rt23zXARUp2UW6K20TJkSbmSEhj7dpmfCsGEA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ip6t_rpfilter: handle routes without inet6_dev
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	co+459f67f4d8af8ce6@bugs.sh, Xiang Mei <xmei5@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Florian Westphal <fw@strlen.de> =E4=BA=8E2026=E5=B9=B49=E6=9C=886=E6=97=A5=
=E5=91=A8=E6=97=A5 12:18=E5=86=99=E9=81=93=EF=BC=9A
>
> Weiming Shi <bestswngs@gmail.com> wrote:
> > ip6_route_lookup() can return an error-free route whose rt6i_idev is
> > NULL.  For example, lowering an external nexthop device's MTU below
> > IPV6_MIN_MTU tears down its inet6_dev while fib6_ifdown() leaves routes
> > using nexthop objects in the FIB.
> >
> > rpfilter_lookup_reverse6() dereferences rt6i_idev before evaluating its
> > loose-mode condition.  This lets an unprivileged user with a private us=
er
> > and network namespace trigger a NULL pointer dereference:
> >
> >   Oops: general protection fault, probably for non-canonical address
> >   0xdffffc0000000000
> >   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007=
]
> >   RIP: rpfilter_mt
> >   ip6t_do_table
> >   nf_hook_slow
> >   ipv6_rcv
> >   process_backlog
> >   net_rx_action
> >   handle_softirqs
> >
> > Evaluate loose mode first because route existence is sufficient there.
> > In strict mode, compare devices only when the route has an inet6_dev.
>
> I don't think we should treat rt->rt6i_idev =3D=3D NULL as an eligible
> result, even in loose mode. Maybe this instead?
>
> diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t=
_rpfilter.c
> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
> @@ -61,7 +61,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, c=
onst struct sk_buff *skb,
>                 fl6.flowi6_oif =3D dev->ifindex;
>
>         rt =3D (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
> -       if (rt->dst.error)
> +       if (rt->dst.error || !rt->rt6i_idev)
>                 goto out;
>
>         if (rt->rt6i_flags & (RTF_REJECT|RTF_ANYCAST))
>
>

 Thanks, agreed. v2 will be sent.
