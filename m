From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC PATCH] ctnetlink port to nf_conntrack take #1
Date: Mon, 14 Nov 2005 18:10:15 +0100
Message-ID: <20051114171015.GI4773@sunbeam.de.gnumonks.org>
References: <4377E89A.5030205@eurodev.net>
	<200511141622.jAEGMAXf015099@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N8ia4yKhAKKETby7"
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200511141622.jAEGMAXf015099@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--N8ia4yKhAKKETby7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 15, 2005 at 01:22:09AM +0900, Yasuyuki KOZAKAI wrote:

> I think we can generalize layer 3 protocol handling more, by introducing
> nfattr_to_tuple/tuple_to_nfattr to l3proto modules like proto.

I agree.

> And it would be great if {ip,nf}_conntrack_netlink.c can be unified.
> But currently I don't have good idea to do that in clear way, and without
> extensibility limitation of nf_conntrack_netlink. I'll think about this m=
ore.
> How do you think ?

I don't think it's really worth the effort.  we already have two
instances of connection tracking code. =20

ip_conntrack will go sooner or later, so we should rather spend time on
important features such as userspace conntrack helpers and NAT for
nf_conntrack

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--N8ia4yKhAKKETby7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDeMT3XaXGVTD0i/8RAo7VAJwI7thWozdxdmuve/x6rVkd3tRNeACdESG5
2r2Cb16ac/zzqayRMxD47R4=
=xOUo
-----END PGP SIGNATURE-----

--N8ia4yKhAKKETby7--
