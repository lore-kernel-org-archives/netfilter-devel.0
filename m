Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECA7623
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2024 01:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717638941; cv=none; b=aSE1HtoYzMxCL8hIc0MsqXyXyzL68fIiWZwksXrr7d73TmkefRVTz2cYy2Jo3qsGcspc4+1FXGqmYTnTJm+BIeg/WqA//PxM7kDzOoBhYYPPckYFq0RzB/+NhbOPfRNGvyRxymhGYykuE5xnut4O2OO+Oem26lOpJpnrvM0co8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717638941; c=relaxed/simple;
	bh=EbnCkFlmoIikZl/MUPpJTOMBQhQwsZz19Bv+l7q9w6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e+tymi+5vBxteZqzQfrRJVBO9O6OaOf2l/ql+oemhvkO4Sk1ccNzfueW4Zvsf/4AMZacPd5iJ8Vb0LCyfDq8w5sHq8CG0Esuss87QdnX1HG12KqSV/DFkcLdpA7mZPVTMwLDiv9mBnrsysZN5upVV8W+vBUQW4p8rKtr33l8IcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ipTxbFOQ; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ipTxbFOQ"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-44036ce0adaso156171cf.0
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2024 18:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717638939; x=1718243739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zUrSdBiduh4Db/1aD09S3T3SUCIp0AO2KNwZ81GBnvw=;
        b=ipTxbFOQCttxppYpLo9CkOSaTBYedSP0AjDSAwuYC/p3bhFoqSgBEscUqPo5KGTSpk
         TU2tnObP0FqKUvbVE9/TkDg7fFuYVUvmMFnIyqj50eE4F7SYAZlMrzxwMkLSgnjcGYex
         WMZrUbwBWHhgG0hK8XlhZzv/8U3iUUC8sbTfWQQdldBB89r7f7jgIXs+jLKazqvFEZiy
         VLsTvkp9mh/5PQi5vx4ZEN4b96R8cED2jlOPA60rL/cnmR70ryCbjJSXpkEiX/OPzwQ9
         zBJ+irkZOR9F0Lwjaso6F4pvC3tRWOyQc2KiOsKY4jypQuaqFkBadDqqGx+TuXAFQY3S
         0FEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717638939; x=1718243739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zUrSdBiduh4Db/1aD09S3T3SUCIp0AO2KNwZ81GBnvw=;
        b=gnsSad0wP/rC8ycSxsDFZ1mWJqCeZ3Cg8oRsk5M0DzCAg4VqLoYjSsdeYXBV4z2QC6
         dWsnogxvQKAvPar+TlzDBHbIiO5ikkKlFNpQ46Q4pvaJyQxbO2HnqSApjFVZ8DHGM31h
         DbxuN53zrlioBnyno1hrPzbANcvUl9v5+zk8PTwuBvYNs5Er57cxovB7atbYLnDyIOpv
         ZDslRjIIX8ycGdH01vx04mmqe+Q+gs8RV5YLPZpcBgA9CW18hh/xTJoX4supziar+m6M
         BZXzydU6bKGT8sW0MfEIPbG9STWgkFHAtmEoC7TPIf2+ExtIw0gTYgjneXmeqYH+dPat
         eZbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJ3hVCCX77+gAE4+LOCoVAu/Q3Kb39OiTyGE2VNurvDE6QaEJ4pKYD8MvjThS8OA6Z6OlpPFnTKvC3+aIqyNUd+w+AXCs0kv+0AcD+D0Ck
X-Gm-Message-State: AOJu0YylqHDKmhAp/YbT1rwDrI/eIqtLrJo4lx4fXWOjvYu2cucpNvI6
	4JuFMXC9gXFX2zxUCqd98qvXOO+mYoXV8ojAwJuw9fYTVHTgGSxjppzQyPtWVxRvsibEjrAR9Qr
	4WQsnWMW71Ztw51fjsNDUkltqXLAJy4mkbCN+1ArnMKf7cjMyRsiF
X-Google-Smtp-Source: AGHT+IEnxpQafaT11+txElX9LAJY4Zol9ZDkzyHkuw5ULeFvU8PmZa/RhoOwmmIwg92466dT1oqryNZ74WjtIJTXU5Y=
X-Received: by 2002:a05:622a:1dca:b0:43c:554e:b81 with SMTP id
 d75a77b69052e-440384ca86fmr860971cf.23.1717638938541; Wed, 05 Jun 2024
 18:55:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240604120311.27300-1-fw@strlen.de> <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc> <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc> <ZmDAQ6r49kSgwaMm@calendula>
 <CA+FuTSfAhHDedA68LOiiUpbBtQKV9E-W5o4TJibpCWokYii69A@mail.gmail.com> <ZmDjtm27BnxQ0xRX@calendula>
In-Reply-To: <ZmDjtm27BnxQ0xRX@calendula>
From: Willem de Bruijn <willemb@google.com>
Date: Wed, 5 Jun 2024 21:54:59 -0400
Message-ID: <CA+FuTScK2cpgRdd5CjgE=z=XbH8Gb45i4kkMNKsCPN9rQa6GpQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Christoph Paasch <cpaasch@apple.com>, 
	Netfilter <netfilter-devel@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	netdev@vger.kernel.org, daniel@iogearbox.net, 
	Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 5, 2024 at 6:16=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> On Wed, Jun 05, 2024 at 05:38:00PM -0400, Willem de Bruijn wrote:
