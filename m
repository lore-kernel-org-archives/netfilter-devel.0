From: Harald Welte <laforge@netfilter.org>
Subject: Re: pptp-conntrack-nat & kernel 2.6.11
Date: Wed, 12 Oct 2005 08:23:08 +0200
Message-ID: <20051012062308.GA4237@rama.de.gnumonks.org>
References: <5a335a3d0510021106l303a056bu@mail.gmail.com>
	<20051003075148.GQ4168@sunbeam.de.gnumonks.org>
	<5a335a3d0510111141hcfe79b2m23823f920eeb630a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Antonio <anton.ananich@gmail.com>
Content-Disposition: inline
In-Reply-To: <5a335a3d0510111141hcfe79b2m23823f920eeb630a@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2005 at 09:41:41PM +0300, Antonio wrote:
> Dear Harald!
>=20
> I'm not shure but i think that i fount a bug in ip_nat_pptp in kernel
> 2.6.14-rc3.
> I used it on router with NAT. When I configure this module to be
> built-in and run dmesg I see that module ip_conntrack_pptp is loaded
> but nothing about ip_nat_pptp. Unfourtently connection was not able to
> be started.

if you compile a kernel with static support for pptpconntrack+nat, you
will see neither of the two in "lsmod".  Can you please send me
(privately) your kernel .config file that was used for the "statically
linked" kernel, and (if possible) also the kernel binary itself?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDTKvMXaXGVTD0i/8RAuWNAJ9lUpc7qCpxULr2uzP9rSOlkobAvwCfe47r
jQSu20SQ8nhxnvun3yaiv3I=
=7Kig
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
