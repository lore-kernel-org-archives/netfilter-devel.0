From: Harald Welte <laforge@gnumonks.org>
Subject: Re: "Atomic" snapshot of counters
Date: Fri, 31 Jan 2003 12:45:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131114514.GT9073@naboo.cybercafe42>
References: <3E308A34.4020501@hipac.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/DkgDsqJFFamjKX0"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E308A34.4020501@hipac.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/DkgDsqJFFamjKX0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2003 at 01:35:00AM +0100, Thomas Heinz wrote:
> Hi
>=20
> Netfilter produces an atomic snapshot of counters, i.e. the table is
> locked during the gathering of the counter values. Of course no packet
> is matched while this lock is active.

yes. This was thought to be one of 'the' advantages of iptables over
ipchains.

> How important is it to have such an atomic snapshot?=20

=46rom my current point of view: not that important.  My pkt_tables plans
[which are meant to eventually replace ip_tables] also don't have this
atomicity anymore.

> Regards,
> Thomas

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

--/DkgDsqJFFamjKX0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+OmHKXaXGVTD0i/8RAuJ7AKCybiH2aCRqyPKR3AixbeHNBeSnWgCgqZih
LABCi9mUl6BC9xg+LjYM9Rw=
=/lGU
-----END PGP SIGNATURE-----

--/DkgDsqJFFamjKX0--
