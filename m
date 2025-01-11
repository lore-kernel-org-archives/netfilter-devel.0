Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A6B10F1
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2025 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736614402; cv=none; b=N/UBOCfCG6SLHGRGW5FgexaIKCncI0m8lGXwTqamcZ2UqADwmWBERmprgWRxRkYaDZK/GLDnAIxAxbeazkPKDWg/xZyiL9BFPr2qPFxdda5WMSXY3ucLZ5p6hsHGRR+WcGiOk4XTPudP3wylHOK7p1GIZ9rzuatnYOYl8D2CHlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736614402; c=relaxed/simple;
	bh=guPE5Gjn/88fNdcFpXmUwpxKl7DVxCxb7zhujurLL9A=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jCp/5Y9B/qCS1OgoA+D8Oix9gBgAgiLLdxJFdUoruJscBb3RpUfZzthXjVbDmtqvk5GRbgo3WEwPtKcghBp9V+Q4Fm/bzrStmgKNUgBjKJk2LY/P3+i+4avGjUYyE2jJqGrmjjdxMvkRKxcZ8iTj+hqJ9lBcwSi0tmYwxyscECg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 71BEA19201D6;
	Sat, 11 Jan 2025 17:53:17 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id q_ONqDIpu8A6; Sat, 11 Jan 2025 17:53:15 +0100 (CET)
Received: from mentat.rmki.kfki.hu (80-95-82-5.pool.digikabel.hu [80.95.82.5])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 3971419201BD;
	Sat, 11 Jan 2025 17:53:15 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 1A16E142836; Sat, 11 Jan 2025 17:53:15 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 15D611424A2;
	Sat, 11 Jan 2025 17:53:15 +0100 (CET)
Date: Sat, 11 Jan 2025 17:53:15 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, 
    Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, 
    Florian Westphal <fw@strlen.de>
Subject: Re: Android boot failure with 6.12
In-Reply-To: <Z4J9aM40NuYLakiy@calendula>
Message-ID: <6b97f047-e48c-3830-12cc-26385aea42a5@netfilter.org>
References: <CAHo-OozVuh4wbTHLxM2Y2+qgQqHTwcmhAfeFOM9W8thqzz6gdg@mail.gmail.com> <CAHo-OozPA7Z9pwBgEA3whh_e3NBhVi1D7EC4EXjNJdVHYNToKg@mail.gmail.com> <CAHo-Ooz-_idiFe4RD8DtbojKJFEa1N-pdA8pdwUPLJTp7iwGhw@mail.gmail.com> <CAHo-OozUg4UWvaP-FtHL44mygWwsnGO_eeFREhHddf=cc2-+ww@mail.gmail.com>
 <16d951e0-5fce-c227-5f50-10ecf3f16967@netfilter.org> <Z4J9aM40NuYLakiy@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1028300721-1736614395=:4693"
X-deepspam: ham 0%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1028300721-1736614395=:4693
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

On Sat, 11 Jan 2025, Pablo Neira Ayuso wrote:

> On Sat, Jan 11, 2025 at 02:31:18PM +0100, Jozsef Kadlecsik wrote:
> >=20
> > On Fri, 10 Jan 2025, Maciej =C5=BBenczykowski wrote:
> >=20
> > > nvm - https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.=
git/commit/net/netfilter/xt_mark.c?id=3D306ed1728e8438caed30332e1ab46b28c=
25fe3d8
> >=20
> > Sorry, but I don't understand the patch at all. With it applied now i=
t'd=20
> > be not possible to load in the "MARK" target with IPv4. The code segm=
ent=20
> > after the patch:
> >=20
> > static struct xt_target mark_tg_reg[] __read_mostly =3D {
> >         {
> >                 .name           =3D "MARK",
> >                 .revision       =3D 2,
> >                 .family         =3D NFPROTO_IPV6,
> >                 .target         =3D mark_tg,
> >                 .targetsize     =3D sizeof(struct xt_mark_tginfo2),
> >                 .me             =3D THIS_MODULE,
> >         },
> > #if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
> >         {
> >                 .name           =3D "MARK",
> >                 .revision       =3D 2,
> >                 .family         =3D NFPROTO_ARP,
> >                 .target         =3D mark_tg,
> >                 .targetsize     =3D sizeof(struct xt_mark_tginfo2),
> >                 .me             =3D THIS_MODULE,
> >         },
> > #endif
> > #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> >         {
> >                 .name           =3D "MARK",
> >                 .revision       =3D 2,
> >                 .family         =3D NFPROTO_IPV6,
> >                 .target         =3D mark_tg,
> >                 .targetsize     =3D sizeof(struct xt_mark_tginfo2),
> >                 .me             =3D THIS_MODULE,
> >         },
> > #endif
> > };
> >=20
> > How is it supposed to work for IPv4?
> >=20
> > Why the "IS_ENABLED(CONFIG_IP6_NF_IPTABLES)" part was not enough for =
the=20
> > IPv6-specific MARK target to be compiled in? Isn't it an issue about=20
> > selecting CONFIG_IP6_NF_IPTABLES vs CONFIG_IP6_NF_IPTABLES_LEGACY?
>=20
> This was fixed by an incremental patch:
>=20
>   306ed1728e84 ("netfilter: xtables: fix typo causing some targets not =
to load on IPv6")
>=20
> so there is no two MARK targets for NFPROTO_IPV6.

No, it was my fault not checking the patch properly. It's completely fine=
,=20
sorry for the noise!

Best regards,
Jozsef
--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-1028300721-1736614395=:4693--
