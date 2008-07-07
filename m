From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: New Version of IPtables (iptables-tng) Ver2.0
Date: Mon, 07 Jul 2008 10:47:06 +0200
Message-ID: <1215420426.16930.46.camel@henriknordstrom.net>
References: <464293e60807062032q6c7fd622h6e364eae33018dc1@mail.gmail.com>
	 <alpine.LNX.1.10.0807071002180.28765@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uqMuq5JBKg3HuCzxgXDo"
Cc: hamid jafarian <hamid.jafarian@gmail.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:45920 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYGGIrN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 04:47:13 -0400
In-Reply-To: <alpine.LNX.1.10.0807071002180.28765@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-uqMuq5JBKg3HuCzxgXDo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On m=C3=A5n, 2008-07-07 at 10:06 +0200, Jan Engelhardt wrote:
> On Monday 2008-07-07 05:32, hamid jafarian wrote:
> >
> >To see Ver1.0 Features and throughput tests: http://iptablestng.sourcefo=
rge.net/
>=20
>=20
> "Adding 10000 rules" taking 5 minutes 11 seconds.
> That's a hilarious joke still, because you should not be using iptables=20
> for that; at least not now.
>=20
> # time iptables-restore 10000.rules
>=20
> real    0m0.120s
> user    0m0.079s
> sys     0m0.039s

I'd say there is something wrong in the time measurements presented on
the web site

real (total) time: 5m11.622s
user space time: 0m12.242s=20
kernel space time: 0m17.609s

12s user + 17s kernel is nowhere near 5m real time..

A more interesting test is to show the iptables time for single rule
modifications as a function of the ruleset size.

Comparing iptables-restore batches isn't that interesting as a
performance point, other than when testing libiptc for stupidities..

Regards
Henrik

--=-uqMuq5JBKg3HuCzxgXDo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUASHHYB0NPQ5Kbx8daAQKTzAQArVcQ0TEwM2Y2IfUW2psVEpPLGB3CHOpW
vAjG2gsRbs6a/OjFSQGg+MRUn1kmO/Cnu1tVOTdbVJFLYOidQE4snRzds6mNHDEV
NB8XC63ClwKnE4PtulO8uDInkirfzKZehBdLVmmk/mN9jqxPMdxiXIOPK1J2NGmJ
78oExOfzL0E=
=+lEK
-----END PGP SIGNATURE-----

--=-uqMuq5JBKg3HuCzxgXDo--

