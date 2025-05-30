Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137BC1D554
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2025 02:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748573111; cv=none; b=td9U6TE1raJwc9IodEhgY8zvEKrHi/eDaY71zanv8Uo9uXq7/5kXIyFq4EXZrRzjp4Zi4dbMtz4aUMxdx5bAqrKNcmOiqu+slvr7KbNIxG2N48WJQ9CLAIkFLKkgnRZRh52HEvChtbV95yCUymKMSqrwNp0DNGbwJtRfqykixA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748573111; c=relaxed/simple;
	bh=fJ1hcBeqPPAuKUtqVgkduUGQurVdTugh9Iqsgd1JVdg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N0g4G6YB6LreuCRJ8Xr2FfHT+gE0nQlD0NIVcuz/77MVIrl+RHYKZTO6e9SbrOf9lQ2cEaGt1JXM+NhPinHGUm6LvE7BYI8Bl4OmObJblOzw6RF+ZOVvpLNmxsIK2+N8eE+qJr0wYm4RogW6yxGQ6aPrkgK4zmxfytTJqH+y0rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6tO4Flh; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6tO4Flh"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6fab5a9a892so17421066d6.0
        for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 19:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748573109; x=1749177909; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqPS5jGr/MDL9kZTLL6WpxqF87uyKXi4+cbNbTn1N04=;
        b=O6tO4FlhAXfogzY1tS5Ma16zGydzCYYkrJZwW6AtjP1RuKupxh/4oY7IxNTR5AEo6T
         8kQBu/u4kZo98nJjwSu7+E37f+dqei6mVa0mCk1A8z61ofwQqkHCEqsuNRBcbFjV6boW
         aFeqFmEvwKm2fk7DL1N+UWbwQqa56h/qKZdBl5DSRGvk+jVXOVW3Z9CbAZDxZudyjAfW
         tbdA6mMoBltE6/Kb93gPKCf4R4d5mKw2kmbM0QN4TBu/DfxnvD3EXXN5IsQ0bvFs5l3A
         a3+LZU4qQlrH5JEgd8x84KvXA6AfMeP/0Qd384LQ8AQWKB60Z/gcZBCDSnOUc6H1+9Z7
         MyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748573109; x=1749177909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HqPS5jGr/MDL9kZTLL6WpxqF87uyKXi4+cbNbTn1N04=;
        b=CnCUy5Sh27inTTdQDh3TM2mZy5HeyDCbGc1znn6wn6TeJ8sXRawnXK3sCYoJwC4EB6
         pnTSpj8Ry7NKCb5S3BJS3qjjIzUHhuKw4GA2E3FY6xgFGHZ7XYgcoEeR0HLl/e7DbzPk
         jn2qJTx9MAOtUTqDS5X78Q6+xZMWMJ8jqNbJd5kKuldquZMZrOfY6HXqY1yMa9MMZM+X
         WkUHBf0HAz4KRl4HMftQUawt08/uKXh817/mXXhqHTaGjaC8HAtN6PGtQHqdabilOVAM
         igWP1uLY+SV506nmg5DphVAHD+/omoOtdgg86SNFC6BOsdwVeMFcrXAuIxvq3OdHTHan
         4J7A==
X-Forwarded-Encrypted: i=1; AJvYcCXi3AncNxXQsYSUr5ho3sZ7eBr0lPozX5gCwKGWfbSDOHUx5Se1GnX9ezADrFkthybhI+/n3FhE067ByuQbT1w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0vjNpfEZzOYchjbTbe7wSgGtS5+pKDAzuZ5MNZiQ4ZPddae51
	YTKAp0A1yHA4UMMaWXDZk2VFw50Ur0N0CwuWfv39yPse/+hPuK6OOTlIPymq00QHR5NDcRLeQcw
	HN8fznl/bmx+S6UIJCqkw2xKzZFu0U6j6JrPK5Pk=
X-Gm-Gg: ASbGncuKKYEqPQi92vva/cMduwH8gGqEmvMMv8hDoZJ80u4oqhwxVValZFj9fbW3/l6
	fnkuSZK2hfdIPh1wlp49HPiN6TIBLQjB3oV4dihLoZG3tKDr6V6EW/ZWB1Jw0S3WaBp6Pkkygx6
	uvRoko2CMyUgzPLocINTgLwgTxAN3tXDYAfg==
X-Google-Smtp-Source: AGHT+IGrBdpFU27GpcQUbc8gUYL+hdLRVKBoBHWYXl7bWkimKiw0SCznhTx0Vh0tMvifJte7KPdSJchYcW/z79jmv3w=
X-Received: by 2002:ad4:5bec:0:b0:6f8:b73e:8ea5 with SMTP id
 6a1803df08f44-6faced43f42mr25250146d6.26.1748573108783; Thu, 29 May 2025
 19:45:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDeftvfuOufo5kdw@fedora> <aDj_oGBSNIUFEZFF@strlen.de>
