From: Kevin Fenzi <kevin@scrye.com>
Subject: Re: nftables/libnftables packages for Fedora
Date: Sun, 12 Jan 2014 17:05:49 -0700
Message-ID: <20140112170549.327dd807@voldemort.scrye.com>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
 <CAOkSjBhCTDCDzBLp86d1qA+xH=KMZtz2HrU3QfnZ+8AJ+qcWTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/qMD.Uz=kta0Vz8ggx.X1Zri"; protocol="application/pgp-signature"
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from scrye.com ([75.148.32.185]:46376 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbaAMALk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 19:11:40 -0500
In-Reply-To: <CAOkSjBhCTDCDzBLp86d1qA+xH=KMZtz2HrU3QfnZ+8AJ+qcWTg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/qMD.Uz=kta0Vz8ggx.X1Zri
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

[ re-sending as I forgot to cc the list ]=20

On Sun, 12 Jan 2014 22:16:35 +0100
Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:

...snip...
=20
> There is a patch from me to address this:
> http://patchwork.ozlabs.org/patch/304866/
> Feel free to test it and comment.
>=20
> I have the same issue in the Debian land. I applied the patch locally
> in the package as a workaround.
>=20
> The patch is not applied yet to upstream.

Cool.=20

That addresses the part of the issue where the interpreter isn't fully
specified, but still the question is if these are config files that
users are expected to modify or are noarch scripts provided by the
package that are expected to be read-only (ie, /etc vs /usr/share)?

> > 6. I recently enabled the xml stuff in libnftables and am seeing a
> > number of tests fail:
> >
> > parsing xmlfiles/55-rule-real.xml:  [31mFAILED [0m (Invalid
> > argument) and
> > parsing xmlfiles/74-set.xml:  [31mFAILED [0m (Invalid argument)
> > mxml: <!-- nft add rule filter output ct secmark 0 counter -->
> > cannot be a second root node after <nftables>
> >
>=20
> I can't see the libmxml version in the build log. Which version of
> libmxml are you using?
> Seem that your version of libmxml treats XML comments different than
> in my version (libmxml 2.6 from Debian).

2.7 here. ;) So, likely that changed between 2.6 and 2.7?

> Also I guess you are using an outdated snapshot of libnftables. Some
> important changes happened to the XML/JSON parsers.

Hum, thats the 2014-01-11 snapshot. Not very old.=20

> Anyway, thanks for the report, I'm going to review the XML parser.

Thank you.=20

> > Are these expected? The Invalid argument might be because it doesn't
> > have nftables available in the build kernel? But the json tests
> > work. :(
> >
>=20
> Not expected at all.
>=20
> These tests simply parse the XML/JSON input, they don't send anything
> to the kernel.

ok. Great=20
=20
> > Thanks. Again, if I should send this somewhere else instead, just
> > let me know. Comments welcome here, direct email and/or in the
> > above review bugs. ;)
>=20
>=20
> I think this is the right place.

Excellent. Thanks.=20

kevin

--Sig_/qMD.Uz=kta0Vz8ggx.X1Zri
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJS0y3eAAoJEEs3sNgP+7tegIUQALfKK54iBfjsi7wNaoOFh2DR
hnRvweufyQeNgxTvPpydco95/f3sC4cm53cmgbVWUi+24eLl1hbYYETEoxkx/PQF
vS6NLK/bg9CvO3MOWnSohynrrhKXwXmstC4KVl0t6WPlSG3z50NRfKAxYscJTHXK
3iCyir27N7chdDcM5drv8WN8B4bsVIhJH2mc21lKxiMKOR0DSBexnmfDgLFUuSYd
xAi2tVWFUYVe2PSvfZckmFl6y4ExTmCSuOR4AX4qyS8+NFiNp6yGG439lUTKM0ih
uyy2ovkuxlwVEIIkkETM6ckRC/SZcls6av12Ch0c8R5+AmkN7uApb+fZjzkIzniB
tKW+16l1oV82ce8jcjjCPfTrWfaJp+1oMYn6hIMzhEUNdJn1kHNOA1XuOneA3Tfn
7v12n0MIZVMwte77zBORzAKU5IPmXJJATgS2ZVRkuxhJU1rVVjlLkZf/EW2RXe0C
nK/gA4bjimMzWB62KwtO/rNWe0+eGpbpUXzeE2W+ahEVjpewgwF2DAL7nu28HGul
f+3fJM+xK70jHlwCPd9xunOF7rpFXt2qxzshlbdyzOgjqBWVQFArCvt48QympGnX
BucM/55UGdiggL5WRn6fHShRn7HqPFeN28bMjFo7rXzyU9eKOoGFGOoXC8ON5Bym
7JaozH+oW1Ccl+GDltiy
=WHzU
-----END PGP SIGNATURE-----

--Sig_/qMD.Uz=kta0Vz8ggx.X1Zri--
