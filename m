From: Harald Welte <laforge@gnumonks.org>
Subject: Re: a question of mtu
Date: Thu, 5 Dec 2002 21:36:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205203624.GM11068@naboo.club.berlin.ccc.de>
References: <000101c29227$29749040$5101a8c0@workstation>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zHDeOHGDnzKksZSU"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ???? <buaacst@163.com>
Content-Disposition: inline
In-Reply-To: <000101c29227$29749040$5101a8c0@workstation>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zHDeOHGDnzKksZSU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 22, 2002 at 09:00:11PM +0800, ???? wrote:
> Hi,
>     I try to get the pmtu at the point of NF_IP_LOCAL_OUT.I write three s=
entence to do this.
>=20
> struct sk_buff *sk_b =3D *skb;
> struct rtable *r_t =3D (struct rtable *)sk_b->dst;
> pmtu =3D r_t->u.dst.pmtu;
>=20
> The result is 0,but in net/ipv4/ip_output.c/ip_queue_xmit2,rt->u.dst.pmtu=
 is not 0.Does some one know the reason,thanks very much!

and how is this related to netfilter development?  This is a core
networking issue, pleaes go to netdev@oss.sgi.com.

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

--zHDeOHGDnzKksZSU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977jIXaXGVTD0i/8RAmt7AJwNKtRI7+gHrZPjLxFT2pICUXZwYwCfVZt4
YjlPidzVPM6XSKABZl+p02M=
=pCu4
-----END PGP SIGNATURE-----

--zHDeOHGDnzKksZSU--
