From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] OSF: pom-ng - linux-2.6.
Date: Wed, 08 Dec 2004 16:43:49 +0300
Message-ID: <1102513429.3363.71.camel@uganda>
References: <1102503533.3363.48.camel@uganda>
	<fa78a99804120805326fed423b@mail.gmail.com>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-1cxbnjfc7C3bU5mj4R2J"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pavel A. Nekrasov" <pnekrasov@gmail.com>
In-Reply-To: <fa78a99804120805326fed423b@mail.gmail.com>
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


--=-1cxbnjfc7C3bU5mj4R2J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2004-12-08 at 14:32 +0100, Pavel A. Nekrasov wrote:
> i got you doing the same.
>=20
> Evgeniy Polyakov wrote:
>=20
> >+      nts =3D netlink_kernel_create(NETLINK_NFLOG, NULL);
>=20
> drivers/w1/w1_int.c:    dev->nls =3D netlink_kernel_create(NETLINK_NFLOG,=
 NULL);
>=20
> NETLINK_NFLOG is used by ipt_ULOG, you can't use that socket because
> you are breaking compatibility. You have to use different sockets,
> call davem and request new ones.

No, ipt_osf used this number forever.
And it was discussed with Harald some time ago.

Allocating new socket number for any new driver that want to communicate
over netlink is badly broken idea.
I've created so called "kernel connector" aka ioctl-ng to solve this
problem,  and this patch is flying around for some time, but until it
is=20
committed we should not break old compatibility issues.

> kind regards,
> Pavel
--=20
        Evgeniy Polyakov

Crash is better than data corruption -- Arthur Grabowski

--=-1cxbnjfc7C3bU5mj4R2J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBBtwUVIKTPhE+8wY0RAk31AKCTc3TYK6/zpXtrGinVGFiS5SaPgQCeM0+N
tRtEB9Xd7EEaD1vh91kfuhw=
=oOun
-----END PGP SIGNATURE-----

--=-1cxbnjfc7C3bU5mj4R2J--
