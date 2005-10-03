From: Harald Welte <laforge@netfilter.org>
Subject: Re: pptp-conntrack-nat & kernel 2.6.11
Date: Mon, 3 Oct 2005 09:51:48 +0200
Message-ID: <20051003075148.GQ4168@sunbeam.de.gnumonks.org>
References: <5a335a3d0510021106l303a056bu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zXAsBmU9x0sF79Nf"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Antonio <anton.ananich@gmail.com>
Content-Disposition: inline
In-Reply-To: <5a335a3d0510021106l303a056bu@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--zXAsBmU9x0sF79Nf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 02, 2005 at 09:06:56PM +0300, Antonio wrote:
> Dear Harald!
>=20
> I have read that pptp-conntrack-nat patch does not work with kernels >
> 2.6.10. So I'd like to ask you if this is temporary? What can you
> advice me to solve this fault? Can I help to solve this problem?

2.6.14 has pptp conntrack/nat in mainline, so I recommend either using
2.6.14-rc3, or wait until 2.6.14 final is reelased.

I didn't do any intermediate ports for 2.6.11. 2.6.12 and 2.6.13.

Though it shouldn't be all that difficult to backport the (new,
pptp-conntrack-3.0) code from 2.6.14-rc3, at least to 2.6.13.  Please
don't forward-port the old code, since there were a number of issues
fixed by the new code.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zXAsBmU9x0sF79Nf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDQOMUXaXGVTD0i/8RAsISAKCDnClJFJvFku4TLBszzdrTKF/DVACcD+AW
nieQHdHIOqKKqTuYcQ8a+uA=
=zLmq
-----END PGP SIGNATURE-----

--zXAsBmU9x0sF79Nf--
