From: Harald Welte <laforge@gnumonks.org>
Subject: Re: a question about ip_conntrack_max
Date: Thu, 12 Dec 2002 13:32:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021212123220.GO3611@sunbeam.de.gnumonks.org>
References: <F78gEj4v5iJarnJ3kEP000004e7@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2iBwrppp/7QCDedR"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: jump lee <zomby_cn@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F78gEj4v5iJarnJ3kEP000004e7@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2iBwrppp/7QCDedR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2002 at 02:35:56PM +0800, jump lee wrote:
>=20
> i am hacking ip_conntrack.
> in function ip_conntrack_init (ip_conntrack_core.c), i can not understand=
=20
> this statement:
>=20
> ip_conntrack_max=3D8*ip_conntrack_htable_size;
>=20
> what's the reason of multiplying ip_conntrack_htable_size by 8?

please read the mailinglist archive.  There have been discussions about
this subject going on all the time.  You can greatly improve performance
by using different values (higher prime numbers, ...) here.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--2iBwrppp/7QCDedR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9+IHUXaXGVTD0i/8RAqXGAKCqcxoBPgNdTtf9e84AQy99mkvbaQCfZPT4
3bLGUhJ18o0FqOQOejQWoRU=
=lipr
-----END PGP SIGNATURE-----

--2iBwrppp/7QCDedR--
