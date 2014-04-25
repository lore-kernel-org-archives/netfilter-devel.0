From: Kevin Fenzi <kevin@scrye.com>
Subject: Re: tests/test-script.sh missing from 1.0.1 tar.bz2?
Date: Fri, 25 Apr 2014 10:14:15 -0600
Message-ID: <20140425101415.7af65532@voldemort.scrye.com>
References: <20140424112343.20161e0f@voldemort.scrye.com>
	<20140425085505.GB4113@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/VCYiQWxkolSm0fD57nGOCb8"; protocol="application/pgp-signature"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:51066
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaDYQOR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:14:17 -0400
In-Reply-To: <20140425085505.GB4113@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/VCYiQWxkolSm0fD57nGOCb8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Apr 2014 10:55:05 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Thu, Apr 24, 2014 at 11:23:43AM -0600, Kevin Fenzi wrote:
> > Greetings.=20
> >=20
> > Looks like somewhere along the way the tests/test-script.sh didn't
> > get included in the
> > http://ftp.netfilter.org/pub/libnftnl/libnftnl-1.0.1.tar.bz2
> > release.
> >=20
> > Something in 'make dist' dropping it?
>=20
> Just pushed a patch to fix this, thanks.
>=20
> http://git.netfilter.org/libnftnl/commit/?id=3D4e92a484c00a8c2e18d4e2b8a1=
912ac1b86b4089

Oops. Also the tests/jsonfiles/ and tests/xmlfiles/ are missing as
well.=20

Sorry for not noticing those at the same time. ;(=20

kevin



--Sig_/VCYiQWxkolSm0fD57nGOCb8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJTWonXAAoJEEs3sNgP+7te1aYP/j6Qxw8LV8jLwOAM7jtpjIF4
dNBQHdNFUv3GFLN7jZi9xdePWbmwj1O+Qwx6gaq+n6j24wdOz1niJEKHiA0w8g7o
6PtNJ4iPiHUcEr5+2A7Ffn8gtmt62U4fHIcqYMiH2bE8aC3j48JIeHHhHAkfgSO9
ho+kV9Ygk+2ESpukgVkXEfazcQqYpryl3qw9YRqfmXjtQ2Oxu9TB696WFnHERyJv
5gl45GJ1OptbUyQcdvHd69K678UheYG0WwXnMrHC1Ks/Uv8rpJFWYjtE80Whfb5B
ZQXUnStfigv/qczFYYDLNreOK3zgjUzwFBfrwS/YATl5IrRcLxJD1Pnwzlq8vrmN
vF5PwN6bidY/rEuuhxXRvypUFeg8GHjYKoF7hFyZ8AY+zqF1j6aFD37ZsfnLI6Rr
6t395QS9jHj/T3CaS5cdw3V2qLJw8n31w7v5cfO29NUXK/9OumtJquRL1ZbfDq6I
tIpSmEpaWG0xYVNzTLU3Uw+9rxq9penE43LhztGF3G5tsc5QPauGes4S2Vpq4Kb/
MqvEyigg6TJjMq8Zqyy53eNtr0rUyBNq01VjDnM1H9nFX9qqSKU/PHl1CoCTdXOa
cpIOS6JGk08tRG/7LAP89Ed28g+CP1e2la25mZWsDGwt1yVY4J4EqOlt/ENAh7Bn
Lskg48559e6WKMNEMw9C
=FCHe
-----END PGP SIGNATURE-----

--Sig_/VCYiQWxkolSm0fD57nGOCb8--
