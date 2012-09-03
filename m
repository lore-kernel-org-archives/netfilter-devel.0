From: Eric Leblond <eric@regit.org>
Subject: Re: [RFC ulogd patch 0/1] Implement conntrack event filter in NFCT
 input
Date: Mon, 03 Sep 2012 09:36:50 +0200
Message-ID: <1346657810.5194.44.camel@tiger.regit.org>
References: <1343856809-11585-1-git-send-email-eric@regit.org>
	 <20120802112344.GB25007@1984>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eIqzWUdjL1iPILPMbBE3"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:44076 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2ICHiN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Sep 2012 03:38:13 -0400
In-Reply-To: <20120802112344.GB25007@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-eIqzWUdjL1iPILPMbBE3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Sorry for being late to reply here.

Le jeudi 02 ao=C3=BBt 2012 =C3=A0 13:23 +0200, Pablo Neira Ayuso a =C3=A9cr=
it :
> On Wed, Aug 01, 2012 at 11:33:28PM +0200, Eric Leblond wrote:
> >=20
> > Hello,
...
> Note that ulogd2 initially dumps the entire table. The filtering will
> not apply to dumping, only to events.

Why is this needed ? This gave us more accurate stats about existing
connection by filling the hash at start ?

>=20
> You need to filter filter dumps.
>=20
> conntrackd already has a framework for user-space filtering, that is
> used for filter. You can grab it. We can probably later move it to
> libnetfilter_conntrack to avoid code redundancy.

I've looked at this part of the code but the implementation seems to
need a lot of conntrackd things like vector. This seems a bit too big to
include inside ulogd.

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/

--=-eIqzWUdjL1iPILPMbBE3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBEXhIACgkQnxA7CdMWjzK70ACeOpnYokMx2YS9NtBfg/d5r7bq
vwUAoIdOwQoE8LBhOjCCBohdSepKaaB8
=VyCp
-----END PGP SIGNATURE-----

--=-eIqzWUdjL1iPILPMbBE3--

