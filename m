From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPIP and SNAT
Date: Sat, 2 Aug 2003 18:03:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030802160351.GA21637@naboo>
References: <Pine.GSO.4.31.0307301130240.13487-100000@disco.cs.columbia.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stelios Sidiroglou-Douskos <ss1759@cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.31.0307301130240.13487-100000@disco.cs.columbia.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2003 at 11:37:23AM -0400, Stelios Sidiroglou-Douskos wrote:
>=20
> I am having some trouble with SNAT and my IPIP implementation.=20

What is 'your IPIP implementation'?

> I have the ipip part working (I use code from ipip.c) but when I clear
> the nfct field of the sk_buff that packet that gets fwd to the other
> interface doesn't get NATed.=20

obviously.  The NAT mappings are saved in the conntrack entry, so if you
remove the reference to conntrack, there will no NAT happen.

> I tried not clearing conntrack but obviously that results in
> the packets not matching up when they return.
>=20
> Do I have to rebuild the conntrack tuple and insert it back? If so, is
> there a code or a helper function to do just that?

well, as I am not aware of what exactly you are trying to implement,
It's hard to give any hints.

> thanks in advance,
> stelios.
>=20
> p.s Please reply to this address directly also.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/K+DmXaXGVTD0i/8RAu0QAJ4pi7BUIjS5qqf9Wbk0YMNGh9ZgDACdEkAW
Z9TzimfrkbZSlJ1JNbnogNI=
=aCHi
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
