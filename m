From: Harald Welte <laforge@netfilter.org>
Subject: Re: Spurious newline in iptables-save output/policy match
Date: Thu, 19 Aug 2004 11:48:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819094854.GA3921@sunbeam.de.gnumonks.org>
References: <41239EEE.3090908@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0rpW5bEisVBStM29"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
Content-Disposition: inline
In-Reply-To: <41239EEE.3090908@shorewall.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0rpW5bEisVBStM29
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 18, 2004 at 11:24:46AM -0700, Tom Eastep wrote:
=20
> There is an unwarrented "printf("\n") at the end of the static function
> 'save' in libipt_policy.c. This causes output from iptables-save to be
> rejected by a subsequent iptables-restore.

thanks, fixed in CVS.

=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0rpW5bEisVBStM29
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJHeGXaXGVTD0i/8RAmlGAKChoVuJYZyFdGlqsCvNo/qDf3BOVwCdEWp7
Wan9coYC4tfi7LNpUA+IP4U=
=FuKT
-----END PGP SIGNATURE-----

--0rpW5bEisVBStM29--
