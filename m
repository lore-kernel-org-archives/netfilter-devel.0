From: Eric Leblond <eric@inl.fr>
Subject: Re: libnetfilter_queue - remove packet from kernel buffer, and  
 reinject later
Date: Thu, 21 Jan 2010 08:08:42 +0100
Message-ID: <1264057722.4571.48.camel@ice-age>
References: <6c279bde1001191125u28fa13a4i4fd7973cf950cccc@mail.gmail.com>
	 <1263941697.4571.46.camel@ice-age>
	 <6c279bde1001201213h724a22cfvc9c8e51538156ec2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Lv2nzqfae60Dxx3Rnobc"
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Mistick Levi <gmistick@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41708 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab0AUHIx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jan 2010 02:08:53 -0500
In-Reply-To: <6c279bde1001201213h724a22cfvc9c8e51538156ec2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-Lv2nzqfae60Dxx3Rnobc
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello,

Le mercredi 20 janvier 2010 =E0 22:13 +0200, Mistick Levi a =E9crit :
> 2010/1/20 Eric Leblond <eric@inl.fr>:
> > Hello,
> >
> > Le mardi 19 janvier 2010 =E0 21:25 +0200, Mistick Levi a =E9crit :
> >> Hi,
> >> I've worked with libipq, and libnetfilter_queue, and i got to a place
> >> where my userspace code can't get anymore packets( with the message:
> >> netlink message: no buffer space available ) .
> >>
> >> Now what i want to do is this:
> >> Read a packet from the queue, copy it to my own queue/location in my
> >> program, and re injecting the packet later on with my verdict, after i
> >> finished.
> >
> > This is how it works ;)
> >
> > In fact, the 'no buffer space available' message is due to your program
> > not getting packets as fast as needed: The kernel is sending packet to =
a
> > netlink socket and the internal buffer of the socket gets filled with
> > the packets waiting to be read.
> >
> > What you need to do is:
> >      * read packet as fast as you can (your callback function has to be
> >        fast)
> >      * do the intensive or delay needing work outside of the callback
> >        (via a thread or something)
>=20
> What do you mean by doing the delay needing work outside of the
> callback? in the end of the callback i should give a verdict, no ?

No, this is not necessary. The verdict can be called from anywhere else
in your program.

BR,


--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-Lv2nzqfae60Dxx3Rnobc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD4DBQBLV/12nxA7CdMWjzIRAo6kAJwIsfquAolo2L97dhW3ba3lwuaAfwCY/Lbq
JDPo8EACF3BDFNIjKRYq3g==
=RUR2
-----END PGP SIGNATURE-----

--=-Lv2nzqfae60Dxx3Rnobc--

