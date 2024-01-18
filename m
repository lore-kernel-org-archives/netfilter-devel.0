Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593B9200AD
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jan 2024 11:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705576089; cv=none; b=cbqCJsexwK4WgMkNzXqH8BvvnnMPG4lzXz5J5JcI3Xk/xNTwLtvGFhRbZGr3SKj4lA/aTVH6g3gmgXmfQPEdmU1+q44cg8obKvqU6y7rC+0I7KVgwecaSV5zG2jw2p/fNpgmYXTq0axH6GMOo9eK6HEfF3JQVZ/WxUoGShztk7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705576089; c=relaxed/simple;
	bh=tNBwY3kZ4r8uZhtCj/MeQOThus6o5Qjxil/+o3CPPvE=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Received:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Subject:From:
	 To:Cc:Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version; b=E0too4Iw0PnYXooQdAPIcHPPNPzx7nl6rifN4IJpLlK/YSZDxKCPLiX2nrtdOS4wMLNyRoE1G3pw7GH6gJ0+zT3bBQSiY8bJZdRjxNn4hT4NsmFB6ftmPAXadO/+LkEtv3ve4eIRpgdUQ6C+IKSuWQ3t7HiPrjZiZI7nmzJtxkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gAmOt34m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gAmOt34m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705576087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wyIKMqu1j/C3Lm7LUQ36mtXxb2sNFngMDGFf93Ohduw=;
	b=gAmOt34m7uG6Pi5iAXaPcn32dJzdqJfBjm2JiBMPh/OSa0s9Wrsk+VEl+lIKJLMHjmn7Y3
	aTRw5fgYv1vi2K7zuYtSvxMyZJnPLgaL0d/dtJu2Oeo2jCZw5mw/47h4VmJWrGYkCCeuK2
	dwNbgfUOFn/vWXQOfXsbUEZi9SaynW8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-WZpU50osMgW9ErJxKTNNqA-1; Thu, 18 Jan 2024 06:08:05 -0500
X-MC-Unique: WZpU50osMgW9ErJxKTNNqA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40d5428caaeso19383175e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jan 2024 03:08:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705576085; x=1706180885;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wyIKMqu1j/C3Lm7LUQ36mtXxb2sNFngMDGFf93Ohduw=;
        b=Tg9ju/IB2/zbXACLZVUI++lR1+2NLTdn/WEdAqAV2pO9f+/slXLFb9DCYcGgcxFSS5
         bvQ2pTjcrepN3m3i/VGdM9CVA77KsVr7pZ6ZDj5PiF31lA7bxJBgSMZjCH7weERBNe05
         myVKesI6afrFV3R7+1HKJpRl/L/fLZ3/+0WQlosrz2IsO2rW7bqj2/l6mbQaDiBG6H0x
         hG6AL1WUVjLpfcHqwKvoNIT04scSXd+94AaR1vuwWePTiFFnbN4Qc7PzjR6o3NXs5XAD
         nLKvDegFg8FFNy+UYcwzbigCYCSu9Z1iSdQbBojMDtL1hjTUxE7MUjIzOQnluT2qXnm8
         3gOA==
X-Gm-Message-State: AOJu0YyNjYXFjWW5DFtpwselNhfk+yDntXQQVgebBcUSEnKXg8DmuKqZ
	nxr2T4XAy6/2gocb+kK9DEWfc6a1oJPU+OUencHx/oGdpv+vn9cRhhCE1OlCCqAzI3D31aoUwB0
	znTeWI6wW9XpJBxSAAfHn3VA6K9B2D4yJ7Z3XsUbpmu/6TL6zDct169SYSsyXut/H2w==
X-Received: by 2002:a05:600c:1c12:b0:40e:89ad:8b77 with SMTP id j18-20020a05600c1c1200b0040e89ad8b77mr914211wms.3.1705576084845;
        Thu, 18 Jan 2024 03:08:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbwYHLGHnJ+67DW8pgoOe65NuBRP6H9vxFNmXdRicomgGIXcGVR8YhSlVp0IV7R5Vl+QW4CQ==
