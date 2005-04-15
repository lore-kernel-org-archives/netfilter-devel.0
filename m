From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH POM-NG] fix quota on SMP
Date: Fri, 15 Apr 2005 11:26:29 +0200
Message-ID: <20050415092629.GD25433@sunbeam.de.gnumonks.org>
References: <425BE6E8.5040304@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uR47HAPHj0Ivj7e6"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <425BE6E8.5040304@eurodev.net>
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


--uR47HAPHj0Ivj7e6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 12, 2005 at 05:19:04PM +0200, Pablo Neira wrote:
> This patch fixes quota on SMP boxes.
>=20
> o 01-24.patch: For 2.4.x
> o 01-26.patch: For 2.6.x
> o 02kill-ip-discount.patch: quota doesn't count the size of the IP header=
 on=20
> 2.6.x.
> o quota-iptables.patch: iptables requires this patch to fix SMP for quota.
> o x-help: remove `quota is broken on SMP' warning that isn't true anymore.

thanks, applied.

btw: I would appreciate if you would submit all hunks that belong to one
issue (e.g. 01-24, 01-26 and x-help in this example) as one single
patch.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--uR47HAPHj0Ivj7e6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCX4jFXaXGVTD0i/8RAiSxAJ9pPPwH7STInbRafCRjR2LGkmsgVwCgrpO+
IOUTNHca07JKJ6PYMzfUFBM=
=ZdIV
-----END PGP SIGNATURE-----

--uR47HAPHj0Ivj7e6--
