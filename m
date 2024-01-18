Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FD82941B;
	Thu, 18 Jan 2024 14:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705587891; cv=none; b=MA6RvqP19MXYODCDOj6He6F3I4q8tgmNzFjFjyB3AKAorMjjmCLt+6c2EzC2aOirjqqWAP2ElEE+JV0fuWNOwsZvsd6p4G3genHLUyGCR/34WjBHl/3uUlS5bhHOn+1MMNLgDFqgvoAxU5RAovAVtrcNbSLWBaZl/S4I7cwf/o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705587891; c=relaxed/simple;
	bh=zPFTOaIe0S+5LgvJyjbzVdwkGCoJBNa2EnHCGr/LOYM=;
	h=Received:X-Virus-Scanned:Received:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type; b=qdbrJvh+7pyvuSoST8Oeusb1lXzfks1PzAgfnOBmcdprrDhovtm0USLaMJ1Gt1WMEnC8t+ZSJ1MGvgiJp6nnmoEpMgpzNWzhPEqrmqizkH2m3g9pKXC/GaRse/i8abpiEtNOFpa/XM+aXLBVYT0R3u1rA0cxcUuv7yTf9XvkaMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 3001ECC02BD;
	Thu, 18 Jan 2024 15:24:44 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Thu, 18 Jan 2024 15:24:42 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 6BF51CC02BC;
	Thu, 18 Jan 2024 15:24:41 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 3001D343167; Thu, 18 Jan 2024 15:24:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 2E69B343166;
	Thu, 18 Jan 2024 15:24:41 +0100 (CET)
Date: Thu, 18 Jan 2024 15:24:41 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Eric Dumazet <edumazet@google.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, 
    David Miller <davem@davemloft.net>, netdev@vger.kernel.org, 
    kuba@kernel.org, pabeni@redhat.com, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net 14/14] netfilter: ipset: fix performance regression
 in swap operation
In-Reply-To: <CANn89iKtpVy1kSSuk_RSGN0R6L+roNJr81ED4+a2SZ2WKzGsng@mail.gmail.com>
Message-ID: <afb39fa8-3b28-27eb-c8ac-22691a064495@netfilter.org>
References: <20240117160030.140264-1-pablo@netfilter.org> <20240117160030.140264-15-pablo@netfilter.org> <CANn89iKtpVy1kSSuk_RSGN0R6L+roNJr81ED4+a2SZ2WKzGsng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1124285290-1705587881=:2980"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1124285290-1705587881=:2980
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Please drop the patch from the batch, it needs more work (see below).

On Thu, 18 Jan 2024, Eric Dumazet wrote:

> On Wed, Jan 17, 2024 at 5:00=E2=80=AFPM Pablo Neira Ayuso <pablo@netfil=
ter.org> wrote:
> >
> > The patch "netfilter: ipset: fix race condition between swap/destroy
> > and kernel side add/del/test", commit 28628fa9 fixes a race condition=
.
> > But the synchronize_rcu() added to the swap function unnecessarily sl=
ows
> > it down: it can safely be moved to destroy and use call_rcu() instead=
.
> > Thus we can get back the same performance and preventing the race con=
dition
> > at the same time.
> >
> > Fixes: 28628fa952fe ("netfilter: ipset: fix race condition between sw=
ap/destroy and kernel side add/del/test")
> > Link: https://lore.kernel.org/lkml/C0829B10-EAA6-4809-874E-E1E9C05A8D=
84@automattic.com/
> > Reported-by: Ale Crismani <ale.crismani@automattic.com>
> > Reported-by: David Wang <00107082@163.com
> > Tested-by: Ale Crismani <ale.crismani@automattic.com>
> > Tested-by: David Wang <00107082@163.com
> > Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/linux/netfilter/ipset/ip_set.h |  2 ++
> >  net/netfilter/ipset/ip_set_core.c      | 31 +++++++++++++++++++-----=
--
> >  2 files changed, 25 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/n=
etfilter/ipset/ip_set.h
> > index e8c350a3ade1..912f750d0bea 100644
> > --- a/include/linux/netfilter/ipset/ip_set.h
> > +++ b/include/linux/netfilter/ipset/ip_set.h
> > @@ -242,6 +242,8 @@ extern void ip_set_type_unregister(struct ip_set_=
type *set_type);
> >
> >  /* A generic IP set */
> >  struct ip_set {
> > +       /* For call_cru in destroy */
> > +       struct rcu_head rcu;
> >         /* The name of the set */
> >         char name[IPSET_MAXNAMELEN];
> >         /* Lock protecting the set data */
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/=
ip_set_core.c
> > index 4c133e06be1d..3bf9bb345809 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -1182,6 +1182,14 @@ ip_set_destroy_set(struct ip_set *set)
> >         kfree(set);
> >  }
> >
> > +static void
> > +ip_set_destroy_set_rcu(struct rcu_head *head)
> > +{
> > +       struct ip_set *set =3D container_of(head, struct ip_set, rcu)=
;
> > +
> > +       ip_set_destroy_set(set);
>=20
> Calling ip_set_destroy_set() from BH (rcu callbacks) is not working.

Yeah, it calls cancel_delayed_work_sync() to handle the garbage collector=
=20
and that can wait. The call can be moved into the main destroy function=20
and let the rcu callback do just the minimal job, however it needs a=20
restructuring. So please skip this patch now.

Best regards,
Jozsef
--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-1124285290-1705587881=:2980--
