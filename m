From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix ip_conntrack_helper_pptp build when
	CONFIG_IP_NF_NAT_NEEDED=n
Date: Thu, 3 Nov 2005 10:54:09 +0100
Message-ID: <20051103095409.GY4479@sunbeam.de.gnumonks.org>
References: <1130807635.6630.13.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="06N9xnU2hL237cv1"
Cc: netfilter-devel@lists.netfilter.org, 336431@bugs.debian.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dann frazier <dannf@hp.com>
Content-Disposition: inline
In-Reply-To: <1130807635.6630.13.camel@localhost>
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


--06N9xnU2hL237cv1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 31, 2005 at 06:13:55PM -0700, dann frazier wrote:
> As reported in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D336431,
> ip_conntrack_helper_pptp in 2.6.14 fails to build if
> CONFIG_IP_NF_NAT_NEEDED isn't enabled.  This patch fixes this by
> disabling manipulation of the dir field of ip_conntrack_expect
> structures when full nat isn't configured.  Compile tested only.

Thanks for reporting this bug.   Yasuyuki Kozakai has submitted a
slightly cleaner version, so I'm merging his patch.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--06N9xnU2hL237cv1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDad5BXaXGVTD0i/8RAiu3AKCgOTOZO/2zUWwp949ZiYrX1aWM7QCggng3
MuQqnSAL/2Ycm3fls+XxOBE=
=D2hW
-----END PGP SIGNATURE-----

--06N9xnU2hL237cv1--