In-Reply-To: <aDj_oGBSNIUFEZFF@strlen.de>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 30 May 2025 10:44:32 +0800
X-Gm-Features: AX0GCFsVYKXPu7Z7wdP7Gmp1MtHpDezgHpbtSFrLvPps6VnkKN2ow3qbm35PSEA
Message-ID: <CALOAHbBhSAO5aQ=mf8Dn0=MViWQNbCy9zyDx=UF-dbx_dHKH4A@mail.gmail.com>
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
To: Florian Westphal <fw@strlen.de>
Cc: Shaun Brady <brady.1345@gmail.com>, pablo@netfilter.org, kadlec@netfilter.org, 
	David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025 at 7:21=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Shaun Brady <brady.1345@gmail.com> wrote:
> > On Wed, May 28, 2025 at 05:03:56PM +0800, Yafang Shao wrote:
> > > diff --git a/net/netfilter/nf_conntrack_core.c
> > > b/net/netfilter/nf_conntrack_core.c
> > > index 7bee5bd22be2..3481e9d333b0 100644
> > > --- a/net/netfilter/nf_conntrack_core.c
> > > +++ b/net/netfilter/nf_conntrack_core.c
> > > @@ -1245,9 +1245,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
> > >
> > >         chainlen =3D 0;
> > >         hlist_nulls_for_each_entry(h, n,
> > > &nf_conntrack_hash[reply_hash], hnnode) {
> > > -               if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY=
].tuple,
> > > -                                   zone, net))
> > > -                       goto out;
> > > +               //if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REP=
LY].tuple,
> > > +               //                  zone, net))
> > > +               //      goto out;
> > >                 if (chainlen++ > max_chainlen) {
> > >  chaintoolong:
> > >                         NF_CT_STAT_INC(net, chaintoolong);
> >
> > Forgive me for jumping in with very little information, but on a hunch =
I
> > tried something.  I applied the above patch to another bug I've been
> > investigating:
> >
> > https://bugzilla.netfilter.org/show_bug.cgi?id=3D1795
> > and Ubuntu reference
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2109889
> >
> > The Ubuntu reproduction steps where easier to follow, so I mimicked
> > them:
> >
> > # cat add_ip.sh
> > ip addr add 10.0.1.200/24 dev enp1s0
> > # cat nft.sh
> > nft -f - <<EOF
> > table ip dnat-test {
> >  chain prerouting {
> >   type nat hook prerouting priority dstnat; policy accept;
> >   ip daddr 10.0.1.200 udp dport 1234 counter dnat to 10.0.1.180:1234
> >  }
> > }
> > EOF
> > # cat listen.sh
> > echo pong|nc -l -u 10.0.1.180 1234
> > # ./add_ip.sh ; ./nft.sh ; listen.sh (and then just ./listen.sh again)
>
> We don't have a selftest for this, I'll add one.
>
> Following patch should help, we fail to check for reverse collision
> before concluding we don't need PAT to handle this.
>
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -248,7 +248,7 @@ static noinline bool
>  nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
>                       const struct nf_conn *ignored_ct)
>  {
> -       static const unsigned long uses_nat =3D IPS_NAT_MASK | IPS_SEQ_AD=
JUST_BIT;
> +       static const unsigned long uses_nat =3D IPS_NAT_MASK | IPS_SEQ_AD=
JUST;
>         const struct nf_conntrack_tuple_hash *thash;
>         const struct nf_conntrack_zone *zone;
>         struct nf_conn *ct;
> @@ -287,8 +287,14 @@ nf_nat_used_tuple_new(const struct nf_conntrack_tupl=
e *tuple,
>         zone =3D nf_ct_zone(ignored_ct);
>
>         thash =3D nf_conntrack_find_get(net, zone, tuple);
> -       if (unlikely(!thash)) /* clashing entry went away */
> -               return false;
> +       if (unlikely(!thash)) {
> +               struct nf_conntrack_tuple reply;
> +
> +               nf_ct_invert_tuple(&reply, tuple);
> +               thash =3D nf_conntrack_find_get(net, zone, &reply);
> +               if (!thash) /* clashing entry went away */
> +                       return false;
> +       }
>
>         ct =3D nf_ct_tuplehash_to_ctrack(thash);
>

JFYI
After applying this additional patch, the NAT source port is
reallocated to a new random port again in my case.

--=20
Regards
Yafang
