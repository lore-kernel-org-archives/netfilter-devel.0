From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables modification
Date: Thu, 19 Aug 2004 13:47:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819114733.GR3921@sunbeam.de.gnumonks.org>
References: <1091580576.3949.12.camel@ben1.scorpiocc.corp> <20040804144201.GA29167@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHR3sS2kvo5MIJEm"
Cc: Ben Alabaster <ben@scorpiocc.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20040804144201.GA29167@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--xHR3sS2kvo5MIJEm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 04, 2004 at 07:42:01AM -0700, Phil Oester wrote:
> I think you're better off just running a cron every 5 minutes which=20
> flushes then repopulates the rules.  Trying to hack netfilter so
> it does DNS lookups for every rule hit doesn't sound efficient.

neither is it feasible, since you would need to write an in-kernel dns
resolver first ;)

> Phil

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xHR3sS2kvo5MIJEm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJJNVXaXGVTD0i/8RArPpAJ9z0mYRsP50MRd5aTNLqqcr06X5GgCfbwxu
J5qTSsdMsqxoYtGK+HRDbfk=
=3FMs
-----END PGP SIGNATURE-----

--xHR3sS2kvo5MIJEm--
