From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack and netstat: diverging ideas of established connections
Date: Fri, 31 Jan 2003 12:46:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131114612.GU9073@naboo.cybercafe42>
References: <4D618F6493CE064A844A5D496733D667031692@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6tPipYVl+OcoAvSh"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Bene <martin.bene@icomedias.com>
Content-Disposition: inline
In-Reply-To: <4D618F6493CE064A844A5D496733D667031692@freedom.icomedias.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6tPipYVl+OcoAvSh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2003 at 04:24:25PM +0100, Martin Bene wrote:
> On a server with no forwarding I'm seeing pronounced differences regarding
> established connections:
>=20
> cat /proc/net/ip_conntrack shows ~ 150 tcp connections in "ESTABLISHED"
> state;
>=20
> netstat -an shows 20 established TCP connections.
>=20
> especialy troubling: I find 10 concurrent connections =3D=3D> port 25 for=
 a host
> IP in ip_conntrack, while there actually is not a single sendmail session
> active.
>=20
> Any ideas why conntrack keeps these "ghost" connections around as avtive =
even
> though they definitely don't exist?
> since I'm trying to limit max concurrent connections by host using iplimit
> these bad entries in ip_conntrack are quite troublesome.
>=20

this is not a development question.

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

--6tPipYVl+OcoAvSh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+OmIEXaXGVTD0i/8RAipTAJwJ8wRo0LRtY0T+kjMANoPAh96ISgCfcjUq
sAMijllY+FxCFUrOW9Ic+M0=
=IyZd
-----END PGP SIGNATURE-----

--6tPipYVl+OcoAvSh--
