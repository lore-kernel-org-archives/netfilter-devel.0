From: Harald Welte <laforge@netfilter.org>
Subject: Re: pkttables compilation problem
Date: Wed, 21 Jan 2004 09:04:47 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040121140447.GS8642@obroa-skai.de.gnumonks.org>
References: <1074256826.6677.9.camel@oc-cinf-lin>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mXDO3udm/xYWQeMQ"
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Glauber Reis <greis_one@yahoo.com.br>
Content-Disposition: inline
In-Reply-To: <1074256826.6677.9.camel@oc-cinf-lin>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mXDO3udm/xYWQeMQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2004 at 09:40:26AM -0300, Glauber Reis wrote:
> Is pkttables from CVS broken? Is there any requisites?

pkttables is an ongoing development effort, don't expect it to do
anything.

> I got only NETLINK and nfnetlink-ctnetlink-0.13 into a 2.4.22 kernel
> (from kernel.org).
> I'd really want to try a netfilter userspace library, but got no success
> with libiptc...

you seem to be confused.

a) pkttables is not needed for nfnetlink-ctnetlink
b) libiptc is not related to nfnetlink-ctnetlink.

all you want to compile is libnfnetlinks and libctnetlink.

=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mXDO3udm/xYWQeMQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFADob/XaXGVTD0i/8RAi4BAKCxxJ9g6Yu1bZN2a5KIgph8CqZZjgCfbO2z
dLq3n6R7tMVzUaDJN9derJs=
=ajMx
-----END PGP SIGNATURE-----

--mXDO3udm/xYWQeMQ--
