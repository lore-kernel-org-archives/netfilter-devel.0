From: Harald Welte <laforge@netfilter.org>
Subject: Re: Any way of knowing a packet's been defragmented
Date: Thu, 19 Aug 2004 13:46:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819114604.GQ3921@sunbeam.de.gnumonks.org>
References: <W5101410375481091705422@asteria.telenet-ops.be> <Pine.LNX.4.61.0408051507530.405@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="74hf9PSALuoWtOh/"
Cc: Bart De Schuymer <bdschuym@pandora.be>, shemminger@osdl.org,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	bridge <bridge@osdl.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0408051507530.405@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--74hf9PSALuoWtOh/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 05, 2004 at 03:10:42PM +0200, Henrik Nordstrom wrote:
> On Thu, 5 Aug 2004 bdschuym@pandora.be wrote:
>=20
> >As Stephen explained, bridge ports of the same bridge device no longer=
=20
> >need to have the same mtu. So the bridge code needs to drop packets=20
> >(ARP, IP, whatever) that will be too long for the output port.
>=20
> Eh.. I do not claim to be a bridge guru, but won't such bridge cause=20
> serious havoc on the network much like PMTU blackholes does?

Nobody ever replied to that question.

Bart, Stephen, what is your take on this?   How was this resolved?

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--74hf9PSALuoWtOh/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJJL8XaXGVTD0i/8RAk+tAJsE/nw7IQzURImMS9CuXryxEa11twCaAk7i
jLZk5i2Wp2FZMFk4f91VfCc=
=kKiS
-----END PGP SIGNATURE-----

--74hf9PSALuoWtOh/--
