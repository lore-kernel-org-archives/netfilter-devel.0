From: Eric Leblond <eric@inl.fr>
Subject: Re: NFLOG - missing packets?
Date: Sun, 11 May 2008 18:18:37 +0200
Message-ID: <20080511161837.GJ11778@ice-age>
References: <200805101657.45111.anton.vazir@gmail.com> <200805101750.38472.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N8ia4yKhAKKETby7"
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:44004 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbYEKQSl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 May 2008 12:18:41 -0400
Content-Disposition: inline
In-Reply-To: <200805101750.38472.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--N8ia4yKhAKKETby7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Saturday, 2008 May 10 at 17:50:37 +0500, Anton wrote:
> Something wrong quite definitelly,
> in 700Mb of the data it logs only 43Mb=20

I've done some test on my system and I've got similar results. Sole
difference is the ratio between logged packets and unlogged packets.=20

I've downloaded a 48Mo at a rate of 348.28K/s and I have the following
result :
Iptables : 33625 packets, 50383786 bits
Ulogd2 : 33272 packets 49856076 bits

As usual, size does not matter. The problem is due to some packets not
being loggued. It recall me results of Pablo's conntrackd benchmark.
After a given rate, the netlink subsystem is not able to transmit
messages.

IMHO, the main issue is that the lost (or the overrun) does not seem to be =
logged
somewhere.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--N8ia4yKhAKKETby7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIJxxdnxA7CdMWjzIRAjmhAKCBAxMsJyZ8wxMzDRfTGN1hoX4sIQCfTo9n
CUpKBZ6VS8aiy4SVYOFKTVQ=
=43i2
-----END PGP SIGNATURE-----

--N8ia4yKhAKKETby7--
