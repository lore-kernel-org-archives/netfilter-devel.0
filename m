From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Mon, 28 May 2007 21:53:11 +0200
Message-ID: <1180381991.6505.46.camel@henriknordstrom.net>
References: <465528CB.4020108@snapgear.com>
	<200705250044.l4P0i3f8007580@toshiba.co.jp>
	<4656342A.5040202@snapgear.com> <4657FBD4.80506@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-A6xA2tm0uDz2LGYh8aD3"
Cc: netfilter-devel@lists.netfilter.org, Philip Craig <philipc@snapgear.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4657FBD4.80506@trash.net>
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


--=-A6xA2tm0uDz2LGYh8aD3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

l=C3=B6r 2007-05-26 klockan 11:20 +0200 skrev Patrick McHardy:

> We can add flags for new features, but not flags that are required to
> be set to behave compatible since that would break iptables userspace
> for old kernels.

But the proposed change is completely transparent to userspace... the
use of the new flags is purely kernel-only and not visible to
userspace..

The drawback is that it reduces the possible new flags which might be
added by two bits, or if put another way reduces the flags field from 8
to 6 bits, leaving only 3 unused flag bits for future flag type
expansions.

But I am a little curious.. how much difference would it yield if simply
the loop was instead changed to terminate on string end instead of
always iterating over the max interface name length..

        for (i =3D 0, ret =3D 0; ((const unsigned long *)ipinfo->outiface_m=
ask)[i] && i < IFNAMSIZ/sizeof(unsigned long); i++) {
		...
        }

instead of

        for (i =3D 0, ret =3D 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
		...
	}

plus a small change to the userspace to zero the mask after the first \0
in the interface name on exact matches.

The userspace only allow exact or prefix matching, so it should be ok to
restrict the compare function to this I think..

Regards
Henrik

--=-A6xA2tm0uDz2LGYh8aD3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARlszIkNPQ5Kbx8daAQIyMwQAkW29gK20KTjGHsrEPWbDepnDv60lBgRz
ZGINTnlJXNK6/nGV3U25YEayewSM4l+GHYhGqgwqBwJOpR+TLu5w3zqzX+0t8S2O
PWZUZL/8p5xaFwBo6HSpdOz8/ESwrMsroPmcJmSXx5ZBR/oVQ39IUvVFJVYHUDZF
ZaiPSjL8oUw=
=txhs
-----END PGP SIGNATURE-----

--=-A6xA2tm0uDz2LGYh8aD3--
