From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_conntrack
Date: Wed, 5 Mar 2003 19:10:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030305181010.GC4880@sunbeam.de.gnumonks.org>
References: <200303040107.28400.alchemyx@uznam.net.pl> <20030304073324.GI25876@oknodo.bof.de> <200303040927.33460.alchemyx@uznam.net.pl> <200303051649.52167.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IQvoI1rdlCKiYEYW"
Cc: Patrick Schaaf <bof@bof.de>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Micha? Margula <alchemyx@uznam.net.pl>
Content-Disposition: inline
In-Reply-To: <200303051649.52167.alchemyx@uznam.net.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IQvoI1rdlCKiYEYW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 05, 2003 at 04:49:52PM +0100, Micha? Margula wrote:
=20
> After few tens of hours of working, got that message once again. So shoul=
d I=20
> rise that number to let say 512000 or maybe one million? Or maybe somethi=
ng=20
> wrong with my system?

is there something particular about your installation? =20

Possible causes:

Do you have asymmetric routing? =20
Are you running a 2.4.20 kernel without applying 'submitted' from p-o-m?

BTW: If you really have 256k/512k connections: remember to increase the
hash bucket size.

> Micha? Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/ +)
> "W ?yciu pi?kne s? tylko chwile" [Ryszard Riedel]

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--IQvoI1rdlCKiYEYW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Zj2CXaXGVTD0i/8RAkD3AJ9MeEgAqj/dHYWNZC1uhAbjsCIqNwCglyWN
kjnxwho0R+QqrQDTr9lEEaw=
=FExm
-----END PGP SIGNATURE-----

--IQvoI1rdlCKiYEYW--
