From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT66 : A first implementation
Date: Thu, 21 Jul 2011 09:15:58 +0200
Message-ID: <20110721071558.GE30758@prithivi.gnumonks.org>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr>
 <4E1F1902.9020605@student.ulg.ac.be>
 <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr>
 <20110714.161717.1387261665409519132.davem@davemloft.net>
 <4E245656.8020605@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Cc: David Miller <davem@davemloft.net>, jengelh@medozas.de,
	T.Moes@student.ulg.ac.be, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:33773 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1GUHSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:18:06 -0400
Content-Disposition: inline
In-Reply-To: <4E245656.8020605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

just a few words out of the strange land that retired netfilter hackers
go to:

1) I am quite at ease not participating in netfilter/iptables anymore
   while the discussion about IPv6 NAT becomes an issue again:  I always
   indicated "over my dead body", and now that I am no longer in charge,
   nobody will have to kill me ;)

2) I agree that there has been a lot of improvement between the
   abomination of what we are doing in IPv4 NAT and what is
   described in RFC6296.

3) For any netfilter integration, I would strongly suggest something
   that does not carry aroudn with it the burden of connection tracking,
   but rather something stateless.  Or at least have the conntrack
   dependency optional.  If there's no need for sophisticated state
   tracking as per the RFC, then don't make it a hard/mandatory
   dependency.

=2E.. and now I'll happily retire again to GSM land ...

Regards,
	Harald
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOJ9IuXaXGVTD0i/8RAjXlAJ9n65YoxHnfAO2X2huCP/RCoWBxZwCeOVux
uZjL8XNuT9mX9Inl455X7U8=
=J3h7
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
