From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables userspace build patch (CLASSIFY & NETMAP extensions)
Date: Fri, 12 Sep 2003 23:26:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030912212651.GG4398@obroa-skai.de.gnumonks.org>
References: <200309091239.43164@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EDJsL2R9iCFAt7IV"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <200309091239.43164@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--EDJsL2R9iCFAt7IV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2003 at 12:40:37PM +0200, Henrik Nordstrom wrote:
> Both CLASSIFY and NETMAP are optional extensions and should not be=20
> built unless supported by the kernel headers.
>=20

Well, that is not true.

We currently have three kinds of possible extensions:

1) included in mainstream kernel
This means we always build the plugin

2) included only in patch-o-matic
This means we execute a test

3) extension is about to be submitted to the kernel
This means we have the kernel header files included in the iptables=20
userspace code to make sure it always compiles.  Include paths are
ordered in a way that kernel headers precede our provided headers.

Both of the targets fall in category three.  This means that if the
kernel headers are missing, they need to be committed to the CVS
repository (which I seem to have forgotten).

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--EDJsL2R9iCFAt7IV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/YjobXaXGVTD0i/8RArAeAKCXjjz3T88r73CEsn9pDNajbGR9UQCeN4C0
9huZ3uvrVRJobKpfceC8GG0=
=SA2J
-----END PGP SIGNATURE-----

--EDJsL2R9iCFAt7IV--
