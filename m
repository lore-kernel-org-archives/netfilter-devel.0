Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ADF140389
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715975673; cv=none; b=R/6i1h2WqrS9V4a41qlbTuzCMrvKqq34/Qz5M7IQpTnKa9ECufDIu7E23MxzrXfayMSWB5gMW8jejPbwiG7LjWn7Q6QFIDCWW1fROLMpiaUatc8H6tJCIZiSkik31OKYV2ufiJ8HFnVZHCIZ3SC/q5aTACvyPSfy0I0oGXODfs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715975673; c=relaxed/simple;
	bh=qfAsuOWl0hC/dGi12IhGHukk3mZo3M46eg6IvViHdmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=drx/qBYcftSm7u8pOVUOVU4WIXAM/6qKVTp22L5/tDOyA1ytsc82MrQtM1PwU/Ww0VPHSJ10ZqmiJ0HrXMipdHitij/J0y9abJ0uAEZySDKF3R2jXbdrb1RhE/Yjxgo5ibVU4IuQ2HNkqTv+hYWbip1f2Qdf0pCUhxrljtLhJ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PJz3wv6u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PJz3wv6u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715975669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iGcVskiD6pxYjXs3xmYrHWr55wsmHpoyxvnk3YO92e0=;
	b=PJz3wv6u/vDfvmZKrVsOnECjI7f/D1+/LajxppTOj19f3YaSCAdaM7YZgrDs+D8/BB8lhn
	mjsJdYk5JmCNl6wnUeJyvW5hhHWAsTnL+DXJbA/pqVvsvpJmAfLZ+PWZF7SLLYjLHj5iw6
	kj1ghrKEDtO8D8TG/KVYAhX+Aco4g20=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-w723_0uDOx680v9l3G3PEQ-1; Fri, 17 May 2024 15:54:27 -0400
X-MC-Unique: w723_0uDOx680v9l3G3PEQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-41c025915a9so48520675e9.3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 12:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715975666; x=1716580466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGcVskiD6pxYjXs3xmYrHWr55wsmHpoyxvnk3YO92e0=;
        b=LXOqkKisXmSyViwhU5tMDGmY8XB+DUrBanqeStrMfQxYzOfYheu5QfSfd0HWoFihmP
         LhuX7yib9Tm8K2xyv9s9mWXgciJ9NaqMQdG2/dLYCXqBhmxbTwA0sGjVdgF291HS7ZV0
         IqB2bFG/b20TgXY9zPnX44R1WfFUIdL7tsRj82ah4/ruy3i+E3F0zx3k03TtaCvznddE
         0MdQxZAscOQk56PA7ao1EyrNE4d/bkxsrB8B69iBxPQ3JpJnSHYEsNRZvQhlthBSfKan
         xzA60Y1i9OBkX/BQ2yL5S2/tN89/PN9d3YppzRVlSSpV4xVaNGyHTmgLPPEla7QSv37e
         FkxA==
X-Forwarded-Encrypted: i=1; AJvYcCXs0i7lHo6uSWRJmwfXXpC1A2L1JbyfjbiSS/m8AxHuXUpn17MqHW7ZRXcJ2y4g0v18OoryHjxcLujK9rnIEADcLVdi6ZqjDUBMy8oR1SJs
X-Gm-Message-State: AOJu0YyxoCuc6LuuNeUshAOFtc2hm98/0axHCLNOjZ/m1/nYu5nm+Lzr
	UEa1pc8aTPDBapvPI3gFFJlTYjSYrncPrO4fDPQcn+6Ye37FCTxUCoCBIBLf19pW3/fChAbKprS
	aPDzwU+uVv7g4OzCvUOke2ZFO55RkSBP7FElohu/4sRLq9P+jxTo6w0UQwAtkmQxt+A==
X-Received: by 2002:a05:600c:1914:b0:420:112e:6c1 with SMTP id 5b1f17b1804b1-420112e06d1mr144292945e9.13.1715975666281;
        Fri, 17 May 2024 12:54:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHj51XinY4vjmIEc/h1fzu4OdgZGt/HVOyIF5sT2vpojTz8FL4AiIG4vUyn8td6j40vq7ZobQ==
X-Received: by 2002:a05:600c:1914:b0:420:112e:6c1 with SMTP id 5b1f17b1804b1-420112e06d1mr144292615e9.13.1715975665642;
        Fri, 17 May 2024 12:54:25 -0700 (PDT)
Received: from localhost (net-188-152-99-152.cust.vodafonedsl.it. [188.152.99.152])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4202de3a79bsm53982065e9.6.2024.05.17.12.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 12:54:25 -0700 (PDT)
Date: Fri, 17 May 2024 21:54:23 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
	pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	toke@redhat.com, fw@strlen.de, hawk@kernel.org, horms@kernel.org,
	donhunte@redhat.com
Subject: Re: [PATCH bpf-next 2/4] netfilter: add bpf_xdp_flow_offload_lookup
 kfunc
Message-ID: <Zke172XFjqUGTE6O@lore-desk>
References: <cover.1715807303.git.lorenzo@kernel.org>
 <c87caa37757cdf6e323c89748fd0a0408fd47da2.1715807303.git.lorenzo@kernel.org>
 <CAP01T76razfX1e7BsMbbyecPF+RjtJYoZifR-Um_BAoyPNOyKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2H42TsNIWDJH9FrG"
