From: netfilter@interlinx.bc.ca
Subject: Re: disturbing MTU experiment
Date: Tue, 8 Apr 2003 16:46:58 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030408204658.GD24451@pc.ilinx>
References: <20030408154101.13919.89741.Mailman@kashyyyk> <16018.64600.149601.372694@isis.cs3-inc.com> <20030408174753.GA8158@pc.ilinx> <20030408184051.GB14357@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030408184051.GB14357@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 08, 2003 at 08:40:51PM +0200, Patrick Schaaf wrote:
>=20
> They are increasingly common.

Of course, this is the corect answer.  I was thinking about the link
at the other end, but of course, that is irrelevant.

> PPPoE DSL links run at 1496,

Right.

> and all kinds
> of tunneling results in even smaller MTU, e.g. 1454 for maximally
> conservative L2TP links.

Right.

> http://mss.phildev.net/

That's the one I was thinking of!

> http://lartc.org/howto/lartc.cookbook.mtu-mss.html

And this is a very workable (even though it's a band-aid to fix other
people's brokenness) solution.

b.

--=20
Brian J. Murrell

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+kzVCl3EQlGLyuXARAne0AKCFjLqg7GO5IdKF7IU570SgNjTZAgCffonC
8L1pv/Rf/ilNTBypUH9E3ps=
=Jciq
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
