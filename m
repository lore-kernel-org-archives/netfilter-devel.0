From: Harald Welte <laforge@gnumonks.org>
Subject: Re: libipulog question (again)
Date: Thu, 5 Sep 2002 11:56:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020905095626.GI1064@naboo.lincon.Uni-Koeln.DE>
References: <Pine.LNX.4.44.0209041924230.2080-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rob McMillen <rvmcmil@cablespeed.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0209041924230.2080-100000@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2002 at 07:34:37PM -0400, Rob McMillen wrote:
> Hope this is the right medium.  I am really having problems with ULOG.  I=
=20
> have a simple rule
>=20
> iptables -A OUTPUT -d 192.168.0.1 -j ULOG

what is the version of ipt_ULOG.c? where did you get libipulog from
(from which iptables package?)

> Thanks in advance,
> Rob

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

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9dypKXaXGVTD0i/8RAhYVAKCYaz4H9zJKEv8yG5nwulxtJwDT/wCdEcLA
Cv1uCB11Z9mjrs+2acCeXx4=
=x1VN
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
