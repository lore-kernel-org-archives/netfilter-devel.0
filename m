From: Harald Welte <laforge@netfilter.org>
Subject: Re: SO_ORIGINAL_DST and getsockopt
Date: Sun, 10 Jul 2005 16:13:23 +0200
Message-ID: <20050710141323.GH20465@sunbeam.de.gnumonks.org>
References: <01642EB7E3370B439D58C010BFB4324804ABF0C9@UDCEXMAIL01.us.trendnet.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wFcEkHhPyqONlKAq"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: peter_yen@trendmicro.com
Content-Disposition: inline
In-Reply-To: <01642EB7E3370B439D58C010BFB4324804ABF0C9@UDCEXMAIL01.us.trendnet.org>
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


--wFcEkHhPyqONlKAq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2005 at 06:05:40PM -0700, peter_yen@trendmicro.com wrote:
=20
> I saw some discussions regarding using getsockopt to retrieve the
> original destination=0D
>=20
> address after the packets have been redirected by iptables rules.
> However, I cannot=0D

What do you mean by "I cannot". What's the result of the oepration?

> if(getsockopt(connfd, SOL_IP, SO_ORIGINAL_DST, &oricliaddr, &oriclilen)

looks fine to me.


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wFcEkHhPyqONlKAq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC0S0DXaXGVTD0i/8RAvyAAJ91vgDmlxomrBnfxRqDxKqz2TDv7ACggMKC
riS+TmlVTRGyzYZPaud3XxI=
=hqc3
-----END PGP SIGNATURE-----

--wFcEkHhPyqONlKAq--
