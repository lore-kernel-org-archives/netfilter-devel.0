From: Harald Welte <laforge@netfilter.org>
Subject: Re: Problem with connection tracking ESP using SPI
Date: Thu, 29 Jan 2004 12:16:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040129111657.GB11761@sunbeam.de.gnumonks.org>
References: <OF6DBB9E97.4BB21383-ON88256E29.00667A58@tais.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2RPSo2VWgDbGU+zh"
Cc: glenn@swonk.com,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Glenn.Swonk@tais.com
Content-Disposition: inline
In-Reply-To: <OF6DBB9E97.4BB21383-ON88256E29.00667A58@tais.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2RPSo2VWgDbGU+zh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2004 at 10:46:47AM -0800, Glenn.Swonk@tais.com wrote:
> Dear Harald,
>=20
> I read your document on "Linux 2.4.x netfilter/iptables firewalling
> internals" and had a couple of questions.
>=20
> I am trying to create a netfilter module for IPSec connection tracking fr=
om
> the LAN side to a destination host.

Please write to the netfilter-devel mailinglist, as it is meant for
development related questions.

> Multiple clients on the LAN side cannot connect to the destination
> host successfully since the packets on the way back cannot be
> successfully routed back to the requesting client (nothing to track
> with).
>=20
> I have in the past used the SPI to track connections but cannot seem to
> include this in a netfilter module.

You would first have to write something like ip_conntrack_proto_esp.c,
which would include the SPI (as port numbers are tracked with TCP).=20
It's not as easy as TCP, since the SPI is different for each direction,
and every packet only contains the SPI for one direction.=20

However, this is again similar of what I had to do for
ip_conntrack_proto_gre.c (see the patch-o-matic PPTP patch), where
ip_conntrack_pptp.c tells ip_conntrack_proto_gre.c which two CallID's
belong to a single connection.

> Any suggestions?

Maybe you could pos your current code so we could see where the problem
might be?

> thanks,
> glenn
>=20
> Glenn Swonk

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2RPSo2VWgDbGU+zh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAGOupXaXGVTD0i/8RAtsZAKCxXl6qTEioD134D8X8SuPRxdvQtgCfdtfI
v1QegfrPQHo9/M7vyC9G2l0=
=uSLT
-----END PGP SIGNATURE-----

--2RPSo2VWgDbGU+zh--
