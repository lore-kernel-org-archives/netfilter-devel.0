From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables-save (1.2.8): ports and levels
Date: Mon, 14 Jul 2003 09:44:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030714074457.GB6538@naboo>
References: <3F0D705B.8000708@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Woerner <twoerner@redhat.com>
Content-Disposition: inline
In-Reply-To: <3F0D705B.8000708@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2003 at 03:55:39PM +0200, Thomas Woerner wrote:
> Hello,
>=20
> I have attached a patch to fix iptable-save behavior. Normally port=20
> numbers are saved. But multiport and mport are saving service names=20
> instead of port numbers.
> LOG is also saving log names instead of log levels.
>=20
> The patch enables numeric output for multiport and mport. The patch is=20
> fixing this.

Thanks.  I will include this patch in iptables CVS as soon as I have
some IP connectivity again (travelling).

> Thomas Woerner
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/El94XaXGVTD0i/8RAlcWAJ9Unq47mCWCdbom6NuOYqnniYQ0bACdH2wy
vrh3DhQzPX5kfmOki7zaHdI=
=LCZR
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
