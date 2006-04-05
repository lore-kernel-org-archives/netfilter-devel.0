From: Harald Welte <laforge@netfilter.org>
Subject: Re: Trivial connlimit and IPMARK patch for 2.6.16
Date: Wed, 5 Apr 2006 17:26:28 +0200
Message-ID: <20060405152628.GI20558@sunbeam.de.gnumonks.org>
References: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/aVve/J9H4Wl5yVO"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>
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


--/aVve/J9H4Wl5yVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2006 at 12:09:52AM +0200, Grzegorz Janoszka wrote:
>=20
> Hello,
>=20
> Due to move of some targets from iptables to xtables, some patches turned=
 to "not applyable", becouse=20
> their Makefile.ladd files
> tried to add iptables entries just after a target, that had been moved fr=
om iptables to xtables.
>=20
> Attached patch solves this problem, it only modifies Makefile.ladd files =
of connlimit and IPMARK. The=20
> patch is to patch-o-matic-ng-20060401 but it should apply clearly on any =
latest pom-ng.

I'm not really in the mood of manually adding such patches to svn.

I'm not really sure on the future of patch-o-matic as a whole.  At least
I haven't really used any of the patches from there or updated anything
or tested whether it applies for at least half a year.

So unless somebody actually wants to become patch-o-matic maintainer
(yes, we once had somebody for that job), I think it's going to die.

Patrick, any news on that 'patch o matic remote repositories' idea?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/aVve/J9H4Wl5yVO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEM+GkXaXGVTD0i/8RAkscAJ9lV3nZUOTG0iLD7kVvLs1odfCu2gCgjtlv
98jXu/hcqO6PHbyO8SWExc0=
=AN86
-----END PGP SIGNATURE-----

--/aVve/J9H4Wl5yVO--
