From: Harald Welte <laforge@netfilter.org>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Thu, 19 Aug 2004 11:47:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819094720.GZ3921@sunbeam.de.gnumonks.org>
References: <20040818223233.GA317@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EcLUEBHJhOmOUQ0C"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Samir Bellabes <sam@cerbere.dyndns.info>
Content-Disposition: inline
In-Reply-To: <20040818223233.GA317@cerbere.dyndns.info>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--EcLUEBHJhOmOUQ0C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 19, 2004 at 12:32:33AM +0200, Samir Bellabes wrote:
> Hi Harald,
>=20
>    It's seems that the file
>    p-o-m/osf/linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h
>    is missing.

Erm, it's not missing.  It is in the linux-2.4 and linux-2.6 shared=20

	pom/osf/linux/include/linux/netfilter_ipv4/

directory in order to avoid duplication of the same file at two
locations within cvs.

>    Without it, ipt_osf can't be compile.
>    thanks.
=20
btw: I wouldn't start using dyndns for email... just imagine what
happens if you get disconnected, somebody else gets the ip and now
somebody delivers email to that ip?  Yes, that email is either lost and
received at his node, or causes a bounce (which in turn might
automatically unsubscribe yourself from a mailinglist).

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--EcLUEBHJhOmOUQ0C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJHcoXaXGVTD0i/8RArqhAKCbMF7nzxAhNYACxlFlS09/yAGnjQCeK0M4
bBfVKXQizinvLYUKguveyAs=
=2ZX7
-----END PGP SIGNATURE-----

--EcLUEBHJhOmOUQ0C--
