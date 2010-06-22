From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Tue, 22 Jun 2010 11:10:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1006221057510.2237@blackhole.kfki.hu>
References: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com> <alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu> <AANLkTin1A2whIiaHWa4k0NZcdGqJhpk511hBSuLZd-pB@mail.gmail.com> <alpine.LSU.2.01.1006211846000.17820@obet.zrqbmnf.qr>
 <AANLkTil7HS75O5WO3Bxz1S7CF5D4r1om0iWD8vSF3bF6@mail.gmail.com> <alpine.LSU.2.01.1006221046110.13935@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-1589202093-1277197643=:2237"
Cc: Nishit Shah <nsshah.82@gmail.com>,
	krunal patel <krunal.raj@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:47395 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab0FVJKh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:10:37 -0400
In-Reply-To: <alpine.LSU.2.01.1006221046110.13935@obet.zrqbmnf.qr>
Content-ID: <alpine.DEB.2.00.1006221107340.2237@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-1589202093-1277197643=:2237
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1006221107341.2237@blackhole.kfki.hu>

On Tue, 22 Jun 2010, Jan Engelhardt wrote:

>=20
> On Tuesday 2010-06-22 07:41, Nishit Shah wrote:
> >> On Monday 2010-06-21 17:18, krunal patel wrote:
> >>>>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set ! --set testip src
> >>>>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set ! --set testip src
> >>>>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set --set testip src
> >>
> >> No question that reevaluating the same thing over and over
> >> increases runtime...
> >
> >Well, that is not the case. With 2.6.18.8 latency is same as 6 msecs.
>=20
> I think what you see could be noise.
>=20
> See commit 848484c08cb4ad161074262994410387585259ff in
> xtables-addons. There I needed 3000 ping packets (sent with ping -f)
> *and* a linear search of 10000 ranges to get above 2000 msec overhead
> for a single rule.

The impact of one more rule should be negligible. Something is bad there,=
=20
but we know too little on the setup, the configuration: what kind of=20
architecture, hardware you run the testing? What do you get when you=20
replace the rules with similar ones but with pure "-s src" matching, i.e.=
=20
without calling ipset? And it'd be good if you'd test a recent kernel as=20
well. 2.6.27 is almost two years old.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-1589202093-1277197643=:2237--
