From: Harald Welte <laforge@netfilter.org>
Subject: Re: your mail
Date: Tue, 30 Aug 2005 16:09:23 +0200
Message-ID: <20050830140923.GD4221@rama.de.gnumonks.org>
References: <200508301321.j7UDLV9k002943@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8w3uRX/HFJGApMzv"
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200508301321.j7UDLV9k002943@toshiba.co.jp>
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


--8w3uRX/HFJGApMzv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2005 at 10:21:31PM +0900, Yasuyuki KOZAKAI wrote:
>=20
> Hi,
>=20
> If CONFIG_NF_IP_CONNTRACK=3Dy, CONFIG_NETFILTER_NETLINK=3Dm, and
> CONFIG_NF_CONNTRACK_NETLINK=3Dm, it's failed to build kernel
> of netfilter-2.6.14 git tree. Because __nfa_fill() in nfnetlink
> called from ip_conntrack isn't built into kernel image in this case.
> It's necessary to fix Kconfig or change source code to make dependencies
> more simple.

Thanks for pointing this out.

This problem will be fixed by Thomas Graf's generic netlink macros
(which will be part of the core network stack) which will be merged
during the net-2.6.14 process, so I think we can ignore
this for now.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8w3uRX/HFJGApMzv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDFGiTXaXGVTD0i/8RAhUHAJ9rjlKvE3bd6xRcLi1oGZXOEaELnACghhOd
R4ljTNyLB3XV487ezKJi/kM=
=IN6t
-----END PGP SIGNATURE-----

--8w3uRX/HFJGApMzv--
