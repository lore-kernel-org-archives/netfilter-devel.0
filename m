From: Christian Hentschel <chentschel@arnet.com.ar>
Subject: Re: [PATCH] nfsim at route del command.
Date: Fri, 06 May 2005 12:34:58 -0300
Message-ID: <1115393698.1847.4.camel@www.l-chr.com.ar>
References: <1114739405.1940.6.camel@www.l-chr.com.ar>
	<20050506112529.GI30482@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-S83he3kxP1Bz3qYNqNoN"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050506112529.GI30482@sunbeam.de.gnumonks.org>
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


--=-S83he3kxP1Bz3qYNqNoN
Content-Type: multipart/mixed; boundary="=-gRjGxrzkmuYKVHbj3r9p"


--=-gRjGxrzkmuYKVHbj3r9p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Yes, sorry for that. I'm quite stupid some times.
=20
There is an extra call to list_del() in tool/route.c at line 186. when
someone's trying to delete a route.=20
ie. route del 192.168.0.0/24

The implementation leaves core/ipv4.c at line 38, the "destruction" of
the route after calling talloc_free().=20
here's that code:=20

static int destroy_route(void *r)
{
	struct ipv4_route *route =3D r;
	list_del(&route->entry);
	return 0;
}
So this extra call leaves wild pointers causing the second call to
segfault.
This patch fixes this segfault, leaving the destruction of the route at
line 38 of core/ipv4.c

Regards
Christian.


On Fri, 2005-05-06 at 13:25 +0200, Harald Welte wrote:
> On Thu, Apr 28, 2005 at 10:50:05PM -0300, Christian Hentschel wrote:
> > This patch fixes segfault at route del command.
>=20
> How is this patch supposed to fix the problem?  AFAICT you no longer
> delete the route from the list, but still free it's data.
>=20
> Please explain.
>=20
--=20
Christian Hentschel <chentschel@arnet.com.ar>

--=-gRjGxrzkmuYKVHbj3r9p
Content-Disposition: attachment; filename=nfsim_route.patch
Content-Type: text/x-patch; name=nfsim_route.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64

SW5kZXg6IHRvb2xzL3JvdXRlLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSB0b29scy9yb3V0ZS5jCShyZXZp
c2lvbiAzODk2KQ0KKysrIHRvb2xzL3JvdXRlLmMJKHdvcmtpbmcgY29weSkNCkBAIC0xODMsNyAr
MTgzLDYgQEANCiAJCQlpZiAocm91dGUtPm5ldHdvcmsgPT0gcjItPm5ldHdvcmsgJiYNCiAJCQkg
ICAgcm91dGUtPm5ldG1hc2sgPT0gcjItPm5ldG1hc2spIHsNCiAJCQkJZm91bmQ9MTsNCi0JCQkJ
bGlzdF9kZWwoJnIyLT5lbnRyeSk7DQogCQkJCXRhbGxvY19mcmVlKHIyKTsNCiAJCQkJbmZzaW1f
bG9nKExPR19VSSwgInJvdXRlIHJlbW92ZWQiKTsNCiAJCQkJYnJlYWs7DQo=


--=-gRjGxrzkmuYKVHbj3r9p--

--=-S83he3kxP1Bz3qYNqNoN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCe46i/jxG54BC3LgRAkG5AJ9zG1vAHR7yRqz+45MD/BA3eBiQWQCglS7z
bp0iOrUWZOqUaaeRGIp0Iyo=
=iEB9
-----END PGP SIGNATURE-----

--=-S83he3kxP1Bz3qYNqNoN--
