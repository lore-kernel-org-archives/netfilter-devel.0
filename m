From: Harald Welte <laforge@netfilter.org>
Subject: Re: p-o-m-ng patch
Date: Fri, 20 Feb 2004 21:23:59 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220202359.GR4797@sunbeam.de.gnumonks.org>
References: <1077284489.27084.5.camel@tech004.alphalink.fr> <1077300913.5116.12.camel@porky> <1077301654.5116.18.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zu4V1sHRt6IpqgDQ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@regit.org>
Content-Disposition: inline
In-Reply-To: <1077301654.5116.18.camel@porky>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Zu4V1sHRt6IpqgDQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 20, 2004 at 07:27:34PM +0100, Eric Leblond wrote:
> Sorry for the disturbance, I do a test from a clean 2.6.3 kernel tree
> and there's compilation problem with CONNMARK.
>=20
> The best match now correctly found the best directory for each type
> (patch,file,ladd) but in the CONNMARK patch the files are split  between
> the 2 directories (linux  linux-2.6). So we miss a subset of the files.
> So my question :
> 	- Do we change p-o-m-ng or do we change CONNMARK patch ?

we need to change p-o-m.    Actually this issue doesn't only effect
CONNMARK, but almost all patches by now.

Most of them share a common Makefile.ladd, a common ipt_whatever.h and
maybe even a common linux.patch - but they have differetn ipt_whatever.c
files, since the syntax of struct ipt_{match,target} is slightly
different in both kernels [by intention].

So we need to iterate over all files in all linux* subdirectories and
build a list of 'best matches' for every single file.

> BR,
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Zu4V1sHRt6IpqgDQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANmzfXaXGVTD0i/8RAspYAJ4zn7oVhveO2xUKLr6llXHbnYHkQQCfYkLQ
4pEmDEDo88SwArXlJzF1dIA=
=+Ko1
-----END PGP SIGNATURE-----

--Zu4V1sHRt6IpqgDQ--
