From: Harald Welte <laforge@netfilter.org>
Subject: Re: Minor modification of function dcc_parse in ip_conntrack_irc.c
Date: Thu, 19 Aug 2004 13:27:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819112727.GM3921@sunbeam.de.gnumonks.org>
References: <1092170081.9955.12.camel@dana.go-nix.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7IzduDXdmGAvR4BO"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Nix N. Nix" <nix@go-nix.ca>
Content-Disposition: inline
In-Reply-To: <1092170081.9955.12.camel@dana.go-nix.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7IzduDXdmGAvR4BO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 10, 2004 at 04:34:41PM -0400, Nix N. Nix wrote:

> dcc_parse is responsible for finding the ip and port in this string.  It
> gets the string starting at <param>.  Unfortunately, so far, dcc_parse
> assumed that <param> does not contain any spaces.  Thus, the module
> failed to track connections implied by a string of the form
>=20
> \1DCC SEND "The Big Movie.avi" 10289477 1011 37546262\1\n

I think I came across this issue once before.  I somewhere found a
document specifying the dcc protocol, and IIRC it stated that spaces are
not allowed.

So my take was always: well, fix the broken irc clients.

However, I think we should integrate a fix.  (see my other mail)
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7IzduDXdmGAvR4BO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJI6fXaXGVTD0i/8RAt6OAJ9+dEOSUkk2yI+izuNhSvZ5Vv2qfwCfSKWU
JrWCWnQqNm2pAEe9kN+wYnw=
=xKSF
-----END PGP SIGNATURE-----

--7IzduDXdmGAvR4BO--
