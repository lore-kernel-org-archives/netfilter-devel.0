Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CC9383A2
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2025 13:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736602293; cv=none; b=CjqnnqMJJdCwvW5kJlDSMTEW6YX4fnDiwDX76GAypaOljeIm6tRuWxIvYxR899lY/Q25C3y8q3jxGgSlYGDCKRA+KJFwrd88T37PvrXbi+lQ+sVXx5mVsPXnVJEolcGXD8l3juo63yxPUgSTpPjPR+7/HELKUmHjmuYtpm0aZM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736602293; c=relaxed/simple;
	bh=lwsv+dTjAvxl2A2ZY3puYhbkkDwNHYVS48WesT94Dhk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=PUybvMsrRHSd7+fnQFC+j35LOLSPfXPuOvFkiBdNZgROJPU/XvymRQTJxX8riO5W1H7vf71KN4dSDh3kpDFZel8iJqkIoSdDSatekcPL0EjNzKhJFB7KxrvLjz/r6PxhVQgIly7wAzd+/DJzpOmJ5A+ag+ezXfRFlYPzvo7fZdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 0627219201D6;
	Sat, 11 Jan 2025 14:31:21 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id hf7LPmUYCrmb; Sat, 11 Jan 2025 14:31:18 +0100 (CET)
Received: from mentat.rmki.kfki.hu (80-95-82-5.pool.digikabel.hu [80.95.82.5])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id B165A19201D3;
	Sat, 11 Jan 2025 14:31:18 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 6E59D142836; Sat, 11 Jan 2025 14:31:18 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 6B6C41413CF;
	Sat, 11 Jan 2025 14:31:18 +0100 (CET)
Date: Sat, 11 Jan 2025 14:31:18 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, 
    Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Android boot failure with 6.12
In-Reply-To: <CAHo-OozUg4UWvaP-FtHL44mygWwsnGO_eeFREhHddf=cc2-+ww@mail.gmail.com>
Message-ID: <16d951e0-5fce-c227-5f50-10ecf3f16967@netfilter.org>
References: <CAHo-OozVuh4wbTHLxM2Y2+qgQqHTwcmhAfeFOM9W8thqzz6gdg@mail.gmail.com> <CAHo-OozPA7Z9pwBgEA3whh_e3NBhVi1D7EC4EXjNJdVHYNToKg@mail.gmail.com> <CAHo-Ooz-_idiFe4RD8DtbojKJFEa1N-pdA8pdwUPLJTp7iwGhw@mail.gmail.com>
 <CAHo-OozUg4UWvaP-FtHL44mygWwsnGO_eeFREhHddf=cc2-+ww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-602670319-1736600904=:4693"
Content-ID: <46c43c1f-151c-7ee4-dea5-432fb62f22a7@blackhole.kfki.hu>
X-deepspam: ham 0%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-602670319-1736600904=:4693
Content-Type: text/plain; charset=UTF-8
Content-ID: <988af676-fbd2-6514-feea-a4a99ff9cfe5@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 10 Jan 2025, Maciej =C5=BBenczykowski wrote:

> nvm - https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/=
commit/net/netfilter/xt_mark.c?id=3D306ed1728e8438caed30332e1ab46b28c25fe=
3d8

Sorry, but I don't understand the patch at all. With it applied now it'd=20
be not possible to load in the "MARK" target with IPv4. The code segment=20
after the patch:

static struct xt_target mark_tg_reg[] __read_mostly =3D {
        {
                .name           =3D "MARK",
                .revision       =3D 2,
                .family         =3D NFPROTO_IPV6,
                .target         =3D mark_tg,
                .targetsize     =3D sizeof(struct xt_mark_tginfo2),
                .me             =3D THIS_MODULE,
        },
#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
        {
                .name           =3D "MARK",
                .revision       =3D 2,
                .family         =3D NFPROTO_ARP,
                .target         =3D mark_tg,
                .targetsize     =3D sizeof(struct xt_mark_tginfo2),
                .me             =3D THIS_MODULE,
        },
#endif
#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
        {
                .name           =3D "MARK",
                .revision       =3D 2,
                .family         =3D NFPROTO_IPV6,
                .target         =3D mark_tg,
                .targetsize     =3D sizeof(struct xt_mark_tginfo2),
                .me             =3D THIS_MODULE,
        },
#endif
};

How is it supposed to work for IPv4?

Why the "IS_ENABLED(CONFIG_IP6_NF_IPTABLES)" part was not enough for the=20
IPv6-specific MARK target to be compiled in? Isn't it an issue about=20
selecting CONFIG_IP6_NF_IPTABLES vs CONFIG_IP6_NF_IPTABLES_LEGACY?

Also, why the "mark" match was not split into NFPROTO_IPV4, NFPROTO_ARP,=20
NFPROTO_IPV6 explicitly (and other matches where the target was split)?

Best regards,
Jozsef
--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu,
         kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-602670319-1736600904=:4693--
