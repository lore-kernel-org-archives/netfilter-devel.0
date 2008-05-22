From: Eric Leblond <eric@inl.fr>
Subject: Re: nlif_open() - nlif_close() - memory leak?
Date: Thu, 22 May 2008 10:07:42 +0200
Message-ID: <20080522080742.GE7436@bayen.regit.org>
References: <200805221053.41058.anton.vazir@gmail.com> <20080522074319.GD7436@bayen.regit.org> <200805221252.41392.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qp4W5+cUSnZs0RIF"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:46945 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763422AbYEVIGW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 04:06:22 -0400
Content-Disposition: inline
In-Reply-To: <200805221252.41392.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--qp4W5+cUSnZs0RIF
Content-Type: multipart/mixed; boundary="GxcwvYAGnODwn7V8"
Content-Disposition: inline


--GxcwvYAGnODwn7V8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 May 22 at 12:52:41 +0500, Anton wrote:
> On Thursday 22 May 2008 12:43, Eric Leblond wrote:
> > Hello,
> >
> > On Thursday, 2008 May 22 at 10:53:40 +0500, Anton wrote:
> > You should not call nlif_open, nlif_close at each
> > resolution:
>=20
> Yes, this is obvious, it was just a quick test.
>=20
> >
> > Information about nlif usage:
> > http://software.inl.fr/trac/wiki/articles/using_nlif
>=20
> Great, thanks!
>=20
> >
> > Anyway, I will investigate to see what's going on. We
> > definitely should not have a memory leak.

The attached patch should fix the memory leak issue. Could you test it ?

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--GxcwvYAGnODwn7V8
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="memleak.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/src/iftable.c b/src/iftable.c
index 7e6172b..a2844fd 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -25,6 +25,8 @@
=20
 #define iftb_log(x, ...)
=20
+#define SIZE_IFHASH 16
+
 struct ifindex_map {
 	struct ifindex_map *next;
=20
@@ -37,7 +39,7 @@ struct ifindex_map {
 };
=20
 struct nlif_handle {
-	struct ifindex_map *ifindex_map[16];
+	struct ifindex_map *ifindex_map[SIZE_IFHASH];
 	struct rtnl_handle *rtnl_handle;
 	struct rtnl_handler ifadd_handler;
 	struct rtnl_handler ifdel_handler;
@@ -255,6 +257,19 @@ err:
 	return NULL;
 }
=20
+static void free_indexmap(struct ifindex_map **indexmap)
+{
+	struct ifindex_map *im, *ima, **imp;
+	int i;
+
+	for (i =3D 0; i < SIZE_IFHASH; i++) {
+		for (ima =3D NULL, imp =3D &(indexmap[i]);=20
+				(im=3D*imp)!=3DNULL; imp =3D &im->next, ima=3Dim) {
+			free(ima);
+		}
+	}
+}
+
 /** Destructor of interface table
  *
  * \param nlif_handle A pointer to a ::nlif_handle created=20
@@ -267,6 +282,7 @@ void nlif_close(struct nlif_handle *h)
 	rtnl_handler_unregister(h->rtnl_handle, &h->ifadd_handler);
 	rtnl_handler_unregister(h->rtnl_handle, &h->ifdel_handler);
 	rtnl_close(h->rtnl_handle);
+	free_indexmap(h->ifindex_map);
 	free(h);
 	h =3D NULL; /* bugtrap */
 }

--GxcwvYAGnODwn7V8--

--qp4W5+cUSnZs0RIF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINSnOnxA7CdMWjzIRAi6hAKCFdVUpMSPl7mQy/U4x5Au4+bv0vQCePzhn
6kZPTZne6xX4B8i6/YTFuGg=
=eVn+
-----END PGP SIGNATURE-----

--qp4W5+cUSnZs0RIF--
