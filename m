Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66E016E881
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Mar 2024 12:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711715652; cv=none; b=EPDV0g3m6VvQHuj4I+YktgMAz58q5Tin7kVsMshybzrLcoQZR+vjXSel6GMi7twatNCjnIBKWUwtoeXsA2/1zzxYswghalVMJMlfAX2/L+rjGvPTy6PJ5O2MDAge/3BAqr4zlwD0gHq8By85+oxU2Luxx17yaG16t8P9Lp8HB28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711715652; c=relaxed/simple;
	bh=VEXihi4/+lsEPhvCzmACEATykKJfPopHaiYFYvqUqX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HFO7yN2ie8uJLw7uxaFOFGTZZ5tZGI4UrLB+7GZnAsOYXMqa5EpSM2p+dRnVd0CIHR3sXaBVmsTLq2pCAvz7+MtFscKDG68SDk32bahGLYVFLcdrxsp7pN8E5K/E1cfwYAbgv91BXpMtQXdgwcT5YlQQlx9FFTYvY/vZmoH2yt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2gpM5/G; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2gpM5/G"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-56ca3e11006so382689a12.3
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Mar 2024 05:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711715649; x=1712320449; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEEht4gVkO75YlS7w3h1a3+FyDs/s2xMtBXUdwf+fg8=;
        b=U2gpM5/GD7jn3Xopegb8rkMyjAOIFYPDEb2CNFeD52jfS86DTyjLF/xjUEFTdH2x3c
         8Z7GiSyZTyUryhzBGZOAFSP4lTxzc9Ni/c/8a0XbAajFCyN00XTX8mOt3+p6nJjeWXm/
         4BBBAr9mOWT5IAQvjfbKLTjijOVHu0/vYPdC9KoMByHTLT9HtYXRBE0EmXFa8Zf28oZT
         sii8/VVTHPziDEOqhG0nmJURoKb70NHMZBTl+AlceCzXENydVgZvkq2DzAJZ3IPWQeQ9
         byKm2v5ajcFRp3VT1Os2AGka5XRDA0e9VPJLD1rTBS88wUhwzoe/DsbOYJg8YbnibrCi
         cFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711715649; x=1712320449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GEEht4gVkO75YlS7w3h1a3+FyDs/s2xMtBXUdwf+fg8=;
        b=p2nJ7EjWPOnsXsGu2Ps2NGcPYJbTy3sjxXLYCDQIePVmv5jIqmCU6YDmj4klYMfdBm
         3edge2PLWxak6U2ha3jiTeTXBUxjlcdurDzZSm4SI2ZbkHonZS5Viq9PrcB+Y17L965e
         u0vVdzm8JbG6H97CmwXkfMI9IwalRZNA/+v08NxUAJiPJ6pSwnphFKETGJq0Yu9p/jkj
         B9r1rHYfdCXkznDlt7hU2UG2Q5E1Vs8omWxxzpoS4fiqOPJ75PSdrykydNBXtJKp691m
         tB3MNCyLnCaFB97zq3Mw3DVLIu3O7hm627p/3DmGyjfhXqLhIVl7bbiJFdYlMnebXV37
         vkrg==
X-Gm-Message-State: AOJu0YxzyPXnnCHq6BKa6OBnxhh1w5tuXEEydludixoqJxIlttdwArKu
	ErBNygQA+fwtkd/LARrN/nHhsmWoyNfdBsYXU+S+96iuUHqDVQgneQVrQdvbZqzXqcTpPRsv8N3
	7DxviF2QtsX3No8S9kyioyo8RHfw56x/SZx0=
X-Google-Smtp-Source: AGHT+IG59DGWobrMfklrOQqJA82d5vSl6shv47AnYIwHEHuT8db2kObivkMIIvdDQ4cLzqkPhfiOe0LGFy4oT4wUucw=
X-Received: by 2002:a17:906:2a14:b0:a47:3b21:161a with SMTP id
 j20-20020a1709062a1400b00a473b21161amr1307254eje.37.1711715648894; Fri, 29
 Mar 2024 05:34:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240325123614.10425-1-kerneljasonxing@gmail.com>