Content-Disposition: inline
In-Reply-To: <CAP01T76razfX1e7BsMbbyecPF+RjtJYoZifR-Um_BAoyPNOyKg@mail.gmail.com>


--2H42TsNIWDJH9FrG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
> > +       tuplehash =3D flow_offload_lookup(flow_table, tuple);
> > +       if (!tuplehash)
> > +               return ERR_PTR(-ENOENT);
>=20
> This is fine to do, but the caller should catch it using IS_ERR_PTR
> and return NULL.
> BPF side cannot distinguish ERR_PTR from normal pointer, so this will
> cause a bad deref in the program.

ack, I will fix it in v2.

>=20
> > +
> > +       flow =3D container_of(tuplehash, struct flow_offload,
> > +                           tuplehash[tuplehash->tuple.dir]);
> > +       flow_offload_refresh(flow_table, flow, false);
> > +
> > +       return tuplehash;
> > +}
> > +
> > +__bpf_kfunc struct flow_offload_tuple_rhash *
> > +bpf_xdp_flow_offload_lookup(struct xdp_md *ctx,
> > +                           struct bpf_fib_lookup *fib_tuple,
> > +                           u32 fib_tuple__sz)
>=20
> Do you think the __sz has the intended effect? It only works when the
> preceding parameter is a void *.
> If you have a type like struct bpf_fib_lookup, I think it should work
> fine without taking a size at all.

ack, I will fix it in v2.

>=20
> > +{
> > +       struct xdp_buff *xdp =3D (struct xdp_buff *)ctx;
> > +       struct flow_offload_tuple tuple =3D {
> > +               .iifidx =3D fib_tuple->ifindex,
> > +               .l3proto =3D fib_tuple->family,
> > +               .l4proto =3D fib_tuple->l4_protocol,
> > +               .src_port =3D fib_tuple->sport,
> > +               .dst_port =3D fib_tuple->dport,
> > +       };
> > +       __be16 proto;
> > +
> > +       switch (fib_tuple->family) {
> > +       case AF_INET:
> > +               tuple.src_v4.s_addr =3D fib_tuple->ipv4_src;
> > +               tuple.dst_v4.s_addr =3D fib_tuple->ipv4_dst;
> > +               proto =3D htons(ETH_P_IP);
> > +               break;
> > +       case AF_INET6:
> > +               tuple.src_v6 =3D *(struct in6_addr *)&fib_tuple->ipv6_s=
rc;
> > +               tuple.dst_v6 =3D *(struct in6_addr *)&fib_tuple->ipv6_d=
st;
> > +               proto =3D htons(ETH_P_IPV6);
> > +               break;
> > +       default:
> > +               return ERR_PTR(-EINVAL);
>=20
> Likewise. While you check IS_ERR_VALUE in selftest, direct dereference
> will be allowed by verifier, which would crash the kernel.
> It's better to do something like conntrack kfuncs, where they set
> opts->error when returning NULL, allowing better debugging in case
> lookup fails.

ack, I will fix it in v2.

>=20
> > +       }
> > +
> > +       return bpf_xdp_flow_offload_tuple_lookup(xdp->rxq->dev, &tuple,=
 proto);
> > +}
> > +
> > +__diag_pop()
> > +
> > +BTF_KFUNCS_START(nf_ft_kfunc_set)
> > +BTF_ID_FLAGS(func, bpf_xdp_flow_offload_lookup)
> > +BTF_KFUNCS_END(nf_ft_kfunc_set)
> > +
> > +static const struct btf_kfunc_id_set nf_flow_offload_kfunc_set =3D {
> > +       .owner =3D THIS_MODULE,
> > +       .set   =3D &nf_ft_kfunc_set,
> > +};
> > +
> > +int nf_flow_offload_register_bpf(void)
> > +{
> > +       return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP,
> > +                                        &nf_flow_offload_kfunc_set);
> > +}
>=20
> We should probably also expose it to skb? We just need net_device, so
> it can work with both XDP and TC progs.
> That would be similar to how we expose conntrack kfuncs to both XDP
> and TC progs.

I think we will get very similar results to sw flowtable in this case,
don't you think?

>=20
> > +EXPORT_SYMBOL_GPL(nf_flow_offload_register_bpf);
> > diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow=
_table_inet.c
> > index 6eef15648b7b0..b13587238eceb 100644
> > --- a/net/netfilter/nf_flow_table_inet.c
> > +++ b/net/netfilter/nf_flow_table_inet.c
> > @@ -98,6 +98,8 @@ static int __init nf_flow_inet_module_init(void)
> >         nft_register_flowtable_type(&flowtable_ipv6);
> >         nft_register_flowtable_type(&flowtable_inet);
> >
> > +       nf_flow_offload_register_bpf();
> > +
>=20
> Error checking needed here? Kfunc registration can fail.

ack, I will fix it.

Regards,
Lorenzo

>=20
> >         return 0;
> >  }
> >
> > --
> > 2.45.0
> >
> >
>=20

--2H42TsNIWDJH9FrG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZke17wAKCRA6cBh0uS2t
rBRdAQCEERfoDpkBBYLgT8dxCY6w8lO1iaQ3rG5xreHO8f7EhAEA20DRSkH9tXWH
kRcvR5nmCv98ZBrvLTQtYNZ+PfeX6QM=
=90hE
-----END PGP SIGNATURE-----

--2H42TsNIWDJH9FrG--

