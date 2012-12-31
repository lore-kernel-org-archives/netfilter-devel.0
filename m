From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] extensions: fix linking against -lip6tc
Date: Sun, 30 Dec 2012 19:51:46 -0500
Message-ID: <201212301951.47241.vapier@gentoo.org>
References: <1356909107-9924-1-git-send-email-vapier@gentoo.org> <20121230233828.GA30455@1984>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12810659.XYZN5DhhX7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:33085 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab2LaAu1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2012 19:50:27 -0500
In-Reply-To: <20121230233828.GA30455@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--nextPart12810659.XYZN5DhhX7
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sunday 30 December 2012 18:38:28 Pablo Neira Ayuso wrote:
> Hi Mike,
>=20
> On Sun, Dec 30, 2012 at 06:11:47PM -0500, Mike Frysinger wrote:
> > The current build forgets to specify a path to find libip6tc which means
> > it either fails (if there is no libip6tc in the system), or links again=
st
> > an old version (if there is one in the system).
>=20
> We already got a similar patch fix for that issue:
>=20
> http://patchwork.ozlabs.org/patch/208133/
>=20
> Can you give it a try and check if it also fixes the problem for you?

adding an -L path to the non-.libs/ subdir doesn't make sense when the=20
existing code (the -lxtables stuff) only uses .libs/.

really the best thing would to stop grubbing around in libtool internals an=
d=20
use libtool to link considering it was used to generate the other libraries=
 in=20
the first place.
=2Dmike

--nextPart12810659.XYZN5DhhX7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQ4OGjAAoJEEFjO5/oN/WBh+EQAJ8LmMnbRUSdgwLefcgr0xu2
DvB7pFM9VTZQcmfEJu9zCstz+wg/WnfbV6cgPTuXPBIuiKAJPBdbNuRWB3wQcxTR
GVtMbdAX/MZPHlPb0i53/sW4gVt5ZUvs6mPnMCrENElYCjAJjjzGaFiSxMzoCEEW
OCJIWtDteTTVKDwDmbwJxHI3Oru4CYykWush1MKKWHymgftrNzK1IEXnmbVR38s7
80oHMFJUhO0GuN/bQNcXyou9ow8Qvq97LzXjvrzoSXc1RUq2ozI1YDqstfL4tQj2
yrcCgJWldIWn42bjwX7CUyPjaemp1kUvRxUgx04ZNlGs6RWR7U/EoUvDKKF07tGE
3CaKugDmYEj6FxU0hoVztLLDF7JEHoamhy1hNIyXYoSqHqughwS4gkZ4pBbB8U0p
cBLYnHH20fJt5I39bf3vyMs7jmtYBczkcZTjpqhYTp8+h6nprBugTq3mLnxttNza
F8tkHrKYCPpZaOSVN2zOyX4C702B5I1PvcaxsUxK+Ud+bu8iDQaPjomqe5QPCOAb
hGFJkze/Y4iBes/+ir3vyN3IliIrH7WHV9oh0kHMUJsfr1rf3/MYTCtTMUi2q/kl
p4iU6tg+E2Xct09693O17NeYAXLjrkeuqBE6+mRcCqDdD0FcEBeeO6Ag2kkGYCmC
AIJKriviL8kNlx+o/Knm
=5OxQ
-----END PGP SIGNATURE-----

--nextPart12810659.XYZN5DhhX7--
