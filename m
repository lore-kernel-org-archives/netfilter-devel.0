From: Harald Welte <laforge@netfilter.org>
Subject: Re: local NAT
Date: Wed, 11 Jun 2003 16:58:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030611145856.GT32593@sunbeam.de.gnumonks.org>
References: <20030607215013.4F9B8444E8@service.i-think-future.de> <20030611120649.GK32593@sunbeam.de.gnumonks.org> <20030611140313.GB8055@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bZ2MuwyI/0uB8yuJ"
Cc: Nils Radtke <Nils.Radtke@Think-Future.de>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20030611140313.GB8055@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--bZ2MuwyI/0uB8yuJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2003 at 04:03:13PM +0200, Balazs Scheidler wrote:
> On Wed, Jun 11, 2003 at 02:06:49PM +0200, Harald Welte wrote:
> > On Sat, Jun 07, 2003 at 11:50:04PM +0200, Nils Radtke wrote:
> > >   Question:
> > >   Is there code around implementing the feature of SNATting incoming
> > >   packets for local processes?
> >=20
> > not that I am aware of.  And I can still not imagine a setup where this
> > would make any sense.  Please enlighten me.
>=20
> a security proxy analyzing HTTP requests before the real webserver gets i=
ts
> hand on it. if you want the webserver to get the original client as the
> source of the connection you need something like this.

Oh, well.  Either you or me misunderstood the feature Nils was
requesting.  You seem to be talking about SNAT'ing outgoing packets sent
by local processes.  I was talking about SNAT'ing incoming packets
received for a socket of a local process.

Nils: which one are you interested in?

> Bazsi

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--bZ2MuwyI/0uB8yuJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+50OwXaXGVTD0i/8RAjypAJ4k2k16IHfVLqPuRp2cZrLg8SwApQCggGXA
8FEZOMIQSNWcO7a5f0dNAXg=
=0dN9
-----END PGP SIGNATURE-----

--bZ2MuwyI/0uB8yuJ--
