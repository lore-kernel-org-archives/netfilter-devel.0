From: Harald Welte <laforge@gnumonks.org>
Subject: Re: TCP concurrent connection capacity
Date: Thu, 5 Dec 2002 21:10:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205201028.GC11068@naboo.club.berlin.ccc.de>
References: <F183xC3LeyF01DfZLVz000294e4@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: jump lee <zomby_cn@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F183xC3LeyF01DfZLVz000294e4@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 29, 2002 at 02:15:59PM +0800, jump lee wrote:
>=20
> i performed a TCP concurrent connection capacity test of iptables and=20
> ipchains .
> i am wondering about the 250000(approximate) capacity limit .
> who can tell me why this limit exist? and which parameter lead to this=20
> limit ?  thanks !

can you please describe what limit you are talking about?  Are you sure
you are not talking about ip_conntrack_max respectively the conntrack
hashsize?  (see faq)

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

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977K0XaXGVTD0i/8RAvsUAKCMdRvkZVxGM7Fg+yOVq+uVh16CcQCgp2jk
nLWHpFdF77lOyH9JS/94uLI=
=Cg/E
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
