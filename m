From: Harald Welte <laforge@netfilter.org>
Subject: Re: HL target in the kernel
Date: Sun, 13 Apr 2003 18:12:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030413161259.GT1922@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.51.0304051703030.2841@dns.toxicfilms.tv> <Pine.LNX.4.33.0304111030280.31394-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+NfgObvpQT1Q9Yq"
Cc: Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0304111030280.31394-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--U+NfgObvpQT1Q9Yq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2003 at 10:40:29AM +0200, Jozsef Kadlecsik wrote:
> On Sat, 5 Apr 2003, Maciej Soltysiak wrote:
>=20
> > i have seen that the hl match has been submitted to the kernel,
> > but why was not the HL target submitted? Does it lack something?
>=20
> The HL target is similar to the TTL target - and the latter isn't
> submitted to the kernel either.

Yes, however the reson hasn't been pointed out yet:  The target is
potentially dangerous.  It is very easy to create loops when the TTL is
incremented somewhere.  We think it is safer for the user and the
network in general to not provide such dangerous features by default.

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--U+NfgObvpQT1Q9Yq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+mYyLXaXGVTD0i/8RAuoPAJ92eD7pAXQv+n/4VTKh9JUVlNpuKQCeIkVu
agEZB//2DAjOnTYd27rDmtc=
=D8JS
-----END PGP SIGNATURE-----

--U+NfgObvpQT1Q9Yq--
