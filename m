From: Harald Welte <laforge@netfilter.org>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Sun, 3 Jul 2005 14:36:50 +0200
Message-ID: <20050703123650.GW3186@sunbeam.de.gnumonks.org>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
	<20050629160923.GF3331@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gAsw9DVneI/FTEJd"
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: rv@eychenne.org
Content-Disposition: inline
In-Reply-To: <20050629160923.GF3331@eychenne.org>
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


--gAsw9DVneI/FTEJd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 29, 2005 at 06:09:23PM +0200, Herve Eychenne wrote:
> On Wed, Jun 29, 2005 at 05:40:49PM +0200, Patrick Schaaf wrote:
>=20
> > > My question is, if anyone sees any problems with this, regarding perf=
ormance
> > > degradation on 32bit boxes or with caching problems?
>=20
> > The problem is compatibility with older versions of the LOG target,
> > both Userlevel (iptables .so module), and Kernel.
>=20
> > You can either make this a new target, or look how the versioning
> > infrastructure discussed here some months ago, worked out. (I don't
> > know; maybe there's already a HOWTO, or you want to write one :)
>=20
> I remember saying here that it would be cool to have the log prefix length
> tunable at kernel LOG module insertion, have it exported (read-only) to s=
ome
> /proc entry, and have userspace (iptables, or any other upper-level
> application) rely on the real-time extracted value.

I really don't think that this is worth the complexity... I also don't
really like using out-of-band interfaces such as /proc to determine how
to communicate rules via {get,set}sockopt()

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gAsw9DVneI/FTEJd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCx9viXaXGVTD0i/8RApdFAJ4oHT0ppFK3Fs+5xyedqzyP0xzdhACcCZrz
aeGy/tFdXBwD0IDPxGQO9XA=
=FDn4
-----END PGP SIGNATURE-----

--gAsw9DVneI/FTEJd--
