From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: remarkably Increase iptables' speed on SMP system.
Date: Fri, 28 Sep 2007 15:29:29 +0200
Message-ID: <1190986169.16627.22.camel@henriknordstrom.net>
References: <00de01c80175$7402ef90$ca8510ac@asimco>
	 <46FCF121.8010807@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0ENzmNjqKRvv3uOk1ToK"
Cc: John Ye <johny@asimco.com.cn>, netfilter-devel@vger.kernel.org,
	YE QY <iceburgue@gmail.com>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from iggypop2.siwnet.net ([81.216.65.12]:55054 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbXI1Wu1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 18:50:27 -0400
In-Reply-To: <46FCF121.8010807@ufomechanic.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--=-0ENzmNjqKRvv3uOk1ToK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On fre, 2007-09-28 at 13:18 +0100, Amin Azez wrote:

> i.e. packets which take more processing may leave the bridge/router
> after a packet of the same flow which arrived later.

=46rom what I can tell the patch already deals with that by distributing
work based on source,destination if you want. (tunable, see bs_policy).

Regards
Henrik

--=-0ENzmNjqKRvv3uOk1ToK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARv0BtkNPQ5Kbx8daAQJGTgP/ZqISXgcR6eblDWtdomve6UkJNrCbYoPv
f16W5PHOf22NsVm88nYB4/NQsi98x27mkgoBY9XN7TjdVjR22p/GqjECYGPIbQW3
8RcHCUY+JyM7RCagex5hNQCB6VfOHZ3Sn1PSubUSGrmuRBNp6j25vGfetf15acqV
7nd7q1X7ay4=
=fBEa
-----END PGP SIGNATURE-----

--=-0ENzmNjqKRvv3uOk1ToK--

