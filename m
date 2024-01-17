Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06E5224C2;
	Wed, 17 Jan 2024 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705508619; cv=none; b=RFe4CemZz+GGWhQq5PEnXuaqYYVi/5BIzCyFtMpP3CR5+zh1yemycDurt4aVlwBhvjc0pLe94eUWJaDvtur6YHROegnwuiMJMBCq37SK2R93PDMOlTQnh2HoSZVIkhZEOSLtr9qK74VYCUPkGhBN1t59UyWsIHjj4jO/9xFvTrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705508619; c=relaxed/simple;
	bh=smZ2otwKHud9IPTdAKTJAvy3iJOvhT25Gpgpb2Mq4fY=;
	h=Received:X-Virus-Scanned:Received:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type; b=sMvmanYt4fcuSB2br1S3ww/RBMP1uR4J+tU2uOyQHOjPK9Ol1sCF84lqJ4W3yKnJ0Q1a+NyC95kKEJPof2IsBRkTqeYuqorajjNKiyV2WPvzM3cbKzpNEqKgkL60zM8P3iehrXLreiINfXQsxc7kXiaywJQcSn2O8QxX2aqWieg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 6D3D6CC011F;
	Wed, 17 Jan 2024 17:23:28 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Wed, 17 Jan 2024 17:23:26 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 18445CC011D;
	Wed, 17 Jan 2024 17:23:25 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id CA962343167; Wed, 17 Jan 2024 17:23:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id C9455343166;
	Wed, 17 Jan 2024 17:23:25 +0100 (CET)
Date: Wed, 17 Jan 2024 17:23:25 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Eric Dumazet <edumazet@google.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, 
    davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
    pabeni@redhat.com, fw@strlen.de
Subject: Re: [PATCH net 14/14] netfilter: ipset: fix performance regression
 in swap operation
In-Reply-To: <CANn89i+jS11sC6cXXFA+_ZVr9Oy6Hn1e3_5P_d4kSR2fWtisBA@mail.gmail.com>
Message-ID: <54f00e7c-8628-1705-8600-e9ad3a0dc677@netfilter.org>
References: <20240117160030.140264-1-pablo@netfilter.org> <20240117160030.140264-15-pablo@netfilter.org> <CANn89i+jS11sC6cXXFA+_ZVr9Oy6Hn1e3_5P_d4kSR2fWtisBA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1146489260-1705508605=:2980"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1146489260-1705508605=:2980
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 17 Jan 2024, Eric Dumazet wrote:

> On Wed, Jan 17, 2024 at 5:00=E2=80=AFPM Pablo Neira Ayuso <pablo@netfil=
ter.org> wrote:
> >
> > From: Jozsef Kadlecsik <kadlec@netfilter.org>
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
>=20
> ...
>=20
> >
> > @@ -2357,6 +2369,9 @@ ip_set_net_exit(struct net *net)
> >
> >         inst->is_deleted =3D true; /* flag for ip_set_nfnl_put */
> >
> > +       /* Wait for call_rcu() in destroy */
> > +       rcu_barrier();
> > +
> >         nfnl_lock(NFNL_SUBSYS_IPSET);
> >         for (i =3D 0; i < inst->ip_set_max; i++) {
> >                 set =3D ip_set(inst, i);
> > --
> > 2.30.2
> >
>=20
> If I am reading this right, time for netns dismantles will increase,
> even for netns not using ipset
>=20
> If there is no other option, please convert "struct pernet_operations
> ip_set_net_ops".exit to an exit_batch() handler,
> to at least have a factorized  rcu_barrier();

You are right, the call to rcu_barrier() can safely be moved to=20
ip_set_fini(). I'm going to prepare a new version of the patch.

Thanks for catching it.

Best regards,
Jozsef
--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-1146489260-1705508605=:2980--
