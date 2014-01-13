From: Kevin Fenzi <kevin@scrye.com>
Subject: Re: nftables/libnftables packages for Fedora
Date: Sun, 12 Jan 2014 17:11:16 -0700
Message-ID: <20140112171116.46eaf896@voldemort.scrye.com>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
 <CAOkSjBhCTDCDzBLp86d1qA+xH=KMZtz2HrU3QfnZ+8AJ+qcWTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/r+PY+sr8+zkijODjC2nQ5Gn"; protocol="application/pgp-signature"
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from scrye.com ([75.148.32.185]:46370 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaAMALU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 19:11:20 -0500
In-Reply-To: <CAOkSjBhCTDCDzBLp86d1qA+xH=KMZtz2HrU3QfnZ+8AJ+qcWTg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/r+PY+sr8+zkijODjC2nQ5Gn
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

--Sig_/r+PY+sr8+zkijODjC2nQ5Gn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJS0y8lAAoJEEs3sNgP+7teyz0P/iHmipJnKE/4K2aO4JbSk71B
qGaObQ/BOKszD5eLCT2HZ9OhuyX4cpv5I+cpHdREqmroVOfojOVchKIc27CAqkm8
J+SAXP760UslDkgdOMJA9D4Wgh5oYIzFS1MTUcglnmTzjldb6fBvyxf0Cg6DVQVA
fWkaZoYQ6m3CXBuItJiFXq0pXcbDvOosFPV1JlCZqTy7nJnKl2ntqd2/5zd9t91x
fm3/yWUK4Kwt85cpfLKfupmBnPFw9Ctf4TPhdp58SHj2yMJcN8wMeQko+7a8i9Ya
cfPxdcjgojcjgLgh0T+8AX01Rwg1xoAFYYdmr1fYtI+ZTNmuDdy73cbWrYvm/PiZ
GPX5psTZP6PQ+shEGTTAfsIfD+3qIu80+Be19xb8yu6VVsGzF6N5MIVOP0f61lrB
IEN6krNiEpk9/VUpScnhblWG1VvRIRp10s+eQjw2zIIujDWKiyfIiWgku6KZCrnR
mpuZPP/wGSmOnIjlYjMomwwxySENVqNQEzBou/3YkTbzs+JMZlQ/2dW1APfFaC7i
9ttfZ4kEnnatsUWzpi/IUSW96u0Xf9BCm45drSAXQ2FUV5dcaTDDBcEK1FnJEzhE
jSrXp5G0xCyj1pDMCcl+NRlfTNCXaFiiYaAPzZ5kpLSwWuJsyC3QbGM5T9X0eSUq
Yze/+3ljA4ADztRxbjEP
=zQ1E
-----END PGP SIGNATURE-----

--Sig_/r+PY+sr8+zkijODjC2nQ5Gn--
