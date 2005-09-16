From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Fri, 16 Sep 2005 11:15:48 +0200
Message-ID: <20050916091548.GO5034@sunbeam.de.gnumonks.org>
References: <20050915145406.GC17121@rama.de.gnumonks.org>
	<4329F94E.4060107@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kaF1vgn83Aa7CiXN"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4329F94E.4060107@trash.net>
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


--kaF1vgn83Aa7CiXN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 16, 2005 at 12:44:30AM +0200, Patrick McHardy wrote:
> Harald Welte wrote:
> >NETFILTER: Add new PPTP conntrack and NAT helper
>=20
> I noticed a number of problems, this first batch of patches
> fixes the worst ones I hope. There's also one or two small
> cleanup patches. I can't test them here, please review and
> ACK/NACK for Dave.

Ok, I'm at the moment hunting down some strange linux-2.6.13 <-> solaris
9 TCP window scaling problems.  Will look into your patches later today.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kaF1vgn83Aa7CiXN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDKo1EXaXGVTD0i/8RAhgXAJ48poQTFncLdXTZicwLE3Y9uNzELACgg2J1
gSDAKVLuKc5o8EH6c+MT+Ao=
=dOjx
-----END PGP SIGNATURE-----

--kaF1vgn83Aa7CiXN--
