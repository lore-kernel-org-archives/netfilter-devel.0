From: Harald Welte <laforge@netfilter.org>
Subject: Re: TTL Target DOESN'T work with kernel 2.6.x!
Date: Wed, 25 Feb 2004 09:52:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040225085206.GW13386@sunbeam.de.gnumonks.org>
References: <200402230756.53183.netfilter@mail.bg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SAeLYP8kwBCGlqB7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Mario <netfilter@mail.bg>
Content-Disposition: inline
In-Reply-To: <200402230756.53183.netfilter@mail.bg>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--SAeLYP8kwBCGlqB7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2004 at 07:56:53AM +0200, Mario wrote:
> but=20
>=20
> root@darkstar:~$ ping ftp.bs.spnet.net
> PING debian.bs.spnet.net (212.50.0.39) 56(84) bytes of data.
> 64 bytes from ftp.bs.spnet.net (212.50.0.39): icmp_seq=3D1 ttl=3D1 time=
=3D2.40 ms
>=20
> Local programs show me the real ttl, not the set one. I tried to route to
> my other pc it doesn't work (my ISP sets incoming ttl to 1)...my linux bo=
x=20
> sends time exceeded to the gateway.so whats the=20
> point? This patch doesn't work correctrly or maybe i'm wrong.

Thanks, I have fixed the bug in patch-o-matic CVS.  Please try with the
current CVS code.

> Mario
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--SAeLYP8kwBCGlqB7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAPGI2XaXGVTD0i/8RAqOHAJ9ijrCwFfyPIZ0ibsbrAXjUSOXXtACcC+Sq
KyBqOkOOnMdOOamEBC0+xOM=
=c3Vk
-----END PGP SIGNATURE-----

--SAeLYP8kwBCGlqB7--
