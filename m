From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: New patch-o-matic release needed
Date: Fri, 19 Dec 2003 23:43:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1071873827.24067.73.camel@tux.rsn.bth.se>
References: <20031219082612.GC2794@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vurS1peL08km2O+SXo6A"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031219082612.GC2794@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-vurS1peL08km2O+SXo6A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2003-12-19 at 09:26, Harald Welte wrote:
> Hi Martin!

Hi Harald

> Could you please prepare the 'old' patch-o-matic tree to be ready for a
> new release?  Lot's of people are still using 030912, which for example
> has lots of known bugs in the pptp code.
>=20
> The new release should apply to 2.4.18-2.4.23.

It does :)
At least according to my test-script but the script doesn't try to apply
patches in all possible combinations, it's better than nothing, it
catches most errors it seems.

.18 -> .23 is 6 kernelversions... not too bad.

The only thing is... submitted/89_ipv6_mld_netfilter.patch _must_ be
removed from the tree-to-be-released before making the release as this
patch only works with .22 and .23 and will give failures with earlier
kernels and it's not very important anyway.

possible to add this as a dependency in pom-ng ?

The tag is called pom_20031219

> Thanks a lot.
>=20
> btw: feel free to change patches in 'submitted' without any notification
> to me.   But please inform me if you have to touch anything else, so I
> can merge the changes to the respective pom-ng patchlets.

I've changed:

base/osf.patch (corrected an off-by-one linecount in the patch)

extra/tcp-window-tracking.patch.depend (ctstat conflicts)

extra/nfnetlink-ctnetlink-0.13.patch (add whitespace to make gcc happy)

> expect a mostly-compatible 'runme' later today.  The internal
> implementation in pom.pm is almost completed.

great.
I'll probably leave for a weeks christmas-vacation tomorrow, I'll give
it a spin when I get back if it looks usable :)

Merry Christmas to all people on this list.

--=20
/Martin

--=-vurS1peL08km2O+SXo6A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/438jWm2vlfa207ERAomxAJ9lz/mWHss2Irna/aXiXEPnshCaPwCgvNFX
HljKOUwaJJ/V2En88d9Wu/Q=
=jYDl
-----END PGP SIGNATURE-----

--=-vurS1peL08km2O+SXo6A--
