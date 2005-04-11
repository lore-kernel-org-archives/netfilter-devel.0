From: Harald Welte <laforge@netfilter.org>
Subject: Re: ICMP error handling in CLUSTERIP
Date: Mon, 11 Apr 2005 17:03:13 +0200
Message-ID: <20050411150313.GA7510@sunbeam.de.gnumonks.org>
References: <000001c53a8c$d5910290$aa28abc1@Vagabond>
	<20050410205842.GY9155@sunbeam.de.gnumonks.org>
	<1113220795.4330.15.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Cc: Alexander Stieglecker <a.stieglecker@gmx.net>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <1113220795.4330.15.camel@nienna.balabit>
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


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 11, 2005 at 01:59:55PM +0200, KOVACS Krisztian wrote:

>   Harald, I'm afraid the fix you committed to svn isn't perfect (does
> not compile.) Shouldn't that be IP_CT_RELATED instead of
> IP_CT_IS_RELATED?

thanks, fixed.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCWpGxXaXGVTD0i/8RAtmRAJ9VKeEe1Ak6fLtpD9PfWcTasgoJDACgi2ov
HTWxVCehcobQA4UyuC5isOY=
=cV8Z
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
