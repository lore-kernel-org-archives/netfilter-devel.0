From: Eric Leblond <eric@regit.org>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 19:07:44 +0200
Message-ID: <1309453730.5846.31.camel@tiger.regit.org>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
		 <1309340843.2532.112.camel@edumazet-laptop>
		 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
		 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru>
		 <1309416426.2532.119.camel@edumazet-laptop>  <4E0C278B.7010403@yandex.ru>
		 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
		 <4E0C651A.1000300@trash.net>
	 <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4E0C8902.8070303@earthlink.net> <4E0C8D7F.3000902@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-EyPdZF39mzvyqVrmA265"
Cc: sclark46@earthlink.net, Eric Dumazet <eric.dumazet@gmail.com>,
	Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:43217 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab1F3Rsa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:48:30 -0400
In-Reply-To: <4E0C8D7F.3000902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-EyPdZF39mzvyqVrmA265
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Thu, 2011-06-30 at 16:51 +0200, Patrick McHardy wrote:
> On 30.06.2011 16:32, Stephen Clark wrote:
> > On 06/30/2011 11:15 AM, Eric Dumazet wrote:
> >> Le jeudi 30 juin 2011 =C3=A0 13:59 +0200, Patrick McHardy a =C3=A9crit=
 :
> >>
> >>  =20
> >>> Thanks Eric, I agree. Give us data and we'll fix it if really is a bu=
g.
...
> >=20
> > So if you receive a -1 the proper recovery is to call nfq_set_verdict()
> > again?
>=20
> Look at errno to see what's happening. But yes, this indicates the
> verdict wasn't issues successfully, so you need to retransmit.

As the verdict failure is bound to occur in a high load time,
retransmission of the verdict (which is necessary) will not help the
system to recover. Userspace has to deal with it but it has another
consequences which is that userspace software may suffer of case where
successive failures occurs.

In this scope, Florian's patch "netfilter: nfqueue: batch verdict
support" could be really useful. It could be used by userspace to
trigger an decide on all stucked packets. Issuing a massive ACCEPT could
lead to dynosaurus packet coming from ancient time but it could be ok if
batch occurs enough often.

Is there a plan to accept it in mainstream ?

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/

--=-EyPdZF39mzvyqVrmA265
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk4MrWAACgkQnxA7CdMWjzILUQCdF0sdTt6tkdgZ3MHIBYxZcqqW
WygAn1ZaX5F8GHWB0mtosPBncGKhRYwu
=DnuB
-----END PGP SIGNATURE-----

--=-EyPdZF39mzvyqVrmA265--

