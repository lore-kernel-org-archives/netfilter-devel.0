From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [RFC PATCH IPTABLES 0/12]: matches/targets unification
Date: Wed, 06 Dec 2006 21:49:24 +0100
Message-ID: <1165438164.4846.3.camel@localhost.localdomain>
References: <200611300943.kAU9hhUn013373@toshiba.co.jp>
	<45769AB6.8090403@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-e3JeX+6cwyKumf+Mq79R"
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45769AB6.8090403@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-e3JeX+6cwyKumf+Mq79R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-12-06 at 11:25 +0100, Patrick McHardy wrote:

> We currently have lots of extensions in iptables for non-mainline
> matches and targets, some obsolete, some already decided against
> merging and some that might be merged in the future. For the
> extensions belonging to a feature that won't be merged, the same
> argument applies as to POM, they increase the maintenance burden
> and should really be maintained along with the kernel patch (and
> pom already supports patching iptables).
>=20
> More problematic are extensions for stuff that might get merged.
> In many cases so far they were included by distributors if
> compiled by default, but when merging a feature we often noticed
> that the ABI had problems like 32/64 bit issues and needed to be
> changed before merging, which effectively broke compatibility.
> I think it would be preferable to have people wait until their
> distribution releases a new version to use a new feature than
> have strange and unexplained errors.
>=20
> So, what I'm proposing is to remove all extensions that are
> neither part of 2.4 or 2.6 from iptables, pushing those for
> externally maintained patches to the patch maintainers, those
> for patches maintained in pom to pom, and delete the rest.
>=20
> Comments?

Yes I think this is what we should do. Iirc this was loosely discussed
during a workshop, it's time to actually do it now. Go for it!

--=20
/Martin

--=-e3JeX+6cwyKumf+Mq79R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFdyzUWm2vlfa207ERAlZgAJ9z0sAN8Th6pFHTmIrQbbI2cFYZwwCfe/sM
LFy7MyCMT7lpp8E39vOFfic=
=c/ER
-----END PGP SIGNATURE-----

--=-e3JeX+6cwyKumf+Mq79R--