> > On Wed, Jun 5, 2024 at 3:45=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilt=
er.org> wrote:
> > >
> > > On Wed, Jun 05, 2024 at 09:08:33PM +0200, Florian Westphal wrote:
> > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >
> > > > [ CC Willem ]
> > > >
> > > > > On Wed, Jun 05, 2024 at 08:14:50PM +0200, Florian Westphal wrote:
> > > > > > Christoph Paasch <cpaasch@apple.com> wrote:
> > > > > > > > Reported-by: Christoph Paasch <cpaasch@apple.com>
> > > > > > > > Suggested-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > > > Closes: https://github.com/multipath-tcp/mptcp_net-next/iss=
ues/494
> > > > > > > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > > > > >
> > > > > > > I just gave this one a shot in my syzkaller instances and am =
still hitting the issue.
> > > > > >
> > > > > > No, different bug, this patch is correct.
> > > > > >
> > > > > > I refuse to touch the flow dissector.
> > > > >
> > > > > I see callers of ip_local_out() in the tree which do not set skb-=
>dev.
> > > > >
> > > > > I don't understand this:
> > > > >
> > > > > bool __skb_flow_dissect(const struct net *net,
> > > > >                         const struct sk_buff *skb,
> > > > >                         struct flow_dissector *flow_dissector,
> > > > >                         void *target_container, const void *data,
> > > > >                         __be16 proto, int nhoff, int hlen, unsign=
ed int flags)
> > > > > {
> > > > > [...]
> > > > >         WARN_ON_ONCE(!net);
> > > > >         if (net) {
> > > > >
> > > > > it was added by 9b52e3f267a6 ("flow_dissector: handle no-skb use =
case")
> > > > >
> > > > > Is this WARN_ON_ONCE() bogus?
> > > >
> > > > When this was added (handle dissection from bpf prog, per netns), t=
he correct
> > > > solution would have been to pass 'struct net' explicitly via skb_ge=
t_hash()
> > > > and all variants.  As that was likely deemed to be too much code ch=
urn it
> > > > tries to infer struct net via skb->{dev,sk}.
> >
> > It has been a while, but I think we just did not anticipate skb's with
> > neither dev nor sk set.
> >
> > Digging through the layers from skb_hash to __skb_flow_dissect
> > now, it does look impractical to add such an explicit API.
> >
> > > > So there are several options here:
> > > > 1. remove the WARN_ON_ONCE and be done with it
> > > > 2. remove the WARN_ON_ONCE and pretend net was init_net
> > > > 3. also look at skb_dst(skb)->dev if skb->dev is unset, then back t=
o 1)
> > > >    or 2)
> > > > 4. stop using skb_get_hash() from netfilter (but there are likely o=
ther
> > > >    callers that might hit this).
> > > > 5. fix up callers, one by one
> > > > 6. assign skb->dev inside netfilter if its unset
> >
> > Is 6 a realistic option?
>
> Postrouting path already sets on skb->dev via ip_output(), if callers
> are "fixed" then skb->dev will get set twice.

I meant to set it just before calling skb_get_hash and unset
right after. Just using the skb to piggy back the information.

> the netfilter tracing infrastructure only needs a hash identifier for
> this packet to be displayed from userspace when tracing rules, how is
> the running the custom bpf dissector hook useful in such case?

The BPF flow dissector is there as much to short circuit the
hard-coded C protocol dissectors as to expand on the existing
feature set. I did not want production machines exposed to
every protocol parser, as that set kept expanding.

Having different dissection algorithms depending on where the
packet enters the dissector is also surprising behavior?

If all that is needed is an opaque ID, and on egress skb->hash
is derived with skb_set_hash_from_sk from sk_txhash, then
this can even be pseudo-random from net_tx_rndhash().

> the most correct solution is to pass struct net explicitly to the
> dissector API instead of guessing what net this packet belongs to.

Unfortunately from skb_get_hash to __skb_flow_dissect is four
layers of indirections, including one with three underscores already,
that cannot be easily circumvented.

Temporarily passing it through skb (and unsetting after) seems
the simplest fix to me.

> Else, remove this WARN_ON_ONCE which is just a oneliner.

According to the commit that introduced it, this was to sniff out drivers
that don't set this (via eth_get_headlen).

The problem is that nothing else warns loudly, so you just quietly
lose the BPF dissection coverage.

This is the first time it warned. You point out that the value of BPF
is limited to you in this case. But that's not true for all such cases.
I'd rather dissection breaks hard than that it falls back quietly for
input from an untrusted network.

Maybe reduce it to DEBUG_NET_WARN_ON_ONCE?

> > > > 3 and 2 combined are probably going to be the least invasive.
> > > >
> > > > 5 might take some time, we now know two, namely tcp resets generate=
d
> > > > from netfilter and igmp_send_report().  No idea if there are more.
> > >
> > > Quickly browsing, synproxy and tee also calls ip_local_out() too.
> > >
> > > icmp_send() which is used, eg. to send destination unreachable too to
> > > reset.
> >
> > Since this uses ip_append_data the generated response should have
> > its skb->sk set.
>
> thanks for explaining.
>
> > > There is also __skb_get_hash_symmetric() that could hit this from
> > > nft_hash?
> > >
> > > No idea what more callers need to be adjusted to remove this splat,
> > > that was a cursory tree review.
> > >
> > > And ip_output() sets on skb->dev from postrouting path, then if
> > > callers are fixed, then skb->dev would be once then again from output=
 path?
