From: Harald Welte <laforge@netfilter.org>
Subject: Re: using netfilter with mpls
Date: Wed, 21 Jul 2004 16:40:45 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040721204045.GM27487@obroa-skai.de.gnumonks.org>
References: <026301c44e59$b892c9a0$248610ac@pc.ccse.kfupm.edu.sa> <1087157097.11287.16.camel@ws> <00c101c451f0$0622a070$248610ac@pc.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZY5CS28jBCfb727c"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Content-Disposition: inline
In-Reply-To: <00c101c451f0$0622a070$248610ac@pc.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZY5CS28jBCfb727c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 14, 2004 at 12:14:40PM +0300, Muhammad R. Sami wrote:
> Can you please help me on writing this MPLS match/target and if
> iptables is not a good solution than where should I focus.

First of all, we need to get the new MPLS implementation into the 2.6.x
kernel, then we can start adding support for MPLS packet filtering.

> regards
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZY5CS28jBCfb727c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA/tTMXaXGVTD0i/8RAmcKAJ9seJJZ/Mwh/YIa189CF+CW0pOBhwCgqNeJ
jSMmkpaj6VT337jFd9M062w=
=wARh
-----END PGP SIGNATURE-----

--ZY5CS28jBCfb727c--