X-Received: by 2002:a05:600c:1c12:b0:40e:89ad:8b77 with SMTP id j18-20020a05600c1c1200b0040e89ad8b77mr914185wms.3.1705576084468;
        Thu, 18 Jan 2024 03:08:04 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-241-180.dyn.eolo.it. [146.241.241.180])
        by smtp.gmail.com with ESMTPSA id l26-20020a056000023a00b0033775980d26sm3797652wrz.2.2024.01.18.03.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 03:08:04 -0800 (PST)
Message-ID: <8834c825579a054d51be3d60405c0b204fa5c24b.camel@redhat.com>
Subject: Re: [PATCH net 14/14] netfilter: ipset: fix performance regression
 in swap operation
From: Paolo Abeni <pabeni@redhat.com>
To: Eric Dumazet <edumazet@google.com>, Jozsef Kadlecsik
 <kadlec@netfilter.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 netfilter-devel@vger.kernel.org,  davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, fw@strlen.de
Date: Thu, 18 Jan 2024 12:08:02 +0100
In-Reply-To: <CANn89iK_oa5CzeJVbiNSmPYZ6K+4_2m9nLqtSdwNAc9BtcZNew@mail.gmail.com>
References: <20240117160030.140264-1-pablo@netfilter.org>
	 <20240117160030.140264-15-pablo@netfilter.org>
	 <CANn89i+jS11sC6cXXFA+_ZVr9Oy6Hn1e3_5P_d4kSR2fWtisBA@mail.gmail.com>
	 <54f00e7c-8628-1705-8600-e9ad3a0dc677@netfilter.org>
	 <CANn89iK_oa5CzeJVbiNSmPYZ6K+4_2m9nLqtSdwNAc9BtcZNew@mail.gmail.com>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-01-17 at 17:28 +0100, Eric Dumazet wrote:
> On Wed, Jan 17, 2024 at 5:23=E2=80=AFPM Jozsef Kadlecsik <kadlec@netfilte=
r.org> wrote:
> >=20
> > Hi,
> >=20
> > On Wed, 17 Jan 2024, Eric Dumazet wrote:
> >=20
> > > On Wed, Jan 17, 2024 at 5:00=E2=80=AFPM Pablo Neira Ayuso <pablo@netf=
ilter.org> wrote:
> > > >=20
> > > > From: Jozsef Kadlecsik <kadlec@netfilter.org>
> > > >=20
> > > > The patch "netfilter: ipset: fix race condition between swap/destro=
y
> > > > and kernel side add/del/test", commit 28628fa9 fixes a race conditi=
on.
> > > > But the synchronize_rcu() added to the swap function unnecessarily =
slows
> > > > it down: it can safely be moved to destroy and use call_rcu() inste=
ad.
> > > > Thus we can get back the same performance and preventing the race c=
ondition
> > > > at the same time.
> > >=20
> > > ...
> > >=20
> > > >=20
> > > > @@ -2357,6 +2369,9 @@ ip_set_net_exit(struct net *net)
> > > >=20
> > > >         inst->is_deleted =3D true; /* flag for ip_set_nfnl_put */
> > > >=20
> > > > +       /* Wait for call_rcu() in destroy */
> > > > +       rcu_barrier();
> > > > +
> > > >         nfnl_lock(NFNL_SUBSYS_IPSET);
> > > >         for (i =3D 0; i < inst->ip_set_max; i++) {
> > > >                 set =3D ip_set(inst, i);
> > > > --
> > > > 2.30.2
> > > >=20
> > >=20
> > > If I am reading this right, time for netns dismantles will increase,
> > > even for netns not using ipset
> > >=20
> > > If there is no other option, please convert "struct pernet_operations
> > > ip_set_net_ops".exit to an exit_batch() handler,
> > > to at least have a factorized  rcu_barrier();
> >=20
> > You are right, the call to rcu_barrier() can safely be moved to
> > ip_set_fini(). I'm going to prepare a new version of the patch.
> >=20
> > Thanks for catching it.
>=20
> I do not want to hold the series, your fix can be built as another
> patch on top of this one.

Given the timing, if we merge this series as is, it could go very soon
into Linus' tree. I think it would be better to avoid introducing known
regressions there.=C2=A0

Any strong opinions vs holding this series until the problems are
fixed? Likely a new PR will be required.

Thanks,

Paolo

