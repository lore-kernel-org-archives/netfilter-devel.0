From: Harald Welte <laforge@gnumonks.org>
Subject: Re: netfilter wont forget old rule
Date: Mon, 6 Jan 2003 14:05:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030106130513.GI9467@sunbeam.de.gnumonks.org>
References: <5.1.0.14.2.20021218033741.0299e840@66.92.0.116>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3bhLwMadv7h6/J9"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Gram <hawk@freechess.org>
Content-Disposition: inline
In-Reply-To: <5.1.0.14.2.20021218033741.0299e840@66.92.0.116>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--O3bhLwMadv7h6/J9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2002 at 03:50:17AM +0100, Henrik Gram wrote:
=20
> Which worked fine sending isakmp messages coming in from our two ISP's=20
> (eth1 and eth2) to our VPN gateway.  However, I was wanting to make anoth=
er=20
> machine the VPN gateway and changed the above line with the updated=20
> ip.  The list of rules was flushed first and in the iptables -L, only the=
=20
> new rule shows up.  However, tcpdump reveals that the box is still=20
> forwarding those packets to the old address.  I cannot figure out why.. I=
=20
> tried adding a LOG target as the first rule but that wasn't matched=20
> either.  For some reason it keeps insisting on using the old rule which i=
s=20
> not listed anywhere.

You seem to have misunderstood how NAT in netfilter works.  The nat
table is just traversed for every first packet of a connection.  At this
point, the NAT binding is saved with the conntrack entry.  All further
packets are NATed according to this NAT binding.

So if you change your NAT rules for an ongoing connection, it will not
work.

> Henrik Gram

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--O3bhLwMadv7h6/J9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GX8JXaXGVTD0i/8RAooUAKCiHj4v3XBKA5mTT/7PH+D3n9zkGACgnPzR
6ueCV36yQeGDc5fGaDe/25Q=
=LGQ2
-----END PGP SIGNATURE-----

--O3bhLwMadv7h6/J9--
