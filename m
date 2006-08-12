From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] Trivial replace of ip_queue by nfnetlink_queue
	in	nfnetlink_queue code
Date: Sat, 12 Aug 2006 17:21:41 +0200
Message-ID: <1155396101.10172.36.camel@localhost>
References: <1155394240.10172.29.camel@localhost> <44DDEFF2.9010403@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-eFQ58XAtMvfW88N/zNGp"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44DDEFF2.9010403@trash.net>
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


--=-eFQ58XAtMvfW88N/zNGp
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Le samedi 12 ao=FBt 2006 =E0 17:12 +0200, Patrick McHardy a =E9crit :
> Eric Leblond wrote:
> > This patch replace "ip_queue" by "nfnetlink_queue" in nfnetlink_queue.c=
.
>=20
> I already changed it to nf_queue now.

Oups sorry :-/
I thought you want me to replace nf_queue by nfnetlink_queue in my
previous patch.

>  If you want to change it to
> nfnetlink_queue, it should be done in all places.

No, I prefer nf_queue.

> But I think it
> would make more sense to throw most of these printks out.

The one about queue full is really useful to notice performance issue or
problems.

By the way, do you have a public git tree where we could fetch the
latest version of the code ?=20

Best regards,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-eFQ58XAtMvfW88N/zNGp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBE3fIFnxA7CdMWjzIRAq2bAJ4ni3+oqF55CcR6mVd8gYkBQJSUzgCgkogq
6tNqR1jDKjbFhnHHByUYl5M=
=aND+
-----END PGP SIGNATURE-----

--=-eFQ58XAtMvfW88N/zNGp--
