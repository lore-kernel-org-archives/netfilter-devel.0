From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Very first try: ipt_connrate patch.
Date: Thu, 19 Feb 2004 19:28:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040219182818.GF4797@sunbeam.de.gnumonks.org>
References: <87bro9fiqq.fsf@iki.fi> <20040214201444.GS7756@sunbeam.de.gnumonks.org> <87ptcfahm4.fsf@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nuutti Kotivuori <naked@iki.fi>
Content-Disposition: inline
In-Reply-To: <87ptcfahm4.fsf@iki.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 16, 2004 at 04:22:11AM +0200, Nuutti Kotivuori wrote:
> This is intentional. 'prev' is used to store a jiffies value, as by
> the comment - which is an unsigned long on all platforms I
> believe. 'avgrate' is again something calculated internally in the
> algorithm, and it should be 32 bits to keep the assumptions I make
> valid.

the issue is sparc64, which has 32bit userspace and 64bit kernelspace.
So libipt_XX.c will be compiled with a 32bit unsigned long, and the
kernel with a 64bit unsigned long :(

> > instead of adding it here, please include a .connrate-test file
>=20
> Actually I did - but at some testing phase and due to the contorted
> way debian builds the iptables package, I couldn't get it to
> automatically detect connrate - so I went the easy way on the first
> time. I also wasn't sure if just adding the -test file would be
> enough, but I guess it is.

yes, it is.  The .test file checks against your currently installed
kernel source tree.  if the kernel source doesn't have the connrate
kernel patch applied, then it won't build the libipt_connrate plugin.

> -- Naked

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANQBCXaXGVTD0i/8RAkRTAKCozHTwLkjKgUdgRIX54mTZBlRNCwCgoVTG
WNEWy8Kb0ZCS8PmjUPuZ6EI=
=ny/q
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
