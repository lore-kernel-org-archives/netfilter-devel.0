From: Harald Welte <laforge@netfilter.org>
Subject: Re: [POM PATCHES] IPv6 ports of time and quota matches
Date: Tue, 6 Jan 2004 19:54:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040106185440.GA934@obroa-skai.de.gnumonks.org>
References: <000501c3c96c$c1f02e60$0e25fe0a@southpark.ae.poznan.pl> <20040105121244.GB16171@sch.bme.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Cc: Maciej So?tysiak <maciej.soltysiak@ae.poznan.pl>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andras Kis-Szabo <kisza@securityaudit.hu>
Content-Disposition: inline
In-Reply-To: <20040105121244.GB16171@sch.bme.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2004 at 01:12:44PM +0100, Andras Kis-Szabo wrote:
> Maciej So??tysiak .......................................................=
=2E.................... (2003. december 23.)
>=20
> Hi,
>=20
> > I noticed I have two patchsets left behind, never included in patch-o-m=
atic
> > These are IPv6 ports of the time and quota matches.
> Please, be careful w/ the 'plain ports'.
> Rusty has changed the internal structure of the IPv4 parts (acording the =
skb
> linearization) - and these changes are missing from the IPv6 part. In IPv6
> every packets are linearized - in IPv4 you have to linearize the required
> parts avery time and in some higher-level protocols tha helper functions =
have
> benn changed.

yes, for consistency reasons we should forward-port those changes from
ipv4 to ipv6.  any volunteers?

> Regards,
> 	kisza=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/+wRwXaXGVTD0i/8RAg1GAJ0RXGZeNj2UZ4xsiQ/eHIQH1hVVygCdGHmM
zch0qz0AnHl6ossI1cj6dcQ=
=9EjZ
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
