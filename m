From: Harald Welte <laforge@gnumonks.org>
Subject: Re: tunneled packets
Date: Thu, 5 Dec 2002 21:14:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205201418.GE11068@naboo.club.berlin.ccc.de>
References: <008201c2955f$06e94da0$0c0aa8c0@aristo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ey/N+yb7u/X9mFhi"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nikolaos Fideropoulos <n.fideropoulos@tu-bs.de>
Content-Disposition: inline
In-Reply-To: <008201c2955f$06e94da0$0c0aa8c0@aristo>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ey/N+yb7u/X9mFhi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2002 at 04:17:24PM +0100, Nikolaos Fideropoulos wrote:

> 1) i want to monitor tunneled packets, but i'm not sure how they pass the
> hooks. is following right?:
>=20
> (incoming packets):
> incoming_device->PRE_ROUTING->FORWARD->POST_ROUTING->tun-device(decapsula=
tio
> n)->PRE_ROUTING->LOCAL_IN
> (outgoing packets):
> LOCAL_OUT->POST_ROUTING->tun-device(encapsualtion)->PRE_ROUTING->FORWARD-=
>PO
> ST_ROUTING->outgoing_device

seems correct to me.

> 2) I wanna write a small module which does some checks on packets in
> NF_IP_LOCAL_IN, NF_IP_LOCAL_OUT and maintains a connection-table. I would
> like to know if it's ok to do that in 1 Module (and 1 function), or should
> that be done for any reason in seperate modules?

Mh. A connection table. Don't we already have one in ip_conntrack? Maybe
it's a  good idea to describe what you really want to achieve, maybe
there's a different solution to the problem.

And yes, of course you can attach a single function to multiple hooks,
if this anwers your question :)

> Regards,
> Nikos

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

--ey/N+yb7u/X9mFhi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977OaXaXGVTD0i/8RAs5iAJwPKaYmq7nk5xtwjAoKt7U953BlRQCgluAX
qPC56bX6Bsm9ybWnCtR6ylA=
=cb5u
-----END PGP SIGNATURE-----

--ey/N+yb7u/X9mFhi--
