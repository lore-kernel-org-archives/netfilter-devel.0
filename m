From: Eric Leblond <eric@regit.org>
Subject: libipq and mark
Date: Sat, 27 Sep 2003 14:31:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1064665866.2289.33.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HtMGh3/IHUo2D9OETTgf"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-HtMGh3/IHUo2D9OETTgf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I like to know it it's possible to set the mark of a paquet in usermode
using libipq ?
=46rom the doc of lipipq it appears that only the payload can be changed.
If it's really the case, have you an idea of the feasibility and
difficulty to add this in libipq ?

This can be used by NuFW to have a user based mark system ! Thus
enabling to have a per-user bandwith allocation !

BR,
--=20
Eric Leblond
Nufw, Now User Filtering Works (http://www.nufw.org)

--=-HtMGh3/IHUo2D9OETTgf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/dYMKnxA7CdMWjzIRAuc1AJ4lcFHwpJaMvyhj9xggyHXaRQYg1QCfYPgN
vODpwMESbmdAjKE3CAUG3+g=
=TQuJ
-----END PGP SIGNATURE-----

--=-HtMGh3/IHUo2D9OETTgf--
