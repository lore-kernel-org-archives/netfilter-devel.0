From: Harald Welte <laforge@netfilter.org>
Subject: Re: netfilter as ACL for SOCK_RAW, binding, netadmin
Date: Thu, 18 Dec 2003 21:53:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031218205338.GE18433@sunbeam.de.gnumonks.org>
References: <20031218030059.GA15627@red-sonja.frakir.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ca0e2zgpnh8/XhnM"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Mordechai T. Abzug" <morty@frakir.org>
Content-Disposition: inline
In-Reply-To: <20031218030059.GA15627@red-sonja.frakir.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Ca0e2zgpnh8/XhnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2003 at 10:00:59PM -0500, Mordechai T. Abzug wrote:
> Suggestion: it would make a lot of sense if there were a netfilter
> hook that allowed the existing flexible netfilter/iptables policy
> mechanisms to make these decisions. =20
>=20
> For example, the following sort of command might allow httpd to be run
> without root:
>=20
> iptables -t ACL -A BIND -m owner --uid-owner www -p tcp --sport 80 -j ACC=
EPT
>=20
> And something like this might give all users the ability to run ping
> without SUID:
>=20
> iptable -t ACL -A SOCK_RAW -m owner --exec-owner /bin/ping -j ACCEPT
>=20
> It would be great for Linux security to be able to remove SUID and
> SGID from a bunch (or all!) of the networking commands, and it would
> be great to be able to use tcpdump and ethereal under Linux without
> root.  Performance for such calls is rarely critical.

the problem is that iptables is a packet filter.  it operates on
packets.  In short, it is a black box that compares a packet with a set
of rules.  If there is no packet, you cannot make any decision.

So if you would base your policy on iptables, every process is still
able to bind, but all the packets you send get discarded.

> - Morty
>=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Ca0e2zgpnh8/XhnM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/4hPSXaXGVTD0i/8RAny3AJ9acCv6EMiSGX713xCIAFsVORTQggCghxeq
DhcyAXKZFUqsinJwzqvr13I=
=MP06
-----END PGP SIGNATURE-----

--Ca0e2zgpnh8/XhnM--
