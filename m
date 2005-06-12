From: Harald Welte <laforge@netfilter.org>
Subject: Re: [Patch] ip{,
	6}tables-restore -n with existing user defined chain
Date: Sun, 12 Jun 2005 11:56:55 +0200
Message-ID: <20050612095655.GB19830@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
	<42AB0D81.2080804@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42AB0D81.2080804@trash.net>
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


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 11, 2005 at 06:12:49PM +0200, Patrick McHardy wrote:
> Charlie Brady wrote:
> >=20
> > I want to redefine an existing chain atomically. I can't do that with
> > the iptables command, but can almost do it with iptables-restore -n.
> > When I try, iptables barfs because the chain already exists. Duh! Yeah,
> > I know it exists, but I want to redefine it.
> >=20
> > I don't see the semantics of this case defined anywhere, and I can't
> > find discussion of it in the archives. So I suggest that the semantics
> > be redefined, so that iptables-restore -n can redefine an existing chain
> > (iptables-restore without -n already does that). I really can't think
> > why anyone would depend on the current semantics.
>=20
> I have no objections, but since I'm not too familiar with that code
> I would like to hear Harald's opinion before applying it.

It seems fine to me, but we alwasy need to be cautious with silently
changing semantics that people might rely on... =20

but please apply...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCrAbnXaXGVTD0i/8RAmT0AJ9JuOPyj5CJSiFVvVUuVqRkoQNkegCcDsIu
EzQw2RKuOhqMDGWafvHIGLw=
=rxsY
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
