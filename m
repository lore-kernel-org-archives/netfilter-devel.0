From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ADMIN] patch-o-matic cleanup
Date: Thu, 29 Sep 2005 20:18:54 +0200
Message-ID: <20050929181853.GW4168@sunbeam.de.gnumonks.org>
References: <20050919151533.GF12075@rama.de.gnumonks.org>
	<Pine.LNX.4.62.0509291445460.20138@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MET8MpPxp2u2c48q"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0509291445460.20138@bizon.gios.gov.pl>
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


--MET8MpPxp2u2c48q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 29, 2005 at 03:09:51PM +0200, Krzysztof Oledzki wrote:
>=20
>=20
> On Mon, 19 Sep 2005, Harald Welte wrote:
>=20
> >Hi!
> Hi!
>=20
> >Following up to the bad experience over the last couple of months,
> >Patrick and me decided that we'd get rid of a lot of code in
> >patch-o-matic.
> >None of the developers seems to have any time left to put into backwards
> >compatibility, and the idea of explicit "patch o matic maintainers" that
> >we tried some two years ago also didn't work out.
> >Therefore, the current best practise seems to be:
> >1) get rid of any code in patch-o-matic that has already included in
> >  mainline (I've already remove tons of directories today)
> >2) stop supporting anything than the most current version of a patchlet.
> >Sorry, but it really wasn't of any use to provide outdated unmaintained
> >and unfixed old versions of the code.
>=20
> What is the current status of nf_conntrack? It is not in mainline, it is =
no longer in pom-ng,=20
> either. Where to find it?
=09
It's in my netfilter-2.6.14 git tree, "nf_conntrack" local branch:

rsync://people.netfilter.org/users/laforge/scm/netfilter-2.6.14.git#nf_conn=
track

you can just do a "git clone" with that url (need to escape the '#',
though).
=09
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MET8MpPxp2u2c48q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDPDANXaXGVTD0i/8RAoteAJ9hnkzYjafEYevif+LTI9wjuP/gOQCgn0ea
oR4k4TI+t5pae4fLZlSSJkY=
=s5/A
-----END PGP SIGNATURE-----

--MET8MpPxp2u2c48q--
