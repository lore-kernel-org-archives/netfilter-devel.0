From: Harald Welte <laforge@gnumonks.org>
Subject: Re: NAT-PT
Date: Tue, 22 Oct 2002 17:18:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021022151854.GA6419@naboo.club.berlin.ccc.de>
References: <E182tvv-00066I-00@kashyyyk.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ulises =?iso-8859-1?Q?Cervi=F1o?= <ulisescervino@fullzero.com.ar>
Content-Disposition: inline
In-Reply-To: <E182tvv-00066I-00@kashyyyk.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 19, 2002 at 10:38:52AM -0300, Ulises Cervi=F1o wrote:
> Hello,=20
>=20
> This is my first post to this mailing list. I was reading RFC (which=20
> describes NAT-PT) and I was wondering if anyone is working on this. I ask=
ing=20
> this because I planning to do so, so I like to know if there was anything=
=20
> already done.

No, unfortunately the way netfilter's NAT implementation works, is fully
based on the connection tracking code.=20

The connection tracking itself is strictly bound to IPv4 and there is no
way how to represent a connection tracking entry with one end in IPv4
and the other end in IPv6 address space.

There have been a couple of messages about this issue on the mailinglist
in the past, I recommend browsing the archives.

> Cervi=F1o Ulises <ulisescervino@ciudad.com.ar>
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9tWxeXaXGVTD0i/8RAm6TAJ9WHwxZhMplrD1VqnqDgktvlwgKtwCfYjHr
cd0i+AZPyDsPru7n6T+PNkU=
=VRZA
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
