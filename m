From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] RPC match and conntrack modules v2.1
Date: Mon, 13 Jan 2003 02:32:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030113013226.GG28943@sunbeam.de.gnumonks.org>
References: <200301121133.h0CBX9K10094@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ian Latter <Ian.Latter@mq.edu.au>
Content-Disposition: inline
In-Reply-To: <200301121133.h0CBX9K10094@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2003 at 09:33:07PM +1100, Ian Latter wrote:
> Hi Harald,
>=20
>   I didn't get your gz attachment, but I reassembled your patch from
> the mailling list archive.

sorry, I missed that attachment :(

>   I have done all bar the cache implementation. =20

Thanks. let's consider the slab cache as optional optimization, if
needed this can be changed later.

>   I have done a fair bit of work on its cleanliness since you last
> saw it.

great.  I'll apply your patch to CVS now.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+IhcqXaXGVTD0i/8RAoqJAJ97nPSdRyU8HNeJXcy3vefdMHg1nwCfVOuo
b2bBOCOUAHh81hwvDkCZnZM=
=RHaC
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
