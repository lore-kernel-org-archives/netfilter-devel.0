From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [RFC] matching tproxied packets
Date: Thu, 6 Jun 2002 07:40:11 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020606074011.E28940@sunbeam.de.gnumonks.org>
References: <20020604145036.GA1295@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="10jrOL3x2xqLmOsH"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20020604145036.GA1295@balabit.hu>; from bazsi@balabit.hu on Tue, Jun 04, 2002 at 04:50:36PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--10jrOL3x2xqLmOsH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2002 at 04:50:36PM +0200, Balazs Scheidler wrote:
> Hi,
>=20
> Suppose you have a TCP session, which is transparently redirected to a lo=
cal
> proxy. With the current state of the tproxy framework one need to add two
> rules to iptables:
>=20
> - one to the tproxy table to actually redirect a session
> - one to the filter table to let the NATed traffic enter the local stack =
(in
>   INPUT)
>=20
> I'd like to make tproxies easier to administer, so I'm thinking about a
> simple way of matching tproxied packets, which can be ACCEPTed from the
> INPUT chain.
>=20
> Possible solutions:
>=20
> * use a new state (called TPROXY), which would be applied to all TPROXYed
>   packets (might interact badly with nat/conntrack).

yes, and it is not really a state.

> * have the tproxy framework mark all packets with an fwmark, and let the
>   packets in based on the value of fwmark

fwmark should only be used as configured by the administrator.=20

> * have a separate match (called tproxy), which matches tproxied sessions
>   based on some value stored in the associated conntrack entry

this is the preferred solution from my point of view.

> Bazsi

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--10jrOL3x2xqLmOsH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE8/vW6XaXGVTD0i/8RAtCNAJ9nQ2aAu9vYx3YDX2VXjlUzH/Bi/QCgrxDY
fDAAwWPq+M95z13W5DDO+h8=
=Y8U1
-----END PGP SIGNATURE-----

--10jrOL3x2xqLmOsH--
