From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 5/5] nfacct: add timestamp option
Date: Fri, 03 Aug 2012 11:43:58 +0200
Message-ID: <1343987038.3284.6.camel@tiger.regit.org>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
	 <1343856436-11129-6-git-send-email-eric@regit.org>
	 <20120803093533.GE12107@1984>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NeUKMZ3TKGNfWMoohgSN"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:60020 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2HCJpB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:45:01 -0400
In-Reply-To: <20120803093533.GE12107@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-NeUKMZ3TKGNfWMoohgSN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Le vendredi 03 ao=C3=BBt 2012 =C3=A0 11:35 +0200, Pablo Neira Ayuso a =C3=
=A9crit :
> On Wed, Aug 01, 2012 at 11:27:16PM +0200, Eric Leblond wrote:
> > This patch adds a timestamp option to the nfacct plugin.
> > If activated, nfacct output a timestamp which is computed just
> > after sending the nfacct request.
>=20
> I think it makes sense to make it unconditionally.
>=20
> The dump of the counters without the time doesn't make too much sense
> to me?
>=20
> Let me know.

I think it was not originally added because some output format did not
need it. Maybe we can make output of a timestamp by default and let
people who want to spare the cycles of gettimeofday() set it to 0.

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/

--=-NeUKMZ3TKGNfWMoohgSN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAbnV4ACgkQnxA7CdMWjzJieQCbBheJdodQzqwibqsawAYLKXBB
IkEAnRpySTG5isd8KKhMdbALKJsqrEDj
=/kcj
-----END PGP SIGNATURE-----

--=-NeUKMZ3TKGNfWMoohgSN--

