From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Connecttrack Access
Date: Thu, 5 Dec 2002 21:40:03 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205204003.GO11068@naboo.club.berlin.ccc.de>
References: <MFEGKJBMPCLPMMMBAACNMEMFOAAA.jfowler@westrope.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYjWXklH5JTzT8n9"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jeremy Fowler <jfowler@westrope.com>
Content-Disposition: inline
In-Reply-To: <MFEGKJBMPCLPMMMBAACNMEMFOAAA.jfowler@westrope.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--TYjWXklH5JTzT8n9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 22, 2002 at 12:41:03PM -0600, Jeremy Fowler wrote:
> New to the list, so sorry if this has been asked before. I was wondering =
if
> there is a library interface to access the connecttrack module's MASQUERA=
DE
> feature to get a list of what port/ipaddr assignments. Basically looking =
for a
> way to let a user-space program track SNAT connections and port usage.

read and parse /proc/net/ip_conntrack.

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

--TYjWXklH5JTzT8n9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977mjXaXGVTD0i/8RAkoAAKCglBfoxRtOHGGSqu+itmMstBdCxACfSs+r
sL6DdrGxPf/Yz2zY4LPz7Gs=
=1pJR
-----END PGP SIGNATURE-----

--TYjWXklH5JTzT8n9--
