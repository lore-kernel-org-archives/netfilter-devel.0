From: Harald Welte <laforge@netfilter.org>
Subject: Re: 2.6.12: connection tracking broken?
Date: Mon, 27 Jun 2005 10:32:19 +0200
Message-ID: <20050627083219.GZ19928@sunbeam.de.gnumonks.org>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
	<1119249575.3387.3.camel@localhost.localdomain>
	<42B6B373.20507@trash.net>
	<1119293193.3381.9.camel@localhost.localdomain>
	<42B74FC5.3070404@trash.net>
	<1119338382.3390.24.camel@localhost.localdomain>
	<42B82F35.3040909@trash.net>
	<20050622214920.GA13519@gondor.apana.org.au>
	<1119507800.3387.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yPlaimQd/TpiYx8R"
Cc: Bart De Schuymer <bdschuym@telenet.be>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	rankincj@yahoo.com, ebtables-devel@lists.sourceforge.net,
	netfilter-devel@manty.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <1119507800.3387.18.camel@localhost.localdomain>
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


--yPlaimQd/TpiYx8R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2005 at 06:23:20AM +0000, Bart De Schuymer wrote:
> Op do, 23-06-2005 te 07:49 +1000, schreef Herbert Xu:
> > Longer term though we should obsolete the ipt_physdev module.  The
> > rationale there is that this creates a precedence that we can't
> > possibly maintain in a consistent way.  For example, we don't have
> > a target that matches by hardware MAC address.  If you wanted to
> > do that, you'd hook into the arptables interface rather than deferring
> > iptables after the creation of the hardware header.
>=20
> Iptables also sees purely bridged packets and at least for these packets
> the physdev module is useful and harmless. I think removing physdev
> alltogether is a bit drastic.
>=20
> I wonder what flood of messages from angry users the removal of the
> physdev functionality for routed packets will stirr.

I have to agree with Bart.  I don't know any bridging-packetfilter setup
that doesn't use ipt_physdev in FORWARD :(

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yPlaimQd/TpiYx8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCv7mTXaXGVTD0i/8RAg0EAKCTW0QG12/GR10fDDOxvKztUN6xrgCcCht6
3rJMrMz7GlsShew+mQXMtgU=
=iQ8I
-----END PGP SIGNATURE-----

--yPlaimQd/TpiYx8R--
