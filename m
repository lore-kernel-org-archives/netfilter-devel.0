From: Harald Welte <laforge@netfilter.org>
Subject: Re: New standalone nat helper module which help function is never called
Date: Thu, 20 Nov 2003 12:56:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031120115616.GT5075@sunbeam.de.gnumonks.org>
References: <20031117174829.711e2e82.tuxit@netcourrier.com> <20031117223129.GF5075@sunbeam.de.gnumonks.org> <20031118005846.06befa0d.tuxit@netcourrier.com> <20031118004931.GH5075@sunbeam.de.gnumonks.org> <20031118100449.4815515b.tuxit@netcourrier.com> <20031118165904.GQ5075@sunbeam.de.gnumonks.org> <20031120105423.27d84443.tuxit@netcourrier.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9iFHQ9JnogSZzyzY"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: tuXit <tuxit@netcourrier.com>
Content-Disposition: inline
In-Reply-To: <20031120105423.27d84443.tuxit@netcourrier.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--9iFHQ9JnogSZzyzY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2003 at 10:54:23AM +0100, tuXit wrote:

> 	ascii.tuple.src.ip =3D 0;
> 	ascii.tuple.src.u.tcp.port =3D 0;
> 	ascii.tuple.dst.ip =3D 0;
> 	ascii.tuple.dst.u.tcp.port =3D __constant_htons(port);
> 	ascii.tuple.dst.protonum =3D IPPROTO_TCP;
> 	ascii.mask.src.ip =3D 0;
> 	ascii.mask.src.u.tcp.port =3D 0xFFFF;
> 	ascii.mask.dst.ip =3D 0;
> 	ascii.mask.dst.u.tcp.port =3D 0;
> 	ascii.mask.dst.protonum =3D 0xFFFF;

please revert the tupoel/mask part.  Like in all existing helper, you
need to specify the port as src.u.tcp.port

> Thanks in advance,
> Florian Pouradier

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9iFHQ9JnogSZzyzY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/vKvgXaXGVTD0i/8RArcmAKCkKIfe61zz6IkGQ8e7+3i1TgQzpACghYUa
LnQSp/r+5X5VaYw28Brfef0=
=1C7Q
-----END PGP SIGNATURE-----

--9iFHQ9JnogSZzyzY--
