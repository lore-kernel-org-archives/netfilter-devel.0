From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] libnetfilter_queue naming problem
Date: Wed, 26 Oct 2005 10:02:05 +0200
Message-ID: <1130313725.14426.4.camel@localhost.localdomain>
References: <1130312714.4872.57.camel@localhost.localdomain>
	<435F370A.6040703@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-JeoTaXTLgwgCZEHw1gXx"
Cc: laforge@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <435F370A.6040703@eurodev.net>
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


--=-JeoTaXTLgwgCZEHw1gXx
Content-Type: multipart/mixed; boundary="=-+WhU/UvwW4rk/Ih/RTuc"


--=-+WhU/UvwW4rk/Ih/RTuc
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le mercredi 26 octobre 2005 =E0 09:58 +0200, Pablo Neira a =E9crit :=20
> Hi Eric,
>=20
> Eric Leblond wrote:
> > I don't like the fact that it uses "struct nfattr* nfa[]" as parameter
> > for high-level function because it is too much linked with the kernel
> > implementation. But I do not have much time to find and propose a more
> > elegant solution. Any idea ?
>=20
> We can provide a higher level interface abstracted from the netlink=20
> sockets, let me see if I can do something.

Great ! I've thought about adding a simple opaque structure which
encapsulate "struct nfattr* nfa[]". That should be enough as high level
functions are already available.

>=20
> In the meantime:
>=20
> > Index: include/libnetfilter_queue/libnfnetlink_queue.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- include/libnetfilter_queue/libnfnetlink_queue.h	(revision 4384)
> > +++ include/libnetfilter_queue/libnfnetlink_queue.h	(working copy)
> > @@ -1,87 +0,0 @@
> > -/* libnfqnetlink.h: Header file for the Netfilter Queue library.
> > Index: src/libnfnetlink_queue.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- src/libnfnetlink_queue.c	(revision 4384)
> > +++ src/libnfnetlink_queue.c	(working copy)
> > @@ -1,375 +0,0 @@
> > -/* libnfqnetlink.c: generic library for access to nf_queue
>=20
> This patch kills libnfnetlink_queue.[h|c], despite that I guess that=20
> your intention is renaming them to libnetfilter_queue.c, correct? ;)

Arghh, looks like svn diff is not working correctly on this point. I've
done a svn rename on the concerned file but the implied add has not be
taken into account by the diff.

I attach a patch with only the modifications to configure.in.

>=20
> cheers,
> Pablo

--=-+WhU/UvwW4rk/Ih/RTuc
Content-Disposition: attachment; filename=libnetfilter_queue-configure.diff
Content-Type: text/x-patch; name=libnetfilter_queue-configure.diff;
	charset=iso-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IGNvbmZpZ3VyZS5pbg0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIGNvbmZpZ3VyZS5pbgkocmV2aXNp
b24gNDM4NCkNCisrKyBjb25maWd1cmUuaW4JKHdvcmtpbmcgY29weSkNCkBAIC0zLDcgKzMsNyBA
QA0KIEFDX0lOSVQNCiBBQ19DQU5PTklDQUxfU1lTVEVNDQogDQotQU1fSU5JVF9BVVRPTUFLRShs
aWJuZm5ldGxpbmtfcXVldWUsIDAuMC4xMCkNCitBTV9JTklUX0FVVE9NQUtFKGxpYm5ldGZpbHRl
cl9xdWV1ZSwgMC4wLjExKQ0KIA0KIEFDX1BST0dfQ0MNCiBBQ19FWEVFWFQNCkBAIC02Miw0ICs2
Miw0IEBADQogDQogDQogZG5sIE91dHB1dCB0aGUgbWFrZWZpbGVzDQotQUNfT1VUUFVUKE1ha2Vm
aWxlIGluY2x1ZGUvTWFrZWZpbGUgaW5jbHVkZS9saWJuZm5ldGxpbmtfcXVldWUvTWFrZWZpbGUg
c3JjL01ha2VmaWxlIHV0aWxzL01ha2VmaWxlKQ0KK0FDX09VVFBVVChNYWtlZmlsZSBpbmNsdWRl
L01ha2VmaWxlIGluY2x1ZGUvbGlibmV0ZmlsdGVyX3F1ZXVlL01ha2VmaWxlIHNyYy9NYWtlZmls
ZSB1dGlscy9NYWtlZmlsZSkNCg==


--=-+WhU/UvwW4rk/Ih/RTuc--

--=-JeoTaXTLgwgCZEHw1gXx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDXzf9nxA7CdMWjzIRAqIOAJ9MTMaNZ3bkTaLEq2aOBdub9BTdjQCfcnrV
8bM+MpjOlwO0XrsQIebglPI=
=JwSA
-----END PGP SIGNATURE-----

--=-JeoTaXTLgwgCZEHw1gXx--
