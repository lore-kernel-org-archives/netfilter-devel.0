Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4881A45C14
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Feb 2024 11:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708602599; cv=none; b=uLEbOJeZ8MJoO5plFxcoudB1H0rF7ihSPYP1Abc7tKIE8n4CjbiPGg9D3O2fXhE5Jvr8cjgtJpe4KkBe5NnostDQxSD1jol22kzklEyQ+54MSFWs/nzDTBp3kpZzmYWu8rSVxtee5b9w+5xJHXcKfBvGe4hYV/Z7iWIGy5W1q2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708602599; c=relaxed/simple;
	bh=S+lSMx+cpAypKgWrkBpW0rLBzedIN0SL/NH4ECxlYdM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Obmm6m5RMZL0KfNubo2/y9heek5pNtNSLS1JRwyDfxQRTkgGN2jzKqRoFdNdLexWnUNsC2HTZEMT/J5PC8KfSx6eE1NqFRtdc3eS7sKaSA32NHAqsB8qN4ycXhVnUxiEHefM2Gx2WjDZBr9S+Ra7oRTfH8sDYyXSfWhyC6NSj4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=ObZfF9oT; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="ObZfF9oT"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5d3907ff128so6813780a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Feb 2024 03:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1708602584; x=1709207384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZULBF8XaSGVu56M0uuhQBNAO6ofQ/3YnhtDXhMt0Lc=;
        b=ObZfF9oTmkeb+WvPnCvKKOKRlRCijBRJdc/DoxN9DSPVGfIk6XdAo1x5oLKGdxdd7T
         Gf3DUMdG8k/5jN/kK6w8ZbWdUCr+PEehtayiBlUgIK/V4c+AbUgNKanebI4TZKn9Gn1p
         lJsU/p/qWlMnhmZuDCsdxR/sBen+1mtIK/FTLJhMlSao0iixZBVTH5qP7k081SNvg7dx
         JIFAnW0qV3qp+ogMqOT0lQQY1N5D2wNPoOoFAevw+gPuH9EX8IS3drZQMa51f8y7yvdw
         LfFgu0tVqu2OtpxXIPpCSkHmFE+yRjWk2IxC88+eVsP5bVXvHZb7PY6AS4sei3mZocJU
         LhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708602584; x=1709207384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fZULBF8XaSGVu56M0uuhQBNAO6ofQ/3YnhtDXhMt0Lc=;
        b=U61nzw886rCXB8h2ZnTvdWMJU3Bo4xP6ojGpcAS5yITEqi+AjbBrVWpcTrhOSQWnq3
         ddmKCPfuj7R5DILAypqKxIObZDR7l1dooqxK8nAdADG+oEum4Cf8HMEfhs+RFhIfRHs5
         y6Y0bAgljQTHqODFLj42YAeT24WyhkNnIAv9iM1dq7+xq5eBQzd9lJamQHtx5rbKYnYA
         cdWS/y54cRWbBj2myur9OV1IrOINtofKOjGjAPd1OQ4+FyBrCsQX13wzBNnpgVt756vi
         b0qkKZy5JU54rc+ciptk8Nd6cNvNXb5x9GhutJdiuZwY9tiSqO8Ck/+QXGqtk2OCcnCd
         XYng==
X-Forwarded-Encrypted: i=1; AJvYcCWQnDMyXniEuoLDVyN/LVvdFKkwu7jANgRKNfkRCqqMTySIGLNulFrLJBiXpIn5+1XF0nYUr6rA4IBw7mKQCeyIT+m83D0GkpACxfLUxPfX
X-Gm-Message-State: AOJu0YwTxOesuPxSSqAdbMT4yM/Z6HVBYbmtDutvwLwVLGORaYd6C9h2
	9dErzT5CyUOvYJb6MuWDlDh/nJrJwx6TSYEdwyWM7TscXkzA0up2cygjP5Np6vylT+8mTyu1n8L
	2F2fh/tiECjwPFaQZOaS8b7FSl8kKpYzF0zOcuQ==
X-Google-Smtp-Source: AGHT+IFb1YdrkCOnDMHInLYrYkCzmdz88+ygcD18ROMFgea6wIq6YA6ZcXwbczpo760i/2oZ6HoGHHAaABktw8PtuS8=
X-Received: by 2002:a17:90b:23c7:b0:29a:42a2:837e with SMTP id
 md7-20020a17090b23c700b0029a42a2837emr1811792pjb.38.1708602584261; Thu, 22
 Feb 2024 03:49:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222103308.7910-1-ignat@cloudflare.com> <ZdcnfnoEE10cV7gL@calendula>
In-Reply-To: <ZdcnfnoEE10cV7gL@calendula>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 22 Feb 2024 11:49:32 +0000
Message-ID: <CALrw=nE4SY2iZkW9wtYMUwcA=p0wSOzOmSqRF3i_4p4sAnEKUg@mail.gmail.com>
Subject: Re: [PATCH v3] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, kernel-team@cloudflare.com, jgriege@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

On Thu, Feb 22, 2024 at 10:52=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter=
.org> wrote:
>
> Hi Ignat,
>
> On Thu, Feb 22, 2024 at 10:33:08AM +0000, Ignat Korchagin wrote:
> > Commit d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family")=
 added
