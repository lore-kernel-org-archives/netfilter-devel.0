From: Harald Welte <laforge@gnumonks.org>
Subject: Re: dstlimit filter on stock 2.4.22
Date: Sun, 30 Nov 2003 21:50:33 +0530
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20031130162033.GM26749@obroa-skai.de.gnumonks.org>
References: <200311252004.33005.timg@tpi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWJEtCrVvH5hpatL"
Cc: linux-net@vger.kernel.org,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-net-owner@vger.kernel.org>
To: Tim Gardner <timg@tpi.com>
Content-Disposition: inline
In-Reply-To: <200311252004.33005.timg@tpi.com>
List-Id: netfilter-devel.vger.kernel.org


--JWJEtCrVvH5hpatL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2003 at 08:04:11PM -0700, Tim Gardner wrote:
> I've been messing with the patch-o-matic/base/dstlimit.patch filter from =
CVS.=20

Hey, cool.  I never made an announcement for that code, but still it
seems to get used ;)

Be warned that although I have written dstlimit (as contract work), I
don't neccessarily agree with what dstlimit does. =20

Ratelimiting of SYN packets (with limit or dstlimit) can only be helpful
in a very small subset of all cases.

In most cases, you will actually make the situation worse if you do any
kind of SYN limiting.  The problem is:  As soon as you hit the
configured limit, you will definitely have a DOS.  And chances are good
that your configured rate will result in a sooner DOS than without the
limit.

The only case where ratlimiting of SYN on a firewall will help is:

- the service[s] you protect can survive a packet-per-second rate _less_
  than the firewall
- you know exactly how many packets-per-second (or syn-per-second) your
  to-be-protected service[s] can handle.

In that particular case, you can create a limit rule that allows a few
packets/syn's less than your service[s] can handle.

The way more common cases is:
- your firewall will not handle a higher pps/sps rate than the
  service[s] you want to protect.  in this case an attacker wil DoS your=20
  firewall independent of any limits set.

> It uses constructs from 2.6 that do not exist in 2.4.=20

please refer to davem's reply.

> Tim Gardner - timg@tpi.com

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--JWJEtCrVvH5hpatL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yhjnXaXGVTD0i/8RAiw8AJ99a7o3AiJD71fGOmQYto+2nA2YYQCffrP0
xVcJxWBnD9IZ3QvxAIunZw8=
=fT26
-----END PGP SIGNATURE-----

--JWJEtCrVvH5hpatL--
