From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] ipt_mask
Date: Fri, 10 Jan 2003 15:05:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110140544.GV1353@sunbeam.de.gnumonks.org>
References: <3DEBA04C.7080606@myrealbox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qf/2YuBwNTyt+peV"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Luciano Ruete <kies@myrealbox.com>
Content-Disposition: inline
In-Reply-To: <3DEBA04C.7080606@myrealbox.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Qf/2YuBwNTyt+peV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 02, 2002 at 03:02:52PM -0300, Luciano Ruete wrote:
> Hi, i've made a netfilter match module called ipt_mask. Basically it=20
> provides arbitrary mask syntax to do a match whit the destination address.
> ie:

Hi, sorry for my late reply.

> will logical AND the first parameter(and_mask) whit the daddress and=20
> then compare the result whit the second parameter(cmpr_mask)
> As result it is MARKing whit 6900 the even daddress and whit 6901 the=20
> odd daddress.
>=20
> It works for me to do a dirty ;-) load balancing between to or more=20
> providers.

Due to the experimental nature of this match (and the lack of practical
use, from my point of view), I will not integrate it into patch-o-matic.

I hope you will understand this,

	Harald.

> Luciano

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--Qf/2YuBwNTyt+peV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HtM4XaXGVTD0i/8RAgZzAJ9SRsVI5FlYYOQRZznvfwkT1C7SFgCZAVUi
gJntSTlv+j/n67vRtynrDZ4=
=0RV1
-----END PGP SIGNATURE-----

--Qf/2YuBwNTyt+peV--
