From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.6] ipt_CLUSTERIP: fix ARP mangling
Date: Tue, 28 Jun 2005 23:28:11 +0200
Message-ID: <20050628212811.GE19036@sunbeam.de.gnumonks.org>
References: <20050622122902.GI4551@obroa-skai.de.gnumonks.org>
	<20050622.124341.95064256.davem@davemloft.net>
	<20050628114330.GA16681@sunbeam.de.gnumonks.org>
	<20050628.124640.57169557.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HeFlAV5LIbMFYYuh"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050628.124640.57169557.davem@davemloft.net>
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


--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2005 at 12:46:40PM -0700, David S. Miller wrote:

I'm very sorry, but I must have done something wrong with git and
cogito.  I cloned from your tree and merged all your changes, still it
gave me that broken patch.  I tried for the better part of an hour, and
thought it was doing 'the right thing' now, but apparently it didn't :(

somehow "cg-diff -r origin:HEAD" behaves different from "cg-mkpatch -r
origin:HEAD", and I'm apparently too clueless to get it right. =20

> Like I said, I'll fix this up by hand for you, but please try
> to avoid this in the future.  Thanks.

really sorry, once again.  I need to practise more with git/cogito :(

> While we're here, should this patch get submitted to stable@kernel.org
> for 2.6.12.x submission?  If so, I'll take care of that for you.

yes, please.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HeFlAV5LIbMFYYuh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCwcDrXaXGVTD0i/8RAh/PAJ9D/x8b/0P5cq1VHoV2OBi/X/Ah4ACeMUYP
vU1yy8T4ipmk6yhIAI8I1mc=
=35RG
-----END PGP SIGNATURE-----

--HeFlAV5LIbMFYYuh--
