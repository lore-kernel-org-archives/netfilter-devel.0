From: Robby Workman <rw@rlworkman.net>
Subject: Re: [ANNOUNCE] conntrack-tools 0.9.11 released
Date: Tue, 24 Feb 2009 08:10:42 -0600
Message-ID: <20090224081042.0f37580e@liberty.rlwhome.lan>
References: <49A03C73.8010004@netfilter.org>
	<20090222233433.0dc8f396@liberty.rlwhome.lan>
	<alpine.LSU.2.00.0902230815570.20446@fbirervta.pbzchgretzou.qr>
	<49A26A3E.5020707@netfilter.org>
	<20090223093416.2c63fc02@liberty.rlwhome.lan>
	<49A3C3FE.2000403@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/C.eVs6lQz=iz_yxwNXrum5H"; protocol="application/pgp-signature"
Cc: Jan Engelhardt <jengelh@medozas.de>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <49A3C3FE.2000403@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/C.eVs6lQz=iz_yxwNXrum5H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Feb 2009 10:55:10 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Robby Workman wrote:
> >=20
> > Weird that it's not affecting Jan then, because it's definitely
> > something specific to newer glibc (or perhaps gcc, but it's not
> > immediately obvious how that would be the case). I'm on Slackware=20
> > rather than Gentoo, running quite a bit of prerelease development=20
> > builds (including gcc-4.3.3 and glibc-2.9 along with 2.6.28.7
> > kernel).
>=20
> I'm don't mind too much as long as the following patch (which is
> already in git to fix the gentoo's problem) fixes also yours:
>=20
> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=3Dconntrack-tools.git;a=3Dc=
ommitdiff;h=3D9bf002ff7935e7dff625683787fc3a06ac2ef2cb;hp=3D87c8c090e1b64ea=
c27edb968845cb1e8ee65b06b
>=20
> Please, confirm that the problem is resolved.


Yes, that's exactly what I did locally to fix it -- confirmed.

-RW

--Sig_/C.eVs6lQz=iz_yxwNXrum5H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmj/+MACgkQvGy9tf6lsvv/3wCgkdHw2SgOud+RKb7MuWr84AoZ
eRAAoKopdg16IEKYQq8+ZUhOERlSZb4m
=GlTE
-----END PGP SIGNATURE-----

--Sig_/C.eVs6lQz=iz_yxwNXrum5H--
