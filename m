From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 14:48:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040128134845.GV11761@sunbeam.de.gnumonks.org>
References: <20040127205123.GA11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401272301070.27343-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oTjmB4SGUHx7SKxS"
Cc: Willy Tarreau <willy@w.ods.org>, Tom Eastep <teastep@shorewall.net>,
	Michal Ludvig <mludvig@suse.cz>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401272301070.27343-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oTjmB4SGUHx7SKxS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2004 at 11:35:48PM +0100, Henrik Nordstrom wrote:
> Sorry for the naming mismatch. With the current close relation between=20
> hooks and chains it is easy to confuse the two when one is not installing=
=20
> hooks every day. All thoughts was in netfilter hooks not iptables chains.
>=20
> Using the existing existing hooks with NF_IP_LOCAL_IN/OUT for the IPSec
> wrapped packets is a exact match on what is required for conntrack, but to
> answer my own question on what is wrong with INPUT/OUTPUT there is nothing
> wrong but NAT and mangle may benefit from using a couple of new hooks for
> the "original" packets just at the border to IPSec due to the different
> rerouting requirements. NF_IP_LOCAL_IN/OUT is however an exact match for
> all existing netfilter module requirements on the encapsulated packets
> from what I can tell.

Well, I now had to find out that libiptc depends on a 'one hook per
chain' assumption, too bad.  My idea was to attach the same chain to
multiple hooks.  That is not possible, as of now.

As you can see in your patch, I gave up on all of that and just use
the existing hooks.

> What is pretty clear is that the "rerouting" requirements is far from
> obvious and needs to be analyzed carefully. If one thought rerouting of
> packets in the plain IP with ip_route_me_harder was a mess the situation
> is now some orders of magnitude more complex it seems, at least from a
> quick evaluation without digging into the actual 2.6 IPSec code.

yes, indeed.  Unfortunately, analyzing this whole issue has alrady cost
me too much of my time the last couple of days :(  I'll have to defer it
for now.

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

--oTjmB4SGUHx7SKxS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAF729XaXGVTD0i/8RAhbvAJ9p0UuTe0rBjCA4dOZK9OVfnN6TaQCeJXOT
hxhf118pQDw4LNE09MB3Ux4=
=dROu
-----END PGP SIGNATURE-----

--oTjmB4SGUHx7SKxS--
