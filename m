From: Harald Welte <laforge@netfilter.org>
Subject: Re: Looking for IPtables developers - Need help at core of iptables (not configuration)
Date: Sun, 1 Aug 2004 18:59:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801165929.GB14539@sunbeam2>
References: <5.2.0.9.2.20040727115216.00aa0a30@pop.benesconsulting.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Leon Bene <leon@benesconsulting.com>
Content-Disposition: inline
In-Reply-To: <5.2.0.9.2.20040727115216.00aa0a30@pop.benesconsulting.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 27, 2004 at 11:59:38AM -0700, Leon Bene wrote:
> I am using iptables in Redhats' release (ES) of Linux. In version 7.1 of=
=20
> Redhat (iptables 1.2.1a) it forwarded packets just fine. Now with iptable=
s=20
> 1.2.8 the outbound traffic hangs for about 5 seconds on rapid small packe=
t=20
> transmissions.

iptables-1.2.1a/1.2.8 are the userspace programs only, they never see or
touch a single packet - all happens in the kernel.

Please describe more detailed what particular problem you seem to be
encountering.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDSFxXaXGVTD0i/8RArlVAJ97gVeqtSmJHUC57YpEWa8MfhGWPgCeIqSC
TVF+xUWK9r2pzGTPQ/5TVqM=
=WVjg
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
