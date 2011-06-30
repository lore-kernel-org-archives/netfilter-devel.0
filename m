From: Eric Leblond <eric@regit.org>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 20:08:29 +0200
Message-ID: <1309457319.5846.41.camel@tiger.regit.org>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
	 <1309340843.2532.112.camel@edumazet-laptop>
	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
	 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru>
	 <1309416426.2532.119.camel@edumazet-laptop>  <4E0C278B.7010403@yandex.ru>
	 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4E0C651A.1000300@trash.net>
	 <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4E0C8902.8070303@earthlink.net> <4E0C8D7F.3000902@trash.net>
	 <1309453730.5846.31.camel@tiger.regit.org>
	 <1309455919.2515.3.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1lMfe4KCRaZJs8K8GKlT"
Cc: Patrick McHardy <kaber@trash.net>, sclark46@earthlink.net,
	Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:43052 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab1F3SIm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:08:42 -0400
In-Reply-To: <1309455919.2515.3.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-1lMfe4KCRaZJs8K8GKlT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Thu, 2011-06-30 at 19:45 +0200, Eric Dumazet wrote:
> Le jeudi 30 juin 2011 =C3=A0 19:07 +0200, Eric Leblond a =C3=A9crit :
>=20
> > As the verdict failure is bound to occur in a high load time,
> > retransmission of the verdict (which is necessary) will not help the
> > system to recover. Userspace has to deal with it but it has another
> > consequences which is that userspace software may suffer of case where
> > successive failures occurs.
> >=20
> > In this scope, Florian's patch "netfilter: nfqueue: batch verdict
> > support" could be really useful. It could be used by userspace to
> > trigger an decide on all stucked packets. Issuing a massive ACCEPT coul=
d
> > lead to dynosaurus packet coming from ancient time but it could be ok i=
f
> > batch occurs enough often.
> >=20
> > Is there a plan to accept it in mainstream ?
>=20
> Given that apparently some apps are not aware some of their verdicts are
> lost, I consider the BATCH idea would be a bad idea, unless DROP is
> used.
>=20
> If you have any doubt, only sane thing is to drop packets, not accept
> them.

All depends of the application. For a security application this is a
sane behaviour (and maybe the only one acceptable) but we've seen
applications such as NFQUEUE based QoS implementation where ACCEPT may
be a decent decision.

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/

--=-1lMfe4KCRaZJs8K8GKlT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk4Mu50ACgkQnxA7CdMWjzJaYwCdGg5q7HvpbQsQD+XDGqU96hNv
5mkAn1kH20t2ZsDDdm7nt/bLKDJAd63X
=DXZg
-----END PGP SIGNATURE-----

--=-1lMfe4KCRaZJs8K8GKlT--

