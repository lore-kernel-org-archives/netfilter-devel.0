From: Harald Welte <laforge@netfilter.org>
Subject: Re: 76_conntrack_bucket_sysctl.patch
Date: Thu, 27 Nov 2003 12:15:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127111527.GE3373@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.58.0311270631070.1622@gw.localnet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0311270631070.1622@gw.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2003 at 06:35:49AM +0100, Patrick McHardy wrote:
> Hi Harald,
>=20
> I just had a look at 76_conntrack_bucket_sysctl.patch, it adds an
> unneccessary strategy routine. The file permission check is done before
> the strategy is called so that alone should be fine. In fact, I didn't
> even manage to get it called at all. The attached patch is tested and
> works.

thanks.  I thought I'd better make really, really sure that it never
gets written...=20

> Best regards,
> Patrick

I'll apply your patch, thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/xdzPXaXGVTD0i/8RArD6AJ9DBd4ndPaNJaZG69tVazh0zWI7agCgl4/W
Kn0GJKT/PSHbKQ+24BhKZEM=
=ws1s
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
