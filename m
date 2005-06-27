From: Harald Welte <laforge@netfilter.org>
Subject: Re: CLUSTERIP and ProxyARP?
Date: Mon, 27 Jun 2005 11:09:59 +0200
Message-ID: <20050627090959.GE19928@sunbeam.de.gnumonks.org>
References: <876ef97a0506231536656b269b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ATYltwmfWCpDp8Ax"
Cc: nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
Content-Disposition: inline
In-Reply-To: <876ef97a0506231536656b269b@mail.gmail.com>
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


--ATYltwmfWCpDp8Ax
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2005 at 06:36:08PM -0400, Tobias DiPasquale wrote:
> Hi all,
>=20
> Does anyone know if ipt_CLUSTERIP and ProxyARP will work correctly
> together on a current Linux kernel? Anything special to watch out for?
> TIA :)

1. all current linux kernel up to (and including 2.6.12) has a CLUSTERIP bug
   anyway
2. I didn't think about interoperability with  proxyarp when
   implementing CLUSTERIP.  In fact, CLUSTERIP is meant to run on
   end-hosts (Such as webservers), not on gateways.

CLUSTERIP mangles ARP requests (and replies) from/to the CLUSTER IP
address.  So if you are proxy-ARP'ing for different IP addresses, it
_should_ work.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ATYltwmfWCpDp8Ax
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCv8JnXaXGVTD0i/8RApTxAJ9TkmXVNDV1Y1JK0ZvhcNQeCQDq9QCfRLEI
1CTBojhKAdXW1b8RnJiDekI=
=FJ6a
-----END PGP SIGNATURE-----

--ATYltwmfWCpDp8Ax--
