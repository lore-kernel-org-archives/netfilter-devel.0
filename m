From: Harald Welte <laforge@netfilter.org>
Subject: Re: [2.4.23] compile / link error in net/ipv4/netfilter
Date: Tue, 2 Dec 2003 13:53:33 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031202082333.GI546@obroa-skai.de.gnumonks.org>
References: <20031201202853.A31914@netdirect.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w3uUfsyyY1Pqa/ej"
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Frey <cdfrey@netdirect.ca>
Content-Disposition: inline
In-Reply-To: <20031201202853.A31914@netdirect.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--w3uUfsyyY1Pqa/ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2003 at 08:28:31PM -0500, Chris Frey wrote:
> Hi,
>=20
> Using gcc 3.2.3.
>=20
> When compiling 2.4.23, it stops during the compile with these errors:

how did you get the .config you have attached?

You have COMPAT_IPCHAINS activated at the same time as COMPAT_IPFWADM!

This is illegal, and 'make menuconfig' or 'make xconfig' should not
allow you to combine the two of them.  Please describe how you managed
to do that ;)

Greetings from india,
	Harald.
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--w3uUfsyyY1Pqa/ej
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/zEwaXaXGVTD0i/8RAiKPAJ9dRrA65mf8HZOpdqBIQkKeBmL7AgCeIVJ0
jFghCpdLN4Ot8C29c3eSiCk=
=cuSN
-----END PGP SIGNATURE-----

--w3uUfsyyY1Pqa/ej--
