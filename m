From: Harald Welte <laforge@netfilter.org>
Subject: Re: SNAT multicast traffic
Date: Tue, 8 Feb 2005 15:46:38 +0100
Message-ID: <20050208144638.GQ6878@sunbeam.de.gnumonks.org>
References: <420882B9.3050108@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7Vi1RbbjZdZQ982c"
Cc: netfilter-devel@lists.netfilter.org
To: Paolo Rossi <paolo_76@inwind.it>
Content-Disposition: inline
In-Reply-To: <420882B9.3050108@inwind.it>
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


--7Vi1RbbjZdZQ982c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 08, 2005 at 10:13:29AM +0100, Paolo Rossi wrote:
> Hi all,
>=20
>=20
> I have a trouble with netfilter. I need to perform a SNAT to outgoing=20
> multicast packet. Multicast packet come from private network and i can't=
=20
> annunce this private network in my routing domain. Becauseour routers=20
> manage multicast traffic with PIM-SM protocol and PIM perform RPF (revers=
e=20
> path forwarding), the clients can't see the multicast traffic. I've read=
=20
> that netfilter don't support multicast SNAT, why?

netfilter/iptables doesn't implement multicast NAT at all.  this is due
to it's strictly stateful fully-symmetric implementation, which
obviously doesn't fit the multicast paradigm (where 'reply' packets of a
multicast 'connection' don't have the inverted
sourceip<->destinationip).

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7Vi1RbbjZdZQ982c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCCNDOXaXGVTD0i/8RAgX1AJ9CHTwuN8tQ3svkE/UQj+b4ueyX6QCfbJiP
oYsXCRh6bv2fCZLD5S9ZyBg=
=zFQi
-----END PGP SIGNATURE-----

--7Vi1RbbjZdZQ982c--