In-Reply-To: <20240325123614.10425-1-kerneljasonxing@gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Fri, 29 Mar 2024 20:33:32 +0800
Message-ID: <CAL+tcoCobqkfKX__xKwwp2u1FH29=+uAUtzwZRnfQjiyudS-eg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] netfilter: use NF_DROP instead of -NF_DROP
To: pablo@netfilter.org, kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2024 at 8:36=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> At the beginning in 2009 one patch [1] introduced collecting drop
> counter in nf_conntrack_in() by returning -NF_DROP. Later, another
> patch [2] changed the return value of tcp_packet() which now is
> renamed to nf_conntrack_tcp_packet() from -NF_DROP to NF_DROP. As
> we can see, that -NF_DROP should be corrected.
>
> Similarly, there are other two points where the -NF_DROP is used.
>
> Well, as NF_DROP is equal to 0, inverting NF_DROP makes no sense
> as patch [2] said many years ago.
>
> [1]
> commit 7d1e04598e5e ("netfilter: nf_conntrack: account packets drop by tc=
p_packet()")
> [2]
> commit ec8d540969da ("netfilter: conntrack: fix dropping packet after l4p=
roto->packet()")
>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>

Hello Pablo,

I don't know how it works in the nf area, so I would like to know the
status of this patch and another one (netfilter: conntrack: dccp: try
not to drop skb in conntrack
)? Is there anything I need to change?

Thanks,
Jason




> ---
> v2
> Link: https://lore.kernel.org/all/20240325031945.15760-1-kerneljasonxing@=
gmail.com/
> 1. squash three patches into one
> ---
>  net/ipv4/netfilter/iptable_filter.c  | 2 +-
>  net/ipv6/netfilter/ip6table_filter.c | 2 +-
>  net/netfilter/nf_conntrack_core.c    | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/ipt=
able_filter.c
> index b9062f4552ac..3ab908b74795 100644
> --- a/net/ipv4/netfilter/iptable_filter.c
> +++ b/net/ipv4/netfilter/iptable_filter.c
> @@ -44,7 +44,7 @@ static int iptable_filter_table_init(struct net *net)
>                 return -ENOMEM;
>         /* Entry 1 is the FORWARD hook */
>         ((struct ipt_standard *)repl->entries)[1].target.verdict =3D
> -               forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
> +               forward ? -NF_ACCEPT - 1 : NF_DROP - 1;
>
>         err =3D ipt_register_table(net, &packet_filter, repl, filter_ops)=
;
>         kfree(repl);
> diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip=
6table_filter.c
> index df785ebda0ca..e8992693e14a 100644
> --- a/net/ipv6/netfilter/ip6table_filter.c
> +++ b/net/ipv6/netfilter/ip6table_filter.c
> @@ -43,7 +43,7 @@ static int ip6table_filter_table_init(struct net *net)
>                 return -ENOMEM;
>         /* Entry 1 is the FORWARD hook */
>         ((struct ip6t_standard *)repl->entries)[1].target.verdict =3D
> -               forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
> +               forward ? -NF_ACCEPT - 1 : NF_DROP - 1;
>
>         err =3D ip6t_register_table(net, &packet_filter, repl, filter_ops=
);
>         kfree(repl);
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntra=
ck_core.c
> index c63868666bd9..6102dc09cdd3 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -2024,7 +2024,7 @@ nf_conntrack_in(struct sk_buff *skb, const struct n=
f_hook_state *state)
>                         goto repeat;
>
>                 NF_CT_STAT_INC_ATOMIC(state->net, invalid);
> -               if (ret =3D=3D -NF_DROP)
> +               if (ret =3D=3D NF_DROP)
>                         NF_CT_STAT_INC_ATOMIC(state->net, drop);
>
>                 ret =3D -ret;
> --
> 2.37.3
>
