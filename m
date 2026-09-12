Received: from mail-pz2-f17.google.com (mail-pz2-f17.google.com [74.125.228.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D700361DDA
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Sep 2026 07:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198949; cv=pass; b=WE5zyuQrG4C1P6dgSbdYx7Wc6qQcjOI0aZDxjejT7fsiN5PVlX7m9KOkaQNZJRAV+nG6F5UnO8AvTNJtiMchLA6uuP2mIKuwCTztR2yqjOJjRYH1E47eBc/7P+LwAxRxnwdznVLunfKc5puGo9CLzx4HhY+dqfnvtxuCKE1eQIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198949; c=relaxed/simple;
	bh=WRqQjY0nqBY7Sg3i9roQRCJWKcirMX5AO+S0jXiSkBk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ona5B9DQcYUVgQpJVG/wT+uJrqfCz2H9gr5mpA8/coUL8NqFs1Dbsf2PaonaG7ge78mCKsrejXjStIg9G2n5YufAWlEPmBoXUuiClGvwt287SQZYEe3QGthkTNpt9IiYJfhPA5rFlMz0pCv3V3bOGBympBelct5BWqhStQK5biU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=K2ha96Vg; arc=pass smtp.client-ip=74.125.228.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="K2ha96Vg"
Received: by mail-pz2-f17.google.com with SMTP id 41be03b00d2f7-cc4c3304784so642526a12.3
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Sep 2026 00:42:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789198948; cv=none;
        d=google.com; s=arc-20260327;
        b=AjEqE8FWf+2GkjS/AX1Wmyy7/Y1e+kJ8Cw/CLdGTiHI6n/CGKPjf6On2EqGiMbfCwb
         oz8BC8vZ2qyIIRnvtq4z3pTGx8G/OxI4FA11ILTtiVRS9Wnx+Wxzq+YmUzmsGAPNn0dZ
         qS9Dm9GZqloGQuBj1F00i5G2yIEaUpr9TyDjiLZDpZu+cqarRHHvKl/IvIf9NWgdrYKo
         q0xDoWK0Z1EFrsp/8nJS0a7Tt3RX8sya2/MfezOu8HaRup/3ICLL1VTFVC6txBbRVe9t
         l+9ZlQOFXIYIz/01Bc1mzVMd6Dllzse8baf9GlIDwuOj4ur5vm1ND5WC/nJVgHJmTI/S
         FvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3tJuKuoSzWQ5ciLlrNmqFia+HpadVqWjy0A5pW8ADTg=;
        fh=Is7aKdVDsHN5yWhHRzwAUHMjBnhvgQ36hrtuMJNkfck=;
        b=harw4N1NUGXEIbb+ZsXPa/m2kQy5A/2ljcU8Ujjur+7gC+IGMTNrhXRyD+x21rjDgY
         vdGASzpZc7CR7aIY5QlzJhjsCtqpP7F+2tNbdIKsjTB/othPCpC8UD18shRRAkgqd7Yh
         qc9yGgWR/ajZ4gvr8dgXtRo3Qjb04iy0MjgvJ8chBWaJPfdDr7PbS8MAe8+omYLouGAv
         nYYuVi+X5ox9h57DgBDIDrBtlUBMrwCWd4hm6IMH/S2/ZXa+8epwaXSX+GgvDRCsxU8l
         SX3AcCia7uUoNMqtL52Qxe4NVFy5VJuvppedmkzqJohnDw0xk5vp1aPKGYdjL003UK7+
         3cWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1789198948; x=1789803748; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3tJuKuoSzWQ5ciLlrNmqFia+HpadVqWjy0A5pW8ADTg=;
        b=K2ha96VgLBfj7USJ7QqRxz23DB91IQe7GzVSUzMTPVJ6B+Jj5kwmDCDk8EvJ8E/RWp
         EOBGd2Ql4GqP8upRk3W6RU79rjJsG5ZR8GFo8Aep8ZuebNMuYlVzEh7Ml1ZGoVL5Ran9
         TE7+H2o1gEFTlwpF3sQyvIxlWSolPfHdihJ5SfYKiFl/I4Z99W5LVDf5NaYsGEZIAL4J
         QZZV2s4SAV4VQqVk0NidAF7ELdZyc/v5VHCHERf7VDm96gv/LOrqqx+Q/v5q8PlZC7Nv
         F7OKsSVimmPYvcnpczF8Fbi8fehChZgiQUcCk1kS7eZOATARbNjM+PE6i2Hl7axckKf0
         LP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789198948; x=1789803748;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3tJuKuoSzWQ5ciLlrNmqFia+HpadVqWjy0A5pW8ADTg=;
        b=DqSy20XFYcnhqEQ+ezaCq1mmL/m3a7HyM/PTyMwYLvV9riF7k7QGRiNIbwLHhHWoVL
         Qo0IoAgSh55UE58kF6/xda2WI2KQgmJV6P0Ds13uhnL3iVju2i2EC3XdAQb/MzZLJC+C
         +m1vYZQH3oZ/FFqZ0fgv5v5eofuuILZ8FYS8b37kDm1ak38Z38yTxtKjXdO3Yo0no0Ee
         HwVU+qljpxSfXKYbrN/UV8ZocGZdPhdd1ait6BwGP4nGYMCHDpQayicK8yhj778DeQcK
         k3WqEbH74CWFMMw0gcJmitVZY21NWxJGonMvmQ/c2P9SwW+2qdC6malAO04vbFfZA8Y6
         8BKw==
X-Forwarded-Encrypted: i=1; AKwUvBwgU21ykmf1EvCcZt66XKwhSDZrv65MCeXoVBQD5Aq+6uQx/JRAHHaKLzKOsgvUG+vvIzCFQSSim5RDKBv9jIQ=@vger.kernel.org
X-Gm-Message-State: AFuF++mpx69ixJOln972BA5f/JRIzMpoc1Cpg+UMdQ5K6JYnynyOiZr1
	8hCfIsihRmwrwlIr1EIFwEc8eR3RaJBQzFecdEIR8ijUZe7URQ9ouB/rTqAXnpUU5rCGGp99oKz
	qVJOegs9qHEUmtB/ShLjewy9lVXGFaPuKPOOZ5fwi
X-Gm-Gg: AYBFou0bKYkRuFe4dOQyEuhPHWsQI7ErkP87wkP5KXBOEYOBGxDxXNGCPUIw8NemG0s
	1E0MNrzRVdse1NoGamIa8BuGuKC/RjTFRa/UtVptMGzcnpvyOACgYFXpKhy6iXSL/dmuO7RUott
	R7RalWWWYD8q7/B6osyUdYP6K+UBqiaxCN9WBWKwucTnryXFKSTteEr5buYsNlkYp++Kg1SvwoQ
	XJXqge/kBXEn9hNdAkdiWHZoGtX3rQNtR/9d7birerut7XYXQJw1mXq/fmOh2llF3/GtRnnglFs
	61rjPWE2NI33eA7XJ3aTCSOB8+WzF9F8I+4qQQ5h4cSzIK0YvJlSU1oM5g4UYKsegSEXvrt0/G6
	JvrhzUPb9pWjhQeQy83m8US6EV2p8YqGoCgMUBIs/w7XJ15VDaxHFKJ/jy5BVtODjJevQRekAe6
	o=
X-Received: by 2002:a05:6a21:6f88:b0:3d8:f78a:9349 with SMTP id
 adf61e73a8af0-3daed2e2f72mr16961102637.13.1789198947035; Sat, 12 Sep 2026
 00:42:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+0ovCj+Pd5owGH+51rA8-RDu9YFx5oYUv8bV0zOE72QgVfY0A@mail.gmail.com>
 <aqQOj8EHUb6ZzWjR@chamomile>
In-Reply-To: <aqQOj8EHUb6ZzWjR@chamomile>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Sat, 12 Sep 2026 00:42:16 -0700
X-Gm-Features: AcwNN1XLN5elLlT8PdL_Nzk9pxZ6_ooMYs8Rf-40WoQTVCImUG3ej9Qw_PbxJGY
Message-ID: <CA+0ovCg74Rj-rvV1kcLDj4nftRaX356-g4oc02kQSk3O7b_Mog@mail.gmail.com>
Subject: Re: [PATCH net] net: reject a forward path that loops back to the tunnel
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, falemi@asu.edu, 
	Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Xuanqiang and Pablo, many thanks for the helpful hints. I=E2=80=99ve sent o=
ut
a v2 addressing the comments above. Please let me know if any further
modifications are needed. Thanks!

On Fri, Sep 11, 2026 at 7:22=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> Hi,
>
> On Fri, Sep 11, 2026 at 12:17:08AM +0000, Farhad Alemi wrote:
> > ipip_fill_forward_path() and ip6_tnl_fill_forward_path() assign the out=
er
> > route's device to ctx->dev without checking that it differs from the tu=
nnel
> > device itself.  When a tunnel's outer route resolves back to that same
> > tunnel, the walk in dev_fill_forward_path() makes no progress and trips=
 its
> > loop check WARN_ON_ONCE(last_dev =3D=3D ctx->dev). Release the route an=
d
> > return -EOPNOTSUPP when the resolved dst device equals ctx->dev, so the
> > path walk either advances to a different device or fails cleanly.
>
> I think we can remove this WARN_ON_ONCE() from dev_fill_forward_path(), i=
e.
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index ecfbd72d5d1a..c67900354fa6 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -789,7 +789,7 @@ int dev_fill_forward_path(struct net_device_path_ctx =
*ctx,
>                         goto err_out;
>
>                 stack->num_paths++;
> -               if (WARN_ON_ONCE(last_dev =3D=3D ctx->dev))
> +               if (last_dev =3D=3D ctx->dev)
>                         goto err_out;
>         }
>
> > Closes: https://lore.kernel.org/all/CA+0ovCgaRvbd0Udj70b2xxG8Cx3CaCpNhn=
f1V4RWQuDveZYZhA@mail.gmail.com/
> > Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > ---
> > --- a/net/ipv4/ipip.c
> > +++ b/net/ipv4/ipip.c
> > @@ -375,6 +375,12 @@ static int ipip_fill_forward_path(struct
> > net_device_path_ctx *ctx,
> >       if (IS_ERR(rt))
> >               return PTR_ERR(rt);
> >
> > +     /* The path walk must advance: a route back into the tunnel is a =
loop. */
> > +     if (rt->dst.dev =3D=3D ctx->dev) {
> > +             ip_rt_put(rt);
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> >       path->type =3D DEV_PATH_TUN;
> >       path->tun.src_v4.s_addr =3D tiph->saddr;
> >       path->tun.dst_v4.s_addr =3D tiph->daddr;
> > --- a/net/ipv6/ip6_tunnel.c
> > +++ b/net/ipv6/ip6_tunnel.c
> > @@ -1863,7 +1863,12 @@ static int ip6_tnl_fill_forward_path(struct
> > net_device_path_ctx *ctx,
> >       fl6.flowi6_proto =3D 0;
> >
> >       dst =3D ip6_route_output(dev_net(ctx->dev), NULL, &fl6);
> > -     if (!dst->error) {
> > +     err =3D dst->error;
> > +     /* The path walk must advance: a route back into the tunnel is a =
loop. */
> > +     if (!err && dst->dev =3D=3D ctx->dev)
> > +             err =3D -EOPNOTSUPP;
> > +
> > +     if (!err) {
> >               path->type =3D DEV_PATH_TUN;
> >               path->tun.src_v6 =3D fl6.saddr;
> >               path->tun.dst_v6 =3D fl6.daddr;
> > @@ -1873,7 +1878,6 @@ static int ip6_tnl_fill_forward_path(struct
> > net_device_path_ctx *ctx,
> >               ctx->dev =3D dst->dev;
> >       }
> >
> > -     err =3D dst->error;
> >       if (err)
> >               dst_release(dst);
