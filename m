From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] info file for ROUTE target
Date: Thu, 16 Dec 2004 13:25:49 +0100
Message-ID: <20041216122549.GD10165@sunbeam.de.gnumonks.org>
References: <1102603380.7528.98.camel@descartes.info.ucl.ac.be>
	<20041209195706.GA4121@oknodo.bof.de>
	<20041209212420.GD591@ti64.telemetry-investments.com>
	<1102667864.11255.2.camel@descartes.info.ucl.ac.be>
	<20041210084350.GB4121@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Cc: "netfilter-devel@lists.netfilter.org"
	<netfilter-devel@lists.netfilter.org>,
	Cedric de Launois <delaunois@info.ucl.ac.be>,
	"Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20041210084350.GB4121@oknodo.bof.de>
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


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 10, 2004 at 09:43:50AM +0100, Patrick Schaaf wrote:
> > > Presumably ip6t_ROUTE.c requires an out-of-line version of ndisc_get_=
neigh()
> > > to be exported.
> >=20
> > Agree.
>=20
> I'm curious - why aren't such functions EXPORT_SYMBOL_GPLled?
> Same question applies to the out-of-line ip_finish_output2 in ROUTE.
> Methinks that would be much nicer. Is this a policy, or is it just
> a communication problem?

well you could make the ROUTE patch export those symbols.  However,
we're not going to export symbols of the core network stack for some
iptables target that only exists in patch-o-matic.

> best regards
>   Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBwX7NXaXGVTD0i/8RAt5GAJ9vxrEpHT21VGoL+KLIiHnZRc/d3ACfQkxY
t71zyTgmtCip9VdFJREapK8=
=SRU9
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--
