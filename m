From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] 1 Wire drivers illegally overload NETLINK_NFLOG
Date: Tue, 26 Jul 2005 05:48:28 -0400
Message-ID: <20050726094828.GJ7925@rama>
References: <20050723125427.GA11177@rama>
	<20050722.230559.123762041.yoshfuji@linux-ipv6.org>
	<20050723133353.GB11177@rama>
	<20050724.191505.69244686.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1E1Oui4vdubnXi3o"
Cc: johnpol@2ka.mipt.ru, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050724.191505.69244686.davem@davemloft.net>
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


--1E1Oui4vdubnXi3o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 24, 2005 at 07:15:05PM -0700, David S. Miller wrote:
=20
> > I strongly disrecommend increasing NPROTO.  Maybe we should look into
> > reusing NETLINK_FIREWALL (which was an old 2.2.x kernel interface).
>=20
> ip_queue.c still uses NETLINK_FIREWALL so we really can't use
> that.

sorry, I didn't remember that ip_queue reused the 2.2.x netlink number
:(  We should have renamed it to make it clear.

> So instead, as in the patch below, I solved this for now by using
> the NETLINK_SKIP value which was reserved years ago yet never
> made use of.

thanks.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--1E1Oui4vdubnXi3o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC5gbsXaXGVTD0i/8RAtYtAJ9LdzcNPEEV4Mf6Wdzgo7Z5Tn6UswCdFlS6
jpXJiTFRaAEDNVvc/IoKh1M=
=COO+
-----END PGP SIGNATURE-----

--1E1Oui4vdubnXi3o--