> > some validation of NFPROTO_* families in the nft_compat module, but it =
broke
> > the ability to use legacy iptables modules in dual-stack nftables.
> >
> > While with legacy iptables one had to independently manage IPv4 and IPv=
6
> > tables, with nftables it is possible to have dual-stack tables sharing =
the
> > rules. Moreover, it was possible to use rules based on legacy iptables
> > match/target modules in dual-stack nftables.
> >
> > As an example, the program from [2] creates an INET dual-stack family t=
able
> > using an xt_bpf based rule, which looks like the following (the actual =
output
> > was generated with a patched nft tool as the current nft tool does not =
parse
> > dual stack tables with legacy match rules, so consider it for illustrat=
ive
> > purposes only):
> >
> > table inet testfw {
> >   chain input {
> >     type filter hook prerouting priority filter; policy accept;
> >     bytecode counter packets 0 bytes 0 accept
> >   }
> > }
>
> This nft command does not exist in tree, this does not restores fine
> with nft -f. It provides a misleading hint to the reader.

I tried to clarify above that this is for illustrative purposes only -
just to give context about what we are trying to do, but do let me
know if you prefer a v4 with this completely removed.

> I am fine with restoring this because you use it, but you have to find
> a better interface than using nft_compat to achieve this IMO.

We're actually looking to restore the effort in [1] so some support
would be appreciated.

> The upstream consensus this far is not to expose nft_compat features
> through userspace nft. But as said, I understand and I am fine with
> restoring kernel behaviour so you can keep going with your out-of-tree
> patch.

Understood. There is no expectation from us that upstream userspace
nft should natively support this (as it didn't before d0009effa886),
but we can send the patch if consensus changes.

> Thanks !
>
> > After d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") =
we get
> > EOPNOTSUPP for the above program.
> >
> > Fix this by allowing NFPROTO_INET for nft_(match/target)_validate(), bu=
t also
> > restrict the functions to classic iptables hooks.
> >
> > Changes in v3:
> >   * clarify that upstream nft will not display such configuration prope=
rly and
> >     that the output was generated with a patched nft tool
> >   * remove example program from commit description and link to it inste=
ad
> >   * no code changes otherwise
> >
> > Changes in v2:
> >   * restrict nft_(match/target)_validate() to classic iptables hooks
> >   * rewrite example program to use unmodified libnftnl
> >
> > Fixes: d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family")
> > Link: https://lore.kernel.org/all/Zc1PfoWN38UuFJRI@calendula/T/#mc94726=
2582c90fec044c7a3398cc92fac7afea72 [1]
> > Link: https://lore.kernel.org/all/20240220145509.53357-1-ignat@cloudfla=
re.com/ [2]
> > Reported-by: Jordan Griege <jgriege@cloudflare.com>
> > Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
> > ---
> >  net/netfilter/nft_compat.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> > index 1f9474fefe84..d3d11dede545 100644
> > --- a/net/netfilter/nft_compat.c
> > +++ b/net/netfilter/nft_compat.c
> > @@ -359,10 +359,20 @@ static int nft_target_validate(const struct nft_c=
tx *ctx,
> >
> >       if (ctx->family !=3D NFPROTO_IPV4 &&
> >           ctx->family !=3D NFPROTO_IPV6 &&
> > +         ctx->family !=3D NFPROTO_INET &&
> >           ctx->family !=3D NFPROTO_BRIDGE &&
> >           ctx->family !=3D NFPROTO_ARP)
> >               return -EOPNOTSUPP;
> >
> > +     ret =3D nft_chain_validate_hooks(ctx->chain,
> > +                                    (1 << NF_INET_PRE_ROUTING) |
> > +                                    (1 << NF_INET_LOCAL_IN) |
> > +                                    (1 << NF_INET_FORWARD) |
> > +                                    (1 << NF_INET_LOCAL_OUT) |
> > +                                    (1 << NF_INET_POST_ROUTING));
> > +     if (ret)
> > +             return ret;
> > +
> >       if (nft_is_base_chain(ctx->chain)) {
> >               const struct nft_base_chain *basechain =3D
> >                                               nft_base_chain(ctx->chain=
);
> > @@ -610,10 +620,20 @@ static int nft_match_validate(const struct nft_ct=
x *ctx,
> >
> >       if (ctx->family !=3D NFPROTO_IPV4 &&
> >           ctx->family !=3D NFPROTO_IPV6 &&
> > +         ctx->family !=3D NFPROTO_INET &&
> >           ctx->family !=3D NFPROTO_BRIDGE &&
> >           ctx->family !=3D NFPROTO_ARP)
> >               return -EOPNOTSUPP;
> >
> > +     ret =3D nft_chain_validate_hooks(ctx->chain,
> > +                                    (1 << NF_INET_PRE_ROUTING) |
> > +                                    (1 << NF_INET_LOCAL_IN) |
> > +                                    (1 << NF_INET_FORWARD) |
> > +                                    (1 << NF_INET_LOCAL_OUT) |
> > +                                    (1 << NF_INET_POST_ROUTING));
> > +     if (ret)
> > +             return ret;
> > +
> >       if (nft_is_base_chain(ctx->chain)) {
> >               const struct nft_base_chain *basechain =3D
> >                                               nft_base_chain(ctx->chain=
);
> > --
> > 2.39.2
> >

[1]: https://lore.kernel.org/netfilter-devel/20220831101617.22329-1-fw@strl=
en.de/

Ignat
